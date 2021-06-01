Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECD8396A72
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 02:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhFAAxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 20:53:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231714AbhFAAxm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 20:53:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74A1F61263;
        Tue,  1 Jun 2021 00:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622508722;
        bh=QP6yKnzoGT0PCjP+hekaoYcOmX1Hc7jwPEsvbRqOPPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdtfAmfgkWKifFokiGoLBYW2/VFrZt7i66X0WQctXEiXPykBxPFcSfIJUdK44J23h
         1Et63P4yKjVaWhnhKtzP89mW+2G1Kakb9KOPdaIvCoZ88MCmKjTU64HhNTGfwDBjPP
         hMDBf+ADS+NPo/FYsqtx8J8lN5XiL/nBsHRWkOsj9sqBwIFr+P0ka5lIEHjzw68AVQ
         pOGJpbYGM3tWzkEyF1+gjN1dvJsSu29Tt7+N6/qECaAgSSRgnd+o/ERS1w+9WthyZY
         YQcaFnwQ6rwywcxwCjVkRQDabIt+DqDP1PLm9ce2BEA+iDqHG9hWvjJ7OGElFFLerf
         QXmxBq6w+PjLQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     linux-leds@vger.kernel.org
Cc:     netdev@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH leds v2 01/10] leds: trigger: netdev: don't explicitly zero kzalloced data
Date:   Tue,  1 Jun 2021 02:51:46 +0200
Message-Id: <20210601005155.27997-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210601005155.27997-1-kabel@kernel.org>
References: <20210601005155.27997-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trigger_data struct is allocated with kzalloc, so we do not need to
explicitly set members to zero.

Signed-off-by: Marek Behún <kabel@kernel.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/leds/trigger/ledtrig-netdev.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index d5e774d83021..4f6b73e3b491 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -406,12 +406,8 @@ static int netdev_trig_activate(struct led_classdev *led_cdev)
 	INIT_DELAYED_WORK(&trigger_data->work, netdev_trig_work);
 
 	trigger_data->led_cdev = led_cdev;
-	trigger_data->net_dev = NULL;
-	trigger_data->device_name[0] = 0;
 
-	trigger_data->mode = 0;
 	atomic_set(&trigger_data->interval, msecs_to_jiffies(50));
-	trigger_data->last_activity = 0;
 
 	led_set_trigger_data(led_cdev, trigger_data);
 
-- 
2.26.3

