Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3113F18A7
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 13:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238931AbhHSL6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 07:58:53 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:51638
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238105AbhHSL6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 07:58:51 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 3806D3F367;
        Thu, 19 Aug 2021 11:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1629374294;
        bh=8tUdKXborkpkb9B6b8mLjUQl9KMTxCxIx0f8+/7UNMw=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=SDJK6/QhUK5RkJwZcNgFVm5RKHNgwJYNJ4KqpO1ygEl8ImlqjU3jSENI8NwJsIWlO
         lSzrufbs99yLGvbbHPZsoQit/q3+2wx8xPdj+E7FRJ4jvzZLpiAeqwmzUdlM70RS5X
         SFJsFw5lokxBAUmRNvANppXjzhtZS4lHWsRw4zGGoXfEQwoM7wIghYbKslQCIlViqs
         bR2bibyzQJPcSrRBC4EPrtxvpAGaHA/lwcwtFNyqSvuBtAbu/HQYrRfJ9AwfC5Gm0w
         gpsQynOOv3T/iJA8n/F8k1r2bySHUlBTqXu5V90zbQ00I6C4hfLDBHKz54Sb/nFQi7
         iC4Y7ZIaOuBYg==
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: make array spec_opcode static const, makes object smaller
Date:   Thu, 19 Aug 2021 12:58:13 +0100
Message-Id: <20210819115813.6692-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the array spec_opcode on the stack but instead it
static const. Makes the object code smaller by 158 bytes:

Before:
   text   data   bss     dec    hex filename
  12271   3976   128   16375   3ff7 .../hisilicon/hns3/hns3pf/hclge_cmd.o

After:
   text   data   bss     dec    hex filename
  12017   4072   128   16217   3f59 .../hisilicon/hns3/hns3pf/hclge_cmd.o

(gcc version 10.3.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../hisilicon/hns3/hns3pf/hclge_cmd.c         | 24 ++++++++++---------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
index 887297e37cf3..13042f1cac6f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.c
@@ -169,17 +169,19 @@ static bool hclge_is_special_opcode(u16 opcode)
 	/* these commands have several descriptors,
 	 * and use the first one to save opcode and return value
 	 */
-	u16 spec_opcode[] = {HCLGE_OPC_STATS_64_BIT,
-			     HCLGE_OPC_STATS_32_BIT,
-			     HCLGE_OPC_STATS_MAC,
-			     HCLGE_OPC_STATS_MAC_ALL,
-			     HCLGE_OPC_QUERY_32_BIT_REG,
-			     HCLGE_OPC_QUERY_64_BIT_REG,
-			     HCLGE_QUERY_CLEAR_MPF_RAS_INT,
-			     HCLGE_QUERY_CLEAR_PF_RAS_INT,
-			     HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT,
-			     HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT,
-			     HCLGE_QUERY_ALL_ERR_INFO};
+	static const u16 spec_opcode[] = {
+		HCLGE_OPC_STATS_64_BIT,
+		HCLGE_OPC_STATS_32_BIT,
+		HCLGE_OPC_STATS_MAC,
+		HCLGE_OPC_STATS_MAC_ALL,
+		HCLGE_OPC_QUERY_32_BIT_REG,
+		HCLGE_OPC_QUERY_64_BIT_REG,
+		HCLGE_QUERY_CLEAR_MPF_RAS_INT,
+		HCLGE_QUERY_CLEAR_PF_RAS_INT,
+		HCLGE_QUERY_CLEAR_ALL_MPF_MSIX_INT,
+		HCLGE_QUERY_CLEAR_ALL_PF_MSIX_INT,
+		HCLGE_QUERY_ALL_ERR_INFO
+	};
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(spec_opcode); i++) {
-- 
2.32.0

