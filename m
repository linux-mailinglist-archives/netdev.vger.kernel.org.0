Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B96264D524
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 03:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiLOCBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 21:01:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbiLOCBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 21:01:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194872ED6D
        for <netdev@vger.kernel.org>; Wed, 14 Dec 2022 18:01:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4EDBBCE1BBC
        for <netdev@vger.kernel.org>; Thu, 15 Dec 2022 02:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04411C433EF;
        Thu, 15 Dec 2022 02:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671069668;
        bh=jnjJ7WPsI5Zm/XZAhem2UgFQ6SMyD15ZeIo6ytQ8XdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVL6zPKfn7xgL/fRqkYBDpwnV8lNvodgNQkEmxK7AcF8p9ZjPcPU2sZLd0FKFVeMB
         +M1WeC6N6wHXZueVylbElNpZdMeRqnDah5LhGmq2c4xxjNIwHzVp8C+GEe4mx9mi8b
         P7y4fV5LrP6A5wBiVixQa96ZzWwx2rcxlwHrRz5YGH8aLXJ7DG93k3J7bN8tliw6aj
         ykIL6JFY3MllqEvEoCTHe0E6EUsZhTTWGXAqFstJiUTRfszxwPz986/Eb/0qdqmFSE
         2GYNbKwmBE+hS5s0XFjZq6uK16+hHTh3KRBpDEl3O3eGQ8VOmzq0fIFJqdsjF5ZHiK
         D5jBrpyZBDeCA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jiri@resnulli.us, jacob.e.keller@intel.com,
        Jakub Kicinski <kuba@kernel.org>, jiri@nvidia.com
Subject: [PATCH net 1/3] devlink: hold region lock when flushing snapshots
Date:   Wed, 14 Dec 2022 18:01:00 -0800
Message-Id: <20221215020102.1619685-2-kuba@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221215020102.1619685-1-kuba@kernel.org>
References: <20221215020102.1619685-1-kuba@kernel.org>
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

Netdevsim triggers a splat on reload, when it destroys regions
with snapshots pending:

  WARNING: CPU: 1 PID: 787 at net/core/devlink.c:6291 devlink_region_snapshot_del+0x12e/0x140
  CPU: 1 PID: 787 Comm: devlink Not tainted 6.1.0-07460-g7ae9888d6e1c #580
  RIP: 0010:devlink_region_snapshot_del+0x12e/0x140
  Call Trace:
   <TASK>
   devl_region_destroy+0x70/0x140
   nsim_dev_reload_down+0x2f/0x60 [netdevsim]
   devlink_reload+0x1f7/0x360
   devlink_nl_cmd_reload+0x6ce/0x860
   genl_family_rcv_msg_doit.isra.0+0x145/0x1c0

This is the locking assert in devlink_region_snapshot_del(),
we're supposed to be holding the region->snapshot_lock here.

Fixes: 2dec18ad826f ("net: devlink: remove region snapshots list dependency on devlink->lock")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: jiri@nvidia.com
---
 net/core/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 6004bd0ccee4..d2df30829083 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11925,8 +11925,10 @@ void devl_region_destroy(struct devlink_region *region)
 	devl_assert_locked(devlink);
 
 	/* Free all snapshots of region */
+	mutex_lock(&region->snapshot_lock);
 	list_for_each_entry_safe(snapshot, ts, &region->snapshot_list, list)
 		devlink_region_snapshot_del(region, snapshot);
+	mutex_unlock(&region->snapshot_lock);
 
 	list_del(&region->list);
 	mutex_destroy(&region->snapshot_lock);
-- 
2.38.1

