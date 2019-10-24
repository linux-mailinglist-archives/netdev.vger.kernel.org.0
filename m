Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597D5E2781
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 02:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407834AbfJXAtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 20:49:21 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:44720 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407738AbfJXAtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 20:49:20 -0400
Received: by mail-pg1-f195.google.com with SMTP id e10so13127469pgd.11
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 17:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Yuw7YcwH8Dw2tAhvZv+UyUY+2BInkM5t58oJhGkHldI=;
        b=QtHcLQhsyAmSvP+1BRiUTnTYCYF7bnKi2ARqpGN+sqP40bizGeuODnZzhaBuJGL7og
         DUn1JZL8Kkdx5O/UjYgNQB6Adf7bIUxktBQgaoWV3Nk6O8oav5zLuTZGcNrhlWmI6EWl
         lEgUPd3kEkPsaDfOjIndjwyF0HwxpvOmXbaEGGpjniOG4zV671GKRjd2wUp6hQg0SljN
         l60Xn6lfG+5MxpoztFy51k6o8gEIp8gRnRwTKQdJRKP7UxU7nMCCoL+zDkYXQmOrq9KT
         i2t80UTRkjKlVo71z5mXaHomlGtZ89YlE+UvQ3W3Aijj48YravyfAlEWDUQFWQjYkjum
         vjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Yuw7YcwH8Dw2tAhvZv+UyUY+2BInkM5t58oJhGkHldI=;
        b=GGz62uPDBrRtrPNN4iLvYZATBBkZzmwQtbKBpZKjBWgIz1YgldqtM5GTBNzKlCekv7
         t/WWzpeZwvbSMBT+sBxy8v+XRwMMK+KUt6pZboSuilomkGAApbkYrgEhKwjfpPZiVP1g
         kR7b9CqLBqiuqli6jgdvDZendKFgtso7PvpCMw0DGtb209/ZUn9RwShjRQEPhQzDZOcL
         h8wA5WIBoKUrhAaXbtFP316NTYviXJJYzHYJmV8pTqbgug19ionnOm94uhaNEe0XgetV
         SO9ghZtxy0eI1oQYQcZXyZqoP8lzybfb6RyBiQbkjEaX0jB62/MksB3Tq/ymYvRpu5Lx
         HgCQ==
X-Gm-Message-State: APjAAAUINF05PLlNNTjPsZ9jzFGSyYfBZQ3TNPfeQlagLQNmXvQ7DRWF
        yeleDeh0VO1axkmYDpW1Vqfvd3EREb4w0A==
X-Google-Smtp-Source: APXvYqwvyNkxSz+qtl+k6F65WjwAePVaDrgOroZ17ch+DxnXWXMt5z9ye8bOWejcmbfhxeE3sDn/Nw==
X-Received: by 2002:a65:67d9:: with SMTP id b25mr6986174pgs.88.1571878159167;
        Wed, 23 Oct 2019 17:49:19 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.1.37.26])
        by smtp.gmail.com with ESMTPSA id b3sm24696440pfd.125.2019.10.23.17.49.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2019 17:49:18 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 4/6] ionic: add a watchdog timer to monitor heartbeat
Date:   Wed, 23 Oct 2019 17:48:58 -0700
Message-Id: <20191024004900.6561-5-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024004900.6561-1-snelson@pensando.io>
References: <20191024004900.6561-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a watchdog to periodically monitor the NIC heartbeat.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic.h   |  2 ++
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 19 +++++++++++++++++--
 .../net/ethernet/pensando/ionic/ionic_dev.h   |  1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic.h b/drivers/net/ethernet/pensando/ionic/ionic.h
index 7a7060677f15..5b013250f8c3 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic.h
@@ -46,6 +46,8 @@ struct ionic {
 	DECLARE_BITMAP(intrs, IONIC_INTR_CTRL_REGS_MAX);
 	struct work_struct nb_work;
 	struct notifier_block nb;
+	struct timer_list watchdog_timer;
+	int watchdog_period;
 };
 
 struct ionic_admin_ctx {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 544a9f799afc..5f9d2ec70446 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -11,6 +11,16 @@
 #include "ionic_dev.h"
 #include "ionic_lif.h"
 
+static void ionic_watchdog_cb(struct timer_list *t)
+{
+	struct ionic *ionic = from_timer(ionic, t, watchdog_timer);
+
+	mod_timer(&ionic->watchdog_timer,
+		  round_jiffies(jiffies + ionic->watchdog_period));
+
+	ionic_heartbeat_check(ionic);
+}
+
 void ionic_init_devinfo(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
@@ -72,6 +82,11 @@ int ionic_dev_setup(struct ionic *ionic)
 		return -EFAULT;
 	}
 
+	timer_setup(&ionic->watchdog_timer, ionic_watchdog_cb, 0);
+	ionic->watchdog_period = IONIC_WATCHDOG_SECS * HZ;
+	mod_timer(&ionic->watchdog_timer,
+		  round_jiffies(jiffies + ionic->watchdog_period));
+
 	idev->db_pages = bar->vaddr;
 	idev->phy_db_pages = bar->bus_addr;
 
@@ -80,7 +95,7 @@ int ionic_dev_setup(struct ionic *ionic)
 
 void ionic_dev_teardown(struct ionic *ionic)
 {
-	/* place holder */
+	del_timer_sync(&ionic->watchdog_timer);
 }
 
 /* Devcmd Interface */
@@ -93,7 +108,7 @@ int ionic_heartbeat_check(struct ionic *ionic)
 
 	/* wait a little more than one second before testing again */
 	hb_time = jiffies;
-	if (time_before(hb_time, (idev->last_hb_time + (HZ * 2))))
+	if (time_before(hb_time, (idev->last_hb_time + ionic->watchdog_period)))
 		return 0;
 
 	/* firmware is useful only if fw_status is non-zero */
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 1ffb3e4dec5d..78691c1ba20b 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -16,6 +16,7 @@
 #define IONIC_MIN_TXRX_DESC		16
 #define IONIC_DEF_TXRX_DESC		4096
 #define IONIC_LIFS_MAX			1024
+#define IONIC_WATCHDOG_SECS		5
 #define IONIC_ITR_COAL_USEC_DEFAULT	64
 
 #define IONIC_DEV_CMD_REG_VERSION	1
-- 
2.17.1

