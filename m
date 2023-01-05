Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25C6E65E45F
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbjAEEGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjAEEFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDF13724E
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C60C60C95
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947D9C433F2;
        Thu,  5 Jan 2023 04:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891543;
        bh=fkB/K7jcQ0udmmhXDmIxJXSKKCZyHo0Pfk7YJ2UlMeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JLpJR57yIGYYFoqGHiEP4jPNy6hVloadk0/nxAe7E5YYlZxFX4V9LlL739WL9z8e8
         uaLXk7fTMc0/kIjSFXJwwCGi8J3JUeLBb+xU+CxBQq4Ju4Ycr7OgbtC98IHNtgXgat
         qzrMAE9fsgaW6YlR8ivHNagzPBOJEi19oP17puyMBhboPiCWFlYjyagMFqFnsuoewL
         SqSzaWlRtLOGf1L4HwVAqt9b6ti6ntvzJ5PatfBOI64Q7iG1F0UsstVog2TVbZwvra
         j4FiSJgYR4+lyKJOT9nbFbDH9CIDgAPTUV9gHLsOjKqOHYoZfxORZgN2IvnyfWihmA
         XUmm7MktQb01Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 12/15] devlink: restart dump based on devlink instance ids (function)
Date:   Wed,  4 Jan 2023 20:05:28 -0800
Message-Id: <20230105040531.353563-13-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230105040531.353563-1-kuba@kernel.org>
References: <20230105040531.353563-1-kuba@kernel.org>
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

Use xarray id for cases of sub-objects which are iterated in
a function.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 358cdfbb1393..091f8814185d 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -2547,12 +2547,12 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	struct devlink_sb *devlink_sb;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, state, devlink) {
+		struct devlink_sb *devlink_sb;
+		int idx = 0;
+
 		if (!devlink->ops->sb_pool_get)
 			goto retry;
 
@@ -2567,6 +2567,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 			} else if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				state->idx = idx;
 				goto out;
 			}
 		}
@@ -2578,7 +2579,6 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	state->idx = idx;
 	return msg->len;
 }
 
@@ -2762,12 +2762,12 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	struct devlink_sb *devlink_sb;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, state, devlink) {
+		struct devlink_sb *devlink_sb;
+		int idx = 0;
+
 		if (!devlink->ops->sb_port_pool_get)
 			goto retry;
 
@@ -2782,6 +2782,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 			} else if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				state->idx = idx;
 				goto out;
 			}
 		}
@@ -2793,7 +2794,6 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	state->idx = idx;
 	return msg->len;
 }
 
@@ -3005,12 +3005,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	struct devlink_sb *devlink_sb;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, state, devlink) {
+		struct devlink_sb *devlink_sb;
+		int idx = 0;
+
 		if (!devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
 
@@ -3025,6 +3025,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 			} else if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				state->idx = idx;
 				goto out;
 			}
 		}
@@ -3036,7 +3037,6 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	state->idx = idx;
 	return msg->len;
 }
 
@@ -6085,19 +6085,20 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *state = devlink_dump_state(cb);
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, state, devlink) {
+		int idx = 0;
+
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
 							       &idx, state->idx);
 		devlink_put(devlink);
-		if (err)
+		if (err) {
+			state->idx = idx;
 			goto out;
+		}
 	}
 out:
-	state->idx = idx;
 	return msg->len;
 }
 
-- 
2.38.1

