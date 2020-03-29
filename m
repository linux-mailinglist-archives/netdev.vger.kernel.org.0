Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E665196F35
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 20:22:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbgC2SWN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 14:22:13 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:37903 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727719AbgC2SWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 14:22:13 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6726A580907;
        Sun, 29 Mar 2020 14:22:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 29 Mar 2020 14:22:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=fZ2asHiORlU0d5AKHvfWSdO4y8dKn+F6eT/SdScKEkM=; b=oSPYumCM
        XCo1nRg9is5fR4n01PqXRufoEDV/AHaHpjgJAsZfAx6QBJzISMD3ljRXhSZ5GyyK
        R7/uTBL2eJ62rjr8Y8EtATnd52yVzhIVelVHBze5WBT7joyeA6sw35HEEtp1DSkF
        3jh8rV0d48oVj3fpR2oI0vbB8hM3noh5n7Fk1PeqlJEc8rmS2z6AcaiChtZq69PA
        dQYsx/5aMCvwRs6vCBa4/Na6W2bRzWGA9PVJBLARy0VGA//WpGF7NFD1A5wePKjn
        PDmliVS3t1/RbkUVKW/014STGFbozIYiH+Sr5ki4KgLWgG4N6eNL+VFSOUDJ2BpY
        ve3tx447NDnEkQ==
X-ME-Sender: <xms:U-eAXmmDDW5w_Pnh5x5U0NC8TsYF6c0ATdMS2Gzl2gIbXMmEZ6C4Vw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeifedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepjeelrddukedurddufedvrdduledunecuvehluhhsth
    gvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:U-eAXiE_wtP5gS0lBv9cnpWWT2DyhrFg_eDldvBp7W_HUA7LpSYJ3A>
    <xmx:U-eAXvpzg0DNXAkho91z6dT_9-oxNAFNnYv5mYeH86rWLjY1YakF5g>
    <xmx:U-eAXu4GolcbzsoojcfNgD4eHqkZad2-WS_x3BWIyUuRSPXXDHWTLw>
    <xmx:U-eAXht__VnUuXy1pJBMPmby1eO51ZWm3Ocimo8HncEj96rcAz0FcQ>
Received: from splinter.mtl.com (bzq-79-181-132-191.red.bezeqint.net [79.181.132.191])
        by mail.messagingengine.com (Postfix) with ESMTPA id F236B3280059;
        Sun, 29 Mar 2020 14:22:08 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 05/15] devlink: Allow setting of packet trap group parameters
Date:   Sun, 29 Mar 2020 21:21:09 +0300
Message-Id: <20200329182119.2207630-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200329182119.2207630-1-idosch@idosch.org>
References: <20200329182119.2207630-1-idosch@idosch.org>
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
index 781ad5285dcf..3a1d87c725fb 100644
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
index 85a566d60d49..5f5e94bb52f7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6269,7 +6269,7 @@ __devlink_trap_group_action_set(struct devlink *devlink,
 static int
 devlink_trap_group_action_set(struct devlink *devlink,
 			      struct devlink_trap_group_item *group_item,
-			      struct genl_info *info)
+			      struct genl_info *info, bool *p_modified)
 {
 	enum devlink_trap_action trap_action;
 	int err;
@@ -6288,6 +6288,47 @@ devlink_trap_group_action_set(struct devlink *devlink,
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
 
@@ -6297,6 +6338,7 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 	struct netlink_ext_ack *extack = info->extack;
 	struct devlink *devlink = info->user_ptr[0];
 	struct devlink_trap_group_item *group_item;
+	bool modified = false;
 	int err;
 
 	if (list_empty(&devlink->trap_group_list))
@@ -6308,11 +6350,21 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
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

