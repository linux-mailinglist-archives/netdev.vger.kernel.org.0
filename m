Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF97572190
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 23:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392048AbfGWVd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 17:33:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37120 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731019AbfGWVd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 17:33:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D5997153BFB1A;
        Tue, 23 Jul 2019 14:33:26 -0700 (PDT)
Date:   Tue, 23 Jul 2019 14:33:26 -0700 (PDT)
Message-Id: <20190723.143326.197667027838462669.davem@davemloft.net>
To:     snelson@pensando.io
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 11/19] ionic: Add Rx filter and rx_mode ndo
 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190722214023.9513-12-snelson@pensando.io>
References: <20190722214023.9513-1-snelson@pensando.io>
        <20190722214023.9513-12-snelson@pensando.io>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 23 Jul 2019 14:33:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shannon Nelson <snelson@pensando.io>
Date: Mon, 22 Jul 2019 14:40:15 -0700

> +	if (in_interrupt()) {
> +		work = kzalloc(sizeof(*work), GFP_ATOMIC);
> +		if (!work) {
> +			netdev_err(lif->netdev, "%s OOM\n", __func__);
> +			return -ENOMEM;
> +		}
> +		work->type = add ? DW_TYPE_RX_ADDR_ADD : DW_TYPE_RX_ADDR_DEL;
> +		memcpy(work->addr, addr, ETH_ALEN);
> +		netdev_dbg(lif->netdev, "deferred: rx_filter %s %pM\n",
> +			   add ? "add" : "del", addr);
> +		ionic_lif_deferred_enqueue(&lif->deferred, work);
> +	} else {
> +		netdev_dbg(lif->netdev, "rx_filter %s %pM\n",
> +			   add ? "add" : "del", addr);
> +		if (add)
> +			return ionic_lif_addr_add(lif, addr);
> +		else
> +			return ionic_lif_addr_del(lif, addr);
> +	}

I don't know about this.

Generally interface address changes are expected to be synchronous.
