Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5303869544
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390244AbfGOOWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:22:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:49526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390579AbfGOOWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:22:16 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E19E217F4;
        Mon, 15 Jul 2019 14:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200535;
        bh=Fel56vlLm3EcR8vmb380+JKCns3ZiwAaYRzP9HrPJ0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BAgxhW2wgZuNvi2nSA1wKhJFDH8dk6jvn71fTe2BHziDxUEboOYhYfBFpiIsOC96
         TA2n8WnzAtrjqgpHdbttThZQdzWRXTFqCNhvOla3vbtnZIr3oW8Cy1XpEc19nn0D2t
         HvhNOP8T/qdb3q07ms4o6I5FFT+zDj5rXQUSkonk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 070/158] net: hns3: fix for skb leak when doing selftest
Date:   Mon, 15 Jul 2019 10:16:41 -0400
Message-Id: <20190715141809.8445-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunsheng Lin <linyunsheng@huawei.com>

[ Upstream commit 8f9eed1a8791b83eb1c54c261d68424717e4111e ]

If hns3_nic_net_xmit does not return NETDEV_TX_BUSY when doing
a loopback selftest, the skb is not freed in hns3_clean_tx_ring
or hns3_nic_net_xmit, which causes skb not freed problem.

This patch fixes it by freeing skb when hns3_nic_net_xmit does
not return NETDEV_TX_OK.

Fixes: c39c4d98dc65 ("net: hns3: Add mac loopback selftest support in hns3 driver")

Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 9684ad015c42..6a3c6b02a77c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -245,11 +245,13 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 
 		skb_get(skb);
 		tx_ret = hns3_nic_net_xmit(skb, ndev);
-		if (tx_ret == NETDEV_TX_OK)
+		if (tx_ret == NETDEV_TX_OK) {
 			good_cnt++;
-		else
+		} else {
+			kfree_skb(skb);
 			netdev_err(ndev, "hns3_lb_run_test xmit failed: %d\n",
 				   tx_ret);
+		}
 	}
 	if (good_cnt != HNS3_NIC_LB_TEST_PKT_NUM) {
 		ret_val = HNS3_NIC_LB_TEST_TX_CNT_ERR;
-- 
2.20.1

