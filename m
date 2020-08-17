Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47612460F9
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgHQIr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgHQIrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:47:16 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31AC0C061388;
        Mon, 17 Aug 2020 01:47:16 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ha11so7371972pjb.1;
        Mon, 17 Aug 2020 01:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G7+u9RfZ4cl+64Cr26dXMpMV5ktm179POSFJ+AOkz/Q=;
        b=jftKsQXgGWi+FXPt2ZFyTlOr/cV1PKn+tzd5IfZZMh4uzm+Ue8Sk0F7PhmrjjcVyRY
         TO7rzQtZpCeh1ktPtQfozgKTuYBkBNaMVRmc/LIIUhIvVUHWm9aKvUH9ilKtYzNElzmz
         35CxpuPkYEYJ1X3bhuQFMwV848JxRewOBzE7rIrGm+QX+LX8tE/mw+FQRWWLq+aH+71K
         W9felpyi6a5pbZp6drnIf2o6hTyc07hyy62NehLoyJ+gz3bXMs6DYt6UskuvSCTIYaLB
         88WjqS07quZv5j396wnYOrlVy5pgB9xNsdxNTVN4U8GYfu8TvbeiJU5dVQkfqUDMq99o
         U/8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=G7+u9RfZ4cl+64Cr26dXMpMV5ktm179POSFJ+AOkz/Q=;
        b=GljOpYHIhHtP9X93lDIiLi8vnkhRwwNSwYIU/Q6+4ZtZAnEBwZ3ArM396lYcirxTGe
         FQaK9LkuPzsZf9+q4zUWonWkjzOQFT59/qsZKQqgkUmQpSfZy6VeAjMzaeUazE5u1YJJ
         Sl6cPibDvFKrTUhFh/6UcPE17FvAB5FJUAHiMsOXAB9zt31f96qY1YsqQGqO6H4wYLde
         XaQd5nvstT7tVEmZ9jvTXN3vVF8Zm9/7MsQpX8AuGpZZwjQmyydtGHRVOLaPL5uJHeJ6
         sFdzuZLDatTnjebKEPqAWy62rEp2GrX7VTa6G03rMM0erPNTxumK2mvhEk1US5zsC6WW
         mNCQ==
X-Gm-Message-State: AOAM533cZSOWIFX9gmN5FDYhSzMo8dPanPNnAR1J0B5yZuH/MaUMKoXK
        V4wTYUmo8ieovbLSbFNgOEI=
X-Google-Smtp-Source: ABdhPJw4yTuPYPMatgAtLiBNdEo2nN33/HZB5EU+ZwyiWp3/aY9wrAnaojEc7+5dloID/iAO9+KVtw==
X-Received: by 2002:a17:902:8608:: with SMTP id f8mr852652plo.66.1597654035752;
        Mon, 17 Aug 2020 01:47:15 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id ml18sm16418443pjb.43.2020.08.17.01.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:47:15 -0700 (PDT)
From:   Allen Pais <allen.cryptic@gmail.com>
To:     m.grzeschik@pengutronix.de, davem@davemloft.net, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com, petkan@nucleusys.com
Cc:     keescook@chromium.org, netdev@vger.kernel.org,
        linux-ppp@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 7/9] net: r8152: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 14:16:12 +0530
Message-Id: <20200817084614.24263-11-allen.cryptic@gmail.com>
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
 drivers/net/usb/r8152.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 2b02fefd094d..6805686abfe7 100644
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
2.17.1

