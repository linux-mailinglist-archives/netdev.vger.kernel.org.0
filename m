Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC2096C1B3F
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:21:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbjCTQVt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbjCTQVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:21:33 -0400
Received: from smtp.smtpout.orange.fr (smtp-21.smtpout.orange.fr [80.12.242.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D39E7EDB
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 09:14:13 -0700 (PDT)
Received: from localhost.localdomain ([109.190.253.11])
        by smtp.orange.fr with ESMTPA
        id eI9ApRTg9HAQ0eI9Bp8cwS; Mon, 20 Mar 2023 17:14:11 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 20 Mar 2023 17:14:11 +0100
X-ME-IP: 109.190.253.11
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH net-next] rsi: Slightly simplify rsi_set_channel()
Date:   Mon, 20 Mar 2023 17:13:42 +0100
Message-Id: <29bf0296bd939e3f6952272bfdcc73b22edbc374.1679328588.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no point in allocating 'skb' and then freeing it if !channel.

Make the sanity check first to slightly simplify the code.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c14689266fec..be9ac252f804 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -1127,6 +1127,9 @@ int rsi_set_channel(struct rsi_common *common,
 	rsi_dbg(MGMT_TX_ZONE,
 		"%s: Sending scan req frame\n", __func__);
 
+	if (!channel)
+		return 0;
+
 	skb = dev_alloc_skb(frame_len);
 	if (!skb) {
 		rsi_dbg(ERR_ZONE, "%s: Failed in allocation of skb\n",
@@ -1134,10 +1137,6 @@ int rsi_set_channel(struct rsi_common *common,
 		return -ENOMEM;
 	}
 
-	if (!channel) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
 	memset(skb->data, 0, frame_len);
 	chan_cfg = (struct rsi_chan_config *)skb->data;
 
-- 
2.32.0

