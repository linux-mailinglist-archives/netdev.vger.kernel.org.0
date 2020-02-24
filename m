Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF99169D42
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 05:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727287AbgBXEyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 23:54:16 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727186AbgBXEyQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 23:54:16 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1485114EFC20A;
        Sun, 23 Feb 2020 20:54:16 -0800 (PST)
Date:   Sun, 23 Feb 2020 20:54:15 -0800 (PST)
Message-Id: <20200223.205415.225744319800955337.davem@davemloft.net>
To:     marex@denx.de
Cc:     netdev@vger.kernel.org, lukas@wunner.de, ynezz@true.cz,
        yuehaibing@huawei.com
Subject: Re: [PATCH] net: ks8851-ml: Fix IRQ handling and locking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200223133840.318025-1-marex@denx.de>
References: <20200223133840.318025-1-marex@denx.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Feb 2020 20:54:16 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>
Date: Sun, 23 Feb 2020 14:38:40 +0100

> The KS8851 requires that packet RX and TX are mutually exclusive.
> Currently, the driver hopes to achieve this by disabling interrupt
> from the card by writing the card registers and by disabling the
> interrupt on the interrupt controller. This however is racy on SMP.
> 
> Replace this approach by expanding the spinlock used around the
> ks_start_xmit() TX path to ks_irq() RX path to assure true mutual
> exclusion and remove the interrupt enabling/disabling, which is
> now not needed anymore. Furthermore, disable interrupts also in
> ks_net_stop(), which was missing before.
> 
> Note that a massive improvement here would be to re-use the KS8851
> driver approach, which is to move the TX path into a worker thread,
> interrupt handling to threaded interrupt, and synchronize everything
> with mutexes, but that would be a much bigger rework, for a separate
> patch.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>

This looks find as a fix for 'net', applied, thanks.
