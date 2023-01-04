Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2096E65CC47
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238688AbjADERF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:17:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238441AbjADEQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:16:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96E6167FD
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:16:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74FEC60B7F
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02709C43396;
        Wed,  4 Jan 2023 04:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672805810;
        bh=kBNSh+yuNVz7m0ROmk4xpu5N5L4yNDxCauR/AkasrbI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FUKxANcXe84eNwaKMEvN00HJR4len3+gg6bUMqF97DI853RXrhTSOvT1WsZzoN0YN
         N4+yvBTwDH0CuE+HRsFICfvlo0VVd2dS9kmkW92p7Bt3wvWW8wI/Gk34nR+ZQzKMob
         yN4WgiZTgpzOhjOhzEziMfL0MBp0Ui/ItvH2S1NA4vjJqX0OeSr1dOvnzfxGzpVA7v
         gEGg9yR+QLMF1X83oCM4TyP5fXKE7GL3KgRMNjmurtlVO9GMGGS6fOdvKIpiy+6Oj3
         C/fMelBHFWXF4/698Q6ya6dUnYdWySrR49rxzjAhv1hS6ppmXWHm2JiqhQL7mukBie
         WtA0UbT9ix7DA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 11/14] devlink: restart dump based on devlink instance ids (function)
Date:   Tue,  3 Jan 2023 20:16:33 -0800
Message-Id: <20230104041636.226398-12-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230104041636.226398-1-kuba@kernel.org>
References: <20230104041636.226398-1-kuba@kernel.org>
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

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 028a763feb50..d01089b65ddc 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
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

