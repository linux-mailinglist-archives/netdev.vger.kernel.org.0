Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 387DD2F8BA1
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 06:28:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725903AbhAPF1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 00:27:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbhAPF13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 00:27:29 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F3DC061757
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 21:26:49 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id q25so10780512otn.10
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 21:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lhhC7i8Jt4OyU/mL///U4MefuTCdZmJtkcEWZXhJTEM=;
        b=Uzxc4W+4aVbbHBCeuzBCIq+SpmtESQvEbAtx0XbHjbFr3Cvm0XZ6gQh3N99sDlKItl
         1sn+VBP/aahUtygbPpBI348RRmzlLMa6VwOo6GCVzaio4JWTDiyGHyX04P3bVxuYp3nP
         TXQRhYmBVxOeEiuBsDjt1VvyhQKRR7GqaclAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lhhC7i8Jt4OyU/mL///U4MefuTCdZmJtkcEWZXhJTEM=;
        b=KOXYJuiSbgGB69qpEsBeNa5uFzhIgx11PV6Zc5DyXGbkM3wmuG569mOFbC1wKiBIFP
         EV6kR71NOLxMiOmbOm3jAUB9iqu9PMxuY93XzHBneYYZO+N9kmsoJx4VI7GXixf7qWFw
         TTbTuwHEHa1D4nzqdZZzri4OdxhzNtWwEgFvafS+1kxLEb6tTNvAaL09TwrC2SrgUx1s
         LS0fj0Y6x92ho4nIHgLhs1y779z+6RdnJB/G0h6RUzpYiEzr8baTJNe3pV7dHu2I4F4v
         xiwnwcwXUmn9vP5INFqoL979VJcJLl7E/XghUsv6xv/8vSwgGSOgfOq4MLq97Itqtck8
         YNJQ==
X-Gm-Message-State: AOAM530FWuwpOcyeId6IDTQ3cMOQMxj3Lf1gfcr3zkwk///sERskPDay
        LPSJIO0VVbjavOQYUjb+AoSihg==
X-Google-Smtp-Source: ABdhPJxh1r3oU4OXQzj0HdZsCt26mLhKNwn9ETHwblOh9IAAMHiid+0NjI2z8mxvWBxJ3Mn+qzcHnA==
X-Received: by 2002:a05:6830:458:: with SMTP id d24mr10584784otc.163.1610774808529;
        Fri, 15 Jan 2021 21:26:48 -0800 (PST)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id 94sm2359230otw.41.2021.01.15.21.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 21:26:47 -0800 (PST)
From:   Grant Grundler <grundler@chromium.org>
To:     Oliver Neukum <oliver@neukum.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 1/3] net: usb: cdc_ncm: emit dev_err on error paths
Date:   Fri, 15 Jan 2021 21:26:21 -0800
Message-Id: <20210116052623.3196274-1-grundler@chromium.org>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several error paths in bind/probe code will only emit
output using dev_dbg. But if we are going to fail the
bind/probe, emit related output with "err" priority.

Signed-off-by: Grant Grundler <grundler@chromium.org>
---
 drivers/net/usb/cdc_ncm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index 5a78848db93f..25498c311551 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -849,17 +849,17 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 
 	/* check if we got everything */
 	if (!ctx->data) {
-		dev_dbg(&intf->dev, "CDC Union missing and no IAD found\n");
+		dev_err(&intf->dev, "CDC Union missing and no IAD found\n");
 		goto error;
 	}
 	if (cdc_ncm_comm_intf_is_mbim(intf->cur_altsetting)) {
 		if (!ctx->mbim_desc) {
-			dev_dbg(&intf->dev, "MBIM functional descriptor missing\n");
+			dev_err(&intf->dev, "MBIM functional descriptor missing\n");
 			goto error;
 		}
 	} else {
 		if (!ctx->ether_desc || !ctx->func_desc) {
-			dev_dbg(&intf->dev, "NCM or ECM functional descriptors missing\n");
+			dev_err(&intf->dev, "NCM or ECM functional descriptors missing\n");
 			goto error;
 		}
 	}
@@ -868,7 +868,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 	if (ctx->data != ctx->control) {
 		temp = usb_driver_claim_interface(driver, ctx->data, dev);
 		if (temp) {
-			dev_dbg(&intf->dev, "failed to claim data intf\n");
+			dev_err(&intf->dev, "failed to claim data intf\n");
 			goto error;
 		}
 	}
@@ -924,7 +924,7 @@ int cdc_ncm_bind_common(struct usbnet *dev, struct usb_interface *intf, u8 data_
 	if (ctx->ether_desc) {
 		temp = usbnet_get_ethernet_addr(dev, ctx->ether_desc->iMACAddress);
 		if (temp) {
-			dev_dbg(&intf->dev, "failed to get mac address\n");
+			dev_err(&intf->dev, "failed to get mac address\n");
 			goto error2;
 		}
 		dev_info(&intf->dev, "MAC-Address: %pM\n", dev->net->dev_addr);
-- 
2.29.2

