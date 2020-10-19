Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1B6329240C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 10:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729957AbgJSI5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 04:57:55 -0400
Received: from twspam01.aspeedtech.com ([211.20.114.71]:65354 "EHLO
        twspam01.aspeedtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729927AbgJSI5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 04:57:53 -0400
Received: from mail.aspeedtech.com ([192.168.0.24])
        by twspam01.aspeedtech.com with ESMTP id 09J8spsl046773;
        Mon, 19 Oct 2020 16:54:51 +0800 (GMT-8)
        (envelope-from dylan_hung@aspeedtech.com)
Received: from localhost.localdomain (192.168.10.9) by TWMBX02.aspeed.com
 (192.168.0.24) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 19 Oct
 2020 16:57:27 +0800
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <ratbert@faraday-tech.com>,
        <linux-aspeed@lists.ozlabs.org>, <openbmc@lists.ozlabs.org>
CC:     <BMC-SW@aspeedtech.com>, Joel Stanley <joel@jms.id.au>
Subject: [PATCH 2/4] ftgmac100: Fix missing-poll issue
Date:   Mon, 19 Oct 2020 16:57:15 +0800
Message-ID: <20201019085717.32413-3-dylan_hung@aspeedtech.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201019085717.32413-1-dylan_hung@aspeedtech.com>
References: <20201019085717.32413-1-dylan_hung@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.168.10.9]
X-ClientProxiedBy: TWMBX02.aspeed.com (192.168.0.24) To TWMBX02.aspeed.com
 (192.168.0.24)
X-DNSRBL: 
X-MAIL: twspam01.aspeedtech.com 09J8spsl046773
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the tx-poll command may advance the tx descriptor due the HW design.
By adding a pseudo read and proper memory barrier, we can ensure all the
data are ready before TX poll command.

Fixes: 52c0cae87465 ("ftgmac100: Remove tx descriptor accessors")
Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Signed-off-by: Joel Stanley <joel@jms.id.au>
---
 drivers/net/ethernet/faraday/ftgmac100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 7cacbe4aecb7..810bda80f138 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -814,8 +814,8 @@ static netdev_tx_t ftgmac100_hard_start_xmit(struct sk_buff *skb,
 	 * before setting the OWN bit on the first descriptor.
 	 */
 	dma_wmb();
-	first->txdes0 = cpu_to_le32(f_ctl_stat);
-
+	WRITE_ONCE(first->txdes0, cpu_to_le32(f_ctl_stat));
+	READ_ONCE(first->txdes0);
 	/* Update next TX pointer */
 	priv->tx_pointer = pointer;
 
-- 
2.17.1

