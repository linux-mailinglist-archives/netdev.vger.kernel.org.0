Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791FF5630D3
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 11:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234346AbiGAJ7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 05:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbiGAJ7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 05:59:33 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF9CD58FC8
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 02:59:31 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id o25so3136492ejm.3
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 02:59:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jC5TGMHuzDR4UggSsCXw2A6RZ1JvL6ydOH8TZ8J3Mjo=;
        b=wOGizbDKUQ4AjCL9LY/5je9wfsHBTAdk7mh+l8331U/xAYdJ0CngAha379C8UXXiVt
         /4uM9C6NOJozHxektrRuJym/ZQN1eeDLitSR0UuAfp6hKhbogLasQwZfxP2P2e+nWwvE
         fbUlxetWcWp2PhjcCbXQtTyyZArKVBtRB0YkuiRA0ETG2/loOUrxTYKiA0SKzZAZclPB
         wV7SCtgDPJ349s8qvhjvSf0Hj91w2YS0M9x3Uo5iZrAkz8bDrYbC5aMCxvSpIc9LSuUM
         JkNZPi1TaTGiYfg5s49V8jlG0b54r7bA5W6SF3xVa53uIERxEzYRvtYgL6bK/VZ0F8p+
         9h9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jC5TGMHuzDR4UggSsCXw2A6RZ1JvL6ydOH8TZ8J3Mjo=;
        b=FT0ZI2kvFlN1t2wy3J4q8jNIi8dGVD69NHu3BkBcobFbZwvjfzFuAkJYLlTLvMRgMj
         V9qBURxlO/0mF72LrN2ZZJ2HBx9RwLH2GkI4c3vprwD5kwpSLykmx9349jkhh/+iVazP
         R9p2Xi0au7CIe1h0a/Bn5+gOVqim/LGpy23gxEbL+Mt6eDhmB7zsOpWlhVKcwwaHxO/h
         13eXKSgBXbeqV/CjpVO17Hat9eTCO/NPUpW/QLwuBAFuSJe1tDLEAg9nh7x/axE8odbY
         TV7eO7LZinSege0Q26SS3+m0KajwA+53DIsqVpgTqGf5jWxNpKJzLhkDnvjXMaikixno
         tjlg==
X-Gm-Message-State: AJIora+fan1GNzvWJFUWaclTJp4nH6cn1QT2oBJgmqItNFVVI5hYHFO2
        Fkngj4KDx9WhMf24VWuKh3oY+wlI8PBsN8Yw
X-Google-Smtp-Source: AGRyM1uPbtccZT/0yJ20aqAcb7tAdK3/IVvaw1pyysmN/ssHO5WR3nbFPpnQe0PTFTxUThdXV+4gkg==
X-Received: by 2002:a17:906:49d4:b0:6d6:e5ec:9a23 with SMTP id w20-20020a17090649d400b006d6e5ec9a23mr14197815ejv.79.1656669570274;
        Fri, 01 Jul 2022 02:59:30 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id k25-20020aa7d8d9000000b004356c18b2b9sm14758516eds.44.2022.07.01.02.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 02:59:29 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next 2/3] net: devlink: call lockdep_assert_held() for devlink->lock directly
Date:   Fri,  1 Jul 2022 11:59:25 +0200
Message-Id: <20220701095926.1191660-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220701095926.1191660-1-jiri@resnulli.us>
References: <20220701095926.1191660-1-jiri@resnulli.us>
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

In devlink.c there is direct access to whole struct devlink so there is
no need to use helper. So obey the customs and work with lock directly
avoiding helpers which might obfuscate things a bit.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 25b481dd1709..a7477addbd59 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10185,7 +10185,7 @@ int devl_rate_leaf_create(struct devlink_port *devlink_port, void *priv)
 	struct devlink *devlink = devlink_port->devlink;
 	struct devlink_rate *devlink_rate;
 
-	devl_assert_locked(devlink_port->devlink);
+	lockdep_assert_held(&devlink_port->devlink->lock);
 
 	if (WARN_ON(devlink_port->devlink_rate))
 		return -EBUSY;
@@ -10224,7 +10224,7 @@ void devl_rate_leaf_destroy(struct devlink_port *devlink_port)
 {
 	struct devlink_rate *devlink_rate = devlink_port->devlink_rate;
 
-	devl_assert_locked(devlink_port->devlink);
+	lockdep_assert_held(&devlink_port->devlink->lock);
 	if (!devlink_rate)
 		return;
 
@@ -10270,7 +10270,7 @@ void devl_rate_nodes_destroy(struct devlink *devlink)
 	static struct devlink_rate *devlink_rate, *tmp;
 	const struct devlink_ops *ops = devlink->ops;
 
-	devl_assert_locked(devlink);
+	lockdep_assert_held(&devlink->lock);
 
 	list_for_each_entry(devlink_rate, &devlink->rate_list, list) {
 		if (!devlink_rate->parent)
-- 
2.35.3

