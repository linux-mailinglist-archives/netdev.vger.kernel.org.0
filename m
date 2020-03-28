Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74387196357
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727126AbgC1DO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:14:57 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:32886 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgC1DO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 23:14:57 -0400
Received: by mail-pl1-f193.google.com with SMTP id g18so4238721plq.0
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 20:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o0QSa2vxWNEuyBrBvwlcOlK3qCDOoYzKYXOOb+XCgTc=;
        b=HbPIp1LkXKFK2fYJ5jICW0OzW7jZW7b0Byp8T1ueguH7Fy4aCpAugZz3VapWJwOJR9
         KEZEhkF132j8+cq946cL12ywVus0VI/A4Mgn33LNpCM1zu9lMND5uOvkGLE+6Y3SNCUB
         xmx4T5tERbLEJNZXyq1+xK90/iL24DOPiJEOiVO2POIGbnJndfo7FKLG6nj/ZJzfym0q
         nLpqNrSI+33XnHSUfb+yvhTxcoT4kK7dKErS/U3WH3Ytx1Kn2jubNH9VxGVUUAsp2j09
         4GzCml2/v2p/TxcsXc46/cJXNk0ytumSxE49iHWAyT0MqWk60ahMIH8fVCGbFAdjeawi
         eo9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o0QSa2vxWNEuyBrBvwlcOlK3qCDOoYzKYXOOb+XCgTc=;
        b=GBRQswDVh91FPksFDBTQ4B4weR9YI/9BkXPyhG0s71Va21YvPmdgB7k4XUiVMXpBOm
         UQ4KKya2CZmqSxnnX0DGK3z8quk+0te2EX9LOaVQmzaYbNHKtOBbyqWlEfP9ssbsT/I5
         Z5TEy6ivZEJVSl637ZH4Ni6DDj9kerhCv1gilRUaUd4QMwCu9s1L+JY4ECzmS37bSENW
         zV3agOl1Zku5YkOkzznG/PunyjJjvW9vmD+2ec8dIpk46cG9nAeVhjT1QFxDGag227r4
         4wf8zkWUiPG30MrcC6itnSCgpA/pVttqwF/m5HEK/fMHaKNTz07n3Mh6WChV7HHKeUz9
         Zv9w==
X-Gm-Message-State: ANhLgQ0rdFXGb53XLg8b1iJ3X1hjf/NSXMPNtBGuZlcfnxadHXpQWvvj
        b9vwshmOZIwibQcu8etK+yezXQ==
X-Google-Smtp-Source: ADFU+vt0ctckd3zmpvHNlRKnXkAc1ui8icahdrLmKz74v9B00zD92tDxsRSa07Fx5cRnW83AkDHFwg==
X-Received: by 2002:a17:902:8d85:: with SMTP id v5mr2190638plo.146.1585365296147;
        Fri, 27 Mar 2020 20:14:56 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id o65sm5208391pfg.187.2020.03.27.20.14.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 27 Mar 2020 20:14:55 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v2 net-next 2/8] ionic: check for linkup in watchdog
Date:   Fri, 27 Mar 2020 20:14:42 -0700
Message-Id: <20200328031448.50794-3-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200328031448.50794-1-snelson@pensando.io>
References: <20200328031448.50794-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a link_status_check to the heartbeat watchdog.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c | 6 +++++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 2 +-
 drivers/net/ethernet/pensando/ionic/ionic_lif.h | 1 +
 3 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 46107de5e6c3..f03a092f370f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -14,11 +14,15 @@
 static void ionic_watchdog_cb(struct timer_list *t)
 {
 	struct ionic *ionic = from_timer(ionic, t, watchdog_timer);
+	int hb;
 
 	mod_timer(&ionic->watchdog_timer,
 		  round_jiffies(jiffies + ionic->watchdog_period));
 
-	ionic_heartbeat_check(ionic);
+	hb = ionic_heartbeat_check(ionic);
+
+	if (hb >= 0 && ionic->master_lif)
+		ionic_link_status_check_request(ionic->master_lif);
 }
 
 void ionic_init_devinfo(struct ionic *ionic)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 3e9c0e9bcad2..ddbff44cda89 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -105,7 +105,7 @@ static void ionic_link_status_check(struct ionic_lif *lif)
 	clear_bit(IONIC_LIF_F_LINK_CHECK_REQUESTED, lif->state);
 }
 
-static void ionic_link_status_check_request(struct ionic_lif *lif)
+void ionic_link_status_check_request(struct ionic_lif *lif)
 {
 	struct ionic_deferred_work *work;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 7c0c6fef8c0b..8aaa7daf3842 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -224,6 +224,7 @@ static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
 	return (units * div) / mult;
 }
 
+void ionic_link_status_check_request(struct ionic_lif *lif);
 int ionic_lifs_alloc(struct ionic *ionic);
 void ionic_lifs_free(struct ionic *ionic);
 void ionic_lifs_deinit(struct ionic *ionic);
-- 
2.17.1

