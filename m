Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604D91B0F94
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728878AbgDTPMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:12:22 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:24412 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730253AbgDTPMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:12:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587395540; x=1618931540;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=M30Yp5CS0j3wWpw8B0uEVdM61N+iFSy/Z5GCWGfXb5Y=;
  b=Tiyw475iLQKIzKQn/RKx+MQPWM4YYiVZCa4bK1hVyWlokgx0hWxEM49D
   lThai/RxOvKa0GboHTNrVokGYiQFJ3yT3p6PY9VhKy6CYGmV5HFNjBcN3
   MeqaM2QuqGEFqPRmnOtWyEKaoGpzqCeukczJUQ6kov8hAByVnajgMMmkl
   J99eqDTdxDK06iIOXD0jnRi0p1ilXNiewhKCLKFuNzyV/AaC7jgdlyMi/
   PxR6RKUJnOEfeay4CnzDzh8Us5ww9m7KWu5e8VRka6N+wd2MOXz8jv7Dm
   YpQsfAtG7mcQOsZQ1mYdkbAm84osxaDSlQ/PLzKjNtZpx+Hcqd+dCtRWu
   w==;
IronPort-SDR: TsOJ0s9Mue+wN9TG6R/U+gJiH+nZSJPdQi3aad8MV9Mx61krOtUKTo3lfd/OLS7Ydw3LVsnez9
 84tXtWI/KTYVPU2oQNYZw5fhnGGbK01bE3mLN50UAL7A1ytv/Uspd1K2HroGp0h5EPRkOgTGIO
 q93jewwWCHuH8rHbmfzBxdl3QA8XQDuWVDzznHhVbf///zJsrNx2s76P4Z7xhs/KpnaVMKOkfV
 IyelVzltXWc2UTOQizPiVepjP5FoXJlitUiMESNZa4zSiuMWKYun6z1PMQxsF0MAYjdkTdp8dH
 LVU=
X-IronPort-AV: E=Sophos;i="5.72,406,1580799600"; 
   d="scan'208";a="9780058"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Apr 2020 08:12:18 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 20 Apr 2020 08:11:51 -0700
Received: from soft-dev3.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1713.5 via Frontend Transport; Mon, 20 Apr 2020 08:11:48 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <nikolay@cumulusnetworks.com>, <davem@davemloft.net>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <kuba@kernel.org>,
        <roopa@cumulusnetworks.com>, <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 12/13] bridge: mrp: Integrate MRP into the bridge
Date:   Mon, 20 Apr 2020 17:09:46 +0200
Message-ID: <20200420150947.30974-13-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200420150947.30974-1-horatiu.vultur@microchip.com>
References: <20200420150947.30974-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To integrate MRP into the bridge, the bridge needs to do the following:
- detect if the MRP frame was received on MRP ring port in that case it would be
  processed otherwise just forward it as usual.
- enable parsing of MRP
- before whenever the bridge was set up, it would set all the ports in
  forwarding state. Add an extra check to not set ports in forwarding state if
  the port is an MRP ring port. The reason of this change is that if the MRP
  instance initially sets the port in blocked state by setting the bridge up it
  would overwrite this setting.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 net/bridge/br_device.c  |  3 +++
 net/bridge/br_if.c      |  2 ++
 net/bridge/br_input.c   |  3 +++
 net/bridge/br_netlink.c |  5 +++++
 net/bridge/br_private.h | 31 +++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+)

diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
index 0e3dbc5f3c34..8ec1362588af 100644
--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -463,6 +463,9 @@ void br_dev_setup(struct net_device *dev)
 	spin_lock_init(&br->lock);
 	INIT_LIST_HEAD(&br->port_list);
 	INIT_HLIST_HEAD(&br->fdb_list);
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+	INIT_LIST_HEAD(&br->mrp_list);
+#endif
 	spin_lock_init(&br->hash_lock);
 
 	br->bridge_id.prio[0] = 0x80;
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 4fe30b182ee7..ca685c0cdf95 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -333,6 +333,8 @@ static void del_nbp(struct net_bridge_port *p)
 	br_stp_disable_port(p);
 	spin_unlock_bh(&br->lock);
 
+	br_mrp_port_del(br, p);
+
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
 
 	list_del_rcu(&p->list);
diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
index fcc260840028..d5c34f36f0f4 100644
--- a/net/bridge/br_input.c
+++ b/net/bridge/br_input.c
@@ -342,6 +342,9 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
 		}
 	}
 
+	if (unlikely(br_mrp_process(p, skb)))
+		return RX_HANDLER_PASS;
+
 forward:
 	switch (p->state) {
 	case BR_STATE_FORWARDING:
diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
index 2f3a9e50c168..52f7bbd3f382 100644
--- a/net/bridge/br_netlink.c
+++ b/net/bridge/br_netlink.c
@@ -675,6 +675,11 @@ static int br_afspec(struct net_bridge *br,
 			if (err)
 				return err;
 			break;
+		case IFLA_BRIDGE_MRP:
+			err = br_mrp_parse(br, p, attr, cmd, extack);
+			if (err)
+				return err;
+			break;
 		}
 	}
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index b3c176a0a136..bbc496fcb181 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1312,6 +1312,37 @@ unsigned long br_timer_value(const struct timer_list *timer);
 extern int (*br_fdb_test_addr_hook)(struct net_device *dev, unsigned char *addr);
 #endif
 
+/* br_mrp.c */
+#if IS_ENABLED(CONFIG_BRIDGE_MRP)
+int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
+		 struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
+int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb);
+bool br_mrp_enabled(struct net_bridge *br);
+void br_mrp_port_del(struct net_bridge *br, struct net_bridge_port *p);
+#else
+static inline int br_mrp_parse(struct net_bridge *br, struct net_bridge_port *p,
+			       struct nlattr *attr, int cmd,
+			       struct netlink_ext_ack *extack)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
+{
+	return 0;
+}
+
+static inline bool br_mrp_enabled(struct net_bridge *br)
+{
+	return 0;
+}
+
+static inline void br_mrp_port_del(struct net_bridge *br,
+				   struct net_bridge_port *p)
+{
+}
+#endif
+
 /* br_netlink.c */
 extern struct rtnl_link_ops br_link_ops;
 int br_netlink_init(void);
-- 
2.17.1

