Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B504C5A1F47
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 05:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244402AbiHZDKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 23:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243899AbiHZDJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 23:09:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C44FCD51A
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6CE7B82F77
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 03:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F367C43142;
        Fri, 26 Aug 2022 03:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661483380;
        bh=AINhcV7uEdKtgFbMqNBS878nyc73PHcIq4GnAxKg3zs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WNGj3T0cXtnRCf+5SS8y2RPJypIIWqJL9091IEyT283U5f+MVb4c2VaMNvdUA4CtS
         4tOoXAgnhwFSyGoApHG/HHGdPFQZ8pCSjna2YD1nPuY0Bv1Afhi0dvT4yYI2/kQKH5
         kZrGOw9Vro9/pnkl4E0uK3bdlCElKKpedcGXqpWTg/ktenxTQLCdgBUlbHf0CiWVzR
         Zmr0HDnKI3NiWhidRjW5om/TZdXeZa/oYZOav0HiJFQIIhv1mtbXyTt34sZEcwYKeA
         byC2lT1g19AVJOnPuKNjiTdyEO4JEMXqryngf0trnRoKJxxpL4ff2BTJ9Z35JlOoFh
         VhO78yuZfmjOg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        mkubecek@suse.cz, johannes@sipsolutions.net, idosch@idosch.org,
        dsahern@gmail.com, stephen@networkplumber.org,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com
Subject: [PATCH net-next v3 4/6] devlink: use missing attribute ext_ack
Date:   Thu, 25 Aug 2022 20:09:33 -0700
Message-Id: <20220826030935.2165661-5-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220826030935.2165661-1-kuba@kernel.org>
References: <20220826030935.2165661-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink with its global attr policy has a lot of attribute
presence check, use the new ext ack reporting when they are
missing.

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
---
 net/core/devlink.c | 41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 0f7078db1280..d0d990bb5c43 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1710,7 +1710,7 @@ static int devlink_nl_cmd_port_split_doit(struct sk_buff *skb,
 	struct devlink *devlink = info->user_ptr[0];
 	u32 count;
 
-	if (!info->attrs[DEVLINK_ATTR_PORT_SPLIT_COUNT])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PORT_SPLIT_COUNT))
 		return -EINVAL;
 	if (!devlink->ops->port_split)
 		return -EOPNOTSUPP;
@@ -1838,7 +1838,7 @@ static int devlink_nl_cmd_port_del_doit(struct sk_buff *skb,
 	if (!devlink->ops->port_del)
 		return -EOPNOTSUPP;
 
-	if (!info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PORT_INDEX)) {
 		NL_SET_ERR_MSG_MOD(extack, "Port index is not specified");
 		return -EINVAL;
 	}
@@ -2690,7 +2690,7 @@ static int devlink_nl_cmd_sb_pool_set_doit(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (!info->attrs[DEVLINK_ATTR_SB_POOL_SIZE])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_SB_POOL_SIZE))
 		return -EINVAL;
 
 	size = nla_get_u32(info->attrs[DEVLINK_ATTR_SB_POOL_SIZE]);
@@ -2900,7 +2900,7 @@ static int devlink_nl_cmd_sb_port_pool_set_doit(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (!info->attrs[DEVLINK_ATTR_SB_THRESHOLD])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_SB_THRESHOLD))
 		return -EINVAL;
 
 	threshold = nla_get_u32(info->attrs[DEVLINK_ATTR_SB_THRESHOLD]);
@@ -3156,7 +3156,7 @@ static int devlink_nl_cmd_sb_tc_pool_bind_set_doit(struct sk_buff *skb,
 	if (err)
 		return err;
 
-	if (!info->attrs[DEVLINK_ATTR_SB_THRESHOLD])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_SB_THRESHOLD))
 		return -EINVAL;
 
 	threshold = nla_get_u32(info->attrs[DEVLINK_ATTR_SB_THRESHOLD]);
@@ -3845,7 +3845,7 @@ static int devlink_nl_cmd_dpipe_entries_get(struct sk_buff *skb,
 	struct devlink_dpipe_table *table;
 	const char *table_name;
 
-	if (!info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_DPIPE_TABLE_NAME))
 		return -EINVAL;
 
 	table_name = nla_data(info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME]);
@@ -4029,8 +4029,9 @@ static int devlink_nl_cmd_dpipe_table_counters_set(struct sk_buff *skb,
 	const char *table_name;
 	bool counters_enable;
 
-	if (!info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME] ||
-	    !info->attrs[DEVLINK_ATTR_DPIPE_TABLE_COUNTERS_ENABLED])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_DPIPE_TABLE_NAME) ||
+	    GENL_REQ_ATTR_CHECK(info,
+				DEVLINK_ATTR_DPIPE_TABLE_COUNTERS_ENABLED))
 		return -EINVAL;
 
 	table_name = nla_data(info->attrs[DEVLINK_ATTR_DPIPE_TABLE_NAME]);
@@ -4119,8 +4120,8 @@ static int devlink_nl_cmd_resource_set(struct sk_buff *skb,
 	u64 size;
 	int err;
 
-	if (!info->attrs[DEVLINK_ATTR_RESOURCE_ID] ||
-	    !info->attrs[DEVLINK_ATTR_RESOURCE_SIZE])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_RESOURCE_ID) ||
+	    GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_RESOURCE_SIZE))
 		return -EINVAL;
 	resource_id = nla_get_u64(info->attrs[DEVLINK_ATTR_RESOURCE_ID]);
 
@@ -4821,7 +4822,7 @@ static int devlink_nl_cmd_flash_update(struct sk_buff *skb,
 	if (!devlink->ops->flash_update)
 		return -EOPNOTSUPP;
 
-	if (!info->attrs[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME))
 		return -EINVAL;
 
 	ret = devlink_flash_component_get(devlink,
@@ -4998,10 +4999,8 @@ static int devlink_nl_cmd_selftests_run(struct sk_buff *skb,
 	if (!devlink->ops->selftest_run || !devlink->ops->selftest_check)
 		return -EOPNOTSUPP;
 
-	if (!info->attrs[DEVLINK_ATTR_SELFTESTS]) {
-		NL_SET_ERR_MSG_MOD(info->extack, "selftest required");
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_SELFTESTS))
 		return -EINVAL;
-	}
 
 	attrs = info->attrs[DEVLINK_ATTR_SELFTESTS];
 
@@ -5455,7 +5454,7 @@ static int
 devlink_param_type_get_from_info(struct genl_info *info,
 				 enum devlink_param_type *param_type)
 {
-	if (!info->attrs[DEVLINK_ATTR_PARAM_TYPE])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PARAM_TYPE))
 		return -EINVAL;
 
 	switch (nla_get_u8(info->attrs[DEVLINK_ATTR_PARAM_TYPE])) {
@@ -5532,7 +5531,7 @@ devlink_param_get_from_info(struct list_head *param_list,
 {
 	char *param_name;
 
-	if (!info->attrs[DEVLINK_ATTR_PARAM_NAME])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PARAM_NAME))
 		return NULL;
 
 	param_name = nla_data(info->attrs[DEVLINK_ATTR_PARAM_NAME]);
@@ -5598,7 +5597,7 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 			return err;
 	}
 
-	if (!info->attrs[DEVLINK_ATTR_PARAM_VALUE_CMODE])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_PARAM_VALUE_CMODE))
 		return -EINVAL;
 	cmode = nla_get_u8(info->attrs[DEVLINK_ATTR_PARAM_VALUE_CMODE]);
 	if (!devlink_param_cmode_is_supported(param, cmode))
@@ -6118,7 +6117,7 @@ static int devlink_nl_cmd_region_get_doit(struct sk_buff *skb,
 	unsigned int index;
 	int err;
 
-	if (!info->attrs[DEVLINK_ATTR_REGION_NAME])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_REGION_NAME))
 		return -EINVAL;
 
 	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
@@ -6251,8 +6250,8 @@ static int devlink_nl_cmd_region_del(struct sk_buff *skb,
 	unsigned int index;
 	u32 snapshot_id;
 
-	if (!info->attrs[DEVLINK_ATTR_REGION_NAME] ||
-	    !info->attrs[DEVLINK_ATTR_REGION_SNAPSHOT_ID])
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_REGION_NAME) ||
+	    GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_REGION_SNAPSHOT_ID))
 		return -EINVAL;
 
 	region_name = nla_data(info->attrs[DEVLINK_ATTR_REGION_NAME]);
@@ -6300,7 +6299,7 @@ devlink_nl_cmd_region_new(struct sk_buff *skb, struct genl_info *info)
 	u8 *data;
 	int err;
 
-	if (!info->attrs[DEVLINK_ATTR_REGION_NAME]) {
+	if (GENL_REQ_ATTR_CHECK(info, DEVLINK_ATTR_REGION_NAME)) {
 		NL_SET_ERR_MSG_MOD(info->extack, "No region name provided");
 		return -EINVAL;
 	}
-- 
2.37.2

