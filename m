Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABFB465D2DC
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 13:37:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239192AbjADMhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 07:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239277AbjADMgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 07:36:36 -0500
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D235813CDF;
        Wed,  4 Jan 2023 04:36:35 -0800 (PST)
Received: from fedcomp.. (unknown [46.242.14.200])
        by mail.ispras.ru (Postfix) with ESMTPSA id 466DD419E9F5;
        Wed,  4 Jan 2023 12:36:34 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.ispras.ru 466DD419E9F5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ispras.ru;
        s=default; t=1672835794;
        bh=dc0S1ZC+JXp9Z/sCIUJ7rKnBqUvmEKO7DJxlv7hastk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PB7Z2vnPjVQVqjLXOkVkz0W94WO0xFb1hYlDUFOdlbFTlSr+3TAyaLfo5acwMgkeo
         IMlbDPynh//gP+nQSxqYj6CdAt3l6kho4vO2i62xBesNW+DHA0HnlWijvWj/OnQRn1
         LISAdoTGbvZDemANeyr1p/uPXul7+CDHEKUnRa10=
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Zekun Shen <bruceshenzk@gmail.com>,
        Joe Perches <joe@perches.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        lvc-project@linuxtesting.org,
        syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
Subject: [PATCH v3] wifi: ath9k: hif_usb: clean up skbs if ath9k_hif_usb_rx_stream() fails
Date:   Wed,  4 Jan 2023 15:36:15 +0300
Message-Id: <20230104123615.51511-1-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <87tu172np9.fsf@toke.dk>
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

Syzkaller detected a memory leak of skbs in ath9k_hif_usb_rx_stream().
While processing skbs in ath9k_hif_usb_rx_stream(), the already allocated
skbs in skb_pool are not freed if ath9k_hif_usb_rx_stream() fails. If we
have an incorrect pkt_len or pkt_tag, the input skb is considered invalid
and dropped. All the associated packets already in skb_pool should be
dropped and freed. Added a comment describing this issue.

The patch also makes remain_skb NULL after being processed so that it
cannot be referenced after potential free. The initialization of hif_dev
fields which are associated with remain_skb (rx_remain_len,
rx_transfer_len and rx_pad_len) is moved after a new remain_skb is
allocated. 

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 6ce708f54cc8 ("ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream")
Fixes: 44b23b488d44 ("ath9k: hif_usb: Reduce indent 1 column")
Reported-by: syzbot+e9632e3eb038d93d6bc6@syzkaller.appspotmail.com
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
v1->v2: added Reported-by tag
v2->v3: added proper remain_skb processing, stat macro, comment 

 drivers/net/wireless/ath/ath9k/hif_usb.c | 31 +++++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 1a2e0c7eeb02..de6c0824c9ca 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -561,11 +561,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			memcpy(ptr, skb->data, rx_remain_len);
 
 			rx_pkt_len += rx_remain_len;
-			hif_dev->rx_remain_len = 0;
 			skb_put(remain_skb, rx_pkt_len);
 
 			skb_pool[pool_index++] = remain_skb;
-
+			hif_dev->remain_skb = NULL;
+			hif_dev->rx_remain_len = 0;
 		} else {
 			index = rx_remain_len;
 		}
@@ -584,16 +584,21 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 		pkt_len = get_unaligned_le16(ptr + index);
 		pkt_tag = get_unaligned_le16(ptr + index + 2);
 
+		/* It is supposed that if we have an invalid pkt_tag or
+		 * pkt_len then the whole input SKB is considered invalid
+		 * and dropped; the associated packets already in skb_pool
+		 * are dropped, too.
+		 */
 		if (pkt_tag != ATH_USB_RX_STREAM_MODE_TAG) {
 			RX_STAT_INC(hif_dev, skb_dropped);
-			return;
+			goto invalid_pkt;
 		}
 
 		if (pkt_len > 2 * MAX_RX_BUF_SIZE) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: invalid pkt_len (%x)\n", pkt_len);
 			RX_STAT_INC(hif_dev, skb_dropped);
-			return;
+			goto invalid_pkt;
 		}
 
 		pad_len = 4 - (pkt_len & 0x3);
@@ -605,11 +610,6 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 		if (index > MAX_RX_BUF_SIZE) {
 			spin_lock(&hif_dev->rx_lock);
-			hif_dev->rx_remain_len = index - MAX_RX_BUF_SIZE;
-			hif_dev->rx_transfer_len =
-				MAX_RX_BUF_SIZE - chk_idx - 4;
-			hif_dev->rx_pad_len = pad_len;
-
 			nskb = __dev_alloc_skb(pkt_len + 32, GFP_ATOMIC);
 			if (!nskb) {
 				dev_err(&hif_dev->udev->dev,
@@ -617,6 +617,12 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				spin_unlock(&hif_dev->rx_lock);
 				goto err;
 			}
+
+			hif_dev->rx_remain_len = index - MAX_RX_BUF_SIZE;
+			hif_dev->rx_transfer_len =
+				MAX_RX_BUF_SIZE - chk_idx - 4;
+			hif_dev->rx_pad_len = pad_len;
+
 			skb_reserve(nskb, 32);
 			RX_STAT_INC(hif_dev, skb_allocated);
 
@@ -654,6 +660,13 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				 skb_pool[i]->len, USB_WLAN_RX_PIPE);
 		RX_STAT_INC(hif_dev, skb_completed);
 	}
+	return;
+invalid_pkt:
+	for (i = 0; i < pool_index; i++) {
+		dev_kfree_skb_any(skb_pool[i]);
+		RX_STAT_INC(hif_dev, skb_dropped);
+	}
+	return;
 }
 
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
-- 
2.34.1

