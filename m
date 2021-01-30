Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71DFB3098DD
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 00:48:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232280AbhA3Xr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 18:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhA3Xr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 18:47:27 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CFCC061573;
        Sat, 30 Jan 2021 15:46:46 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id s11so14799165edd.5;
        Sat, 30 Jan 2021 15:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qwA2gP4Z6kauBc6Cc73AmShh3FB/zzrpeQJUUXZmIH0=;
        b=e3Oc9m+umdOmjwsP9KdTReObMY0/FdDSHDqvzx+xhoBMqgcJW0U+RTlW8C/N2LagAR
         9s3UZleEBmOpIllSckwltFkKvhNrOF07BV46894A7TiWFn9A5sAipwYbG0V8CKX1Lg4s
         K+KCsvQ1prpMbyCWPO8DyHKCwFwqVPGVpvBQppC9jcuBsfAAYe9EtdKoR+BJqmXF6y5r
         TbcbqEPftKg9emW5VUit1lcLCicRW1t6TjB8GfITcfLpxMbSqfFmd1wKQ0tV+aCS7rfO
         ixdT3pHwXBPaCyGA/MHbXr7mXJtnmoP/ThzJs4bj8jZwcuuKY3yJ3u3TNOB9Gk3EDvGT
         4MKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=qwA2gP4Z6kauBc6Cc73AmShh3FB/zzrpeQJUUXZmIH0=;
        b=JEPgXQapRnxVXM/be4Ds29RCvrD2riYWzHlX7isuBLJL1CnsZXN7CIL49bWm59m74k
         HIZSjBiJmGycRgP0yTSVzmVEeeduunrJ9ToroRlMncwj8FgPKDvEjeeVlyKZCd7GYIOH
         pxkmxku8iyjqYmFka8Z56bA3npgUbM3b9LkNPrGOS7hILyY1MLpGm3aQ7s9JrjokHcJD
         n5FgBVsJreLLJHIQmRcv8L6U/ZKDLNBb62V7l9qzfDfscKmsfFxvgkFekRRsyOIjVDzI
         j4ELEo6fRVkcvkFqtTUzv0Nm71YlZcSm0W/TqvyijfEDLQwDuy6m/4yFf6ed2iTvVrpm
         vxKA==
X-Gm-Message-State: AOAM5325gbk4tEjy98B0SBWneF9PMtz4dZKle/8jYYoKRffSPoVOnK8c
        yT7b32o2aC1MnLhjUC8udSmaHIjQL/EzyQ==
X-Google-Smtp-Source: ABdhPJx7XVrefx5b4ETT32hLZdkRAaatr8F8S3u8Z8ooDjHPjy9JaoL3I9vchwk0Yv6jb8Em26UvSQ==
X-Received: by 2002:a05:6402:60a:: with SMTP id n10mr11779375edv.230.1612050405218;
        Sat, 30 Jan 2021 15:46:45 -0800 (PST)
Received: from stitch.. ([80.71.140.73])
        by smtp.gmail.com with ESMTPSA id ah12sm5814197ejc.70.2021.01.30.15.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Jan 2021 15:46:44 -0800 (PST)
Sender: Emil Renner Berthing <emil.renner.berthing@gmail.com>
From:   Emil Renner Berthing <kernel@esmil.dk>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Emil Renner Berthing <kernel@esmil.dk>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: usb: cdc_ncm: use new API for bh tasklet
Date:   Sun, 31 Jan 2021 00:46:37 +0100
Message-Id: <20210130234637.26505-1-kernel@esmil.dk>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the driver to use the new tasklet API introduced in
commit 12cc923f1ccc ("tasklet: Introduce new initialization API")

It is unfortunate that we need to add a pointer to the driver context to
get back to the usbnet device, but the space will be reclaimed once
there are no more users of the old API left and we can remove the data
value and flag from the tasklet struct.

Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
---
Let me know if you know of a better way to get the usbnet device from
the cdc_ncn_ctx context.

 drivers/net/usb/cdc_ncm.c   | 12 +++++++-----
 include/linux/usb/cdc_ncm.h |  2 ++
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 291e76d32abe..4087c9e33781 100644
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
@@ -813,9 +813,11 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 	if (!ctx)
 		return -ENOMEM;
 
+	ctx->dev = dev;
+
 	hrtimer_init(&ctx->tx_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	ctx->tx_timer.function = &cdc_ncm_tx_timer_cb;
-	tasklet_init(&ctx->bh, cdc_ncm_txpath_bh, (unsigned long)dev);
+	tasklet_setup(&ctx->bh, cdc_ncm_txpath_bh);
 	atomic_set(&ctx->stop, 0);
 	spin_lock_init(&ctx->mtx);
 
@@ -1472,10 +1474,10 @@ static enum hrtimer_restart cdc_ncm_tx_timer_cb(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static void cdc_ncm_txpath_bh(unsigned long param)
+static void cdc_ncm_txpath_bh(struct tasklet_struct *t)
 {
-	struct usbnet *dev = (struct usbnet *)param;
-	struct cdc_ncm_ctx *ctx = (struct cdc_ncm_ctx *)dev->data[0];
+	struct cdc_ncm_ctx *ctx = from_tasklet(ctx, t, bh);
+	struct usbnet *dev = ctx->dev;
 
 	spin_lock_bh(&ctx->mtx);
 	if (ctx->tx_timer_pending != 0) {
diff --git a/include/linux/usb/cdc_ncm.h b/include/linux/usb/cdc_ncm.h
index 0ce4377545f8..f7cb3ddce7fb 100644
--- a/include/linux/usb/cdc_ncm.h
+++ b/include/linux/usb/cdc_ncm.h
@@ -98,6 +98,8 @@ struct cdc_ncm_ctx {
 	struct hrtimer tx_timer;
 	struct tasklet_struct bh;
 
+	struct usbnet *dev;
+
 	const struct usb_cdc_ncm_desc *func_desc;
 	const struct usb_cdc_mbim_desc *mbim_desc;
 	const struct usb_cdc_mbim_extended_desc *mbim_extended_desc;
-- 
2.30.0

