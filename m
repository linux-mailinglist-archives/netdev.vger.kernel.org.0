Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41A7B192C2F
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgCYPWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36963 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727751AbgCYPW3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id d1so3161601wmb.2
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6iRPv1lM2JYm9JzaSdpzNx0DiYcPcVAOEsGAUR9MeD0=;
        b=J1vohO+p9nQiLUnP2SVUe7lejW91XxPsnc8jHc7NyMySa6sSSUhkakPzg1pvYIv25K
         LhkmlKBrQtziwcu5fVZ3K8Mp9V4M/sILpmEp3DcBvDkHOz/n6dPo0G5j38X/LTr899oY
         quZuRX/NRS5IthpfOa/X9UTOdwnELl/JOyCuNtU7dK+iJOERIwfaat8Uw3CUPxc6+VhZ
         q9ORUvXwjtW4mpK0KfRsIprQ6ccPnMK/8lPs5vQKseEaFThXmwXHOTRUPmiBXLCvIZb6
         F33A8BcTnaufEierI8Mm2tHjp9CCGfVKxRE0eu2uBnRvcw5OhTmECk0YdZvKHUd0NRNH
         Dxtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6iRPv1lM2JYm9JzaSdpzNx0DiYcPcVAOEsGAUR9MeD0=;
        b=p40PqcatTM0FaUJoQSHL/PxaPF2vVObhaKxjF/s7/If8g1ghPXxXg6ZjLSE/hBTkhc
         TRDJRoVmXcvtKTZonCuBO++NcoJR8Kk6fFU5VVsof4PIKfb9ZMM8o2omJIewsKzgWt2h
         D3RBZrfBcTQPoQ0V0TGZWePHQmdyjjVIGMFp3lPrc8HF/fY9wGgU89xFO8Aj2rNdISBX
         GZbJD/PE7HBUKye8DDl/I8hks+OZX0tgFwGQcnZyKdLEYsT4WAyoUzPe72Ze7cXZjCgI
         gYCTQ7J2ErhdayConmOcWX7EjMo+znVSZSRsqLGLwu0m472gjS6P5ZxE92M7IT7kSt8p
         /9OQ==
X-Gm-Message-State: ANhLgQ2WCVYnVpYH044BsxGK6v+dwGuXeO0BtoX896RTzNazar/odq4+
        NdYop8OLyYWkIEcdgEjgf0Q=
X-Google-Smtp-Source: ADFU+vuSyti+yJq9hAaOrDF7T3o3BD874e0GXBOWFy1q4FFsWu7yy6v6GY6CedDWHoqRxrFsqB0Tbw==
X-Received: by 2002:a1c:b4c6:: with SMTP id d189mr3774315wmf.132.1585149747995;
        Wed, 25 Mar 2020 08:22:27 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:27 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 10/10] net: bridge: implement auto-normalization of MTU for hardware datapath
Date:   Wed, 25 Mar 2020 17:22:09 +0200
Message-Id: <20200325152209.3428-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325152209.3428-1-olteanv@gmail.com>
References: <20200325152209.3428-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the initial attempt to add MTU configuration for DSA:

https://patchwork.ozlabs.org/cover/1199868/

Florian raised a concern about the bridge MTU normalization logic (when
you bridge an interface with MTU 9000 and one with MTU 1500). His
expectation was that the bridge would automatically change the MTU of
all its slave ports to the minimum MTU, if those slaves are part of the
same hardware bridge. However, it doesn't do that, and for good reason,
I think. What br_mtu_auto_adjust() does is it adjusts the MTU of the
bridge net device itself, and not that of any slave port.  If it were to
modify the MTU of the slave ports, the effect would be that the user
wouldn't be able to increase the MTU of any bridge slave port as long as
it was part of the bridge, which would be a bit annoying to say the
least.

The idea behind this behavior is that normal termination from Linux over
the L2 forwarding domain described by DSA should happen over the bridge
net device, which _is_ properly limited by the minimum MTU. And
termination over individual slave device is possible even if those are
bridged. But that is not "forwarding", so there's no reason to do
normalization there, since only a single interface sees that packet.

The real problem is with the offloaded data path, where of course, the
bridge net device MTU is ignored. So a packet received on an interface
with MTU 9000 would still be forwarded to an interface with MTU 1500.
And that is exactly what this patch is trying to prevent from happening.

Florian's idea was that all hardware ports having the same
netdev_port_same_parent_id should be adjusted to have the same MTU.
The MTU that we attempt to configure the ports to is the most recently
modified MTU. The attempt is to follow user intention as closely as
possible and not be annoying at that.

So there are 2 cases really:

ip link set dev sw0p0 master br0
ip link set dev sw0p1 mtu 1400
ip link set dev sw0p1 master br0

The above sequence will make sw0p0 inherit MTU 1400 as well.

The second case:

ip link set dev sw0p0 master br0
ip link set dev sw0p1 master br0
ip link set dev sw0p0 mtu 1400

This sequence will make sw0p1 inherit MTU 1400 from sw0p0.

Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/bridge/br.c         |  1 +
 net/bridge/br_if.c      | 93 +++++++++++++++++++++++++++++++++++++++++
 net/bridge/br_private.h |  1 +
 3 files changed, 95 insertions(+)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index b6fe30e3768f..5f05380df1ee 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -57,6 +57,7 @@ static int br_device_event(struct notifier_block *unused, unsigned long event, v
 
 	switch (event) {
 	case NETDEV_CHANGEMTU:
+		br_mtu_normalization(br, dev);
 		br_mtu_auto_adjust(br);
 		break;
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4fe30b182ee7..a228668920a6 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -514,6 +514,98 @@ void br_mtu_auto_adjust(struct net_bridge *br)
 	br_opt_toggle(br, BROPT_MTU_SET_BY_USER, false);
 }
 
+struct br_hw_port {
+	struct list_head list;
+	struct net_device *dev;
+	int old_mtu;
+};
+
+static int br_hw_port_list_set_mtu(struct list_head *hw_port_list, int mtu)
+{
+	const struct br_hw_port *p;
+	int err;
+
+	list_for_each_entry(p, hw_port_list, list) {
+		if (p->dev->mtu == mtu)
+			continue;
+
+		err = dev_set_mtu(p->dev, mtu);
+		if (err)
+			goto rollback;
+	}
+
+	return 0;
+
+rollback:
+	list_for_each_entry_continue_reverse(p, hw_port_list, list) {
+		if (p->dev->mtu == p->old_mtu)
+			continue;
+
+		if (dev_set_mtu(p->dev, p->old_mtu))
+			netdev_err(p->dev, "Failed to restore MTU\n");
+	}
+
+	return err;
+}
+
+static void br_hw_port_list_free(struct list_head *hw_port_list)
+{
+	struct br_hw_port *p, *n;
+
+	list_for_each_entry_safe(p, n, hw_port_list, list)
+		kfree(p);
+}
+
+/* Make the hardware datapath to/from @br_if limited to a common MTU */
+void br_mtu_normalization(struct net_bridge *br, struct net_device *br_if)
+{
+	const struct net_bridge_port *p;
+	struct list_head hw_port_list;
+	int min_mtu = ETH_MAX_MTU;
+	int err;
+
+	INIT_LIST_HEAD(&hw_port_list);
+
+	/* Populate the list of ports that are part of the same hardware bridge
+	 * as the newly added port
+	 */
+	list_for_each_entry(p, &br->port_list, list) {
+		struct br_hw_port *hw_port;
+
+		if (!netdev_port_same_parent_id(p->dev, br_if))
+			continue;
+
+		if (min_mtu > p->dev->mtu)
+			min_mtu = p->dev->mtu;
+
+		hw_port = kzalloc(sizeof(*hw_port), GFP_KERNEL);
+		if (!hw_port)
+			goto out;
+
+		hw_port->dev = p->dev;
+		hw_port->old_mtu = p->dev->mtu;
+
+		list_add(&hw_port->list, &hw_port_list);
+	}
+
+	/* Attempt to configure the entire hardware bridge to the newly added
+	 * interface's MTU first, regardless of whether the intention of the
+	 * user was to raise or lower it.
+	 */
+	err = br_hw_port_list_set_mtu(&hw_port_list, br_if->mtu);
+	if (!err)
+		goto out;
+
+	/* Clearly that didn't work out so well, so just set the minimum MTU on
+	 * all hardware bridge ports now. If this fails too, then all ports will
+	 * still have their old MTU rolled back anyway.
+	 */
+	br_hw_port_list_set_mtu(&hw_port_list, min_mtu);
+
+out:
+	br_hw_port_list_free(&hw_port_list);
+}
+
 static void br_set_gso_limits(struct net_bridge *br)
 {
 	unsigned int gso_max_size = GSO_MAX_SIZE;
@@ -676,6 +768,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	if (changed_addr)
 		call_netdevice_notifiers(NETDEV_CHANGEADDR, br->dev);
 
+	br_mtu_normalization(br, dev);
 	br_mtu_auto_adjust(br);
 	br_set_gso_limits(br);
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 1f97703a52ff..df010e36228e 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -693,6 +693,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
 	      struct netlink_ext_ack *extack);
 int br_del_if(struct net_bridge *br, struct net_device *dev);
 void br_mtu_auto_adjust(struct net_bridge *br);
+void br_mtu_normalization(struct net_bridge *br, struct net_device *br_if);
 netdev_features_t br_features_recompute(struct net_bridge *br,
 					netdev_features_t features);
 void br_port_flags_change(struct net_bridge_port *port, unsigned long mask);
-- 
2.17.1

