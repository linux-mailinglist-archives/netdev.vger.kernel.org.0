Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4FD524621F
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 11:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbgHQJKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 05:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728781AbgHQJHl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 05:07:41 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F85DC06138A;
        Mon, 17 Aug 2020 02:07:33 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id i10so2274074pgk.1;
        Mon, 17 Aug 2020 02:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CTxSxCLcXtx7K2nHBX1s0dpHO14GqBxRUYGs9AhPATI=;
        b=ZxNQMq20uoDRbIr/qBq0gsF0L2FC1tp0+LmN2xpBpa4kZMCpmUWVNhrQqgEgdMGi28
         zhu6AsjHyMI9ezhcjvSFFhoxeWmCmizBbhaCyiLfu/9DTqCxFcAt6nzHTUHllyARA4DK
         kPfYw3/LJcqcoYbk9ywZQDsgnOEZBecK/4RZ7vg4Jq6NkgSjmBEAPsKlddCD7iAmqmW3
         NM5QcO+sdj6jF8gWjr2AL9a+EMxWoDJy1dGJif/dp9Gd2MVVuR/5bo3thrM64GmwYdmn
         pp4pck/F0ANxVXDC/xb18jS02uOyO4uqTUgsrmfosFPwLIkBheJ1DZQbrPGmvRfOzKHR
         X5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CTxSxCLcXtx7K2nHBX1s0dpHO14GqBxRUYGs9AhPATI=;
        b=FoOsgGe/VQ+nog627bqRgkiNY/UP5ECSkv4SXyn5024V56C/uqXMuYW0blRC9tKPJq
         WcYU9gLNCiHpTucL12LMovg37DFyAydMKQSzsv+PejSLUJgTOpfz3NtgOE1LzixGIUU9
         3Vj20D3hS9MNPWTYE0WJV9ncbpJxvTbr0u+QqG9ySMyGwL9LBm8XuCERZpndhx7raAGh
         h+oI3vExsFalzTNd1lVKniQBgMzmFgH6SIxEyXjbmDMtwVtNtWfQEVjQ7es+MbLCcM2O
         +oCV2PamlJLhxNBKnPGlITEk0UiJOqXAywvWmrNg64j61vNuuVOiQe97aby7Eclni9/K
         zAbA==
X-Gm-Message-State: AOAM532/uaDN0ySWIy+Nqdm82gRxXeQ0TM6LILZZ7ttCi2PffKhmiLg6
        NLioi5UgQmbPJOJlqme8zmM=
X-Google-Smtp-Source: ABdhPJw4O6FVlqolZK+ui0NUfpSUYbGTVVcmXQX9MXy4HvFtIoe5YnofINDnVG5/0IBC1eRown9dcA==
X-Received: by 2002:a63:eb14:: with SMTP id t20mr366676pgh.236.1597655253001;
        Mon, 17 Aug 2020 02:07:33 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id t14sm16616237pgb.51.2020.08.17.02.07.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 02:07:32 -0700 (PDT)
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
Subject: [PATCH 05/16] wireless: atmel: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:36:26 +0530
Message-Id: <20200817090637.26887-6-allen.cryptic@gmail.com>
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
and from_tasklet() to pass the tasklet pointer explicitly
and remove .data field.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/wireless/atmel/at76c50x-usb.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/atmel/at76c50x-usb.c b/drivers/net/wireless/atmel/at76c50x-usb.c
index a63b5c2f1e17..365c2ee19d03 100644
--- a/drivers/net/wireless/atmel/at76c50x-usb.c
+++ b/drivers/net/wireless/atmel/at76c50x-usb.c
@@ -1199,7 +1199,6 @@ static void at76_rx_callback(struct urb *urb)
 {
 	struct at76_priv *priv = urb->context;
 
-	priv->rx_tasklet.data = (unsigned long)urb;
 	tasklet_schedule(&priv->rx_tasklet);
 }
 
@@ -1545,10 +1544,10 @@ static inline int at76_guess_freq(struct at76_priv *priv)
 	return ieee80211_channel_to_frequency(channel, NL80211_BAND_2GHZ);
 }
 
-static void at76_rx_tasklet(unsigned long param)
+static void at76_rx_tasklet(struct tasklet_struct *t)
 {
-	struct urb *urb = (struct urb *)param;
-	struct at76_priv *priv = urb->context;
+	struct at76_priv *priv = from_tasklet(priv, t, rx_tasklet);
+	struct urb *urb = priv->rx_urb;
 	struct at76_rx_buffer *buf;
 	struct ieee80211_rx_status rx_status = { 0 };
 
@@ -2215,7 +2214,7 @@ static struct at76_priv *at76_alloc_new_device(struct usb_device *udev)
 	INIT_WORK(&priv->work_join_bssid, at76_work_join_bssid);
 	INIT_DELAYED_WORK(&priv->dwork_hw_scan, at76_dwork_hw_scan);
 
-	tasklet_init(&priv->rx_tasklet, at76_rx_tasklet, 0);
+	tasklet_setup(&priv->rx_tasklet, at76_rx_tasklet);
 
 	priv->pm_mode = AT76_PM_OFF;
 	priv->pm_period = 0;
-- 
2.17.1

