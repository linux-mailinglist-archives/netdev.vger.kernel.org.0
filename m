Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8F26EFBDC
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 22:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239716AbjDZUtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 16:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235048AbjDZUtG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 16:49:06 -0400
Received: from smtp.smtpout.orange.fr (smtp-20.smtpout.orange.fr [80.12.242.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF90114
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 13:49:04 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
        by smtp.orange.fr with ESMTPA
        id rm4TpH0Nn0CGGrm4TpqSEV; Wed, 26 Apr 2023 22:49:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
        s=t20230301; t=1682542142;
        bh=kp67nxVyh8jZZFZ6p2tHHUiB/eOzKLK57FZQrJ+46xQ=;
        h=From:To:Cc:Subject:Date;
        b=ON2127XtGpB/s0nIKPSntB5hb2UXPGUjJbG0gWF4olqVv8Hsoq17f2CVZnTAqGjPb
         qjEtnnos6bjixkIl2xHm7tJtBGnev6CIXjI+r/RBc8dW7NbISsUDUB7NnFCE6KypH0
         lIxOQngLIcbBA0anyIK6DzecaH3umtqq7zENdXUXclYTy/DKWymYNq+2xETADox2Ln
         6JknIAoEWjhca/1nWp+t0OEBIqnT9ohbdJV9S/ITns9T4XEIYLR/ptN58mKZkhsf7e
         VCh/NJUXID8JMFj3swQEOh/pTUdav3oHh8fzy8uS4VOPC6FU2an3wKS4a6G2DNd03G
         A+n8GaFpsjuBA==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Wed, 26 Apr 2023 22:49:02 +0200
X-ME-IP: 86.243.2.178
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] wifi: ath11k: Use list_count_nodes()
Date:   Wed, 26 Apr 2023 22:48:59 +0200
Message-Id: <941484caae24b89d20524b1a5661dd1fd7025492.1682542084.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ath11k_wmi_fw_stats_num_vdevs() and ath11k_wmi_fw_stats_num_bcn() really
look the same as list_count_nodes(), so use the latter instead of hand
writing it.

The first ones use list_for_each_entry() and the other list_for_each(), but
they both count the number of nodes in the list.

While at it, also remove to prototypes of non-existent functions.
Based on the names and prototypes, it is likely that they should be
equivalent to list_count_nodes().

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Un-tested
---
 drivers/net/wireless/ath/ath11k/wmi.c | 24 +-----------------------
 drivers/net/wireless/ath/ath11k/wmi.h |  3 ---
 2 files changed, 1 insertion(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/wmi.c b/drivers/net/wireless/ath/ath11k/wmi.c
index d0b59bc2905a..a55b5fe37ecf 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.c
+++ b/drivers/net/wireless/ath/ath11k/wmi.c
@@ -6548,28 +6548,6 @@ int ath11k_wmi_pull_fw_stats(struct ath11k_base *ab, struct sk_buff *skb,
 				   &parse);
 }
 
-size_t ath11k_wmi_fw_stats_num_vdevs(struct list_head *head)
-{
-	struct ath11k_fw_stats_vdev *i;
-	size_t num = 0;
-
-	list_for_each_entry(i, head, list)
-		++num;
-
-	return num;
-}
-
-static size_t ath11k_wmi_fw_stats_num_bcn(struct list_head *head)
-{
-	struct ath11k_fw_stats_bcn *i;
-	size_t num = 0;
-
-	list_for_each_entry(i, head, list)
-		++num;
-
-	return num;
-}
-
 static void
 ath11k_wmi_fw_pdev_base_stats_fill(const struct ath11k_fw_stats_pdev *pdev,
 				   char *buf, u32 *length)
@@ -6880,7 +6858,7 @@ void ath11k_wmi_fw_stats_fill(struct ath11k *ar,
 	}
 
 	if (stats_id == WMI_REQUEST_BCN_STAT) {
-		num_bcn = ath11k_wmi_fw_stats_num_bcn(&fw_stats->bcn);
+		num_bcn = list_count_nodes(&fw_stats->bcn);
 
 		len += scnprintf(buf + len, buf_len - len, "\n");
 		len += scnprintf(buf + len, buf_len - len, "%30s (%zu)\n",
diff --git a/drivers/net/wireless/ath/ath11k/wmi.h b/drivers/net/wireless/ath/ath11k/wmi.h
index 92fddb77669c..91bc3e648ce1 100644
--- a/drivers/net/wireless/ath/ath11k/wmi.h
+++ b/drivers/net/wireless/ath/ath11k/wmi.h
@@ -6372,9 +6372,6 @@ int ath11k_wmi_send_pdev_set_regdomain(struct ath11k *ar,
 				       struct pdev_set_regdomain_params *param);
 int ath11k_wmi_pull_fw_stats(struct ath11k_base *ab, struct sk_buff *skb,
 			     struct ath11k_fw_stats *stats);
-size_t ath11k_wmi_fw_stats_num_peers(struct list_head *head);
-size_t ath11k_wmi_fw_stats_num_peers_extd(struct list_head *head);
-size_t ath11k_wmi_fw_stats_num_vdevs(struct list_head *head);
 void ath11k_wmi_fw_stats_fill(struct ath11k *ar,
 			      struct ath11k_fw_stats *fw_stats, u32 stats_id,
 			      char *buf);
-- 
2.34.1

