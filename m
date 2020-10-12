Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E699728B1B6
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 11:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729424AbgJLJkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 05:40:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726104AbgJLJkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 05:40:10 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A66C0613CE;
        Mon, 12 Oct 2020 02:40:10 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1kRuJH-0002Xh-Vl; Mon, 12 Oct 2020 11:40:04 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.94)
        (envelope-from <laforge@gnumonks.org>)
        id 1kRuI7-004DOg-CW; Mon, 12 Oct 2020 11:38:51 +0200
Date:   Mon, 12 Oct 2020 11:38:51 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Paul Moore <paul@paul-moore.com>
Cc:     pablo@netfilter.org,
        Richard Haines <richard_c_haines@btinternet.com>,
        selinux@vger.kernel.org, linux-security-module@vger.kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH 3/3] selinux: Add SELinux GTP support
Message-ID: <20201012093851.GF947663@nataraja>
References: <20200930094934.32144-1-richard_c_haines@btinternet.com>
 <20200930094934.32144-4-richard_c_haines@btinternet.com>
 <20200930110153.GT3871@nataraja>
 <33cf57c9599842247c45c92aa22468ec89f7ba64.camel@btinternet.com>
 <20200930133847.GD238904@nataraja>
 <CAHC9VhT5HahBhow0RzWHs1yAh5qQw2dZ-3vgJv5GuyFWrXau1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhT5HahBhow0RzWHs1yAh5qQw2dZ-3vgJv5GuyFWrXau1A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paul,

On Sun, Oct 11, 2020 at 10:09:11PM -0400, Paul Moore wrote:
> Harald, Pablo - I know you both suggested taking a slow iterative
> approach to merging functionality, perhaps you could also help those
> of us on the SELinux side better understand some of the common GTP use
> cases?

There really only is one use case for this code:  The GGSN or P-GW function
in the 3GPP network architecture.  There are open source implementations
like OsmoGGSN and (at least older/previos versions) of ergw, but also
non-FOSS-but-shared-source (like OpenAirInterface) and proprietary
software that use the existing kernel GTP for that.

In a GGSN (2G/3G) or P-GW (4G), you have a control plane instance
talking a control plane protocol GTP-C (GTPv1-C or GTPv2-C) with other
elements in the network, such as the SGSN (2G/3G) or S-GW (4G)

This control plane instance will then talk to the user plane instance
(which is, in the case of the kernel GTP module, netlink) to crate PDP
contexts (2G/3G) or "barers" (4G).

Those PDP contexts / bearers are constantly being created, modified and
torn down.  Creation happens at the time your modern phone attaches to
the network (once you have "mobile data" enabled).  Modification happens
when you start roaming around the country / coverage area as you change
between larger regions.  Deletion happens once you disable "mobile data'
or go into airplane mode.

The kernel GTP "tun" device typically represents an "APN", i.e. one
specific IP network your phones/modems want to attach to.  There could be
multiple in parallel (e.g. public internet, private operator network for
VoLTE, company-private networks).

So you have one tun device per APN which is mostly static configuration,
stable for months, years, ...  and then you have the hightly volatile
PDP contexts / bearers within each of those APN.  That's why I was
hinting from a security policy point of view, it makes sense to separate
those two, as one only happens at system boot / application start time,
and the other happens at any point during runtime of your GGSN/PGW.

If you want to see how that looks on the wire, check the OsmoGGSN
automatic test suite, where every test case generates a pcap file:
overview at https://jenkins.osmocom.org/jenkins/view/TTCN3/job/ttcn3-ggsn-test/
actual artefacts including per-test pcap files:
https://jenkins.osmocom.org/jenkins/view/TTCN3/job/ttcn3-ggsn-test/lastSuccessfulBuild/artifact/logs/ggsn-tester/
specifically, if you open
https://jenkins.osmocom.org/jenkins/view/TTCN3/job/ttcn3-ggsn-test/lastSuccessfulBuild/artifact/logs/ggsn-tester/GGSN_Tests.TC_pdp6_act_deact_gtpu_access.pcap.gz
in wirehark and filter on 'gtp', you will see the GTP-C traffic on udp
port 2123, and the GTP-U traffic on UDP port 2152.  This second part is
where you would use the kernel-GTP-U implementation to avoid the
kernel-userspace-kernel roundtrip for every user IP packet.

There are many other use cases for GTP in general in other network
elements such as a S-GW (which basically acts as a proxy for GTP-U), but
those are not implemented in the existing Linux kernel GTP module.

I think OsmoGGSN is about the most simple to understand user out there,
due to its very limited code size.  Check
https://git.osmocom.org/osmo-ggsn/tree/lib/gtp-kernel.c for the libgtpnl
interface and https://git.osmocom.org/osmo-ggsn/tree/ggsn/ggsn.c for the
hearth of the logic, including the calls to the gtp_kernel_tunnel_*() API.

Hope this helps,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
