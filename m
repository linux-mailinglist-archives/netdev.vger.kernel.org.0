Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 449CDF30ED
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 15:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389148AbfKGOMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 09:12:23 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:46356 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729162AbfKGOMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 09:12:23 -0500
Received: from www-data by cheepnis.misterjones.org with local (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1iSiWG-0006fb-WE; Thu, 07 Nov 2019 15:12:17 +0100
To:     Salil Mehta <salil.mehta@huawei.com>
Subject: Re: [PATCH net] net: hns: Fix the stray netpoll locks causing  deadlock in NAPI path
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Nov 2019 15:21:37 +0109
From:   Marc Zyngier <maz@kernel.org>
Cc:     <davem@davemloft.net>, <edumazet@google.com>,
        <yisen.zhuang@huawei.com>, <lipeng321@huawei.com>,
        <mehta.salil@opnsrc.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>
In-Reply-To: <20191106185405.23112-1-salil.mehta@huawei.com>
References: <20191106185405.23112-1-salil.mehta@huawei.com>
Message-ID: <a6f06cfc7ef91685746dfe5ab6c56401@www.loen.fr>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/0.7.2
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Rcpt-To: salil.mehta@huawei.com, davem@davemloft.net, edumazet@google.com, yisen.zhuang@huawei.com, lipeng321@huawei.com, mehta.salil@opnsrc.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Salil,

On 2019-11-06 20:03, Salil Mehta wrote:
> This patch fixes the problem of the spin locks, originally
> meant for the netpoll path of hns driver, causing deadlock in
> the normal NAPI poll path. The issue happened due presence of
> the stray leftover spin lock code related to the netpoll,
> whose support was earlier removed from the HNS[1], got activated
> due to enabling of NET_POLL_CONTROLLER switch.
>
> Earlier background:
> The netpoll handling code originally had this bug(as identified
> by Marc Zyngier[2]) of wrong spin lock API being used which did
> not disable the interrupts and hence could cause locking issues.
> i.e. if the lock were first acquired in context to thread like
> 'ip' util and this lock if ever got later acquired again in
> context to the interrupt context like TX/RX (Interrupts could
> always pre-empt the lock holding task and acquire the lock again)
> and hence could cause deadlock.
>
> Proposed Solution:
> 1. If the netpoll was enabled in the HNS driver, which is not
>    right now, we could have simply used spin_[un]lock_irqsave()
> 2. But as netpoll is disabled, therefore, it is best to get rid
>    of the existing locks and stray code for now. This should
>    solve the problem reported by Marc.
>
> @Marc,
> Could you please test this patch and confirm if the problem is
> fixed at your end?

Yes, this fixes it, although you may want to fully get rid of
the now useless lock:

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.c 
b/drivers/net/ethernet/hisilicon/hns/hnae.c
index 6d0457eb4faa..08339278c722 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.c
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.c
@@ -199,7 +199,6 @@ hnae_init_ring(struct hnae_queue *q, struct 
hnae_ring *ring, int flags)

  	ring->q = q;
  	ring->flags = flags;
-	spin_lock_init(&ring->lock);
  	ring->coal_param = q->handle->coal_param;
  	assert(!ring->desc && !ring->desc_cb && !ring->desc_dma_addr);

diff --git a/drivers/net/ethernet/hisilicon/hns/hnae.h 
b/drivers/net/ethernet/hisilicon/hns/hnae.h
index e9c67c06bfd2..6ab9458302e1 100644
--- a/drivers/net/ethernet/hisilicon/hns/hnae.h
+++ b/drivers/net/ethernet/hisilicon/hns/hnae.h
@@ -274,9 +274,6 @@ struct hnae_ring {
  	/* statistic */
  	struct ring_stats stats;

-	/* ring lock for poll one */
-	spinlock_t lock;
-
  	dma_addr_t desc_dma_addr;
  	u32 buf_size;       /* size for hnae_desc->addr, preset by AE */
  	u16 desc_num;       /* total number of desc */

With that:

Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
