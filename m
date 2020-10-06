Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5262853E5
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 23:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgJFVbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 17:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727301AbgJFVa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 17:30:57 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B0BC0613D3
        for <netdev@vger.kernel.org>; Tue,  6 Oct 2020 14:30:57 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so68624ior.2
        for <netdev@vger.kernel.org>; Tue, 06 Oct 2020 14:30:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qs9Gy3dxzM7xaThHwcW4AxTAzloEsG+6Jlaezs70FgI=;
        b=JJREY7PRIfXcfFUfrKQ0pV2ZtTzN3H1y28QrSUrmiP0RDxh0oUYkKafN6gCc2kfkqt
         R1kog4Sn/ZPdmKpcixk8bbWS0BvSd8JwPujsLgrNkOsvTadS5lf4gYitrKf8mKMgI6wh
         mriTtJa1fxhS1GQJyNLaar0GYQ8BATzhYFkS6tqiBEYWPiUj/Rj0yMqC19NRzBcEsvqP
         cL0qjX1KW27H4x865EIJOuaaA3luz+CMJAZUHYv5hYMTHji0wkNJ5HMvYFFpTKcT9KbI
         jTWM1Tdjb+HBuJmZWYLaLOam+2lBYPbENZxa/MAJdRG3ymw3o3qLER9rhM1mRuZcI0mH
         E0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qs9Gy3dxzM7xaThHwcW4AxTAzloEsG+6Jlaezs70FgI=;
        b=G+wJmMYPUvdHoXxjdeqX6KMgQtdpc9kNPgQ+dlxE4TiBRo87+H0UXL+/j4sF74YjfZ
         KNA84yKPL3CGO5cC2So1/eW5D1QGH8gDPWTXegm3pTHkyg3j3W8JVWoT+S+UwouXLU7u
         H2Yaca2wv6+6zskB0Z9LNYeWdvg/aT/50lykYtZKoEwE4Z0jt9hWQ6aTD0J5NT2jD6Fj
         qbGrB+fCUap73sAlyjZHaqwVEPqi3fBuMs4pMKbrbEFQ3twWAky3bTQnsuio/rKqN+eE
         FaiFm+2Id9D5U/ldQiPNt4r3wc4s4iILDLi34WZd7UNZvLdUJ1khpaOj590LZ3PBQE34
         5ymg==
X-Gm-Message-State: AOAM5304+j6eaEhU5ivgG7vy/flDTV0aDWfpN5jXC+FFmwOR4hPyRlL3
        Qrnmg/Bk4t+PnXK9H9hkF8w1Lw==
X-Google-Smtp-Source: ABdhPJzp6fzi8JE8LPCtdYy1WOfzLeWtA7+QJwd9ggA1EAXbQTtSt3ayQUIKQIXmN/8d0vwMu1mRCQ==
X-Received: by 2002:a6b:9243:: with SMTP id u64mr2733135iod.197.1602019856978;
        Tue, 06 Oct 2020 14:30:56 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z20sm2043215ior.2.2020.10.06.14.30.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 14:30:56 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        mka@chromium.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net 1/2] net: ipa: only clear hardware state if setup has completed
Date:   Tue,  6 Oct 2020 16:30:46 -0500
Message-Id: <20201006213047.31308-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201006213047.31308-1-elder@linaro.org>
References: <20201006213047.31308-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the setup phase of initialization, GSI firmware gets loaded
and initialized, and the AP command TX and default RX endpoints
get set up.  Until that happens, IPA commands must not be issued
to the hardware.

If the modem crashes, we stop endpoint channels and perform a
number of other activities to clear modem-related IPA state,
including zeroing filter and routing tables (using IPA commands).
This is a bug if setup is not complete.  We should also not be
performing the other cleanup activity in that case either.

Fix this by returning immediately when handling a modem crash if we
haven't completed setup.

Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
Tested-by: Matthias Kaehlcke <mka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index e34fe2d77324e..dd5b89c5cb2d4 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -285,6 +285,9 @@ static void ipa_modem_crashed(struct ipa *ipa)
 	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
+	if (!ipa->setup_complete)
+		return;
+
 	ipa_endpoint_modem_pause_all(ipa, true);
 
 	ipa_endpoint_modem_hol_block_clear_all(ipa);
-- 
2.20.1

