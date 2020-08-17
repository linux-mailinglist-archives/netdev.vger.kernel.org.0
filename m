Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6235E2460F0
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbgHQIrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgHQIqz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:46:55 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88970C061389;
        Mon, 17 Aug 2020 01:46:55 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id g7so6026091plq.1;
        Mon, 17 Aug 2020 01:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Uavx1EOmJ7bSLeVLJ6XOgqseCssvPSFdNEvIC2Bysbw=;
        b=LPJJgyv3/lpXbkuhi7Kjvn9mnA+OOxbjWuXsLs5FFc9v2qhqmkyKataTtaef0mNZ8w
         PudCWR1MMRmUIRpmDWHr3Z02PxKnmCODhbQW7JN241sYryKi9oJgjN38TADW5CGPRBfd
         QJHawRn1PCIw5GxiC5ufMuejMLjJ9WTT8G6KVWHriDUg81PpiQTF29r0xLm5KXj0jQ3Y
         2EkHtYPtJZJ6+6MRyRy/LHqXc3cgxDMumDN8VFqt5Eu2qcZ6KbrLRjBbFBInnnNbK48r
         gZCgLDq5Zf0rYofg21pe+ZI6aYbWRFVqCT4kBpw5XmsGvcD4fce+QmZaWYYouco6vScv
         CMwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Uavx1EOmJ7bSLeVLJ6XOgqseCssvPSFdNEvIC2Bysbw=;
        b=sT7oxkt4E/G44J8YK8HF8uoHYxcxuIGRmwpjg9DXnvwsPC/3QkYxpM6Zq5oY+MTEXf
         yMPXtA1NE0gmw9K+1AorbKxAK8/NCD9w8NlIOg1yn+kwxr7L+QrVeh92mzuRGNZ32srf
         EbyPU/OWO0Sfxz/E0rt9K20QHSOT2aAcpamBtqrNVtJ175K8CbuolQ4A7GadaS5d0prF
         Zcgul7gLX77erU3P8lNrsuEoxnK8lCBIekZlEFO7CrLl4nfY91bbE87tEt7wCOAledDf
         H0l7QPM0okqxCnd9falpafSrD2dJSAQV9W+omE+56hzqV5a11tde8tTSJt8MCbMmD1mV
         iWWw==
X-Gm-Message-State: AOAM532KrhuYsy2NAECB0IMeQAlHRTpLORsIX1Mh7BOJmBfRoj1quLze
        8Debx8yLLf9f4kmN6y+P83o=
X-Google-Smtp-Source: ABdhPJww6G5UjSHakF95RK6lWfDJt0TSnLD/Lmaq3pCsiIthUPmi94Kb2THrMEF3W0jGfBwSAhy2AQ==
X-Received: by 2002:a17:902:a585:: with SMTP id az5mr10412116plb.172.1597654015098;
        Mon, 17 Aug 2020 01:46:55 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:46:54 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 3/9] net: cdc_ncm: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:08 +0530
Message-Id: <20200817084614.24263-7-allen.cryptic@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817084614.24263-1-allen.cryptic@gmail.com>
References: <20200817084614.24263-1-allen.cryptic@gmail.com>
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
 drivers/net/usb/cdc_ncm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e04f588538cc..57a95ef90385 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -61,7 +61,7 @@ static bool prefer_mbim;
 module_param(prefer_mbim, bool, 0644);
 MODULE_PARM_DESC(prefer_mbim, "Prefer MBIM setting on dual NCM/MBIM functions");
 
-static void cdc_ncm_txpath_bh(unsigned long param);
+static void cdc_ncm_txpath_bh(struct tasklet_struct *t);
 static void cdc_ncm_tx_timeout_start(struct cdc_ncm_ctx *ctx);
 static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *hr_timer);
 static struct usb_driver cdc_ncm_driver;
@@ -815,7 +815,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 
 	hrtimer_init(&ctx->tx_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ctx->tx_timer.function = &cdc_ncm_tx_timer_cb;
-	tasklet_init(&ctx->bh, cdc_ncm_txpath_bh, (unsigned long)dev);
+	tasklet_setup(&ctx->bh, cdc_ncm_txpath_bh);
 	atomic_set(&ctx->stop, 0);
 	spin_lock_init(&ctx->mtx);
 
@@ -1468,9 +1468,9 @@ static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void cdc_ncm_txpath_bh(unsigned long param)
+static void cdc_ncm_txpath_bh(struct tasklet_struct *t)
 {
-	struct usbnet *dev = (struct usbnet *)param;
+	struct usbnet *dev = from_tasklet(dev, t, bh);
 	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
 
 	spin_lock_bh(&ctx->mtx);
-- 
2.17.1

