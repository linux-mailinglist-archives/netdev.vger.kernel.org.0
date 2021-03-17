Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B7A33F2C6
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231932AbhCQOht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbhCQOh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:37:26 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21647C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:37:26 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id p21so3283550lfu.11
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 07:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NSivc71DcP9/79d/xpwrqcVB0YlHsf3Tsu5+fLHsZnQ=;
        b=AzhZGEjyaV3TAka8xWtaJKH16k0mrkE547qd7sa0Kf8kGjlcEWuw0JcZpcFsavv8aK
         bjFOmJhgn72HDgNFbI+LjW3ewKwQ+R2jlElWlMPGNhZb8Hf86KYT9uNOVwLZXcRpi8dI
         fsyiLAZ2prjfZw+S7+hN1rNQmrv2Qc5ZbelSrcC4rnoWtu5K9cZqFUWAlIrblHpXZzWx
         m7cXDEJdY2Y6Fhsw2mrOZOJfve4XSU5q6dKFdU8eqkMgPL85YoI+ESWwf4UhHmzfxu7d
         OdOcF8Ihgxk2J/X/ZRv5Ifa20f/+RvEbUMaLT3FF74nCFPoVm2PlQ/9XdxDBCWE5Vpmh
         l3DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NSivc71DcP9/79d/xpwrqcVB0YlHsf3Tsu5+fLHsZnQ=;
        b=TRl0EHSKfsJYrGLkRE/8nlnb3bZiuSNu2sMhSgMMBEGern35/M1DCngLd4S5ds35zc
         UECCuyMB6sfTeVyBszBSQsKR1SOdq+Djf1NIPIpXutuQ7EkKESam20EGWQd6SSxgsMsy
         sSOnzef8EJKyzi7OxfLdR3zeCrUw86pVYH4ZX17W3Do0hDcNdzdCsZdTFBY9BglV9zm2
         2j6q2jBxZ8Nzd5UYSAL2ZGU0/vtqxIImwFIFToXnIIRfI3c/qjm98paPPNJ/Eio8sDE/
         zntxxyQtmx+RB8+Zly66Q5ivOIbmM4lWcfS08yw3uoosYUcnXtwiZ1hl9cUwO9Ofr7Hx
         6jxg==
X-Gm-Message-State: AOAM530bG9lnPhnD5LNq8iutDjCoo5LvcFdZgruTNi7QVqLinu5h/QZa
        g0a9To6r8ybopYXAfISmUys=
X-Google-Smtp-Source: ABdhPJyRXWZpaOZ7eQIAIaFApysdlCmpZxY45iB6126CE5ZnAtJtS0Rc+hwOUtgahzuI/mVWVT5r1A==
X-Received: by 2002:a19:690f:: with SMTP id e15mr1127915lfc.662.1615991844538;
        Wed, 17 Mar 2021 07:37:24 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id k5sm3554745ljb.78.2021.03.17.07.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:37:24 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH 2/2] net: dsa: bcm_sf2: fix BCM4908 RGMII reg(s)
Date:   Wed, 17 Mar 2021 15:37:06 +0100
Message-Id: <20210317143706.30809-3-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210317143706.30809-1-zajec5@gmail.com>
References: <20210317143706.30809-1-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

BCM4908 has only 1 RGMII reg for controlling port 7.

Fixes: 73b7a6047971 ("net: dsa: bcm_sf2: support BCM4908's integrated switch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/bcm_sf2.c      | 11 +++++++----
 drivers/net/dsa/bcm_sf2_regs.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 942773bcb7e0..5dc02dbb7094 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -36,7 +36,12 @@ static u16 bcm_sf2_reg_rgmii_cntrl(struct bcm_sf2_priv *priv, int port)
 {
 	switch (priv->type) {
 	case BCM4908_DEVICE_ID:
-		/* TODO */
+		switch (port) {
+		case 7:
+			return REG_RGMII_11_CNTRL;
+		default:
+			break;
+		}
 		break;
 	default:
 		switch (port) {
@@ -1183,9 +1188,7 @@ static const u16 bcm_sf2_4908_reg_offsets[] = {
 	[REG_PHY_REVISION]	= 0x14,
 	[REG_SPHY_CNTRL]	= 0x24,
 	[REG_CROSSBAR]		= 0xc8,
-	[REG_RGMII_0_CNTRL]	= 0xe0,
-	[REG_RGMII_1_CNTRL]	= 0xec,
-	[REG_RGMII_2_CNTRL]	= 0xf8,
+	[REG_RGMII_11_CNTRL]	= 0x014c,
 	[REG_LED_0_CNTRL]	= 0x40,
 	[REG_LED_1_CNTRL]	= 0x4c,
 	[REG_LED_2_CNTRL]	= 0x58,
diff --git a/drivers/net/dsa/bcm_sf2_regs.h b/drivers/net/dsa/bcm_sf2_regs.h
index c7783cb45845..9e141d1a0b07 100644
--- a/drivers/net/dsa/bcm_sf2_regs.h
+++ b/drivers/net/dsa/bcm_sf2_regs.h
@@ -21,6 +21,7 @@ enum bcm_sf2_reg_offs {
 	REG_RGMII_0_CNTRL,
 	REG_RGMII_1_CNTRL,
 	REG_RGMII_2_CNTRL,
+	REG_RGMII_11_CNTRL,
 	REG_LED_0_CNTRL,
 	REG_LED_1_CNTRL,
 	REG_LED_2_CNTRL,
-- 
2.26.2

