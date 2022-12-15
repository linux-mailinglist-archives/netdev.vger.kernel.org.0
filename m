Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD9564DF15
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 17:56:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiLOQ4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 11:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbiLOQ4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 11:56:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CE6E088;
        Thu, 15 Dec 2022 08:56:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D5C1B81C03;
        Thu, 15 Dec 2022 16:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E0BC433EF;
        Thu, 15 Dec 2022 16:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671123359;
        bh=tVhkH/FcY9gESy+V3xeK947kCGObkEYr+sAE3pHakis=;
        h=From:To:Cc:Subject:Date:From;
        b=LXoIjw5ra7kHRbvYTXP6NigITE4JtnJBxLDqJvA4kbg7jKh7PCVIvaWKZXXlEpAA+
         Ha1v4BRa9Gnf6/ruDAN2j/Y/EXBz65z2x77sh3ozb/BZoeP263lObyomW2MW75Rqcr
         vd0uZ6dtjPt3xtmRkG5sSdNQ3v+0FWP8UtQ9YCYnXzb+5QzogKJOfxyaLbZ1thQayo
         lWfWdEIsOCy8HMjoI+z68/JlRbUVoxxgC2y8rFRfUZ7ofb3ujdTtH90M0KxjoJ8rXb
         wqQ1Qj5F2Uni/kMo6MwlxGch9dneycHhG96i0Qglyy8DH+ufc+U6+CH3Vqcsz2/qUh
         2Yumvup4npcjw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>,
        Pavel Skripkin <paskripkin@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ath9k: use proper statements in conditionals
Date:   Thu, 15 Dec 2022 17:55:42 +0100
Message-Id: <20221215165553.1950307-1-arnd@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

A previous cleanup patch accidentally broke some conditional
expressions by replacing the safe "do {} while (0)" constructs
with empty macros. gcc points this out when extra warnings
are enabled:

drivers/net/wireless/ath/ath9k/hif_usb.c: In function 'ath9k_skb_queue_complete':
drivers/net/wireless/ath/ath9k/hif_usb.c:251:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
  251 |                         TX_STAT_INC(hif_dev, skb_failed);

Make both sets of macros proper expressions again.

Fixes: d7fc76039b74 ("ath9k: htc: clean up statistics macros")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath9k/htc.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 30f0765fb9fd..237f4ec2cffd 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -327,9 +327,9 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-#define __STAT_SAFE(hif_dev, expr)	((hif_dev)->htc_handle->drv_priv ? (expr) : 0)
-#define CAB_STAT_INC(priv)		((priv)->debug.tx_stats.cab_queued++)
-#define TX_QSTAT_INC(priv, q)		((priv)->debug.tx_stats.queue_stats[q]++)
+#define __STAT_SAFE(hif_dev, expr)	do { ((hif_dev)->htc_handle->drv_priv ? (expr) : 0); } while (0)
+#define CAB_STAT_INC(priv)		do { ((priv)->debug.tx_stats.cab_queued++); } while (0)
+#define TX_QSTAT_INC(priv, q)		do { ((priv)->debug.tx_stats.queue_stats[q]++); } while (0)
 
 #define TX_STAT_INC(hif_dev, c) \
 		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c++)
@@ -378,10 +378,10 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 			    struct ethtool_stats *stats, u64 *data);
 #else
 
-#define TX_STAT_INC(hif_dev, c)
-#define TX_STAT_ADD(hif_dev, c, a)
-#define RX_STAT_INC(hif_dev, c)
-#define RX_STAT_ADD(hif_dev, c, a)
+#define TX_STAT_INC(hif_dev, c)		do { } while (0)
+#define TX_STAT_ADD(hif_dev, c, a)	do { } while (0)
+#define RX_STAT_INC(hif_dev, c)		do { } while (0)
+#define RX_STAT_ADD(hif_dev, c, a)	do { } while (0)
 
 #define CAB_STAT_INC(priv)
 #define TX_QSTAT_INC(priv, c)
-- 
2.35.1

