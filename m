Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4E4450CEC0
	for <lists+netdev@lfdr.de>; Sun, 24 Apr 2022 04:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbiDXDAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 23:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237791AbiDXDAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 23:00:46 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D863413F261;
        Sat, 23 Apr 2022 19:57:47 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id ay11so8234032qtb.4;
        Sat, 23 Apr 2022 19:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XjCdzYbvTiumAbdBQKpwnCmY/DB2qhX1zt/3WHbpTBY=;
        b=ayegxzyF/KPCw0iAe5COmtVy6cQmP7gjyGCPRXwzyrlmv2fFvDaSBDDq5X71qGEf1p
         sS56u+5lXrAnX8OHWy0sR9L6itSfjlpk5zIYmnekVgolat1BLi4h2Og3clylnKgfl0gt
         2+jENAj2WkR8fuiv5p/BoeQ+jGlAYlUxDggLlqobnquHJbriTwz0qUyjkOC4uVRa5jEd
         sb+eoFdDGOOmRJkrgVRqNbiZSHg7uEI5FSIOpOrUmPPTsBZfp8AeNmFd33MCeGEZ3pF8
         5l3SIqQxl24U4DEUd+4kx8IevioIRcJm4kx24gP3Z+KCzX1+v1GOwRpuNy059UNu2UeG
         95bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XjCdzYbvTiumAbdBQKpwnCmY/DB2qhX1zt/3WHbpTBY=;
        b=kYXCN9qHO4JCGj3ijctr2yXkODNxescviuO48cVMAOHuvqW9lmmhptizPcse/uYsYA
         cp9CIYZ4wtqequdsYMss0EJr02mxt+Lg6lWfP972jB1xdlVDbTkmA55KNQ39LKE+Dp9G
         56nEk8mAGFC1Z4VjceeFACA4+rlx0zIrOOoUwtMVPmame4hCmDQ34f2k9ppSM6GZYZvV
         WwIQ+ZGtnDtxVkYQjbqlhBT1+VJNkTe0hOa2cuLc2+XcXxzAexEGO9smXAU/l7tPPga+
         dl62SKX435SXo7LFgDd9TqDPTV2+FmNjFDTegJqdymHeqfRPgFw9AXy0DbcSHuvGdrTh
         Xdtg==
X-Gm-Message-State: AOAM530/Jq7WBRvvSYX0wK0WXKpuCy3f52uarJhhIeDAvkKWJmoUbNAC
        Shz2BrPEUq+7rsps/BEDoZvWbMT+2T0=
X-Google-Smtp-Source: ABdhPJwq7R1leUtmM43JRhupWQb4TivSOH5A2uF9lwwk82MGTOMgFt7wf6hY3YMrr0jMaMcrSD9vtg==
X-Received: by 2002:ac8:5b0d:0:b0:2f3:4377:713b with SMTP id m13-20020ac85b0d000000b002f34377713bmr8031486qtw.588.1650769067040;
        Sat, 23 Apr 2022 19:57:47 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id x24-20020ac87318000000b002f1fc5fcaedsm3629753qto.68.2022.04.23.19.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 19:57:45 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     kuba@kernel.org
Cc:     cgel.zte@gmail.com, cuissard@marvell.com, davem@davemloft.net,
        krzysztof.kozlowski@linaro.org, linux-kernel@vger.kernel.org,
        lv.ruyi@zte.com.cn, netdev@vger.kernel.org, sameo@linux.intel.com,
        yashsri421@gmail.com, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH v2] NFC: nfcmrvl: fix error check return value of irq_of_parse_and_map()
Date:   Sun, 24 Apr 2022 02:57:10 +0000
Message-Id: <20220424025710.3166034-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220422160931.6a4eca42@kernel.org>
References: <20220422160931.6a4eca42@kernel.org>
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

Fixes: b5b3e23e4cac ("NFC: nfcmrvl: add i2c driver")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
v2: don't print ret, and return -EINVAL rather than 0
---
 drivers/nfc/nfcmrvl/i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
 
-- 
2.25.1

