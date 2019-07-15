Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E8BC68FB9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 16:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389705AbfGOOQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 10:16:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731290AbfGOOQZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 10:16:25 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D6CA206B8;
        Mon, 15 Jul 2019 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200184;
        bh=vKsXn2+tp/0Snr7P84MX3DCJco/k7jEpG0uIqM6X8YM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nB1ah8GouYFO9LuIQEleUaTGOT6TQObSluT2rLOO+hIeAtitgpe63I6hMSo3voIV4
         es2yBoVFMH9J/ok3mGL5DXLbxjXZx6BD9nuY17S1F4kZ5oBOouJG3nKc/dQQvN6KHo
         9qbElcLDvppPswpT3T5M0faXgp8o6qhQE01cIEJ8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 203/219] net: hns3: enable broadcast promisc mode when initializing VF
Date:   Mon, 15 Jul 2019 10:03:24 -0400
Message-Id: <20190715140341.6443-203-sashal@kernel.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 2d5066fc175ea77a733d84df9ef414b34f311641 ]

For revision 0x20, the broadcast promisc is enabled by firmware,
it's unnecessary to enable it when initializing VF.

For revision 0x21, it's necessary to enable broadcast promisc mode
when initializing or re-initializing VF, otherwise, it will be
unable to send and receive promisc packets.

Fixes: f01f5559cac8 ("net: hns3: don't allow vf to enable promisc mode")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c  | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index 8dd7fef863f6..d7a15d5b6b61 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2425,6 +2425,12 @@ static int hclgevf_reset_hdev(struct hclgevf_dev *hdev)
 		return ret;
 	}
 
+	if (pdev->revision >= 0x21) {
+		ret = hclgevf_set_promisc_mode(hdev, true);
+		if (ret)
+			return ret;
+	}
+
 	dev_info(&hdev->pdev->dev, "Reset done\n");
 
 	return 0;
@@ -2504,9 +2510,11 @@ static int hclgevf_init_hdev(struct hclgevf_dev *hdev)
 	 * firmware makes sure broadcast packets can be accepted.
 	 * For revision 0x21, default to enable broadcast promisc mode.
 	 */
-	ret = hclgevf_set_promisc_mode(hdev, true);
-	if (ret)
-		goto err_config;
+	if (pdev->revision >= 0x21) {
+		ret = hclgevf_set_promisc_mode(hdev, true);
+		if (ret)
+			goto err_config;
+	}
 
 	/* Initialize RSS for this VF */
 	ret = hclgevf_rss_init_hw(hdev);
-- 
2.20.1

