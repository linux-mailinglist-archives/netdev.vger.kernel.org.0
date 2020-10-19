Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBB1B29230C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 09:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbgJSHjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 03:39:52 -0400
Received: from twspam01.aspeedtech.com ([211.20.114.71]:48121 "EHLO
        twspam01.aspeedtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727768AbgJSHjw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 03:39:52 -0400
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 09J7anxl039002;
        Mon, 19 Oct 2020 15:36:49 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.9) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct
 2020 15:39:25 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ratbert@faraday-tech.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>
CC:     <BMC-SW@aspeedtech.com>
Subject: [PATCH] net: ftgmac100: Fix missing TX-poll issue
Date:   Mon, 19 Oct 2020 15:39:08 +0800
Message-ID: <20201019073908.32262-1-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.10.9]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 09J7anxl039002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cpu accesses the register and the memory via different bus/path on
aspeed soc.  So we can not guarantee that the tx-poll command
(register access) is always behind the tx descriptor (memory).  In other
words, the HW may start working even the data is not yet ready.  By
adding a dummy read after the last data write, we can ensure the data
are pushed to the memory, then guarantee the processing sequence

Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 00024dd41147..9a99a87f29f3 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -804,7 +804,8 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 	 * before setting the OWN bit on the first descriptor.
 	 */
 	dma_wmb();
-	first->txdes0 = cpu_to_le32(f_ctl_stat);
+	WRITE_ONCE(first->txdes0, cpu_to_le32(f_ctl_stat));
+	READ_ONCE(first->txdes0);
 
 	/* Update next TX pointer */
 	priv->tx_pointer = pointer;
-- 
2.17.1

