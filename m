Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7A76EE833
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 21:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbjDYT0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 15:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236009AbjDYT0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 15:26:31 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7D217DDF;
        Tue, 25 Apr 2023 12:26:21 -0700 (PDT)
Received: from fpc.intra.ispras.ru (unknown [10.10.165.4])
        by mail.ispras.ru (Postfix) with ESMTPSA id C1ADC40737C6;
        Tue, 25 Apr 2023 19:26:19 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru C1ADC40737C6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1682450779;
        bh=elNBmHMXHbOyemTHL7bhh7PqCcdux0Jfn0kEsJT4fzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYEZNmtjDpJENcCCfwHWpZvY5ouS159P94EXKKrZQ4bfMaAx0hiSpDrUVGl7XWDKF
         t19EbC8tRVUvo5YQ3wYnyG7ZcXxbH786i4LtH8byn3p8DNCQgEpNBkXXjuF50cY1vd
         N7JmaYElz8QmtJroukWSYSK+2ffg8Rf+2ZOHOb1U=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Vallo <kvalo@kernel.org>
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
        Hillf Danton <hdanton@sina.com>
Subject: [PATCH v3 2/2] wifi: ath9k: protect WMI command response buffer replacement with a lock
Date:   Tue, 25 Apr 2023 22:26:07 +0300
Message-Id: <20230425192607.18015-2-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230425192607.18015-1-pchelkin@ispras.ru>
References: <20230425192607.18015-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If ath9k_wmi_cmd() has exited with a timeout, it is possible that during
next ath9k_wmi_cmd() call the wmi_rsp callback for previous wmi command
writes to new wmi->cmd_rsp_buf and makes a completion. This results in an
invalid ath9k_wmi_cmd() return value.

Move the replacement of WMI command response buffer and length under
wmi_lock. Note that last_seq_id value is updated there, too.

Thus, the buffer cannot be written to by a belated wmi_rsp callback
because that path is properly rejected by the last_seq_id check.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
v2: do not extract ath9k_wmi_rsp_callback() internals, rephrase
description
v3: per Hillf Danton's comment, protect last_seq_id with wmi_lock on
timeout path, divide the v2 version into two separate patches; the first
one is concerned with last_seq_id and completion under wmi_lock, the
second one is for moving rsp buffer and length recording under wmi lock.
Note that it's been only tested with Syzkaller and on basic driver
scenarios with real hardware.

 drivers/net/wireless/ath/ath9k/wmi.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 04f363cb90fe..1476b42b52a9 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
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

