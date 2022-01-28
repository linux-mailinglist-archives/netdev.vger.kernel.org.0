Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB9849FCD7
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:31:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349549AbiA1PbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:31:18 -0500
Received: from mga06.intel.com ([134.134.136.31]:4991 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244953AbiA1PbP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jan 2022 10:31:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643383875; x=1674919875;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=qKfdRlbgRRkrQqDhWpRoGV1t4Jcb2HrJkvZo0CYDXSc=;
  b=NU+m6sWbYi13//LV1tdS3JJmUqscUBpPy76ySCsGKSoeAyZKcj/J95/R
   ozWjGSan+3BGLpWa84vVfD73421gCYQL7rrDp5PZLh2cXpTYNGSN51ykD
   g2HON4Ir3QdBsgwAEVoKsqulUQgdq7QjlXbea4VfuurxTnCHDht4tk+Lu
   D3/lF+NKY5r3l/YkyHCN9nV7KmB2SOPO9WrW1OfnZJeVVF39CLE+0K9OI
   IdDG+wSkPmGK5Z5KTN+C0uVjYf8jtL6th++VarzVdLg/TNv1L6qRnQ2en
   qmW4ljGn4wuCdn7k8m7IbT2bJ1F+z1YUEN1ZE+0sFVGXBpkafWel4hb5j
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10240"; a="307855125"
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="307855125"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2022 07:31:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,324,1635231600"; 
   d="scan'208";a="697121006"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 28 Jan 2022 07:31:14 -0800
Date:   Fri, 28 Jan 2022 16:31:13 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     "Maurice Baijens (Ellips B.V.)" <maurice.baijens@ellips.com>
Cc:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ixgbe driver link down causes 100% load in ksoftirqd/x
Message-ID: <YfQMQWsFqCIPBBqO@boxer>
References: <VI1PR02MB4142A638EC38107B262DB32F885A9@VI1PR02MB4142.eurprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR02MB4142A638EC38107B262DB32F885A9@VI1PR02MB4142.eurprd02.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 20, 2022 at 09:23:06AM +0000, Maurice Baijens (Ellips B.V.) wrote:
> Hello,
> 
> 
> I have an issue with the ixgbe driver and X550Tx network adapter.
> When I disconnect the network cable I end up with 100% load in ksoftirqd/x. I am running the adapter in
> xdp mode (XDP_FLAGS_DRV_MODE). Problem seen in linux kernel 5.15.x and also 5.16.0+ (head).

Hello,

a stupid question - why do you disconnect the cable when running traffic? :)
If you plug this back in then what happens?

> 
> I traced the problem down to function ixgbe_xmit_zc in ixgbe_xsk.c:
> 
> if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
>     !netif_carrier_ok(xdp_ring->netdev)) {
>             work_done = false;
>             break;
> }

This was done in commit c685c69fba71 ("ixgbe: don't do any AF_XDP
zero-copy transmit if netif is not OK") - it was addressing the transient
state when configuring the xsk pool on particular queue pair.

> 
> This function is called from ixgbe_poll() function via ixgbe_clean_xdp_tx_irq(). It sets
> work_done to false if netif_carrier_ok() returns false (so if link is down). Because work_done
> is always false, ixgbe_poll keeps on polling forever.
> 
> I made a fix by checking link in ixgbe_poll() function and if no link exiting polling mode:
> 
> /* If all work not completed, return budget and keep polling */
> if ((!clean_complete) && netif_carrier_ok(adapter->netdev))
>             return budget;

Not sure about the correctness of this. Question is how should we act for
link down - should we say that we are done with processing or should we
wait until the link gets back?

Instead of setting the work_done to false immediately for
!netif_carrier_ok(), I'd rather break out the checks that are currently
combined into the single statement, something like this:

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index b3fd8e5cd85b..6a5e9cf6b5da 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -390,12 +390,14 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	u32 cmd_type;
 
 	while (budget-- > 0) {
-		if (unlikely(!ixgbe_desc_unused(xdp_ring)) ||
-		    !netif_carrier_ok(xdp_ring->netdev)) {
+		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
 			work_done = false;
 			break;
 		}
 
+		if (!netif_carrier_ok(xdp_ring->netdev))
+			break;
+
 		if (!xsk_tx_peek_desc(pool, &desc))
 			break;


> 
> This is probably fine for our application as we only run in xdpdrv mode, however I am not sure this

By xdpdrv I would understand that you're running XDP in standard native
mode, however you refer to the AF_XDP Zero Copy implementation in the
driver. But I don't think it changes anything in this thread.

In the end I see some outstanding issues with ixgbe_xmit_zc(), so this
probably might need some attention.

Thanks!
Maciej

> is the correct way to fix this issue and the behaviour of the normal skb mode operation is 
> also affected by my fix.
> 
> So hopefully my observations are correct and someone here can fix the issue and push it upstream.
> 
> 
> Best regards,
> 	Maurice Baijens
