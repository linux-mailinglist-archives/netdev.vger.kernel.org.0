Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB5EE65E45B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbjAEEFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjAEEFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:05:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7B937253
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:05:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BA39B819B1
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:05:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00F3C43392;
        Thu,  5 Jan 2023 04:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672891539;
        bh=w4pAKtOPFGZwGtoBFLLkpmPVk3XOhAWzgO7WSjs+Xdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTKaLBRISr0PmiMOp6q08kc9ansuq/vPTJtwZWU0KHBFapJqhPfOB6yPjTP1mPQuU
         ojKnc2eElDL9L3AhKCjxxsgNObnqw1gU2V1mOJD3b6TRWFMpD3jLr6YrEjopsE+8QG
         nUcHAy6scfgYImsX0DIOJQ4YP7B62uziGbwQLjhWgcGtHppOtexbzMAe/JsARGMNlE
         IUhg2fBJSyzMhrbT7Rdpp01mInY1WahLc7SZ0gvzZaUbI26kjCxvLsFrlOnjW+0lCt
         wQt+3j+er+eLouw4+zuIm01nIx2Yh8TzsY2pNrixykmYHiEM3ALX1xh72J9J76SD+l
         N4a0n/5B2fhwA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        jacob.e.keller@intel.com, jiri@resnulli.us,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 02/15] devlink: rename devlink_netdevice_event -> devlink_port_netdevice_event
Date:   Wed,  4 Jan 2023 20:05:18 -0800
Message-Id: <20230105040531.353563-3-kuba@kernel.org>
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

To make the upcoming change a pure(er?) code move rename
devlink_netdevice_event -> devlink_port_netdevice_event.
This makes it clear that it only touches ports and doesn't
belong cleanly in the core.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 032d6d0a5ce6..1221c7277c0b 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9942,8 +9942,8 @@ void devlink_set_features(struct devlink *devlink, u64 features)
 }
 EXPORT_SYMBOL_GPL(devlink_set_features);
 
-static int devlink_netdevice_event(struct notifier_block *nb,
-				   unsigned long event, void *ptr);
+static int devlink_port_netdevice_event(struct notifier_block *nb,
+					unsigned long event, void *ptr);
 
 /**
  *	devlink_alloc_ns - Allocate new devlink instance resources
@@ -9978,7 +9978,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 	if (ret < 0)
 		goto err_xa_alloc;
 
-	devlink->netdevice_nb.notifier_call = devlink_netdevice_event;
+	devlink->netdevice_nb.notifier_call = devlink_port_netdevice_event;
 	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
 	if (ret)
 		goto err_register_netdevice_notifier;
@@ -10480,8 +10480,8 @@ void devlink_port_type_clear(struct devlink_port *devlink_port)
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-static int devlink_netdevice_event(struct notifier_block *nb,
-				   unsigned long event, void *ptr)
+static int devlink_port_netdevice_event(struct notifier_block *nb,
+					unsigned long event, void *ptr)
 {
 	struct net_device *netdev = netdev_notifier_info_to_dev(ptr);
 	struct devlink_port *devlink_port = netdev->devlink_port;
-- 
2.38.1

