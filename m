Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B36814891B
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 15:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392732AbgAXOcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 09:32:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389436AbgAXOUA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 09:20:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E4D424676;
        Fri, 24 Jan 2020 14:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579875599;
        bh=W1jirwlr7v13jTCfr7mNvWD5BBnGeEGhhW1PMP2SgVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rv+glKT5ASCt+RuILq7Xr44EhCIBtgUMl5U08o/f0+jDBBk7/JvZyxjRaa0wKgyRL
         8kjRgasKiGN+mkslDQ92jK3u3QVs8X5+tDtZ9KqZQAQdpvFr1mH9qHMUomuMLnRx65
         /FQLynTRh7HC7QY8VXD16wxnl5ist/p8XVFcdD4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 088/107] net: hns3: pad the short frame before sending to the hardware
Date:   Fri, 24 Jan 2020 09:17:58 -0500
Message-Id: <20200124141817.28793-88-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200124141817.28793-1-sashal@kernel.org>
References: <20200124141817.28793-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 36c67349a1a1c88b9cf11d7ca7762ababdb38867 ]

The hardware can not handle short frames below or equal to 32
bytes according to the hardware user manual, and it will trigger
a RAS error when the frame's length is below 33 bytes.

This patch pads the SKB when skb->len is below 33 bytes before
sending it to hardware.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 84d8816c8681b..0c8d2269bc46e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -54,6 +54,8 @@ MODULE_PARM_DESC(debug, " Network interface message level setting");
 #define HNS3_INNER_VLAN_TAG	1
 #define HNS3_OUTER_VLAN_TAG	2
 
+#define HNS3_MIN_TX_LEN		33U
+
 /* hns3_pci_tbl - PCI Device ID Table
  *
  * Last entry must be all 0s
@@ -1329,6 +1331,10 @@ netdev_tx_t hns3_nic_net_xmit(struct sk_buff *skb, struct net_device *netdev)
 	int ret;
 	int i;
 
+	/* Hardware can only handle short frames above 32 bytes */
+	if (skb_put_padto(skb, HNS3_MIN_TX_LEN))
+		return NETDEV_TX_OK;
+
 	/* Prefetch the data used later */
 	prefetch(skb->data);
 
-- 
2.20.1

