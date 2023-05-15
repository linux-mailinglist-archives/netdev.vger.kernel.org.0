Return-Path: <netdev+bounces-2665-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E561702EAA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59F792812C5
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C07C8FC;
	Mon, 15 May 2023 13:48:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C735D507
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:48:38 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD28A10F1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:48:36 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.55])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QKgdS2hS3zsRsg;
	Mon, 15 May 2023 21:46:36 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 21:48:34 +0800
From: Hao Lan <lanhao@huawei.com>
To: <netdev@vger.kernel.org>
CC: <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <lanhao@huawei.com>,
	<wangpeiyang1@huawei.com>, <shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<simon.horman@corigine.com>, <wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>,
	<cai.huoqing@linux.dev>, <xiujianfeng@huawei.com>
Subject: [PATCH net-next 3/4] net: hns3: fix strncpy() not using dest-buf length as length issue
Date: Mon, 15 May 2023 21:46:42 +0800
Message-ID: <20230515134643.48314-4-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230515134643.48314-1-lanhao@huawei.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Hao Chen <chenhao418@huawei.com>

Now, strncpy() in hns3_dbg_fill_content() use src-length as copy-length,
it may result in dest-buf overflow.

This patch is to fix intel compile warning for csky-linux-gcc (GCC) 12.1.0
compiler.

The warning reports as below:

hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on
the length of the source argument [-Wstringop-truncation]

strncpy(pos, items[i].name, strlen(items[i].name));

hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before
terminating nul copying as many bytes from a string as its length
[-Wstringop-truncation]

strncpy(pos, result[i], strlen(result[i]));

strncpy() use src-length as copy-length, it may result in
dest-buf overflow.

So,this patch add some values check to avoid this issue.

Signed-off-by: Hao Chen <chenhao418@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/lkml/202207170606.7WtHs9yS-lkp@intel.com/T/
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 .../ethernet/hisilicon/hns3/hns3_debugfs.c    | 31 ++++++++++++++-----
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 29 ++++++++++++++---
 2 files changed, 48 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
index 4c3e90a1c4d0..cf415cb37685 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_debugfs.c
@@ -438,19 +438,36 @@ static void hns3_dbg_fill_content(char *content, u16 len,
 				  const struct hns3_dbg_item *items,
 				  const char **result, u16 size)
 {
+#define HNS3_DBG_LINE_END_LEN	2
 	char *pos = content;
+	u16 item_len;
 	u16 i;
 
+	if (!len) {
+		return;
+	} else if (len <= HNS3_DBG_LINE_END_LEN) {
+		*pos++ = '\0';
+		return;
+	}
+
 	memset(content, ' ', len);
-	for (i = 0; i < size; i++) {
-		if (result)
-			strncpy(pos, result[i], strlen(result[i]));
-		else
-			strncpy(pos, items[i].name, strlen(items[i].name));
+	len -= HNS3_DBG_LINE_END_LEN;
 
-		pos += strlen(items[i].name) + items[i].interval;
+	for (i = 0; i < size; i++) {
+		item_len = strlen(items[i].name) + items[i].interval;
+		if (len < item_len)
+			break;
+
+		if (result) {
+			if (item_len < strlen(result[i]))
+				break;
+			memcpy(pos, result[i], strlen(result[i]));
+		} else {
+			memcpy(pos, items[i].name, strlen(items[i].name));
+		}
+		pos += item_len;
+		len -= item_len;
 	}
-
 	*pos++ = '\n';
 	*pos++ = '\0';
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index a0b46e7d863e..1354fd0461f7 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -88,16 +88,35 @@ static void hclge_dbg_fill_content(char *content, u16 len,
 				   const struct hclge_dbg_item *items,
 				   const char **result, u16 size)
 {
+#define HCLGE_DBG_LINE_END_LEN	2
 	char *pos = content;
+	u16 item_len;
 	u16 i;
 
+	if (!len) {
+		return;
+	} else if (len <= HCLGE_DBG_LINE_END_LEN) {
+		*pos++ = '\0';
+		return;
+	}
+
 	memset(content, ' ', len);
+	len -= HCLGE_DBG_LINE_END_LEN;
+
 	for (i = 0; i < size; i++) {
-		if (result)
-			strncpy(pos, result[i], strlen(result[i]));
-		else
-			strncpy(pos, items[i].name, strlen(items[i].name));
-		pos += strlen(items[i].name) + items[i].interval;
+		item_len = strlen(items[i].name) + items[i].interval;
+		if (len < item_len)
+			break;
+
+		if (result) {
+			if (item_len < strlen(result[i]))
+				break;
+			memcpy(pos, result[i], strlen(result[i]));
+		} else {
+			memcpy(pos, items[i].name, strlen(items[i].name));
+		}
+		pos += item_len;
+		len -= item_len;
 	}
 	*pos++ = '\n';
 	*pos++ = '\0';
-- 
2.30.0


