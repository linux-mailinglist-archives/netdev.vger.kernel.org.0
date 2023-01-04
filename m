Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02C2A65CC53
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 05:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238779AbjADERP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 23:17:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238547AbjADEQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 23:16:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636781705D
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:16:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 116B9B811E0
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 04:16:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F93BC43392;
        Wed,  4 Jan 2023 04:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672805810;
        bh=Djq7oIZ+dFtDZ+4xbGlNyLLkBZO6yAI76Jz7mcHncRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4O94YP/uyeThXCukBASd8Kpquz7c0uQofZOWnZGDEFh78EMLGp8KNZz1tV4Zu262
         8H4gJ+66UTxYk6A3qqjyrXA+EXIKuaFhvDpt1S883ttuAwEd5EsBf5IM+Sy89cEtxB
         RNjBW5wjzC58liccMrzO1jruYkDHljfpxkxsiauHKKy/p9fBcU9k9W8ZFWi47+w54O
         xOpuVdRz4QynI5l18yCBkJR9YQYx1oTbkb6/20htikCkg+FszcY9o5lXJMQxtqq3Hy
         pq4E3gK0K3ZvlQXwyL8wGL5TKn6K9xTobk9iOo4TSCKO+7+ZyZToqsGRK8XAHHH4YE
         RcxuNRgR2aOLg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 12/14] devlink: uniformly take the devlink instance lock in the dump loop
Date:   Tue,  3 Jan 2023 20:16:34 -0800
Message-Id: <20230104041636.226398-13-kuba@kernel.org>
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

Move the lock taking out of devlink_nl_cmd_region_get_devlink_dumpit().
This way all dumps will take the instance lock in the main iteration
loop directly, making refactoring and reading the code easier.

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index d01089b65ddc..c6ad8133fc23 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -6050,9 +6050,8 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	struct devlink_region *region;
 	struct devlink_port *port;
 	unsigned long port_index;
-	int err = 0;
+	int err;
 
-	devl_lock(devlink);
 	list_for_each_entry(region, &devlink->region_list, list) {
 		if (*idx < start) {
 			(*idx)++;
@@ -6064,7 +6063,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 					     cb->nlh->nlmsg_seq,
 					     NLM_F_MULTI, region);
 		if (err)
-			goto out;
+			return err;
 		(*idx)++;
 	}
 
@@ -6072,12 +6071,10 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 		err = devlink_nl_cmd_region_get_port_dumpit(msg, cb, port, idx,
 							    start);
 		if (err)
-			goto out;
+			return err;
 	}
 
-out:
-	devl_unlock(devlink);
-	return err;
+	return 0;
 }
 
 static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
@@ -6090,8 +6087,10 @@ static int devlink_nl_cmd_region_get_dumpit(struct sk_buff *msg,
 	devlink_dump_for_each_instance_get(msg, dump, devlink) {
 		int idx = 0;
 
+		devl_lock(devlink);
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
 							       &idx, dump->idx);
+		devl_unlock(devlink);
 		devlink_put(devlink);
 		if (err) {
 			dump->idx = idx;
-- 
2.38.1

