Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989D22845D7
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgJFGMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:35 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 257CBC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id h2so698191pll.11
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NapLG5xGSA6zL7J4CktPjbhy5S9DFmPYUCoV49Bbr34=;
        b=CdbnlBWKTZovz9tvPQs8fjsXRAFxLTlVK4XKsSxC9O/bRuYM9Ii//y7Olj636xrYr9
         ckNNFawu5S5apOOU/c+fwJtb03iK5Qt6kS7DWDujsbwKVrBfT8gQHvR0liIidcctl7i6
         dwBn68BLo0YM0Yyto9rvZnq3kmIFwaBzo2aCsAqcAi47y1uBtHeOvab6Yjbd250Pewij
         vEzaKf8KLNjK6qdPJU/CDRXECkWX7awtMO6xIC0EfO8WtLQoy0CLpOU4ccYAXTO3s7Vi
         mwPpiRMWPJVpcs6h6d2G6L+rN4s81UbcP8RnJZ7nyZggUWNRhyQJ1rVKnfKALgS6pG6x
         Pwmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NapLG5xGSA6zL7J4CktPjbhy5S9DFmPYUCoV49Bbr34=;
        b=AF9w7AbP4i+AbgpGasGxi+9+eAnpewkTXNxXVHfGZiSy3yNQIvRhma3p/QNgo42VKW
         bmJaoXHIo5ynANSplgOxYQTnLuuYPk5j12wKmcC3BxEX/ITWUZl8J60G0wICDY2yN1FA
         JcylOaQuDW6Cei6dlu7wbK6uOgp6qLENMMe6T9M7DKHD0Z6rPdBMiJGOcKnTbawMEjBq
         q9kDl2FHDaj81TZ7rT3dScIhjg5nfPBBuEDkzs2lSS1gcCfhEp62oGqAJCiZ1EaZs79p
         BW7g9ooXzc5eVFgiSUlFOcp1Yv66OwyLSNG99jt/dX1XawQle8aaZIEhU4GIeJBLgykc
         pxfw==
X-Gm-Message-State: AOAM532TOelWpBIU8E1LC6d/NGDRJK2FMxyQhC6ncknUNUYpagepU9in
        xcxSy0rvLTepG8iCCGiuMgs=
X-Google-Smtp-Source: ABdhPJxPE0A1OVr8iMMrhTVelXa4bjkxigLnFGwSmZyqsZ9giWhc3rDaBC4Rs91EciDvKR60MQMH3w==
X-Received: by 2002:a17:90a:e64c:: with SMTP id ep12mr2803977pjb.43.1601964754720;
        Mon, 05 Oct 2020 23:12:34 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:34 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 05/10] net: cdc_ncm: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:54 +0530
Message-Id: <20201006061159.292340-6-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006061159.292340-1-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/usb/cdc_ncm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index e04f58853..57a95ef90 100644
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
2.25.1

