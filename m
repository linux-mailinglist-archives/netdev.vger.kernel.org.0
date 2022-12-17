Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2D864F6C3
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiLQBUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiLQBUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC5C680AD
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CC0EB81E4C
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A47CC4339E;
        Sat, 17 Dec 2022 01:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240010;
        bh=K7SDs1Ovp9+ToEHA6znlZ/5VvZL3ZhdxOY1YZLCWOcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duLQWGe9aDOJrib0/+LfUsIzDB9jgU0FFADeYZkttUTMfzTHRhFHk6pFrbobwAQhz
         Rk7fJdb/K/EUAFWasnxxQrPJ/xB1njOnB964vPRY/JmbIp5Xru/H4Fk1yB93mFPx7K
         /loevtQsNK3+M6ZqBoGHbimn4Nq7j3++D2sF1bPDGu/K+r3cylWTAwvd9H8G82xrkK
         n26A8/ayxBEi+7zRj7IHTXgC/FG+WHpZ9lHpLSV8zN27V0OrBOz+Pes+0syAPPYOv7
         vpU6AIo3Yo/wnCzrk5eoymHPnwTycKANchL6xqfQ9RUbnh8FhptKk3N1HRR+dU9/fL
         Ho9WlsVUSmuBg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 03/10] devlink: protect devlink->dev by the instance lock
Date:   Fri, 16 Dec 2022 17:19:46 -0800
Message-Id: <20221217011953.152487-4-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221217011953.152487-1-kuba@kernel.org>
References: <20221217011953.152487-1-kuba@kernel.org>
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
 net/devlink/basic.c         | 7 +++----
 net/devlink/devl_internal.h | 3 ++-
 net/devlink/netlink.c       | 9 ++++++---
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index ceac4343698b..5f33d74eef83 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -6314,12 +6314,10 @@ static int devlink_nl_cmd_region_read_dumpit(struct sk_buff *skb,
 
 	start_offset = dump->start_offset;
 
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
diff --git a/net/devlink/devl_internal.h b/net/devlink/devl_internal.h
index ef0369449592..c3977c69552a 100644
--- a/net/devlink/devl_internal.h
+++ b/net/devlink/devl_internal.h
@@ -129,7 +129,8 @@ struct devlink_gen_cmd {
 
 extern const struct genl_small_ops devlink_nl_ops[56];
 
-struct devlink *devlink_get_from_attrs(struct net *net, struct nlattr **attrs);
+struct devlink *
+devlink_get_from_attrs_lock(struct net *net, struct nlattr **attrs);
 
 void devlink_notify_unregister(struct devlink *devlink);
 void devlink_notify_register(struct devlink *devlink);
diff --git a/net/devlink/netlink.c b/net/devlink/netlink.c
index 7eb39ccb2ae7..b38df704be1c 100644
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

