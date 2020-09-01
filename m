Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23C125A0F0
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbgIAVoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728677AbgIAVn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:43:58 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87325C061244;
        Tue,  1 Sep 2020 14:43:57 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o68so1616168pfg.2;
        Tue, 01 Sep 2020 14:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wxoDaZ8UHHEQlvfwUILqE66J22AZX7CBjGhbO9+lAP8=;
        b=vMze48wKQwuyKYU1aG6dAoBZ3pChYbJqqV8YZQK7QYyAHpBWIfiVRC8xJnWTsWhn/I
         /G+WHvFyNHr7CKGs6vI3ZZVK1TjNwZ/3QXNgzF0rW6da8QLD7VvIXmb+pin9EWAULLGB
         eE5VkYESLpu5sNfb66v027v5UWMGZL9ZmhjYACmjQ4pOpOPkDKRz5u/RQtTvzUZYHd25
         8wQlF5XgR/KMD7anSJ86Adm7eRzOiZyMu6abV19eknVj5wWJiTmytQSxkjWHBR5b3N8G
         munKz0Tr0YYLCj2SpYIKyHZdLIpnJg0lLP63Lw6pFNDAur1Yx1ObNsW2XpLmwPp4OjW2
         nN0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wxoDaZ8UHHEQlvfwUILqE66J22AZX7CBjGhbO9+lAP8=;
        b=MrK0O8BekDgovXdtd4QbcIAAwboM4K6KsBjKJgU7SexS0R1ZvaBp0NNkilb0XaNOg/
         8X4YchBN0vEnsntdWTedM/xl9CUXyVWgHSw0dqN4WS5WZba5E0hx9/KZRaO5XIgpVy7D
         Dt9yPkthMFf5kANzq59aErBX4ZaGDkUHAM2yfNnwvybgTpj+mp0oz7FPiBzIDhiIyURy
         UFgwbfI8sWcMEn7Gcr7LZqWrx70ZiJ/TOoRG6XhqQgdxh4G0wHArEXyDRWH4PxrzIA4r
         IvP6xhub7akQYFvVhj/wUxrZEfg6d1/oPB4ZKqY1dx+RZMNGLrj09xnAllwnTO2zNIZ8
         BieA==
X-Gm-Message-State: AOAM533OAqYWDtmol5+tabCKzZgK4hiNmVavzB0hWv2398krwosNloXi
        qA3ViaSCmgvfLdg3yVanvFBq8XSa0+c=
X-Google-Smtp-Source: ABdhPJxNwuniEyTkzzYubwMHYOvUnazz975bfaZP0Z1jnZQtFQ9mWKuXNldMHS6Hknm7dxuvcbmc1w==
X-Received: by 2002:a62:7a97:: with SMTP id v145mr182279pfc.19.1598996636655;
        Tue, 01 Sep 2020 14:43:56 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 131sm128663pfy.5.2020.09.01.14.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 14:43:55 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Blair Prescott <blair.prescott@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM SYSTEMPORT
        ETHERNET DRIVER)
Subject: [PATCH net-next 3/3] net: systemport: Manage Wake-on-LAN clock
Date:   Tue,  1 Sep 2020 14:43:48 -0700
Message-Id: <20200901214348.1523403-4-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200901214348.1523403-1-f.fainelli@gmail.com>
References: <20200901214348.1523403-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is necessary to manage the Wake-on-LAN clock to turn on the
appropriate blocks for MPD or CFP-based packet matching to work
otherwise we will not be able to reliably match packets during suspend.

Reported-by: Blair Prescott <blair.prescott@broadcom.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 10 +++++++++-
 drivers/net/ethernet/broadcom/bcmsysport.h |  1 +
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 91eadba5540c..b25c70b74c92 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -2583,6 +2583,10 @@ static int bcm_sysport_probe(struct platform_device *pdev)
 	if (!ret)
 		device_set_wakeup_capable(&pdev->dev, 1);
 
+	priv->wol_clk = devm_clk_get_optional(&pdev->dev, "sw_sysportwol");
+	if (IS_ERR(priv->wol_clk))
+		return PTR_ERR(priv->wol_clk);
+
 	/* Set the needed headroom once and for all */
 	BUILD_BUG_ON(sizeof(struct bcm_tsb) != 8);
 	dev->needed_headroom += sizeof(struct bcm_tsb);
@@ -2772,8 +2776,10 @@ static int __maybe_unused bcm_sysport_suspend(struct device *d)
 	bcm_sysport_fini_rx_ring(priv);
 
 	/* Get prepared for Wake-on-LAN */
-	if (device_may_wakeup(d) && priv->wolopts)
+	if (device_may_wakeup(d) && priv->wolopts) {
+		clk_prepare_enable(priv->wol_clk);
 		ret = bcm_sysport_suspend_to_wol(priv);
+	}
 
 	clk_disable_unprepare(priv->clk);
 
@@ -2791,6 +2797,8 @@ static int __maybe_unused bcm_sysport_resume(struct device *d)
 		return 0;
 
 	clk_prepare_enable(priv->clk);
+	if (priv->wolopts)
+		clk_disable_unprepare(priv->wol_clk);
 
 	umac_reset(priv);
 
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.h b/drivers/net/ethernet/broadcom/bcmsysport.h
index 51800053e88c..3a5cb6f128f5 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.h
+++ b/drivers/net/ethernet/broadcom/bcmsysport.h
@@ -771,6 +771,7 @@ struct bcm_sysport_priv {
 	u8			sopass[SOPASS_MAX];
 	unsigned int		wol_irq_disabled:1;
 	struct clk		*clk;
+	struct clk		*wol_clk;
 
 	/* MIB related fields */
 	struct bcm_sysport_mib	mib;
-- 
2.25.1

