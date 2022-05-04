Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7AE51A238
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 16:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351344AbiEDOfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 10:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351342AbiEDOfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 10:35:04 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6512F1FA73;
        Wed,  4 May 2022 07:31:28 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-e93bbb54f9so1321531fac.12;
        Wed, 04 May 2022 07:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TkR4+Ak42lKAVTpIpmlEu7xaOxXFRRFm8b0SVx8aIK8=;
        b=d2zsqe+LjRZ0/q16f0uNPNcEBQsGPHyHl9A0iFGxVxcMbgkkt4Xa3wd0mjcQRXY3Zf
         I8DvLS/pYwPDXnZLSVXq2pUSf+2Gay7fwp6RWUyAdDligYkS5Gi/9UC3kMs0P1vy62hh
         L4sNqfBh4j7Aytfg/zxgOgKEEFiPFovy/WDTdFiW+X3OQlWdiX4JYzDW5GzyEHM+Cn6A
         KHzBPVZiavamj7r4LwMvWrVUEEymhn2KYE2VW33XsojyWNspLO/MTSUfg3fGjZ7iu6Jo
         O8X5JJiSHlcAbYlzQuHpJdYP9dQ3Uq5V6QqhJqvZhzXJRA9u8vh7dKIO90bDfXclKfD2
         vkTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TkR4+Ak42lKAVTpIpmlEu7xaOxXFRRFm8b0SVx8aIK8=;
        b=CnoHycRPT6QSdt+AJ7aVKwh96B4AqPVe8HzwTPLDtBZjDHq1fyp3YCUCAqHefCCh7b
         mD4vEWS+cbZ6Ui2s4pCyNIhVlY6SO03naK1JzEOjllGHvQ7NxPHlR1bsmGPXt4sEUc8r
         /I5DLEnv/wnMeurLC/QdUOXf+umXS/JY/WXnZM58Oz2WxWJBTz6HlhdQwXKQo9ZIeRAY
         mLfpCljY8jSMD5hglqemkx9CS1YirkppY14VmD5ETYAkzQaj5qsJLtGtIimjos+7EsCb
         bByOQxdwTvMg9hHpGUK+ayeJMyQIs3tdXXHaRXb/OSaGicvZ7m4TCocMNXwqQ81gSz7b
         zIug==
X-Gm-Message-State: AOAM532cLxZwVq846EvP95vRcJmwyMjFJX7omWcqQ7l38yeGgEWcaklk
        hQ8qqCaKtMyAcqvCbuK4LwU=
X-Google-Smtp-Source: ABdhPJwVA7TMiQ/jxm7yXoFyx+nQCDbG+YJAW/Hdf84gmBHEKuw2CSOZUJoDpy3jnAbBLJiHIXgvWw==
X-Received: by 2002:a05:6870:618e:b0:e5:c2f3:e009 with SMTP id a14-20020a056870618e00b000e5c2f3e009mr3871331oah.10.1651674687522;
        Wed, 04 May 2022 07:31:27 -0700 (PDT)
Received: from localhost.localdomain ([2804:14c:485:4b69:6ef3:840d:df28:4651])
        by smtp.gmail.com with ESMTPSA id m9-20020a4ad509000000b0035eb4e5a6dasm6018832oos.48.2022.05.04.07.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 07:31:27 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, andrew@lunn.ch, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        linux@armlinux.org.uk, Fabio Estevam <festevam@denx.de>,
        stable@vger.kernel.org
Subject: [PATCH net v2 1/2] net: phy: micrel: Do not use kszphy_suspend/resume for KSZ8061
Date:   Wed,  4 May 2022 11:31:03 -0300
Message-Id: <20220504143104.1286960-1-festevam@gmail.com>
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

From: Fabio Estevam <festevam@denx.de>

Since commit f1131b9c23fb ("net: phy: micrel: use
kszphy_suspend()/kszphy_resume for irq aware devices") the following
NULL pointer dereference is observed on a board with KSZ8061:

 # udhcpc -i eth0
udhcpc: started, v1.35.0
8<--- cut here ---
Unable to handle kernel NULL pointer dereference at virtual address 00000008
pgd = f73cef4e
[00000008] *pgd=00000000
Internal error: Oops: 5 [#1] SMP ARM
Modules linked in:
CPU: 0 PID: 196 Comm: ifconfig Not tainted 5.15.37-dirty #94
Hardware name: Freescale i.MX6 SoloX (Device Tree)
PC is at kszphy_config_reset+0x10/0x114
LR is at kszphy_resume+0x24/0x64
...

The KSZ8061 phy_driver structure does not have the .probe/..driver_data
fields, which means that priv is not allocated.

This causes the NULL pointer dereference inside kszphy_config_reset().

Fix the problem by using the generic suspend/resume functions as before.

Another alternative would be to provide the .probe and .driver_data
information into the structure, but to be on the safe side, let's
just restore Ethernet functionality by using the generic suspend/resume.

Cc: stable@vger.kernel.org
Fixes: f1131b9c23fb ("net: phy: micrel: use kszphy_suspend()/kszphy_resume for irq aware devices")
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
Changes since v1:
- Explained why enphy_suspend/resume solution is preferred (Andrew).

 drivers/net/phy/micrel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 685a0ab5453c..11cd073630e5 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3021,8 +3021,8 @@ static struct phy_driver ksphy_driver[] = {
 	.config_init	= ksz8061_config_init,
 	.config_intr	= kszphy_config_intr,
 	.handle_interrupt = kszphy_handle_interrupt,
-	.suspend	= kszphy_suspend,
-	.resume		= kszphy_resume,
+	.suspend	= genphy_suspend,
+	.resume		= genphy_resume,
 }, {
 	.phy_id		= PHY_ID_KSZ9021,
 	.phy_id_mask	= 0x000ffffe,
-- 
2.25.1

