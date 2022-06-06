Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFDA53EA18
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 19:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239379AbiFFN4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 09:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239368AbiFFN4B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 09:56:01 -0400
Received: from mail.nfschina.com (unknown [IPv6:2400:dd01:100f:2:72e2:84ff:fe10:5f45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4317113D38;
        Mon,  6 Jun 2022 06:56:00 -0700 (PDT)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 9458B1E80D76;
        Mon,  6 Jun 2022 21:55:48 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id r0ZZjdADiD8D; Mon,  6 Jun 2022 21:55:46 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 5A8F81E80D27;
        Mon,  6 Jun 2022 21:55:45 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Li Qiong <liqiong@nfschina.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yuzhe@nfschina.com,
        renyu@nfschina.com
Subject: [PATCH 2/2] mwl8k: use time_after to replace "jiffies > a"
Date:   Mon,  6 Jun 2022 21:54:49 +0800
Message-Id: <20220606135449.23256-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

time_after deals with timer wrapping correctly.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 drivers/net/wireless/marvell/mwl8k.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 864a2ba9efee..2dfb8c10bb57 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -1880,7 +1880,7 @@ static inline void mwl8k_tx_count_packet(struct ieee80211_sta *sta, u8 tid)
 	 * packets ever exceeds the ampdu_min_traffic threshold, we will allow
 	 * an ampdu stream to be started.
 	 */
-	if (jiffies - tx_stats->start_time > HZ) {
+	if (time_after(jiffies, (unsigned long)tx_stats->start_time + HZ)) {
 		tx_stats->pkts = 0;
 		tx_stats->start_time = 0;
 	} else
-- 
2.25.1

