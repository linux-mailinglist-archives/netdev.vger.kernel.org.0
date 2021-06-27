Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6099C3B53A6
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231297AbhF0ONM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbhF0OND (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:13:03 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2B7C061766
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:38 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id n2so13316599eju.11
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J+t92kp2whfwaiecVe0FC6ct75iFu1mJ1vcqnv+uoxE=;
        b=crFreKQWgEAs1gJLe1GLDONF5tOb1/kK/ioWoqGK67G+ELy3AX/mjhRxuKxqXv2hFY
         u+Mxf0FA3MBhqTJxk6mISxhODeZe+UF3hBCydsfiQ0PvntCXN7QRDhy+vuB9fhC+b2+N
         V1H6HY7aEEeyWoHkj/qnK9dwKmRSA2OWGMLt5oYtrYcuGwcfxWOWQQ1vVVxQLGwsu5IC
         UZljRIbQG+OOoR3bAQ5hdAES7QOLFSObadCbtC+PsX7JpcT9nHvE4+Bi7KHJwtbkg/DI
         uOrSHYrT1twTvFBCdElCNBnKTcqsQ/ip1CDUJyeqfXhYRDL+mlwptIg3aKq1oxrt5f0g
         uUFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+t92kp2whfwaiecVe0FC6ct75iFu1mJ1vcqnv+uoxE=;
        b=ZIp1Rm03lxG+GhRd7W9Z9KAdM/Uy6RtzEE+9yiT/SRuRtqDcYxWSwvpmr6tqpBiVHV
         3P0WixOy3uT161zZoiS9OyOV6/UySqF+ZVu16s0Hyb2ba4z4MSb3tdJQoo/G3MGMARvI
         HMNdx1mw5pUmECVRzWgE2i7MyYmfanp57S+KZEHUAhzkxa3ZaQwijvUosF6ANzLEH9x2
         bVgsqyyAI5Q78iTrggQqc4u3N3rxsBW6EnihpL9mBCE6/WpY8bt09Dg+m/A8U5CZmoyh
         AvZKmPoWKFrq2SYI+uMxZsaorh2dZI7vVVh5krIXD8VI32evnFOl37BgMCx4ZnVTOrYi
         oEYA==
X-Gm-Message-State: AOAM530SLABX4mvZBRO6rZ13Uc9mmXvv/PDoJxfYcy5ZOBSJWRjedrHf
        Bsu8LF7rDGf0wZ0QnDOEmJvcZwTB5/8=
X-Google-Smtp-Source: ABdhPJyIO7DTAWPS9dFx9uf/V9kxBXyoKmmz7qQ/gmNG4lDRzrrDtKiiERQGpXfkzbD/QognxTGlbQ==
X-Received: by 2002:a17:906:8c1:: with SMTP id o1mr20355013eje.530.1624803036999;
        Sun, 27 Jun 2021 07:10:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:36 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH v3 net-next 14/15] net: dsa: ensure during dsa_fdb_offload_notify that dev_hold and dev_put are on the same dev
Date:   Sun, 27 Jun 2021 17:10:12 +0300
Message-Id: <20210627141013.1273942-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When
(a) "dev" is a bridge port which the DSA switch tree offloads, but is
    otherwise not a dsa slave (such as a LAG netdev), or
(b) "dev" is the bridge net device itself

then strange things happen to the dev_hold/dev_put pair:
dsa_schedule_work() will still be called with a DSA port that offloads
that netdev, but dev_hold() will be called on the non-DSA netdev.
Then the "if" condition in dsa_slave_switchdev_event_work() does not
pass, because "dev" is not a DSA netdev, so dev_put() is not called.

This results in the simple fact that we have a reference counting
mismatch on the "dev" net device.

This can be seen when we add support for host addresses installed on the
bridge net device.

ip link add br1 type bridge
ip link set br1 address 00:01:02:03:04:05
ip link set swp0 master br1
ip link del br1
[  968.512278] unregister_netdevice: waiting for br1 to become free. Usage count = 5

It seems foolish to do penny pinching and not add the net_device pointer
in the dsa_switchdev_event_work structure, so let's finally do that.
As an added bonus, when we start offloading local entries pointing
towards the bridge, these will now properly appear as 'offloaded' in
'bridge fdb' (this was not possible before, because 'dev' was assumed to
only be a DSA net device):

00:01:02:03:04:05 dev br0 vlan 1 offload master br0 permanent
00:01:02:03:04:05 dev br0 offload master br0 permanent

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h | 1 +
 net/dsa/slave.c    | 9 ++++-----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 36e667ea94db..f201c33980bf 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -116,6 +116,7 @@ struct dsa_notifier_mrp_ring_role_info {
 struct dsa_switchdev_event_work {
 	struct dsa_switch *ds;
 	int port;
+	struct net_device *dev;
 	struct work_struct work;
 	unsigned long event;
 	/* Specific for SWITCHDEV_FDB_ADD_TO_DEVICE and
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index a7b5d2a41472..ffbba1e71551 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2349,9 +2349,8 @@ static void dsa_slave_switchdev_event_work(struct work_struct *work)
 	}
 	rtnl_unlock();
 
+	dev_put(switchdev_work->dev);
 	kfree(switchdev_work);
-	if (dsa_is_user_port(ds, dp->index))
-		dev_put(dp->slave);
 }
 
 static int dsa_lower_dev_walk(struct net_device *lower_dev,
@@ -2469,15 +2468,15 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		switchdev_work->ds = dp->ds;
 		switchdev_work->port = dp->index;
 		switchdev_work->event = event;
+		switchdev_work->dev = dev;
 
 		ether_addr_copy(switchdev_work->addr,
 				fdb_info->addr);
 		switchdev_work->vid = fdb_info->vid;
 		switchdev_work->host_addr = host_addr;
 
-		/* Hold a reference on the slave for dsa_fdb_offload_notify */
-		if (dsa_is_user_port(dp->ds, dp->index))
-			dev_hold(dev);
+		/* Hold a reference for dsa_fdb_offload_notify */
+		dev_hold(dev);
 		dsa_schedule_work(&switchdev_work->work);
 		break;
 	default:
-- 
2.25.1

