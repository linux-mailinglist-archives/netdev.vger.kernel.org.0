Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD32A42C0C6
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 14:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhJMNAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 09:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbhJMNAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 09:00:33 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FDEC061570;
        Wed, 13 Oct 2021 05:58:30 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1madpz-00055V-LO; Wed, 13 Oct 2021 14:58:27 +0200
Date:   Wed, 13 Oct 2021 14:58:27 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
Message-ID: <20211013125827.GB32450@breakpoint.cc>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
 <20211013122843.wxj7jtyzifwng3j4@kgollan-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211013122843.wxj7jtyzifwng3j4@kgollan-pc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lahav Schlesinger <lschlesinger@drivenets.com> wrote:
> The call to nf_reset_ct() I added was to match the existing call in the
> egress flow, which I didn't want to change in order to not break
> existing behaviour (which I unintentionally still did :-)).
> 
> Seems like any combination of calling nf_reset_ct() will lead to
> something breaking. So continuing on what Florian suggested, another
> possibility is to make the calls to nf_reset_ct() in both ingress and egress
> flow configurable (procfs or new flags to RTM_NEWLINK).
> 
> One benefit of this is that disabling nf_reset_ct() on the egress flow will
> mean no port SNAT will take place when SNAT rule is installed on a VRF
> (as I described in my original commit), which can break applications
> that depend on using a specific source port.

Looking at the original change, eb63ecc1706b3e094d0f57438b6c2067cfc299f2
"net: vrf: Drop conntrack data after pass through VRF device on Tx",
I wonder if thats not the real cause of the problem.

=========================
Locally originated traffic in a VRF fails in the presence of a POSTROUTING
rule. For example,

$ iptables -t nat -A POSTROUTING -s 11.1.1.0/24  -j
MASQUERADE
$ ping -I red -c1 11.1.1.3
ping: Warning: source address might
be selected on device other than red.
PING 11.1.1.3 (11.1.1.3)
from 11.1.1.2 red: 56(84) bytes of data.
ping: sendmsg: Operation not permitted
=========================

I think we first need selftest scripts that re-creates the three scenarios
the one reported by Eugene, the one outlined above and the double-PAT one Lahav
fixed before any code changes are tested.

Its tempting to just change the nf_ct_reset() done on egress to be
conditional on the ct->status snat bit & drop support for double-snat.

Given Lahavs patch, double-snat probably never worked to begin with?
