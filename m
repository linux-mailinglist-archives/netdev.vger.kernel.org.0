Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFDD35F771
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350114AbhDNPQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:16:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbhDNPQ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:16:28 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1778C061574;
        Wed, 14 Apr 2021 08:16:06 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e2so5979538plh.8;
        Wed, 14 Apr 2021 08:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZ2RsmV+OU356aeQOZZ5iMpx/AhX3VL0MX95R8sfFIY=;
        b=nzo816JMfJIbv7Xim7u6A6s4DUUNVJQvi+WoxfxS89HrOI79jr4V6q4gzB8sTqH/CL
         pcVU/Lvltdq5Ikpbgh5OuUG8EBeunvXYfdtXOluaNiamqynmgZSStFkh2RL0CB2CPaWM
         JjR/c+jj0tPiybMKIXjPcbh7okBmNam82rm7JTDVPoIAmoPmPKVdO0jm4B/H7GIjJV2o
         VxCD48sF7vUXw2zBk41/yOIgXRcWmgMOrummM19b1OD3qW77umilMyLq462n8Hb4Bxuz
         edx53z0FMTGu6aFmQ6tRQgkhhz45AXjmCBuzlMvWLrzh44PBPczb+V77UyS33Juy1GVS
         K5FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VZ2RsmV+OU356aeQOZZ5iMpx/AhX3VL0MX95R8sfFIY=;
        b=te2p/jxyqOF0iYKhObDUpGCSXQTRrTLq2vXCA2a2FC8EFghHk+Uzf+LNClo2p5Asq8
         mqGfAc54Ykm8SHhv2+go23YGlzlzZ+kjyLJLPVyOF05tmwL+ng71xxGQHLg75Ki0gBOa
         PKCYOR2zoY1MKPKa1Ru0uPZMDXclaGwgHl9cbmciProjC+hJSIZrwN1nyutWUKo5DK6S
         dUfIjFAlHY8ufLXnGwQvec788ShpA15jBL8K8PXPgR06zmm4z0HNs6c1FlmptObUKsl7
         aNI3zprUgbBY7IVOdylfsUtL7D5kbvCkg9bfJgkyV6lbQl50aeGt7sXVmWJjSr66AsVX
         Y/1g==
X-Gm-Message-State: AOAM53313UgH5kOt77S5lA5uHvfHu+ahQ+VqV1oJ1DqcdBLugVLesFKK
        +srM74HZqoo3dvQ97WCijgY=
X-Google-Smtp-Source: ABdhPJya5aEIzjkZKQwFlokUW51hE2ZN604L/nqIMPttyU08qKmimAZRZjtKnnz2suWGlexGvNPS3w==
X-Received: by 2002:a17:902:8f89:b029:ea:ea23:a02c with SMTP id z9-20020a1709028f89b02900eaea23a02cmr18976533plo.71.1618413366195;
        Wed, 14 Apr 2021 08:16:06 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id s40sm12241146pfw.133.2021.04.14.08.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 08:16:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] net: bridge: switchdev: refactor br_switchdev_fdb_notify
Date:   Wed, 14 Apr 2021 18:15:39 +0300
Message-Id: <20210414151540.1808871-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

Instead of having to add more and more arguments to
br_switchdev_fdb_call_notifiers, get rid of it and build the info
struct directly in br_switchdev_fdb_notify.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br_switchdev.c | 41 +++++++++++----------------------------
 1 file changed, 11 insertions(+), 30 deletions(-)

diff --git a/net/bridge/br_switchdev.c b/net/bridge/br_switchdev.c
index 1e24d9a2c9a7..c390f84adea2 100644
--- a/net/bridge/br_switchdev.c
+++ b/net/bridge/br_switchdev.c
@@ -107,25 +107,16 @@ int br_switchdev_set_port_flag(struct net_bridge_port *p,
 	return 0;
 }
 
-static void
-br_switchdev_fdb_call_notifiers(bool adding, const unsigned char *mac,
-				u16 vid, struct net_device *dev,
-				bool added_by_user, bool offloaded)
-{
-	struct switchdev_notifier_fdb_info info;
-	unsigned long notifier_type;
-
-	info.addr = mac;
-	info.vid = vid;
-	info.added_by_user = added_by_user;
-	info.offloaded = offloaded;
-	notifier_type = adding ? SWITCHDEV_FDB_ADD_TO_DEVICE : SWITCHDEV_FDB_DEL_TO_DEVICE;
-	call_switchdev_notifiers(notifier_type, dev, &info.info, NULL);
-}
-
 void
 br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 {
+	struct switchdev_notifier_fdb_info info = {
+		.addr = fdb->key.addr.addr,
+		.vid = fdb->key.vlan_id,
+		.added_by_user = test_bit(BR_FDB_ADDED_BY_USER, &fdb->flags),
+		.offloaded = test_bit(BR_FDB_OFFLOADED, &fdb->flags),
+	};
+
 	if (!fdb->dst)
 		return;
 	if (test_bit(BR_FDB_LOCAL, &fdb->flags))
@@ -133,22 +124,12 @@ br_switchdev_fdb_notify(const struct net_bridge_fdb_entry *fdb, int type)
 
 	switch (type) {
 	case RTM_DELNEIGH:
-		br_switchdev_fdb_call_notifiers(false, fdb->key.addr.addr,
-						fdb->key.vlan_id,
-						fdb->dst->dev,
-						test_bit(BR_FDB_ADDED_BY_USER,
-							 &fdb->flags),
-						test_bit(BR_FDB_OFFLOADED,
-							 &fdb->flags));
+		call_switchdev_notifiers(SWITCHDEV_FDB_DEL_TO_DEVICE,
+					 fdb->dst->dev, &info.info, NULL);
 		break;
 	case RTM_NEWNEIGH:
-		br_switchdev_fdb_call_notifiers(true, fdb->key.addr.addr,
-						fdb->key.vlan_id,
-						fdb->dst->dev,
-						test_bit(BR_FDB_ADDED_BY_USER,
-							 &fdb->flags),
-						test_bit(BR_FDB_OFFLOADED,
-							 &fdb->flags));
+		call_switchdev_notifiers(SWITCHDEV_FDB_ADD_TO_DEVICE,
+					 fdb->dst->dev, &info.info, NULL);
 		break;
 	}
 }
-- 
2.25.1

