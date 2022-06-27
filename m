Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B8155D32B
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236350AbiF0Mk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 08:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236324AbiF0Mkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 08:40:53 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B60B7F4
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 05:40:51 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id cw10so18912486ejb.3
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 05:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lJMIQmaTr/csqoOVBa8hy1Civ+/zMXbxh5Fbkw0Bj30=;
        b=av3iLNYbThYrQEBCn1cu5+D5JyQmpouY/f3wntuG/EajpMnFxNhIoJxrVeL9F5RqjU
         lHauNhXX+xPSHcXtdIWJUvgv4lyH7D85Jab+53fcnhqLs04rUlo92ctnXhCIzC7wnUMZ
         WYSaBuRcWNi+yAPD2EkSMhUgBgd1IqQ9aluFnamiQXOUTvas6XFf5YxDgejS76fQE+EF
         FVGQAaAo3ZIKdexUk480WNaAK/7sBXxerNEhWR2BsIQEkE/QlhcaHf/HFHgsF2/RJ0tD
         iOvtJ/8JCcWvox5nov9Ah/zz4/4XOlDLdKbywoC/wsPsjU2k6jmDB9iBTrJk3OOftiMg
         3P8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lJMIQmaTr/csqoOVBa8hy1Civ+/zMXbxh5Fbkw0Bj30=;
        b=NUUKiP9V+VsilifcKjik4WeygE0SOFh62ti/eCZosPrZciGOZ1pjbJi52Yf0tKkWvS
         5EeINlkCc4pJktJEGwDmHqyqnP0sPYBRtsOfHCzj6VrTmZBj3l3Dx+9VCpgFdxUDsi8t
         mfBA7w6jvGn1EpeT/oVdzC3KGEvweO48Xo6mJzGWCpA6vxc4O8wCGtLaLyMVLX537HBh
         BDldKIjrWolquP0bAq644L5oAzwLszkAHN2NcaD4jyV8cBW4zfqwJNh8JqUBosS4sfo+
         JimIaQVCTtNCJoWMXetADBpY2ZiVFN1NzFlkbYjJif5ljBACcUtF3Y5bjzOVVh3GARqU
         NVPg==
X-Gm-Message-State: AJIora/a/e6vTKQJuZyTfoqKmPXTqJ88coXhAyo2ZJJOGcfTxq1Whvhv
        3HjGw7FJiw/zSwTzFKdqD0UAjg==
X-Google-Smtp-Source: AGRyM1vUtVCS8Qwszx2mLh1lEctO7HOktkVRsGdoSM3zBXW9DMbcuTR+4Cj4Kzp1Ew9pwpWazggfQQ==
X-Received: by 2002:a17:906:54c3:b0:6ef:d07b:c8ec with SMTP id c3-20020a17090654c300b006efd07bc8ecmr12026339ejp.687.1656333650598;
        Mon, 27 Jun 2022 05:40:50 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id o3-20020aa7c503000000b0042de8155fa1sm7641524edq.0.2022.06.27.05.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 05:40:50 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Vincent Cuissard <cuissard@marvell.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lv Ruyi <lv.ruyi@zte.com.cn>
Subject: [PATCH v2] nfc: nfcmrvl: Fix irq_of_parse_and_map() return value
Date:   Mon, 27 Jun 2022 14:40:48 +0200
Message-Id: <20220627124048.296253-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
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

The irq_of_parse_and_map() returns 0 on failure, not a negative ERRNO.

Reported-by: Lv Ruyi <lv.ruyi@zte.com.cn>
Fixes: caf6e49bf6d0 ("NFC: nfcmrvl: add spi driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

---

Changes since v1:
1. Do not print 'rc' in error msg.
2. Fix also I2C.
---
 drivers/nfc/nfcmrvl/i2c.c | 6 +++---
 drivers/nfc/nfcmrvl/spi.c | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index ceef81d93ac9..01329b91d59d 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -167,9 +167,9 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
 		pdata->irq_polarity = IRQF_TRIGGER_RISING;
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
-		pr_err("Unable to get irq, error: %d\n", ret);
-		return ret;
+	if (!ret) {
+		pr_err("Unable to get irq\n");
+		return -EINVAL;
 	}
 	pdata->irq = ret;
 
diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
index a38e2fcdfd39..ad3359a4942c 100644
--- a/drivers/nfc/nfcmrvl/spi.c
+++ b/drivers/nfc/nfcmrvl/spi.c
@@ -115,9 +115,9 @@ static int nfcmrvl_spi_parse_dt(struct device_node *node,
 	}
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
-		pr_err("Unable to get irq, error: %d\n", ret);
-		return ret;
+	if (!ret) {
+		pr_err("Unable to get irq\n");
+		return -EINVAL;
 	}
 	pdata->irq = ret;
 
-- 
2.34.1

