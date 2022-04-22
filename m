Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D5850B332
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 10:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445592AbiDVItH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 04:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1445577AbiDVItG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 04:49:06 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 034D4532E9;
        Fri, 22 Apr 2022 01:46:14 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id ay11so5052340qtb.4;
        Fri, 22 Apr 2022 01:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W4w/iK0rp5BN8/CHDCqXsD0JJrK3FIxJXY/tHyFUfOQ=;
        b=YfviSKz71YQd0Yit4e9xX3jfCaw/+6s86fQWMXC/9UliAZ401BXuL/5UHi+VgA4jCU
         U3/C7n2iCvSODB4ZWTS42dtPNdHIqz+0funNyJ34Dn0aPD6VOmsxw+2QiSYFIoYN2lYq
         DUuchZ7S2/CQSGAoDpKK7hm2NV4BI/WgkvhOIIlsTDjAJqNNOIpACVLKYl7XRur7QoK6
         jdgY4Pr6RcgKLZIruCiHzdwq6dL1uAmNqFXQCZPggO1Zq+OS+Cybyc/JX2WAP3Xvr+0Y
         meA63t5Sgx86mdRET+T7mR0jdFlfvmKNQlvt5cGOIyU5G5S5f3W4nFEyHNG9GG9OwKIO
         6oYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W4w/iK0rp5BN8/CHDCqXsD0JJrK3FIxJXY/tHyFUfOQ=;
        b=RnO8TafrYIl1jFIBcNUDWI9J44KoCs+cIW6npM6HfOLlqZQZgY9vSG6ZmayDcgK57R
         iQ9fELXVeS0NCeVx0q/Ehhle1G6F8HGGL/TlwiwxU+eWoX1DCM1+52RyS1pEXkLQ5KAo
         qCETR5r7zWeirvviaeQKyab6iOCUN8nuUrR99qsNlMiSseW0Ce1YgJrpoGtmIuhfKnpK
         34pyabOs3AKjCKpwTO6+zTwRExdGOAQW83rpfx8PgtrYK/zx5gXl/AuL4lPmywYBKt6L
         UjLRYADrkrmS9UmLEub6aYizgePfyRJ9iQEtNhzvhTM2QHK2MjwXILdD/xCGdeQ4o3Dh
         gCtg==
X-Gm-Message-State: AOAM533XFKmNbSdLji8QaHYrKTADnCfUNFW2hOncAPD1o7QSqmvb3t//
        2n1x/P+YsksCgxlx3i4o78w=
X-Google-Smtp-Source: ABdhPJxvT5z2VQ+20WmPRjokT+8ToUV+14zDgpwKtIxyk/zk6vjaq85whpcKkVq6pbiFEaRha9cqkA==
X-Received: by 2002:a05:622a:6201:b0:2f1:d669:5ee9 with SMTP id hj1-20020a05622a620100b002f1d6695ee9mr2347259qtb.190.1650617173129;
        Fri, 22 Apr 2022 01:46:13 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id j18-20020a37a012000000b0069e92753d72sm641306qke.88.2022.04.22.01.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 01:46:12 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     krzysztof.kozlowski@linaro.org, davem@davemloft.net
Cc:     kuba@kernel.org, lv.ruyi@zte.com.cn, yashsri421@gmail.com,
        sameo@linux.intel.com, cuissard@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] NFC: nfcmrvl: fix error check return value of irq_of_parse_and_map()
Date:   Fri, 22 Apr 2022 08:46:05 +0000
Message-Id: <20220422084605.2775542-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

The irq_of_parse_and_map() function returns 0 on failure, and does not
return an negative value.

Fixes: 	b5b3e23e4cac ("NFC: nfcmrvl: add i2c driver")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/nfc/nfcmrvl/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
index ceef81d93ac9..7dcc97707363 100644
--- a/drivers/nfc/nfcmrvl/i2c.c
+++ b/drivers/nfc/nfcmrvl/i2c.c
@@ -167,7 +167,7 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
 		pdata->irq_polarity = IRQF_TRIGGER_RISING;
 
 	ret = irq_of_parse_and_map(node, 0);
-	if (ret < 0) {
+	if (!ret) {
 		pr_err("Unable to get irq, error: %d\n", ret);
 		return ret;
 	}
-- 
2.25.1


