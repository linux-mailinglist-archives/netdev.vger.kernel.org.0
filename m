Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8251048BDC1
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 04:49:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350494AbiALDtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 22:49:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51156 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiALDtv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 22:49:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B95B2617D6
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 03:49:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3CFC36AE5;
        Wed, 12 Jan 2022 03:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641959390;
        bh=nbCyDX0TWvzzfSZfmovAPrvN3rYM2pdboW63svHrpl8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MmRKs8kFjvS4GIg1fsheO3HStUVze6iw2A73croYNE733wHxv7TMqPxX3sfcoUqFB
         WOhEGmuAsG4XT3YwG53AIwmUAEO7qrXwvbPBHOZvTy2NVzsZAhZWMADksSb9VTStYZ
         FYoVTDjqCiyjIoEhUq1Mjgz6jYVLrVhh4hOf/5ch3KGIcvozm/S9kZ+OVbaQ9akpmq
         yfSdL8/0Ih6m9ZPpPt938Qji2LEbA3yQ9OCkZcYsPvYtWV0wm/ECK5Fnobxt5YEk4d
         p1B2bkIH5YOqPv1aOp9giwf22JjfXU2LTLk8avWSnkBqoxfNS7oarg5aAL3FfD/tTv
         cSzGvZOwH2GmA==
Date:   Tue, 11 Jan 2022 19:49:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, radhey.shyam.pandey@xilinx.com,
        davem@davemloft.net
Subject: Re: [PATCH net 6/7] net: axienet: fix for TX busy handling
Message-ID: <20220111194948.056c7211@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111211358.2699350-7-robert.hancock@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
        <20220111211358.2699350-7-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 15:13:57 -0600 Robert Hancock wrote:
> We should be avoiding returning NETDEV_TX_BUSY from ndo_start_xmit in
> normal cases. Move the main check for a full TX ring to the end of the
> function so that we stop the queue after the last available space is used
> up, and only wake up the queue if enough space is available for a full
> maximally fragmented packet. Print a warning if there is insufficient
> space at the start of start_xmit, since this should no longer happen.
> 
> Fixes: 8a3b7a252dca9 ("drivers/net/ethernet/xilinx: added Xilinx AXI Ethernet driver")
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Feels a little more like an optimization than strictly a fix.
Can we apply this and the following patch to net-next in two
week's time? It's not too much of a stretch to take it in now
if it's a bit convenience but I don't think the Fixes tags should 
stay.

> -		netif_wake_queue(ndev);
> +		netdev_warn(ndev, "TX ring unexpectedly full\n");

Probably wise to make this netdev_warn_once() or at least rate limit it.

> +		return NETDEV_TX_BUSY;
>  	}
>  
>  	if (skb->ip_summed == CHECKSUM_PARTIAL) {

