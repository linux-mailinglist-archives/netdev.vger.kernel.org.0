Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42DDA461C
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 22:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfHaUTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 16:19:00 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44710 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbfHaUS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 16:18:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id i78so7776016qke.11
        for <netdev@vger.kernel.org>; Sat, 31 Aug 2019 13:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JnIx/KTFqvBrxoB43+JIRNkONU8BF4RoXqrAwi6RSK8=;
        b=JAceOnuI9GGl7nmrknwkq8IPuFIOKfSWbg5tteYDVHyU40KH79M/cUG38PXE2ISqHo
         N4rJ3NTsqtaND1bGF+IBOmBstYfTCUUXEu7B8Cf1rLazLtCqq5RGbTsz2MjyjHg+pyRv
         WTyquFz7Uzw9jih+UVvdPIDZ+gwYzsojw7NhIFJPH+cpd4E4jXtCnYie5B+L5xTivLng
         kHIHYM8d4USm+MQtncOXY8eQ04zKiNKAsWMYZWmtCfiADYBoYMlFbY/WklUJPP/YcGYy
         8XmWqhK9BQ0+W+xxXp6ehBYWyAMVfzS+xcySzkdFRbtbSG0AkxHT4RCHEeM14I4w2P5R
         AQdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JnIx/KTFqvBrxoB43+JIRNkONU8BF4RoXqrAwi6RSK8=;
        b=SRHG5Pd5eSUHCVhw2oFLdcvT26/fMNCw61/V3ZxJl8Z7NKqyBT3Lul7EictJzDUtWT
         ejiSfTStspX9U0TL4NA4HhmJMGCKCCHPvSjEV7WGsUZllCqHgrM//eX8i2xE9ZORr1Gy
         91cB4CyMtkpsPUapYH4yJi8hG66ljaQuOapLmGCXxLV+yiwoFBGsMD3uj1ol9PpUsaoV
         0DXnEaLtW+i7wRERac1sQHoRboD7szCSZYM/xSugv0MJzB6s6Y1BGtVIhyzFoVCN/trO
         Js4QNighQGRXz2RWrDVP2EoJ5Jg7O6ySSwhjw//uX3F7S5NEy3bBF9EGqqsWMJQdZ8LG
         D6aQ==
X-Gm-Message-State: APjAAAVjoXNiFooYb84pIWcrtubcVU2VtXYyjciQChyrVGhiaxKLMYLX
        iwLPseDKf4Qz2WwgcT/20WV9i30D
X-Google-Smtp-Source: APXvYqyLil/PgWAZFcnsTsaBta4QtGxVahFsylPmx1LLuy5xaipqKDX3daM21L4N7MMjiYW+7Oh0PA==
X-Received: by 2002:a05:620a:12ef:: with SMTP id f15mr22829380qkl.167.1567282738203;
        Sat, 31 Aug 2019 13:18:58 -0700 (PDT)
Received: from localhost (modemcable249.105-163-184.mc.videotron.ca. [184.163.105.249])
        by smtp.gmail.com with ESMTPSA id g4sm4401152qki.47.2019.08.31.13.18.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Aug 2019 13:18:57 -0700 (PDT)
From:   Vivien Didelot <vivien.didelot@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        f.fainelli@gmail.com, andrew@lunn.ch,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 02/10] net: dsa: mv88e6xxx: fix SERDES IRQ mapping
Date:   Sat, 31 Aug 2019 16:18:28 -0400
Message-Id: <20190831201836.19957-3-vivien.didelot@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190831201836.19957-1-vivien.didelot@gmail.com>
References: <20190831201836.19957-1-vivien.didelot@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current mv88e6xxx SERDES code checks for negative error code from
irq_find_mapping, while this function returns an unsigned integer. This
patch removes this dead code and simply returns 0 is no IRQ is found.

Signed-off-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h   |  2 +-
 drivers/net/dsa/mv88e6xxx/serdes.c | 14 ++++----------
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 421e8b84bec3..2016f51c868b 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -199,7 +199,7 @@ struct mv88e6xxx_port {
 	u64 vtu_member_violation;
 	u64 vtu_miss_violation;
 	u8 cmode;
-	int serdes_irq;
+	unsigned int serdes_irq;
 };
 
 struct mv88e6xxx_chip {
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 7eb7ed68c91d..f65652e6edec 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -249,11 +249,8 @@ int mv88e6352_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 
 	chip->ports[port].serdes_irq = irq_find_mapping(chip->g2_irq.domain,
 							MV88E6352_SERDES_IRQ);
-	if (chip->ports[port].serdes_irq < 0) {
-		dev_err(chip->dev, "Unable to map SERDES irq: %d\n",
-			chip->ports[port].serdes_irq);
-		return chip->ports[port].serdes_irq;
-	}
+	if (!chip->ports[port].serdes_irq)
+		return 0;
 
 	/* Requesting the IRQ will trigger irq callbacks. So we cannot
 	 * hold the reg_lock.
@@ -690,11 +687,8 @@ int mv88e6390_serdes_irq_setup(struct mv88e6xxx_chip *chip, int port)
 
 	chip->ports[port].serdes_irq = irq_find_mapping(chip->g2_irq.domain,
 							port);
-	if (chip->ports[port].serdes_irq < 0) {
-		dev_err(chip->dev, "Unable to map SERDES irq: %d\n",
-			chip->ports[port].serdes_irq);
-		return chip->ports[port].serdes_irq;
-	}
+	if (!chip->ports[port].serdes_irq)
+		return 0;
 
 	/* Requesting the IRQ will trigger irq callbacks. So we cannot
 	 * hold the reg_lock.
-- 
2.23.0

