Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3343D1984A9
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 21:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728778AbgC3TjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 15:39:19 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:45697 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728726AbgC3TjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 15:39:18 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 04A7A580542;
        Mon, 30 Mar 2020 15:39:17 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 30 Mar 2020 15:39:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=JswBityx+klgSk4voKx7mhTuPn+P/3kpjr/D/YJxQj0=; b=wTDooaNY
        vD4F2G3vrcCvlk/pkpUyStvUQ8jHnmGlDAgqxzd3KcUffnCuMy/YN4m91aTq54Jh
        PQkon7q7Df+sDTYG6dz5s1bDD7EdI9MwURmIVN0+xuFEbQ7X0Sr9jkUsi6fAEYre
        t+8+DgEJ45WHJQXJRVNKKY+3guim/nBzFo/p5poxe3h2cOjgp8bB4giok8gWOTRD
        rXPVUk5H/Z6H6ncNETVu02EBWwh93w/3zgaxoOKRaICrAm9BjHArfg+M14btHROh
        m5AYqbrM7vDnY2tHItBVJDor4D2ZRJ4e9vos7bQSw7nL6RQzitJJmy1STylmIR7a
        M2GMY9wz69BaFA==
X-ME-Sender: <xms:5EqCXrCrXZq_YAvCBLJSYPFJHvEWK6Hokrpi10Z3vkwReGRxFxC_Bw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeihedgudeflecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:5EqCXsoqST-FXgn7kA0cNHZzGS3guL3MR_4O4Dxe_oMu5fTlZec9ZA>
    <xmx:5EqCXg7kRCQmFhWEzVt7EOo1uCpPynE05l0omtf1Uf7gPk_4osNBug>
    <xmx:5EqCXqWl6lV5JMz06g2OYxYitutTnqRDADr16znq1_BePZnZ_2Wv6g>
    <xmx:5UqCXmpEOlrmWPV5ok24az-2mj1qHCW6qHpziJ6kmgeClAOugK0oWQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id D044D306CA25;
        Mon, 30 Mar 2020 15:39:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v3 05/15] devlink: Allow setting of packet trap group parameters
Date:   Mon, 30 Mar 2020 22:38:22 +0300
Message-Id: <20200330193832.2359876-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330193832.2359876-1-idosch@idosch.org>
References: <20200330193832.2359876-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The previous patch allowed device drivers to publish their default
binding between packet trap policers and packet trap groups. However,
some users might not be content with this binding and would like to
change it.

In case user space passed a packet trap policer identifier when setting
a packet trap group, invoke the appropriate device driver callback and
pass the new policer identifier.

v2:
* Check for presence of 'DEVLINK_ATTR_TRAP_POLICER_ID' in
  devlink_trap_group_set() and bail if not present
* Add extack error message in case trap group was partially modified

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  9 +++++++
 net/core/devlink.c    | 56 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 63834686c8d3..8ffc1b5cd89b 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -877,6 +877,15 @@ struct devlink_ops {
 	 */
 	int (*trap_group_init)(struct devlink *devlink,
 			       const struct devlink_trap_group *group);
+	/**
+	 * @trap_group_set: Trap group parameters set function.
+	 *
+	 * Note: @policer can be NULL when a policer is being unbound from
+	 * @group.
+	 */
+	int (*trap_group_set)(struct devlink *devlink,
+			      const struct devlink_trap_group *group,
+			      const struct devlink_trap_policer *policer);
 	/**
 	 * @trap_policer_init: Trap policer initialization function.
 	 *
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 544543443e96..80f97722f31f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6283,7 +6283,7 @@ __devlink_trap_group_action_set(struct devlink *devlink,
 static int
 devlink_trap_group_action_set(struct devlink *devlink,
 			      struct devlink_trap_group_item *group_item,
-			      struct genl_info *info)
+			      struct genl_info *info, bool *p_modified)
 {
 	enum devlink_trap_action trap_action;
 	int err;
@@ -6302,6 +6302,47 @@ devlink_trap_group_action_set(struct devlink *devlink,
 	if (err)
 		return err;
 
+	*p_modified = true;
+
+	return 0;
+}
+
+static int devlink_trap_group_set(struct devlink *devlink,
+				  struct devlink_trap_group_item *group_item,
+				  struct genl_info *info)
+{
+	struct devlink_trap_policer_item *policer_item;
+	struct netlink_ext_ack *extack = info->extack;
+	const struct devlink_trap_policer *policer;
+	struct nlattr **attrs = info->attrs;
+	int err;
+
+	if (!attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
+		return 0;
+
+	if (!devlink->ops->trap_group_set)
+		return -EOPNOTSUPP;
+
+	policer_item = group_item->policer_item;
+	if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID]) {
+		u32 policer_id;
+
+		policer_id = nla_get_u32(attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
+		policer_item = devlink_trap_policer_item_lookup(devlink,
+								policer_id);
+		if (policer_id && !policer_item) {
+			NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");
+			return -ENOENT;
+		}
+	}
+	policer = policer_item ? policer_item->policer : NULL;
+
+	err = devlink->ops->trap_group_set(devlink, group_item->group, policer);
+	if (err)
+		return err;
+
+	group_item->policer_item = policer_item;
+
 	return 0;
 }
 
@@ -6311,6 +6352,7 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_group_item *group_item;
+	bool modified = false;
 	int err;
 
 	if (list_empty(&devlink->trap_group_list))
@@ -6322,11 +6364,21 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 		return -ENOENT;
 	}
 
-	err = devlink_trap_group_action_set(devlink, group_item, info);
+	err = devlink_trap_group_action_set(devlink, group_item, info,
+					    &modified);
 	if (err)
 		return err;
 
+	err = devlink_trap_group_set(devlink, group_item, info);
+	if (err)
+		goto err_trap_group_set;
+
 	return 0;
+
+err_trap_group_set:
+	if (modified)
+		NL_SET_ERR_MSG_MOD(extack, "Trap group set failed, but some changes were committed already");
+	return err;
 }
 
 static struct devlink_trap_policer_item *
-- 
2.24.1

