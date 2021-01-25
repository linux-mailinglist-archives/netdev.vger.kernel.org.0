Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9AA303018
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbhAYX0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732715AbhAYVbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:31:15 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F245C061793
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:58 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id u17so29687344iow.1
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iqgjR1e4tTC1elH7UbXJeMsKuzidjS4eT9TJei8uecI=;
        b=osFJcjiG+Ez7FBpzfNES7O9KKeutX3LZXsqAW7kLdNt123+JY6264IQRdt/RBTwuGY
         C+7NlE0mfTalBI+ULID5XnwXYWNNFkWHu91x8BqoJOycmTAu9t+N3DFzWwDA2VGXgksl
         Y/RcmKnYd2krCIUrbVXtG3jSJrmLAV55hZuS7su4/YJmge98SdRAErEdVJ4nZNwvQVIa
         2muIezqpp5PnTaCCrg30RkAXPmvXHdkFiQHmz7DQE83OtNAqBNWOa4if6S2lJGPowL7L
         QBNVlyGzKADRJAC9v7no0mOy+ydwLDAwj+K8uDuld0WcGabQ21m8BWOphXX5DrOd+vYR
         bROw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iqgjR1e4tTC1elH7UbXJeMsKuzidjS4eT9TJei8uecI=;
        b=susBTjewGEIvn+PQeqy0TqoqqwKrvvkWBub76ojUUGqc8Ta/Oi9kDjj+0EbPgV31yf
         etQH+tIu9syAfL9UI7ADMb0307kd44B3zGxe5mSa7hHRTvraLyv424hTlEsSLWpYXWVF
         7M24VGH2U2TWCEpfn+0WLxJ+72Yv2ti5ZrhF9FYyfsi/exn3cJgWRDfXEC++vM9iMerr
         ICnTT3DqmhChQHYhTBttcq72rV4hLKTyNysJet5a9rsiTOU19LyQ5HtbjIsjdmbqFtvQ
         M7Xqn6dp+s5ydj3ROlvHQofoGkNAWbV28rUs1LGKKm3joI8GTzwWBcBgVmKChWR174XK
         Mzug==
X-Gm-Message-State: AOAM532NRvL3XAXajN+w555P9L4+kOzsMwwzqODNUI4VtHnqO6zqKTts
        Jk/30QXAlpsQv9HznIE0IwjFxQ==
X-Google-Smtp-Source: ABdhPJxankEcZ4hMidjK+Yiz//ksUk6O71p0G87exvA0fWKOOLf4HrK+oGXJTaN8thKbeYLgPYhC+Q==
X-Received: by 2002:a92:7d14:: with SMTP id y20mr1978742ilc.196.1611610197543;
        Mon, 25 Jan 2021 13:29:57 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o18sm11136241ioa.39.2021.01.25.13.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:29:57 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: don't pass tag value to ipa_cmd_ip_tag_status_add()
Date:   Mon, 25 Jan 2021 15:29:46 -0600
Message-Id: <20210125212947.17097-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210125212947.17097-1-elder@linaro.org>
References: <20210125212947.17097-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We only send a tagged packet from the AP->command TX endpoint when
we're clearing the hardware pipeline.  And when we receive the
tagged packet we don't care what the actual tag value is.

Stop passing a tag value to ipa_cmd_ip_tag_status_add(), and just
encode 0 as the tag sent.  Fix the function that encodes the tag so
it uses the proper byte ordering.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index 7df0072bddcce..eb50e7437359a 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -529,7 +529,7 @@ void ipa_cmd_dma_shared_mem_add(struct gsi_trans *trans, u32 offset, u16 size,
 			  direction, opcode);
 }
 
-static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans, u64 tag)
+static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
 	enum ipa_cmd_opcode opcode = IPA_CMD_IP_PACKET_TAG_STATUS;
@@ -543,7 +543,7 @@ static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans, u64 tag)
 	cmd_payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
 	payload = &cmd_payload->ip_packet_tag_status;
 
-	payload->tag = u64_encode_bits(tag, IP_PACKET_TAG_STATUS_TAG_FMASK);
+	payload->tag = le64_encode_bits(0, IP_PACKET_TAG_STATUS_TAG_FMASK);
 
 	gsi_trans_cmd_add(trans, payload, sizeof(*payload), payload_addr,
 			  direction, opcode);
@@ -583,13 +583,13 @@ void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans)
 	 * command says to send the next packet directly to the exception
 	 * endpoint without any other IPA processing.  The tag_status
 	 * command requests that status be generated on completion of
-	 * that transfer, and that it will contain the given tag value.
+	 * that transfer, and that it will be tagged with a value.
 	 * Finally, the transfer command sends a small packet of data
 	 * (instead of a command) using the command endpoint.
 	 */
 	endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
 	ipa_cmd_ip_packet_init_add(trans, endpoint->endpoint_id);
-	ipa_cmd_ip_tag_status_add(trans, 0xcba987654321);
+	ipa_cmd_ip_tag_status_add(trans);
 	ipa_cmd_transfer_add(trans, 4);
 }
 
-- 
2.20.1

