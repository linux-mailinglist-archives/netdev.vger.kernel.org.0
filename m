Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29E456ED539
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 21:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232269AbjDXTTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 15:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjDXTTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 15:19:24 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD454C2B;
        Mon, 24 Apr 2023 12:19:23 -0700 (PDT)
Received: from fpc.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 2847A4076277;
        Mon, 24 Apr 2023 19:19:21 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 2847A4076277
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1682363961;
        bh=Ndv3UKrB3QzOIT2rE3GkXyq8UTij4TcY2JmMRnQH7YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mpvrbInnWHLEaNECUq4UUY726unmqUX7LoG9JOs4bRBcbyfF38K71RnSZfVeNI0bn
         Y64XsH3P09pSVn25rmYiUoRvwAkOlmPvn3osGmpBgyqKU8oFHROuFMGbkBVJvERuG8
         x47QuJ0UHqRfAVfTvEM5Y7Q+pyq1FHutBYkEQ4O8=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
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
        syzbot+f2cb6e0ffdb961921e4d@syzkaller.appspotmail.com,
        syzbot+df61b36319e045c00a08@syzkaller.appspotmail.com
Subject: [PATCH v2] wifi: ath9k: fix races between ath9k_wmi_cmd and ath9k_wmi_ctrl_rx
Date:   Mon, 24 Apr 2023 22:18:26 +0300
Message-Id: <20230424191826.117354-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230424191158.iebfqubeanurdabk@fpc>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the synchronization between ath9k_wmi_cmd() and
ath9k_wmi_ctrl_rx() is exposed to a race condition which, although being
rather unlikely, can lead to invalid behaviour of ath9k_wmi_cmd().

Consider the following scenario:

CPU0					CPU1

ath9k_wmi_cmd(...)
  mutex_lock(&wmi->op_mutex)
  ath9k_wmi_cmd_issue(...)
  wait_for_completion_timeout(...)
  ---
  timeout
  ---
					/* the callback is being processed
					 * before last_seq_id became zero
					 */
					ath9k_wmi_ctrl_rx(...)
					  spin_lock_irqsave(...)
					  /* wmi->last_seq_id check here
					   * doesn't detect timeout yet
					   */
					  spin_unlock_irqrestore(...)
  /* last_seq_id is zeroed to
   * indicate there was a timeout
   */
  wmi->last_seq_id = 0
  mutex_unlock(&wmi->op_mutex)
  return -ETIMEDOUT

ath9k_wmi_cmd(...)
  mutex_lock(&wmi->op_mutex)
  /* the buffer is replaced with
   * another one
   */
  wmi->cmd_rsp_buf = rsp_buf
  wmi->cmd_rsp_len = rsp_len
  ath9k_wmi_cmd_issue(...)
    spin_lock_irqsave(...)
    spin_unlock_irqrestore(...)
  wait_for_completion_timeout(...)
					/* the continuation of the
					 * callback left after the first
					 * ath9k_wmi_cmd call
					 */
					  ath9k_wmi_rsp_callback(...)
					    /* copying data designated
					     * to already timeouted
					     * WMI command into an
					     * inappropriate wmi_cmd_buf
					     */
					    memcpy(...)
					    complete(&wmi->cmd_wait)
  /* awakened by the bogus callback
   * => invalid return result
   */
  mutex_unlock(&wmi->op_mutex)
  return 0

To fix this, move ath9k_wmi_rsp_callback() under wmi_lock inside
ath9k_wmi_ctrl_rx() so that the wmi->cmd_wait can be completed only for
initially designated wmi_cmd call, otherwise the path would be rejected
with last_seq_id check.

Also move recording the rsp buffer and length into ath9k_wmi_cmd_issue()
under the same wmi_lock with last_seq_id update to avoid their racy
changes.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Reported-and-tested-by: syzbot+df61b36319e045c00a08@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
v2: do not extract ath9k_wmi_rsp_callback() internals, rephrase
description

 drivers/net/wireless/ath/ath9k/wmi.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index d652c647d56b..688453a2e53a 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -242,10 +242,10 @@ static void ath9k_wmi_ctrl_rx(void *priv, struct sk_buff *skb,
 		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 		goto free_skb;
 	}
-	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
 	/* WMI command response */
 	ath9k_wmi_rsp_callback(wmi, skb);
+	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
 free_skb:
 	kfree_skb(skb);
@@ -283,7 +283,8 @@ int ath9k_wmi_connect(struct htc_target *htc, struct wmi *wmi,
 
 static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 			       struct sk_buff *skb,
-			       enum wmi_cmd_id cmd, u16 len)
+			       enum wmi_cmd_id cmd, u16 len,
+			       u8 *rsp_buf, u32 rsp_len)
 {
 	struct wmi_cmd_hdr *hdr;
 	unsigned long flags;
@@ -293,6 +294,11 @@ static int ath9k_wmi_cmd_issue(struct wmi *wmi,
 	hdr->seq_no = cpu_to_be16(++wmi->tx_seq_id);
 
 	spin_lock_irqsave(&wmi->wmi_lock, flags);
+
+	/* record the rsp buffer and length */
+	wmi->cmd_rsp_buf = rsp_buf;
+	wmi->cmd_rsp_len = rsp_len;
+
 	wmi->last_seq_id = wmi->tx_seq_id;
 	spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
@@ -333,11 +339,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
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

