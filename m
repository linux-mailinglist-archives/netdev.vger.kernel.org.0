Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7CA3D81AF
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhG0VVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233741AbhG0VVL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:21:11 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCF0C0619E7
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:19:37 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id l11so652894iln.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oi6124QyCYE8lAwaOWwJ6X0dUBFbQ7SiwlLUUvXeRnk=;
        b=pQsTQJp+pV6ucEYpVO9R37BS3Z6n7HhaNCkUf5uPmRvwnTDhZHDI5oIyoOocUX5EfY
         NMX6RQI3qZ50JGGlzEbxtQo6JORPn3pN5j8ZuYGbE98OGkjUVuLMiZGya3unQaAbUAHO
         bTaxd1zHp69hgYKM3B3G2c6BTSspXTuD85rWrkNcobVUrDq16zyqdoueK/EYvgjtcgnO
         /RtFcUk+21szVAXoiuenisPfdZTxPezVSWkjOEQhNlz1hsyenSdlqsIJvhjT31sf8O63
         HCaBlWW/xKXXVDbhto1FLCYrpq2z5O8u/g65U9TiBbpS84J7ZM1/EtD2F5wpjCFD/LZ1
         rNsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oi6124QyCYE8lAwaOWwJ6X0dUBFbQ7SiwlLUUvXeRnk=;
        b=umcqf/NJas2tc/75UIXCCY2LgQR17Lw/cBfWc6nB3IsZ9qBy/Ray7BmfRfWLvTaM6r
         1pLJsNpO/91B5QMouhjh3eLo8cRGR7rdMiPRb5FYFJCXjyO3WLIFUrsP5EsW/Mugc7jD
         64kXTiIQ0G4bBhND9MphyQSh1b/K3NtDm00t8PNPV7lkezpZYuJJx/p9NsBmJlZdvmGW
         JzmCjtb9GNxYdApec7Df27YXyZ6mTPzWV1pCIrPWiP4REQ/xcXvqM+pdCU0DJv50yYGR
         iaOe3J+jUjq/UqStYb6NoanELBrNfKhWtkI/pJenFXuSnR9us2lNwEqOp1lC4U04q/DP
         ZQyA==
X-Gm-Message-State: AOAM533XrL5fqYyJdI24EdC4AwmY8qhWtVqGWa/GMWLD1+fyq4Z5wGS8
        8SgNHqRjVKr0+2C+V1BAATp6MA==
X-Google-Smtp-Source: ABdhPJzcyaJkI6fNJ0q61ZLX3iC30S0/fdsI9JBVxjfooN28+0KNz3y7iMqhA941+JWj5X+PAJE5Qw==
X-Received: by 2002:a92:190f:: with SMTP id 15mr17352568ilz.45.1627420777012;
        Tue, 27 Jul 2021 14:19:37 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s21sm3136068iot.33.2021.07.27.14.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:19:36 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: get clock in ipa_probe()
Date:   Tue, 27 Jul 2021 16:19:29 -0500
Message-Id: <20210727211933.926593-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210727211933.926593-1-elder@linaro.org>
References: <20210727211933.926593-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Any entry point that leads to IPA hardware access must ensure the
hardware is operational (clocked).  Currently we ensure this by
taking an extra clock reference during setup that is not released
until we receive a system suspend request.  But this extra reference
will soon go away.

When the platform driver ->probe function is called, we first need
hardware access in ipa_config().  Although ipa_config() takes an IPA
clock reference, it the special reference taken to prevent suspending
the hardware.

Have ipa_probe() take a reference before calling ipa_config(), so
that the "no-suspend" reference can eventually go away.  Drop this
reference before ipa_probe() returns.

Similarly, the driver ->remove function can be called at any time.
Take an IPA clock reference at the beginning of that function, and
drop it again after the deconfig stage has completed (at which point
hardware access is no longer needed).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 5bcc6cd13a9a0..67aba68e6e3b4 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -770,9 +770,12 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_table_exit;
 
+	/* The clock needs to be active for config and setup */
+	ipa_clock_get(ipa);
+
 	ret = ipa_config(ipa, data);
 	if (ret)
-		goto err_modem_exit;
+		goto err_clock_put;	/* Error */
 
 	dev_info(dev, "IPA driver initialized");
 
@@ -781,7 +784,7 @@ static int ipa_probe(struct platform_device *pdev)
 	 * we're done here.
 	 */
 	if (modem_init)
-		return 0;
+		goto out_clock_put;	/* Done; no error */
 
 	/* Otherwise we need to load the firmware and have Trust Zone validate
 	 * and install it.  If that succeeds we can proceed with setup.
@@ -794,11 +797,15 @@ static int ipa_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_deconfig;
 
+out_clock_put:
+	ipa_clock_put(ipa);
+
 	return 0;
 
 err_deconfig:
 	ipa_deconfig(ipa);
-err_modem_exit:
+err_clock_put:
+	ipa_clock_put(ipa);
 	ipa_modem_exit(ipa);
 err_table_exit:
 	ipa_table_exit(ipa);
@@ -824,6 +831,8 @@ static int ipa_remove(struct platform_device *pdev)
 	struct ipa_clock *clock = ipa->clock;
 	int ret;
 
+	ipa_clock_get(ipa);
+
 	if (ipa->setup_complete) {
 		ret = ipa_modem_stop(ipa);
 		/* If starting or stopping is in progress, try once more */
@@ -838,6 +847,9 @@ static int ipa_remove(struct platform_device *pdev)
 	}
 
 	ipa_deconfig(ipa);
+
+	ipa_clock_put(ipa);
+
 	ipa_modem_exit(ipa);
 	ipa_table_exit(ipa);
 	ipa_endpoint_exit(ipa);
-- 
2.27.0

