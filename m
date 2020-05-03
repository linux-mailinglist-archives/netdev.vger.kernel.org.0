Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF3FB1C2F5E
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 23:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729126AbgECVK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 17:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729089AbgECVK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 17:10:56 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCA4BC061A0F
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 14:10:55 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z6so6581450wml.2
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 14:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QRA8TH6x2wkp+yi6thFqNBS9leAJ/FYpUBdqonT4yJY=;
        b=ji4qTXtNfnNYqK7aZabdS05GfCI4O1lhvBMgfY79bQ1KJB5d4u6SEPcx3+XWfR2r81
         RrHqJN5qKTOaN8igpEGs7bCFOZHR6Cu4c07MV0tJDrvxnL1DBQbI5jiZC8eKYfkhA/jG
         c0UfdZDkCJhiK9uyqOH/un/1muw9o7J80ovckNpc3EA8B+35Dl+63gNRerT7YKWEDWC7
         XIHE/hd6HRis09h2pULMnPtyR3PCZn4qbRALDH2/xVbuNQrHkHhdqnd+IV0rrsMSzzoG
         E3khIAVzeAdhIKBU0DFE9Nirlxb6czAGc/FiSTbbFuwCHEEorzb5kuikHSP7sNgZjB6Q
         ztCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QRA8TH6x2wkp+yi6thFqNBS9leAJ/FYpUBdqonT4yJY=;
        b=aXSH4OjhobqCZ3yBLioGoyXPptOP7B4OZuAvBqCOvvlGIQsF15p1e430vTSXPW8SiQ
         +1rGv3iUJFOdLHQ8QjlzupoGgf+PyLoDvIXIF7wKTHqbqtFIEJKaV/URG4znLyGYX5Hm
         +W+XYw+ZBH9Q6I7rlm5cFWYHA1KYqUVe6a1A1oFsmKTcheVCqj510Gk9kefjoChdeSfI
         v9RZ0lq2ZZYWKXkkczXYILmOWJqekRmOajYirAbiBBjQW+CSthabacOucRUIXPWD4+gr
         68zTbQwi2pDHcAdfMdJQD39IOStdFZgpN6wN+MRf5Jgpu05z3oE21USnIHElvIJxCQ+x
         aRLw==
X-Gm-Message-State: AGi0Pubcm9Qr7Xav1//Keeqz2cvbzm768hJB/237eaW0zanwOH0be6I1
        UItX2h5EbVkbYqkI6V/fqJilfiaG
X-Google-Smtp-Source: APiQypLsIdPVEuMwkyB25Q5A7+8SypNRVy00J3DxDx1vUNT/2m+cqKsVDgafU8tNSWUHtOfCGVIBcw==
X-Received: by 2002:a1c:f20c:: with SMTP id s12mr11774769wmc.83.1588540254436;
        Sun, 03 May 2020 14:10:54 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id s6sm10252682wmh.17.2020.05.03.14.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 14:10:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vinicius.gomes@intel.com, po.liu@nxp.com, xiaoliang.yang@nxp.com,
        mingkai.hu@nxp.com, christian.herber@nxp.com,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com,
        alexandru.marginean@nxp.com, vlad@buslov.dev, jiri@mellanox.com,
        idosch@mellanox.com, kuba@kernel.org
Subject: [PATCH net-next 1/6] net: dsa: export dsa_slave_dev_check and dsa_slave_to_port
Date:   Mon,  4 May 2020 00:10:30 +0300
Message-Id: <20200503211035.19363-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503211035.19363-1-olteanv@gmail.com>
References: <20200503211035.19363-1-olteanv@gmail.com>
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
Changes from RFC:
None.

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

