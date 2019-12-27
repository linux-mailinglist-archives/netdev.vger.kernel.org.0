Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25F012BA1A
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 19:16:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfL0SQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 13:16:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:41468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728350AbfL0SQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 13:16:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D406F20CC7;
        Fri, 27 Dec 2019 18:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577470576;
        bh=Gtk5/0Fmps0CpCMIBKZ69bWUpSgCAMMbRSD/i+uxqNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmsAgSWRoo4R0FiL47jl5LXjW+MWFofQSDjEUl4Qiol002FUrijZXeaBMOAoZU1jh
         5635XEVLuHr/vaal8Ae7lrLfxbHzwEzDXh6myxUyOzjaFpy2QsZQvMGzEIZJAj6/EX
         l6NBwSmM+3nMYOGvxZ6O2OLLNtD84MOOi19aCVXI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 23/25] net: hisilicon: Fix a BUG trigered by wrong bytes_compl
Date:   Fri, 27 Dec 2019 13:15:47 -0500
Message-Id: <20191227181549.8040-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227181549.8040-1-sashal@kernel.org>
References: <20191227181549.8040-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiangfeng Xiao <xiaojiangfeng@huawei.com>

[ Upstream commit 90b3b339364c76baa2436445401ea9ade040c216 ]

When doing stress test, we get the following trace:
kernel BUG at lib/dynamic_queue_limits.c:26!
Internal error: Oops - BUG: 0 [#1] SMP ARM
Modules linked in: hip04_eth
CPU: 0 PID: 2003 Comm: tDblStackPcap0 Tainted: G           O L  4.4.197 #1
Hardware name: Hisilicon A15
task: c3637668 task.stack: de3bc000
PC is at dql_completed+0x18/0x154
LR is at hip04_tx_reclaim+0x110/0x174 [hip04_eth]
pc : [<c041abfc>]    lr : [<bf0003a8>]    psr: 800f0313
sp : de3bdc2c  ip : 00000000  fp : c020fb10
r10: 00000000  r9 : c39b4224  r8 : 00000001
r7 : 00000046  r6 : c39b4000  r5 : 0078f392  r4 : 0078f392
r3 : 00000047  r2 : 00000000  r1 : 00000046  r0 : df5d5c80
Flags: Nzcv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment user
Control: 32c5387d  Table: 1e189b80  DAC: 55555555
Process tDblStackPcap0 (pid: 2003, stack limit = 0xde3bc190)
Stack: (0xde3bdc2c to 0xde3be000)
[<c041abfc>] (dql_completed) from [<bf0003a8>] (hip04_tx_reclaim+0x110/0x174 [hip04_eth])
[<bf0003a8>] (hip04_tx_reclaim [hip04_eth]) from [<bf0012c0>] (hip04_rx_poll+0x20/0x388 [hip04_eth])
[<bf0012c0>] (hip04_rx_poll [hip04_eth]) from [<c04c8d9c>] (net_rx_action+0x120/0x374)
[<c04c8d9c>] (net_rx_action) from [<c021eaf4>] (__do_softirq+0x218/0x318)
[<c021eaf4>] (__do_softirq) from [<c021eea0>] (irq_exit+0x88/0xac)
[<c021eea0>] (irq_exit) from [<c0240130>] (msa_irq_exit+0x11c/0x1d4)
[<c0240130>] (msa_irq_exit) from [<c0267ba8>] (__handle_domain_irq+0x110/0x148)
[<c0267ba8>] (__handle_domain_irq) from [<c0201588>] (gic_handle_irq+0xd4/0x118)
[<c0201588>] (gic_handle_irq) from [<c0558360>] (__irq_svc+0x40/0x58)
Exception stack(0xde3bdde0 to 0xde3bde28)
dde0: 00000000 00008001 c3637668 00000000 00000000 a00f0213 dd3627a0 c0af6380
de00: c086d380 a00f0213 c0a22a50 de3bde6c 00000002 de3bde30 c0558138 c055813c
de20: 600f0213 ffffffff
[<c0558360>] (__irq_svc) from [<c055813c>] (_raw_spin_unlock_irqrestore+0x44/0x54)
Kernel panic - not syncing: Fatal exception in interrupt

Pre-modification code:
int hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
{
[...]
[1]	priv->tx_head = TX_NEXT(tx_head);
[2]	count++;
[3]	netdev_sent_queue(ndev, skb->len);
[...]
}
An rx interrupt occurs if hip04_mac_start_xmit just executes to the line 2,
tx_head has been updated, but corresponding 'skb->len' has not been
added to dql_queue.

And then
hip04_mac_interrupt->__napi_schedule->hip04_rx_poll->hip04_tx_reclaim

In hip04_tx_reclaim, because tx_head has been updated,
bytes_compl will plus an additional "skb-> len"
which has not been added to dql_queue. And then
trigger the BUG_ON(bytes_compl > num_queued - dql->num_completed).

To solve the problem described above, we put
"netdev_sent_queue(ndev, skb->len);"
before
"priv->tx_head = TX_NEXT(tx_head);"

Fixes: a41ea46a9a12 ("net: hisilicon: new hip04 ethernet driver")
Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index 2a7dfac20546..09c51220b5ca 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -455,9 +455,9 @@ static int hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	skb_tx_timestamp(skb);
 
 	hip04_set_xmit_desc(priv, phys);
-	priv->tx_head = TX_NEXT(tx_head);
 	count++;
 	netdev_sent_queue(ndev, skb->len);
+	priv->tx_head = TX_NEXT(tx_head);
 
 	stats->tx_bytes += skb->len;
 	stats->tx_packets++;
-- 
2.20.1

