Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3595B4148
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 21:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388387AbfIPToo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 15:44:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50590 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729144AbfIPTon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 15:44:43 -0400
Received: from localhost (80-167-222-154-cable.dk.customer.tdc.net [80.167.222.154])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0D11D153F3459;
        Mon, 16 Sep 2019 12:44:39 -0700 (PDT)
Date:   Mon, 16 Sep 2019 21:44:38 +0200 (CEST)
Message-Id: <20190916.214438.647698482843698023.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com
Subject: Re: [PATCH V1 net-next 2/5] net: ena: multiple queue creation
 related cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190915152722.8240-3-sameehj@amazon.com>
References: <20190915152722.8240-1-sameehj@amazon.com>
        <20190915152722.8240-3-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Sep 2019 12:44:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Sun, 15 Sep 2019 18:27:19 +0300

> @@ -1885,6 +1885,13 @@ static int ena_up(struct ena_adapter *adapter)
>  	if (rc)
>  		goto err_req_irq;
>  
> +	netif_info(adapter, ifup, adapter->netdev, "creating %d io queues. rx queue size: %d tx queue size. %d LLQ is %s\n",
> +		   adapter->num_io_queues,
> +		   adapter->requested_rx_ring_size,
> +		   adapter->requested_tx_ring_size,
> +		   (adapter->ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV) ?
> +		   "ENABLED" : "DISABLED");

Please don't clog up the kernel log with stuff like this.

Maybe netif_debug() at best, but I'd rather you remove this entirely.  It's so
easy to make a device go up and down repeatedly multiple times in one second.
