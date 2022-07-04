Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47B53565666
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 15:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234649AbiGDNDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 09:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiGDNDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 09:03:03 -0400
Received: from smtp.smtpout.orange.fr (smtp07.smtpout.orange.fr [80.12.242.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90286BC1E
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 06:03:00 -0700 (PDT)
Received: from pop-os.home ([90.11.190.129])
        by smtp.orange.fr with ESMTPA
        id 8Lj7okCqDJcJL8Lj7oTUN6; Mon, 04 Jul 2022 15:02:58 +0200
X-ME-Helo: pop-os.home
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Mon, 04 Jul 2022 15:02:58 +0200
X-ME-IP: 90.11.190.129
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] p54: Use the bitmap API to allocate bitmaps
Date:   Mon,  4 Jul 2022 15:02:55 +0200
Message-Id: <2755b8b7d85a2db0663d39ea6df823f94f3401b3.1656939750.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.

It is less verbose and it improves the semantic.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/intersil/p54/fwio.c | 6 ++----
 drivers/net/wireless/intersil/p54/main.c | 2 +-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/fwio.c b/drivers/net/wireless/intersil/p54/fwio.c
index bece14e4ff0d..b52cce38115d 100644
--- a/drivers/net/wireless/intersil/p54/fwio.c
+++ b/drivers/net/wireless/intersil/p54/fwio.c
@@ -173,10 +173,8 @@ int p54_parse_firmware(struct ieee80211_hw *dev, const struct firmware *fw)
 		 * keeping a extra list for uploaded keys.
 		 */
 
-		priv->used_rxkeys = kcalloc(BITS_TO_LONGS(priv->rx_keycache_size),
-					    sizeof(long),
-					    GFP_KERNEL);
-
+		priv->used_rxkeys = bitmap_zalloc(priv->rx_keycache_size,
+						  GFP_KERNEL);
 		if (!priv->used_rxkeys)
 			return -ENOMEM;
 	}
diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index 115be1f3f33d..c1e1711382a7 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -830,7 +830,7 @@ void p54_free_common(struct ieee80211_hw *dev)
 	kfree(priv->output_limit);
 	kfree(priv->curve_data);
 	kfree(priv->rssi_db);
-	kfree(priv->used_rxkeys);
+	bitmap_free(priv->used_rxkeys);
 	kfree(priv->survey);
 	priv->iq_autocal = NULL;
 	priv->output_limit = NULL;
-- 
2.34.1

