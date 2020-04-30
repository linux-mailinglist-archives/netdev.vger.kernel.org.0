Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8428F1C097B
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 23:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbgD3VfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 17:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727077AbgD3VfU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 17:35:20 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB310C035495
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:35:19 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id s9so4720797qkm.6
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 14:35:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDbWKqllD32Zzrgur/5ifZ7Q6Ppu2GkH8sQaMON6aEA=;
        b=w8Hp6LU/YnMao27Myy/EieJ66WTJDSb2srpoFkwVQgk1zBbjc4sBbYcXQmdGxG8yV4
         4+QjcJO3M+SNfKmA4X7pjK1uLS+PoVpeG+OTFC6ffSASFPuKAUyFkatsZpwnfbY8eAUb
         njCJL50HuqRTm/46xi4L4sr4JFeAe5LAZSpEkgtb+E7GM7N6s3Rc9rsntbAHNbkxTWX1
         YR0whSuao/79fI8iCxtPcdzhlZhJehTV17LfEuFrRl+LzdRQ3OMEA1MEHprNOJovWaxg
         r4wHyQwQgjQ7eK7aF/8j4Rznag09rMfa2V1x1abhHDqQsLwL1lfXroV1duJcZnCSYM03
         rzlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDbWKqllD32Zzrgur/5ifZ7Q6Ppu2GkH8sQaMON6aEA=;
        b=os8FvYtPmqAGG1o34lr5dxtnBMyjqLG6tTNWuqQLI6hTDMQWNrqwUH6VEutoX8+LLc
         8K7m75q0R0X8quKgVBWPQxb6gwuFT+bIHb0opw0TbGcwWrhntg3pQB2tM2ho8IjuDZSd
         SFQHQbD1PmX8hFZt14UZhoHCMGjt6yOi/C3+50asadOc9EEnDobJ27ViwAzFHzgK+fni
         0DuW0KtJcztJbz454DB+yv2LHF6bIWizgIKl+OnMUtcvekYInpanw1a8AJSvTB1/hGjK
         UnMMJ1kv+MRd6YO7ZkLHuutvv6i4Jd9mER7JEDD0meWNftbrQNk7PeoRvkQnxlSLWLh7
         oobA==
X-Gm-Message-State: AGi0Pub0tuPaOZ+zIF+yhqYEGKMNg9bD3LDS6OkbvKLxk2BNDRxsAu6Y
        fkSNGzTdsQtx52zOdjGSPWgsYA==
X-Google-Smtp-Source: APiQypLrSH7yaDRSRPpYaNxGoA74UjF04aY6CXlzqQMGPLp5Pw5yu1nJ6UVSjdnghjSA5D5aFznHvw==
X-Received: by 2002:a37:aa8e:: with SMTP id t136mr559577qke.175.1588282519043;
        Thu, 30 Apr 2020 14:35:19 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s190sm1112543qkh.23.2020.04.30.14.35.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 14:35:18 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 1/3] net: ipa: fix a bug in ipa_endpoint_stop()
Date:   Thu, 30 Apr 2020 16:35:10 -0500
Message-Id: <20200430213512.3434-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430213512.3434-1-elder@linaro.org>
References: <20200430213512.3434-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_endpoint_stop(), for TX endpoints we set the number of retries
to 0.  When we break out of the loop, retries being 0 means we return
EIO rather than the value of ret (which should be 0).

Fix this by using a non-zero retry count for both RX and TX
channels, and just break out of the loop after calling
gsi_channel_stop() for TX channels.  This way only RX channels
will retry, and the retry count will be non-zero at the end
for TX channels (so the proper value gets returned).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 6de03be28784..a21534f1462f 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1283,7 +1283,7 @@ static int ipa_endpoint_stop_rx_dma(struct ipa *ipa)
  */
 int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
 {
-	u32 retries = endpoint->toward_ipa ? 0 : IPA_ENDPOINT_STOP_RX_RETRIES;
+	u32 retries = IPA_ENDPOINT_STOP_RX_RETRIES;
 	int ret;
 
 	do {
@@ -1291,12 +1291,9 @@ int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
 		struct gsi *gsi = &ipa->gsi;
 
 		ret = gsi_channel_stop(gsi, endpoint->channel_id);
-		if (ret != -EAGAIN)
+		if (ret != -EAGAIN || endpoint->toward_ipa)
 			break;
 
-		if (endpoint->toward_ipa)
-			continue;
-
 		/* For IPA v3.5.1, send a DMA read task and check again */
 		if (ipa->version == IPA_VERSION_3_5_1) {
 			ret = ipa_endpoint_stop_rx_dma(ipa);
-- 
2.20.1

