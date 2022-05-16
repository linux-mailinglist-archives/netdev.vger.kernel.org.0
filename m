Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD72527C4C
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 05:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239601AbiEPDYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 May 2022 23:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235755AbiEPDYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 May 2022 23:24:03 -0400
Received: from mail.meizu.com (edge01.meizu.com [14.29.68.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FCC19F96;
        Sun, 15 May 2022 20:24:01 -0700 (PDT)
Received: from IT-EXMB-1-125.meizu.com (172.16.1.125) by mz-mail04.meizu.com
 (172.16.1.16) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 16 May
 2022 11:24:02 +0800
Received: from meizu.meizu.com (172.16.137.70) by IT-EXMB-1-125.meizu.com
 (172.16.1.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.14; Mon, 16 May
 2022 11:23:59 +0800
From:   Haowen Bai <baihaowen@meizu.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
CC:     Haowen Bai <baihaowen@meizu.com>, <ath11k@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] ath11k: Fix pointer dereferenced before checking
Date:   Mon, 16 May 2022 11:23:56 +0800
Message-ID: <1652671437-20235-1-git-send-email-baihaowen@meizu.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.137.70]
X-ClientProxiedBy: IT-EXMB-1-126.meizu.com (172.16.1.126) To
 IT-EXMB-1-125.meizu.com (172.16.1.125)
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pointer sspec is dereferencing pointer sar before sar is being
null checked. Fix this by assigning sar->sub_specs to sspec only if
sar is not NULL, otherwise just NULL. The code has checked sar whether
it is NULL or not as below, but use before checking.

Signed-off-by: Haowen Bai <baihaowen@meizu.com>
---
 drivers/net/wireless/ath/ath11k/mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1957e1713548..fe97c9a3c1c5 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -8287,7 +8287,7 @@ static int ath11k_mac_op_set_bios_sar_specs(struct ieee80211_hw *hw,
 					    const struct cfg80211_sar_specs *sar)
 {
 	struct ath11k *ar = hw->priv;
-	const struct cfg80211_sar_sub_specs *sspec = sar->sub_specs;
+	const struct cfg80211_sar_sub_specs *sspec = sar ? sar->sub_specs : NULL;
 	int ret, index;
 	u8 *sar_tbl;
 	u32 i;
-- 
2.7.4

