Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E751549D7B
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348621AbiFMTWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348525AbiFMTVh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:21:37 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCCF286CC
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:09 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u2so6326039pfc.2
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 10:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E83xgHGBSlrea3RuRNnmqu56ICtmNe3QaOTQd1XRhUI=;
        b=tzG6BM+baSkEPI4er+Nz+huiMvaIlnP8LzlHaV3xyVOnFP7ZqVRuoupLMBwr56xZ05
         NvbZ67hvGY6+DrHEeHtorK8TfFe3mUu590VgPhZGENKFb3+FMZqtPSJaQG7tNBlkJZcl
         SNMIphuVrVSEreNDIAu13lc3fXRidszhKXlRXSn8RCFkNSpBzqpnf+II0sQLxdwmhUpY
         PQraqwpVPDAsLbm7A8Le1Od6+gGW7naHHqTeH8kggT5HEBIq6GopqKgejHeC6Y9KuSBC
         7Yll/LVgaP3YCjT5lKA9zqRHmmtI9nb2wuqRMjGPbhEfke5e+FVOoAwj6Swgc09oYuP0
         323Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E83xgHGBSlrea3RuRNnmqu56ICtmNe3QaOTQd1XRhUI=;
        b=aH4RNUWkNhbRpzprZJciu45TQ64LVR288wncUqvHg9N6w8h9n6CJj8ySUgkojaVQf7
         HX1mdn8gnJ5aTJfeA3bcM9QlgnVYIzvWPbxGZo6zzSoa0ZzYxCVFqIVTdjLCQWWq4DKs
         IzQy0R0DOpEi1KuYx5X+y5qa1WrgYJYVVOSCh4hBbWgn1fjdAm0rj145UFr3PVyI/6Fm
         KareQAiqSYd8MWDb2yYQ9+frKgo0+usPy665F+1reu78NW2qRPGlGXnHBHJj7OTQBL/k
         g1vPp2riOkY+3X3wA8ukzN1KRU6LPPrM2/VVG9g/amNE+Z8VsIytgItpF7mIlQNDifAe
         aj/w==
X-Gm-Message-State: AOAM532WwscCAAeF1byYUtUj/FBFl68mVCPWjNZLL4SVIFOB5g75XBjZ
        w3ldNNDAbG14DhOYdoH+cvHvHQ==
X-Google-Smtp-Source: ABdhPJxvKkxI4ovaeSFS1/tZfofauDJd1SGhM+GSw9nJetd2y/4vx7vszEcxop4IOQxgxVzTgzDVrA==
X-Received: by 2002:a63:24c7:0:b0:3fc:5c99:a196 with SMTP id k190-20020a6324c7000000b003fc5c99a196mr526249pgk.521.1655140688993;
        Mon, 13 Jun 2022 10:18:08 -0700 (PDT)
Received: from localhost.localdomain ([192.77.111.2])
        by smtp.gmail.com with ESMTPSA id u17-20020a62d451000000b0050dc762812csm5646641pfl.6.2022.06.13.10.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:18:08 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: introduce gsi_trans_tx_committed()
Date:   Mon, 13 Jun 2022 12:17:56 -0500
Message-Id: <20220613171759.578856-4-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220613171759.578856-1-elder@linaro.org>
References: <20220613171759.578856-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new function that encapsulates recording information needed
for TX channel statistics when a transaction is committed.

Record the accumulated length in the transaction before the call
(for both RX and TX), so it can be used when updating TX statistics.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c         | 11 +++++++++++
 drivers/net/ipa/gsi_private.h |  9 +++++++++
 drivers/net/ipa/gsi_trans.c   | 11 +++--------
 drivers/net/ipa/gsi_trans.h   |  7 ++++---
 4 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5b446d2a07c8a..1091ac23567d5 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -991,6 +991,17 @@ void gsi_resume(struct gsi *gsi)
 	enable_irq(gsi->irq);
 }
 
+void gsi_trans_tx_committed(struct gsi_trans *trans)
+{
+	struct gsi_channel *channel = &trans->gsi->channel[trans->channel_id];
+
+	trans->trans_count = channel->trans_count;
+	trans->byte_count = channel->byte_count;
+
+	channel->trans_count++;
+	channel->byte_count += trans->len;
+}
+
 void gsi_trans_tx_queued(struct gsi_trans *trans)
 {
 	u32 channel_id = trans->channel_id;
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index 56450a1899074..74cbc287fc715 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -104,6 +104,15 @@ void gsi_channel_doorbell(struct gsi_channel *channel);
  */
 void *gsi_ring_virt(struct gsi_ring *ring, u32 index);
 
+/**
+ * gsi_trans_tx_committed() - Record bytes committed for transmit
+ * @trans:	TX endpoint transaction being committed
+ *
+ * Report that a TX transaction has been committed.  It updates some
+ * statistics used to manage transmit rates.
+ */
+void gsi_trans_tx_committed(struct gsi_trans *trans);
+
 /**
  * gsi_trans_tx_queued() - Report a queued TX channel transaction
  * @trans:	Transaction being passed to hardware
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 986857eb39296..a110be72f70b6 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -586,14 +586,9 @@ static void __gsi_trans_commit(struct gsi_trans *trans, bool ring_db)
 	}
 	tre_ring->index += trans->used_count;
 
-	if (channel->toward_ipa) {
-		/* We record TX bytes when they are sent */
-		trans->len = byte_count;
-		trans->trans_count = channel->trans_count;
-		trans->byte_count = channel->byte_count;
-		channel->trans_count++;
-		channel->byte_count += byte_count;
-	}
+	trans->len = byte_count;
+	if (channel->toward_ipa)
+		gsi_trans_tx_committed(trans);
 
 	/* Associate the last TRE with the transaction */
 	gsi_channel_trans_map(channel, tre_ring->index - 1, trans);
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index b5f80250ca006..7084507830c21 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -35,7 +35,7 @@ struct gsi_trans_pool;
  * @cancelled:	If set by the core code, transaction was cancelled
  * @rsvd_count:	Number of TREs reserved for this transaction
  * @used_count:	Number of TREs *used* (could be less than rsvd_count)
- * @len:	Total # of transfer bytes represented in sgl[] (set by core)
+ * @len:	Number of bytes sent or received by the transaction
  * @data:	Preserved but not touched by the core transaction code
  * @cmd_opcode:	Array of command opcodes (command channel only)
  * @sgl:	An array of scatter/gather entries managed by core code
@@ -45,8 +45,9 @@ struct gsi_trans_pool;
  * @byte_count:	TX channel byte count recorded when transaction committed
  * @trans_count: Channel transaction count when committed (for BQL accounting)
  *
- * The size used for some fields in this structure were chosen to ensure
- * the full structure size is no larger than 128 bytes.
+ * The @len field is set when the transaction is committed.  For RX
+ * transactions it is updated later to reflect the actual number of bytes
+ * received.
  */
 struct gsi_trans {
 	struct list_head links;		/* gsi_channel lists */
-- 
2.34.1

