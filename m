Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4DE1268606
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgINHcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgINHcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:33 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A976C061788;
        Mon, 14 Sep 2020 00:32:32 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id q4so5022181pjh.5;
        Mon, 14 Sep 2020 00:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zOQKj9yAVp75GeABVCWJkbI1F1JUvZbL7Zt6hBXdVz8=;
        b=H7Vk5lpud8ae6do/7R7/E439BDih3dEXglPrN4QqhqLQQ1FQLrVcCAHDb5kj+fpEh5
         jgworh/Rgo/WQ0m3CUHSklQxIVCn5UYvKw6xDqgesyKExEUOtrGvD93csUhuKpeYsP1r
         B9kx+8EQ+VJjLwz7Bb3LnOmdygSDnAz4MxvcvQZYLQdDcxEDKW4qWWdQ8GOOCa6owmLD
         0E4zGxeTmCy8+p8QgPNG46Hn3YwdeBMAoDAUik1H477+Ap/HI7oF6yhMre5u07bv5YoN
         83sTHWAXkPLNBaiOHSHl0JQ87pcL6TBelQ//35vPXG++uBmOXGeYR2rs5YxH5D5bVAYy
         L35g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zOQKj9yAVp75GeABVCWJkbI1F1JUvZbL7Zt6hBXdVz8=;
        b=i+8UrnFfL15Lo1ugDRFk6bND7DsYoywNroRdordYxf0O9VtdxCJ9x3GxBeEkzoZGi/
         oTqDFVvy3VLsAFePSeALT3pB65KVNN2NuZslCOzRJcPvOinDEjGTIlpqMJcogbK0y9Nb
         3Fxja8zm4sMycOQ8mKZx05BuI7lLvi24FTWsbA+dMmZE6sfnFnTCXo7i3N+Y9uXNtKlE
         Ql0Pwgeq3SZY90P2oVk6csU/I92V9YpPCZ6GyzRW1xEpSTM23vZLeThI779cV16ZEvIt
         Nd/YfiPHylJhI3BW/msWrCraUGZgbuBiB+E4yPwadxtytGWqtlsUaZZYERTifoXGaOkw
         GAug==
X-Gm-Message-State: AOAM533ghjAUWimkbeWYvamp8Kgq/kBIAfVpP+Z3LTRze1AtB4XEM1OR
        W1n5xP5xfeJnTKoiawaAF6w=
X-Google-Smtp-Source: ABdhPJz6NeGTlr+27zZLNZza9dbvHhQ1tg12+yq4GzCKa4ifumMPCs29uCVZqiEazYOJGCtTZjblaQ==
X-Received: by 2002:a17:90a:ec0b:: with SMTP id l11mr12375692pjy.144.1600068751891;
        Mon, 14 Sep 2020 00:32:31 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:32:31 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 12/12] net: usbnet: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:31 +0530
Message-Id: <20200914073131.803374-13-allen.lkml@gmail.com>
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
and from_tasklet() to pass the tasklet pointer explicitly
and remove the .data field.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
---
 drivers/net/usb/usbnet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 2b2a841cd938..d63485b858ba 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1708,8 +1708,7 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 	skb_queue_head_init (&dev->txq);
 	skb_queue_head_init (&dev->done);
 	skb_queue_head_init(&dev->rxq_pause);
-	dev->bh.func = usbnet_bh_tasklet;
-	dev->bh.data = (unsigned long)&dev->delay;
+	dev->bh.func = (void(*) (unsigned long))usbnet_bh_tasklet;
 	INIT_WORK (&dev->kevent, usbnet_deferred_kevent);
 	init_usb_anchor(&dev->deferred);
 	timer_setup(&dev->delay, usbnet_bh, 0);
-- 
2.25.1

