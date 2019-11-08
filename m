Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFBDBF50E1
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 17:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727615AbfKHQTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 11:19:07 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60298 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727352AbfKHQTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 11:19:06 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 8 Nov 2019 18:19:01 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id xA8GIxdI003131;
        Fri, 8 Nov 2019 18:19:00 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id xA8GIxoQ030088;
        Fri, 8 Nov 2019 18:18:59 +0200
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id xA8GIx5N030087;
        Fri, 8 Nov 2019 18:18:59 +0200
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, danielj@mellanox.com, parav@mellanox.com,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com,
        Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next v2 04/10] devlink: Support subdev HW address get
Date:   Fri,  8 Nov 2019 18:18:40 +0200
Message-Id: <1573229926-30040-5-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow privileged user to get the HW address of a subdev.

Example:

$ devlink subdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 00:23:35:af:35:34

$ devlink subdev show pci/0000:03:00.0/1 -pj
{
    "subdev": {
        "pci/0000:03:00.0/1": {
            "flavour": "pcivf",
            "pf": 0,
            "vf": 0,
            "port_index": 1,
            "hw_addr": "00:23:35:af:35:34"
        }
    }
}

Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h        |  3 +++
 include/uapi/linux/devlink.h |  1 +
 net/core/devlink.c           | 34 +++++++++++++++++++++++++++-------
 3 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 0cedd6d34ef8..5917260e5748 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -765,6 +765,9 @@ struct devlink_ops {
 };
 
 struct devlink_subdev_ops {
+	int (*hw_addr_get)(struct devlink_subdev *subdev,
+			   u8 *hw_addr, struct netlink_ext_ack *extack);
+	unsigned int hw_addr_len;
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index da79ffad9c5a..c7a7ad4c4a20 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -439,6 +439,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_SUBDEV_FLAVOUR,		/* u16 */
 	DEVLINK_ATTR_SUBDEV_PF_INDEX,		/* u32 */
 	DEVLINK_ATTR_SUBDEV_VF_INDEX,		/* u32 */
+	DEVLINK_ATTR_SUBDEV_HW_ADDR,		/* binary */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0c97c51dea0d..7d6e3da8a64c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -711,10 +711,13 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 static int devlink_nl_subdev_fill(struct sk_buff *msg, struct devlink *devlink,
 				  struct devlink_subdev *devlink_subdev,
 				  enum devlink_command cmd, u32 subdevid,
-				  u32 seq, int flags)
+				  u32 seq, int flags,
+				  struct netlink_ext_ack *extack)
 {
 	struct devlink_subdev_attrs *attrs = &devlink_subdev->attrs;
+	const struct devlink_subdev_ops *ops = devlink_subdev->ops;
 	void *hdr;
+	int err;
 
 	hdr = genlmsg_put(msg, subdevid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
@@ -748,6 +751,19 @@ static int devlink_nl_subdev_fill(struct sk_buff *msg, struct devlink *devlink,
 				devlink_subdev->devlink_port->index))
 			goto nla_put_failure;
 
+	if (ops && ops->hw_addr_get) {
+		u8 hw_addr[MAX_ADDR_LEN];
+
+		err = ops->hw_addr_get(devlink_subdev, hw_addr, extack);
+		if (err) {
+			genlmsg_cancel(msg, hdr);
+			return err;
+		}
+		if (nla_put(msg, DEVLINK_ATTR_SUBDEV_HW_ADDR,
+			    ops->hw_addr_len, hw_addr))
+			goto nla_put_failure;
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -769,8 +785,8 @@ static void devlink_subdev_notify(struct devlink_subdev *devlink_subdev,
 	if (!msg)
 		return;
 
-	err = devlink_nl_subdev_fill(msg, devlink,
-				     devlink_subdev, cmd, 0, 0, 0);
+	err = devlink_nl_subdev_fill(msg, devlink, devlink_subdev, cmd,
+				     0, 0, 0, NULL);
 	if (err) {
 		nlmsg_free(msg);
 		return;
@@ -993,8 +1009,8 @@ static int devlink_nl_cmd_subdev_get_doit(struct sk_buff *skb,
 		return -ENOMEM;
 
 	err = devlink_nl_subdev_fill(msg, devlink, devlink_subdev,
-				     DEVLINK_CMD_SUBDEV_NEW,
-				     info->snd_portid, info->snd_seq, 0);
+				     DEVLINK_CMD_SUBDEV_NEW, info->snd_portid,
+				     info->snd_seq, 0, info->extack);
 	if (err) {
 		nlmsg_free(msg);
 		return err;
@@ -1011,7 +1027,7 @@ static int devlink_nl_cmd_subdev_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
@@ -1030,7 +1046,7 @@ static int devlink_nl_cmd_subdev_get_dumpit(struct sk_buff *msg,
 						     DEVLINK_CMD_NEW,
 						     NETLINK_CB(cb->skb).portid,
 						     cb->nlh->nlmsg_seq,
-						     NLM_F_MULTI);
+						     NLM_F_MULTI, NULL);
 			if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
@@ -1041,6 +1057,8 @@ static int devlink_nl_cmd_subdev_get_dumpit(struct sk_buff *msg,
 	}
 out:
 	mutex_unlock(&devlink_mutex);
+	if (err != -EMSGSIZE)
+		return err;
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -6114,6 +6132,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_SUBDEV_FLAVOUR] = { .type = NLA_U16 },
 	[DEVLINK_ATTR_SUBDEV_PF_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_SUBDEV_VF_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_SUBDEV_HW_ADDR] = { .type = NLA_BINARY,
+					.len = MAX_ADDR_LEN },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
-- 
2.17.1

