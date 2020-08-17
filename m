Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FF32461FD
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgHQJIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728087AbgHQJIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:08:21 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8062C06138A;
        Mon, 17 Aug 2020 02:08:18 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id p37so7816186pgl.3;
        Mon, 17 Aug 2020 02:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6sU8o1XQWmR2sc7LetPQwvecEyprB+Gwia5I48gR5I8=;
        b=qXUGS1RMqtA2xbUCujNZntnf2zOYYcE4h+WiPza4dc2NxIOQswDgtwqqFOqtfM6jgC
         QuPK4TVQO9JSJ4I9FqbXKzWHKoUV9OR1GBGMMdT4TvLd6U8K9zRNhWk/oIz7pL+upc/s
         Yp1OG7Ab2JGPN3/+SRfK22DJjo8TVGcxcDYk1usgMWMU9cvO48EffkFfAiCqd9dMcv6E
         9J788afLBfzzkubzeWyn5SsGC46VcFAV2NFjBPlRNM1lYvubWAAHatDIbjpESVOW8nQp
         uzcFM8Ey1dfVFDbdyp3UKtEQxPt9zLE3MjO4bZvlfFdv2PJkh1UZKYJnKIGmth6UIQge
         AJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6sU8o1XQWmR2sc7LetPQwvecEyprB+Gwia5I48gR5I8=;
        b=VvG39ZUs9mZeE6tnDJAiuDvIy3Yg1kIixT9Tgyp59WgdQvY7/QiINyWMA87OvPRtDX
         nAvHqeZINayACQkutEqCtlQ2Dd88hUJ9porX19K4MBSg9lX6d4DFALQ5inls67Wd72Mz
         MkJlWE+6JUZtW5KFHOQV9TfVQivB6M9ikTggHdX6d3dnSTY983A66GVSc1kIT1TOt1I2
         U3sSzB4xLDuLiex78iWiWOWkmSdjIeIm8z22MJdTasr+6Z3O84A6OxtZQiXUg760N0QL
         cdrj7mB/ml2F4sjeHdicW7M8zAr90KBjLUmVX2TB/ii7on2NS4ZYkb3ScKrkwKASPDDx
         lSKQ==
X-Gm-Message-State: AOAM531YZN+5qDpIXRbUbipbPhN99POIWopowFQgjWyPr4Nh9yQYQnCz
        NWbJdYoV340bCENJsw3Zbko=
X-Google-Smtp-Source: ABdhPJzR0Lmnn1LKu2ZlXZNS9fQDRnVIaqr85aSxwYitxzM90mPxjkiagXju+vNO4oP8X/WAoR5E4w==
X-Received: by 2002:a63:5049:: with SMTP id q9mr9560233pgl.219.1597655298339;
        Mon, 17 Aug 2020 02:08:18 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:08:17 -0700 (PDT)
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
Subject: [PATCH 11/16] wireless: marvell: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:32 +0530
Message-Id: <20200817090637.26887-12-allen.cryptic@gmail.com>
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
 drivers/net/wireless/marvell/mwl8k.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 97f23f93f6e7..23efd7075df6 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -4630,10 +4630,10 @@ static irqreturn_t mwl8k_interrupt(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void mwl8k_tx_poll(unsigned long data)
+static void mwl8k_tx_poll(struct tasklet_struct *t)
 {
-	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
-	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_priv *priv = from_tasklet(priv, t, poll_tx_task);
+	struct ieee80211_hw *hw = pci_get_drvdata(priv->pdev);
 	int limit;
 	int i;
 
@@ -4659,10 +4659,10 @@ static void mwl8k_tx_poll(unsigned long data)
 	}
 }
 
-static void mwl8k_rx_poll(unsigned long data)
+static void mwl8k_rx_poll(struct tasklet_struct *t)
 {
-	struct ieee80211_hw *hw = (struct ieee80211_hw *)data;
-	struct mwl8k_priv *priv = hw->priv;
+	struct mwl8k_priv *priv = from_tasklet(priv, t, poll_rx_task);
+	struct ieee80211_hw *hw = pci_get_drvdata(priv->pdev);
 	int limit;
 
 	limit = 32;
@@ -6120,9 +6120,9 @@ static int mwl8k_firmware_load_success(struct mwl8k_priv *priv)
 	INIT_WORK(&priv->fw_reload, mwl8k_hw_restart_work);
 
 	/* TX reclaim and RX tasklets.  */
-	tasklet_init(&priv->poll_tx_task, mwl8k_tx_poll, (unsigned long)hw);
+	tasklet_setup(&priv->poll_tx_task, mwl8k_tx_poll);
 	tasklet_disable(&priv->poll_tx_task);
-	tasklet_init(&priv->poll_rx_task, mwl8k_rx_poll, (unsigned long)hw);
+	tasklet_setup(&priv->poll_rx_task, mwl8k_rx_poll);
 	tasklet_disable(&priv->poll_rx_task);
 
 	/* Power management cookie */
-- 
2.17.1

