Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D67D9DE48
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 08:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbfH0G6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 02:58:08 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37160 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbfH0G6I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 02:58:08 -0400
Received: by mail-pf1-f194.google.com with SMTP id y9so13112288pfl.4
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 23:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SjzIbZ5hnYu3S33EBe7j6jLOK8CzX1GOqeIXZJFsQM=;
        b=cr05cDWOBWMlN9xmzk2396gJ0Yv94+bAhseFR8515+ucd/o5PzyR/Hy1HLNvvG4mlF
         epI6WjmKO+EmWvr1mmHggLoQeumqrcjTfcv9/g7pP3GVeuhyanzhZ8C6kReraq9af7Le
         eEY6gmqa+5F1NI3y85owS2gUSlSKv4A2ue3HQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2SjzIbZ5hnYu3S33EBe7j6jLOK8CzX1GOqeIXZJFsQM=;
        b=CQ+HesaA6mJrhW40pT/J1NhbHCK2ju17chPzivHPIC5JQ6QGvUJNKW7cvB/HQAkCDU
         bL/x23m8iD6Bv7UzgPMVb16WlUChyWHVs/DEQaVf+v8Os4VLVH0Ru4A3au1MlpoBy8hE
         d/8892uVCX91KinMsacnKi1AnbnUL2JJwZoIFoNdvIWA0cNBtFZHd7Gb4LWVRMaPSZZD
         SMaAAa9mMIpFQZbjh47eEtME+vBHKvdE4DOEihDpfHTxgUzbZUjyBahJ6Pwtf+FepIbD
         7V4Ih7o10SitmJhKJg3i0IXHtJ7EJAkcAinui1IgJ2ivrWCY0yF+YJuaOQQHrcILtMeS
         igmw==
X-Gm-Message-State: APjAAAXHUlxP3PfY2oiOyGycTECPHdv5rub9tUKIiypVKeajAn8GkIy5
        UEXQo4kbt9xSBTo9S+e0ALiLWw==
X-Google-Smtp-Source: APXvYqzcZ7kf4YnloLL8kQIiSagsepOrKO60rVy/s+xMJPjlrHUuOYXWh8kMuZiF4AL8PzdR9RlVTg==
X-Received: by 2002:a65:5082:: with SMTP id r2mr19450345pgp.170.1566889087335;
        Mon, 26 Aug 2019 23:58:07 -0700 (PDT)
Received: from drinkcat2.tpe.corp.google.com ([2401:fa00:1:b:d8b7:33af:adcb:b648])
        by smtp.gmail.com with ESMTPSA id b19sm12537347pgs.10.2019.08.26.23.58.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2019 23:58:06 -0700 (PDT)
From:   Nicolas Boichat <drinkcat@chromium.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wgong@codeaurora.org, Niklas Cassel <niklas.cassel@linaro.org>,
        Alagu Sankar <alagusankar@silex-india.com>,
        briannorris@chromium.org, tientzu@chromium.org
Subject: [PATCH v2] ath10k: Adjust skb length in ath10k_sdio_mbox_rx_packet
Date:   Tue, 27 Aug 2019 14:58:02 +0800
Message-Id: <20190827065802.167677-1-drinkcat@chromium.org>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the FW bundles multiple packets, pkt->act_len may be incorrect
as it refers to the first packet only (however, the FW will only
bundle packets that fit into the same pkt->alloc_len).

Before this patch, the skb length would be set (incorrectly) to
pkt->act_len in ath10k_sdio_mbox_rx_packet, and then later manually
adjusted in ath10k_sdio_mbox_rx_process_packet.

The first problem is that ath10k_sdio_mbox_rx_process_packet does not
use proper skb_put commands to adjust the length (it directly changes
skb->len), so we end up with a mismatch between skb->head + skb->tail
and skb->data + skb->len. This is quite serious, and causes corruptions
in the TCP stack, as the stack tries to coalesce packets, and relies
on skb->tail being correct (that is, skb_tail_pointer must point to
the first byte_after_ the data).

Instead of re-adjusting the size in ath10k_sdio_mbox_rx_process_packet,
this moves the code to ath10k_sdio_mbox_rx_packet, and also add a
bounds check, as skb_put would crash the kernel if not enough space is
available.

Fixes: 8530b4e7b22bc3b ("ath10k: sdio: set skb len for all rx packets")
Signed-off-by: Nicolas Boichat <drinkcat@chromium.org>

---

One simple way to reproduce this issue is this scriplet, that sends a
lot of small packets over SSH (it usually fails before reaching 300):
(for i in `seq 1 300`; do echo $i; sleep 0.1; done) | ssh $IP cat

I was not able to check the original use case why the code was added
(packets > 1500 bytes), as the FW on my board crashes when sending
such large packets.

 drivers/net/wireless/ath/ath10k/sdio.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/sdio.c b/drivers/net/wireless/ath/ath10k/sdio.c
index 8ed4fbd8d6c3888..0a3ac44a13698c1 100644
--- a/drivers/net/wireless/ath/ath10k/sdio.c
+++ b/drivers/net/wireless/ath/ath10k/sdio.c
@@ -381,16 +381,11 @@ static int ath10k_sdio_mbox_rx_process_packet(struct ath10k *ar,
 	struct ath10k_htc_hdr *htc_hdr = (struct ath10k_htc_hdr *)skb->data;
 	bool trailer_present = htc_hdr->flags & ATH10K_HTC_FLAG_TRAILER_PRESENT;
 	enum ath10k_htc_ep_id eid;
-	u16 payload_len;
 	u8 *trailer;
 	int ret;
 
-	payload_len = le16_to_cpu(htc_hdr->len);
-	skb->len = payload_len + sizeof(struct ath10k_htc_hdr);
-
 	if (trailer_present) {
-		trailer = skb->data + sizeof(*htc_hdr) +
-			  payload_len - htc_hdr->trailer_len;
+		trailer = skb->data + skb->len - htc_hdr->trailer_len;
 
 		eid = pipe_id_to_eid(htc_hdr->eid);
 
@@ -636,9 +631,23 @@ static int ath10k_sdio_mbox_rx_packet(struct ath10k *ar,
 
 	ret = ath10k_sdio_readsb(ar, ar_sdio->mbox_info.htc_addr,
 				 skb->data, pkt->alloc_len);
+	if (!ret) {
+		/* Update actual length. The original length may be incorrect,
+		 * as the FW will bundle multiple packets as long as their sizes
+		 * fit within the same aligned length (pkt->alloc_len).
+		 */
+		struct ath10k_htc_hdr *htc_hdr =
+			(struct ath10k_htc_hdr *)skb->data;
+		pkt->act_len = le16_to_cpu(htc_hdr->len) + sizeof(*htc_hdr);
+		if (pkt->act_len <= pkt->alloc_len) {
+			skb_put(skb, pkt->act_len);
+		} else {
+			ath10k_warn(ar, "rx_packet too large (%d > %d)\n",
+				    pkt->act_len, pkt->alloc_len);
+			ret = -EMSGSIZE;
+		}
+	}
 	pkt->status = ret;
-	if (!ret)
-		skb_put(skb, pkt->act_len);
 
 	return ret;
 }
-- 
2.23.0.187.g17f5b7556c-goog

