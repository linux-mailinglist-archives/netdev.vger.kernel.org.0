Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A8D21222E
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 13:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbgGBLZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 07:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728707AbgGBLZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 07:25:43 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9FEC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 04:25:43 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t4so10693877iln.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 04:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kp2cMksA2bKPwFtLgY/MdRQdPPtTBA5vqesfT2+0hjc=;
        b=ZpOKoGgZlAuRQs5w7DsHYa62CW16hmQWM1HcZzK51k7rMZJhv1MF74+eKeB3DU2pg1
         NI63CGILl/2WsASLDtzkHVaA8SZTgeodbnefw5lVLFDFXAgqNbEgoo80GPd4m+e3isKS
         /jxYBRTrYTVzHBkm+nNNQy0nymA69OgsbmEfoGuN6KhUp/at28+S+Idug6ETvajRv1JI
         227hCdaggbcuw5getFtTppHvKwaiVfji5Vjm3218MNLEaat/ArxfEgZTWcjgsIEutyhQ
         MsuH6ki5461HFzUqhcTYzDZ0T4gDlF+Bqxfa6F48UMJVynAO0RLa0v67UJwWL9D5iVDa
         tj+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kp2cMksA2bKPwFtLgY/MdRQdPPtTBA5vqesfT2+0hjc=;
        b=A5Cq8wyDELvhBIstYyhj24bvb4tmrzwbket92FHb/81L6K5WKxl2vohfvSlkh0zdid
         HihiQoQiu9LntBOkhJckruYlI3cmfyZRPgLSCmkGbk1DBwu0OAo1hidmvbUqAtyhnC95
         lVS0rbzJXqC0OKvP76O2RSbiSiMinu0/32z9dxlC6JN7DGvHQASqdBD29M83fLHpIakd
         Q+4vh9QAc0DWUDXm0RjOUXNaGqa+SJGF2xzq1al5mKxsYIGnPXnaDmSHQj8qqwdFwH7a
         H9t3ucQlSizXH4Ee07eDkeVYCMEbmog/vms1N8Ydg/1RXpuGpcLNhOaoQo5F08/pk805
         qTJQ==
X-Gm-Message-State: AOAM532+98qHcEe4fRvZkaWeNThdl/QZUVLOE03e5+sIGw6l0c4YWmyl
        dDFdQVg4OwKRO8Z5kwgrMiKVUA==
X-Google-Smtp-Source: ABdhPJwEv0HnyP43dQAbI1RSDGyNlCw4/LxYtvhyIKCZJLEssNc1xhU9uEsBvjwtkgqrnjdbjWfRfA==
X-Received: by 2002:a92:c087:: with SMTP id h7mr11803456ile.279.1593689142638;
        Thu, 02 Jul 2020 04:25:42 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id c3sm4692842ilj.31.2020.07.02.04.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 04:25:42 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/4] net: ipa: move version test inside ipa_endpoint_program_delay()
Date:   Thu,  2 Jul 2020 06:25:34 -0500
Message-Id: <20200702112537.347994-2-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200702112537.347994-1-elder@linaro.org>
References: <20200702112537.347994-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA version 4.2 has a hardware quirk that affects endpoint delay
mode, so it isn't used there.  Isolate the test that avoids using
delay mode for that version inside ipa_endpoint_program_delay(),
rather than making that check in the caller.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index a7b5a6407e8f..7f4bea18bd02 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -318,7 +318,9 @@ ipa_endpoint_program_delay(struct ipa_endpoint *endpoint, bool enable)
 {
 	/* assert(endpoint->toward_ipa); */
 
-	(void)ipa_endpoint_init_ctrl(endpoint, enable);
+	/* Delay mode doesn't work properly for IPA v4.2 */
+	if (endpoint->ipa->version != IPA_VERSION_4_2)
+		(void)ipa_endpoint_init_ctrl(endpoint, enable);
 }
 
 /* Returns previous suspend state (true means it was enabled) */
@@ -1294,8 +1296,7 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 {
 	if (endpoint->toward_ipa) {
-		if (endpoint->ipa->version != IPA_VERSION_4_2)
-			ipa_endpoint_program_delay(endpoint, false);
+		ipa_endpoint_program_delay(endpoint, false);
 		ipa_endpoint_init_hdr_ext(endpoint);
 		ipa_endpoint_init_aggr(endpoint);
 		ipa_endpoint_init_deaggr(endpoint);
-- 
2.25.1

