Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5583164F6BD
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 02:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiLQBUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 20:20:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiLQBUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 20:20:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8BC680A6
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 17:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74F5C62314
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 01:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18613C433EF;
        Sat, 17 Dec 2022 01:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671240011;
        bh=G/4KnMUzTz4d0LyHi+EyMPb1vvsCK1YgkZza0J7UpPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjT30a8ZFlK8Wlb0+gUwEy8+BIOsNBwknd2OrT3VBWpcoH0gvSNIlPx8DQxVfCIhC
         gB1fnOFi4en95z0mpk6NZMBibBq7ZPBT2JKfUUfcp+OyXrDVWREQoRtdsio9tkmT+h
         UBIDHWqxiSAEfF8iwO/LplYxEjmjL7CtQ1CWafOsaLsZv1yDThhg1vBw0mjDWatExu
         txOMwcrpycH/A9kdqPjzkKOK3zPJ8uLS+mGOHy7zNQVfuBu2mUyhiVX+ewyu/l9t3b
         jwF8kGZHC0z3ivL7nxYU83epBLA1HpjMEN+YFTVHsPkLs5RTEIj2E6ujdjLtR9G0ZK
         zdE42K6siCKMw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     jiri@resnulli.us, jacob.e.keller@intel.com, leon@kernel.org
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [RFC net-next 06/10] devlink: don't require setting features before registration
Date:   Fri, 16 Dec 2022 17:19:49 -0800
Message-Id: <20221217011953.152487-7-kuba@kernel.org>
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

Requiring devlink_set_features() to be run before devlink is
registered is overzealous. devlink_set_features() itself is
a leftover from old workarounds which were trying to prevent
initiating reload before probe was complete.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 413b92534ad6..f30fc167c8ad 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -131,8 +131,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
  */
 void devlink_set_features(struct devlink *devlink, u64 features)
 {
-	ASSERT_DEVLINK_NOT_REGISTERED(devlink);
-
 	WARN_ON(features & DEVLINK_F_RELOAD &&
 		!devlink_reload_supported(devlink->ops));
 	devlink->features = features;
-- 
2.38.1

