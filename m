Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EB835F94B
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 18:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352871AbhDNQyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 12:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352025AbhDNQyA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 12:54:00 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9AD9C061574;
        Wed, 14 Apr 2021 09:53:36 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id lt13so1725289pjb.1;
        Wed, 14 Apr 2021 09:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VZ2RsmV+OU356aeQOZZ5iMpx/AhX3VL0MX95R8sfFIY=;
        b=ShFOcPd/+HbLiuZq2V5t0mN0LPtywqHDNWS0xHjnOVDvQf/VcA1CNvzArbc4eFESL9
         nfjQMWqbYGPr8rXq6J3RcUBY0v2mf7cwsmgmNuhOIyw3qs+K2Fm9t5NtsnxSH/BIHzRA
         TEMTFn5Dhtoufs+g6+R0KUptkMWQE9qhJi2HUAj9zLaBlcQlffi9kDiCxdDOIzXkMlQv
         3SUWwo9FBzNR6hgGS+zwD/NZ8usHZKxDLcMwSrNDX2rSgePnjxoMSMmUie+ol5o87FHv
         e9wbW3ESLDexdFF49m7lN05yUpP7uh8B1Qb7Ig2zy0Z8cu2pwQLKqC/rsgLzq8DBCIXa
         A2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VZ2RsmV+OU356aeQOZZ5iMpx/AhX3VL0MX95R8sfFIY=;
        b=t9JicgcWLUbQ5lFp82WMIl6iSR0NT8peMG8szD6DbsbdI7hO0lQkPA0RxoOBIgrJ1q
         9N/mhFLCMHbbBjEKzn7wxIUUlSCxWO+dNPXjqCYS0eRKaN8O3n9GoVNaxouN9l+APTF2
         aZQcrbF4g2yH9AbMmYAWeJl0MqEVYtREyYcElloGptYHHT6N6oP0+lXz8+SUUcqqCPu2
         6pxFDN3zCXb5GM0y6KWLfdGMJQ+fDs6mBntnbb59LIsC6Nqyilu+c9kbvJLAgl/o/ijz
         PFVNPWEV79ARtSRSiGYt0cjTg+ZAgsOGxLOP9Ee3WNjYELdakJFWxfh8SFSVtsdMyjx4
         ZrSQ==
X-Gm-Message-State: AOAM530s8rPsd7lgAGc+TzrftJKYXQu7k9dgS6gnBy1FseCm2P+dZx00
        vy/WjWsVUEE1rv5qthAXDaoldAAJHbMHZQ==
X-Google-Smtp-Source: ABdhPJzkP75ip1Y1g7ZBwhthTy4KQ5Qg6Ym/j2T3lWy2KdV0Zk55Tc3nELx4cuB5gblzG0xCw1spFg==
X-Received: by 2002:a17:902:ea89:b029:ea:c781:daad with SMTP id x9-20020a170902ea89b02900eac781daadmr23126240plb.62.1618419214996;
        Wed, 14 Apr 2021 09:53:34 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id t65sm31427pfd.5.2021.04.14.09.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 09:53:34 -0700 (PDT)
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
Subject: [PATCH resend net-next 1/2] net: bridge: switchdev: refactor br_switchdev_fdb_notify
Date:   Wed, 14 Apr 2021 19:52:55 +0300
Message-Id: <20210414165256.1837753-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210414165256.1837753-1-olteanv@gmail.com>
References: <20210414165256.1837753-1-olteanv@gmail.com>
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

