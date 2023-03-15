Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FED86BBDE7
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 21:22:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbjCOUWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 16:22:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbjCOUWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 16:22:33 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43A9A0F34;
        Wed, 15 Mar 2023 13:22:22 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.16])
        by mail.ispras.ru (Postfix) with ESMTPSA id B6F5E44C1011;
        Wed, 15 Mar 2023 20:22:20 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru B6F5E44C1011
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1678911740;
        bh=OrnpI5NnHl+YmfKjeyUc8fbO91ALa8VLak03DsUl8sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoRg1+hQUtvvsjxslFN50LmZFPjj1sU/YtGyrYoBzGx8lrHunJ5uyZfMyiP+WStSZ
         68sT46/hEdpFbadO4pcLfu8UoA46W0wMGWUWDH+mrERu8NVnMgrBhhOvJAyKvABCAd
         a97RF7oquPObq2LzTga6ggECjDqejZla2fKe9ILI=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+df61b36319e045c00a08@syzkaller.appspotmail.com
Subject: [PATCH 2/3] wifi: ath9k: fix races between ath9k_wmi_cmd and ath9k_wmi_ctrl_rx
Date:   Wed, 15 Mar 2023 23:21:11 +0300
Message-Id: <20230315202112.163012-3-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230315202112.163012-1-pchelkin@ispras.ru>
References: <20230315202112.163012-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the synchronization between ath9k_wmi_cmd() and
ath9k_wmi_ctrl_rx() is exposed to races which can result, for example, not
only in wmi->cmd_rsp_buf being incorrectly initialized, but in overall
invalid behaviour of ath9k_wmi_cmd().

Consider the following scenario:

CPU0					CPU1

ath9k_wmi_cmd(...)
  mutex_lock(&wmi->op_mutex)
  ath9k_wmi_cmd_issue(...)
  wait_for_completion_timeout(...)
  ---
  timeout
  ---
  mutex_unlock(&wmi->op_mutex)
  return -ETIMEDOUT

ath9k_wmi_cmd(...)
  mutex_lock(&wmi->op_mutex)
  ath9k_wmi_cmd_issue(...)
  wait_for_completion_timeout(...)
					/* the one left after the first
					 * ath9k_wmi_cmd call
					 */
					ath9k_wmi_rsp_callback(...)
					  memcpy(...)
					  complete(&wmi->cmd_wait);
  /* Awakened by the bogus callback
   * => invalid return
   */
  mutex_unlock(&wmi->op_mutex)
  return 0

This may occur even on uniprocessor machines, and in SMP case the races
may be even more intricate.

To fix this, move the contents of ath9k_wmi_rsp_callback() under wmi_lock
inside ath9k_wmi_ctrl_rx() so that the wmi->cmd_wait can be completed only
for initially designated wmi_cmd call, otherwise the path would be
rejected with last_seq_id check.

Also move recording the rsp buffer and length into ath9k_wmi_cmd_issue()
under the same wmi_lock with last_seq_id update to avoid their racy
changes.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+df61b36319e045c00a08@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
This patch depends on [PATCH 1/3] wifi: ath9k: avoid referencing uninit
memory in ath9k_wmi_ctrl_rx

 drivers/net/wireless/ath/ath9k/wmi.c | 48 ++++++++++++++--------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 2e7c361b62f5..99a91bbaace9 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -200,20 +200,6 @@ void ath9k_fatal_work(struct work_struct *work)
 	ath9k_htc_reset(priv);
 }
 
-static void ath9k_wmi_rsp_callback(struct wmi *wmi, struct sk_buff *skb)
-{
-	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
-
-	/* Once again validate the SKB. */
-	if (unlikely(skb->len < wmi->cmd_rsp_len))
-		return;
-
-	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
-		memcpy(wmi->cmd_rsp_buf, skb->data, wmi->cmd_rsp_len);
-
-	complete(&wmi->cmd_wait);
-}
-
 static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 			      enum htc_endpoint_id epid)
 {
@@ -242,14 +228,26 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 
 	/* Check if there has been a timeout. */
 	spin_lock_irqsave(&wmi->wmi_lock, flags);
-	if (be16_to_cpu(hdr->seq_no) != wmi->last_seq_id) {
+	if (be16_to_cpu(hdr->seq_no) != wmi->last_seq_id ||
+	    be16_to_cpu(hdr->seq_no) == 0) {
+		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
+		goto free_skb;
+	}
+
+	/* Next, process WMI command response */
+	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
+
+	/* Once again validate the SKB. */
+	if (unlikely(skb->len < wmi->cmd_rsp_len)) {
 		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 		goto free_skb;
 	}
-	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
-	/* WMI command response */
-	ath9k_wmi_rsp_callback(wmi, skb);
+	if (wmi->cmd_rsp_buf != NULL && wmi->cmd_rsp_len != 0)
+		memcpy(wmi->cmd_rsp_buf, skb->data, wmi->cmd_rsp_len);
+
+	complete(&wmi->cmd_wait);
+	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
 free_skb:
 	kfree_skb(skb);
@@ -287,7 +285,8 @@ int ath9k_wmi_connect(struct htc_target *htc, struct wmi *wmi,
 
 static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 			       struct sk_buff *skb,
-			       enum wmi_cmd_id cmd, u16 len)
+			       enum wmi_cmd_id cmd, u16 len,
+			       u8 *rsp_buf, u32 rsp_len)
 {
 	struct wmi_cmd_hdr *hdr;
 	unsigned long flags;
@@ -297,6 +296,11 @@ static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 	hdr->seq_no = cpu_to_be16(++wmi->tx_seq_id);
 
 	spin_lock_irqsave(&wmi->wmi_lock, flags);
+
+	/* record the rsp buffer and length */
+	wmi->cmd_rsp_buf = rsp_buf;
+	wmi->cmd_rsp_len = rsp_len;
+
 	wmi->last_seq_id = wmi->tx_seq_id;
 	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
@@ -337,11 +341,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 		goto out;
 	}
 
-	/* record the rsp buffer and length */
-	wmi->cmd_rsp_buf = rsp_buf;
-	wmi->cmd_rsp_len = rsp_len;
-
-	ret = ath9k_wmi_cmd_issue(wmi, skb, cmd_id, cmd_len);
+	ret = ath9k_wmi_cmd_issue(wmi, skb, cmd_id, cmd_len, rsp_buf, rsp_len);
 	if (ret)
 		goto out;
 
-- 
2.34.1

