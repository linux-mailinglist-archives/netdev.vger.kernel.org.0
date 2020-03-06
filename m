Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D5EF17C387
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 18:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbgCFREs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 12:04:48 -0500
Received: from mx2.suse.de ([195.135.220.15]:43452 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727095AbgCFREs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 12:04:48 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 45136B32E;
        Fri,  6 Mar 2020 17:04:45 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E6DE8E00E7; Fri,  6 Mar 2020 18:04:44 +0100 (CET)
Message-Id: <6b2a34e6a3069e8df12cccee30b54162e1f90908.1583513281.git.mkubecek@suse.cz>
In-Reply-To: <cover.1583513281.git.mkubecek@suse.cz>
References: <cover.1583513281.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v3 09/25] netlink: initialize ethtool netlink socket
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Fri,  6 Mar 2020 18:04:44 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As part of the netlink initialization, set up netlink socket for ethtool
netlink and get id of ethtool genetlink family and monitor multicast group.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/netlink.c | 94 ++++++++++++++++++++++++++++++++++++++++++++++-
 netlink/netlink.h | 11 ++++++
 2 files changed, 104 insertions(+), 1 deletion(-)

diff --git a/netlink/netlink.c b/netlink/netlink.c
index 7d5eca666c84..7cd7bef6eac9 100644
--- a/netlink/netlink.c
+++ b/netlink/netlink.c
@@ -9,6 +9,8 @@
 #include "../internal.h"
 #include "netlink.h"
 #include "extapi.h"
+#include "msgbuff.h"
+#include "nlsock.h"
 
 /* Used as reply callback for requests where no reply is expected (e.g. most
  * "set" type commands)
@@ -40,18 +42,108 @@ int attr_cb(const struct nlattr *attr, void *data)
 
 /* initialization */
 
+struct fam_info {
+	const char	*fam_name;
+	const char	*grp_name;
+	uint16_t	fam_id;
+	uint32_t	grp_id;
+};
+
+static void find_mc_group(struct nlattr *nest, struct fam_info *info)
+{
+	const struct nlattr *grp_tb[CTRL_ATTR_MCAST_GRP_MAX + 1] = {};
+	DECLARE_ATTR_TB_INFO(grp_tb);
+	struct nlattr *grp_attr;
+	int ret;
+
+	mnl_attr_for_each_nested(grp_attr, nest) {
+		ret = mnl_attr_parse_nested(grp_attr, attr_cb, &grp_tb_info);
+		if (ret < 0)
+			return;
+		if (!grp_tb[CTRL_ATTR_MCAST_GRP_NAME] ||
+		    !grp_tb[CTRL_ATTR_MCAST_GRP_ID])
+			continue;
+		if (strcmp(mnl_attr_get_str(grp_tb[CTRL_ATTR_MCAST_GRP_NAME]),
+			   info->grp_name))
+			continue;
+		info->grp_id =
+			mnl_attr_get_u32(grp_tb[CTRL_ATTR_MCAST_GRP_ID]);
+		return;
+	}
+}
+
+static int family_info_cb(const struct nlmsghdr *nlhdr, void *data)
+{
+	struct fam_info *info = data;
+	struct nlattr *attr;
+
+	mnl_attr_for_each(attr, nlhdr, GENL_HDRLEN) {
+		switch (mnl_attr_get_type(attr)) {
+		case CTRL_ATTR_FAMILY_ID:
+			info->fam_id = mnl_attr_get_u16(attr);
+			break;
+		case CTRL_ATTR_MCAST_GROUPS:
+			find_mc_group(attr, info);
+			break;
+		}
+	}
+
+	return MNL_CB_OK;
+}
+
+static int get_genl_family(struct nl_socket *nlsk, struct fam_info *info)
+{
+	struct nl_msg_buff *msgbuff = &nlsk->msgbuff;
+	int ret;
+
+	nlsk->nlctx->suppress_nlerr = 2;
+	ret = __msg_init(msgbuff, GENL_ID_CTRL, CTRL_CMD_GETFAMILY,
+			 NLM_F_REQUEST | NLM_F_ACK, 1);
+	if (ret < 0)
+		goto out;
+	ret = -EMSGSIZE;
+	if (ethnla_put_strz(msgbuff, CTRL_ATTR_FAMILY_NAME, info->fam_name))
+		goto out;
+
+	nlsock_sendmsg(nlsk, NULL);
+	nlsock_process_reply(nlsk, family_info_cb, info);
+	ret = info->fam_id ? 0 : -EADDRNOTAVAIL;
+
+out:
+	nlsk->nlctx->suppress_nlerr = 0;
+	return ret;
+}
+
 int netlink_init(struct cmd_context *ctx)
 {
+	struct fam_info info = {
+		.fam_name	= ETHTOOL_GENL_NAME,
+		.grp_name	= ETHTOOL_MCGRP_MONITOR_NAME,
+	};
 	struct nl_context *nlctx;
+	int ret;
 
 	nlctx = calloc(1, sizeof(*nlctx));
 	if (!nlctx)
 		return -ENOMEM;
 	nlctx->ctx = ctx;
+	ret = nlsock_init(nlctx, &nlctx->ethnl_socket, NETLINK_GENERIC);
+	if (ret < 0)
+		goto out_free;
+	ret = get_genl_family(nlctx->ethnl_socket, &info);
+	if (ret < 0)
+		goto out_nlsk;
+	nlctx->ethnl_fam = info.fam_id;
+	nlctx->ethnl_mongrp = info.grp_id;
 
 	ctx->nlctx = nlctx;
-
 	return 0;
+
+out_nlsk:
+	nlsock_done(nlctx->ethnl_socket);
+out_free:
+	free(nlctx);
+	return ret;
 }
 
 void netlink_done(struct cmd_context *ctx)
diff --git a/netlink/netlink.h b/netlink/netlink.h
index fbcea0b62240..9ba03b05163f 100644
--- a/netlink/netlink.h
+++ b/netlink/netlink.h
@@ -11,6 +11,7 @@
 #include <linux/netlink.h>
 #include <linux/genetlink.h>
 #include <linux/ethtool_netlink.h>
+#include "nlsock.h"
 
 #define WILDCARD_DEVNAME "*"
 
@@ -22,6 +23,9 @@ struct nl_context {
 	int			exit_code;
 	unsigned int		suppress_nlerr;
 	uint16_t		ethnl_fam;
+	uint32_t		ethnl_mongrp;
+	struct nl_socket	*ethnl_socket;
+	struct nl_socket	*ethnl2_socket;
 };
 
 struct attr_tb_info {
@@ -35,4 +39,11 @@ struct attr_tb_info {
 int nomsg_reply_cb(const struct nlmsghdr *nlhdr, void *data);
 int attr_cb(const struct nlattr *attr, void *data);
 
+static inline int netlink_init_ethnl2_socket(struct nl_context *nlctx)
+{
+	if (nlctx->ethnl2_socket)
+		return 0;
+	return nlsock_init(nlctx, &nlctx->ethnl2_socket, NETLINK_GENERIC);
+}
+
 #endif /* ETHTOOL_NETLINK_INT_H__ */
-- 
2.25.1

