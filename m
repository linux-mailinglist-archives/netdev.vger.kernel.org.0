Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BAD391E98
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 20:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbhEZSDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 14:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234792AbhEZSDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 14:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95545613DC;
        Wed, 26 May 2021 18:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622052093;
        bh=FvskSE+fiFOQO8upGh0hC4EfFft4hH1AbDZuqNNLT6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BX5lqq03/LuGedtbncYguYb4pdwrd2KwsA7mh8dJZ8yzkSGuzALlpebvHj9agcHLx
         NToEKPx2PicX/5utl9QekpgjHsEKubLhemoQX4aCGh/56YX7BSBpbP5ufPmycWr6Wl
         tLhinSCLAqpGz5Nma8lSvksHObSIuuUVDCgEZeewvTsl8H1cD9n870Xcrwk86QbuVr
         moGurAjBjVkLZSEhBj2z0a260afZYfz+1jtcH8zV7djPJGSsMw3UvwiHMwZKVLgwaz
         cPXmbTKLbI4Iwt9WICuuUFcbO7f7PBdlb8KnExlUOjhJkJfvJkFqZvUyLnSIa9o8U1
         4kO3YnaWCKdVw==
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
Subject: [PATCH leds v1 1/5] leds: trigger: netdev: don't explicitly zero kzalloced data
Date:   Wed, 26 May 2021 20:00:16 +0200
Message-Id: <20210526180020.13557-2-kabel@kernel.org>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210526180020.13557-1-kabel@kernel.org>
References: <20210526180020.13557-1-kabel@kernel.org>
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

