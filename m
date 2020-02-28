Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92F3F173EFD
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 19:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgB1SBn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 13:01:43 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45770 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1SBn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 13:01:43 -0500
Received: by mail-pg1-f196.google.com with SMTP id m15so1880715pgv.12
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 10:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=EMG8mLdlSEBMuMtWPWrjvkI/oIKYNHu26M3KebVZLEo=;
        b=abgwU2yUewFvGAWPYFNbm6hro8tiBC0K2Sor0CzcbWNnVZcUJ3wLfikuyjyKuPYtq2
         h7EKUu95f2I92/YVoUzMhsj2MSShldj1EJM+UfTZ2AAOTN85dBZH6uBUVSb2+8fHhPCp
         30ziqV1y9bojRDGpWgn3St5BZboUMcDZLH706T/ZjhBQ8NjdbpG7W7Itbehx0m43a4La
         zmAq7tk+8uMIUb+I6/Gn6bXdOwQfIjqpdrCR5p8PqavWYwHfpr4b23+ThqkuY30j/Dit
         xpQsVLSO8qK+vjN4aP9unXd1QvjiFCq/Pvz3HYYPI30riqX0FrJ8a4UA0TCOCe6r48J8
         Jluw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=EMG8mLdlSEBMuMtWPWrjvkI/oIKYNHu26M3KebVZLEo=;
        b=sU/54/WoyDcQ1p6wrQEAJppRA9RfDglaxZG/98xVx0xFOYEc4rJsWN4jpS1ut+ssKo
         NMyRGkFpedHVkXyDMkPGP0t/h9KdLaDaG2VSP/ll6ud4gMTlqA+xXH3NjcppcW/1akV5
         2r39yl+ZJlNaiRYA1J3k/XzL/QnN+Y/IC3BZp5aK63VmPDSszwL+O2cu73VqMwE9s/kr
         15zaTLcnKK4cb2N6Y0h7C4m4eKn+wwqQ7OzEqwoLujIV4dGPBeJjs48+ISALNr8H835z
         PbVt8tpJHc/BPTLfMw0sT1c5UpEMXg8XChQ5xEBwGBD+hbuyn5dKphb3EG/7hm+isbwx
         UZdw==
X-Gm-Message-State: APjAAAVjHurLrFp/TS6kT4KfXO7hFTQr/FzZWGmy8Ha2FyFdwjJuIFGN
        EAYZBwtiiTFYEsUcqGEetzA=
X-Google-Smtp-Source: APXvYqzO98UXq3R4Am4bHx5dtniQkl/Rk0F9NUh7HPXN8ZxuDhQlKgTXcXjQkWNRV1kLuM5l/RRLWg==
X-Received: by 2002:aa7:98c6:: with SMTP id e6mr5531507pfm.251.1582912902236;
        Fri, 28 Feb 2020 10:01:42 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id q3sm1888149pgj.92.2020.02.28.10.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 10:01:41 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 2/5] hsr: use extack error message instead of netdev_info
Date:   Fri, 28 Feb 2020 18:01:35 +0000
Message-Id: <20200228180135.27683-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If HSR uses the extack instead of netdev_info(), users can get
error messages immediately without any checking the kernel message.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_device.c  |  9 +++++----
 net/hsr/hsr_device.h  |  3 ++-
 net/hsr/hsr_netlink.c | 22 +++++++++++++++-------
 net/hsr/hsr_slave.c   | 20 ++++++++++++--------
 net/hsr/hsr_slave.h   |  2 +-
 5 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index c7bd6c49fadf..a48f621c2fec 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -431,7 +431,8 @@ static const unsigned char def_multicast_addr[ETH_ALEN] __aligned(2) = {
 };
 
 int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
-		     unsigned char multicast_spec, u8 protocol_version)
+		     unsigned char multicast_spec, u8 protocol_version,
+		     struct netlink_ext_ack *extack)
 {
 	struct hsr_priv *hsr;
 	struct hsr_port *port;
@@ -478,7 +479,7 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	/* Make sure the 1st call to netif_carrier_on() gets through */
 	netif_carrier_off(hsr_dev);
 
-	res = hsr_add_port(hsr, hsr_dev, HSR_PT_MASTER);
+	res = hsr_add_port(hsr, hsr_dev, HSR_PT_MASTER, extack);
 	if (res)
 		goto err_add_master;
 
@@ -486,11 +487,11 @@ int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
 	if (res)
 		goto err_unregister;
 
-	res = hsr_add_port(hsr, slave[0], HSR_PT_SLAVE_A);
+	res = hsr_add_port(hsr, slave[0], HSR_PT_SLAVE_A, extack);
 	if (res)
 		goto err_add_slaves;
 
-	res = hsr_add_port(hsr, slave[1], HSR_PT_SLAVE_B);
+	res = hsr_add_port(hsr, slave[1], HSR_PT_SLAVE_B, extack);
 	if (res)
 		goto err_add_slaves;
 
diff --git a/net/hsr/hsr_device.h b/net/hsr/hsr_device.h
index 6d7759c4f5f9..a099d7de7e79 100644
--- a/net/hsr/hsr_device.h
+++ b/net/hsr/hsr_device.h
@@ -13,7 +13,8 @@
 
 void hsr_dev_setup(struct net_device *dev);
 int hsr_dev_finalize(struct net_device *hsr_dev, struct net_device *slave[2],
-		     unsigned char multicast_spec, u8 protocol_version);
+		     unsigned char multicast_spec, u8 protocol_version,
+		     struct netlink_ext_ack *extack);
 void hsr_check_carrier_and_operstate(struct hsr_priv *hsr);
 bool is_hsr_master(struct net_device *dev);
 int hsr_get_max_mtu(struct hsr_priv *hsr);
diff --git a/net/hsr/hsr_netlink.c b/net/hsr/hsr_netlink.c
index 8dc0547f01d0..7ed308a0c035 100644
--- a/net/hsr/hsr_netlink.c
+++ b/net/hsr/hsr_netlink.c
@@ -35,26 +35,34 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 	unsigned char multicast_spec, hsr_version;
 
 	if (!data) {
-		netdev_info(dev, "HSR: No slave devices specified\n");
+		NL_SET_ERR_MSG_MOD(extack, "No slave devices specified");
 		return -EINVAL;
 	}
 	if (!data[IFLA_HSR_SLAVE1]) {
-		netdev_info(dev, "HSR: Slave1 device not specified\n");
+		NL_SET_ERR_MSG_MOD(extack, "Slave1 device not specified");
 		return -EINVAL;
 	}
 	link[0] = __dev_get_by_index(src_net,
 				     nla_get_u32(data[IFLA_HSR_SLAVE1]));
+	if (!link[0]) {
+		NL_SET_ERR_MSG_MOD(extack, "Slave1 does not exist");
+		return -EINVAL;
+	}
 	if (!data[IFLA_HSR_SLAVE2]) {
-		netdev_info(dev, "HSR: Slave2 device not specified\n");
+		NL_SET_ERR_MSG_MOD(extack, "Slave2 device not specified");
 		return -EINVAL;
 	}
 	link[1] = __dev_get_by_index(src_net,
 				     nla_get_u32(data[IFLA_HSR_SLAVE2]));
+	if (!link[1]) {
+		NL_SET_ERR_MSG_MOD(extack, "Slave2 does not exist");
+		return -EINVAL;
+	}
 
-	if (!link[0] || !link[1])
-		return -ENODEV;
-	if (link[0] == link[1])
+	if (link[0] == link[1]) {
+		NL_SET_ERR_MSG_MOD(extack, "Slave1 and Slave2 are same");
 		return -EINVAL;
+	}
 
 	if (!data[IFLA_HSR_MULTICAST_SPEC])
 		multicast_spec = 0;
@@ -66,7 +74,7 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
 	else
 		hsr_version = nla_get_u8(data[IFLA_HSR_VERSION]);
 
-	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version);
+	return hsr_dev_finalize(dev, link, multicast_spec, hsr_version, extack);
 }
 
 static int hsr_fill_info(struct sk_buff *skb, const struct net_device *dev)
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index fbfd0db182b7..127ebcc0e28f 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -58,33 +58,37 @@ bool hsr_port_exists(const struct net_device *dev)
 	return rcu_access_pointer(dev->rx_handler) == hsr_handle_frame;
 }
 
-static int hsr_check_dev_ok(struct net_device *dev)
+static int hsr_check_dev_ok(struct net_device *dev,
+			    struct netlink_ext_ack *extack)
 {
 	/* Don't allow HSR on non-ethernet like devices */
 	if ((dev->flags & IFF_LOOPBACK) || dev->type != ARPHRD_ETHER ||
 	    dev->addr_len != ETH_ALEN) {
-		netdev_info(dev, "Cannot use loopback or non-ethernet device as HSR slave.\n");
+		NL_SET_ERR_MSG_MOD(extack, "Cannot use loopback or non-ethernet device as HSR slave.");
 		return -EINVAL;
 	}
 
 	/* Don't allow enslaving hsr devices */
 	if (is_hsr_master(dev)) {
-		netdev_info(dev, "Cannot create trees of HSR devices.\n");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Cannot create trees of HSR devices.");
 		return -EINVAL;
 	}
 
 	if (hsr_port_exists(dev)) {
-		netdev_info(dev, "This device is already a HSR slave.\n");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "This device is already a HSR slave.");
 		return -EINVAL;
 	}
 
 	if (is_vlan_dev(dev)) {
-		netdev_info(dev, "HSR on top of VLAN is not yet supported in this driver.\n");
+		NL_SET_ERR_MSG_MOD(extack, "HSR on top of VLAN is not yet supported in this driver.");
 		return -EINVAL;
 	}
 
 	if (dev->priv_flags & IFF_DONT_BRIDGE) {
-		netdev_info(dev, "This device does not support bridging.\n");
+		NL_SET_ERR_MSG_MOD(extack,
+				   "This device does not support bridging.");
 		return -EOPNOTSUPP;
 	}
 
@@ -126,13 +130,13 @@ static int hsr_portdev_setup(struct net_device *dev, struct hsr_port *port)
 }
 
 int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
-		 enum hsr_port_type type)
+		 enum hsr_port_type type, struct netlink_ext_ack *extack)
 {
 	struct hsr_port *port, *master;
 	int res;
 
 	if (type != HSR_PT_MASTER) {
-		res = hsr_check_dev_ok(dev);
+		res = hsr_check_dev_ok(dev, extack);
 		if (res)
 			return res;
 	}
diff --git a/net/hsr/hsr_slave.h b/net/hsr/hsr_slave.h
index 64b549529592..8953ea279ce9 100644
--- a/net/hsr/hsr_slave.h
+++ b/net/hsr/hsr_slave.h
@@ -13,7 +13,7 @@
 #include "hsr_main.h"
 
 int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
-		 enum hsr_port_type pt);
+		 enum hsr_port_type pt, struct netlink_ext_ack *extack);
 void hsr_del_port(struct hsr_port *port);
 bool hsr_port_exists(const struct net_device *dev);
 
-- 
2.17.1

