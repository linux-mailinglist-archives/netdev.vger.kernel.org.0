Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FFD268601
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgINHcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgINHcP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:15 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCAB5C06174A;
        Mon, 14 Sep 2020 00:32:07 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l126so11877412pfd.5;
        Mon, 14 Sep 2020 00:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yFfTzKbC737CiCdcc0Qf1mfE2VfmaqJXLd14QnIRSpM=;
        b=H9oplXLLvus21oTN7Tuzl9KJDupryRH7cT8dywWEtodMsg1282jIzm1oWqmL6WPKpB
         NOrf/JTBETDAuD7QoasYaFgGa4/SiQaKyH5DBogQUeUmURlhyJCDJQSrB0mj8Pviouou
         osvhqFtGZOIFc15H9L18HDf+UgfXxqsf/zcCmBQJWy6BdH2XUDUDc/4KDILQvAV41v8t
         egvOLafkMA0j5Ss2PYuJhIkDVLQ6qUiBXBGTah4sbL/0Pzew6fCZvxAzR2etMQ2qS9WS
         VhSQHxoIIGZG38tzwfAP8XUb8A5o29GJN2j4SAtUEEBti8iF9gOLxmCuLCPlCzc447XG
         +n+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yFfTzKbC737CiCdcc0Qf1mfE2VfmaqJXLd14QnIRSpM=;
        b=WcHW3xPDRTWe5LlmRM9eoHmlDzUNfKFIk+FmQs0Njs+izvWS58H16rHM2R8WAJlixU
         a2xzD0LCEdIZwIaIiMiDJ/mpdvJCbc4FLMJcwT7bTJG81hMRQx9bMRQF7T4RIQNmjc9s
         iVOJSX09vHFHkIAMSzwPMA3yo/SatD/VfLU3OqnSM2dXf5xUL0LtAFTnB12XoLcZJaq9
         n5JmYDPKHIMw5SYIGJy/D4XRdh1GDv2JcZp52+IJ4YWY3zyfUo2HXH3fAbz9Z+DCsvtl
         NXPNw67SHxograUlVhlCe8RduXxKEsCYbvB0nnWYwx03nZIHsmAdZnVu1VTgOS+Ee/oW
         t+oA==
X-Gm-Message-State: AOAM532m7AJ+VSLj+XQYjgJxg3p8JbF6UuRzTuUNxk+W6YHpJSSa/5SK
        +d1vGpK39KxMsbNgwi0g2jg=
X-Google-Smtp-Source: ABdhPJyEcN0So3gQDeCdXrlobhXHvrlly4dzm9jYBa4iJDafB560Qejk6uorb5sLy9KPnwapaRdhEA==
X-Received: by 2002:a63:6ce:: with SMTP id 197mr10223234pgg.32.1600068727519;
        Mon, 14 Sep 2020 00:32:07 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:32:07 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 06/12] net: cdc_ncm: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:25 +0530
Message-Id: <20200914073131.803374-7-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914073131.803374-1-allen.lkml@gmail.com>
References: <20200914073131.803374-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
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
2.25.1

