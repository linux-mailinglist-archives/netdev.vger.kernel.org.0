Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DB9433509
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 13:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235364AbhJSLv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 07:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbhJSLvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 07:51:55 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05303C06161C;
        Tue, 19 Oct 2021 04:49:42 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1mcnch-0004Vq-RG; Tue, 19 Oct 2021 13:49:39 +0200
Date:   Tue, 19 Oct 2021 13:49:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Ahern <dsahern@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Eugene Crosser <crosser@average.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
Message-ID: <20211019114939.GD28644@breakpoint.cc>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
 <20211013092235.GA32450@breakpoint.cc>
 <20211015210448.GA5069@breakpoint.cc>
 <378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com>
 <20211018143430.GB28644@breakpoint.cc>
 <a5422062-a0a8-a2bf-f4a8-d57eb7ddc4af@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5422062-a0a8-a2bf-f4a8-d57eb7ddc4af@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> wrote:
> Thanks for the detailed summary and possible solutions.
> 
> NAT/MASQ rules with VRF were not really thought about during
> development; it was not a use case (or use cases) Cumulus or other NOS
> vendors cared about. Community users were popping up fairly early and
> patches would get sent, but no real thought about how to handle both
> sets of rules - VRF device and port devices.
> 
> What about adding an attribute on the VRF device to declare which side
> to take -- rules against the port device or rules against the VRF device
> and control the nf resets based on it?

This would need a way to suppress the NF_HOOK invocation from the
normal IP path.  Any idea on how to do that?  AFAICS there is no way to
get to the vrf device at that point, so no way to detect the toggle.

Or did you mean to only suppress the 2nd conntrack round?

For packets that get forwarded we'd always need to run those in the vrf
context, afaics, because doing an nf_reset() may create a new conntrack
entry (if flow has DNAT, then incoming address has been reversed
already, so it won't match existing REPLY entry in the conntrack table anymore).

For locally generated packets, we could skip conntrack for VRF context
via 'skb->_nfct = UNTRACKED' + nf_reset_ct before xmit to lower device,
and for lower device by eliding the reset entirely.
