Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD600304D8C
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 01:44:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732385AbhAZXKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 18:10:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732364AbhAZS5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 13:57:52 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48AD2C061352
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:12 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id e22so35779095iog.6
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 10:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4obeX1NaiRltyNAJxhbtg4nhO/wV8qatGfACRFnTlEE=;
        b=yXhpmzCGtOEPgfRAyDcrM0jJ+K9X6PmYt6SCqBm46i+zav4iGds/ZuuCt/7Gc+MXVv
         IIOkZdoPzmteZcXoyozJ8wuMqewn4EU5I3EtTRyj9NApKqxGG9uyJSid/jlaXQtScQoQ
         g+D6w4ncrZdRBN14SHAND1viZ7pEoyUpHLQlaS7MIH1bTlj0H34GxXJEUUR6nwBIjuOu
         nestJrfjVokNSMs1i1uAo8eTftqAkXC7cvyvm61JPWeEpqn1++ADc6d2vl+XEfSIF9zx
         MoeMUKalPq3LWU4rv8yQZoLiAQy9s4tCGx1Hvzzrq3MQGP9P+m4ZD2JF6HGg7Mk1Hxay
         wGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4obeX1NaiRltyNAJxhbtg4nhO/wV8qatGfACRFnTlEE=;
        b=rvC5mVDDTF8nR8HqyQbTt0+f6t12k1Zx/I7MGWU3y/K/Z4ckpe6tTR9qpDR8ncPw/Z
         SG0xX/GfGOCv+00UiW1b8VzA3R0LT9swWQDK4vFs2iwUTnrtlRrmH2kk3x1fP+oi2qO1
         dym+tWiRJsK7mlwqhaFtyPJgtO7H3rwQ/cAyAqbXFwweUdXv62cCrYBFrIW2iYNSM2it
         BZWk+KMaehGOb1vzt80Io9E7JQ8UIBVMsFdAzScq1S8qMd8vHL/aL4Y8/xL3mcrWim5f
         VHugoQBcnQKtqHIdbr7l460Bd3few3AJcZFS4MxOIAE+Q7CZe1DtNe6FkzXm8RtTO438
         J8yA==
X-Gm-Message-State: AOAM530dODc6SaA6oCkX/J7zx86K+uF9A1TWoRk2euHgIBEkOOlSfMSs
        P80Af11sspf9Ub04jl8FRiC5bg==
X-Google-Smtp-Source: ABdhPJwTF9P6PnVZAsCECqewMmKCSM4ZD1vBbfL8cWGCOLDImW4iNWxLw7uE6dE+MuybRlOlC6sKlA==
X-Received: by 2002:a92:ca81:: with SMTP id t1mr5590173ilo.139.1611687431668;
        Tue, 26 Jan 2021 10:57:11 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id l14sm13060681ilh.58.2021.01.26.10.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 10:57:11 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 4/6] net: ipa: signal when tag transfer completes
Date:   Tue, 26 Jan 2021 12:57:01 -0600
Message-Id: <20210126185703.29087-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210126185703.29087-1-elder@linaro.org>
References: <20210126185703.29087-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are times, such as when the modem crashes, when we issue
commands to clear the IPA hardware pipeline.  These commands include
a data transfer command that delivers a small packet directly to the
default (AP<-LAN RX) endpoint.

The places that do this wait for the transactions that contain these
commands to complete, but the pipeline can't be assumed clear until
the sent packet has been *received*.

The small transfer will be delivered with a status structure, and
that status will indicate its tag is valid.  This is the only place
we send a tagged packet, so we use the tag to determine when the
pipeline clear packet has arrived.

Add a completion to the IPA structure to to be used to signal
the receipt of a pipeline clear packet.  Create a new function
ipa_cmd_pipeline_clear_wait() that will wait for that completion.

Reinitialize the completion whenever pipeline clear commands are
added to a transaction.  Extend ipa_endpoint_status_tag() to check
whether a packet whose status contains a valid tag was sent from the
AP->command TX endpoint, and if so, signal the new IPA completion.

Have all callers of ipa_cmd_pipeline_clear_add() wait for the
pipeline clear indication after the transaction that clears the
pipeline has completed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa.h          |  2 ++
 drivers/net/ipa/ipa_cmd.c      |  9 +++++++++
 drivers/net/ipa/ipa_cmd.h      |  7 +++++++
 drivers/net/ipa/ipa_endpoint.c | 27 ++++++++++++++++++++++++++-
 drivers/net/ipa/ipa_main.c     |  1 +
 5 files changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index c6c6a7f6909c1..8020776313716 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -43,6 +43,7 @@ enum ipa_flag {
  * @flags:		Boolean state flags
  * @version:		IPA hardware version
  * @pdev:		Platform device
+ * @completion:		Used to signal pipeline clear transfer complete
  * @smp2p:		SMP2P information
  * @clock:		IPA clocking information
  * @table_addr:		DMA address of filter/route table content
@@ -82,6 +83,7 @@ struct ipa {
 	DECLARE_BITMAP(flags, IPA_FLAG_COUNT);
 	enum ipa_version version;
 	struct platform_device *pdev;
+	struct completion completion;
 	struct notifier_block nb;
 	void *notifier;
 	struct ipa_smp2p *smp2p;
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 27630244512d8..7df0072bddcce 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -573,6 +573,9 @@ void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans)
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
 	struct ipa_endpoint *endpoint;
 
+	/* This will complete when the transfer is received */
+	reinit_completion(&ipa->completion);
+
 	/* Issue a no-op register write command (mask 0 means no write) */
 	ipa_cmd_register_write_add(trans, 0, 0, 0, true);
 
@@ -596,6 +599,11 @@ u32 ipa_cmd_pipeline_clear_count(void)
 	return 4;
 }
 
+void ipa_cmd_pipeline_clear_wait(struct ipa *ipa)
+{
+	wait_for_completion(&ipa->completion);
+}
+
 void ipa_cmd_pipeline_clear(struct ipa *ipa)
 {
 	u32 count = ipa_cmd_pipeline_clear_count();
@@ -605,6 +613,7 @@ void ipa_cmd_pipeline_clear(struct ipa *ipa)
 	if (trans) {
 		ipa_cmd_pipeline_clear_add(trans);
 		gsi_trans_commit_wait(trans);
+		ipa_cmd_pipeline_clear_wait(ipa);
 	} else {
 		dev_err(&ipa->pdev->dev,
 			"error allocating %u entry tag transaction\n", count);
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index a41a58cc2c5ac..6dd3d35cf315d 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -170,8 +170,15 @@ void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans);
  */
 u32 ipa_cmd_pipeline_clear_count(void);
 
+/**
+ * ipa_cmd_pipeline_clear_wait() - Wait pipeline clear to complete
+ * @ipa:	- IPA pointer
+ */
+void ipa_cmd_pipeline_clear_wait(struct ipa *ipa);
+
 /**
  * ipa_cmd_pipeline_clear() - Clear the hardware pipeline
+ * @ipa:	- IPA pointer
  */
 void ipa_cmd_pipeline_clear(struct ipa *ipa);
 
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 68970a3baa47a..8313220d41e70 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -436,6 +436,8 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 	/* XXX This should have a 1 second timeout */
 	gsi_trans_commit_wait(trans);
 
+	ipa_cmd_pipeline_clear_wait(ipa);
+
 	return 0;
 }
 
@@ -1178,7 +1180,30 @@ static bool ipa_endpoint_status_skip(struct ipa_endpoint *endpoint,
 static bool ipa_endpoint_status_tag(struct ipa_endpoint *endpoint,
 				    const struct ipa_status *status)
 {
-	return !!le16_get_bits(status->mask, IPA_STATUS_MASK_TAG_VALID_FMASK);
+	struct ipa_endpoint *command_endpoint;
+	struct ipa *ipa = endpoint->ipa;
+	u32 endpoint_id;
+
+	if (!le16_get_bits(status->mask, IPA_STATUS_MASK_TAG_VALID_FMASK))
+		return false;	/* No valid tag */
+
+	/* The status contains a valid tag.  We know the packet was sent to
+	 * this endpoint (already verified by ipa_endpoint_status_skip()).
+	 * If the packet came from the AP->command TX endpoint we know
+	 * this packet was sent as part of the pipeline clear process.
+	 */
+	endpoint_id = u8_get_bits(status->endp_src_idx,
+				  IPA_STATUS_SRC_IDX_FMASK);
+	command_endpoint = ipa->name_map[IPA_ENDPOINT_AP_COMMAND_TX];
+	if (endpoint_id == command_endpoint->endpoint_id) {
+		complete(&ipa->completion);
+	} else {
+		dev_err(&ipa->pdev->dev,
+			"unexpected tagged packet from endpoint %u\n",
+			endpoint_id);
+	}
+
+	return true;
 }
 
 /* Return whether the status indicates the packet should be dropped */
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index ab0fd5cb49277..c10e7340b0318 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -831,6 +831,7 @@ static int ipa_probe(struct platform_device *pdev)
 	dev_set_drvdata(dev, ipa);
 	ipa->clock = clock;
 	ipa->version = data->version;
+	init_completion(&ipa->completion);
 
 	ret = ipa_reg_init(ipa);
 	if (ret)
-- 
2.20.1

