Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C0C65E465
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:06:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbjAEEGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbjAEEFq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0931C37253
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9502D6183B
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175DBC433F1;
        Thu,  5 Jan 2023 04:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891544;
        bh=NmZA5va5eeKiNrlyQthtNmv/C0s4F4p9fY2ZVapW3rQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ctpKNdx21DPpcNtI4bQtBhQx7KfQqXcrWJ+rx7iwlz4z8+Od5kyNz7tPGxEYnJ4gi
         IMc9GUTAuyIytzGPTwXScMt7uCki1K3Peg+U+V0Ymt8qWG/RabW9ElPuZRKQXwogEo
         sncWSdTwt0FvaziLUeRaTLyTQVfO27nJUsd8rH+Ryt4Z73cUG0apt0vRBNSOzBAEU8
         Y9STaRlEWUtDDFvj7q5+UADWAStCGIEu1HX6Ia9L47zreMu48WRB6Vfw0gZQT4ahTW
         S0mQBtngD5q7YddwN2GH/adYzEPk0aIDO04oWg9R2WSAISUSj9zuFe+Ej7drOT30sc
         7x6sbDHo4gfow==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 13/15] devlink: uniformly take the devlink instance lock in the dump loop
Date:   Wed,  4 Jan 2023 20:05:29 -0800
Message-Id: <20230105040531.353563-14-kuba@kernel.org>
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

Move the lock taking out of devlink_nl_cmd_region_get_devlink_dumpit().
This way all dumps will take the instance lock in the main iteration
loop directly, making refactoring and reading the code easier.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 091f8814185d..4c91143d0792 100644
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
 	devlink_dump_for_each_instance_get(msg, state, devlink) {
 		int idx = 0;
 
+		devl_lock(devlink);
 		err = devlink_nl_cmd_region_get_devlink_dumpit(msg, cb, devlink,
 							       &idx, state->idx);
+		devl_unlock(devlink);
 		devlink_put(devlink);
 		if (err) {
 			state->idx = idx;
-- 
2.38.1

