Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236E91BB37D
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 03:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgD1Bjc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 21:39:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726233AbgD1Bjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 21:39:31 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26C3C03C1A8
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:39:30 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so994808wmc.5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 18:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FNwQnh9HK2QI880PfDB10dgka+yTFCMJycK++RfJjnU=;
        b=L/maPzT54PWA7xdYb1gEt0aFcXN0hd+u1nyU7YjtBXhtcWH5/u05oMBnz+L7JLwPBQ
         pn0Q1zNFU4okm0fRyB7xaZdS2tJ3FFjSIdmojpTTggdwFer5Szh4gkUwMSAndANXp6yV
         y/trblM+48LBPHf9/xbIg2q0KpJ9w1fAEwktJz+eC4fOm5IOgdV9xeqlVVx9bGkBe0VO
         nBNRsVKxpI135/ZdgRIKRFNW2g8O38Qwcw9Uz4Ymf7GZiofhChP6VzLzOfh0rJjllaCZ
         vDVgkqEpwdtouvek5CxDus3zmSsDZiokgs6Nf5apITVH61TDQwaKaSYIvZurHkVEWNom
         i5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FNwQnh9HK2QI880PfDB10dgka+yTFCMJycK++RfJjnU=;
        b=Q1LojAu5EKaETP3hRFRrB/kNmAKDhb+xHM72X61ESUjO0WOx2QM+DRsIS/4NR1/Raa
         VcgC7XuYNAr04CWP9oOZ2PwcxomU3LcUW1NAdlDKjwsIfY3MO0FGYO2zK4u4tOhP1Feg
         rlEzJemNS1TfvJA+2L9eAO0sb7xtjCqBVINS0lP5PaOrIMYQR+M+NBQkVPDzzUtliq6B
         I4FiQJJnTLlqj3rQG48TGLy3Fv7eYaJRCImJlc/DWoTd/bbvy0MXfLqKR5AgdmUmqvFS
         aH1odquGDr27Vd4CnNX66kpufpXOigbbsBbX9oSfZKo61G/bz+G2x4KFWkbpsk40xFWH
         GqDA==
X-Gm-Message-State: AGi0Pubd/EyEu5egZWpY8gPiIXT3IftCyzqlA0wROlmZUdQf26eeWyeK
        i4pBhHTNwMFR0xjfUc5q2YQ6tF2Z
X-Google-Smtp-Source: APiQypIwO/iOgeCKsA9nqsj7FfRmsPmXNKFC1gbEzexZGOY4DQdgHT8K+bPXOTSgZNBdKlwIn1KG/w==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr1774364wmi.155.1588037969459;
        Mon, 27 Apr 2020 18:39:29 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id u188sm1235348wmg.37.2020.04.27.18.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 18:39:29 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, vlad@buslov.dev, jiri@mellanox.com,
        idosch@mellanox.com, kuba@kernel.org
Subject: [RFC PATCH 1/5] net: dsa: export dsa_slave_dev_check and dsa_slave_to_port
Date:   Tue, 28 Apr 2020 04:39:02 +0300
Message-Id: <20200428013906.19904-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428013906.19904-1-olteanv@gmail.com>
References: <20200428013906.19904-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

To be able to perform mirroring and redirection through tc-flower
offloads (the implementation of which is given raw access to the
flow_cls_offload structure), switch drivers need to be able to call
these functions on act->dev.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h  | 2 ++
 net/dsa/dsa_priv.h | 8 --------
 net/dsa/slave.c    | 9 +++++++++
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fb3f9222f2a1..62beaa4c234e 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -739,6 +739,8 @@ int dsa_port_get_phy_strings(struct dsa_port *dp, uint8_t *data);
 int dsa_port_get_ethtool_phy_stats(struct dsa_port *dp, uint64_t *data);
 int dsa_port_get_phy_sset_count(struct dsa_port *dp);
 void dsa_port_phylink_mac_change(struct dsa_switch *ds, int port, bool up);
+bool dsa_slave_dev_check(const struct net_device *dev);
+struct dsa_port *dsa_slave_to_port(const struct net_device *dev);
 
 struct dsa_tag_driver {
 	const struct dsa_device_ops *ops;
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 6d9a1ef65fa0..32bf570fd71c 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -173,19 +173,11 @@ extern const struct dsa_device_ops notag_netdev_ops;
 void dsa_slave_mii_bus_init(struct dsa_switch *ds);
 int dsa_slave_create(struct dsa_port *dp);
 void dsa_slave_destroy(struct net_device *slave_dev);
-bool dsa_slave_dev_check(const struct net_device *dev);
 int dsa_slave_suspend(struct net_device *slave_dev);
 int dsa_slave_resume(struct net_device *slave_dev);
 int dsa_slave_register_notifier(void);
 void dsa_slave_unregister_notifier(void);
 
-static inline struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
-{
-	struct dsa_slave_priv *p = netdev_priv(dev);
-
-	return p->dp;
-}
-
 static inline struct net_device *
 dsa_slave_to_master(const struct net_device *dev)
 {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index ba8bf90dc0cc..4eeb5b47ef99 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -62,6 +62,14 @@ static int dsa_slave_get_iflink(const struct net_device *dev)
 	return dsa_slave_to_master(dev)->ifindex;
 }
 
+struct dsa_port *dsa_slave_to_port(const struct net_device *dev)
+{
+	struct dsa_slave_priv *p = netdev_priv(dev);
+
+	return p->dp;
+}
+EXPORT_SYMBOL_GPL(dsa_slave_to_port);
+
 static int dsa_slave_open(struct net_device *dev)
 {
 	struct net_device *master = dsa_slave_to_master(dev);
@@ -1836,6 +1844,7 @@ bool dsa_slave_dev_check(const struct net_device *dev)
 {
 	return dev->netdev_ops == &dsa_slave_netdev_ops;
 }
+EXPORT_SYMBOL_GPL(dsa_slave_dev_check);
 
 static int dsa_slave_changeupper(struct net_device *dev,
 				 struct netdev_notifier_changeupper_info *info)
-- 
2.17.1

