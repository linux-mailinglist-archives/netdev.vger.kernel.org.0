Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7904A56382A
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 18:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbiGAQkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 12:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbiGAQkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 12:40:16 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E6E933EAC
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 09:40:14 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id b26so4036003wrc.2
        for <netdev@vger.kernel.org>; Fri, 01 Jul 2022 09:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jC5TGMHuzDR4UggSsCXw2A6RZ1JvL6ydOH8TZ8J3Mjo=;
        b=tmCTGkztRZ1ugabXURCVaXLwcVeQ2TrZmzFUPhpXivYCKoXTL248Gwtoh11HtshJFG
         wz0XvmmOXLhDPvc2mGCMb0GiB2jVPu5wvL6DKICPHc9Ied9oj/6msBYjpNQdQfz+YM1T
         rAuvXEr59nVLTv786Ej5A8wQl/ZMZaNZxi+IAWwe+PdfCx24GaeNj+J5sBoHu6JrRNxx
         /GmEIcZzPPSusGdutj9AI6RenSSAhxHEHMMRVSlmE2a/S5ZAa4ZRWEvh9P6DavJIgtS3
         GZqrQlOTL7hWg83JEDIKWOhhV+Kj59bJCIXvOXLdx6Op5yEl18wYri0dDqlCx+S3bep7
         PO7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jC5TGMHuzDR4UggSsCXw2A6RZ1JvL6ydOH8TZ8J3Mjo=;
        b=tfTt0mfKTP4pgMDJ/qVShs4ymuXg7P15LpzKIKMWYUdwonUQIG0UU4oxOKc/G0OZj1
         N1hpDrvDHVgQayaOoIdqG37DaWyht60QBM0BmQsbDegHDoZIZ9nWlhF0bKYVtXjWnMDc
         MwCRp5ZxDzQjYVZ5IWWKC8XHJo/lKDgM84LkoHrfb8kp4HrT3Kb7ZA4fOgKn708g4uyN
         wLi/zPZVe4lXdvc3oFtdtmkHFsCbw05Hi9/agF6Vbh2GFuOtLSfbV5QuHPvStdzsXWGe
         vM2enGILmEFR9JCfz56JQVmevXOhE8CJL2yWvijC+Z65A9JKl0kGKsQtKNU89MlxSVKr
         C2fg==
X-Gm-Message-State: AJIora9SHa2ZYwgj1eoV8HfuXHjYejPkAGvldxPYY5OsUmxoD9nV5wnP
        Kju2BIhEOL6eD3I+omOU+9f9lEW6gase2jDI
X-Google-Smtp-Source: AGRyM1sisUJvBes9dsX+Duoe281Mr8h68+MRzCYojptsHoV68MukyMfcR2LZk2rwfnCL6RPwqwcnTQ==
X-Received: by 2002:adf:e68b:0:b0:21d:1c8d:9891 with SMTP id r11-20020adfe68b000000b0021d1c8d9891mr15083489wrm.37.1656693612611;
        Fri, 01 Jul 2022 09:40:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id g4-20020a5d5544000000b0021a39f5ba3bsm22642406wrw.7.2022.07.01.09.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 09:40:12 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: [patch net-next v2 2/3] net: devlink: call lockdep_assert_held() for devlink->lock directly
Date:   Fri,  1 Jul 2022 18:40:06 +0200
Message-Id: <20220701164007.1243684-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220701164007.1243684-1-jiri@resnulli.us>
References: <20220701164007.1243684-1-jiri@resnulli.us>
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

