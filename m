Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8D657043B
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiGKN0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiGKN0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:26:13 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4706633413
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:26:12 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id r129-20020a1c4487000000b003a2d053adcbso4986072wma.4
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Nw/aImixlglCx4k/7N+n3bLHGBwdC0nf40VGZYRhBQ=;
        b=DtAn8gJ7D2xaUP54YjJNlIEI1hC45dxurj42lnn2se42UZwpZa8Tr6i6te1Xgwn/ow
         HRcrQt/DgEgJ9xIv7jZj9DAp1QKOzR9ooeGZLFMEPLCCqXvHJiADoe63ObXNaO8ABYMW
         4C2i7kZ50g0MTbXHqQD4ifq0aGIL8JBDS54JFyk3vASnamzydCGucXudqmJG2mAHJcxA
         wI2aLMMzfp+3Cn43OZGEHyu/pquedBdnnEGroq86hk3nBTIO6amcxZBA5asp6+wuSR1F
         sA5L+aMRDyrphAo8ZcdXxBKH6ZZOOxjbmddXuKZZniWqnIRZXlBCr745BsrWgw615N5y
         QhJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Nw/aImixlglCx4k/7N+n3bLHGBwdC0nf40VGZYRhBQ=;
        b=2zmEXvxyGBjNWzu9tR0xfupzMgiLmKBQH7fUt4A828yCHlwH8ZvafdiOGA7j8dv3h/
         DqvS78HKfqfbOxdctbqkQcvQrHZP1QAmSbj7XV3r61U2CSeNcJ4EFZ+2nOVO5o+tvMde
         bc8ATe1L8F+E9eTpdFsgoUAS2luERn/wlxMLzOuQW8a5NWBS/yOZzVTdAUeDBzS8QzV0
         2g1CrsOBsg8UZpKVum0qaoflqkoGidUbhUCu5MaVmqXcb+ZohLeXDRug4PeUKX6zhf/t
         rVT3XJbvAT7ClUMAJ080P2VLYpdbThbQ3UudvwzbdnDFRcDcBXXsKbyesclCCa1JBLBz
         wJWg==
X-Gm-Message-State: AJIora+H6sE9dpIxHvfX+XCN+8W2woixxej1duyvgqddWgjKHnQdASfQ
        TQvvMMh6EQFBprX3wSRvehoAE9vR074IHiQsRiE=
X-Google-Smtp-Source: AGRyM1t3LaFH5X35Vq//KOdvwQEF4Kdv1aXqTa5Et0CRT4T6dMhlv6+uUyeqC6dNvYGaR89Qa8julw==
X-Received: by 2002:a05:600c:1e8e:b0:3a2:c1b4:922c with SMTP id be14-20020a05600c1e8e00b003a2c1b4922cmr16243130wmb.24.1657545970776;
        Mon, 11 Jul 2022 06:26:10 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l23-20020a1ced17000000b003a03ae64f57sm6713991wmh.8.2022.07.11.06.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 06:26:10 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v3/repost 1/3] net: devlink: fix unlocked vs locked functions descriptions
Date:   Mon, 11 Jul 2022 15:26:05 +0200
Message-Id: <20220711132607.2654337-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220711132607.2654337-1-jiri@resnulli.us>
References: <20220711132607.2654337-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

To be unified with the rest of the code, the unlocked version (devl_*)
of function should have the same description in documentation as the
locked one. Add the missing documentation. Also, add "Context"
annotation for the locked versions where it is missing.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
v1->v2:
- s/devlink_/devl_/ for unregister comment
- removed tabs
- added ()s
---
 net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index db61f3a341cb..0bb9b1f497c7 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9677,6 +9677,19 @@ static void devlink_port_type_warn_cancel(struct devlink_port *devlink_port)
 	cancel_delayed_work_sync(&devlink_port->type_warn_dw);
 }
 
+/**
+ * devl_port_register() - Register devlink port
+ *
+ * @devlink: devlink
+ * @devlink_port: devlink port
+ * @port_index: driver-specific numerical identifier of the port
+ *
+ * Register devlink port with provided port index. User can use
+ * any indexing, even hw-related one. devlink_port structure
+ * is convenient to be embedded inside user driver private structure.
+ * Note that the caller should take care of zeroing the devlink_port
+ * structure.
+ */
 int devl_port_register(struct devlink *devlink,
 		       struct devlink_port *devlink_port,
 		       unsigned int port_index)
@@ -9715,6 +9728,8 @@ EXPORT_SYMBOL_GPL(devl_port_register);
  *	is convenient to be embedded inside user driver private structure.
  *	Note that the caller should take care of zeroing the devlink_port
  *	structure.
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
@@ -9729,6 +9744,11 @@ int devlink_port_register(struct devlink *devlink,
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
 
+/**
+ * devl_port_unregister() - Unregister devlink port
+ *
+ * @devlink_port: devlink port
+ */
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
 	lockdep_assert_held(&devlink_port->devlink->lock);
@@ -9746,6 +9766,8 @@ EXPORT_SYMBOL_GPL(devl_port_unregister);
  *	devlink_port_unregister - Unregister devlink port
  *
  *	@devlink_port: devlink port
+ *
+ *	Context: Takes and release devlink->lock <mutex>.
  */
 void devlink_port_unregister(struct devlink_port *devlink_port)
 {
@@ -10006,6 +10028,15 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 }
 EXPORT_SYMBOL_GPL(devl_rate_leaf_create);
 
+/**
+ * devlink_rate_leaf_create - create devlink rate leaf
+ * @devlink_port: devlink port object to create rate object on
+ * @priv: driver private data
+ *
+ * Create devlink rate object of type leaf on provided @devlink_port.
+ *
+ * Context: Takes and release devlink->lock <mutex>.
+ */
 int
 devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 {
@@ -10020,6 +10051,11 @@ devlink_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 }
 EXPORT_SYMBOL_GPL(devlink_rate_leaf_create);
 
+/**
+ * devl_rate_leaf_destroy - destroy devlink rate leaf
+ *
+ * @devlink_port: devlink port linked to the rate object
+ */
 void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
 {
 	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
-- 
2.35.3

