Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F4065FB7C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 07:34:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbjAFGeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 01:34:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231495AbjAFGeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 01:34:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815F16E0FE
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 22:34:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F7E661D3A
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 06:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E43FC433F0;
        Fri,  6 Jan 2023 06:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672986849;
        bh=DX8D7va/x/euBLTkXY4R8x0u5ES46bDaeKv0voM01yU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OX6QRtyC1D7vUjLg/ejuaC6OtjFTigR+96O0OTHvIFPMgy947HX2zTeiFUJzY4EQd
         5scr76m/fJ7qPkTw07wH/W5YVrib+QS0X7/BrWo6NWLBX8UrBVrdeu28AvPPVjN08a
         F6g41oZHJviZuIVHVBhLMUjg8/OgD7NFMcBjnBt/QPDT3VvXANTNgq2NonjqF4q9Xw
         yy3OGpxe4QJo51e/GQSw52YLLtQ18HOHC5xHOZxCZyWtEcG3kx0qNMaT/0DxqPAjXF
         AJc7EQJ19cVl+/FIJvbbLdRvXPJDYnRbMXW39LOm9MayaBtx8b+O2vIkejCq4XibJA
         yfr/D41fdbZ8Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 6/9] devlink: don't require setting features before registration
Date:   Thu,  5 Jan 2023 22:33:59 -0800
Message-Id: <20230106063402.485336-7-kuba@kernel.org>
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

Requiring devlink_set_features() to be run before devlink is
registered is overzealous. devlink_set_features() itself is
a leftover from old workarounds which were trying to prevent
initiating reload before probe was complete.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 7cf0b3efbb2f..a31a317626d7 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -125,8 +125,6 @@ struct devlink *devlinks_xa_find_get(struct net *net, unsigned long *indexp)
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

