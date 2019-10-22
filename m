Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D578AE0AE4
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 19:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731982AbfJVRnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 13:43:22 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:55830 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731910AbfJVRnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 13:43:22 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from yuvalav@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 22 Oct 2019 19:43:19 +0200
Received: from sw-mtx-008.mtx.labs.mlnx (sw-mtx-008.mtx.labs.mlnx [10.9.150.35])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id x9MHhIsN005578;
        Tue, 22 Oct 2019 20:43:19 +0300
Received: from sw-mtx-008.mtx.labs.mlnx (localhost [127.0.0.1])
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7) with ESMTP id x9MHhIAp023987;
        Tue, 22 Oct 2019 20:43:18 +0300
Received: (from yuvalav@localhost)
        by sw-mtx-008.mtx.labs.mlnx (8.14.7/8.14.7/Submit) id x9MHhImW023986;
        Tue, 22 Oct 2019 20:43:18 +0300
From:   Yuval Avnery <yuvalav@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        shuah@kernel.org, Yuval Avnery <yuvalav@mellanox.com>
Subject: [PATCH net-next 4/9] devlink: Support vdev HW address get
Date:   Tue, 22 Oct 2019 20:43:05 +0300
Message-Id: <1571766190-23943-5-git-send-email-yuvalav@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow privileged user to get the HW address of a vdev.

Example:

$ devlink vdev show pci/0000:03:00.0/1
pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 00:23:35:af:35:34

$ devlink vdev show pci/0000:03:00.0/1 -pj
{
    "vdev": {
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
 net/core/devlink.c           | 33 +++++++++++++++++++++++++++------
 3 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 138d33275963..12550cc92e9d 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -765,6 +765,9 @@ struct devlink_ops {
 };
 
 struct devlink_vdev_ops {
+	int (*hw_addr_get)(struct devlink_vdev *vdev,
+			   u8 *hw_addr, struct netlink_ext_ack *extack);
+	unsigned int hw_addr_len;
 };
 
 static inline void *devlink_priv(struct devlink *devlink)
diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
index 161bad54d528..2f2c2d60796f 100644
--- a/include/uapi/linux/devlink.h
+++ b/include/uapi/linux/devlink.h
@@ -439,6 +439,7 @@ enum devlink_attr {
 	DEVLINK_ATTR_VDEV_FLAVOUR,		/* u16 */
 	DEVLINK_ATTR_VDEV_PF_INDEX,		/* u32 */
 	DEVLINK_ATTR_VDEV_VF_INDEX,		/* u32 */
+	DEVLINK_ATTR_VDEV_HW_ADDR,		/* binary */
 
 	/* add new attributes above here, update the policy in devlink.c */
 
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 2fffbd37e710..94599409f12c 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -711,10 +711,13 @@ static void devlink_port_notify(struct devlink_port *devlink_port,
 static int devlink_nl_vdev_fill(struct sk_buff *msg, struct devlink *devlink,
 				struct devlink_vdev *devlink_vdev,
 				enum devlink_command cmd, u32 vdevid,
-				u32 seq, int flags)
+				u32 seq, int flags,
+				struct netlink_ext_ack *extack)
 {
 	struct devlink_vdev_attrs *attrs = &devlink_vdev->attrs;
+	const struct devlink_vdev_ops *ops = devlink_vdev->ops;
 	void *hdr;
+	int err;
 
 	hdr = genlmsg_put(msg, vdevid, seq, &devlink_nl_family, flags, cmd);
 	if (!hdr)
@@ -748,6 +751,19 @@ static int devlink_nl_vdev_fill(struct sk_buff *msg, struct devlink *devlink,
 				devlink_vdev->devlink_port->index))
 			goto nla_put_failure;
 
+	if (ops && ops->hw_addr_get) {
+		u8 hw_addr[MAX_ADDR_LEN];
+
+		err = ops->hw_addr_get(devlink_vdev, hw_addr, extack);
+		if (err) {
+			genlmsg_cancel(msg, hdr);
+			return err;
+		}
+		if (nla_put(msg, DEVLINK_ATTR_VDEV_HW_ADDR,
+			    ops->hw_addr_len, hw_addr))
+			goto nla_put_failure;
+	}
+
 	genlmsg_end(msg, hdr);
 	return 0;
 
@@ -769,7 +785,8 @@ static void devlink_vdev_notify(struct devlink_vdev *devlink_vdev,
 	if (!msg)
 		return;
 
-	err = devlink_nl_vdev_fill(msg, devlink, devlink_vdev, cmd, 0, 0, 0);
+	err = devlink_nl_vdev_fill(msg, devlink, devlink_vdev, cmd,
+				   0, 0, 0, NULL);
 	if (err) {
 		nlmsg_free(msg);
 		return;
@@ -992,8 +1009,8 @@ static int devlink_nl_cmd_vdev_get_doit(struct sk_buff *skb,
 		return -ENOMEM;
 
 	err = devlink_nl_vdev_fill(msg, devlink, devlink_vdev,
-				   DEVLINK_CMD_VDEV_NEW,
-				   info->snd_portid, info->snd_seq, 0);
+				   DEVLINK_CMD_VDEV_NEW, info->snd_portid,
+				   info->snd_seq, 0, info->extack);
 	if (err) {
 		nlmsg_free(msg);
 		return err;
@@ -1009,7 +1026,7 @@ static int devlink_nl_cmd_vdev_get_dumpit(struct sk_buff *msg,
 	struct devlink *devlink;
 	int start = cb->args[0];
 	int idx = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&devlink_mutex);
 	list_for_each_entry(devlink, &devlink_list, list) {
@@ -1025,7 +1042,7 @@ static int devlink_nl_cmd_vdev_get_dumpit(struct sk_buff *msg,
 						   DEVLINK_CMD_NEW,
 						   NETLINK_CB(cb->skb).portid,
 						   cb->nlh->nlmsg_seq,
-						   NLM_F_MULTI);
+						   NLM_F_MULTI, NULL);
 			if (err) {
 				mutex_unlock(&devlink->lock);
 				goto out;
@@ -1036,6 +1053,8 @@ static int devlink_nl_cmd_vdev_get_dumpit(struct sk_buff *msg,
 	}
 out:
 	mutex_unlock(&devlink_mutex);
+	if (err != -EMSGSIZE)
+		return err;
 
 	cb->args[0] = idx;
 	return msg->len;
@@ -6109,6 +6128,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_VDEV_FLAVOUR] = { .type = NLA_U16 },
 	[DEVLINK_ATTR_VDEV_PF_INDEX] = { .type = NLA_U32 },
 	[DEVLINK_ATTR_VDEV_VF_INDEX] = { .type = NLA_U32 },
+	[DEVLINK_ATTR_VDEV_HW_ADDR] = { .type = NLA_BINARY,
+					.len = MAX_ADDR_LEN },
 };
 
 static const struct genl_ops devlink_nl_ops[] = {
-- 
2.17.1

