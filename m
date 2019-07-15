Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8B968D58
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:59:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733007AbfGON5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:57:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731845AbfGON5w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:57:52 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F3102083D;
        Mon, 15 Jul 2019 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199071;
        bh=EnoKj8gvrxt9vzbUip65DQKTkQ796pgK5snKd2HkWao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Dj34TYX3ZfpKKIqSYMiU6OZ5PPoMIhaY4QyZueGiN1TmkcZBnuYopK0UHEwcxN6C
         KR6btM1Nu2kuTPqteU2oZH+BPcrDJeTeoi66OugG7jU73ZaIW1BrcvsJn7Bh1++x3N
         sDfp8K6MfDyF1wIdup+gDPjqbz0GNnP2COc5im1Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jian Shen <shenjian15@huawei.com>, Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 180/249] net: hns3: restore the MAC autoneg state after reset
Date:   Mon, 15 Jul 2019 09:45:45 -0400
Message-Id: <20190715134655.4076-180-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit d736fc6c68a5f76e89a6c2c4100e3678706003a3 ]

When doing global reset, the MAC autoneg state of fibre
port is set to default, which may cause user configuration
lost. This patch fixes it by restore the MAC autoneg state
after reset.

Fixes: 22f48e24a23d ("net: hns3: add autoneg and change speed support for fibre port")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 4d9bcad26f06..645b9b3e0256 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2389,6 +2389,15 @@ static int hclge_mac_init(struct hclge_dev *hdev)
 		return ret;
 	}
 
+	if (hdev->hw.mac.support_autoneg) {
+		ret = hclge_set_autoneg_en(hdev, hdev->hw.mac.autoneg);
+		if (ret) {
+			dev_err(&hdev->pdev->dev,
+				"Config mac autoneg fail ret=%d\n", ret);
+			return ret;
+		}
+	}
+
 	mac->link = 0;
 
 	if (mac->user_fec_mode & BIT(HNAE3_FEC_USER_DEF)) {
-- 
2.20.1

