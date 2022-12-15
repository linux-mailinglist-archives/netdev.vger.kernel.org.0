Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6264D537
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiLOCC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiLOCCT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEC356D6A
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BDD8B81ADA
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB9BC433D2;
        Thu, 15 Dec 2022 02:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069729;
        bh=CWIkX03YSevv9ITYkgpaz/E592bS943UtMIQw4L+VS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auvZCD2vZXX+P05Seh+JPBHW55FTqHwHooZ6h9ulNYNtB6/MObks9fns9M9Cbvm6Q
         o0EEc6pxMnaYVp/yGgrrffyI54/7Oy6fWm3ZkdpHg0UsRLT9ejP3NKak/ie6wwPGqu
         KYw2KSYk3i83AQNJgfb716Phdh4nR1Z0FWswXkq45EKRO5LBi04q6q5KROxXocilw6
         vEcpFZC3iJuDXvs3lPQcO3vrUrCC0ibUN4EqwdRuqkap6l+tYjUBwWbFXGjODeAu1t
         LcRKqjJkXkw8iP+ziweInxkhZmFyBik+usuEWTExJeDmZ+OUePGoMkq+XF7cMYJHRu
         m+fFwyNfnw2rQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 12/15] devlink: restart dump based on devlink instance ids (function)
Date:   Wed, 14 Dec 2022 18:01:52 -0800
Message-Id: <20221215020155.1619839-13-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020155.1619839-1-kuba@kernel.org>
References: <20221215020155.1619839-1-kuba@kernel.org>
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

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/basic.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index 028a763feb50..d01089b65ddc 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
@@ -2547,12 +2547,12 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	struct devlink_sb *devlink_sb;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_sb *devlink_sb;
+		int idx = 0;
+
 		if (!devlink->ops->sb_pool_get)
 			goto retry;
 
@@ -2567,6 +2567,7 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 			} else if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 		}
@@ -2578,7 +2579,6 @@ static int devlink_nl_cmd_sb_pool_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -2762,12 +2762,12 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	struct devlink_sb *devlink_sb;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_sb *devlink_sb;
+		int idx = 0;
+
 		if (!devlink->ops->sb_port_pool_get)
 			goto retry;
 
@@ -2782,6 +2782,7 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 			} else if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 		}
@@ -2793,7 +2794,6 @@ static int devlink_nl_cmd_sb_port_pool_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -3005,12 +3005,12 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	struct devlink_sb *devlink_sb;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		struct devlink_sb *devlink_sb;
+		int idx = 0;
+
 		if (!devlink->ops->sb_tc_pool_bind_get)
 			goto retry;
 
@@ -3025,6 +3025,7 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 			} else if (err) {
 				devl_unlock(devlink);
 				devlink_put(devlink);
+				dump->idx = idx;
 				goto out;
 			}
 		}
@@ -3036,7 +3037,6 @@ devlink_nl_cmd_sb_tc_pool_bind_get_dumpit(struct sk_buff *msg,
 	if (err != -EMSGSIZE)
 		return err;
 
-	dump->idx = idx;
 	return msg->len;
 }
 
@@ -6085,19 +6085,20 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 {
 	struct devlink_nl_dump_state *dump = devl_dump_state(cb);
 	struct devlink *devlink;
-	unsigned long index;
-	int idx = 0;
 	int err = 0;
 
-	devlinks_xa_for_each_registered_get(sock_net(msg->sk), index, devlink) {
+	devlink_dump_for_each_instance_get(msg, dump, devlink) {
+		int idx = 0;
+
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
 							       &idx, dump->idx);
 		devlink_put(devlink);
-		if (err)
+		if (err) {
+			dump->idx = idx;
 			goto out;
+		}
 	}
 out:
-	dump->idx = idx;
 	return msg->len;
 }
 
-- 
2.38.1

