Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD5E65BAF0
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 07:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjACGuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 01:50:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjACGum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 01:50:42 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB633BD;
        Mon,  2 Jan 2023 22:50:41 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id j9so14622985qvt.0;
        Mon, 02 Jan 2023 22:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+FaroeNRhw8mgfq5ffIuGy5imbHI1fFU0bTsxQOtpTU=;
        b=TJCVzRLqmlCOtXEpnJ4XZ4st7WsQs1XIs161S72C7t5zyjdnodeugvVQMbAO+l52jt
         eO5BvqOANF8fdh6iFoFDcCPKBF3rLxaQY6sxhyE4Zb1uaEPKeRomcR5MvFzkFggR0ZQg
         uAA7QZo4afzgLHKh1xAM+kPFAWr+RMEAzdTkmS90BalPAb61AtLr5KrklXuZ9NdU0403
         dMDfKo4TEwloUkVH5ObT+CZ8gR7G09TO0UIECG5o/LOJKqCM8m+ITEcS6CftrlOEnN08
         gwFEY6/XHs4AGbu5+/+lWn9IeXs4qM0X2+nQv9RQ++UW05ddIrwrdJYwR92rlFX68xEP
         cyzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+FaroeNRhw8mgfq5ffIuGy5imbHI1fFU0bTsxQOtpTU=;
        b=c8H5wH9chLCqpHD93/JAbYAcLCRxFOYSFf6C4vO2npSlMbBpMpYAhuqFjQ+b9Gk6/p
         huSZsco1nER/RxO586GfAyI+4L+1bU7cDVZQo9f872eX2unoz5QcfOb5Sc+HVY0ynrew
         E8ANdL+m5wiOgM+wvw4CCvwmi01jEEFL4GY2HjCUjCqxr0b7hfdA06SCT1wzu9BRs4cC
         nro4XukbyYXD90XnXxPiWMWxft9Cqwm4Y65EUIyL6wowJIODqQ5hSbq7MeBq7jEKnbU3
         HfxJMlIM6uCTbJbPnOLU/7uj6PpdZrrvx3/lwN5pljZp0HTF/zjny5zUSZJxQm8AENHR
         +VTQ==
X-Gm-Message-State: AFqh2kptR0K+kmNsVi3zT7f0V8kNU+SP+sehX31W53JCrapqF7yAWDTS
        R+w9xz10N7hk6PEzoiJxiqk=
X-Google-Smtp-Source: AMrXdXsyoRwnSRIPorIEC6SH4zsIhRiOCKwZsAtF8Qt0QW0XtjUkpMDx0ZjiFZvDUOnBdIXCs5tepA==
X-Received: by 2002:ad4:596f:0:b0:531:bfaf:cf8f with SMTP id eq15-20020ad4596f000000b00531bfafcf8fmr17311496qvb.39.1672728640462;
        Mon, 02 Jan 2023 22:50:40 -0800 (PST)
Received: from localhost (pool-173-73-95-180.washdc.fios.verizon.net. [173.73.95.180])
        by smtp.gmail.com with UTF8SMTPSA id ay34-20020a05620a17a200b006b929a56a2bsm21695308qkb.3.2023.01.02.22.50.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 22:50:40 -0800 (PST)
From:   Sean Anderson <seanga2@gmail.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Zigotzky <info@xenosoft.de>,
        linux-kernel@vger.kernel.org, Sean Anderson <seanga2@gmail.com>
Subject: [PATCH net] net: dpaa: Fix dtsec check for PCS availability
Date:   Tue,  3 Jan 2023 01:50:38 -0500
Message-Id: <20230103065038.2174637-1-seanga2@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We want to fail if the PCS is not available, not if it is available. Fix
this condition.

Fixes: 5d93cfcf7360 ("net: dpaa: Convert to phylink")
Reported-by: Christian Zigotzky <info@xenosoft.de>
Signed-off-by: Sean Anderson <seanga2@gmail.com>
---

 drivers/net/ethernet/freescale/fman/fman_dtsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 3c87820ca202..3462f2b78680 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1431,7 +1431,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	dtsec->dtsec_drv_param->tx_pad_crc = true;
 
 	phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
-	if (!phy_node || of_device_is_available(phy_node)) {
+	if (!phy_node || !of_device_is_available(phy_node)) {
 		of_node_put(phy_node);
 		err = -EINVAL;
 		dev_err_probe(mac_dev->dev, err,
-- 
2.37.1

