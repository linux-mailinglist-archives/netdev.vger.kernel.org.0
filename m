Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A927A2EC7B2
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 02:26:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbhAGBZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 20:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726297AbhAGBZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 20:25:55 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A88C0612F1
        for <netdev@vger.kernel.org>; Wed,  6 Jan 2021 17:25:15 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y24so6139609edt.10
        for <netdev@vger.kernel.org>; Wed, 06 Jan 2021 17:25:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J5314oOLBwOSaPqs3GfHrm1zBklYsaL3mcAsr73qJYY=;
        b=mCetRwcFj9CuD/PaI1tSEH2mAATl4zyWm9TKhatwacGUvvIbywqnOOUF7pPTZtyYCF
         vRwTaYcxjhlCK+7DbfKjXVA1S1gqx2TqOlBGBdKHP7Ar9ofU5ZvdoadhRkRQTeqnB0lw
         oPlFD6mFgh/qu9Qw94WQ8t5LWShnxt6w4hRLZ0zcKIFb6+EO4cKFt6JmBKImjo73Sttu
         lMaFjxJi4O8KepHV5Iy6hhn2ghg/+MHBIf1iVB8AlLw/QKM7Rk/J36wOLtk9TZvcODq6
         57wD1r0A+o05bX4EtoYczLdLMy8Fo3KAy8IWaVMn8mEq72uMW5cscQ7w/64a+DAvdEcU
         Qdpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J5314oOLBwOSaPqs3GfHrm1zBklYsaL3mcAsr73qJYY=;
        b=WibTl+gDaHvGZw/IhYIvK2y8LfPiBCeI4sd+XuOARv1vb4RpljzcuP3K0zOzeTm572
         ZHGgKTmiAlSosM3zLwAuQk8QOnEMEVjpC1EGwKMohSDBOUH8ynwGRbA7IDztBp+xQGbF
         iuE40Xr1xUW6FIWj/CWPt17fR5WwJfbXZMIoKu+Y9aPyCKjR/MhrzVdlw9dMypiptS2U
         FO63FPQ6C65lU/+bUziwV+f4U8Lno6MVN8p1j7DAxwoGZedh0Xb8l0r39SJFT/hKgGMY
         ejjdTIJ5sryOa2VLnebtE7wJSG3Skm2pA8TGX8tD0usXd1YKl1CDk4wza53RnEMkIfzq
         9ztw==
X-Gm-Message-State: AOAM533UnrK2F0y1JCt0b/eda6FxF194UgHH7SYfMMZlaBdEvwtdnHSm
        L7bk84yKDfOg/1tm815PJ2+LKKw/2NSLKw==
X-Google-Smtp-Source: ABdhPJxCiJMEmv2u78EZefGwnEGLOoN5P/Nx6pOs7J35gu2dc7j+PajEHt1QCzTfjqnhjscYu2sfaw==
X-Received: by 2002:a50:d646:: with SMTP id c6mr5708437edj.177.1609982713815;
        Wed, 06 Jan 2021 17:25:13 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id a6sm2041858edv.74.2021.01.06.17.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 17:25:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH v2 net-next 2/4] net: dsa: export dsa_slave_dev_check
Date:   Thu,  7 Jan 2021 03:24:01 +0200
Message-Id: <20210107012403.1521114-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210107012403.1521114-1-olteanv@gmail.com>
References: <20210107012403.1521114-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Using the NETDEV_CHANGEUPPER notifications, drivers can be aware when
they are enslaved to e.g. a bridge by calling netif_is_bridge_master().

Export this helper from DSA to get the equivalent functionality of
determining whether the upper interface of a CHANGEUPPER notifier is a
DSA switch interface or not.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v2:
None.

 include/net/dsa.h  | 6 ++++++
 net/dsa/dsa_priv.h | 1 -
 net/dsa/slave.c    | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index af9a4f9ee764..5badfd6403c5 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -855,6 +855,7 @@ int register_dsa_notifier(struct notifier_block *nb);
 int unregister_dsa_notifier(struct notifier_block *nb);
 int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 		       struct dsa_notifier_info *info);
+bool dsa_slave_dev_check(const struct net_device *dev);
 #else
 static inline int register_dsa_notifier(struct notifier_block *nb)
 {
@@ -871,6 +872,11 @@ static inline int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 {
 	return NOTIFY_DONE;
 }
+
+static inline bool dsa_slave_dev_check(const struct net_device *dev)
+{
+	return false;
+}
 #endif
 
 netdev_tx_t dsa_enqueue_skb(struct sk_buff *skb, struct net_device *dev);
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 7c96aae9062c..33c082f10bb9 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -172,7 +172,6 @@ extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
 void dsa_slave_destroy(struct net_device *slave_dev);
-bool dsa_slave_dev_check(const struct net_device *dev);
 int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 4a0498bf6c65..c01bc7ebeb14 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1924,6 +1924,7 @@ bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &dsa_slave_netdev_ops;
 }
+EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
 
 static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
-- 
2.25.1

