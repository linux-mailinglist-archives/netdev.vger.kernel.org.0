Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B3C5FF283
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 17:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbfKPQTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 11:19:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729267AbfKPPp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 16 Nov 2019 10:45:59 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B4762077B;
        Sat, 16 Nov 2019 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919158;
        bh=T93k57TIsenFOGGX58LNq3dynzwqIM/Y3j3qkoXDZw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDacVGEKW2bE1GynioaYrgaxcUiMcjHWOM3bLxFXnOuaq84u5cxtp9/3YmgD1fy72
         uGVZwKC3tqv2qej+RKEnaRYeqYIv37+0DP3Bz6knyu0ayrFTMnSEk/dBoK+P2JI4jO
         0SOgraUPRm2rhGNG38fVnq354oJTWfkbe07jBhaQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 169/237] net: hns3: bugfix for reporting unknown vector0 interrupt repeatly problem
Date:   Sat, 16 Nov 2019 10:40:04 -0500
Message-Id: <20191116154113.7417-169-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huazhong Tan <tanhuazhong@huawei.com>

[ Upstream commit 0d4411408a7fb9aad0645f23911d9bfdd2ce3177 ]

The current driver supports handling two vector0 interrupts, reset and
mailbox. When the hardware reports an interrupt of another type of
interrupt source, if the driver does not process the interrupt, but
enables the interrupt, the hardware will repeatedly report the unknown
interrupt.

Therefore, the driver enables the vector0 interrupt after clearing the
known type of interrupt source. Other conditions are not enabled.

Fixes: cd8c5c269b1d ("net: hns3: Fix for hclge_reset running repeatly problem")
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 89ca69fa2b97b..0b622d20cd305 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2574,7 +2574,7 @@ static irqreturn_t hclge_misc_irq_handle(int irq, void *data)
 	}
 
 	/* clear the source of interrupt if it is not cause by reset */
-	if (event_cause != HCLGE_VECTOR0_EVENT_RST) {
+	if (event_cause == HCLGE_VECTOR0_EVENT_MBX) {
 		hclge_clear_event_cause(hdev, event_cause, clearval);
 		hclge_enable_vector(&hdev->misc_vector, true);
 	}
-- 
2.20.1

