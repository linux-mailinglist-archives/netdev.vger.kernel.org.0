Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDFA5061C8
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 03:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343709AbiDSBri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 21:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343749AbiDSBrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 21:47:31 -0400
Received: from mail-qv1-xf2a.google.com (mail-qv1-xf2a.google.com [IPv6:2607:f8b0:4864:20::f2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D10D267F;
        Mon, 18 Apr 2022 18:44:48 -0700 (PDT)
Received: by mail-qv1-xf2a.google.com with SMTP id a5so12164690qvx.1;
        Mon, 18 Apr 2022 18:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iPR7KjpiiS3B+4FaAzRwBvS4FN94Ws45XLOjIugVXyo=;
        b=LQeVQPjY46lbhT9D9zrmgV26yhpAcYsK5dOpHlz8O9ifKtMt1R1BBE8Abw4tCQ5TUz
         UIqwDDLvhq2OzvClOlkT4W1g4Y5g4IyjVgWMs0CwqzlgyrgC3u0UeaNurUPZA3vhMRQa
         3WOY1+FCHh9sg/pgbfYQGFaD4acMz57b4NMILZv35J1qyQbDELE4Or4rrSEr54fM26/z
         3IuAkxOMztfElGCU56Fr6t4PSZM68gYqQbyCkl3Z6TmRMe+gr9aC4SLpg6unPEV+NTJg
         upK0Uwn0l3RExPehhqlCBmegmPbZ9OsLTRcEPIZIZWhP/TP5ch8It8V/WaIm3Rqn8fLv
         zfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iPR7KjpiiS3B+4FaAzRwBvS4FN94Ws45XLOjIugVXyo=;
        b=mpi7J1hwNGfgfQ1VP12dQR7nqlByEKNHiOp9RTzLSo34FXQi9pFQffW/QRrknCPHQR
         /dZlX0r7w+44jJq6DPDLtB7hnxX0RUghEvZeTHTieyr2yrhG1IkI5eXKP17KD45p50xs
         mDqmXkoGS3LQOI5vINXaUYmy27aghti8exYA3qh6LVHG3AEddPWSM0/94LTXGDkgGtOO
         FMcWZi4z0sK1vW7M6yVq5m6LcJRNtC7u01BHfggQU9zgLkmnz7xtksAbBwwaREY6JfrK
         4TCiql0/1e+x7CcJvMbm/UNZTHCURljaEtcCSclIeMqVK52LZKFuYSFIoV5aQdd7ttHf
         vAuw==
X-Gm-Message-State: AOAM531XrUFhEVp/N9w+H33dlPDPhvrgcBbZ/aEAEMD9lZfn/6kKnRPA
        tFVtDCjwWK/+cc0FqNUHUl5o6McjKqA=
X-Google-Smtp-Source: ABdhPJySdFp7tUmJanTf/0OISbH3xa9Zz1MI3078odp0PXs6D4/nuFCcqkCE6Sx4vD2Tg5FUBL0t3g==
X-Received: by 2002:a05:6214:21a4:b0:446:5514:82b7 with SMTP id t4-20020a05621421a400b00446551482b7mr6225710qvc.54.1650332687225;
        Mon, 18 Apr 2022 18:44:47 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id w3-20020a376203000000b0069e9a4568f9sm2655790qkb.125.2022.04.18.18.44.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 18:44:46 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: lv.ruyi@zte.com.cn
To:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lv Ruyi <lv.ruyi@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: phy: fix error check return value of phy_read()
Date:   Tue, 19 Apr 2022 01:44:39 +0000
Message-Id: <20220419014439.2561835-1-lv.ruyi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lv Ruyi <lv.ruyi@zte.com.cn>

phy_read() returns a negative number if there's an error, but the
error-checking code in the bcm87xx driver's config_intr function
triggers if phy_read() returns non-zero.  Correct that.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
---
 drivers/net/phy/bcm87xx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/bcm87xx.c b/drivers/net/phy/bcm87xx.c
index 313563482690..e62b53718010 100644
--- a/drivers/net/phy/bcm87xx.c
+++ b/drivers/net/phy/bcm87xx.c
@@ -146,7 +146,7 @@ static int bcm87xx_config_intr(struct phy_device *phydev)
 
 	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
 		err = phy_read(phydev, BCM87XX_LASI_STATUS);
-		if (err)
+		if (err < 0)
 			return err;
 
 		reg |= 1;
-- 
2.25.1


