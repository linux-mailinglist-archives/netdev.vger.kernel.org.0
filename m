Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F815648B81
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 00:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLIX6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 18:58:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiLIX6D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 18:58:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A797747CF
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 15:58:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC623B829FA
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 23:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D75BC433D2;
        Fri,  9 Dec 2022 23:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670630279;
        bh=fEFQDOtjljw/UdoMQ45dR6QLzGE0suR6RY9gCQiY/6c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DKMUuxnL0sYgX1nVgkq6cXtXUSLjl6dvhfwM6D1/vmuvqm4meXCXUZftVRpVg0xA4
         XoUjj9qXvUnglVCEC/7Toxffj4fma8wL26cr0clBQ0xbF34uFNTAg0UcEpuSuLA3+U
         nhZ3a1b7D7xapIQQaWm4MTJIlyaby4rekGuxwjD5BLltyf4iWy0tdYDAfCKAqz40/7
         A6yZ/pNyrf6vT8Yg/ZJav1mtHFfeN7jxdUGBCNU45a6JfSpz7QFU+hHluYBimRPCeC
         XKBw9uVvYxoiOOUHj3VoyHp10f5i0G32/gQLIenGJXZPVu0gBbTib4p8P4OAbh+9ti
         bkfq1C0xNLlfw==
Date:   Fri, 9 Dec 2022 15:57:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     <netdev@vger.kernel.org>, <isdn@linux-pingi.de>,
        <davem@davemloft.net>
Subject: Re: [PATCH net 1/3] mISDN: hfcsusb: don't call dev_kfree_skb()
 under spin_lock_irqsave()
Message-ID: <20221209155758.459b858d@kernel.org>
In-Reply-To: <20221207093239.3775457-2-yangyingliang@huawei.com>
References: <20221207093239.3775457-1-yangyingliang@huawei.com>
        <20221207093239.3775457-2-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 7 Dec 2022 17:32:37 +0800 Yang Yingliang wrote:
>  			spin_lock_irqsave(&hw->lock, flags);
>  			skb_queue_purge(&dch->squeue);

Please take a look at what skb_queue_purge() does.
Perhaps you should create a skb_buff_head on the stack,
skb_queue_splice_init() from the sch->squeue onto that
queue, add the rx_skb and tx_skb into that queue,
then drop the lock and skb_queue_purge() outside the lock.

>  			if (dch->tx_skb) {
> -				dev_kfree_skb(dch->tx_skb);
> +				dev_consume_skb_irq(dch->tx_skb);
