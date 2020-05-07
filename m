Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5023B1C9AA1
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728485AbgEGTOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEGTON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 15:14:13 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C85EBC05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 12:14:12 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id i14so27488qka.10
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 12:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wX5XMHdz/M+4Ly0oHrP6bxAEiJLYb6cRVv2K95uxWwg=;
        b=T5BWfYqNoQpnrJCv2Ie2wfQiVRMiIaKJyfhlfrVqofUztNcEQUPykFlaw/fEkXaftJ
         IFMjTrwM5xiQ7gMyBdrIrSvMGzAmcAFrhWFM/G10PVdY/mT419WU3MP4OneVGI7Ha2kv
         PDp8jTbBPD6hECoa40AYj2kN6YAFtJneX1VgtqJE2hn3pGhDADp2kJr9ydJucBT5ciHn
         +a19RDzcDiGTOKZe6l7WmR2rOCE+yyKnfQzHt62nNUroJsZQNsWqAimJVxY/V7Me7Vuk
         WLQTtkXUsMghQp00pN/Lh8VswyWGwvi+bP/8IOaVZc4ijatKaOeKM+SYvxUevZ46Iog7
         jheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wX5XMHdz/M+4Ly0oHrP6bxAEiJLYb6cRVv2K95uxWwg=;
        b=tHiffQUotzFfeQYIg3dAGcUDj/PUnnVXUiE7pEX2wKAQGmNwesa1umIr9KMS4ljXoz
         6axmMtMEVUAfC9WBamCruU9VgW5rv4ArVWYLHZC4D77oG2WaP1UabjGm2maYd6zqBkyL
         eHXXD4i3iK5XKCzL1IRvzxYG1/6hErAdG8o4QMR5ivF+1JToiF4H21M2kufvb/Uu+PNQ
         /j1Azr9a9FYHAcJI3jVn4x4PMjhrcNbUBYGZtc7S59B0ogXswm/zgnYDi8oDCvCquV9R
         cRcRy6zYykoQTUPRoZ6CwLtqOCL+Pt8AByyktVUhZVG79RtSK0c06HXd+LTFwoEALR2p
         3A9A==
X-Gm-Message-State: AGi0PubIIEmO42ZPjPxncTIzoIdlNrWKBpeWMR1D3salGhyc6E5fNQjT
        73jZqyrpexbjjwbqbpdB+XhmsQ==
X-Google-Smtp-Source: APiQypJGLda9xBHWwenDCQAcn6P3cH5cZURCVuyFJBA8E3DVDslgKP5Y2647O3Sycr93BkqdJvg8wA==
X-Received: by 2002:a05:620a:13b5:: with SMTP id m21mr15794630qki.208.1588878852049;
        Thu, 07 May 2020 12:14:12 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j8sm5094236qtk.85.2020.05.07.12.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 12:14:11 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 2/2] net: ipa: use tag process on modem crash
Date:   Thu,  7 May 2020 14:14:04 -0500
Message-Id: <20200507191404.31626-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200507191404.31626-1-elder@linaro.org>
References: <20200507191404.31626-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One part of recovering from a modem crash is performing a "tag
sequence" of several IPA immediate commands, to clear the hardware
pipeline.  The sequence ends with a data transfer request on the
command endpoint (which is not otherwise done).  Unfortunately,
attempting to do the data transfer led to a hang, so that request
plus two other commands were commented out.

The previous commit fixes the bug that was causing that hang.  And
with that bug fixed we can properly issue the tag sequence when the
modem crashes, to return the hardware to a known state.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_cmd.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index d226b858742d..cee417181f98 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -628,23 +628,15 @@ static void ipa_cmd_transfer_add(struct gsi_trans *trans, u16 size)
 
 void ipa_cmd_tag_process_add(struct gsi_trans *trans)
 {
-	ipa_cmd_register_write_add(trans, 0, 0, 0, true);
-#if 1
-	/* Reference these functions to avoid a compile error */
-	(void)ipa_cmd_ip_packet_init_add;
-	(void)ipa_cmd_ip_tag_status_add;
-	(void) ipa_cmd_transfer_add;
-#else
 	struct ipa *ipa = container_of(trans->gsi, struct ipa, gsi);
-	struct gsi_endpoint *endpoint;
+	struct ipa_endpoint *endpoint;
 
 	endpoint = ipa->name_map[IPA_ENDPOINT_AP_LAN_RX];
+
+	ipa_cmd_register_write_add(trans, 0, 0, 0, true);
 	ipa_cmd_ip_packet_init_add(trans, endpoint->endpoint_id);
-
 	ipa_cmd_ip_tag_status_add(trans, 0xcba987654321);
-
 	ipa_cmd_transfer_add(trans, 4);
-#endif
 }
 
 /* Returns the number of commands required for the tag process */
-- 
2.20.1

