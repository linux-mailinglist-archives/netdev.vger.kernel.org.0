Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A137720F4EE
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 14:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387863AbgF3Moy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 08:44:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387836AbgF3Mou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 08:44:50 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1D2C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:44:50 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i4so20771424iov.11
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 05:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0fzm9ivbOZhTMkiMv3HS0noPXFaLM5j356lho+0tq40=;
        b=afhODrlyuRuSgJChUpQG2XY3nveWqjldkpWmGxxjIP0xJfH/0BJkI+Jh3eGsxnB+OR
         zutMm5QTTporiO9wAqYMbWs0bD5SB4tuBfpn+yDG2UL3a5LtawbTw0TZkt9J9ZmJO5BL
         t5Xbl1+kb72T6t5ovYqhZ1/H528+/djnLm+JWr/D6/Jl4ryQ8ekHTVssYXrVdlFovycI
         0iZiQc4jS222M1OpzWLp30LY5Sf4SdC7YMxra1Fak0RGs/fDOSrceJDBRvCHBFvpxlZV
         vY6xDrgDR45SvZ0N9UgWqZsriKpkx/UnmA23ktp2IYVlQ8l208uKpl8JVE8KhVV5U6Hm
         TGVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0fzm9ivbOZhTMkiMv3HS0noPXFaLM5j356lho+0tq40=;
        b=sucbjdqUWgI2zAeIkSSPh5moZuegI1lSjMnD1sMoT73fO9nLpgcCZuAIwxwox3sW08
         /oUpQ+7dlh74+PsJuSJKj2fOTET0IpZu3xEIKAQKP5omvl20SQ6Fo8IQCmVqOD+8z/TR
         SL+zQmCATGcRqy8nKKwhOXvj5q2pTm3HimAMqBqI+D6ZUsNs4CeIlF1pzRBXfNTSvGVy
         bzK8W5bbM1k2K22qq7q9fJXKTlznBOjTHOHM74UErWaywWMuMSxlA+dVeKsA2TLwVt1U
         x5vRgliN1M1H5d0hdmMV3w0nHdCx8t6jYKzsQStfgTAmPliWGYbqZphZ5M2/5DXBdHUA
         RI/A==
X-Gm-Message-State: AOAM530zIJKulYteuTIPRpV5PPmy0Gl3rukeemOO409nPyHp4JyDld+2
        o1PbXJJuz2RkADLUyzyhe2DTDg==
X-Google-Smtp-Source: ABdhPJxwuCQKXzJ4+E1VHwYwm85X9sscQdUMNA9Fsw/KOgUIafz6HoyQtbTCkf1qhN6Kf9Gouy1ydA==
X-Received: by 2002:a02:694c:: with SMTP id e73mr23210222jac.17.1593521090058;
        Tue, 30 Jun 2020 05:44:50 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id t83sm1697536ilb.47.2020.06.30.05.44.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 05:44:49 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 2/3] net: ipa: no checksum offload for SDM845 LAN RX
Date:   Tue, 30 Jun 2020 07:44:43 -0500
Message-Id: <20200630124444.1240107-3-elder@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200630124444.1240107-1-elder@linaro.org>
References: <20200630124444.1240107-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The AP LAN RX endpoint should not have download checksum offload
enabled.

The receive handler does properly accommodate the trailer that's
added by the hardware, but we ignore it.

Fixes: 1ed7d0c0fdba ("soc: qcom: ipa: configuration data")
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Fixed typo in description, and added "Fixes" tag.

 drivers/net/ipa/ipa_data-sdm845.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 52d4b84e0dac..de2768d71ab5 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -44,7 +44,6 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 		.endpoint = {
 			.seq_type	= IPA_SEQ_INVALID,
 			.config = {
-				.checksum	= true,
 				.aggregation	= true,
 				.status_enable	= true,
 				.rx = {
-- 
2.25.1

