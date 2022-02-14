Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 241A24B3F61
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 03:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiBNCV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 21:21:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238841AbiBNCVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 21:21:23 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48D355496
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:21:15 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id y23so15960388oia.13
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 18:21:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q4U77wHQmDqUfeCh34vVheVm6z6dQNy1UJnXJPf9w3E=;
        b=Tu0akXWdXLFlPT5UPHshwxheKD3hcQ7lMU415aKqADGI7lkUH2bjq+ztC8SoYsjIYG
         AFOj1ANT6jY/wRs/7oLj7tEZtExOrMHr9QLUUeHTYPsa0MIGCDQv0eLmjo+piXJzN1Ml
         i6nLKGaUDanFbw/5/O+K3328v4XQ2mKupgrYs0sB4KT+3DuDHpbpZ0lSvjJrt18ybezH
         HOWipSmykSg7dZbJE5Vo+eDM55ufdC03zNRJUHzFlNrsJATqUeb7tPVspdyTHlL0TKM2
         M9p8M+NJB+DXgZGyHsKYoxkPeoEhzp9cwinZrwjdkF28GRHYhU8nigpJon17nt1Ki6/6
         EqvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q4U77wHQmDqUfeCh34vVheVm6z6dQNy1UJnXJPf9w3E=;
        b=pc9c+t2aPT89pBAVi8XGFWRcBxKoSt7Dao/R/q4cTZtt7t//52wnHl9iEAEjdkl5i7
         w/5vZUzLGLhTLuw3Ar3t5fr5kaJlFu9fUzpakdfiA5OVF+SiklhAMc0Iob/jX+o63AZZ
         1r/5tNuLnPlmG22B/Xdb77MEMUG/D3ATM/ALJgP87cL8fzXXRDT/MOsxzE1m7OfpvvuA
         Zy5umoXiSmdz1/zYlE23XCyaCTI++TeYIE/gpArl8C7/O0KVnKVA/13j15qgyR/W1jyy
         8AFgRbRaQVbWIFee5T4F6v0roR6spsy7tDjN3wiVjNBTUEzijuTi1A+LsWJ8/YyMhXJy
         rsJA==
X-Gm-Message-State: AOAM531IsEFx1M+6UnKfpypM5jz0oAMsL3sL6P/8WKQwzIVwFIY6xudj
        tUvJZpiEQ1SAM1xzOaRS6/8o82tr7EV42A==
X-Google-Smtp-Source: ABdhPJxF3W6KWR8o4wJ6jVlH7YZZdyV29BSOZ/1xTQqTrN7lbVmjWVnLUujyEQitU6QeM4/++zFpYw==
X-Received: by 2002:a05:6808:e82:: with SMTP id k2mr4710111oil.10.1644805274286;
        Sun, 13 Feb 2022 18:21:14 -0800 (PST)
Received: from tresc043793.tre-sc.gov.br (187-049-235-234.floripa.net.br. [187.49.235.234])
        by smtp.gmail.com with ESMTPSA id h203sm12321150oif.27.2022.02.13.18.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 18:21:13 -0800 (PST)
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk, arinc.unal@arinc9.com,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Frank Wunderlich <frank-w@public-files.de>
Subject: [PATCH net-next v3 2/2] net: dsa: realtek: realtek-mdio: reset before setup
Date:   Sun, 13 Feb 2022 23:20:12 -0300
Message-Id: <20220214022012.14787-3-luizluca@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214022012.14787-1-luizluca@gmail.com>
References: <20220214022012.14787-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Some devices, like the switch in Banana Pi BPI R64 only starts to answer
after a HW reset. It is the same reset code from realtek-smi.

Reported-by: Frank Wunderlich <frank-w@public-files.de>
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Tested-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
---
 drivers/net/dsa/realtek/realtek-mdio.c | 19 +++++++++++++++++++
 drivers/net/dsa/realtek/realtek-smi.c  |  6 ++----
 drivers/net/dsa/realtek/realtek.h      |  3 +++
 3 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/realtek/realtek-mdio.c b/drivers/net/dsa/realtek/realtek-mdio.c
index 0c5f2bdced9d..0308be95d00a 100644
--- a/drivers/net/dsa/realtek/realtek-mdio.c
+++ b/drivers/net/dsa/realtek/realtek-mdio.c
@@ -152,6 +152,21 @@ static int realtek_mdio_probe(struct mdio_device *mdiodev)
 	/* TODO: if power is software controlled, set up any regulators here */
 	priv->leds_disabled = of_property_read_bool(np, "realtek,disable-leds");
 
+	priv->reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_LOW);
+	if (IS_ERR(priv->reset)) {
+		dev_err(dev, "failed to get RESET GPIO\n");
+		return PTR_ERR(priv->reset);
+	}
+
+	if (priv->reset) {
+		gpiod_set_value(priv->reset, 1);
+		dev_dbg(dev, "asserted RESET\n");
+		msleep(REALTEK_HW_STOP_DELAY);
+		gpiod_set_value(priv->reset, 0);
+		msleep(REALTEK_HW_START_DELAY);
+		dev_dbg(dev, "deasserted RESET\n");
+	}
+
 	ret = priv->ops->detect(priv);
 	if (ret) {
 		dev_err(dev, "unable to detect switch\n");
@@ -185,6 +200,10 @@ static void realtek_mdio_remove(struct mdio_device *mdiodev)
 
 	dsa_unregister_switch(priv->ds);
 
+	/* leave the device reset asserted */
+	if (priv->reset)
+		gpiod_set_value(priv->reset, 1);
+
 	dev_set_drvdata(&mdiodev->dev, NULL);
 }
 
diff --git a/drivers/net/dsa/realtek/realtek-smi.c b/drivers/net/dsa/realtek/realtek-smi.c
index 33cf5a0692de..8806b74bd7a8 100644
--- a/drivers/net/dsa/realtek/realtek-smi.c
+++ b/drivers/net/dsa/realtek/realtek-smi.c
@@ -43,8 +43,6 @@
 #include "realtek.h"
 
 #define REALTEK_SMI_ACK_RETRY_COUNT		5
-#define REALTEK_SMI_HW_STOP_DELAY		25	/* msecs */
-#define REALTEK_SMI_HW_START_DELAY		100	/* msecs */
 
 static inline void realtek_smi_clk_delay(struct realtek_priv *priv)
 {
@@ -428,9 +426,9 @@ static int realtek_smi_probe(struct platform_device *pdev)
 	if (priv->reset) {
 		gpiod_set_value(priv->reset, 1);
 		dev_dbg(dev, "asserted RESET\n");
-		msleep(REALTEK_SMI_HW_STOP_DELAY);
+		msleep(REALTEK_HW_STOP_DELAY);
 		gpiod_set_value(priv->reset, 0);
-		msleep(REALTEK_SMI_HW_START_DELAY);
+		msleep(REALTEK_HW_START_DELAY);
 		dev_dbg(dev, "deasserted RESET\n");
 	}
 
diff --git a/drivers/net/dsa/realtek/realtek.h b/drivers/net/dsa/realtek/realtek.h
index ed5abf6cb3d6..443cf51cb918 100644
--- a/drivers/net/dsa/realtek/realtek.h
+++ b/drivers/net/dsa/realtek/realtek.h
@@ -13,6 +13,9 @@
 #include <linux/gpio/consumer.h>
 #include <net/dsa.h>
 
+#define REALTEK_HW_STOP_DELAY		25	/* msecs */
+#define REALTEK_HW_START_DELAY		100	/* msecs */
+
 struct realtek_ops;
 struct dentry;
 struct inode;
-- 
2.35.1

