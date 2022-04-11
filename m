Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E5A4FB198
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 04:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbiDKCLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 22:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbiDKCLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 22:11:10 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9800C1AD89;
        Sun, 10 Apr 2022 19:08:57 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4KcC0W6PZwzgYZ2;
        Mon, 11 Apr 2022 10:07:07 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 11 Apr
 2022 10:08:55 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <quic_cjhuang@quicinc.com>,
        <quic_bqiang@quicinc.com>
CC:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath11k: Fix build warning without CONFIG_IPV6
Date:   Mon, 11 Apr 2022 10:08:43 +0800
Message-ID: <20220411020843.10284-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wireless/ath/ath11k/mac.c:8175:13: error: ‘ath11k_mac_op_ipv6_changed’ defined but not used [-Werror=unused-function]
 static void ath11k_mac_op_ipv6_changed(struct ieee80211_hw *hw,
             ^~~~~~~~~~~~~~~~~~~~~~~~~~

Wrap it with #ifdef block to fix this.

Fixes: c3c36bfe998b ("ath11k: support ARP and NS offload")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index ca998fb13b62..18a2994b6d85 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8151,6 +8151,7 @@ static void ath11k_mac_op_sta_statistics(struct ieee80211_hw *hw,
 	}
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static void ath11k_generate_ns_mc_addr(struct ath11k *ar,
 				       struct ath11k_arp_ns_offload *offload)
 {
@@ -8245,6 +8246,7 @@ static void ath11k_mac_op_ipv6_changed(struct ieee80211_hw *hw,
 	/* generate ns multicast address */
 	ath11k_generate_ns_mc_addr(ar, offload);
 }
+#endif
 
 static void ath11k_mac_op_set_rekey_data(struct ieee80211_hw *hw,
 					 struct ieee80211_vif *vif,
-- 
2.17.1

