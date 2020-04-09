Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67B61A3A6E
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgDITSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:18:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:55882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726632AbgDITSL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 15:18:11 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9D7F206F5;
        Thu,  9 Apr 2020 19:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586459892;
        bh=yP2d2e1n+GwPcjoxvQGwUTVuQq6EPdlhx4w3UrWLvNg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Bnm9mrsT4PoTgnq+h7BSHcYMLSw2oBVBrq0w5BOw79A/ZZujiQDh+UiNeSFTbSv85
         r9y/ruockZXnOH2LQlN9ziufDA8e+d4t5kNo4TCcXgzX0P5dHyf18StwAaNoV3elfU
         1rpWVIXg6s5KXURrdApkIn4K60ltdxar7ZZoWtew=
Date:   Thu, 9 Apr 2020 12:18:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Christian Deacon <gamemann@gflclan.com>, bpf@vger.kernel.org,
        aelior@marvell.com, skalluru@marvell.com, netdev@vger.kernel.org
Subject: Re: TC BPF Program Crashing With Bnx2x Drivers
Message-ID: <20200409121810.26ad70aa@kicinski-fedora-PC1C0HJN>
In-Reply-To: <54d3af61-8f00-6f65-23a4-0f1d5a9aba8e@iogearbox.net>
References: <853f67f9-6713-a354-07f7-513d654ede91@gflclan.com>
        <c3c44050-132e-44f7-1611-95d30b0b4b47@iogearbox.net>
        <0a96d4ee-e875-e89c-e6bb-e6b62061abdd@gflclan.com>
        <54d3af61-8f00-6f65-23a4-0f1d5a9aba8e@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 01:57:42 +0200 Daniel Borkmann wrote:
> On 4/9/20 1:30 AM, Christian Deacon wrote:
> > Hey Daniel,
> > 
> > 
> > Thank you for your response and I'm glad I'm in the correct area!
> > 
> > 
> > When the individual ran:
> > 
> > 
> > ```
> > 
> > ethtool -K eth0 tso off
> > 
> > ```
> > 
> > 
> > The program started operating without crashing. It has been around 20 minutes so far and no crash. Therefore, I'd assume that stopped the crashing considering it usually crashed 20 - 30 seconds after starting the program each time beforehand. I'm not entirely sure what TSO does with this network driver, but I'll try doing some research.  
> 
> Yep, don't think it should crash anymore after you turned it off and
> it survived since then. ;) I presume GSO is still on in your case,
> right (check via `ethtool -k eth0`)?
> 
> > I was suspecting it may be the 'bpf_skb_adjust_room()' function as
> > well since I'm using a mode that was implemented in later kernels.
> > This function removes the outer IP header in my program from the
> > outgoing IPIP packet. I'm not sure what would be causing the
> > crashing, though.  
> 
> Probably bnx2x folks might be able to help but as mentioned looks
> like the tso handling in there has an issue with the ipip which leads
> to the nic hang eventually.

IMHO this is not a bnx2x problem. The drivers should not have to
re-validate GSO flags..

Let's see if I get this right. We have an IPinIP encap, IPXIP4 GSO skb
comes down and TC bpf pulls the outer header off, but the gso flags
remain unchanged. The driver then sees IPXIP4 GSO but there are no
headers so it implodes. Is this correct?

And we have the ability to add the right gso flags for encap, not decap
(bpf_skb_net_grow() vs bpf_skb_net_shrink()).
