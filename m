Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75A34AA076
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 20:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbiBDTvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 14:51:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbiBDTvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 14:51:01 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB00C061756
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 11:50:56 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id s18so8663554ioa.12
        for <netdev@vger.kernel.org>; Fri, 04 Feb 2022 11:50:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmF/moFaP2vIu3wyyPlPwTNgQVyw6cgxTUQxtgkWdeo=;
        b=t5BfgawT/Wi7BmrdzbQR8QJ+QBreob1GlKCLwZgqgf1bRGhvxIC96l1yYniIAJJOvr
         RojhGZHINyxfRZUofCo5qxAutycDc6s0FTMi2j8aZQpGWIJY77vzqX5GGb0LYnjCRCp+
         G4C2CfCwJ49OfMY8jBde4zjpjcgzUQ862CJfRyXrofRs5uXXbs9ka0A2jNh1bsKnw/wI
         VIxwlcO5njztQsVeiI/UF2llVsZ4C3qelhUT0ZsHnPp7JIFKHcNZBZGeDX8/Hd1olUKb
         MhBd4joG/lOC0yHP0uPVlqFkaN4EXj4wNuTwJG90Nz41DSEnZMUZOAspV5MQUygbOoQ5
         46gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmF/moFaP2vIu3wyyPlPwTNgQVyw6cgxTUQxtgkWdeo=;
        b=SZwQoS0SxlA79+73Oxxi5P6XzlM+9QqfzZO7e0zaIp7Ajkao0n0VMAIlYlOzbwptBA
         touXbxyGQBww2ZLGCicAE6/aRUanZjAXoavEMHhwW/4mHHy3nU7HABXNlOE5WbRSkHw/
         uvZiQAOGFHeeuBiYbjJq3p5tkogBTyFKmrEF++5khodWq5j+OagJPwKq+7V3TCj/Dwol
         PLf2ftJCGVMrWMkFpw02Tdp9WzePnDNnjsxlypvJVovl3IKbnX7YxMXIiA4jO2P/UZ+Y
         Wfos327b0TIB+0kLbweolRpiTc34XAmkUpHX6XBkQifvq8BoU2VFmypzPUnqK6bG2cgi
         nLnw==
X-Gm-Message-State: AOAM530gHWDsLU3WZirJaGse1o89xHzKsyA5vtcH+VeCR7NF94AWg9qI
        iGIQrT6IGu4LF+9xxNBw/B7bRw==
X-Google-Smtp-Source: ABdhPJxZOI7fkns7Bw4xQje93fgOz8XkJ6mRP3Npz85CJMRQOrUd35T3uQximAJItlvsrQkXLclU+Q==
X-Received: by 2002:a05:6638:379c:: with SMTP id w28mr326787jal.275.1644004255938;
        Fri, 04 Feb 2022 11:50:55 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id k13sm1417564ili.22.2022.02.04.11.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Feb 2022 11:50:55 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     djakov@kernel.org, bjorn.andersson@linaro.org, mka@chromium.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        avuyyuru@codeaurora.org, jponduru@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/7] net: ipa: use bulk interconnect initialization
Date:   Fri,  4 Feb 2022 13:50:42 -0600
Message-Id: <20220204195044.1082026-6-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220204195044.1082026-1-elder@linaro.org>
References: <20220204195044.1082026-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

