Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7746429689B
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 04:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S374802AbgJWCy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 22:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S374798AbgJWCy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Oct 2020 22:54:58 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E898208B6;
        Fri, 23 Oct 2020 02:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603421697;
        bh=X+3xWmkHcvyf8kDxi+w+OcEIqO7qYB09N2fNBMeMGxo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LqlSz6xLJNNuhcCC+en5Ehwh0Gn0DVFRIl0bY9aEE4AjhmWY1oWOILDNmCaEE6Hnq
         pgVjKa/1ZWsXf1KxAf4aA9hwEkiz+wvM14rZhAYOSOD1/+++hM/zgSQuXt8BvwB6nn
         VPh3E10E+V6rY0/oa1nceZBXjsSlmLLp40QEOqrk=
Date:   Thu, 22 Oct 2020 19:54:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "james.jurack@ametek.com" <james.jurack@ametek.com>
Subject: Re: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
 headroom
Message-ID: <20201022195455.09939040@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <AM0PR04MB6754877DC2BBA688F2DC249A961D0@AM0PR04MB6754.eurprd04.prod.outlook.com>
References: <fa12d66e-de52-3e2e-154c-90c775bb4fe4@ametek.com>
        <20201020173605.1173-1-claudiu.manoil@nxp.com>
        <20201021105933.2cfa7176@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AM0PR04MB6754877DC2BBA688F2DC249A961D0@AM0PR04MB6754.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Oct 2020 12:09:00 +0000 Claudiu Manoil wrote:
> >-----Original Message-----
> >From: Jakub Kicinski <kuba@kernel.org>
> >Sent: Wednesday, October 21, 2020 9:00 PM
> >To: Claudiu Manoil <claudiu.manoil@nxp.com>
> >Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
> >james.jurack@ametek.com
> >Subject: Re: [PATCH net] gianfar: Account for Tx PTP timestamp in the skb
> >headroom
> >
> >On Tue, 20 Oct 2020 20:36:05 +0300 Claudiu Manoil wrote:  
> [...]
> >>
> >>  	if (dev->features & NETIF_F_IP_CSUM ||
> >>  	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
> >> -		dev->needed_headroom = GMAC_FCB_LEN;
> >> +		dev->needed_headroom = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
> >>
> >>  	/* Initializing some of the rx/tx queue level parameters */
> >>  	for (i = 0; i < priv->num_tx_queues; i++) {  
> >
> >Claudiu, I think this may be papering over the real issue.
> >needed_headroom is best effort, if you were seeing crashes
> >the missing checks for skb being the right geometry are still
> >out there, they just not get hit in the case needed_headroom
> >is respected.
> >
> >So updating needed_headroom is definitely fine, but the cause of
> >crashes has to be found first.  
> 
> I agree Jakub, but this is a simple (and old) ring based driver. So the
> question is what checks or operations may be missing or be wrong
> in the below sequence of operations made on the skb designated for
> timestamping?
> As hinted in the commit description, the code is not crashing when
> multiple TCP streams are transmitted alone (skb frags manipulation was
> omitted for brevity below, and this is a well exercised path known to work),
> but only crashes when multiple TCP stream are run concurrently
> with a PTP Tx packet flow taking the skb_realloc_headroom() path.
> I don't find other drivers doing skb_realloc_headroom() for PTP packets,
> so maybe is this an untested use case of skb usage?
> 
> init:
> dev->needed_headroom = GMAC_FCB_LEN;
> 
> start_xmit:
> netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
> {
> 	do_tstamp = (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> 		    priv->hwts_tx_en;
> 	fcb_len = GMAC_FCB_LEN; // can also be 0
> 	if (do_tstamp)
> 		fcb_len = GMAC_FCB_LEN + GMAC_TXPAL_LEN;
> 
> 	if (skb_headroom(skb) < fcb_len) {
> 		skb_new = skb_realloc_headroom(skb, fcb_len);
> 		if (!skb_new) {
> 			dev_kfree_skb_any(skb);
> 			return NETDEV_TX_OK;
> 		}
> 		if (skb->sk)
> 			skb_set_owner_w(skb_new, skb->sk);
> 		dev_consume_skb_any(skb);
> 		skb = skb_new;
> 	}

Try replacing this if () with skb_cow_head(). The skbs you're getting
are probably cloned.

> 	[...]
> 	if (do_tstamp)
> 		skb_push(skb, GMAC_TXPAL_LEN);
> 	if (fcb_len)
> 		skb_push(skb, GMAC_FCB_LEN);
> 
> 	// dma map and send the frame
> }
> 
> Tx napi (xmit completion):
> gfar_clean_tx_ring()
> {
> 	do_tstamp = (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
> 		    priv->hwts_tx_en;
> 	// dma unmap
> 	if (do_tstamp) {
> 		struct skb_shared_hwtstamps shhwtstamps;
> 
> 		// read timestamp from skb->data and write it to shhwtstamps
> 		skb_pull(skb, GMAC_FCB_LEN + GMAC_TXPAL_LEN);
> 		skb_tstamp_tx(skb, &shhwtstamps);
> 	}
> 	dev_kfree_skb_any(skb);
> }
> 

