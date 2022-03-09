Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A96E4D3A06
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 20:22:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237735AbiCITWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 14:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237655AbiCITVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 14:21:52 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84C98F70EC
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:20:50 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id i1so2209927ila.7
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 11:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmF/moFaP2vIu3wyyPlPwTNgQVyw6cgxTUQxtgkWdeo=;
        b=tZQL42LMw7w8qEoQcgr/zFzmySjiweyFNh4ph819TAVXx1+OsZuq2+ZApoTwXoYSnj
         oHyAumuKdNS1V9uoLZ0FMpitmvSHy5bUpKwUIpCeLWDNwTkrdcBgiD5UXIxo3gS460V5
         0Cdwbg4W6y53NYQdwmVJOCxhlLATTFfEnlgmiGfXLMm6u5pbrzYEZKdArA52pjZBqheU
         huFXMXcW0e0JlNrjsI455N5hNFzHSMlFmEaEdSsE753r2MIIyoDsAT4nWuMNOgD0p8HU
         +0aDommrpl9rOZc+uJCqvMEmTn0zu3GoR8WxmyJtIGOxbLc9qfRXkALfU8Ko3oSBXWfM
         gTLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmF/moFaP2vIu3wyyPlPwTNgQVyw6cgxTUQxtgkWdeo=;
        b=drYmU3nzrfm8AOialBDPrBAPFyyrrb0gUAfM8R5Se9l/2bURx4XunkEnt93mixV6xk
         TWP62pJWDBJFckbagyq/QkS5FKhmTHoJ6HlT44fz10iN5lmzq9r9tGy4tjhhC9SU3d9B
         TFSJpgDc7SDMnREeaYsKiWH7POq4/Z/BpxSZgi6sM7iXU9eOdkXtr1Unf/vGj8EUnGma
         SiMlTFFIAXQ8F5zsJeo7gZ+2CAzQ/ihzVgj4dYJ1jeR7TO4TIdaPHcoHfYnh4jnoq2N7
         7aMLFPljWo5EM3uuB4sSsvyIy+QIak7ZsvDKQQF2GRhrbQiRWSvbxLGRw74pAqX252P4
         20Jw==
X-Gm-Message-State: AOAM531fxOokpyqPDOXhb/cL5qzwoymUr6O6GAGmMbr9lg4Zi0xqODSl
        n8+Pvf3cjEp2374Lj8RuuVvctg==
X-Google-Smtp-Source: ABdhPJzPrDgilD+IdsuARRSJnLjVmuLnZzSIbM26fRO56upgn5UdKvFS9Q7eftjgYS1yG3MpiGDHJw==
X-Received: by 2002:a05:6e02:20e8:b0:2c1:e164:76e6 with SMTP id q8-20020a056e0220e800b002c1e16476e6mr726884ilv.135.1646853649808;
        Wed, 09 Mar 2022 11:20:49 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id g8-20020a056602248800b006409fb2cbccsm1389182ioe.32.2022.03.09.11.20.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 11:20:49 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     djakov@kernel.org, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/7] net: ipa: use bulk interconnect initialization
Date:   Wed,  9 Mar 2022 13:20:35 -0600
Message-Id: <20220309192037.667879-6-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220309192037.667879-1-elder@linaro.org>
References: <20220309192037.667879-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch used bulk interconnect operations to initialize
IPA interconnects one at a time.  This rearranges things to use the
bulk interfaces as intended--on all interconnects together.  As a
result ipa_interconnect_init_one() and ipa_interconnect_exit_one()
are no longer needed.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_power.c | 66 +++++++++++++------------------------
 1 file changed, 23 insertions(+), 43 deletions(-)

diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index c0da1274f5d67..b1f6978dddadb 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -70,38 +70,6 @@ struct ipa_power {
 	struct icc_bulk_data *interconnect;
 };
 
-static int ipa_interconnect_init_one(struct device *dev,
-				     struct icc_bulk_data *interconnect,
-				     const struct ipa_interconnect_data *data)
-{
-	int ret;
-
-	/* interconnect->path is filled in by of_icc_bulk_get() */
-	interconnect->name = data->name;
-	interconnect->avg_bw = data->average_bandwidth;
-	interconnect->peak_bw = data->peak_bandwidth;
-
-	ret = of_icc_bulk_get(dev, 1, interconnect);
-	if (ret)
-		return ret;
-
-	/* All interconnects are initially disabled */
-	icc_bulk_disable(1, interconnect);
-
-	/* Set the bandwidth values to be used when enabled */
-	ret = icc_bulk_set_bw(1, interconnect);
-	if (ret)
-		icc_bulk_put(1, interconnect);
-
-	return ret;
-}
-
-static void ipa_interconnect_exit_one(struct icc_bulk_data *interconnect)
-{
-	icc_bulk_put(1, interconnect);
-	memset(interconnect, 0, sizeof(*interconnect));
-}
-
 /* Initialize interconnects required for IPA operation */
 static int ipa_interconnect_init(struct ipa_power *power, struct device *dev,
 				 const struct ipa_interconnect_data *data)
@@ -116,18 +84,34 @@ static int ipa_interconnect_init(struct ipa_power *power, struct device *dev,
 		return -ENOMEM;
 	power->interconnect = interconnect;
 
+	/* Initialize our interconnect data array for bulk operations */
 	while (count--) {
-		ret = ipa_interconnect_init_one(dev, interconnect, data++);
-		if (ret)
-			goto out_unwind;
+		/* interconnect->path is filled in by of_icc_bulk_get() */
+		interconnect->name = data->name;
+		interconnect->avg_bw = data->average_bandwidth;
+		interconnect->peak_bw = data->peak_bandwidth;
+		data++;
 		interconnect++;
 	}
 
+	ret = of_icc_bulk_get(dev, power->interconnect_count,
+			      power->interconnect);
+	if (ret)
+		goto err_free;
+
+	/* All interconnects are initially disabled */
+	icc_bulk_disable(power->interconnect_count, power->interconnect);
+
+	/* Set the bandwidth values to be used when enabled */
+	ret = icc_bulk_set_bw(power->interconnect_count, power->interconnect);
+	if (ret)
+		goto err_bulk_put;
+
 	return 0;
 
-out_unwind:
-	while (interconnect-- > power->interconnect)
-		ipa_interconnect_exit_one(interconnect);
+err_bulk_put:
+	icc_bulk_put(power->interconnect_count, power->interconnect);
+err_free:
 	kfree(power->interconnect);
 	power->interconnect = NULL;
 
@@ -137,11 +121,7 @@ static int ipa_interconnect_init(struct ipa_power *power, struct device *dev,
 /* Inverse of ipa_interconnect_init() */
 static void ipa_interconnect_exit(struct ipa_power *power)
 {
-	struct icc_bulk_data *interconnect;
-
-	interconnect = power->interconnect + power->interconnect_count;
-	while (interconnect-- > power->interconnect)
-		ipa_interconnect_exit_one(interconnect);
+	icc_bulk_put(power->interconnect_count, power->interconnect);
 	kfree(power->interconnect);
 	power->interconnect = NULL;
 }
-- 
2.32.0

