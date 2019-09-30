Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1FDDC1E68
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 11:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730567AbfI3Jsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 05:48:30 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54145 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726504AbfI3Js3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 05:48:29 -0400
Received: by mail-wm1-f67.google.com with SMTP id i16so12605004wmd.3
        for <netdev@vger.kernel.org>; Mon, 30 Sep 2019 02:48:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wjgYThXkeuJ/jW5QTdoLaEsPOdlOjsA/SlKrYUigfqU=;
        b=oE+TkcpKL0zEibxSUYZAAxnZAhd/hHP8okDiZt4fNoWKAAc0L91J8mJIfliVhCtiY3
         ve90j9mBjtygbEZbJClL61sHaZzCKFo067KjBy7BbuLTCH1bl1JUCpjOC3uNOlikpKd/
         B5322BxQlpx6OMVrkaUNnPw4Tl3qJ7ZsQHC84DbKiKnus915XTC/A3egEtdBTEWqGoKj
         5kJlmv4OOUchigOIHCNxaGEexbWCaaTn8I5rMIKJVNeMuAzOttuNrvkOsOPQpTeBgM33
         2+keC4Gdrpeds6SEMAoqMnafL03zqYz8G0TKqiWjEH9gQyR66TkGlVbwLvZTR7b98pE1
         FfYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wjgYThXkeuJ/jW5QTdoLaEsPOdlOjsA/SlKrYUigfqU=;
        b=XouU/sp7pZ2kjgxOTxw1sfoyaZpQ9vq3JaEbo76U5DwhFjhbank2EMfmda5U/jghGw
         JLTsaO/SMEHifU+7PdmToAtvHpNfdzXLn147HrmVV9KBfm+oHUM5cXQFAjdcydgDJvTi
         oc44MxJ3c1o8wx5/n8O09afd5WK8ZcamUHDFvQJRuE90KvxSjle/OD2ZjRB5DY9SV/fi
         aWY9mwUPUv9OVLrGskRu77XyZbfL9RANR81cdQWGwX3o41MTL5KH6Y5+iZrzXcdMEIZo
         uY4YvNAdnWbIcMrWS/RlX5aprtBvP8bF0B4Spy83yg3k/uHop1bC9Ciz0NACWq0Un85o
         hBpw==
X-Gm-Message-State: APjAAAUkKq1r0GpeZ4FI7UBUWnX1oJAJh1Tok0iQcgxQ01xxsTt++XYE
        i4oBEQs+mTLDIa950rKQ/MqxQ4m3jn8=
X-Google-Smtp-Source: APXvYqzaRQ5RWNAE+t3UlQpucPPk+MBnBO1KAjbRu/mVMrTA+DDY5nxCuEmVao1YQCnbXDi7E5D4qw==
X-Received: by 2002:a7b:c353:: with SMTP id l19mr15481600wmj.173.1569836905179;
        Mon, 30 Sep 2019 02:48:25 -0700 (PDT)
Received: from localhost (ip-89-177-132-96.net.upcbroadband.cz. [89.177.132.96])
        by smtp.gmail.com with ESMTPSA id f83sm16134141wmf.43.2019.09.30.02.48.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2019 02:48:24 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com, dcbw@redhat.com,
        nikolay@cumulusnetworks.com, mkubecek@suse.cz, andrew@lunn.ch,
        parav@mellanox.com, saeedm@mellanox.com, f.fainelli@gmail.com,
        stephen@networkplumber.org, sd@queasysnail.net, sbrivio@redhat.com,
        pabeni@redhat.com, mlxsw@mellanox.com
Subject: [patch net-next 3/7] net: rtnetlink: add linkprop commands to add and delete alternative ifnames
Date:   Mon, 30 Sep 2019 11:48:16 +0200
Message-Id: <20190930094820.11281-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190930094820.11281-1-jiri@resnulli.us>
References: <20190930094820.11281-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add two commands to add and delete list of link properties. Implement
the first property type along - alternative ifnames.
Each net device can have multiple alternative names.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
rfc->v1:
- make netdev_name_node_alt_create/destroy() char *name arg const
- converted the patch to add/del list of link properties
---
 include/linux/netdevice.h      |   4 ++
 include/uapi/linux/if.h        |   1 +
 include/uapi/linux/if_link.h   |   2 +
 include/uapi/linux/rtnetlink.h |   7 +++
 net/core/dev.c                 |  58 ++++++++++++++++++-
 net/core/rtnetlink.c           | 103 +++++++++++++++++++++++++++++++++
 security/selinux/nlmsgtab.c    |   4 +-
 7 files changed, 177 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e92bc5467256..48cc71aae466 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -927,10 +927,14 @@ struct tlsdev_ops;
 
 struct netdev_name_node {
 	struct hlist_node hlist;
+	struct list_head list;
 	struct net_device *dev;
 	const char *name;
 };
 
+int netdev_name_node_alt_create(struct net_device *dev, const char *name);
+int netdev_name_node_alt_destroy(struct net_device *dev, const char *name);
+
 /*
  * This structure defines the management hooks for network devices.
  * The following hooks can be defined; unless noted otherwise, they are
diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
index 7fea0fd7d6f5..4bf33344aab1 100644
--- a/include/uapi/linux/if.h
+++ b/include/uapi/linux/if.h
@@ -33,6 +33,7 @@
 #define	IFNAMSIZ	16
 #endif /* __UAPI_DEF_IF_IFNAMSIZ */
 #define	IFALIASZ	256
+#define	ALTIFNAMSIZ	128
 #include <linux/hdlc/ioctl.h>
 
 /* For glibc compatibility. An empty enum does not compile. */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 4a8c02cafa9a..8aec8769d944 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -167,6 +167,8 @@ enum {
 	IFLA_NEW_IFINDEX,
 	IFLA_MIN_MTU,
 	IFLA_MAX_MTU,
+	IFLA_PROP_LIST,
+	IFLA_ALT_IFNAME, /* Alternative ifname */
 	__IFLA_MAX
 };
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index ce2a623abb75..1418a8362bb7 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -164,6 +164,13 @@ enum {
 	RTM_GETNEXTHOP,
 #define RTM_GETNEXTHOP	RTM_GETNEXTHOP
 
+	RTM_NEWLINKPROP = 108,
+#define RTM_NEWLINKPROP	RTM_NEWLINKPROP
+	RTM_DELLINKPROP,
+#define RTM_DELLINKPROP	RTM_DELLINKPROP
+	RTM_GETLINKPROP,
+#define RTM_GETLINKPROP	RTM_GETLINKPROP
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index b9088dee0701..36e139793e8e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -245,7 +245,13 @@ static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
 static struct netdev_name_node *
 netdev_name_node_head_alloc(struct net_device *dev)
 {
-	return netdev_name_node_alloc(dev, dev->name);
+	struct netdev_name_node *name_node;
+
+	name_node = netdev_name_node_alloc(dev, dev->name);
+	if (!name_node)
+		return NULL;
+	INIT_LIST_HEAD(&name_node->list);
+	return name_node;
 }
 
 static void netdev_name_node_free(struct netdev_name_node *name_node)
@@ -289,6 +295,55 @@ static struct netdev_name_node *netdev_name_node_lookup_rcu(struct net *net,
 	return NULL;
 }
 
+int netdev_name_node_alt_create(struct net_device *dev, const char *name)
+{
+	struct netdev_name_node *name_node;
+	struct net *net = dev_net(dev);
+
+	name_node = netdev_name_node_lookup(net, name);
+	if (name_node)
+		return -EEXIST;
+	name_node = netdev_name_node_alloc(dev, name);
+	if (!name_node)
+		return -ENOMEM;
+	netdev_name_node_add(net, name_node);
+	/* The node that holds dev->name acts as a head of per-device list. */
+	list_add_tail(&name_node->list, &dev->name_node->list);
+
+	return 0;
+}
+EXPORT_SYMBOL(netdev_name_node_alt_create);
+
+static void __netdev_name_node_alt_destroy(struct netdev_name_node *name_node)
+{
+	list_del(&name_node->list);
+	netdev_name_node_del(name_node);
+	kfree(name_node->name);
+	netdev_name_node_free(name_node);
+}
+
+int netdev_name_node_alt_destroy(struct net_device *dev, const char *name)
+{
+	struct netdev_name_node *name_node;
+	struct net *net = dev_net(dev);
+
+	name_node = netdev_name_node_lookup(net, name);
+	if (!name_node)
+		return -ENOENT;
+	__netdev_name_node_alt_destroy(name_node);
+
+	return 0;
+}
+EXPORT_SYMBOL(netdev_name_node_alt_destroy);
+
+static void netdev_name_node_alt_flush(struct net_device *dev)
+{
+	struct netdev_name_node *name_node, *tmp;
+
+	list_for_each_entry_safe(name_node, tmp, &dev->name_node->list, list)
+		__netdev_name_node_alt_destroy(name_node);
+}
+
 /* Device list insertion */
 static void list_netdevice(struct net_device *dev)
 {
@@ -8317,6 +8372,7 @@ static void rollback_registered_many(struct list_head *head)
 		dev_uc_flush(dev);
 		dev_mc_flush(dev);
 
+		netdev_name_node_alt_flush(dev);
 		netdev_name_node_free(dev->name_node);
 
 		if (dev->netdev_ops->ndo_uninit)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..e13646993d82 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1750,6 +1750,9 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_CARRIER_DOWN_COUNT] = { .type = NLA_U32 },
 	[IFLA_MIN_MTU]		= { .type = NLA_U32 },
 	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
+	[IFLA_PROP_LIST]	= { .type = NLA_NESTED },
+	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
+				    .len = ALTIFNAMSIZ - 1 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -3373,6 +3376,103 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
+			   bool *changed, struct netlink_ext_ack *extack)
+{
+	char *alt_ifname;
+	int err;
+
+	err = nla_validate(attr, attr->nla_len, IFLA_MAX, ifla_policy, extack);
+	if (err)
+		return err;
+
+	alt_ifname = nla_data(attr);
+	if (cmd == RTM_NEWLINKPROP) {
+		alt_ifname = kstrdup(alt_ifname, GFP_KERNEL);
+		if (!alt_ifname)
+			return -ENOMEM;
+		err = netdev_name_node_alt_create(dev, alt_ifname);
+		if (err) {
+			kfree(alt_ifname);
+			return err;
+		}
+	} else if (cmd == RTM_DELLINKPROP) {
+		err = netdev_name_node_alt_destroy(dev, alt_ifname);
+		if (err)
+			return err;
+	} else {
+		WARN_ON(1);
+		return 0;
+	}
+
+	*changed = true;
+	return 0;
+}
+
+static int rtnl_linkprop(int cmd, struct sk_buff *skb, struct nlmsghdr *nlh,
+			 struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlattr *tb[IFLA_MAX + 1];
+	struct net_device *dev;
+	struct ifinfomsg *ifm;
+	bool changed = false;
+	struct nlattr *attr;
+	int err, rem;
+
+	err = nlmsg_parse(nlh, sizeof(*ifm), tb, IFLA_MAX, ifla_policy, extack);
+	if (err)
+		return err;
+
+	err = rtnl_ensure_unique_netns(tb, extack, true);
+	if (err)
+		return err;
+
+	ifm = nlmsg_data(nlh);
+	if (ifm->ifi_index > 0) {
+		dev = __dev_get_by_index(net, ifm->ifi_index);
+	} else if (tb[IFLA_IFNAME]) {
+		char ifname[IFNAMSIZ];
+
+		nla_strlcpy(ifname, tb[IFLA_IFNAME], IFNAMSIZ);
+		dev = __dev_get_by_name(net, ifname);
+	} else {
+		return -EINVAL;
+	}
+
+	if (!dev)
+		return -ENODEV;
+
+	if (!tb[IFLA_PROP_LIST])
+		return 0;
+
+	nla_for_each_nested(attr, tb[IFLA_PROP_LIST], rem) {
+		switch (nla_type(attr)) {
+		case IFLA_ALT_IFNAME:
+			err = rtnl_alt_ifname(cmd, dev, attr, &changed, extack);
+			if (err)
+				return err;
+			break;
+		}
+	}
+
+	if (changed)
+		netdev_state_change(dev);
+	return 0;
+}
+
+static int rtnl_newlinkprop(struct sk_buff *skb, struct nlmsghdr *nlh,
+			    struct netlink_ext_ack *extack)
+{
+	return rtnl_linkprop(RTM_NEWLINKPROP, skb, nlh, extack);
+}
+
+static int rtnl_dellinkprop(struct sk_buff *skb, struct nlmsghdr *nlh,
+			    struct netlink_ext_ack *extack)
+{
+	return rtnl_linkprop(RTM_DELLINKPROP, skb, nlh, extack);
+}
+
 static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	struct net *net = sock_net(skb->sk);
@@ -5331,6 +5431,9 @@ void __init rtnetlink_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETROUTE, NULL, rtnl_dump_all, 0);
 	rtnl_register(PF_UNSPEC, RTM_GETNETCONF, NULL, rtnl_dump_all, 0);
 
+	rtnl_register(PF_UNSPEC, RTM_NEWLINKPROP, rtnl_newlinkprop, NULL, 0);
+	rtnl_register(PF_UNSPEC, RTM_DELLINKPROP, rtnl_dellinkprop, NULL, 0);
+
 	rtnl_register(PF_BRIDGE, RTM_NEWNEIGH, rtnl_fdb_add, NULL, 0);
 	rtnl_register(PF_BRIDGE, RTM_DELNEIGH, rtnl_fdb_del, NULL, 0);
 	rtnl_register(PF_BRIDGE, RTM_GETNEIGH, rtnl_fdb_get, rtnl_fdb_dump, 0);
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 58345ba0528e..c97fdae8f71b 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -83,6 +83,8 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_NEWLINKPROP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELLINKPROP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -166,7 +168,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOP + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_NEWLINKPROP + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.21.0

