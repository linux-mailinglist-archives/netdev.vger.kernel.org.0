Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4EB399B27
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhFCHBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:01:24 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46920 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhFCHBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:01:13 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id ADADE219EB; Thu,  3 Jun 2021 14:52:30 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH RFC net-next 06/16] mctp: Add device handling and netlink interface
Date:   Thu,  3 Jun 2021 14:52:08 +0800
Message-Id: <20210603065218.570867-7-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603065218.570867-1-jk@codeconstruct.com.au>
References: <20210603065218.570867-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change adds the infrastructure for managing MCTP netdevices; we add
a pointer to the AF_MCTP-specific data to struct netdevice, and hook up
the rtnetlink operations for adding and removing addresses.

Includes changes from Matt Johnston <matt@codeconstruct.com.au>.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 MAINTAINERS                   |   1 +
 include/linux/netdevice.h     |   3 +
 include/net/mctp.h            |  14 ++
 include/net/mctpdevice.h      |  41 ++++
 include/uapi/linux/if_ether.h |   3 +
 include/uapi/linux/if_link.h  |  10 +
 include/uapi/linux/mctp.h     |   1 +
 net/mctp/Makefile             |   2 +-
 net/mctp/af_mctp.c            |   8 +
 net/mctp/device.c             | 367 ++++++++++++++++++++++++++++++++++
 10 files changed, 449 insertions(+), 1 deletion(-)
 create mode 100644 include/net/mctpdevice.h
 create mode 100644 net/mctp/device.c

diff --git a/MAINTAINERS b/MAINTAINERS
index d3114697601b..2a12c7386986 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -10876,6 +10876,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/mctp/
 F:	include/net/mctp.h
+F:	include/net/mctpdevice.h
 F:	net/mctp/
 
 MAN-PAGES: MANUAL PAGES FOR LINUX -- Sections 2, 3, 4, 5, and 7
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..a37e119460fe 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2092,6 +2092,9 @@ struct net_device {
 #if IS_ENABLED(CONFIG_MPLS_ROUTING)
 	struct mpls_dev __rcu	*mpls_ptr;
 #endif
+#if IS_ENABLED(CONFIG_MCTP)
+	struct mctp_dev __rcu	*mctp_ptr;
+#endif
 
 /*
  * Cache lines mostly used on receive path (including eth_type_trans())
diff --git a/include/net/mctp.h b/include/net/mctp.h
index 757304d98c0a..24d02fa96425 100644
--- a/include/net/mctp.h
+++ b/include/net/mctp.h
@@ -10,6 +10,7 @@
 #define __NET_MCTP_H
 
 #include <linux/bits.h>
+#include <linux/mctp.h>
 
 /* MCTP packet definitions */
 struct mctp_hdr {
@@ -32,4 +33,17 @@ struct mctp_hdr {
 #define MCTP_HDR_TAG_SHIFT	0
 #define MCTP_HDR_TAG_MASK	GENMASK(2, 0)
 
+static inline bool mctp_address_ok(mctp_eid_t eid)
+{
+	return eid >= 8 && eid < 255;
+}
+
+static inline struct mctp_hdr *mctp_hdr(struct sk_buff *skb)
+{
+	return (struct mctp_hdr *)skb_network_header(skb);
+}
+
+void mctp_device_init(void);
+void mctp_device_exit(void);
+
 #endif /* __NET_MCTP_H */
diff --git a/include/net/mctpdevice.h b/include/net/mctpdevice.h
new file mode 100644
index 000000000000..a6ac4aee5d7b
--- /dev/null
+++ b/include/net/mctpdevice.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Management Controller Transport Protocol (MCTP) - device
+ * definitions.
+ *
+ * Copyright (c) 2021 Code Construct
+ * Copyright (c) 2021 Google
+ */
+
+#ifndef __NET_MCTPDEVICE_H
+#define __NET_MCTPDEVICE_H
+
+#include <linux/list.h>
+#include <linux/types.h>
+#include <linux/refcount.h>
+
+struct mctp_ifaddr {
+	u8			eid;
+
+	struct mctp_dev		*dev;
+	struct list_head	dev_list;
+
+	struct rcu_head		rcu;
+};
+
+struct mctp_dev {
+	struct net_device	*dev;
+
+	unsigned int		net;
+
+	struct list_head	addrs; /* -> mctp_ifaddr.dev_list */
+
+	struct rcu_head		rcu;
+};
+
+#define MCTP_INITIAL_DEFAULT_NET	1
+
+struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev);
+struct mctp_dev *__mctp_dev_get(const struct net_device *dev);
+
+#endif /* __NET_MCTPDEVICE_H */
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index a0b637911d3c..cf3fbfec716a 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -151,6 +151,9 @@
 #define ETH_P_MAP	0x00F9		/* Qualcomm multiplexing and
 					 * aggregation protocol
 					 */
+#define ETH_P_MCTP	0x00FA		/* Management controller transport
+					 * protocol packets
+					 */
 
 /*
  *	This is an Ethernet frame header.
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index cd5b382a4138..a4543ddf98f4 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1251,4 +1251,14 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
+/* MCTP section */
+
+enum {
+	IFLA_MCTP_UNSPEC,
+	IFLA_MCTP_NET,
+	__IFLA_MCTP_MAX,
+};
+
+#define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
diff --git a/include/uapi/linux/mctp.h b/include/uapi/linux/mctp.h
index a9f6c6744b27..f973e9bb5d4e 100644
--- a/include/uapi/linux/mctp.h
+++ b/include/uapi/linux/mctp.h
@@ -26,6 +26,7 @@ struct sockaddr_mctp {
 };
 
 #define MCTP_NET_ANY		0x0
+#define MCTP_NET_DEFAULT	0x0
 
 #define MCTP_ADDR_ANY		0xff
 
diff --git a/net/mctp/Makefile b/net/mctp/Makefile
index 7c056b1b7939..2ea98c27b262 100644
--- a/net/mctp/Makefile
+++ b/net/mctp/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_MCTP) += mctp.o
-mctp-objs := af_mctp.o
+mctp-objs := af_mctp.o device.o
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index 3946e5dbe12d..d77955eee21b 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -6,13 +6,18 @@
  * Copyright (c) 2021 Google
  */
 
+#include <linux/if_arp.h>
 #include <linux/net.h>
 #include <linux/mctp.h>
 #include <linux/module.h>
 #include <linux/socket.h>
 
+#include <net/mctp.h>
+#include <net/mctpdevice.h>
 #include <net/sock.h>
 
+/* socket implementation */
+
 struct mctp_sock {
 	struct sock	sk;
 };
@@ -152,6 +157,8 @@ static __init int mctp_init(void)
 	if (rc)
 		goto err_unreg_sock;
 
+	mctp_device_init();
+
 	return 0;
 
 err_unreg_sock:
@@ -162,6 +169,7 @@ static __init int mctp_init(void)
 
 static __exit void mctp_exit(void)
 {
+	mctp_device_exit();
 	proto_unregister(&mctp_proto);
 	sock_unregister(PF_MCTP);
 }
diff --git a/net/mctp/device.c b/net/mctp/device.c
new file mode 100644
index 000000000000..988936936693
--- /dev/null
+++ b/net/mctp/device.c
@@ -0,0 +1,367 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Management Controller Transport Protocol (MCTP) - device implementation.
+ *
+ * Copyright (c) 2021 Code Construct
+ * Copyright (c) 2021 Google
+ */
+
+#include <linux/if_link.h>
+#include <linux/mctp.h>
+#include <linux/netdevice.h>
+#include <linux/rcupdate.h>
+#include <linux/rtnetlink.h>
+
+#include <net/addrconf.h>
+#include <net/netlink.h>
+#include <net/mctp.h>
+#include <net/mctpdevice.h>
+#include <net/sock.h>
+
+/* unlocked: caller must hold rcu_read_lock */
+struct mctp_dev *__mctp_dev_get(const struct net_device *dev)
+{
+	return rcu_dereference(dev->mctp_ptr);
+}
+
+struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev)
+{
+	return rtnl_dereference(dev->mctp_ptr);
+}
+
+static void mctp_dev_destroy(struct mctp_dev *mdev)
+{
+	struct net_device *dev = mdev->dev;
+
+	dev_put(dev);
+	kfree_rcu(mdev, rcu);
+}
+
+static int mctp_fill_addrinfo(struct sk_buff *skb, struct netlink_callback *cb,
+			      struct mctp_dev *mdev, struct mctp_ifaddr *ifa)
+{
+	struct ifaddrmsg *hdr;
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+			RTM_NEWADDR, sizeof(*hdr), NLM_F_MULTI);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	hdr = nlmsg_data(nlh);
+	hdr->ifa_family = AF_MCTP;
+	hdr->ifa_prefixlen = 0;
+	hdr->ifa_flags = 0;
+	hdr->ifa_scope = 0;
+	hdr->ifa_index = mdev->dev->ifindex;
+
+	if (nla_put_u8(skb, IFA_LOCAL, ifa->eid))
+		goto cancel;
+
+	if (nla_put_u8(skb, IFA_ADDRESS, ifa->eid))
+		goto cancel;
+
+	nlmsg_end(skb, nlh);
+
+	return 0;
+
+cancel:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
+static int mctp_dump_dev_addrinfo(struct mctp_dev *mdev, struct sk_buff *skb,
+				  struct netlink_callback *cb, int s_a_idx)
+{
+	struct mctp_ifaddr *ifa;
+	int a_idx = 0;
+
+	list_for_each_entry(ifa, &mdev->addrs, dev_list) {
+		if (a_idx < s_a_idx)
+			goto next;
+
+		if (mctp_fill_addrinfo(skb, cb, mdev, ifa) < 0)
+			break;
+
+next:
+		a_idx++;
+	}
+
+	return 0;
+
+	cb->args[2] = a_idx;
+}
+
+static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct net_device *dev;
+	struct mctp_dev *mdev;
+	struct hlist_head *head;
+	int s_h, s_idx, s_a_idx;
+	int h, idx;
+
+	/* todo: change to struct overlay */
+	s_h = cb->args[0];
+	s_idx = cb->args[1];
+	s_a_idx = cb->args[2];
+
+	/* todo: strict check -> filter by dev */
+
+	rcu_read_lock();
+	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
+		idx = 0;
+		head = &net->dev_index_head[h];
+		hlist_for_each_entry_rcu(dev, head, index_hlist) {
+			if (idx < s_idx)
+				goto cont;
+			mdev = __mctp_dev_get(dev);
+			if (!mdev)
+				goto cont;
+			if (h > s_h || idx > s_idx)
+				s_a_idx = 0;
+			if (mctp_dump_dev_addrinfo(mdev, skb, cb, s_a_idx) < 0)
+				goto out;
+cont:
+			idx++;
+		}
+	}
+out:
+	rcu_read_unlock();
+	cb->args[1] = idx;
+	cb->args[0] = h;
+
+	return skb->len;
+}
+
+static const struct nla_policy ifa_mctp_policy[IFA_MAX + 1] = {
+	[IFA_ADDRESS]		= { .type = NLA_U8 },
+	[IFA_LOCAL]		= { .type = NLA_U8 },
+};
+
+static int mctp_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
+			    struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlattr *tb[IFA_MAX + 1];
+	struct mctp_ifaddr *ifaddr;
+	struct net_device *dev;
+	struct mctp_addr *addr;
+	struct mctp_dev *mdev;
+	struct ifaddrmsg *ifm;
+	int rc;
+
+	rc = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, ifa_mctp_policy,
+			 extack);
+	if (rc < 0)
+		return rc;
+
+	ifm = nlmsg_data(nlh);
+
+	if (tb[IFA_LOCAL])
+		addr = nla_data(tb[IFA_LOCAL]);
+	else if (tb[IFA_ADDRESS])
+		addr = nla_data(tb[IFA_ADDRESS]);
+	else
+		return -EINVAL;
+
+	/* find device */
+	dev = __dev_get_by_index(net, ifm->ifa_index);
+	if (!dev)
+		return -ENODEV;
+
+	mdev = mctp_dev_get_rtnl(dev);
+	if (!mdev)
+		return -ENODEV;
+
+	if (!mctp_address_ok(addr->s_addr))
+		return -EINVAL;
+
+	/* Prevent duplicates */
+	list_for_each_entry(ifaddr, &mdev->addrs, dev_list) {
+		if (ifaddr->eid == addr->s_addr)
+			return -EEXIST;
+	}
+
+	ifaddr = kzalloc(sizeof(*ifaddr), GFP_KERNEL);
+	if (!ifaddr)
+		return -ENOMEM;
+
+	ifaddr->eid = addr->s_addr;
+	ifaddr->dev = mdev;
+	list_add(&ifaddr->dev_list, &mdev->addrs);
+
+	return 0;
+}
+
+static struct mctp_dev *mctp_add_dev(struct net_device *dev)
+{
+	struct mctp_dev *mdev;
+
+	ASSERT_RTNL();
+
+	mdev = kzalloc(sizeof(*mdev), GFP_KERNEL);
+	if (!mdev)
+		return ERR_PTR(ENOMEM);
+
+	INIT_LIST_HEAD(&mdev->addrs);
+
+	mdev->net = MCTP_INITIAL_DEFAULT_NET;
+
+	/* associate to net_device */
+	rcu_assign_pointer(dev->mctp_ptr, mdev);
+	dev_hold(dev);
+	mdev->dev = dev;
+
+	return mdev;
+}
+
+static int mctp_fill_link_af(struct sk_buff *skb,
+			     const struct net_device *dev, u32 ext_filter_mask)
+{
+	struct mctp_dev *mdev;
+
+	mdev = mctp_dev_get_rtnl(dev);
+	if (!mdev)
+		return -ENODATA;
+	if (nla_put_u32(skb, IFLA_MCTP_NET, mdev->net))
+		return -EMSGSIZE;
+	return 0;
+}
+
+static size_t mctp_get_link_af_size(const struct net_device *dev,
+				    u32 ext_filter_mask)
+{
+	struct mctp_dev *mdev;
+	unsigned int ret;
+
+	/* caller holds RCU */
+	mdev = __mctp_dev_get(dev);
+	if (!mdev)
+		return 0;
+	ret = nla_total_size(4); /* IFLA_MCTP_NET */
+	return ret;
+}
+
+static const struct nla_policy ifla_af_mctp_policy[IFLA_MCTP_MAX + 1] = {
+	[IFLA_MCTP_NET]		= { .type = NLA_U32 },
+};
+
+static int mctp_set_link_af(struct net_device *dev, const struct nlattr *attr,
+			    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_MCTP_MAX + 1];
+	struct mctp_dev *mdev;
+	int rc;
+
+	rc = nla_parse_nested(tb, IFLA_MCTP_MAX, attr, ifla_af_mctp_policy,
+			      NULL);
+	if (rc)
+		return rc;
+
+	/* caller holds RCU */
+	mdev = __mctp_dev_get(dev);
+	if (!mdev)
+		return 0;
+
+	if (tb[IFLA_MCTP_NET])
+		WRITE_ONCE(mdev->net, nla_get_u32(tb[IFLA_MCTP_NET]));
+
+	return 0;
+}
+
+static void mctp_unregister(struct net_device *dev)
+{
+	struct mctp_ifaddr *ifa, *tmp;
+	struct mctp_dev *mdev;
+
+	mdev = mctp_dev_get_rtnl(dev);
+
+	if (!mdev)
+		return;
+
+	RCU_INIT_POINTER(mdev->dev->mctp_ptr, NULL);
+
+	/* TODO: drop routes, to the point where we can dev_put(); requires
+	 * coordination with the route layer; each route should hold a dev
+	 * reference. We should only need to synchronize_rcu() once for this.
+	 */
+	list_for_each_entry_safe(ifa, tmp, &mdev->addrs, dev_list) {
+		list_del_rcu(&ifa->dev_list);
+		kfree_rcu(ifa, rcu);
+	}
+
+	mctp_dev_destroy(mdev);
+}
+
+static int mctp_register(struct net_device *dev)
+{
+	struct mctp_dev *mdev;
+
+	/* Already registered? */
+	if (rtnl_dereference(dev->mctp_ptr))
+		return 0;
+
+	/* only register specific types; MCTP-specific and loopback for now */
+	if (dev->type != ARPHRD_MCTP && dev->type != ARPHRD_LOOPBACK)
+		return 0;
+
+	mdev = mctp_add_dev(dev);
+	if (IS_ERR(mdev))
+		return PTR_ERR(mdev);
+
+	return 0;
+}
+
+static int mctp_dev_notify(struct notifier_block *this, unsigned long event,
+			   void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	int rc;
+
+	switch (event) {
+	case NETDEV_REGISTER:
+		rc = mctp_register(dev);
+		if (rc)
+			return notifier_from_errno(rc);
+		break;
+	case NETDEV_UNREGISTER:
+		mctp_unregister(dev);
+		break;
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct rtnl_af_ops mctp_af_ops = {
+	.family = AF_MCTP,
+	.fill_link_af = mctp_fill_link_af,
+	.get_link_af_size = mctp_get_link_af_size,
+	.set_link_af = mctp_set_link_af,
+};
+
+static struct notifier_block mctp_dev_nb = {
+	.notifier_call = mctp_dev_notify,
+	.priority = ADDRCONF_NOTIFY_PRIORITY,
+};
+
+void __init mctp_device_init(void)
+{
+	register_netdevice_notifier(&mctp_dev_nb);
+
+	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_GETADDR,
+			     NULL, mctp_dump_addrinfo, 0);
+	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_NEWADDR,
+			     mctp_rtm_newaddr, NULL, 0);
+	rtnl_af_register(&mctp_af_ops);
+}
+
+void __exit mctp_device_exit(void)
+{
+	rtnl_af_unregister(&mctp_af_ops);
+	rtnl_unregister(PF_MCTP, RTM_NEWADDR);
+	rtnl_unregister(PF_MCTP, RTM_GETADDR);
+	rtnl_unregister(PF_MCTP, RTM_GETLINK);
+
+	unregister_netdevice_notifier(&mctp_dev_nb);
+}
-- 
2.30.2

