Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 096214D38A1
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 19:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235143AbiCISVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 13:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbiCISVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 13:21:15 -0500
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5D8639A
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 10:20:15 -0800 (PST)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1nS0uv-001HcT-ML; Wed, 09 Mar 2022 19:20:09 +0100
Received: from laforge by localhost.localdomain with local (Exim 4.95)
        (envelope-from <laforge@gnumonks.org>)
        id 1nS0rC-008cd5-Ax;
        Wed, 09 Mar 2022 19:16:18 +0100
Date:   Wed, 9 Mar 2022 19:16:18 +0100
From:   Harald Welte <laforge@gnumonks.org>
To:     "Drewek, Wojciech" <wojciech.drewek@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "michal.swiatkowski@linux.intel.com" 
        <michal.swiatkowski@linux.intel.com>,
        Marcin Szycik <marcin.szycik@linux.intel.com>
Subject: Re: PFCP support in kernel
Message-ID: <Yiju8kbN87kROucg@nataraja>
References: <MW4PR11MB577600AC075530F7C3D2F06DFD0A9@MW4PR11MB5776.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB577600AC075530F7C3D2F06DFD0A9@MW4PR11MB5776.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wojciech,

On Wed, Mar 09, 2022 at 12:27:01PM +0000, Drewek, Wojciech wrote:
> First of all I want to thank you for your revision of our GTP changes,
> we've learned a lot from your comments.

Happy to help!

> So, as you may know our changes were focused around implementing offload of GTP traffic.

Of course, that was what the kernel GTP driver always was about.
Unfortunately it didn't receive a lot of love from the telecom industry,
and hence it is stuck in "2G/3G land", i.e. at a time before the EPS
with its dedicated bearers.  So you cannot use it for IMS/VoLTE, for
example, as it can only match on the source IP address and doesn't have
the capability of using packet classification to put packets in
different tunnels based on [inner IP] port numbers, etc.

> We wanted to introduce a consistent solution so we followed the approach used for geneve/vxlan.
> In general this approach looks like that:
> - create tunnel device (geneve/vxlan/GTP)
> - use that device in tc filter command
> - based on the type of the device used in tc filter, our driver knows what traffic should be offloaded

I'm sorry, I have very limited insight into geneve/vxlan.  It may
be of interest to you that within Osmocom we are currently implementing
a UPF that uses nftables as the backend.  The UPF runs in userspace,
handles a minimal subset of PFCP (no qos/shaping, for example), and then
installs rules into nftables to perform packet matching and
manipulation.  Contrary to the old kernel GTP driver, this approach is
more flexible as it can also cover the TEID mapping case which you find
at SGSN/S-GW or in roaming hubs.  We currently are just about to
complete a prof-of-concept of that.

> Going to the point, now we want to do the same with PFCP. 
> The question is: does it even make sense to create PFCP device and
> parse PFCP messages in kernel space?

I don't think so.  IMHO, PFCP is a rather complex prootocol and it
should be handled in a userspace program, and that userspace program can
then install whatever kernel configuration - whether you want to use
nftables, or tc, or ebpf, or whatever other old or new subsystem in the
kernel network stack.

> My understanding is that PFCP is some kind of equivalent of GTP-C and since GTP-C was purposely not
> implemented in the kernel I feel like PFCP wouldn't fit there either.

I'm sorry, but PFCP is not a replacement of GTP-C.  It serves a rather
different purpose, i.e. to act as protocol between control and user
plane.  GTP-C is control plane, GTP-U is user plane.  PFCP is used in
between the control and user plane entities to configure the user plane.
It's purpose is primarily to be able to mix and match control plane
implementations with user plane implementations. - and to be able to
reuse the same user plane implementation from multiple different network
elements,  like SGW, PGW, HNBGW, roaming hubs, ...

On an abstract / architectural level, PFCP can be compared a bit to
NETLINK:  A protocol between the control plane (linux userspace, routing
daemons, etc.) and the data plane (kernel network stack).

Not sure if there is anything new in it for you, but a while ago in the
osmocom developer call covered CUPS, see the following video recording:
https://media.ccc.de/v/osmodevcall-20211125-laforge-cups-pfcp

> Lastly, if you are wrong person to ask such question then I'm sorry.
> Maybe you know someone else who could help us?

I'm a bit overloaded, but happy to help as far as time permits.

Regards,
	Harald

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
