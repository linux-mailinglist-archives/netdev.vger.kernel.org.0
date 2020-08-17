Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33732461F3
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbgHQJII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728169AbgHQJH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:07:56 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C03AC061343;
        Mon, 17 Aug 2020 02:07:56 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id s14so1212062plp.4;
        Mon, 17 Aug 2020 02:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UBB+n9cDuI7XYF/pC4eNjD5U8+6JcYZBRuNgqS2AGgk=;
        b=HXLn54FBex80tHRNmwdKihOrEPyVtnLNdQf8TwlOBItoHYMgb7yHJ2oObwwvgiLVnE
         0UCPuPAPAPCdbPoSbPrpsbYWOFqTyGBExI+zGlB9BnPOZ7q7Qhrn82VJ3hcBHkitc1O0
         zAXjATodOhOkHExhgL+2sPPBkBg12CZB4iuyv7U0heF96xu0F+FXrhGu2likERpqGWYK
         asu0KNI5V0TWhz699ZzySTQ4uNmNZuuEaWIl2kphgmdxu0v74gt2EJVtNBYoqrxCDUc0
         TTCwdm+cl6qPFrdE0dDSpQI6GLPUzLH5UFov4kccjv7l1pq6L5LN7YikWzJzpEY/uLGn
         3psQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=UBB+n9cDuI7XYF/pC4eNjD5U8+6JcYZBRuNgqS2AGgk=;
        b=MOCnB5KoMPs92C4NLwMIliD12KFUQcopwcC02IR4VbfNW/+8XCGUNjjIhoSZM1Grj0
         ZcalP2PZDSnZQOkcX76Y4UbyUxkcLFBbgYvE/J8qJpnBorM54FXQJihH0jIjqCurdMMZ
         spiuqHnQ7GllV4+Ow9EAHviCrmwHMp7kfa8ys0ZWqYUUKFVVuM+4QL704kUnLg/kkd96
         lLLYqnNdK4twth80iZ0QeF8aP492mvCk4j6TSd2kR/YJ8xvzAEORqn6YRv+KVidanaqO
         /1WgjUxfnTMjJT7aoVwgaQH6nSetkANiugys0iGSBbWdfxOk3UQABaTC0vkvfKG86qpj
         SyFg==
X-Gm-Message-State: AOAM533JdCk5BWfi0z0roTFeURJx8nIbXJMnoBitKbg3Y7qXGcvFBHsl
        BA5F9eFRK3YpxZbd78ZTWvM=
X-Google-Smtp-Source: ABdhPJwm30IhDFLAzIdPcu0mrZMovl5JKjumtUizmN8j8X1WRRm412RMOp37kioXJ3J/qaYvQ8weqg==
X-Received: by 2002:a17:90a:950a:: with SMTP id t10mr11677353pjo.107.1597655275673;
        Mon, 17 Aug 2020 02:07:55 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.07.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:07:55 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     kvalo@codeaurora.org, kuba@kernel.org, jirislaby@kernel.org,
        mickflemm@gmail.com, mcgrof@kernel.org, chunkeey@googlemail.com,
        Larry.Finger@lwfinger.net, stas.yakovlev@gmail.com,
        helmut.schaa@googlemail.com, pkshih@realtek.com,
        yhchuang@realtek.com, dsd@gentoo.org, kune@deine-taler.de
Cc:     keescook@chromium.org, ath11k@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, b43-dev@lists.infradead.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 08/16] wireless: ipw2x00: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:29 +0530
Message-Id: <20200817090637.26887-9-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817090637.26887-1-allen.cryptic@gmail.com>
References: <20200817090637.26887-1-allen.cryptic@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 9 ++++-----
 drivers/net/wireless/intel/ipw2x00/ipw2200.c | 7 +++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 461e955aa259..b7fbfc77b612 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -3204,9 +3204,9 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 	}
 }
 
-static void ipw2100_irq_tasklet(unsigned long data)
+static void ipw2100_irq_tasklet(struct tasklet_struct *t)
 {
-	struct ipw2100_priv *priv = (struct ipw2100_priv *)data;
+	struct ipw2100_priv *priv = from_tasklet(priv, t, irq_tasklet);
 	struct net_device *dev = priv->net_dev;
 	unsigned long flags;
 	u32 inta, tmp;
@@ -6005,7 +6005,7 @@ static void ipw2100_rf_kill(struct work_struct *work)
 	spin_unlock_irqrestore(&priv->low_lock, flags);
 }
 
-static void ipw2100_irq_tasklet(unsigned long data);
+static void ipw2100_irq_tasklet(struct tasklet_struct *t);
 
 static const struct net_device_ops ipw2100_netdev_ops = {
 	.ndo_open		= ipw2100_open,
@@ -6135,8 +6135,7 @@ static struct net_device *ipw2100_alloc_device(struct pci_dev *pci_dev,
 	INIT_DELAYED_WORK(&priv->rf_kill, ipw2100_rf_kill);
 	INIT_DELAYED_WORK(&priv->scan_event, ipw2100_scan_event);
 
-	tasklet_init(&priv->irq_tasklet,
-		     ipw2100_irq_tasklet, (unsigned long)priv);
+	tasklet_setup(&priv->irq_tasklet, ipw2100_irq_tasklet);
 
 	/* NOTE:  We do not start the deferred work for status checks yet */
 	priv->stop_rf_kill = 1;
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 129ef2f6248a..5af1c548a564 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -1945,9 +1945,9 @@ static void notify_wx_assoc_event(struct ipw_priv *priv)
 	wireless_send_event(priv->net_dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-static void ipw_irq_tasklet(unsigned long data)
+static void ipw_irq_tasklet(struct tasklet_struct *t)
 {
-	struct ipw_priv *priv = (struct ipw_priv *)data;
+	struct ipw_priv *priv = from_tasklet(priv, t, irq_tasklet);
 	u32 inta, inta_mask, handled = 0;
 	unsigned long flags;
 	int rc = 0;
@@ -10673,8 +10673,7 @@ static void ipw_setup_deferred_work(struct ipw_priv *priv)
 	INIT_WORK(&priv->qos_activate, ipw_bg_qos_activate);
 #endif				/* CONFIG_IPW2200_QOS */
 
-	tasklet_init(&priv->irq_tasklet,
-		     ipw_irq_tasklet, (unsigned long)priv);
+	tasklet_setup(&priv->irq_tasklet, ipw_irq_tasklet);
 }
 
 static void shim__set_security(struct net_device *dev,
-- 
2.17.1

