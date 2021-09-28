Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3D2E41AB4D
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 10:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239828AbhI1JA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 05:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239784AbhI1JAq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 05:00:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DCD7861159;
        Tue, 28 Sep 2021 08:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632819546;
        bh=en7nVuj1sD+c8w9l7DbdzPI52yWs3ggAogVXkWmvTkg=;
        h=From:To:Cc:Subject:Date:From;
        b=d5Y/AYoGL1EaP0pg+ceT4RUNJ6EK7jtDoYxjgnhzt1s1haQvBmUFKmLUNs/8AfkRK
         dI00AA5kV7G74I0l7974dEAxLE5ol/gE9OO2Ox2OLoFtqlpREQ2JOy3PCoEtHfG7Gq
         S8rchhmS181CHTO6dyb+z3QmIGYI7NgbU6HPfDR+PrNqaAhUvi4ps+gQHpX2Bp5egS
         7ZL5iKUdeE2iS+QTNXZ4e7MplHs5bdaRCl5Z8r3lKfnNasXnPOtfBpslyGuu7nYq3F
         WNYUMp9buu7u25bl/QLf6CrIsgb9ZLllwtICTdu2Cl/P55r6wUzlxA8UqQtPrqrnTo
         J9HTLrrXn5APw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>,
        Jian Shen <shenjian15@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] net: hns3: fix hclge_dbg_dump_tm_pg() stack usage
Date:   Tue, 28 Sep 2021 10:58:34 +0200
Message-Id: <20210928085900.2394697-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This function copies strings around between multiple buffers
including a large on-stack array that causes a build warning
on 32-bit systems:

drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c: In function 'hclge_dbg_dump_tm_pg':
drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c:782:1: error: the frame size of 1424 bytes is larger than 1400 bytes [-Werror=frame-larger-than=]

The function can probably be cleaned up a lot, to go back to
printing directly into the output buffer, but dynamically allocating
the structure is a simpler workaround for now.

Fixes: 04d96139ddb3 ("net: hns3: refine function hclge_dbg_dump_tm_pri()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Changes in v2:
 - rearrange local variable as suggested by huangguangbin
---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 28 ++++++++++++++++---
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 87d96f82c318..32f62cd2dd99 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -719,9 +719,9 @@ static void hclge_dbg_fill_shaper_content(struct hclge_tm_shaper_para *para,
 	sprintf(result[(*index)++], "%6u", para->rate);
 }
 
-static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
+static int __hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *data_str,
+				  char *buf, int len)
 {
-	char data_str[ARRAY_SIZE(tm_pg_items)][HCLGE_DBG_DATA_STR_LEN];
 	struct hclge_tm_shaper_para c_shaper_para, p_shaper_para;
 	char *result[ARRAY_SIZE(tm_pg_items)], *sch_mode_str;
 	u8 pg_id, sch_mode, weight, pri_bit_map, i, j;
@@ -729,8 +729,10 @@ static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
 	int pos = 0;
 	int ret;
 
-	for (i = 0; i < ARRAY_SIZE(tm_pg_items); i++)
-		result[i] = &data_str[i][0];
+	for (i = 0; i < ARRAY_SIZE(tm_pg_items); i++) {
+		result[i] = data_str;
+		data_str += HCLGE_DBG_DATA_STR_LEN;
+	}
 
 	hclge_dbg_fill_content(content, sizeof(content), tm_pg_items,
 			       NULL, ARRAY_SIZE(tm_pg_items));
@@ -781,6 +783,24 @@ static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
 	return 0;
 }
 
+static int hclge_dbg_dump_tm_pg(struct hclge_dev *hdev, char *buf, int len)
+{
+	char *data_str;
+	int ret;
+
+	data_str = kcalloc(ARRAY_SIZE(tm_pg_items),
+			   HCLGE_DBG_DATA_STR_LEN, GFP_KERNEL);
+
+	if (!data_str)
+		return -ENOMEM;
+
+	ret = __hclge_dbg_dump_tm_pg(hdev, data_str, buf, len);
+
+	kfree(data_str);
+
+	return ret;
+}
+
 static int hclge_dbg_dump_tm_port(struct hclge_dev *hdev,  char *buf, int len)
 {
 	struct hclge_tm_shaper_para shaper_para;
-- 
2.29.2

