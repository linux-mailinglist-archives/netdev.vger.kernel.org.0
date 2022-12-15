Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0622164D533
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLOCCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiLOCCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:02:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 679D156D65
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:02:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14E6EB81AD8
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:02:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BEFC433F0;
        Thu, 15 Dec 2022 02:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069729;
        bh=NB+FgTDeEIFB9LwxX0Ypv0/hq/329HkZvG+AA5CF5EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNQ9Sa6Y1THoI8aR/nUTFTGorkR7ZeST9ZMpD6q+guqNwioB7oPihT6eedXgbMVMD
         VzdDb9gEjmBxi262KOrovuEHGXJs4R09UbZ4Mrm3NlbHlIF8addQv1ANTxKC1ly8W+
         IVVF5/8GbkGCXAtiQuAoTUTqu0s3FWwCSmaUOMupj5MUfOtbGNF67ebUVhFCcqZszK
         dANbyIcpfFgg2cNZhwtc1qofZKK8XyN8qr19DjHrBclTLZeK7QvYz0Tngyv/oesFTH
         AzaDi0kUplPjW2j5Su0HwaTZ0RBBeinV9ic3EyzpeGWCfvog6mF7J7eugHtE6PAvNy
         xoiAjdtQZ4KAg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 13/15] devlink: uniformly take the devlink instance lock in the dump loop
Date:   Wed, 14 Dec 2022 18:01:53 -0800
Message-Id: <20221215020155.1619839-14-kuba@kernel.org>
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

Move the lock taking out of devlink_nl_cmd_region_get_devlink_dumpit().
This way all dumps will take the instance lock in the main iteration
loop directly, making refactoring and reading the code easier.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/basic.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/devlink/basic.c b/net/devlink/basic.c
index d01089b65ddc..c6ad8133fc23 100644
--- a/net/devlink/basic.c
+++ b/net/devlink/basic.c
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

