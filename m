Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99373268618
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:33:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726023AbgINHd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgINHcZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:32:25 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FD7C06174A;
        Mon, 14 Sep 2020 00:32:24 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id l126so11878106pfd.5;
        Mon, 14 Sep 2020 00:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jwBSQkwxFDmuxnhyMb2b19ee2+rUfqniVLHpZYtKUdU=;
        b=CcnFiM+yywZ1hWJKc0oQLwb63YKZFFUEQ7k4r3aOiFjYEQxFvBXb3DH4xKX5HyU6Mo
         Kg/QvbkQclgjIBxT8yhzqbBt3I16v97MsmKYULWbr3/228COyZH1msIaq839WxwTI2Wz
         tehc9LHApHk9MWU+upofP/S2ocYaw+xA2EPqZ9/iaMBmIBMoPnaUVtNkMUDBJhR3ZZJO
         sWiJ2GcaO2E7zu1qVQQxPBKH8gm/QDonq3GvV2bOjfISyO2vQHODuBbvcq4O63n/1VJu
         jDDgsJZUghcIxXReZCINf9eC4JOfhMh5hjOWVoPtNbzV4esPeZj1fIlLXPK1Y3gCC9jI
         ztnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jwBSQkwxFDmuxnhyMb2b19ee2+rUfqniVLHpZYtKUdU=;
        b=X+7r3JnI10CT3Rg6DM/9MgzdZ/Aw0pI8MlfhuopxWkqyujXsa188P6lFLN4nyQOwf3
         r9GgcIN5Zs5woRoqTOR6yOeR3OtYhB6mUuozgiSmxveRtpvo6TyxsuWQSjXQ3YXOKCZc
         OFbk1SQ+g+w4vSYzIeaNL6u6OmpBjsJF46I6qerl+f5wLvmTk/eB2KrazHAt1GTkP3qg
         o+xPmowUobINU9mig7QzqejSfMtp2rWHYSDNpSXltk7ZaGbQRIF8WV7LqIPhJPIkTO4O
         R2Bb3EScNfav3MbjZcAowoln+xdLsap3oUfGF2fLd4y0izYZf36yIUqzfieQ5p81i+/l
         dVxA==
X-Gm-Message-State: AOAM532NGRlu10BkyCQfhiz8ETIds+wjIlpDCPs9SCcdh990SIBDkKBo
        7WmAPS9Dsm7NztuxQpGuTGk=
X-Google-Smtp-Source: ABdhPJzN+0NqSopntb5zrOiedCWU/1GO532NjylMRNFzb35Ce9i6VUKEm4RvEXZemKErD8wsLVd+lw==
X-Received: by 2002:a17:902:c253:: with SMTP id 19mr12931535plg.65.1600068744361;
        Mon, 14 Sep 2020 00:32:24 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id o1sm9128626pfg.83.2020.09.14.00.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:32:23 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-ppp@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [RESEND net-next v2 10/12] net: r8152: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 13:01:29 +0530
Message-Id: <20200914073131.803374-11-allen.lkml@gmail.com>
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
 drivers/net/usb/r8152.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index b1770489aca5..2d706cdbf9a2 100644
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

