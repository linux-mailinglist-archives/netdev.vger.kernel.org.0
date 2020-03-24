Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFEA7191A06
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727613AbgCXTe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:28 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:55101 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727150AbgCXTe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:27 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 74318580061;
        Tue, 24 Mar 2020 15:34:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=CUWWiGI9rct6NIU4x9Jw0CWHTZHkn2xpiAVb682KvOo=; b=e8/jfr1f
        wLAZVGE77wQgufD9AnaKBAqGnwNECkOaPMtXplajzU+WP32QJv9bR3buE+2GjuKS
        bIwB6hoQ6D9d5/aYfFIO9CwHVfd8Lk6O0wSpAjEIv8+PZgejvf/iZv1foObpIMc3
        /d5w9Ur4n1+gQfmO+nDeo1FWeYhQ8hO6lEawVOSsdOC7nL5BKjQGRhHZzr9GQrNo
        07uMz9+xA1dOE7nFXyvzzlvT30aY4dt2HXmoE/B9F84G7BXdiVyuJdXrVcUQmgnb
        RSfFrLPyhLKXKswhYlcMBiUQWRooAdpuB0xjxi6VPpJb/e86wSa0Tag3JFmV9NUF
        T5hh6xjoHkequg==
X-ME-Sender: <xms:wmB6Xl2MYapYaOBdvl4U7EPkiQK6LfrWjrAQQV6zb1ydzYql3Eh9ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:wmB6XvVJwgiHQF3rxJBXJ9XhfT28UNDCJ2faaoA0XCLzH2-84-mTCA>
    <xmx:wmB6XtZ3KnHIu7EYQ5-xpNxj7gbiRV3htNjTmpCfCwHwn-DBHj-4rA>
    <xmx:wmB6XgddHGYcHpizl0OILGbugWBPrjNBBtaYW8nUZ6oCrXsQvP2PjQ>
    <xmx:wmB6XpaUutRrZpOTbS65mYMX2MN9HwSgIQpcHQ36zN8bbc61suWKkw>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4196A3065E1B;
        Tue, 24 Mar 2020 15:34:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 05/15] devlink: Allow setting of packet trap group parameters
Date:   Tue, 24 Mar 2020 21:32:40 +0200
Message-Id: <20200324193250.1322038-6-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
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

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/devlink.h |  9 +++++++++
 net/core/devlink.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 84c28e0f2d90..dea3c3fd9634 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -847,6 +847,15 @@ struct devlink_ops {
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
index 4ec7c7578709..e3042e131c1f 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -6039,6 +6039,45 @@ devlink_trap_group_action_set(struct devlink *devlink,
 	return 0;
 }
 
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
+	if (!devlink->ops->trap_group_set) {
+		if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
+			return -EOPNOTSUPP;
+		return 0;
+	}
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
+	return 0;
+}
+
 static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 					      struct genl_info *info)
 {
@@ -6060,6 +6099,10 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
 	if (err)
 		return err;
 
+	err = devlink_trap_group_set(devlink, group_item, info);
+	if (err)
+		return err;
+
 	return 0;
 }
 
-- 
2.24.1

