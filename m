Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4274254CF33
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 19:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354664AbiFOQ7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 12:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354052AbiFOQ7l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 12:59:41 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DB492E686
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 09:59:39 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id c196so11987618pfb.1
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 09:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yR38ccdgKnrRjCuDMGRCE5StIBkp839XVZD0RSnVzf0=;
        b=mZ1yiu1IsEYQaQrG5j1bdIMF5bbDREHPevOeyc9afs1CwmgonhuFmXsEpg4vOeAoSq
         CrNh0td8hESqycp8HYBKyyngs6nnWGF0S+idzEirlllrqh2xXLt4DQ7femi9mtzOrPjo
         0nr65KZRfv3gnnycRkG7whM7CXy940pf6ziwUOqCvhUcycJfXl7e5iMzPpycMXE2E4ch
         7aQibgDpWn0faHZXH8AZ8S/bbqHhI+KQB1PoNwGuZfgVhwRRkaSGiCG4jyDwzFJtcIbL
         ZnbWlg2aszRV9Fdmj6kerAK78BxXbl/wFX1x8Hprd86ihXM9Lhmyv9a9DFC89fLoqxMb
         lT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yR38ccdgKnrRjCuDMGRCE5StIBkp839XVZD0RSnVzf0=;
        b=S1wFnsR15ijECsX4Aqgjkgo0LMfUtg2pRcfvV1uAxnp1/CdDDHoYrjFjAau+UgfnDe
         H4DUs/KVPwZ3715uhVk8KAnOrnUkanneOI8/EbckYbxYhJLcL5RCsVden9lkKhfOWxXR
         e7EGYv8k4oF4VCqioBSboYumwn3pgibGn25cXjCusMLq8cUl3081SSUNGlKZOmwQ2joX
         HIFMRFhKJodaOMxJlp4vhvGP61Qjlqph4l8sd8MA35nccZhiMmmDY2AgUUJSWfV29ESQ
         cA28HJ03/11JAQGOd7CIe1AbO11VVsi3WHPXI53vKOS3E4wW3EXMmfkmYnswjCry3Ji+
         u7Jg==
X-Gm-Message-State: AJIora+uxsXPa8CYER/CauYbD2SxaSs+POhXUevvTHb2Tic97i1PKc9W
        sAXdw10D8qElARQU7W0Yz469xg==
X-Google-Smtp-Source: AGRyM1tieMSlqX6r3NjvN0HfQkohWMO5hBXzzB79TBsSneWc0a35yqQgGYx+GpFcZK/sqhz8LqrfcQ==
X-Received: by 2002:aa7:98cd:0:b0:520:5200:1c07 with SMTP id e13-20020aa798cd000000b0052052001c07mr518649pfm.13.1655312378945;
        Wed, 15 Jun 2022 09:59:38 -0700 (PDT)
Received: from localhost.localdomain ([192.77.111.2])
        by smtp.gmail.com with ESMTPSA id s194-20020a6377cb000000b003fd1111d73csm10618513pgc.4.2022.06.15.09.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 09:59:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] net: ipa: move more code out of gsi_channel_update()
Date:   Wed, 15 Jun 2022 11:59:29 -0500
Message-Id: <20220615165929.5924-6-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220615165929.5924-1-elder@linaro.org>
References: <20220615165929.5924-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the processing done for TX channels in gsi_channel_update()
into gsi_evt_ring_rx_update().  The called function is called for
both RX and TX channels, so rename it to be gsi_evt_ring_update().
As a result, this code no longer assumes events in an event ring are
associated with just one channel.

Because all events in a ring are handled in that function, we can
move the call to gsi_trans_move_complete() there, and can ring the
event ring doorbell there as well after all new events in the ring
have been processed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index d08f3e73d51fc..4e46974a69ecd 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1344,7 +1344,7 @@ gsi_event_trans(struct gsi *gsi, struct gsi_event *event)
 }
 
 /**
- * gsi_evt_ring_rx_update() - Record lengths of received data
+ * gsi_evt_ring_update() - Update transaction state from hardware
  * @gsi:		GSI pointer
  * @evt_ring_id:	Event ring ID
  * @index:		Event index in ring reported by hardware
@@ -1353,6 +1353,10 @@ gsi_event_trans(struct gsi *gsi, struct gsi_event *event)
  * the buffer.  Every event has a transaction associated with it, and here
  * we update transactions to record their actual received lengths.
  *
+ * When an event for a TX channel arrives we use information in the
+ * transaction to report the number of requests and bytes have been
+ * transferred.
+ *
  * This function is called whenever we learn that the GSI hardware has filled
  * new events since the last time we checked.  The ring's index field tells
  * the first entry in need of processing.  The index provided is the
@@ -1363,7 +1367,7 @@ gsi_event_trans(struct gsi *gsi, struct gsi_event *event)
  *
  * Note that @index always refers to an element *within* the event ring.
  */
-static void gsi_evt_ring_rx_update(struct gsi *gsi, u32 evt_ring_id, u32 index)
+static void gsi_evt_ring_update(struct gsi *gsi, u32 evt_ring_id, u32 index)
 {
 	struct gsi_evt_ring *evt_ring = &gsi->evt_ring[evt_ring_id];
 	struct gsi_ring *ring = &evt_ring->ring;
@@ -1372,10 +1376,12 @@ static void gsi_evt_ring_rx_update(struct gsi *gsi, u32 evt_ring_id, u32 index)
 	u32 event_avail;
 	u32 old_index;
 
-	/* We'll start with the oldest un-processed event.  RX channels
-	 * replenish receive buffers in single-TRE transactions, so we
-	 * can just map that event to its transaction.  Transactions
-	 * associated with completion events are consecutive.
+	/* Starting with the oldest un-processed event, determine which
+	 * transaction (and which channel) is associated with the event.
+	 * For RX channels, update each completed transaction with the
+	 * number of bytes that were actually received.  For TX channels
+	 * associated with a network device, report to the network stack
+	 * the number of transfers and bytes this completion represents.
 	 */
 	old_index = ring->index;
 	event = gsi_ring_virt(ring, old_index);
@@ -1394,6 +1400,10 @@ static void gsi_evt_ring_rx_update(struct gsi *gsi, u32 evt_ring_id, u32 index)
 
 		if (trans->direction == DMA_FROM_DEVICE)
 			trans->len = __le16_to_cpu(event->len);
+		else
+			gsi_trans_tx_completed(trans);
+
+		gsi_trans_move_complete(trans);
 
 		/* Move on to the next event and transaction */
 		if (--event_avail)
@@ -1401,6 +1411,9 @@ static void gsi_evt_ring_rx_update(struct gsi *gsi, u32 evt_ring_id, u32 index)
 		else
 			event = gsi_ring_virt(ring, 0);
 	} while (event != event_done);
+
+	/* Tell the hardware we've handled these events */
+	gsi_evt_ring_doorbell(gsi, evt_ring_id, index);
 }
 
 /* Initialize a ring, including allocating DMA memory for its entries */
@@ -1499,14 +1512,7 @@ static struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 	 * the number of transactions and bytes this completion represents
 	 * up the network stack.
 	 */
-	if (channel->toward_ipa)
-		gsi_trans_tx_completed(trans);
-	gsi_evt_ring_rx_update(gsi, evt_ring_id, index);
-
-	gsi_trans_move_complete(trans);
-
-	/* Tell the hardware we've handled these events */
-	gsi_evt_ring_doorbell(gsi, evt_ring_id, index);
+	gsi_evt_ring_update(gsi, evt_ring_id, index);
 
 	return gsi_channel_trans_complete(channel);
 }
-- 
2.34.1

