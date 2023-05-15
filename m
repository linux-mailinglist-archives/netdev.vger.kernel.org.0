Return-Path: <netdev+bounces-2557-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7742C70280C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B8FE1C20AB1
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:14:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F5A5A935;
	Mon, 15 May 2023 09:14:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A33883A
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:14:07 +0000 (UTC)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 131F2272D;
	Mon, 15 May 2023 02:14:00 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.57])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4QKYTx1CBjzqSV0;
	Mon, 15 May 2023 17:09:41 +0800 (CST)
Received: from huawei.com (10.175.101.6) by dggpeml500026.china.huawei.com
 (7.185.36.106) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Mon, 15 May
 2023 17:13:58 +0800
From: Zhengchao Shao <shaozhengchao@huawei.com>
To: <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<johannes@sipsolutions.net>, <kvalo@kernel.org>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC: <jaewan@google.com>, <steen.hegelund@microchip.com>,
	<weiyongjun1@huawei.com>, <yuehaibing@huawei.com>,
	<shaozhengchao@huawei.com>,
	<syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com>
Subject: [PATCH net-next,v2] mac80211_hwsim: fix memory leak in hwsim_new_radio_nl
Date: Mon, 15 May 2023 17:22:27 +0800
Message-ID: <20230515092227.2691437-1-shaozhengchao@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

When parse_pmsr_capa failed in hwsim_new_radio_nl, the memory resources
applied for by pmsr_capa are not released. Add release processing to the
incorrect path.

Fixes: 92d13386ec55 ("mac80211_hwsim: add PMSR capability support")
Reported-by: syzbot+904ce6fbb38532d9795c@syzkaller.appspotmail.com
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
---
v2: move the value assigned to pmsr_capa before parse_pmsr_capa
---
 drivers/net/wireless/virtual/mac80211_hwsim.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
index 9a8faaf4c6b6..89c7a1420381 100644
--- a/drivers/net/wireless/virtual/mac80211_hwsim.c
+++ b/drivers/net/wireless/virtual/mac80211_hwsim.c
@@ -5964,10 +5964,11 @@ static int hwsim_new_radio_nl(struct sk_buff *msg, struct genl_info *info)
 			ret = -ENOMEM;
 			goto out_free;
 		}
+		param.pmsr_capa = pmsr_capa;
+
 		ret = parse_pmsr_capa(info->attrs[HWSIM_ATTR_PMSR_SUPPORT], pmsr_capa, info);
 		if (ret)
 			goto out_free;
-		param.pmsr_capa = pmsr_capa;
 	}
 
 	ret = mac80211_hwsim_new_radio(info, &param);
-- 
2.34.1


