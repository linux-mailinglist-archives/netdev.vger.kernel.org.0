Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB7E65FB7D
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjAFGeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbjAFGeM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5482E6E0CF
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA4CFB81CCB
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383B9C43396;
        Fri,  6 Jan 2023 06:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986848;
        bh=DBs1ChKoi6R70LDrGAyxzrYuAdgpnLROcBw9lihUXXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AO/UsW3L8/86p5BzDU/+3366YV2c0MuMy0JyHPvEnM4XgAoz8z4m8o6IIsHToMMAf
         CojJT6WbRnQSiXfnq8p5p1hJ50q2YjqyDgFKizziZRu2UyZhASSDrJZ8uMnOhQNr4L
         /Z1PsUk8mEq0vmh6/0jmvqHWCRrLgC82ecA84uR6o1tTVEurZ3I/QlHzf5+YIshurC
         4g2s0ga7z2E6llKtMmwsYbCnDGa9EElZuL7Dbd3VsisFXMcD35EolWkPNYIuf5ADyf
         aeqapmPexJiDycWt3ht1uKj5wK6nptXGoRCENvHjNiZxTGZ8yyMPzBiPsVhRY9zp1K
         wADqlEQKd/XpQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/9] devlink: protect devlink->dev by the instance lock
Date:   Thu,  5 Jan 2023 22:33:56 -0800
Message-Id: <20230106063402.485336-4-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230106063402.485336-1-kuba@kernel.org>
References: <20230106063402.485336-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink->dev is assumed to be always valid as long as any
outstanding reference to the devlink instance exists.

In prep for weakening of the references take the instance lock.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/devl_internal.h | 3 ++-
 net/devlink/leftover.c      | 7 +++----
 net/devlink/netlink.c       | 9 ++++++---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index 14767e809178..6342552e5f99 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -131,7 +131,8 @@ struct devlink_gen_cmd {
 
 extern const struct genl_small_ops devlink_nl_ops[56];
 
-struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
+struct devlink *
+devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs);
 
 void devlink_notify_unregister(struct devlink *devlink);
 void devlink_notify_register(struct devlink *devlink);
diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index e6d6c7f74ae7..bec408da4dbe 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6314,12 +6314,10 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	start_offset = state->start_offset;
 
-	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
+	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs);
 	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
 
-	devl_lock(devlink);
-
 	if (!attrs[DEVLINK_ATTR_REGION_NAME]) {
 		NL_SET_ERR_MSG(cb->extack, "No region name provided");
 		err = -EINVAL;
@@ -7735,9 +7733,10 @@ devlink_health_reporter_get_from_cb(struct netlink_callback *cb)
 	struct nlattr **attrs = info->attrs;
 	struct devlink *devlink;
 
-	devlink = devlink_get_from_attrs(sock_net(cb->skb->sk), attrs);
+	devlink = devlink_get_from_attrs_lock(sock_net(cb->skb->sk), attrs);
 	if (IS_ERR(devlink))
 		return NULL;
+	devl_unlock(devlink);
 
 	reporter = devlink_health_reporter_get_from_attrs(devlink, attrs);
 	devlink_put(devlink);
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index a552e723f4a6..69111746f5d9 100644
--- a/net/devlink/netlink.c
+++ b/net/devlink/netlink.c
@@ -82,7 +82,8 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
 	[DEVLINK_ATTR_REGION_DIRECT] = { .type = NLA_FLAG },
 };
 
-struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs)
+struct devlink *
+devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs)
 {
 	struct devlink *devlink;
 	unsigned long index;
@@ -96,9 +97,11 @@ struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs)
 	devname = nla_data(attrs[DEVLINK_ATTR_DEV_NAME]);
 
 	devlinks_xa_for_each_registered_get(net, index, devlink) {
+		devl_lock(devlink);
 		if (strcmp(devlink->dev->bus->name, busname) == 0 &&
 		    strcmp(dev_name(devlink->dev), devname) == 0)
 			return devlink;
+		devl_unlock(devlink);
 		devlink_put(devlink);
 	}
 
@@ -113,10 +116,10 @@ static int devlink_nl_pre_doit(const struct genl_split_ops *ops,
 	struct devlink *devlink;
 	int err;
 
-	devlink = devlink_get_from_attrs(genl_info_net(info), info->attrs);
+	devlink = devlink_get_from_attrs_lock(genl_info_net(info), info->attrs);
 	if (IS_ERR(devlink))
 		return PTR_ERR(devlink);
-	devl_lock(devlink);
+
 	info->user_ptr[0] = devlink;
 	if (ops->internal_flags & DEVLINK_NL_FLAG_NEED_PORT) {
 		devlink_port = devlink_port_get_from_info(devlink, info);
-- 
2.38.1

