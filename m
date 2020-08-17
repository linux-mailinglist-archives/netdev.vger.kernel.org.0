Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3C92460F7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:47:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbgHQIrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgHQIrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:47:10 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41F1C061388;
        Mon, 17 Aug 2020 01:47:09 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u128so7893848pfb.6;
        Mon, 17 Aug 2020 01:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lMvQXQqK67XE+ERJB4p7WULy70BNuugzhIMCPrWP7dc=;
        b=RR4FE7zIDT7xeJOw2T0yeOy8yebnB11xxk30+wQaytBEzxV/MFN6/pC9x6iU/9ygxp
         HddjXFM1tpAGKFD7jFJrGhn45BnTzr3yEyc2Zuss3oNBERdfs9hVTwlrDj++iTgoZxBe
         eNbD3eKt4dufe6BmPfHgWa9Dq+gEBKiEmyJ67+7g9urctxoZFapjBz6ZWKExv5l0ApWW
         3IeCKkLvcRLuHVXiQ+BC1HTjnz9246JxhBfidmHGtTqr7jDHxv1N+RjKM5QnyCSGMfqR
         4ks47n5plHjmPz+o0yuwtrVecJtoVmKR/6xeTD2qhfZb71jqKoAxI7RB+hyUQpFEUgdU
         DZaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lMvQXQqK67XE+ERJB4p7WULy70BNuugzhIMCPrWP7dc=;
        b=hwYuIPzEL7omgmWcmyFGIEnLEcihB7vX/s05WWswbmR3w7B0P2IuKr+tJWUx56YmKw
         y1VTwH2tBHGLEv+J/J86aeuffF5t8sR9UrhB92XtViT6sLnzH8pV92fIbQ9YpMeQ1Anp
         sPqrfq5Hk5ipHW9wUsrhJf4aXYEcOATuYSySvhH9W8jHWv5iqKkp23I5NeZinbyMsOdy
         n5Hj8v33WTCAjSlZneLLN995h9Dyf+uw6PojUNhMVeT9a+z/QF/LKoR6VHV9Jca1Ex2D
         4F+Ak6bFJSsdwbtbqXoc92Ra+sdvwFFaw2pwEHS4L9J2uEVYX2veoXcqiQzsHuRmUEvF
         X8mA==
X-Gm-Message-State: AOAM532AWtNUsz12Y3/Z+H9kU7U7oCbssTjq/8tIz0EmYz7efnxOglOF
        BZqvRcUdRGWaadTmtbpSVP+yIKUKE+Wcwg==
X-Google-Smtp-Source: ABdhPJxb8PBsTsMLDsJ2/3LBtSkPpxbTso20fBQASjXGomLKioE9lTEwZMw1et+kICAbv3Ribbp/iQ==
X-Received: by 2002:a63:9d0b:: with SMTP id i11mr9105907pgd.399.1597654029291;
        Mon, 17 Aug 2020 01:47:09 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:47:08 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 6/9] net: pegasus: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:11 +0530
Message-Id: <20200817084614.24263-10-allen.cryptic@gmail.com>
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
 drivers/net/usb/pegasus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 0ef7e1f443e3..addf904e7c65 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -565,12 +565,12 @@ static void read_bulk_callback(struct urb *urb)
 	tasklet_schedule(&pegasus->rx_tl);
 }
 
-static void rx_fixup(unsigned long data)
+static void rx_fixup(struct tasklet_struct *t)
 {
 	pegasus_t *pegasus;
 	int status;
 
-	pegasus = (pegasus_t *) data;
+	pegasus = from_tasklet(pegasus, t, rx_tl);
 	if (pegasus->flags & PEGASUS_UNPLUG)
 		return;
 
@@ -1141,7 +1141,7 @@ static int pegasus_probe(struct usb_interface *intf,
 		goto out1;
 	}
 
-	tasklet_init(&pegasus->rx_tl, rx_fixup, (unsigned long) pegasus);
+	tasklet_setup(&pegasus->rx_tl, rx_fixup);
 
 	INIT_DELAYED_WORK(&pegasus->carrier_check, check_carrier);
 
-- 
2.17.1

