Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC31B4140
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 21:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388178AbfIPTk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 15:40:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50556 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbfIPTk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 15:40:58 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A5E24153F3440;
        Mon, 16 Sep 2019 12:40:54 -0700 (PDT)
Date:   Mon, 16 Sep 2019 21:40:53 +0200 (CEST)
Message-Id: <20190916.214053.1979513954122379431.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V1 net] net: ena: don't wake up tx queue when down
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190915142944.7572-1-sameehj@amazon.com>
References: <20190915142944.7572-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 12:40:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Sun, 15 Sep 2019 17:29:44 +0300

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> There is a race condition that can occur when calling ena_down().
> The ena_clean_tx_irq() - which is a part of the napi handler -
> function might wake up the tx queue when the queue is supposed
> to be down (during recovery or changing the size of the queues
> for example) This causes the ena_start_xmit() function to trigger
> and possibly try to access the destroyed queues.
> 
> The race is illustrated below:
> 
> Flow A:                                       Flow B(napi handler)
> ena_down()
>    netif_carrier_off()
>    netif_tx_disable()
>                                                       ena_clean_tx_irq()
>                                                          netif_tx_wake_queue()
>    ena_napi_disable_all()
>    ena_destroy_all_io_queues()
> 
> After these flows the tx queue is active and ena_start_xmit() accesses
> the destroyed queue which leads to a kernel panic.
> 
> fixes: 1738cd3ed342 (net: ena: Add a driver for Amazon Elastic Network Adapters (ENA))
> 
> Signed-off-by: Sameeh Jubran <sameehj@amazon.com>

Applied.
