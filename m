Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96143303019
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 00:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732031AbhAYX0M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 18:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732718AbhAYVbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 16:31:16 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FE6C0617A7
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:59 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id q1so29610482ion.8
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 13:29:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4XCw/DKlPzbfEbK7Wq85mEUjWal6SYNVmWAVH0HVNQI=;
        b=uKrUBC6NtBeeBE5pBcIlAHijHnMqgRB+8kn6DDkVpxUgdLA6xk38TqUQFJZCNE8Pbx
         fu57WVKL5YvDES5X1NDRvtC9src9XPPx/9olwnQtBvMOLvXyhl1ww4Do5ED9pPC+g7SC
         iPIdAv2NfLbOa+s7iCcSyCePnPNjAUqNDD224NwHcZtTEFDnLTkCd8syC4VPZSgMG9Ho
         29a84K1IQQGEu3RO1BVJzAR6m4D+cTyZHK/dHYPKFXxoSq5awz55OzQdA87a9qHgSItc
         DdXi7Hg2Qsw0uKwL6ZX9P5Sn8XrJDw+9BN9DKum6Ueg7NJ/5ugGldHfSLjjRaSj8Y27j
         EUKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4XCw/DKlPzbfEbK7Wq85mEUjWal6SYNVmWAVH0HVNQI=;
        b=YezSGb0RWKdEqWcQBiqpVIF0fyw4jYO5llFk+8aEbXQbFd6Q2bnsjv+Gql99l3Me/w
         dG2bf5UZ/Muog8eYUOOcbUSAEDqqMp5sIoAJ1ORdA7iKFivReFYFfndkgP6I0vMl+3xA
         VP1f2ahI8++yhOmKKnAmuzMqTGdEwLAFtXqivjxNHqxFDkKGAiZwawZw1w57OfDvMSsj
         yaDE1+GNeaNZ/3xhlR/zGbn8xy6f4w7f4FPP7jQXYOOboOehN/c4HMb7J+o27zJNr3B1
         1qIqfoZmN7wiQTxejU+nNODRtZa5r1XVPHMchauGO+W8fXjoTkHVGvCIXT0nGw8KqGKU
         8mxQ==
X-Gm-Message-State: AOAM533DUx9Z5sAGGZ85EfKGaThrv6MWdq7D/2iO54nrWr9D3H91lVyc
        HMVFDC1dsZwNdcqR1ChieayhvA==
X-Google-Smtp-Source: ABdhPJwk/ZJfk8NN/aPZKInJLMmllmE3RFmXUuyFJ6tyH6q8A/WhDStVnEyYvxUS3uqHxPRwbdEqtg==
X-Received: by 2002:a5d:8887:: with SMTP id d7mr1940535ioo.151.1611610198567;
        Mon, 25 Jan 2021 13:29:58 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id o18sm11136241ioa.39.2021.01.25.13.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 13:29:58 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: don't pass size to ipa_cmd_transfer_add()
Date:   Mon, 25 Jan 2021 15:29:47 -0600
Message-Id: <20210125212947.17097-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210125212947.17097-1-elder@linaro.org>
References: <20210125212947.17097-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only time we transfer data (rather than issuing a command) out
of the AP->command TX endpoint is when we're clearing the hardware
pipeline.  All that's needed is a "small" data buffer, and its
contents aren't even important.

For convenience, we just transfer a command structure in this case
(it's already mapped for DMA).  The TRE is added to a transaction
using ipa_cmd_ip_tag_status_add(), but we ignore the size value
provided to that function.  So just get rid of the size argument.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index eb50e7437359a..97b50fee60089 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -550,7 +550,7 @@ static void ipa_cmd_ip_tag_status_add(struct gsi_trans *trans)
 }
 
 /* Issue a small command TX data transfer */
-static void ipa_cmd_transfer_add(struct gsi_trans *trans, u16 size)
+static void ipa_cmd_transfer_add(struct gsi_trans *trans)
 {
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
 	enum dma_data_direction direction = DMA_TO_DEVICE;
@@ -558,8 +558,6 @@ static void ipa_cmd_transfer_add(struct gsi_trans *trans, u16 size)
 	union ipa_cmd_payload *payload;
 	dma_addr_t payload_addr;
 
-	/* assert(size <= sizeof(*payload)); */
-
 	/* Just transfer a zero-filled payload structure */
 	payload = ipa_cmd_payload_alloc(ipa, &payload_addr);
 
@@ -590,7 +588,7 @@ void ipa_cmd_pipeline_clear_add(struct gsi_trans *trans)
 	endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
 	ipa_cmd_ip_packet_init_add(trans, endpoint->endpoint_id);
 	ipa_cmd_ip_tag_status_add(trans);
-	ipa_cmd_transfer_add(trans, 4);
+	ipa_cmd_transfer_add(trans);
 }
 
 /* Returns the number of commands required to clear the pipeline */
-- 
2.20.1

