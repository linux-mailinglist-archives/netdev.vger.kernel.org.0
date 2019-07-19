Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9118F6E4A0
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 13:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfGSLAm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 07:00:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50559 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727516AbfGSLAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 07:00:40 -0400
Received: by mail-wm1-f65.google.com with SMTP id v15so28402193wml.0
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 04:00:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4Ge50GJLJB+ZKejv+wdmPqWVtRwoDTOFbE4Gy6yyR7E=;
        b=m9la+q9evZgvlJu4ThVTrxOYG7TN1AzeMSXB2kNa7/ndbnBVrGBp56eQ+U2NcHxTfq
         ncAemEpDKYV/kVFhLIfnXZHqEoegd8olrpAmmEi86vTlL2WvNViNrY8NGQEvHzgHhu+B
         CHyc12M3wyEwd+QZAL5PAohA2MZf9T6EbyNl1owyXd1bAz/XFPtoYUb4fg41gbnlsu43
         67mRcKNsC4P6Hb/IO8MBeHipQLvUWiskaamGkN1dtxC9J7sU95fwb2iHgIKNKjFdwoE4
         c8tZ6eqf68pYKnDKkeaup9Scu/ggBP9ZxK8TFyUQFbHO5J1eWdztjzk2TQthZUXY4DBF
         iVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4Ge50GJLJB+ZKejv+wdmPqWVtRwoDTOFbE4Gy6yyR7E=;
        b=nQxPejFZz1phahx7QQ8F31sjgXXPTZ1WS87QHErxQAiMG3yUtKFFwzlHF4+MdFrgT+
         vRJe3eeN3A2dKQv+nTzwmI7zyNOJ6bN/QWeFJMChjh3kAdZML3win7CQir7kvRFHwUSG
         MTv8YSUA8SGPXyAwafDvcePGtw6CNGtPv0iCkWErPk0NkS/EJT+KcgSWXI/iT6PH82JA
         XdKG+PZpY1wmNI09zEvLzY2+zKBtSSQSZTIuyXvsr7rQO1gj4QivmSiziVTwGgUN7mMJ
         Rbuiq9iJoBa/EOPJUr4rmfYcHmwgYGU3LBgjAj9oszAM/C9POy0RQ7nisJ8a0LN812L+
         u9OA==
X-Gm-Message-State: APjAAAXOWr9y1ESc3ofscTxkgf8io/QrjP9NcNQxPcdy/ITlEJ02y1th
        DZopHjrI7ChumDJ4LixDhPBFPl9C
X-Google-Smtp-Source: APXvYqwspe92XxfCIWZp3amOzBCjryx/pIqvU/d62qzwuzriMXHkVGleIAo/28nA6Uj6G91FCxpu2A==
X-Received: by 2002:a05:600c:2117:: with SMTP id u23mr47795857wml.117.1563534033508;
        Fri, 19 Jul 2019 04:00:33 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id b203sm34338970wmd.41.2019.07.19.04.00.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 04:00:33 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        sthemmin@microsoft.com, dsahern@gmail.com, dcbw@redhat.com,
        mkubecek@suse.cz, andrew@lunn.ch, parav@mellanox.com,
        saeedm@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and delete alternative ifnames
Date:   Fri, 19 Jul 2019 13:00:25 +0200
Message-Id: <20190719110029.29466-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190719110029.29466-1-jiri@resnulli.us>
References: <20190719110029.29466-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Add two commands to add and delete alternative ifnames for net device.
Each net device can have multiple alternative names.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 include/linux/netdevice.h      |   4 ++
 include/uapi/linux/if.h        |   1 +
 include/uapi/linux/if_link.h   |   1 +
 include/uapi/linux/rtnetlink.h |   7 +++
 net/core/dev.c                 |  58 ++++++++++++++++++-
 net/core/rtnetlink.c           | 102 +++++++++++++++++++++++++++++++++
 security/selinux/nlmsgtab.c    |   4 +-
 7 files changed, 175 insertions(+), 2 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 74f99f127b0e..6922fdb483ca 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -920,10 +920,14 @@ struct tlsdev_ops;
 
 struct netdev_name_node {
 	struct hlist_node hlist;
+	struct list_head list;
 	struct net_device *dev;
 	char *name;
 };
 
+int netdev_name_node_alt_create(struct net_device *dev, char *name);
+int netdev_name_node_alt_destroy(struct net_device *dev, char *name);
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
index 4a8c02cafa9a..92268946e04a 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -167,6 +167,7 @@ enum {
 	IFLA_NEW_IFINDEX,
 	IFLA_MIN_MTU,
 	IFLA_MAX_MTU,
+	IFLA_ALT_IFNAME_MOD, /* Alternative ifname to add/delete */
 	__IFLA_MAX
 };
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index ce2a623abb75..b36cfd83eb76 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -164,6 +164,13 @@ enum {
 	RTM_GETNEXTHOP,
 #define RTM_GETNEXTHOP	RTM_GETNEXTHOP
 
+	RTM_NEWALTIFNAME = 108,
+#define RTM_NEWALTIFNAME	RTM_NEWALTIFNAME
+	RTM_DELALTIFNAME,
+#define RTM_DELALTIFNAME	RTM_DELALTIFNAME
+	RTM_GETALTIFNAME,
+#define RTM_GETALTIFNAME	RTM_GETALTIFNAME
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/net/core/dev.c b/net/core/dev.c
index ad0d42fbdeee..2a3be2b279d3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -244,7 +244,13 @@ static struct netdev_name_node *netdev_name_node_alloc(struct net_device *dev,
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
@@ -288,6 +294,55 @@ static struct netdev_name_node *netdev_name_node_lookup_rcu(struct net *net,
 	return NULL;
 }
 
+int netdev_name_node_alt_create(struct net_device *dev, char *name)
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
+int netdev_name_node_alt_destroy(struct net_device *dev, char *name)
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
@@ -8258,6 +8313,7 @@ static void rollback_registered_many(struct list_head *head)
 		dev_uc_flush(dev);
 		dev_mc_flush(dev);
 
+		netdev_name_node_alt_flush(dev);
 		netdev_name_node_free(dev->name_node);
 
 		if (dev->netdev_ops->ndo_uninit)
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..7a2010b16e10 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1750,6 +1750,8 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_CARRIER_DOWN_COUNT] = { .type = NLA_U32 },
 	[IFLA_MIN_MTU]		= { .type = NLA_U32 },
 	[IFLA_MAX_MTU]		= { .type = NLA_U32 },
+	[IFLA_ALT_IFNAME_MOD]	= { .type = NLA_STRING,
+				    .len = ALTIFNAMSIZ - 1 },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -3373,6 +3375,103 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int rtnl_newaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
+			     struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlattr *tb[IFLA_MAX + 1];
+	struct net_device *dev;
+	struct ifinfomsg *ifm;
+	char *new_alt_ifname;
+	int err;
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
+	if (!tb[IFLA_ALT_IFNAME_MOD])
+		return -EINVAL;
+
+	new_alt_ifname = nla_strdup(tb[IFLA_ALT_IFNAME_MOD], GFP_KERNEL);
+	if (!new_alt_ifname)
+		return -ENOMEM;
+
+	err = netdev_name_node_alt_create(dev, new_alt_ifname);
+	if (err)
+		goto out_free_new_alt_ifname;
+
+	return 0;
+
+out_free_new_alt_ifname:
+	kfree(new_alt_ifname);
+	return err;
+}
+
+static int rtnl_delaltifname(struct sk_buff *skb, struct nlmsghdr *nlh,
+			     struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlattr *tb[IFLA_MAX + 1];
+	struct net_device *dev;
+	struct ifinfomsg *ifm;
+	char *del_alt_ifname;
+	int err;
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
+	if (!tb[IFLA_ALT_IFNAME_MOD])
+		return -EINVAL;
+
+	del_alt_ifname = nla_strdup(tb[IFLA_ALT_IFNAME_MOD], GFP_KERNEL);
+	if (!del_alt_ifname)
+		return -ENOMEM;
+
+	err = netdev_name_node_alt_destroy(dev, del_alt_ifname);
+	kfree(del_alt_ifname);
+
+	return err;
+}
+
 static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	struct net *net = sock_net(skb->sk);
@@ -5331,6 +5430,9 @@ void __init rtnetlink_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETROUTE, NULL, rtnl_dump_all, 0);
 	rtnl_register(PF_UNSPEC, RTM_GETNETCONF, NULL, rtnl_dump_all, 0);
 
+	rtnl_register(PF_UNSPEC, RTM_NEWALTIFNAME, rtnl_newaltifname, NULL, 0);
+	rtnl_register(PF_UNSPEC, RTM_DELALTIFNAME, rtnl_delaltifname, NULL, 0);
+
 	rtnl_register(PF_BRIDGE, RTM_NEWNEIGH, rtnl_fdb_add, NULL, 0);
 	rtnl_register(PF_BRIDGE, RTM_DELNEIGH, rtnl_fdb_del, NULL, 0);
 	rtnl_register(PF_BRIDGE, RTM_GETNEIGH, rtnl_fdb_get, rtnl_fdb_dump, 0);
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 58345ba0528e..a712b54c666c 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -83,6 +83,8 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETNEXTHOP,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_NEWALTIFNAME,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELALTIFNAME,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] =
@@ -166,7 +168,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWNEXTHOP + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_NEWALTIFNAME + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.21.0

