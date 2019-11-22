Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D63B410612C
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 06:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbfKVFyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:54:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:59038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfKVFxE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B390F2068F;
        Fri, 22 Nov 2019 05:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401983;
        bh=lwe9ZwYIqGLbnxUhHCr7toIMXnpr2DN+CvP5jajKOk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtPUkv5voXmVraSsbnA/0YfqHYMt+8Jj3BIF4mLy4442rJEj6CpMCkGlvgqde/vRk
         MtSV6R8qpOS0eRgn4OK+FogB4JgO63SgRPO0Mj+F7fN5EQViRr+lgyPn9WnwkNqeVe
         lcEYdyACy+K3LQMHrxxKULTy0njpt5IfUbmo+s2w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 202/219] net: hns3: fix an issue for hclgevf_ae_get_hdev
Date:   Fri, 22 Nov 2019 00:48:53 -0500
Message-Id: <20191122054911.1750-194-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

[ Upstream commit eed9535f9f716a532ec0c5d6cc7a48584acdf435 ]

HNS3 VF driver support NIC and Roce, hdev stores NIC
handle and Roce handle, should use correct parameter for
container_of.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 5570fb5dc2eb4..f6a579220ec18 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -26,7 +26,12 @@ MODULE_DEVICE_TABLE(pci, ae_algovf_pci_tbl);
 static inline struct hclgevf_dev *hclgevf_ae_get_hdev(
 	struct hnae3_handle *handle)
 {
-	return container_of(handle, struct hclgevf_dev, nic);
+	if (!handle->client)
+		return container_of(handle, struct hclgevf_dev, nic);
+	else if (handle->client->type == HNAE3_CLIENT_ROCE)
+		return container_of(handle, struct hclgevf_dev, roce);
+	else
+		return container_of(handle, struct hclgevf_dev, nic);
 }
 
 static int hclgevf_tqps_update_stats(struct hnae3_handle *handle)
-- 
2.20.1

