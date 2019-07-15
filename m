Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A25CC69644
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388657AbfGOOJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:60490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388645AbfGOOJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:09:08 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C35217F4;
        Mon, 15 Jul 2019 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199747;
        bh=5H8U7i/tEl0qTeXs4KMUUMiPG1zl2dOe992Ac7Uqr8c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPiPdheekSKypibdEy7E1p/62uPyozSVo1xg7GiEMdcBPVedRM8K5PPr6tnsze6fS
         Ku5bw1ajUMaWBP8GhkiV7yp56sh4RUc4eLH+hfEePsDX+3Cf4UJ1rX+GlveRw3vsnf
         br5ym/0YvMcs+DKUINRxZcdKP81joNa8Z1tdnWds=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 093/219] net: hns3: fix for skb leak when doing selftest
Date:   Mon, 15 Jul 2019 10:01:34 -0400
Message-Id: <20190715140341.6443-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
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
index ea94b5152963..cf20fa6768d7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -241,11 +241,13 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 
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

