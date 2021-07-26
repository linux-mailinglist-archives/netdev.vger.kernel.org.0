Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A672E3D67EB
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 22:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbhGZTbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 15:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhGZTbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 15:31:13 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C915DC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:41 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id r18so13489000iot.4
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 13:11:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EcVZ6uLqTzi0vdrkZnez1ZLjp+fPM1xVTEzZ6l8/XNI=;
        b=AxxmeeSipjWwNHuPrxNL0tCah1QB5ybdW2X9RExe2+Z8tejjZ3MrFEClHVWyen21Uw
         uRU7A98eEfnESa/BS91Ict2LBJ0mJC4F8pX/KIID1KZLY2yX4zIacOSl2T0bLACuCBqv
         vVob5+VFUGmlLuRohhKoqEYo+eA6Rez68jsNyqlMYoLcSAS87NPsdu3O5tzsP3pX6gB7
         TZPoyFPvoYiQFXjRBS56rhq/39bKvjuqL4+WaIUFzqRlD0wx+Q8okc86e2vuS6Agz6cw
         KwDOX6DZLvioR/iwoBRMjBYmQLjuPfkS1cxC63d31OI5oUSArbZCOL2t5J3jAx4BmYU+
         8taA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EcVZ6uLqTzi0vdrkZnez1ZLjp+fPM1xVTEzZ6l8/XNI=;
        b=adDvAgERcAIdGnQV8HBVlrwmz7V1HfY8qZoHhzpBaNZ319zt/2BdfDUEvZ+VYG5M+o
         ns+MfVGdkIaMenI9WAC6H0Q6BZk/Q3BlxJTaCRVY2/NQ1muxfQKMeDdJ7us3kxuw1Rml
         9cB9tgwSUpI7GJ37OAcUlVTj7w5hzCtnqfmhhYD8wXB9ao52285whs7kA+vnbCehWRpW
         Fc+bN1WLl4PVdCoUj9E3hVahv6TpDrwtz9kcsJJy7RSibig5aBqIRYAeGjXgJSt4Rw+j
         yTIfELCq+hbb5ddLlTNy3O9ya0OLf0+c6JFfJXsaDdUhAcdwW7HsYEntVj8mOcmDtaev
         KCZw==
X-Gm-Message-State: AOAM532FugVOnZ8E1kDbKz87R5wj30OzJ9YY1LlLFlNcAqAYZ9eiZFTd
        yxRgRZzbsAPEiFX1dpFaqeG9LA==
X-Google-Smtp-Source: ABdhPJwk0CAuPxnXxR9QpqmONVifuqCRD2GIxkZZZ1eXETRC+We7HBNVHBE/eMdcz48DYPU5vr90lA==
X-Received: by 2002:a05:6638:130d:: with SMTP id r13mr18115683jad.103.1627330301265;
        Mon, 26 Jul 2021 13:11:41 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z10sm425964iln.8.2021.07.26.13.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 13:11:40 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/5] net: ipa: configure memory regions early
Date:   Mon, 26 Jul 2021 15:11:33 -0500
Message-Id: <20210726201136.502800-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210726201136.502800-1-elder@linaro.org>
References: <20210726201136.502800-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA-resident memory is one of the most primitive resources that
needs initialization, so call init_mem_config() early in
ipa_config().

This is in preparation for initializing the IPA-resident
microcontroller earlier.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 91e2ec3a0c133..8768e52854d08 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -471,31 +471,31 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 
 	ipa_hardware_config(ipa, data);
 
-	ret = ipa_endpoint_config(ipa);
-	if (ret)
-		goto err_hardware_deconfig;
-
 	ret = ipa_mem_config(ipa);
 	if (ret)
-		goto err_endpoint_deconfig;
+		goto err_hardware_deconfig;
+
+	ret = ipa_endpoint_config(ipa);
+	if (ret)
+		goto err_mem_deconfig;
 
 	ipa_table_config(ipa);		/* No deconfig required */
 
 	/* Assign resource limitation to each group; no deconfig required */
 	ret = ipa_resource_config(ipa, data->resource_data);
 	if (ret)
-		goto err_mem_deconfig;
+		goto err_endpoint_deconfig;
 
 	ret = ipa_modem_config(ipa);
 	if (ret)
-		goto err_mem_deconfig;
+		goto err_endpoint_deconfig;
 
 	return 0;
 
-err_mem_deconfig:
-	ipa_mem_deconfig(ipa);
 err_endpoint_deconfig:
 	ipa_endpoint_deconfig(ipa);
+err_mem_deconfig:
+	ipa_mem_deconfig(ipa);
 err_hardware_deconfig:
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
@@ -510,8 +510,8 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 static void ipa_deconfig(struct ipa *ipa)
 {
 	ipa_modem_deconfig(ipa);
-	ipa_mem_deconfig(ipa);
 	ipa_endpoint_deconfig(ipa);
+	ipa_mem_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
 }
-- 
2.27.0

