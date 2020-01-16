Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0406C13E26C
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733112AbgAPQzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:55:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732543AbgAPQzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:55:54 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E9722464;
        Thu, 16 Jan 2020 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193753;
        bh=hr+B5uQ0PdzcKcQdS7HasGDltOnY59pKbIhtGDmGYoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+IN2WLbDfh4y/fPykt4Q3Xn2OeWSE7ZbLu17brSEZjDTxPkvu9xEVqryu/9hATAo
         N9+do2MqzVumVTkV4ACUB0TBTYileXXtgkoeG60Rm4wPECD8Go0/AC5LiNkvOvuqhI
         ojbC9muqpnNFgpdfF3MHJuW09R5aDI+cW+mYaT74=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 042/671] net: hns3: add error handler for hns3_nic_init_vector_data()
Date:   Thu, 16 Jan 2020 11:44:33 -0500
Message-Id: <20200116165502.8838-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit ece4bf46e98c9f3775a488f3932a531508d3b1a2 ]

When hns3_nic_init_vector_data() fails to map ring to vector,
it should cancel the netif_napi_add() that has been successfully
done and then exits.

Fixes: 76ad4f0ee747 ("net: hns3: Add support of HNS3 Ethernet Driver for hip08 SoC")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 1aaf6e2a3b39..9df807ec8c84 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2642,7 +2642,7 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 	struct hnae3_handle *h = priv->ae_handle;
 	struct hns3_enet_tqp_vector *tqp_vector;
 	int ret = 0;
-	u16 i;
+	int i;
 
 	for (i = 0; i < priv->vector_num; i++) {
 		tqp_vector = &priv->tqp_vector[i];
@@ -2687,13 +2687,19 @@ static int hns3_nic_init_vector_data(struct hns3_nic_priv *priv)
 		hns3_free_vector_ring_chain(tqp_vector, &vector_ring_chain);
 
 		if (ret)
-			return ret;
+			goto map_ring_fail;
 
 		netif_napi_add(priv->netdev, &tqp_vector->napi,
 			       hns3_nic_common_poll, NAPI_POLL_WEIGHT);
 	}
 
 	return 0;
+
+map_ring_fail:
+	while (i--)
+		netif_napi_del(&priv->tqp_vector[i].napi);
+
+	return ret;
 }
 
 static int hns3_nic_alloc_vector_data(struct hns3_nic_priv *priv)
-- 
2.20.1

