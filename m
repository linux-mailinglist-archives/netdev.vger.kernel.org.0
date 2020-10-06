Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F199B2845DB
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbgJFGMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:53 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 566ADC0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:53 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x5so700087plo.6
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UMPpQ9MhQnwTKESiOifs7VirxYRe8QqZDvNFjPxNfCc=;
        b=Np0o5EiL4SptCTmvPTNuloCPef6mbyDXFXpNTBPdw4ZKCF2WEwXweC1Q3Br5rZqNTB
         b0e9ROtXIdcbP9vA/g5F9OllVp8jHH0iR8NyKfRCPBmfrpoQ2u20NyD1HS5nQqd6ZVn0
         +/7On01l4nWTFrslFAHh33oo/tbcNpYZ/rj9jx4QccCTaYLnWX9AV2dMBAflkMeU/jAE
         KuyEci8TckMP7l4i+CLoWy8aIlsmunWAaWtn1MkIqUAb1Uxv2bIG6YqGumgcZ+Pp+GTQ
         Gd8n9JtMFMJuEFv0hZNuZOOR/mL8yfH83+vFDonzaHWao7rwVQ42xcMQ5+aOXOmnSt+R
         WxIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UMPpQ9MhQnwTKESiOifs7VirxYRe8QqZDvNFjPxNfCc=;
        b=Ls2c4MzLOFS5/pMR5r7aUfs39u9WywPyIGPx08++VAzHLqiMXk6i5lqP+N3GRYVUjz
         +8XuU1uWkSys8qHljFcPBO0M+tdqHto2ZKDvfWHX8kR3xlLqbIkhKLJi4gzeumznFUJD
         WgTktXqCOTbx8E2zwxnABUZbpcphzvuJDEyWAAzLufAbjnRECQnaojA3PN5PR9SvfGH9
         MJ7BaoPUOVNAamcTX69pRlLnsGKFRqO+rR2ZF1rHVEI2gLflv++aruk7Ro8Em0L8Du0b
         0gt4H1GJUISbyRNUUPxWGQ+Xz5Q6KpBkh3OLzsYF5dtTAjGK4SyXLiY3ozcULZ23YJ2j
         gXzQ==
X-Gm-Message-State: AOAM532KZRGHSRpWOwJEFflXtTYbAuopaN6g/B8adpH6NkTcoDTyqnHz
        4S8SaaVt8GKKbAjRm9VSa6J/cXddeSY=
X-Google-Smtp-Source: ABdhPJxFeuL/6JdgRphp2QChYb/kx2avOX/19jrcjnY1SRJMqaUbqQQs4HpereFw6IPtkw2qpJASVQ==
X-Received: by 2002:a17:902:d90e:b029:d2:8cba:8f02 with SMTP id c14-20020a170902d90eb02900d28cba8f02mr1839923plz.38.1601964772941;
        Mon, 05 Oct 2020 23:12:52 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:52 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 09/10] net: r8152: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:58 +0530
Message-Id: <20201006061159.292340-10-allen.lkml@gmail.com>
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
 drivers/net/usb/r8152.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b1770489a..2d706cdbf 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2410,11 +2410,9 @@ static void tx_bottom(struct r8152 *tp)
 	} while (res == 0);
 }
 
-static void bottom_half(unsigned long data)
+static void bottom_half(struct tasklet_struct *t)
 {
-	struct r8152 *tp;
-
-	tp = (struct r8152 *)data;
+	struct r8152 *tp = from_tasklet(tp, t, tx_tl);
 
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
@@ -6730,7 +6728,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 	mutex_init(&tp->control);
 	INIT_DELAYED_WORK(&tp->schedule, rtl_work_func_t);
 	INIT_DELAYED_WORK(&tp->hw_phy_work, rtl_hw_phy_work_func_t);
-	tasklet_init(&tp->tx_tl, bottom_half, (unsigned long)tp);
+	tasklet_setup(&tp->tx_tl, bottom_half);
 	tasklet_disable(&tp->tx_tl);
 
 	netdev->netdev_ops = &rtl8152_netdev_ops;
-- 
2.25.1

