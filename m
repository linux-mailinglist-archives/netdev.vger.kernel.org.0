Return-Path: <netdev+bounces-2663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23513702EA7
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 15:48:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D1943280D41
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 13:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70AF3D2EB;
	Mon, 15 May 2023 13:48:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664F2D2EA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 13:48:36 +0000 (UTC)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0513A19BA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:48:35 -0700 (PDT)
Received: from dggpemm500005.china.huawei.com (unknown [172.30.72.53])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4QKgf96JMdzLlkr;
	Mon, 15 May 2023 21:47:13 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500005.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 21:48:32 +0800
From: Hao Lan <lanhao@huawei.com>
To: <netdev@vger.kernel.org>
CC: <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
	<davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
	<pabeni@redhat.com>, <richardcochran@gmail.com>, <lanhao@huawei.com>,
	<wangpeiyang1@huawei.com>, <shenjian15@huawei.com>, <chenhao418@huawei.com>,
	<simon.horman@corigine.com>, <wangjie125@huawei.com>, <yuanjilin@cdjrlc.com>,
	<cai.huoqing@linux.dev>, <xiujianfeng@huawei.com>
Subject: [PATCH net-next 1/4] net: hns3: refine the tcam key convert handle
Date: Mon, 15 May 2023 21:46:40 +0800
Message-ID: <20230515134643.48314-2-lanhao@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230515134643.48314-1-lanhao@huawei.com>
References: <20230515134643.48314-1-lanhao@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Jian Shen <shenjian15@huawei.com>

The expression '(k ^ ~v)' is exaclty '(k & v)', and
'(k & v) & k' is exaclty 'k & v'. So simplify the
expression for tcam key convert.
(k ^ ~v) & k ==  (k & v) & k ==  k & k & v == k & v

It also add necessary brackets for them.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Hao Lan <lanhao@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 81aa6b0facf5..6a43d1515585 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -835,15 +835,10 @@ struct hclge_vf_vlan_cfg {
  * Then for input key(k) and mask(v), we can calculate the value by
  * the formulae:
  *	x = (~k) & v
- *	y = (k ^ ~v) & k
+ *	y = k & v
  */
-#define calc_x(x, k, v) (x = ~(k) & (v))
-#define calc_y(y, k, v) \
-	do { \
-		const typeof(k) _k_ = (k); \
-		const typeof(v) _v_ = (v); \
-		(y) = (_k_ ^ ~_v_) & (_k_); \
-	} while (0)
+#define calc_x(x, k, v) ((x) = ~(k) & (v))
+#define calc_y(y, k, v) ((y) = (k) & (v))
 
 #define HCLGE_MAC_STATS_FIELD_OFF(f) (offsetof(struct hclge_mac_stats, f))
 #define HCLGE_STATS_READ(p, offset) (*(u64 *)((u8 *)(p) + (offset)))
-- 
2.30.0


