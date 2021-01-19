Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6942FBF39
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 19:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729888AbhASS21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 13:28:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:48616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388721AbhASS1e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 13:27:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16610238E2;
        Tue, 19 Jan 2021 17:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611078321;
        bh=9UBi/msyPHQZCmsjTo0fEYHjoK6YoBp5WsNfbH0M4qg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=sTOv4wJ4KHa+QO6F3+qYhfEERh1cWXzWX0LvLM6yshvS6D3cHeX/YX7IAfkJ4z7Rp
         DP/UaR7SNTdY4QC6NQOFgRm2Dv0rx9PjFRcKrf/s7LFvA6d9VK7THxn8d8bxxNh+kb
         ZtGgoTD89xt/S8TYhBPYj+oVRA/ZTyIYoVBxgGIbL8nAzHfGWaKqvVQjBzM/C8nRq2
         U+83D7vVY5armV7lDgIOUukotdx3MyikZ07uQTQYjKY9JQt2DGGAareiAyHlnFgJKX
         8hfJUlrHgjFdueBp4bQozoUEDVceeX1wHEnUpvpUqlEmxLj+8Z35WMwawowIaKJhK1
         WweoHa54QgUVg==
Date:   Tue, 19 Jan 2021 09:45:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net: mrp: fix definitions of MRP test packets
Message-ID: <20210119094516.723bce6c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <50d2a1b0-c7b5-cd12-e288-977fbfdea104@prevas.dk>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
        <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
        <20201228142411.1c752b2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <50d2a1b0-c7b5-cd12-e288-977fbfdea104@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 19 Jan 2021 16:42:14 +0100 Rasmus Villemoes wrote:
> On 28/12/2020 23.24, Jakub Kicinski wrote:
> > On Wed, 23 Dec 2020 15:45:32 +0100 Rasmus Villemoes wrote:  
> >> Wireshark says that the MRP test packets cannot be decoded - and the
> >> reason for that is that there's a two-byte hole filled with garbage
> >> between the "transitions" and "timestamp" members.
> >>
> >> So Wireshark decodes the two garbage bytes and the top two bytes of
> >> the timestamp written by the kernel as the timestamp value (which thus
> >> fluctuates wildly), and interprets the lower two bytes of the
> >> timestamp as a new (type, length) pair, which is of course broken.
> >>
> >> While my copy of the MRP standard is still under way [*], I cannot
> >> imagine the standard specifying a two-byte hole here, and whoever
> >> wrote the Wireshark decoding code seems to agree with that.
> >>
> >> The struct definitions live under include/uapi/, but they are not
> >> really part of any kernel<->userspace API/ABI, so fixing the
> >> definitions by adding the packed attribute should not cause any
> >> compatibility issues.
> >>
> >> The remaining on-the-wire packet formats likely also don't contain
> >> holes, but pahole and manual inspection says the current definitions
> >> suffice. So adding the packed attribute to those is not strictly
> >> needed, but might be done for good measure.
> >>
> >> [*] I will never understand how something hidden behind a +1000$
> >> paywall can be called a standard.
> >>
> >> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> >> ---
> >>  include/uapi/linux/mrp_bridge.h | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
> >> index 6aeb13ef0b1e..d1d0cf65916d 100644
> >> --- a/include/uapi/linux/mrp_bridge.h
> >> +++ b/include/uapi/linux/mrp_bridge.h
> >> @@ -96,7 +96,7 @@ struct br_mrp_ring_test_hdr {
> >>  	__be16 state;
> >>  	__be16 transitions;
> >>  	__be32 timestamp;
> >> -};
> >> +} __attribute__((__packed__));
> >>  
> >>  struct br_mrp_ring_topo_hdr {
> >>  	__be16 prio;
> >> @@ -141,7 +141,7 @@ struct br_mrp_in_test_hdr {
> >>  	__be16 state;
> >>  	__be16 transitions;
> >>  	__be32 timestamp;
> >> -};
> >> +} __attribute__((__packed__));
> >>  
> >>  struct br_mrp_in_topo_hdr {
> >>  	__u8 sa[ETH_ALEN];  
> > 
> > Can we use this opportunity to move the definitions of these structures
> > out of the uAPI to a normal kernel header?
> 
> Jakub, can we apply this patch to net, then later move the definitions
> out of uapi (and deleting the unused ones in the process)?

This has been lost in the patchwork archives already, we'll need a
fresh posting anyway. Why not do the move as a part of the same series?
Doesn't seems like much work, unless I'm missing something..
