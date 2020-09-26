Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDC7279C8C
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727424AbgIZVHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:07:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726426AbgIZVHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 17:07:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMHPU-00GJh7-0s; Sat, 26 Sep 2020 23:07:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 4/7] net: devlink: Add support for port regions
Date:   Sat, 26 Sep 2020 23:06:29 +0200
Message-Id: <20200926210632.3888886-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200926210632.3888886-1-andrew@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow regions to be registered to a devlink port. The same netlink API
is used, but the port index is provided to indicate when a region is a
port region as opposed to a device region.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/devlink.h |  27 +++++
 net/core/devlink.c    | 250 +++++++++++++++++++++++++++++++++++++-----
 2 files changed, 251 insertions(+), 26 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 4883dbae7faf..d9ce317ae060 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -110,6 +110,7 @@ struct devlink_port_attrs {
 struct devlink_port {
 	struct list_head list;
 	struct list_head param_list;
+	struct list_head region_list;
 	struct devlink *devlink;
 	unsigned int index;
 	bool registered;
@@ -573,6 +574,26 @@ struct devlink_region_ops {
 	void *priv;
 };
 
+/**
+ * struct devlink_port_region_ops - Region operations for a port
+ * @name: region name
+ * @destructor: callback used to free snapshot memory when deleting
+ * @snapshot: callback to request an immediate snapshot. On success,
+ *            the data variable must be updated to point to the snapshot data.
+ *            The function will be called while the devlink instance lock is
+ *            held.
+ * @priv: Pointer to driver private data for the region operation
+ */
+struct devlink_port_region_ops {
+	const char *name;
+	void (*destructor)(const void *data);
+	int (*snapshot)(struct devlink_port *port,
+			const struct devlink_port_region_ops *ops,
+			struct netlink_ext_ack *extack,
+			u8 **data);
+	void *priv;
+};
+
 struct devlink_fmsg;
 struct devlink_health_reporter;
 
@@ -1336,7 +1357,13 @@ struct devlink_region *
 devlink_region_create(struct devlink *devlink,
 		      const struct devlink_region_ops *ops,
 		      u32 region_max_snapshots, u64 region_size);
+struct devlink_region *
+devlink_port_region_create(struct devlink_port *port,
+			   const struct devlink_port_region_ops *ops,
+			   u32 region_max_snapshots, u64 region_size);
 void devlink_region_destroy(struct devlink_region *region);
+void devlink_port_region_destroy(struct devlink_region *region);
+
 int devlink_region_snapshot_id_get(struct devlink *devlink, u32 *id);
 void devlink_region_snapshot_id_put(struct devlink *devlink, u32 id);
 int devlink_region_snapshot_create(struct devlink_region *region,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index fc9589eb4115..19d1e07cf9d3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -347,8 +347,12 @@ devlink_sb_tc_index_get_from_info(struct devlink_sb *devlink_sb,
 
 struct devlink_region {
 	struct devlink *devlink;
+	struct devlink_port *port;
 	struct list_head list;
-	const struct devlink_region_ops *ops;
+	union {
+		const struct devlink_region_ops *ops;
+		const struct devlink_port_region_ops *port_ops;
+	};
 	struct list_head snapshot_list;
 	u32 max_snapshots;
 	u32 cur_snapshots;
@@ -374,6 +378,19 @@ devlink_region_get_by_name(struct devlink *devlink, const char *region_name)
 	return NULL;
 }
 
+static struct devlink_region *
+devlink_port_region_get_by_name(struct devlink_port *port,
+				const char *region_name)
+{
+	struct devlink_region *region;
+
+	list_for_each_entry(region, &port->region_list, list)
+		if (!strcmp(region->ops->name, region_name))
+			return region;
+
+	return NULL;
+}
+
 static struct devlink_snapshot *
 devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 {
@@ -3903,6 +3920,11 @@ static int devlink_nl_region_fill(struct sk_buff *msg, struct devlink *devlink,
 	if (err)
 		goto nla_put_failure;
 
+	if (region->port)
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
+				region->port->index))
+			goto nla_put_failure;
+
 	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME, region->ops->name);
 	if (err)
 		goto nla_put_failure;
@@ -3950,6 +3972,11 @@ devlink_nl_region_notify_build(struct devlink_region *region,
 	if (err)
 		goto out_cancel_msg;
 
+	if (region->port)
+		if (nla_put_u32(msg, DEVLINK_ATTR_PORT_INDEX,
+				region->port->index))
+			goto out_cancel_msg;
+
 	err = nla_put_string(msg, DEVLINK_ATTR_REGION_NAME,
 			     region->ops->name);
 	if (err)
@@ -4196,16 +4223,30 @@ static int devlink_nl_cmd_region_get_doit(struct sk_buff *skb,
 					  struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
+	struct devlink_port *port = NULL;
 	struct devlink_region *region;
 	const char *region_name;
 	struct sk_buff *msg;
+	unsigned int index;
 	int err;
 
 	if (!info->attrs[DEVLINK_ATTR_REGION_NAME])
 		return -EINVAL;
 
+	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+		index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
+
+		port = devlink_port_get_by_index(devlink, index);
+		if (!port)
+			return -ENODEV;
+	}
+
 	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
-	region = devlink_region_get_by_name(devlink, region_name);
+	if (port)
+		region = devlink_port_region_get_by_name(port, region_name);
+	else
+		region = devlink_region_get_by_name(devlink, region_name);
+
 	if (!region)
 		return -EINVAL;
 
@@ -4224,10 +4265,75 @@ static int devlink_nl_cmd_region_get_doit(struct sk_buff *skb,
 	return genlmsg_reply(msg, info);
 }
 
+static int devlink_nl_cmd_region_get_port_dumpit(struct sk_buff *msg,
+						 struct netlink_callback *cb,
+						 struct devlink_port *port,
+						 int *idx,
+						 int start)
+{
+	struct devlink_region *region;
+	int err = 0;
+
+	list_for_each_entry(region, &port->region_list, list) {
+		if (*idx < start) {
+			(*idx)++;
+			continue;
+		}
+		err = devlink_nl_region_fill(msg, port->devlink,
+					     DEVLINK_CMD_REGION_GET,
+					     NETLINK_CB(cb->skb).portid,
+					     cb->nlh->nlmsg_seq,
+					     NLM_F_MULTI, region);
+		if (err)
+			goto out;
+		(*idx)++;
+	}
+
+out:
+	return err;
+}
+
+static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
+						    struct netlink_callback *cb,
+						    struct devlink *devlink,
+						    int *idx,
+						    int start)
+{
+	struct devlink_region *region;
+	struct devlink_port *port;
+	int err = 0;
+
+	mutex_lock(&devlink->lock);
+	list_for_each_entry(region, &devlink->region_list, list) {
+		if (*idx < start) {
+			(*idx)++;
+			continue;
+		}
+		err = devlink_nl_region_fill(msg, devlink,
+					     DEVLINK_CMD_REGION_GET,
+					     NETLINK_CB(cb->skb).portid,
+					     cb->nlh->nlmsg_seq,
+					     NLM_F_MULTI, region);
+		if (err)
+			goto out;
+		(*idx)++;
+	}
+
+	list_for_each_entry(port, &devlink->port_list, list) {
+		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, idx,
+							    start);
+		if (err)
+			goto out;
+	}
+
+out:
+	mutex_unlock(&devlink->lock);
+	return err;
+}
+
 static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 					    struct netlink_callback *cb)
 {
-	struct devlink_region *region;
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
@@ -4237,25 +4343,10 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	list_for_each_entry(devlink, &devlink_list, list) {
 		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
 			continue;
-
-		mutex_lock(&devlink->lock);
-		list_for_each_entry(region, &devlink->region_list, list) {
-			if (idx < start) {
-				idx++;
-				continue;
-			}
-			err = devlink_nl_region_fill(msg, devlink,
-						     DEVLINK_CMD_REGION_GET,
-						     NETLINK_CB(cb->skb).portid,
-						     cb->nlh->nlmsg_seq,
-						     NLM_F_MULTI, region);
-			if (err) {
-				mutex_unlock(&devlink->lock);
-				goto out;
-			}
-			idx++;
-		}
-		mutex_unlock(&devlink->lock);
+		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
+							       &idx, start);
+		if (err)
+			goto out;
 	}
 out:
 	mutex_unlock(&devlink_mutex);
@@ -4268,8 +4359,10 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_snapshot *snapshot;
+	struct devlink_port *port = NULL;
 	struct devlink_region *region;
 	const char *region_name;
+	unsigned int index;
 	u32 snapshot_id;
 
 	if (!info->attrs[DEVLINK_ATTR_REGION_NAME] ||
@@ -4279,7 +4372,19 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
 	snapshot_id = nla_get_u32(info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID]);
 
-	region = devlink_region_get_by_name(devlink, region_name);
+	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+		index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
+
+		port = devlink_port_get_by_index(devlink, index);
+		if (!port)
+			return -ENODEV;
+	}
+
+	if (port)
+		region = devlink_port_region_get_by_name(port, region_name);
+	else
+		region = devlink_region_get_by_name(devlink, region_name);
+
 	if (!region)
 		return -EINVAL;
 
@@ -4296,9 +4401,11 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_snapshot *snapshot;
+	struct devlink_port *port = NULL;
 	struct nlattr *snapshot_id_attr;
 	struct devlink_region *region;
 	const char *region_name;
+	unsigned int index;
 	u32 snapshot_id;
 	u8 *data;
 	int err;
@@ -4309,7 +4416,20 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
-	region = devlink_region_get_by_name(devlink, region_name);
+
+	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+		index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
+
+		port = devlink_port_get_by_index(devlink, index);
+		if (!port)
+			return -ENODEV;
+	}
+
+	if (port)
+		region = devlink_port_region_get_by_name(port, region_name);
+	else
+		region = devlink_region_get_by_name(devlink, region_name);
+
 	if (!region) {
 		NL_SET_ERR_MSG_MOD(info->extack, "The requested region does not exist");
 		return -EINVAL;
@@ -4345,7 +4465,12 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	err = region->ops->snapshot(devlink, region->ops, info->extack, &data);
+	if (port)
+		err = region->port_ops->snapshot(port, region->port_ops,
+						 info->extack, &data);
+	else
+		err = region->ops->snapshot(devlink, region->ops,
+					    info->extack, &data);
 	if (err)
 		goto err_snapshot_capture;
 
@@ -4467,10 +4592,12 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	const struct genl_dumpit_info *info = genl_dumpit_info(cb);
 	u64 ret_offset, start_offset, end_offset = U64_MAX;
 	struct nlattr **attrs = info->attrs;
+	struct devlink_port *port = NULL;
 	struct devlink_region *region;
 	struct nlattr *chunks_attr;
 	const char *region_name;
 	struct devlink *devlink;
+	unsigned int index;
 	void *hdr;
 	int err;
 
@@ -4491,8 +4618,21 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 		goto out_unlock;
 	}
 
+	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+		index = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
+
+		port = devlink_port_get_by_index(devlink, index);
+		if (!port)
+			return -ENODEV;
+	}
+
 	region_name = nla_data(attrs[DEVLINK_ATTR_REGION_NAME]);
-	region = devlink_region_get_by_name(devlink, region_name);
+
+	if (port)
+		region = devlink_port_region_get_by_name(port, region_name);
+	else
+		region = devlink_region_get_by_name(devlink, region_name);
+
 	if (!region) {
 		err = -EINVAL;
 		goto out_unlock;
@@ -4529,6 +4669,11 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 	if (err)
 		goto nla_put_failure;
 
+	if (region->port)
+		if (nla_put_u32(skb, DEVLINK_ATTR_PORT_INDEX,
+				region->port->index))
+			goto nla_put_failure;
+
 	err = nla_put_string(skb, DEVLINK_ATTR_REGION_NAME, region_name);
 	if (err)
 		goto nla_put_failure;
@@ -7623,6 +7768,7 @@ int devlink_port_register(struct devlink *devlink,
 	mutex_init(&devlink_port->reporters_lock);
 	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
+	INIT_LIST_HEAD(&devlink_port->region_list);
 	mutex_unlock(&devlink->lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
 	devlink_port_type_warn_schedule(devlink_port);
@@ -7646,6 +7792,7 @@ void devlink_port_unregister(struct devlink_port *devlink_port)
 	list_del(&devlink_port->list);
 	mutex_unlock(&devlink->lock);
 	WARN_ON(!list_empty(&devlink_port->reporter_list));
+	WARN_ON(!list_empty(&devlink_port->region_list));
 	mutex_destroy(&devlink_port->reporters_lock);
 }
 EXPORT_SYMBOL_GPL(devlink_port_unregister);
@@ -8725,6 +8872,57 @@ devlink_region_create(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_region_create);
 
+/**
+ *	devlink_port_region_create - create a new address region for a port
+ *
+ *	@port: devlink port
+ *	@ops: region operations and name
+ *	@region_max_snapshots: Maximum supported number of snapshots for region
+ *	@region_size: size of region
+ */
+struct devlink_region *
+devlink_port_region_create(struct devlink_port *port,
+			   const struct devlink_port_region_ops *ops,
+			   u32 region_max_snapshots, u64 region_size)
+{
+	struct devlink *devlink = port->devlink;
+	struct devlink_region *region;
+	int err = 0;
+
+	if (WARN_ON(!ops) || WARN_ON(!ops->destructor))
+		return ERR_PTR(-EINVAL);
+
+	mutex_lock(&devlink->lock);
+
+	if (devlink_port_region_get_by_name(port, ops->name)) {
+		err = -EEXIST;
+		goto unlock;
+	}
+
+	region = kzalloc(sizeof(*region), GFP_KERNEL);
+	if (!region) {
+		err = -ENOMEM;
+		goto unlock;
+	}
+
+	region->devlink = devlink;
+	region->port = port;
+	region->max_snapshots = region_max_snapshots;
+	region->port_ops = ops;
+	region->size = region_size;
+	INIT_LIST_HEAD(&region->snapshot_list);
+	list_add_tail(&region->list, &port->region_list);
+	devlink_nl_region_notify(region, NULL, DEVLINK_CMD_REGION_NEW);
+
+	mutex_unlock(&devlink->lock);
+	return region;
+
+unlock:
+	mutex_unlock(&devlink->lock);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(devlink_port_region_create);
+
 /**
  *	devlink_region_destroy - destroy address region
  *
-- 
2.28.0

