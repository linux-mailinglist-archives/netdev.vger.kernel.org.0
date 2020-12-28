Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0795A2E6C3D
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 00:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730458AbgL1Wzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 17:55:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:55820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729630AbgL1WYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Dec 2020 17:24:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76BAE20829;
        Mon, 28 Dec 2020 22:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609194252;
        bh=BRLRmoc86o/lCtC8L20RHhYC6lNGCKS1C8CieN5brmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=osxvvUn2xazBLXZrNSnH+KTDzibEOLboMXSoDaCx/Aj70xHxif3gpup542baiCHy3
         s3YKsYr+2UwJUtr3ZGbmHzT5OD1bSVHRnU5Z8sXATK3EszopFycgxUwiwc0IUoJjRs
         VgBobkOZWR80QCNHHI7RT9CTP6bbFIzOiRTuBAspn7IA5C+nV8jLdAUMcMj3Q/l8F3
         VUI8aeMDLdKFLO/MHrXUb03KF5MNnHBxf0VK1MegavG3hOnormgifIUczRtRMqxeM8
         bck/U4152Cz4FWjZkKfd2QlmIG5OAD7BEE6mTNgEGPbKSrVZqPr2w4YRrk53sME6d8
         +MdEffeSYsYwA==
Date:   Mon, 28 Dec 2020 14:24:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     netdev@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net 1/2] net: mrp: fix definitions of MRP test packets
Message-ID: <20201228142411.1c752b2e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
References: <20201223144533.4145-1-rasmus.villemoes@prevas.dk>
        <20201223144533.4145-2-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 15:45:32 +0100 Rasmus Villemoes wrote:
> Wireshark says that the MRP test packets cannot be decoded - and the
> reason for that is that there's a two-byte hole filled with garbage
> between the "transitions" and "timestamp" members.
> 
> So Wireshark decodes the two garbage bytes and the top two bytes of
> the timestamp written by the kernel as the timestamp value (which thus
> fluctuates wildly), and interprets the lower two bytes of the
> timestamp as a new (type, length) pair, which is of course broken.
> 
> While my copy of the MRP standard is still under way [*], I cannot
> imagine the standard specifying a two-byte hole here, and whoever
> wrote the Wireshark decoding code seems to agree with that.
> 
> The struct definitions live under include/uapi/, but they are not
> really part of any kernel<->userspace API/ABI, so fixing the
> definitions by adding the packed attribute should not cause any
> compatibility issues.
> 
> The remaining on-the-wire packet formats likely also don't contain
> holes, but pahole and manual inspection says the current definitions
> suffice. So adding the packed attribute to those is not strictly
> needed, but might be done for good measure.
> 
> [*] I will never understand how something hidden behind a +1000$
> paywall can be called a standard.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
> ---
>  include/uapi/linux/mrp_bridge.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/mrp_bridge.h b/include/uapi/linux/mrp_bridge.h
> index 6aeb13ef0b1e..d1d0cf65916d 100644
> --- a/include/uapi/linux/mrp_bridge.h
> +++ b/include/uapi/linux/mrp_bridge.h
> @@ -96,7 +96,7 @@ struct br_mrp_ring_test_hdr {
>  	__be16 state;
>  	__be16 transitions;
>  	__be32 timestamp;
> -};
> +} __attribute__((__packed__));
>  
>  struct br_mrp_ring_topo_hdr {
>  	__be16 prio;
> @@ -141,7 +141,7 @@ struct br_mrp_in_test_hdr {
>  	__be16 state;
>  	__be16 transitions;
>  	__be32 timestamp;
> -};
> +} __attribute__((__packed__));
>  
>  struct br_mrp_in_topo_hdr {
>  	__u8 sa[ETH_ALEN];

Can we use this opportunity to move the definitions of these structures
out of the uAPI to a normal kernel header?
