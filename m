Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AD95F1A14
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 08:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiJAGBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 02:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJAGBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 02:01:53 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17AD6237C4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:52 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a26so12934380ejc.4
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 23:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=tV8RQ8wQKtXZ0tWqNwcRmnxwJvvFr184uepBD40zDNU=;
        b=GjIGBfb5fJFK+tHfoWkonTJAzHwqyEYg0aNYtpubBiMyovOqtZ091ygGtmPXF0gLVO
         ALEvlgfYKPw7PWyqXC+g2soR7tV445vp/psau2OgIwotEz/hPL1FCGeKjdHrWboSpcmW
         xiC+cbW3lgNvB9negcSk/0Y8EmBm5ru+HJAraQXgM91Bnb3ad82HildUm7YA+I2i8v5Y
         EJU7ln6k/wpjTgrQTizeMmk1rOQoYtLBL/eOPpefkdEcPOqz6RkEfhKB+VsBbeJhbBmn
         LLeDjRGGj41LpjP1T6XTjyAcnJkHJRD4EtiPOB2GmwBaZzNIvZ9ZfJs7mS4vR6f8wjXk
         fxgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=tV8RQ8wQKtXZ0tWqNwcRmnxwJvvFr184uepBD40zDNU=;
        b=OsX0NWL9ehmwflg9MQK0xhhCKXgvO61He22dKLZ7TBkB4v4JOmxY3gYAqu74yOu078
         sjPPUqC38sseOEP0X+t6iQDsYHqieud09dhM6m7AuZrE3ujzDaPuVBiQVtnahWwrBuc3
         6I0nBA49CS5G1D7olCXEMOQcOkXD3ogBdf0XFXzm0i7oxDGeCepeKSXaS2qfN42mv2fs
         utPQyX6dA/b7+SircQw7F1XUkjizC75XIuuJTT+9BpNM+R6PiFVFodZ+KNUprXtjVSXV
         brkaCMZz2Ld+0JqAqZAya1S1D29iOce+zNwHsHCGVH+ac+CTE0yzx2+NUAyP3uiMgrkl
         O8ng==
X-Gm-Message-State: ACrzQf2Qapf6ORpEzJ/rVshHEtWGOJmUgd2kNMC7oNqHVfGThbsX/QYZ
        BveANPfnDdJfqNLgtBXJsMnl/sfqsqcTm2PV
X-Google-Smtp-Source: AMsMyM5iYjUkBVRWkmWj4ludCJLHpdsTBxYkT1oxQTPakebEhm5BRAWbAvtCYL8Lve+YedzWKe75Aw==
X-Received: by 2002:a17:906:30c8:b0:73c:81a9:f8e1 with SMTP id b8-20020a17090630c800b0073c81a9f8e1mr8774149ejb.649.1664604110654;
        Fri, 30 Sep 2022 23:01:50 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id iy7-20020a170907818700b00730b61d8a5esm2203195ejc.61.2022.09.30.23.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 23:01:50 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: [patch net-next 02/13] net: devlink: move port_type_warn_schedule() call to __devlink_port_type_set()
Date:   Sat,  1 Oct 2022 08:01:34 +0200
Message-Id: <20221001060145.3199964-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221001060145.3199964-1-jiri@resnulli.us>
References: <20221001060145.3199964-1-jiri@resnulli.us>
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

As __devlink_port_type_set() is going to be called directly from netdevice
notifier event handle in one of the follow-up patches, move the
port_type_warn_schedule() call there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 7e7645ae3d89..218cb1cdb50e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -10000,7 +10000,11 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
 
-	devlink_port_type_warn_cancel(devlink_port);
+	if (type == DEVLINK_PORT_TYPE_NOTSET)
+		devlink_port_type_warn_schedule(devlink_port);
+	else
+		devlink_port_type_warn_cancel(devlink_port);
+
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
 	switch (type) {
@@ -10095,7 +10099,6 @@ EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
 void devlink_port_type_clear(struct devlink_port *devlink_port)
 {
 	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL);
-	devlink_port_type_warn_schedule(devlink_port);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-- 
2.37.1

