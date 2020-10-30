Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2512A048F
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 12:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgJ3Loo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 07:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725808AbgJ3Lon (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 07:44:43 -0400
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 177C520825;
        Fri, 30 Oct 2020 11:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604058283;
        bh=Rxcr44275WfEO6LixBmu4tWy5vMLxwk+wEItVg0bGa0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpH/kfP0AiQaq6CY1ZbynzvoTgMFd8xW+BTBpU+ulO5Wfb6vTKLUx74AtZg9dl1Q8
         ZMPU/XL/Ih69p+oNOSjmkartlpCov/BVyzVjQ1w4LcWbEC8gle0cThnnsfT9lY7YnL
         5qsRKev4QCpP1BmpAeeFzjuGMRaOKIN+UjluvKE4=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacek Anaszewski <jacek.anaszewski@gmail.com>,
        Ben Whitten <ben.whitten@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH RFC leds + net-next 1/7] leds: trigger: netdev: don't explicitly zero kzalloced data
Date:   Fri, 30 Oct 2020 12:44:29 +0100
Message-Id: <20201030114435.20169-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201030114435.20169-1-kabel@kernel.org>
References: <20201030114435.20169-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trigger_data struct is allocated with kzalloc, so we do not need to
explicitly set members to zero.

Signed-off-by: Marek Behún <kabel@kernel.org>
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
2.26.2

