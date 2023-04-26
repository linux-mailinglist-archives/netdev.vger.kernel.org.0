Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0A66EFBE3
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239848AbjDZUtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239894AbjDZUtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:49:20 -0400
Received: from smtp.smtpout.orange.fr (smtp-17.smtpout.orange.fr [80.12.242.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F5C2708
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:49:16 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id rm4bp1ti14BqCrm4bpKuv9; Wed, 26 Apr 2023 22:49:15 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682542155;
        bh=Rd8MEII6gS22N52uLm/8OT5mzUNWj2Lr1oquvlwAI8Y=;
        h=From:To:Cc:Subject:Date;
        b=llYRWeZ1TtlP7PRM2wkHHJ9r6eDGdOj7BMb52xhXACqlpMY+QR4IGAj3X1fTXAzrT
         secuIsC9KlnlyiSWoGB7ACzwIt8avoDfilk3BG5Ry81fQbsEaDWHCV4STQ3VPScFOX
         9etnPOo0V2hMjPRZ99/uxMw0hYxIeTeT6BYbvgU7otwD4RpBLI0pwbOquxhdbNUygo
         w8t9TbdjzzS0wjO1CEZdOx/uyUJSkitdTK5ShQsXY0HDENv2qcrsoGM7/PVz/xNjn0
         M1LRo7OnaCmrIxWBxHYui8NxIH5ZG5p5yGuyMjAS1ij1t9WhpwYBqmd+AE8zHQBSie
         4KHHzL46TCBDw==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 26 Apr 2023 22:49:15 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] wifi: ath10k: Use list_count_nodes()
Date:   Wed, 26 Apr 2023 22:49:07 +0200
Message-Id: <e6ec525c0c5057e97e33a63f8a4aa482e5c2da7f.1682541872.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath10k_wmi_fw_stats_num_peers() and ath10k_wmi_fw_stats_num_vdevs() really
look the same as list_count_nodes(), so use the latter instead of hand
writing it.

The first ones use list_for_each_entry() and the other list_for_each(), but
they both count the number of nodes in the list.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Un-tested
---
 drivers/net/wireless/ath/ath10k/debug.c |  4 +--
 drivers/net/wireless/ath/ath10k/wmi.c   | 34 +++++--------------------
 drivers/net/wireless/ath/ath10k/wmi.h   |  2 --
 3 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/debug.c b/drivers/net/wireless/ath/ath10k/debug.c
index b9aea1510f7b..f9518e1c9903 100644
--- a/drivers/net/wireless/ath/ath10k/debug.c
+++ b/drivers/net/wireless/ath/ath10k/debug.c
@@ -293,8 +293,8 @@ void ath10k_debug_fw_stats_process(struct ath10k *ar, struct sk_buff *skb)
 		goto free;
 	}
 
-	num_peers = ath10k_wmi_fw_stats_num_peers(&ar->debug.fw_stats.peers);
-	num_vdevs = ath10k_wmi_fw_stats_num_vdevs(&ar->debug.fw_stats.vdevs);
+	num_peers = list_count_nodes(&ar->debug.fw_stats.peers);
+	num_vdevs = list_count_nodes(&ar->debug.fw_stats.vdevs);
 	is_start = (list_empty(&ar->debug.fw_stats.pdevs) &&
 		    !list_empty(&stats.pdevs));
 	is_end = (!list_empty(&ar->debug.fw_stats.pdevs) &&
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 980d4124fa28..05fa7d4c0e1a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -8164,28 +8164,6 @@ ath10k_wmi_10_2_4_op_gen_pdev_get_tpc_config(struct ath10k *ar, u32 param)
 	return skb;
 }
 
-size_t ath10k_wmi_fw_stats_num_peers(struct list_head *head)
-{
-	struct ath10k_fw_stats_peer *i;
-	size_t num = 0;
-
-	list_for_each_entry(i, head, list)
-		++num;
-
-	return num;
-}
-
-size_t ath10k_wmi_fw_stats_num_vdevs(struct list_head *head)
-{
-	struct ath10k_fw_stats_vdev *i;
-	size_t num = 0;
-
-	list_for_each_entry(i, head, list)
-		++num;
-
-	return num;
-}
-
 static void
 ath10k_wmi_fw_pdev_base_stats_fill(const struct ath10k_fw_stats_pdev *pdev,
 				   char *buf, u32 *length)
@@ -8462,8 +8440,8 @@ void ath10k_wmi_main_op_fw_stats_fill(struct ath10k *ar,
 		goto unlock;
 	}
 
-	num_peers = ath10k_wmi_fw_stats_num_peers(&fw_stats->peers);
-	num_vdevs = ath10k_wmi_fw_stats_num_vdevs(&fw_stats->vdevs);
+	num_peers = list_count_nodes(&fw_stats->peers);
+	num_vdevs = list_count_nodes(&fw_stats->vdevs);
 
 	ath10k_wmi_fw_pdev_base_stats_fill(pdev, buf, &len);
 	ath10k_wmi_fw_pdev_tx_stats_fill(pdev, buf, &len);
@@ -8520,8 +8498,8 @@ void ath10k_wmi_10x_op_fw_stats_fill(struct ath10k *ar,
 		goto unlock;
 	}
 
-	num_peers = ath10k_wmi_fw_stats_num_peers(&fw_stats->peers);
-	num_vdevs = ath10k_wmi_fw_stats_num_vdevs(&fw_stats->vdevs);
+	num_peers = list_count_nodes(&fw_stats->peers);
+	num_vdevs = list_count_nodes(&fw_stats->vdevs);
 
 	ath10k_wmi_fw_pdev_base_stats_fill(pdev, buf, &len);
 	ath10k_wmi_fw_pdev_extra_stats_fill(pdev, buf, &len);
@@ -8668,8 +8646,8 @@ void ath10k_wmi_10_4_op_fw_stats_fill(struct ath10k *ar,
 		goto unlock;
 	}
 
-	num_peers = ath10k_wmi_fw_stats_num_peers(&fw_stats->peers);
-	num_vdevs = ath10k_wmi_fw_stats_num_vdevs(&fw_stats->vdevs);
+	num_peers = list_count_nodes(&fw_stats->peers);
+	num_vdevs = list_count_nodes(&fw_stats->vdevs);
 
 	ath10k_wmi_fw_pdev_base_stats_fill(pdev, buf, &len);
 	ath10k_wmi_fw_pdev_extra_stats_fill(pdev, buf, &len);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 6de3cc4640a0..6d04a66fe5e0 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -7502,8 +7502,6 @@ void ath10k_wmi_main_op_fw_stats_fill(struct ath10k *ar,
 void ath10k_wmi_10x_op_fw_stats_fill(struct ath10k *ar,
 				     struct ath10k_fw_stats *fw_stats,
 				     char *buf);
-size_t ath10k_wmi_fw_stats_num_peers(struct list_head *head);
-size_t ath10k_wmi_fw_stats_num_vdevs(struct list_head *head);
 void ath10k_wmi_10_4_op_fw_stats_fill(struct ath10k *ar,
 				      struct ath10k_fw_stats *fw_stats,
 				      char *buf);
-- 
2.34.1

