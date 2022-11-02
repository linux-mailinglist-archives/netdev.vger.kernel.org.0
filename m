Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB366166E8
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiKBQDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiKBQCd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:02:33 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0C02C67D
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:02:29 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w14so25200614wru.8
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 09:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeEG84ShhdCfRruT4hxrr8t/aoGHb3f77grm4bwgQyI=;
        b=ZeQ4SvR1Kr39bmTHz2yBwzlEZWB3HZEwElltQBJXUyalpCkzCQdnnzfEWrcCQykddq
         +JNr/eATM4xxzYeKG6JBjN0kLHw2ggsKR+iaQmSBAQ1Hq3LgcCt968v0XPJ8HTXIVdB0
         EFlP826AaDuPPOkwKrUzKO8fZdFagEqfdakwQsF0upLENAYMj1PNRb/xgTNUXLRnQPg6
         6pnEngRt9UjbW1eAOiQ2sIlLDCgsjc+GqU6Jk26WHD5k89eWuNo3hi2RNFi7fKS7TULu
         wNVEFrq37WVDMlBrWXWZIuMaSF4F2CSdcPpzPkpfEeTFnO20hkjk2zs1u4p3eGzawS6N
         +3bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qeEG84ShhdCfRruT4hxrr8t/aoGHb3f77grm4bwgQyI=;
        b=lQRv4JBM7PJc3rO9pop01PkBb85AhiRLdPQXbRp77n/WuckFLczSgXH3sGVJVJ1PFo
         zuixHR4M3ELEqepPlFQHwJ9kxzzRnHCCmSAhp0VRYSSDJc9grDU54AArulOERs9Js7vr
         UWnOCU8ygCw2zYP4fYRTgmJyym4KcgV+0I05LmbiKHwKb6zpagLz8255un21gbV90lwN
         t496hKLPVk++qi8Crdp2DQutPMRCcRHogQqVz+N3kcUJyLHIkhrU1/sq0d5c2ps1nsQi
         02O2lifIE06Fjzy5Xe5vW6QYH6+mHGpYsoDHYRFXpW/1k0Ds+/Ub7oxWzXBMVryAaW+W
         ZUzQ==
X-Gm-Message-State: ACrzQf0ZDklhY+s2EEqoz9cVCtUr+wj2xksrLTBSdduiy90TuXj/e3PK
        4t49ImL5LUGQWPuUMT3iAyCMbwJMgP0O4K82QbE=
X-Google-Smtp-Source: AMsMyM5YqyPS7e2YBMBWxdaja9Yuops44I1umYCrNxfgkhWPee7fI4EvTPD9YgSErJtGRlUNJqpQeQ==
X-Received: by 2002:a05:6000:11cb:b0:236:b1ad:7ae7 with SMTP id i11-20020a05600011cb00b00236b1ad7ae7mr14544885wrx.608.1667404948718;
        Wed, 02 Nov 2022 09:02:28 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id cy2-20020a056000400200b0022afedf3c87sm13396984wrb.105.2022.11.02.09.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 09:02:28 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v4 10/13] net: devlink: add not cleared type warning to port unregister
Date:   Wed,  2 Nov 2022 17:02:08 +0100
Message-Id: <20221102160211.662752-11-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221102160211.662752-1-jiri@resnulli.us>
References: <20221102160211.662752-1-jiri@resnulli.us>
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

By the time port unregister is called. There should be no type set. Make
sure that the driver cleared it before and warn in case it didn't. This
enforces symmetricity with type set and port register.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 38de3a1dff36..4a0ba86b86ed 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9977,6 +9977,7 @@ EXPORT_SYMBOL_GPL(devlink_port_register);
 void devl_port_unregister(struct devlink_port *devlink_port)
 {
 	lockdep_assert_held(&devlink_port->devlink->lock);
+	WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);
 
 	devlink_port_type_warn_cancel(devlink_port);
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_DEL);
-- 
2.37.3

