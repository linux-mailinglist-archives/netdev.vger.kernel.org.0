Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E4C5F2F0A
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 12:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiJCKwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 06:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbiJCKwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 06:52:10 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A24535303B
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 03:52:09 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id e18so13996796edj.3
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 03:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=tV8RQ8wQKtXZ0tWqNwcRmnxwJvvFr184uepBD40zDNU=;
        b=vpq6l7OA8SGC8ENlYHQTIIHLUmNwnIDu7io42RoqBrQLr4u256zn996/9Cxq20bN6j
         K9yQg4wMthbB0Nlc6P0kFvIwTtvVGMygiKhFYzYdYTOtWm95ffVOcSPXfnB2NZd8Wa7g
         Jppk8of2QrouSKXIGg6lb83cgPZ+dmG81LMWGuiNCEtossvUswU+luWLRAGVj8Jeefgn
         tuQt/15Y3GtpqKwMyxG3wq8gxQugosGLqwsO1mAszaCNGOsojpWxXF+/v70TJgxZuKCn
         NLFAwoXl0uijJ7nuWr5TW/BI+vQsLJ8VJZAFPLcUy0M54M+HpL6XbifAGUi5IDTyjyzZ
         8o6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=tV8RQ8wQKtXZ0tWqNwcRmnxwJvvFr184uepBD40zDNU=;
        b=urWpR2EWOI/PKnRsbB2FkmXqWBw+WNhEmSB5OpY3odmjyLStVp+HWfhGV7Uk9vRo/2
         +pBjcgK+NWwK/Cn39Yjg5wg1upAa2FZ5IHWmjgEz/QThB3Pk/prmD6zUOo0rXsvGaIM1
         moiXiD65pdMTT98nXQdRHyrqRn5UJ+nU6nUfT9fiCJffDGtx4XyofEAPpV3m/mCtxorw
         XSwVDijUBKcsAdmjD7Wi7rwElRwEfbZJZLowBXrrBxTYF5ZzeEHbdgJ7mA/mFf1wV3SP
         v1DgMWmdl6XVO2QdNavXxGV8qyrtXxsCPBBGYHTtpdpP1F6buz/ZFJOOCQE3z/jonus9
         vfug==
X-Gm-Message-State: ACrzQf2/qJmQHuunQ4NDHn2lYLNpojsp3y+ilwYuFKc/alCJBu8Kj9ec
        MvX3ROrTLnzRdNepLbJ7+d7MESSHLPRxETKfOTg=
X-Google-Smtp-Source: AMsMyM4ZKxD3wwVIm8mQvXmKU1ygkE9tDN2UNsGRLg0HQPUGkdGCMI0DdJ6oOvAh04BwGp8VmJue9A==
X-Received: by 2002:a05:6402:1555:b0:458:ed89:24e9 with SMTP id p21-20020a056402155500b00458ed8924e9mr5074223edx.55.1664794328275;
        Mon, 03 Oct 2022 03:52:08 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id tl25-20020a170907c31900b0078b1bb98615sm1925358ejc.51.2022.10.03.03.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Oct 2022 03:52:07 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, moshe@nvidia.com,
        saeedm@nvidia.com, linux-rdma@vger.kernel.org
Subject: [patch net-next v2 02/13] net: devlink: move port_type_warn_schedule() call to __devlink_port_type_set()
Date:   Mon,  3 Oct 2022 12:51:53 +0200
Message-Id: <20221003105204.3315337-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221003105204.3315337-1-jiri@resnulli.us>
References: <20221003105204.3315337-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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

