Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C68F50DE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727319AbfKHQS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:18:59 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60235 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726095AbfKHQS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:18:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:18:53 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GIpYO003113;
        Fri, 8 Nov 2019 18:18:52 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GIp1F030081;
        Fri, 8 Nov 2019 18:18:51 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GIpHI030080;
        Fri, 8 Nov 2019 18:18:51 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 01/10] devlink: Introduce subdev
Date:   Fri,  8 Nov 2019 18:18:37 +0200
Message-Id: <1573229926-30040-2-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subdev represents a device that exists on the ASIC which is not necessarily
visible to the kernel.
Just like devlink port, the driver should set index and attributes to
the subdev.

Example:
A VF represented by subdev pci/0000:03:00.0/1, before it is enabled.
The PF subdev is represented by pci/0000:03:00.0/0.

$ devlink dev show
pci/0000:03:00.0

$ devlink subdev show
pci/0000:03:00.0/0
pci/0000:03:00.0/1

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Suggested-by: Parav Pandit <parav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h        |  18 +++
 include/uapi/linux/devlink.h |   7 +
 net/core/devlink.c           | 261 +++++++++++++++++++++++++++++++++++
 3 files changed, 286 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 6bf3b9e0595a..9d6b50b906ee 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -23,6 +23,7 @@ struct devlink_ops;
 struct devlink {
 	struct list_head list;
 	struct list_head port_list;
+	struct list_head subdev_list;
 	struct list_head sb_list;
 	struct list_head dpipe_table_list;
 	struct list_head resource_list;
@@ -73,6 +74,8 @@ struct devlink_port_attrs {
 	};
 };
 
+struct devlink_subdev;
+
 struct devlink_port {
 	struct list_head list;
 	struct list_head param_list;
@@ -89,6 +92,9 @@ struct devlink_port {
 	struct delayed_work type_warn_dw;
 };
 
+struct devlink_subdev_attrs {
+};
+
 struct devlink_sb_pool_info {
 	enum devlink_sb_pool_type pool_type;
 	u32 size;
@@ -743,6 +749,9 @@ struct devlink_ops {
 			       const struct devlink_trap_group *group);
 };
 
+struct devlink_subdev_ops {
+};
+
 static inline void *devlink_priv(struct devlink *devlink)
 {
 	BUG_ON(!devlink);
@@ -802,6 +811,15 @@ void devlink_port_attrs_pci_vf_set(struct devlink_port *devlink_port,
 				   const unsigned char *switch_id,
 				   unsigned char switch_id_len,
 				   u16 pf, u16 vf);
+struct devlink_subdev *
+devlink_subdev_create(struct devlink *devlink,
+		      unsigned int subdev_index,
+		      const struct devlink_subdev_ops *ops,
+		      const struct devlink_subdev_attrs *attrs,
+		      void *priv);
+void devlink_subdev_destroy(struct devlink_subdev *devlink_subdev);
+struct devlink *devlink_subdev_devlink(struct devlink_subdev *devlink_subdev);
+void *devlink_subdev_priv(struct devlink_subdev *devlink_subdev);
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index b558ea88b766..df894091f26a 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -117,6 +117,11 @@ enum devlink_command {
 	DEVLINK_CMD_TRAP_GROUP_NEW,
 	DEVLINK_CMD_TRAP_GROUP_DEL,
 
+	DEVLINK_CMD_SUBDEV_GET,		/* can dump */
+	DEVLINK_CMD_SUBDEV_SET,
+	DEVLINK_CMD_SUBDEV_NEW,
+	DEVLINK_CMD_SUBDEV_DEL,
+
 	/* add new commands above here */
 	__DEVLINK_CMD_MAX,
 	DEVLINK_CMD_MAX = __DEVLINK_CMD_MAX - 1
@@ -425,6 +430,8 @@ enum devlink_attr {
 	DEVLINK_ATTR_NETNS_PID,			/* u32 */
 	DEVLINK_ATTR_NETNS_ID,			/* u32 */
 
+	DEVLINK_ATTR_SUBDEV_INDEX,		/* u32 */
+
 	/* add new attributes above here, update the policy in devlink.c */
 
 	__DEVLINK_ATTR_MAX,
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 97e9a2246929..5ab2fc2f2d82 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -31,6 +31,15 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/devlink.h>
 
+struct devlink_subdev {
+	struct list_head list;
+	struct devlink *devlink;
+	unsigned int index;
+	const struct devlink_subdev_ops *ops;
+	struct devlink_subdev_attrs attrs;
+	void *priv;
+};
+
 static struct devlink_dpipe_field devlink_dpipe_fields_ethernet[] = {
 	{
 		.name = "destination mac",
@@ -183,6 +192,46 @@ static struct devlink_port *devlink_port_get_from_info(struct devlink *devlink,
 	return devlink_port_get_from_attrs(devlink, info->attrs);
 }
 
+static struct devlink_subdev *
+devlink_subdev_get_by_index(struct devlink *devlink, unsigned int subdev_index)
+{
+	struct devlink_subdev *devlink_subdev;
+
+	list_for_each_entry(devlink_subdev, &devlink->subdev_list, list) {
+		if (devlink_subdev->index == subdev_index)
+			return devlink_subdev;
+	}
+	return NULL;
+}
+
+static bool devlink_subdev_index_exists(struct devlink *devlink,
+					unsigned int subdev_index)
+{
+	return devlink_subdev_get_by_index(devlink, subdev_index);
+}
+
+static struct devlink_subdev *
+devlink_subdev_get_from_attrs(struct devlink *devlink, struct nlattr **attrs)
+{
+	struct devlink_subdev *devlink_subdev;
+	u32 subdev_index;
+
+	if (!attrs[DEVLINK_ATTR_SUBDEV_INDEX])
+		return ERR_PTR(-EINVAL);
+
+	subdev_index = nla_get_u32(attrs[DEVLINK_ATTR_SUBDEV_INDEX]);
+	devlink_subdev = devlink_subdev_get_by_index(devlink, subdev_index);
+	if (!devlink_subdev)
+		return ERR_PTR(-ENODEV);
+	return devlink_subdev;
+}
+
+static struct devlink_subdev *
+devlink_subdev_get_from_info(struct devlink *devlink, struct genl_info *info)
+{
+	return devlink_subdev_get_from_attrs(devlink, info->attrs);
+}
+
 struct devlink_sb {
 	struct list_head list;
 	unsigned int index;
@@ -386,6 +435,7 @@ devlink_region_snapshot_get_by_id(struct devlink_region *region, u32 id)
 #define DEVLINK_NL_FLAG_NEED_DEVLINK	BIT(0)
 #define DEVLINK_NL_FLAG_NEED_PORT	BIT(1)
 #define DEVLINK_NL_FLAG_NEED_SB		BIT(2)
+#define DEVLINK_NL_FLAG_NEED_SUBDEV       BIT(3)
 
 /* The per devlink instance lock is taken by default in the pre-doit
  * operation, yet several commands do not require this. The global
@@ -418,6 +468,15 @@ static int devlink_nl_pre_doit(const struct genl_ops *ops,
 			goto unlock;
 		}
 		info->user_ptr[0] = devlink_port;
+	} else if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_SUBDEV) {
+		struct devlink_subdev *devlink_subdev;
+
+		devlink_subdev = devlink_subdev_get_from_info(devlink, info);
+		if (IS_ERR(devlink_subdev)) {
+			err = PTR_ERR(devlink_subdev);
+			goto unlock;
+		}
+		info->user_ptr[0] = devlink_subdev;
 	}
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_SB) {
 		struct devlink_sb *devlink_sb;
@@ -644,6 +703,54 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
 }
 
+static int devlink_nl_subdev_fill(struct sk_buff *msg, struct devlink *devlink,
+				  struct devlink_subdev *devlink_subdev,
+				  enum devlink_command cmd, u32 subdevid,
+				  u32 seq, int flags)
+{
+	void *hdr;
+
+	hdr = genlmsg_put(msg, subdevid, seq, &devlink_nl_family, flags, cmd);
+	if (!hdr)
+		return -EMSGSIZE;
+
+	if (devlink_nl_put_handle(msg, devlink))
+		goto nla_put_failure;
+	if (nla_put_u32(msg, DEVLINK_ATTR_SUBDEV_INDEX, devlink_subdev->index))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+	return 0;
+
+nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	return -EMSGSIZE;
+}
+
+static void devlink_subdev_notify(struct devlink_subdev *devlink_subdev,
+				  enum devlink_command cmd)
+{
+	struct devlink *devlink = devlink_subdev->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	WARN_ON(cmd != DEVLINK_CMD_SUBDEV_NEW && cmd != DEVLINK_CMD_SUBDEV_DEL);
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return;
+
+	err = devlink_nl_subdev_fill(msg, devlink,
+				     devlink_subdev, cmd, 0, 0, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	genlmsg_multicast_netns(&devlink_nl_family, devlink_net(devlink),
+				msg, 0, DEVLINK_MCGRP_CONFIG, GFP_KERNEL);
+}
+
 static int devlink_nl_cmd_get_doit(struct sk_buff *skb, struct genl_info *info)
 {
 	struct devlink *devlink = info->user_ptr[0];
@@ -844,6 +951,78 @@ static int devlink_nl_cmd_port_unsplit_doit(struct sk_buff *skb,
 	return devlink_port_unsplit(devlink, port_index, info->extack);
 }
 
+static int devlink_nl_cmd_subdev_get_doit(struct sk_buff *skb,
+					  struct genl_info *info)
+{
+	struct devlink_subdev *devlink_subdev = info->user_ptr[0];
+	struct devlink *devlink = devlink_subdev->devlink;
+	struct sk_buff *msg;
+	int err;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	err = devlink_nl_subdev_fill(msg, devlink, devlink_subdev,
+				     DEVLINK_CMD_SUBDEV_NEW,
+				     info->snd_portid, info->snd_seq, 0);
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	return genlmsg_reply(msg, info);
+}
+
+static int devlink_nl_cmd_subdev_get_dumpit(struct sk_buff *msg,
+					    struct netlink_callback *cb)
+{
+	struct devlink_subdev *devlink_subdev;
+	struct list_head *subdev_list;
+	struct devlink *devlink;
+	int start = cb->args[0];
+	int idx = 0;
+	int err;
+
+	mutex_lock(&devlink_mutex);
+	list_for_each_entry(devlink, &devlink_list, list) {
+		subdev_list = &devlink->subdev_list;
+
+		if (!net_eq(devlink_net(devlink), sock_net(msg->sk)))
+			continue;
+		mutex_lock(&devlink->lock);
+		list_for_each_entry(devlink_subdev, subdev_list, list) {
+			if (idx < start) {
+				idx++;
+				continue;
+			}
+			err = devlink_nl_subdev_fill(msg, devlink,
+						     devlink_subdev,
+						     DEVLINK_CMD_NEW,
+						     NETLINK_CB(cb->skb).portid,
+						     cb->nlh->nlmsg_seq,
+						     NLM_F_MULTI);
+			if (err) {
+				mutex_unlock(&devlink->lock);
+				goto out;
+			}
+			idx++;
+		}
+		mutex_unlock(&devlink->lock);
+	}
+out:
+	mutex_unlock(&devlink_mutex);
+
+	cb->args[0] = idx;
+	return msg->len;
+}
+
+static int devlink_nl_cmd_subdev_set_doit(struct sk_buff *skb,
+					  struct genl_info *info)
+{
+	return 0;
+}
+
 static int devlink_nl_sb_fill(struct sk_buff *msg, struct devlink *devlink,
 			      struct devlink_sb *devlink_sb,
 			      enum devlink_command cmd, u32 portid,
@@ -5902,6 +6081,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_NETNS_PID] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_NETNS_FD] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_NETNS_ID] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_SUBDEV_INDEX] = { .type = NLA_U32 },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
@@ -5928,6 +6108,19 @@ static const struct genl_ops devlink_nl_ops[] = {
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = DEVLINK_NL_FLAG_NEED_PORT,
 	},
+	{
+		.cmd = DEVLINK_CMD_SUBDEV_GET,
+		.doit = devlink_nl_cmd_subdev_get_doit,
+		.dumpit = devlink_nl_cmd_subdev_get_dumpit,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_SUBDEV,
+		/* can be retrieved by unprivileged users */
+	},
+	{
+		.cmd = DEVLINK_CMD_SUBDEV_SET,
+		.doit = devlink_nl_cmd_subdev_set_doit,
+		.flags = GENL_ADMIN_PERM,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_SUBDEV,
+	},
 	{
 		.cmd = DEVLINK_CMD_PORT_SPLIT,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
@@ -6268,6 +6461,7 @@ struct devlink *devlink_alloc(const struct devlink_ops *ops, size_t priv_size)
 	devlink->ops = ops;
 	__devlink_net_set(devlink, &init_net);
 	INIT_LIST_HEAD(&devlink->port_list);
+	INIT_LIST_HEAD(&devlink->subdev_list);
 	INIT_LIST_HEAD(&devlink->sb_list);
 	INIT_LIST_HEAD_RCU(&devlink->dpipe_table_list);
 	INIT_LIST_HEAD(&devlink->resource_list);
@@ -6332,6 +6526,7 @@ void devlink_free(struct devlink *devlink)
 	WARN_ON(!list_empty(&devlink->dpipe_table_list));
 	WARN_ON(!list_empty(&devlink->sb_list));
 	WARN_ON(!list_empty(&devlink->port_list));
+	WARN_ON(!list_empty(&devlink->subdev_list));
 
 	kfree(devlink);
 }
@@ -6657,6 +6852,72 @@ static int __devlink_port_phys_port_name_get(struct devlink_port *devlink_port,
 	return 0;
 }
 
+void *devlink_subdev_priv(struct devlink_subdev *devlink_subdev)
+{
+	return devlink_subdev->priv;
+}
+EXPORT_SYMBOL_GPL(devlink_subdev_priv);
+
+/**
+ *	devlink_subdev_create - create devlink subdev
+ *
+ *	@devlink: devlink
+ *	@subdev_index: driver-specific numerical identifier of the subdev
+ *	@ops: subdev specific ops
+ *	@attrs: subdev specific attributes
+ *	@priv: driver private data
+ *
+ *	Create devlink subdev with provided subdev index. User can use
+ *	any indexing, even hw-related one.
+ */
+struct devlink_subdev *
+devlink_subdev_create(struct devlink *devlink,
+		      unsigned int subdev_index,
+		      const struct devlink_subdev_ops *ops,
+		      const struct devlink_subdev_attrs *attrs,
+		      void *priv)
+{
+	struct devlink_subdev *devlink_subdev;
+
+	devlink_subdev = kzalloc(sizeof(*devlink_subdev), GFP_KERNEL);
+	if (!devlink_subdev)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_lock(&devlink->lock);
+	if (devlink_subdev_index_exists(devlink, subdev_index)) {
+		mutex_unlock(&devlink->lock);
+		kfree(devlink_subdev);
+		return ERR_PTR(-EEXIST);
+	}
+	devlink_subdev->devlink = devlink;
+	devlink_subdev->priv = priv;
+	devlink_subdev->index = subdev_index;
+	devlink_subdev->ops = ops;
+	devlink_subdev->attrs = *attrs;
+	list_add_tail(&devlink_subdev->list, &devlink->subdev_list);
+	mutex_unlock(&devlink->lock);
+	devlink_subdev_notify(devlink_subdev, DEVLINK_CMD_SUBDEV_NEW);
+	return devlink_subdev;
+}
+EXPORT_SYMBOL_GPL(devlink_subdev_create);
+
+/**
+ *	devlink_subdev_destroy - destroy devlink subdev
+ *
+ *	@devlink_subdev: devlink subdev
+ */
+void devlink_subdev_destroy(struct devlink_subdev *devlink_subdev)
+{
+	struct devlink *devlink = devlink_subdev->devlink;
+
+	devlink_subdev_notify(devlink_subdev, DEVLINK_CMD_SUBDEV_DEL);
+	mutex_lock(&devlink->lock);
+	list_del(&devlink_subdev->list);
+	mutex_unlock(&devlink->lock);
+	kfree(devlink_subdev);
+}
+EXPORT_SYMBOL_GPL(devlink_subdev_destroy);
+
 int devlink_sb_register(struct devlink *devlink, unsigned int sb_index,
 			u32 size, u16 ingress_pools_count,
 			u16 egress_pools_count, u16 ingress_tc_count,
-- 
2.17.1

