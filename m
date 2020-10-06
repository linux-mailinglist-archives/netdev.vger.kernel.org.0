Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 847812845DA
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgJFGMt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:48 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FE9C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:48 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id az3so1045304pjb.4
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JhX2wxus5RbdcHbbl5XkDhw1vYd+kb0KjLnVSS0LP+k=;
        b=dD5vCNIjptEVROer9MwJHrcyBz0bVYx2/OGMOOLxSKy1GupS18mtiqwu1Na6wcaL41
         kxZuZ1eqOEf+zZ9OgVsriaSahb5AYbnCZEfclaUZR0+llILL1zXCvHrDQbdTt5EuF1d9
         Ws/zkyppoz/wp1+6W9wHK9yOl7Se6FUU1HxZJYJEJo21de4LcdkMz7sDaX8iQRgS3s3s
         fY10VynAj7WeS1lZSdVYyCkqDXvojlmwrHQqYHEyOlX3GNB0G9p12eUBMXelB4aAg/5P
         JHbggaCo0mhn1QQgwP/bD3Ql7v4VdYORlj/UGn/qqiguUn2xYs6+vKaScxjxbcdk6WQf
         /pbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JhX2wxus5RbdcHbbl5XkDhw1vYd+kb0KjLnVSS0LP+k=;
        b=grqfync6+uk1R7S8wuEHCGLonqzKB6t8aYP5BapG/M+8BcQ+mQGDwzzWLwoWZh7GSD
         liqp5NrbciWMgJtHUusQclW4wW95HAw2XzbMUCwiEgRhGsQQQTYv7fcQxGb6NGB9j7L/
         iH7W8XyCXNPC/IeTV0LYvU7GJ67/uklWWqOaGlwFh+Zjyvd0qI7B+UTw86+lEcbEURMA
         49BWqn604pdD5aZk6LtKutIEH5kGcubD+3JjxYbsf3ozX7j1a1VM116AMHrr8WZhBplX
         XGFTNKSOgK9cryGyFDtpan1XivCQ4Cyi0PWi0x/4XAOtzi7t6klU1ZWs/z06a+tzyqJL
         M5CA==
X-Gm-Message-State: AOAM530Ep1Ki78B9Rts6fOtnZP2/D9Ni9i01aKXobW0e/urkmpNq/NEi
        XlzsX8gE8G4Gqx+rUgcnve+9mqOVL70=
X-Google-Smtp-Source: ABdhPJz7Ak3KAoI5SoMD81GHj9wKnJtO0ArbZefys2C5eUg4DhlMPZ+QJMTR+/AQa1JpVzUhVVgrKw==
X-Received: by 2002:a17:90a:4b84:: with SMTP id i4mr2793174pjh.132.1601964768319;
        Mon, 05 Oct 2020 23:12:48 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:47 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 08/10] net: pegasus: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:57 +0530
Message-Id: <20201006061159.292340-9-allen.lkml@gmail.com>
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
 drivers/net/usb/pegasus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 060a8a03e..8eb4af405 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -584,12 +584,12 @@ static void read_bulk_callback(struct urb *urb)
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
 
@@ -1160,7 +1160,7 @@ static int pegasus_probe(struct usb_interface *intf,
 		goto out1;
 	}
 
-	tasklet_init(&pegasus->rx_tl, rx_fixup, (unsigned long) pegasus);
+	tasklet_setup(&pegasus->rx_tl, rx_fixup);
 
 	INIT_DELAYED_WORK(&pegasus->carrier_check, check_carrier);
 
-- 
2.25.1

