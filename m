Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A102584AF
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 02:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgIAAPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 20:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgIAAO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 20:14:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEC0C061573
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 17:14:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E85951298592B;
        Mon, 31 Aug 2020 16:58:10 -0700 (PDT)
Date:   Mon, 31 Aug 2020 17:14:54 -0700 (PDT)
Message-Id: <20200831.171454.2235150331629306394.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org, neel@pensando.io
Subject: Re: [PATCH net-next 1/5] ionic: clean up page handling code
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200831233558.71417-2-snelson@pensando.io>
References: <20200831233558.71417-1-snelson@pensando.io>
        <20200831233558.71417-2-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 31 Aug 2020 16:58:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 31 Aug 2020 16:35:54 -0700

> @@ -100,6 +100,8 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>  		frag_len = min(len, (u16)PAGE_SIZE);
>  		len -= frag_len;
>  
> +		dma_sync_single_for_cpu(dev, dma_unmap_addr(page_info, dma_addr),
> +					len, DMA_FROM_DEVICE);
>  		dma_unmap_page(dev, dma_unmap_addr(page_info, dma_addr),
>  			       PAGE_SIZE, DMA_FROM_DEVICE);
>  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,

The unmap operation performs a sync, if necessary, for you.

That's the pattern of usage:

	map();
	device read/write memory
	unmap();

That's it, no more, no less.

The time to use sync is when you want to maintain the mapping and keep
using it.
