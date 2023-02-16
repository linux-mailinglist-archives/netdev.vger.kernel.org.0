Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A885699CF4
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjBPTXP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:23:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBPTXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:23:14 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E009147411;
        Thu, 16 Feb 2023 11:23:13 -0800 (PST)
Received: from fpc.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 0AB5941C612E;
        Thu, 16 Feb 2023 19:23:12 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 0AB5941C612E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1676575392;
        bh=fZZ2iOgIhJ3ucWh4NWw0K/zocy8Eivp28hABNY/JFHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NkGLrrQoVCLyMpuxUXO+dUSu4yqDhS9zYhUT+BXF1uhKTe0gRsoB2WrjDywY3Q68P
         STxma9qDiGSuVP4k/2uiHvmMJEApdh0wUhyHyrqvzJzKnpJwXAEf9cPxjuEzR0EQ91
         r/E8FTqilUY8g7g7XjN3SAXVXqBlpwpCs+x7zBfI=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        Senthil Balasubramanian <senthilkumar@atheros.com>,
        Sujith <Sujith.Manoharan@atheros.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org
Subject: [PATCH v2] wifi: ath9k: hif_usb: fix memory leak of remain_skbs
Date:   Thu, 16 Feb 2023 22:23:01 +0300
Message-Id: <20230216192301.171225-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <87ttzlqyd4.fsf@toke.dk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hif_dev->remain_skb is allocated and used exclusively in
ath9k_hif_usb_rx_stream(). It is implied that an allocated remain_skb is
processed and subsequently freed (in error paths) only during the next
call of ath9k_hif_usb_rx_stream().

So, if the urbs are deallocated between those two calls due to the device
deinitialization or suspend, it is possible that ath9k_hif_usb_rx_stream()
is not called next time and the allocated remain_skb is leaked. Our local
Syzkaller instance was able to trigger that.

remain_skb makes sense when receiving two consecutive urbs which are
logically linked together, i.e. a specific data field from the first skb
indicates a cached skb to be allocated, memcpy'd with some data and
subsequently processed in the next call to ath9k_hif_usb_rx_stream(). Urbs
deallocation supposedly makes that link irrelevant so we need to free the
cached skb in those cases.

Fix the leak by introducing a function to explicitly free remain_skb (if
it is not NULL) when the rx urbs have been deallocated. remain_skb is NULL
when it has not been allocated at all (hif_dev struct is kzalloced) or
when it has been processed in next call to ath9k_hif_usb_rx_stream().

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
v1->v2: move ath9k_hif_usb_free_rx_remain_skb call into urbs dealloc
function as advised by Toke; add a stat macro

 drivers/net/wireless/ath/ath9k/hif_usb.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f521dfa2f194..e0130beb304d 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -534,6 +534,24 @@ static struct ath9k_htc_hif hif_usb = {
 	.send = hif_usb_send,
 };
 
+/* Need to free remain_skb allocated in ath9k_hif_usb_rx_stream
+ * in case ath9k_hif_usb_rx_stream wasn't called next time to
+ * process the buffer and subsequently free it.
+ */
+static void ath9k_hif_usb_free_rx_remain_skb(struct hif_device_usb *hif_dev)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&hif_dev->rx_lock, flags);
+	if (hif_dev->remain_skb) {
+		dev_kfree_skb_any(hif_dev->remain_skb);
+		hif_dev->remain_skb = NULL;
+		hif_dev->rx_remain_len = 0;
+		RX_STAT_INC(hif_dev, skb_dropped);
+	}
+	spin_unlock_irqrestore(&hif_dev->rx_lock, flags);
+}
+
 static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				    struct sk_buff *skb)
 {
@@ -868,6 +886,7 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
 static void ath9k_hif_usb_dealloc_rx_urbs(struct hif_device_usb *hif_dev)
 {
 	usb_kill_anchored_urbs(&hif_dev->rx_submitted);
+	ath9k_hif_usb_free_rx_remain_skb(hif_dev);
 }
 
 static int ath9k_hif_usb_alloc_rx_urbs(struct hif_device_usb *hif_dev)
-- 
2.34.1

