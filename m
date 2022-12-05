Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BDA642B9F
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:26:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiLEP0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:26:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiLEPZ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:25:59 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF93A12089
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:23:15 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id ml11so28661686ejb.6
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SVP0AyEmVbTokYrTnscONR2H42l3s+jnJiE/U2Sqz3I=;
        b=GKYh4mlXq1n33ykv9UXS51k36ckmOOdVeR8RJ3okoeezuOsoSYfjTUhBn8/nYgUECC
         D/BQKwm5V/XZkD+rLSBcIo4hiDJGA9Z5JgGdtxILyi7nWZICem4DHOl4UjrRGpY+HswC
         lCiYoa2qo6JsD5JXmiFYaYraQ4jo0wmdvw656v+y9b8zzAMQkSKHiqHWiyWJp7m3ymns
         pZKU3wAhYIoyo13Rj6hXNIV0DxAJmBse40AzwW5OcHbnRKLMfpLPsu/ya8knRJLDdeoe
         iBt632XrW6Y4Qyv/xcbXJHGpk0XmfAj/A9Cn4IceHw4F9AASd7nAkEMm3AFbbRuUnat+
         0QEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SVP0AyEmVbTokYrTnscONR2H42l3s+jnJiE/U2Sqz3I=;
        b=Ou88Q5VqF0/PCLTqx83ia3GczODSD5Tvn4TNsM0FY+Ye0M+MaEoIBaMhmIhAkE7kFW
         L/BziGU+ylTUPPJzwdIVL+zsQtB0oSAHOCq/1wNaAkAP2SeDaaQucfD0kU0FKnMMsucz
         bmXDaiZTnkmPgxisQVx4eTN7ZscBxlNTpTiqe7jqKoXBuBx7igCH9uJbK/xbbc1duVe8
         dqrkYRrcyMCuo5ZlSWW7zgN9QLXKaiYJ2zY22kjkHyHgvUrONsCY6HwnOCK9nXkjVEph
         V8j+b2PWol7RdslBjlbwcl8ucb6obDmiaJmK6g4hI/vFnLMKtN1RIbR7j0ds0nq3kuXd
         x4QQ==
X-Gm-Message-State: ANoB5pmBU8YQyCeurz3+guoomrmFZK7Q8nTGWguyA6wfIaJb86LChG8l
        EOCMqd/K6F9U0JoAEGhxMjqgJCWwjsidJK08X104Pw==
X-Google-Smtp-Source: AA0mqf5L2ExlwVfSpKS/lhNJkUpvEjoYB7kAJiB+w1GRQXBBeU+ghf/1YjdaQiGRXVBLVidP/sVtlA==
X-Received: by 2002:a17:907:6daa:b0:7ba:e537:c64b with SMTP id sb42-20020a1709076daa00b007bae537c64bmr48589991ejc.180.1670253794295;
        Mon, 05 Dec 2022 07:23:14 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h23-20020a1709060f5700b007bfacaea851sm6279801ejj.88.2022.12.05.07.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:23:13 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: [patch net-next 7/8] devlink: assert if devl_port_register/unregister() is called on unregistered devlink instance
Date:   Mon,  5 Dec 2022 16:22:56 +0100
Message-Id: <20221205152257.454610-8-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205152257.454610-1-jiri@resnulli.us>
References: <20221205152257.454610-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Now when all drivers do call devl_port_register/unregister() within the
time frame during which the devlink is registered, put and assertion to
the functions to check that and avoid going back.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
RFC->v1:
- rebased
---
 net/core/devlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 907df7124157..9b9775bc10b3 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10084,6 +10084,7 @@ int devl_port_register(struct devlink *devlink,
 {
 	int err;
 
+	ASSERT_DEVLINK_REGISTERED(devlink);
 	devl_assert_locked(devlink);
 
 	ASSERT_DEVLINK_PORT_NOT_REGISTERED(devlink_port);
@@ -10142,6 +10143,7 @@ EXPORT_SYMBOL_GPL(devlink_port_register);
  */
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
+	ASSERT_DEVLINK_REGISTERED(devlink_port->devlink);
 	lockdep_assert_held(&devlink_port->devlink->lock);
 	WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
 
-- 
2.37.3

