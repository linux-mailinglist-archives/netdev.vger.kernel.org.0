Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EAB01805B2
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 18:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgCJR7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 13:59:43 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:43292 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJR7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 13:59:43 -0400
Received: by mail-yw1-f65.google.com with SMTP id p69so14467694ywh.10;
        Tue, 10 Mar 2020 10:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5XXpJ4ZxMNGZ3MVXM7l+KVCnncYkpt5mf2ustLE6DdY=;
        b=nINPOu/Sja5C8M/v8YKrkjV95bUiVvaqQOqKU67QZMBfWEvfpjqXvchaZHqJyeSiM2
         dAiCp656j3wJhK6aW5lB428xlyRacJw/qgjGIOII8K52FiJYh8WPS91HjC2hLYsGDVqg
         Cw16NJH/7wAgX+uX65w4TCwHUg2P+C+hFgIqKidAY4oGFP5gyBofcRMOYFfyFwjan9G9
         fFN9ep/Sj4msDIg1Q6HTkxuerbHafgIgRY2l1ToBSurvsbwMMKUn1C52+uTKcvzS5iUZ
         dSkVIWDCF72oa/YDRXEhWrOrQoM4aOp21cJv9nYmYsZDBymHlgn8TKsiUGULnn+oVeWS
         gpLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5XXpJ4ZxMNGZ3MVXM7l+KVCnncYkpt5mf2ustLE6DdY=;
        b=lv8SeFnglV1VjJqGQ8+ksR0rAHslisDP13qbgDYPkq6fxySK+FhTOGKZbqw4A3ZHU3
         FxowrVElMuZB8Zrv9EtXonQMyCObDSFett7P25qj3wMCOp40lTOJDnlKklDHSW+0NsVF
         EzqHjN1A2Slu28AfEbG9tMOnW0XLvIX8xO+DOHuKq9qnxvowucbvC2qMlCYwpfJfUkUL
         6XgDsg1fboxX2ZMILkGh/F/wG+eFhLhNy0hy/GIpMvTFocU/eYEYzIOw8hrk3qjvxng0
         PjNebLKwn2gpELg/XkZZ3KwwTAuNcfrU0F5K/uQjwSbIZecR7JQIqqCLzLohCwkdx1T/
         8BkQ==
X-Gm-Message-State: ANhLgQ3/ChzcOShQsiCW7MNG9wdhXQrhQ93PYwlZsNRsMFiACjK3l+VY
        g068GgeUbOl3paGyBbphodMFbHox9w==
X-Google-Smtp-Source: ADFU+vuvJt6P35wAIIszjBT1hM9wxlx3itdQojljMIZ4Tr3vPuYUPTveAXrpZe2627v2SqhJl7/xbQ==
X-Received: by 2002:a25:6b4b:: with SMTP id o11mr25428867ybm.257.1583863179742;
        Tue, 10 Mar 2020 10:59:39 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id a12sm17153101ywm.0.2020.03.10.10.59.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Mar 2020 10:59:39 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marek Vasut <marex@denx.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next] net: dsa: microchip: use delayed_work instead of timer + work
Date:   Tue, 10 Mar 2020 12:58:59 -0500
Message-Id: <20200310175859.118105-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify ksz_common.c by using delayed_work instead of a combination of
timer and work.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/microchip/ksz_common.c | 26 ++++++++------------------
 drivers/net/dsa/microchip/ksz_common.h |  3 +--
 2 files changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz_common.c b/drivers/net/dsa/microchip/ksz_common.c
index d8fda4a02640..fd1d6676ae4f 100644
--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -67,7 +67,7 @@ static void port_r_cnt(struct ksz_device *dev, int port)
 static void ksz_mib_read_work(struct work_struct *work)
 {
 	struct ksz_device *dev = container_of(work, struct ksz_device,
-					      mib_read);
+					      mib_read.work);
 	struct ksz_port_mib *mib;
 	struct ksz_port *p;
 	int i;
@@ -93,32 +93,24 @@ static void ksz_mib_read_work(struct work_struct *work)
 		p->read = false;
 		mutex_unlock(&mib->cnt_mutex);
 	}
-}
-
-static void mib_monitor(struct timer_list *t)
-{
-	struct ksz_device *dev = from_timer(dev, t, mib_read_timer);
 
-	mod_timer(&dev->mib_read_timer, jiffies + dev->mib_read_interval);
-	schedule_work(&dev->mib_read);
+	schedule_delayed_work(&dev->mib_read, dev->mib_read_interval);
 }
 
 void ksz_init_mib_timer(struct ksz_device *dev)
 {
 	int i;
 
+	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
+
 	/* Read MIB counters every 30 seconds to avoid overflow. */
 	dev->mib_read_interval = msecs_to_jiffies(30000);
 
-	INIT_WORK(&dev->mib_read, ksz_mib_read_work);
-	timer_setup(&dev->mib_read_timer, mib_monitor, 0);
-
 	for (i = 0; i < dev->mib_port_cnt; i++)
 		dev->dev_ops->port_init_cnt(dev, i);
 
 	/* Start the timer 2 seconds later. */
-	dev->mib_read_timer.expires = jiffies + msecs_to_jiffies(2000);
-	add_timer(&dev->mib_read_timer);
+	schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
@@ -152,7 +144,7 @@ void ksz_adjust_link(struct dsa_switch *ds, int port,
 	/* Read all MIB counters when the link is going down. */
 	if (!phydev->link) {
 		p->read = true;
-		schedule_work(&dev->mib_read);
+		schedule_delayed_work(&dev->mib_read, 0);
 	}
 	mutex_lock(&dev->dev_mutex);
 	if (!phydev->link)
@@ -477,10 +469,8 @@ EXPORT_SYMBOL(ksz_switch_register);
 void ksz_switch_remove(struct ksz_device *dev)
 {
 	/* timer started */
-	if (dev->mib_read_timer.expires) {
-		del_timer_sync(&dev->mib_read_timer);
-		flush_work(&dev->mib_read);
-	}
+	if (dev->mib_read_interval)
+		cancel_delayed_work_sync(&dev->mib_read);
 
 	dev->dev_ops->exit(dev);
 	dsa_unregister_switch(dev->ds);
diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
index a20ebb749377..f2c9bb68fd33 100644
--- a/drivers/net/dsa/microchip/ksz_common.h
+++ b/drivers/net/dsa/microchip/ksz_common.h
@@ -80,8 +80,7 @@ struct ksz_device {
 	struct vlan_table *vlan_cache;
 
 	struct ksz_port *ports;
-	struct timer_list mib_read_timer;
-	struct work_struct mib_read;
+	struct delayed_work mib_read;
 	unsigned long mib_read_interval;
 	u16 br_member;
 	u16 member;
-- 
2.11.0

