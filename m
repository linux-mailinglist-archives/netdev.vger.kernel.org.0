Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D44C2C861D
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727392AbgK3OBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:01:30 -0500
Received: from mx03.lhost.no ([5.158.192.84]:34713 "EHLO mx03.lhost.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgK3OB3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 09:01:29 -0500
X-ASG-Debug-ID: 1606744845-0ffc0524df139910001-BZBGGp
Received: from s103.paneda.no ([5.158.193.76]) by mx03.lhost.no with ESMTP id BholgjuvAwmgNorP (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NO); Mon, 30 Nov 2020 15:00:45 +0100 (CET)
X-Barracuda-Envelope-From: thomas.karlsson@paneda.se
X-Barracuda-Effective-Source-IP: UNKNOWN[5.158.193.76]
X-Barracuda-Apparent-Source-IP: 5.158.193.76
X-ASG-Whitelist: Client
Received: from [192.168.10.188] (83.140.179.234) by s103.paneda.no
 (10.16.55.12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.1979.3; Mon, 30
 Nov 2020 15:00:42 +0100
Subject: [PATCH net-next v3] macvlan: Support for high multicast packet rate
To:     Jakub Kicinski <kuba@kernel.org>
X-ASG-Orig-Subj: [PATCH net-next v3] macvlan: Support for high multicast packet rate
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kaber@trash.net>, <edumazet@google.com>,
        <vyasevic@redhat.com>, <alexander.duyck@gmail.com>,
        <thomas.karlsson@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
 <147b704ac1d5426fbaa8617289dad648@paneda.se>
 <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Thomas Karlsson <thomas.karlsson@paneda.se>
Message-ID: <0c88607c-1b63-e8b5-8a84-14b63e55e8e2@paneda.se>
Date:   Mon, 30 Nov 2020 15:00:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: sv
Content-Transfer-Encoding: 7bit
X-Originating-IP: [83.140.179.234]
X-ClientProxiedBy: s103.paneda.no (10.16.55.12) To s103.paneda.no
 (10.16.55.12)
X-Barracuda-Connect: UNKNOWN[5.158.193.76]
X-Barracuda-Start-Time: 1606744845
X-Barracuda-Encrypted: ECDHE-RSA-AES256-SHA384
X-Barracuda-URL: https://mx03.lhost.no:443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at lhost.no
X-Barracuda-Scan-Msg-Size: 7714
X-Barracuda-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Background:
Broadcast and multicast packages are enqueued for later processing.
This queue was previously hardcoded to 1000.

This proved insufficient for handling very high packet rates.
This resulted in packet drops for multicast.
While at the same time unicast worked fine.

The change:
This patch make the queue length adjustable to accommodate
for environments with very high multicast packet rate.
But still keeps the default value of 1000 unless specified.

The queue length is specified as a request per macvlan
using the IFLA_MACVLAN_BC_QUEUE_LEN parameter.

The actual used queue length will then be the maximum of
any macvlan connected to the same port. The actual used
queue length for the port can be retrieved (read only)
by the IFLA_MACVLAN_BC_QUEUE_LEN_USED parameter for verification.

This will be followed up by a patch to iproute2
in order to adjust the parameter from userspace.

Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>
---

v3 switched to using netlink attributes

v1/2 used module_param

 drivers/net/macvlan.c              | 44 ++++++++++++++++++++++++++++--
 include/linux/if_macvlan.h         |  1 +
 include/uapi/linux/if_link.h       |  2 ++
 tools/include/uapi/linux/if_link.h |  2 ++
 4 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index d9b6c44a5911..b8197761248e 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -35,7 +35,7 @@
 
 #define MACVLAN_HASH_BITS	8
 #define MACVLAN_HASH_SIZE	(1<<MACVLAN_HASH_BITS)
-#define MACVLAN_BC_QUEUE_LEN	1000
+#define MACVLAN_DEFAULT_BC_QUEUE_LEN	1000
 
 #define MACVLAN_F_PASSTHRU	1
 #define MACVLAN_F_ADDRCHANGE	2
@@ -46,6 +46,7 @@ struct macvlan_port {
 	struct list_head	vlans;
 	struct sk_buff_head	bc_queue;
 	struct work_struct	bc_work;
+	u32			bc_queue_len_used;
 	u32			flags;
 	int			count;
 	struct hlist_head	vlan_source_hash[MACVLAN_HASH_SIZE];
@@ -67,6 +68,7 @@ struct macvlan_skb_cb {
 #define MACVLAN_SKB_CB(__skb) ((struct macvlan_skb_cb *)&((__skb)->cb[0]))
 
 static void macvlan_port_destroy(struct net_device *dev);
+static void update_port_bc_queue_len(struct macvlan_port *port);
 
 static inline bool macvlan_passthru(const struct macvlan_port *port)
 {
@@ -354,7 +356,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 	MACVLAN_SKB_CB(nskb)->src = src;
 
 	spin_lock(&port->bc_queue.lock);
-	if (skb_queue_len(&port->bc_queue) < MACVLAN_BC_QUEUE_LEN) {
+	if (skb_queue_len(&port->bc_queue) < port->bc_queue_len_used) {
 		if (src)
 			dev_hold(src->dev);
 		__skb_queue_tail(&port->bc_queue, nskb);
@@ -1218,6 +1220,7 @@ static int macvlan_port_create(struct net_device *dev)
 	for (i = 0; i < MACVLAN_HASH_SIZE; i++)
 		INIT_HLIST_HEAD(&port->vlan_source_hash[i]);
 
+	port->bc_queue_len_used = MACVLAN_DEFAULT_BC_QUEUE_LEN;
 	skb_queue_head_init(&port->bc_queue);
 	INIT_WORK(&port->bc_work, macvlan_process_broadcast);
 
@@ -1486,6 +1489,12 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
 			goto destroy_macvlan_port;
 	}
 
+	vlan->bc_queue_len_requested = MACVLAN_DEFAULT_BC_QUEUE_LEN;
+	if (data && data[IFLA_MACVLAN_BC_QUEUE_LEN])
+		vlan->bc_queue_len_requested = nla_get_u32(data[IFLA_MACVLAN_BC_QUEUE_LEN]);
+	if (vlan->bc_queue_len_requested > port->bc_queue_len_used)
+		port->bc_queue_len_used = vlan->bc_queue_len_requested;
+
 	err = register_netdevice(dev);
 	if (err < 0)
 		goto destroy_macvlan_port;
@@ -1529,6 +1538,7 @@ void macvlan_dellink(struct net_device *dev, struct list_head *head)
 	if (vlan->mode == MACVLAN_MODE_SOURCE)
 		macvlan_flush_sources(vlan->port, vlan);
 	list_del_rcu(&vlan->list);
+	update_port_bc_queue_len(vlan->port);
 	unregister_netdevice_queue(dev, head);
 	netdev_upper_dev_unlink(vlan->lowerdev, dev);
 }
@@ -1572,6 +1582,15 @@ static int macvlan_changelink(struct net_device *dev,
 		}
 		vlan->flags = flags;
 	}
+
+	if (data && data[IFLA_MACVLAN_BC_QUEUE_LEN_USED])
+		return -EINVAL; /* Trying to set a read only attribute */
+
+	if (data && data[IFLA_MACVLAN_BC_QUEUE_LEN]) {
+		vlan->bc_queue_len_requested = nla_get_u32(data[IFLA_MACVLAN_BC_QUEUE_LEN]);
+		update_port_bc_queue_len(vlan->port);
+	}
+
 	if (set_mode)
 		vlan->mode = mode;
 	if (data && data[IFLA_MACVLAN_MACADDR_MODE]) {
@@ -1602,6 +1621,8 @@ static size_t macvlan_get_size(const struct net_device *dev)
 		+ nla_total_size(2) /* IFLA_MACVLAN_FLAGS */
 		+ nla_total_size(4) /* IFLA_MACVLAN_MACADDR_COUNT */
 		+ macvlan_get_size_mac(vlan) /* IFLA_MACVLAN_MACADDR */
+		+ nla_total_size(4) /* IFLA_MACVLAN_BC_QUEUE_LEN */
+		+ nla_total_size(4) /* IFLA_MACVLAN_BC_QUEUE_LEN_USED */
 		);
 }
 
@@ -1625,6 +1646,7 @@ static int macvlan_fill_info(struct sk_buff *skb,
 				const struct net_device *dev)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
+	struct macvlan_port *port = vlan->port;
 	int i;
 	struct nlattr *nest;
 
@@ -1645,6 +1667,10 @@ static int macvlan_fill_info(struct sk_buff *skb,
 		}
 		nla_nest_end(skb, nest);
 	}
+	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN, vlan->bc_queue_len_requested))
+		goto nla_put_failure;
+	if (nla_put_u32(skb, IFLA_MACVLAN_BC_QUEUE_LEN_USED, port->bc_queue_len_used))
+		goto nla_put_failure;
 	return 0;
 
 nla_put_failure:
@@ -1658,6 +1684,8 @@ static const struct nla_policy macvlan_policy[IFLA_MACVLAN_MAX + 1] = {
 	[IFLA_MACVLAN_MACADDR] = { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
 	[IFLA_MACVLAN_MACADDR_DATA] = { .type = NLA_NESTED },
 	[IFLA_MACVLAN_MACADDR_COUNT] = { .type = NLA_U32 },
+	[IFLA_MACVLAN_BC_QUEUE_LEN] = { .type = NLA_U32 },
+	[IFLA_MACVLAN_BC_QUEUE_LEN_USED] = { .type = NLA_U32 },
 };
 
 int macvlan_link_register(struct rtnl_link_ops *ops)
@@ -1688,6 +1716,18 @@ static struct rtnl_link_ops macvlan_link_ops = {
 	.priv_size      = sizeof(struct macvlan_dev),
 };
 
+static void update_port_bc_queue_len(struct macvlan_port *port)
+{
+	struct macvlan_dev *vlan;
+	u32 max_bc_queue_len_requested = 0;
+
+	list_for_each_entry_rcu(vlan, &port->vlans, list) {
+		if (vlan->bc_queue_len_requested > max_bc_queue_len_requested)
+			max_bc_queue_len_requested = vlan->bc_queue_len_requested;
+	}
+	port->bc_queue_len_used = max_bc_queue_len_requested;
+}
+
 static int macvlan_device_event(struct notifier_block *unused,
 				unsigned long event, void *ptr)
 {
diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
index a367ead4bf4b..c3923fdbe1f0 100644
--- a/include/linux/if_macvlan.h
+++ b/include/linux/if_macvlan.h
@@ -30,6 +30,7 @@ struct macvlan_dev {
 	enum macvlan_mode	mode;
 	u16			flags;
 	unsigned int		macaddr_count;
+	u32			bc_queue_len_requested;
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	struct netpoll		*netpoll;
 #endif
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index c4b23f06f69e..874cc12a34d9 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -588,6 +588,8 @@ enum {
 	IFLA_MACVLAN_MACADDR,
 	IFLA_MACVLAN_MACADDR_DATA,
 	IFLA_MACVLAN_MACADDR_COUNT,
+	IFLA_MACVLAN_BC_QUEUE_LEN,
+	IFLA_MACVLAN_BC_QUEUE_LEN_USED,
 	__IFLA_MACVLAN_MAX,
 };
 
diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index 781e482dc499..d208b2af697f 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -409,6 +409,8 @@ enum {
 	IFLA_MACVLAN_MACADDR,
 	IFLA_MACVLAN_MACADDR_DATA,
 	IFLA_MACVLAN_MACADDR_COUNT,
+	IFLA_MACVLAN_BC_QUEUE_LEN,
+	IFLA_MACVLAN_BC_QUEUE_LEN_USED,
 	__IFLA_MACVLAN_MAX,
 };
 
-- 
2.29.2

