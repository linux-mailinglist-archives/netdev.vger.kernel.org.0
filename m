Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30AA0268613
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbgINHdn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgINHcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:21 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B8FC06178B;
        Mon, 14 Sep 2020 00:32:20 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id v14so3569991pjd.4;
        Mon, 14 Sep 2020 00:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cd71yq/lAASqvcH4C2Jtz3wuu5v0StzhHrHHOcVra4g=;
        b=JQAf75xcEztoyinIIDsx1TWKkL/AJ4wVKElWlJKiEycTkNg4NaU89AjUPZuklCIivF
         ZHn7CWNqeXB2ZXURJiBJFWqh3YlCUJwzAr4Xr4SUB0WbBkkj7sTBbKq8NiC3ZvloTLTl
         TlYFAPlniWvALfFaWjP+I4TSWA/VmOb1G6MGIt0twZ02SNFIpR2oMhFwXlNI6kgpXnWB
         G5oQXIOq79hdf/BjUETwLXPQjVlGA0Lm8+lYsgUnqVtEIg4Mzvn8cWO4wtE8dncji0UQ
         xUuZHmZr1yrfoRF7QnMC3dFlj33H84UAy31UrljaFlQzqlggOE0YKpmgr43y2pqmnefm
         TGwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cd71yq/lAASqvcH4C2Jtz3wuu5v0StzhHrHHOcVra4g=;
        b=Y26hpk0NG4n81/g6kdHV2XhcYoz/lkgEUyw9W1GwQQpNo7BOtsMCBvaKjOnvceT8or
         qb7h9axSk1qDSu8IVKrFU4n7nu4zr5KV1M6HzFWpE+V/Lc6lJ1U1lepVtd7edqrfJXv4
         c/uJ7CvzEm1arVAH1lBBNUPeoF4pp5TxueNNn23zug/82wm+5KGDhGAE6BZJpuQOkhE5
         Am7n7dFInMc5HrI4aPQh1RzNeJt2AE7/qVlJqm5PjTRz1uQT1kGQgxOkGpVDFrHdAVQe
         dX49K/gwRy5/h9VxHJffka3ICQsc41w+CH+ycxV3QjchCqnybRqYSLPPokvAALmCvOSO
         bnZQ==
X-Gm-Message-State: AOAM5337ybrm6DmxfThxRx99bDvNosqlSqx1FRoNn1aVYSGwJbyCJPlv
        Qe9OLyI9s7E0hNqEF6wRwh0=
X-Google-Smtp-Source: ABdhPJyxn4lCfqiv+OVxmW576cCaSzWQhjtVvF1qvhnzNVPCURZEq0END9+HC31olr2Y4/lnztzaNg==
X-Received: by 2002:a17:90b:104f:: with SMTP id gq15mr12445937pjb.215.1600068740380;
        Mon, 14 Sep 2020 00:32:20 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:32:19 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 09/12] net: pegasus: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:28 +0530
Message-Id: <20200914073131.803374-10-allen.lkml@gmail.com>
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
 drivers/net/usb/pegasus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index e92cb51a2c77..1f11e586037f 100644
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
2.25.1

