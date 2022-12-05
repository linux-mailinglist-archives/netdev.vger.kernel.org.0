Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7AD2642853
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231744AbiLEMWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:22:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbiLEMWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:22:19 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CD8F5B8
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 04:22:06 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id qk9so9584734ejc.3
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 04:22:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ftY6vTAr322cYQjd592MVAMRE7dHL3ysFcwRytb0ZJo=;
        b=t93b4P6hfTAfug+oqHHtUBKf/eNilt4gPSMeR8y9VqbUXxoU5VxXYBISuxdQ98dqPF
         cz/wV5KZToA4YONnPfvsOvnPGfETjj0+MyLabq2MKdxsP5V/9kx0shcCxnhyYTb8f/Qq
         wtZyjTNpJIHChm9YH/wTIUCO/3XL9nC+8ego2W3G7UAl3OBuxOmrmow3CCF9+1GmFl+H
         +14JHdjksqYz6ooCQp3tJYIA3jtIGYgclxGaum16P2oBYSOCSv3uelgy60jfQ1lJ6Hz2
         ozMYbGZ/CmUouP4jiHjlgx/xk8ctrRigs4nDdrmpkDzfGOsxiX1V0fyw6ku7Y1tBNZQK
         DJPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ftY6vTAr322cYQjd592MVAMRE7dHL3ysFcwRytb0ZJo=;
        b=Z+Ba0OEHPzxa4TiwGXaHq4tOIHF6Y7nMf1bVH2amJZRC4SC9R62CmPhe3Hmng3djD9
         +XpzrfuzQvBFH/appBbvh29ov7bc58bbElGybyWeoJq/FPLjHcxNrXFXsIcgF3Ana3Jf
         if6d2guZYUiJK1wbkqw+8WNI2fta8j7ajy6O5hOmKsXFkCCV3zH47PjxRHtv05W2x+IP
         ezCp8hngd+hXGgbfZleomfs0j+CTXCIRVDLJDV4UL3qyjjoJgGPaZt58kTsKt2M8m+A5
         z05Nwd0dlK3tRQj+QrGIAiHrXTYb3WU6uLQW/q2WcTFRyIfcKDmt1CfNm/B5Nr5J8eWe
         0/4w==
X-Gm-Message-State: ANoB5pm18/KDFhbGpKrsCJFx8dXRK8M+2gg3tMcqjKG4+4JszAhQ7+K0
        qFSBnfqKxSnfhMmL245OsoWOkzU2gUoO3MQafwI=
X-Google-Smtp-Source: AA0mqf7H9o/E8YipptL0CwLo8nnvlKbYkPfDkrecjF4NpwQqvYa6LqGz3TRKOToaqwwL2dxbmJcGVQ==
X-Received: by 2002:a17:906:5ad7:b0:7c0:b55f:295 with SMTP id x23-20020a1709065ad700b007c0b55f0295mr14628401ejs.424.1670242925295;
        Mon, 05 Dec 2022 04:22:05 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id 4-20020a170906308400b007bd9e683639sm6159721ejv.130.2022.12.05.04.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:22:04 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch iproute2/net-next 3/4] devlink: push common code to __pr_out_port_handle_start_tb()
Date:   Mon,  5 Dec 2022 13:21:57 +0100
Message-Id: <20221205122158.437522-4-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205122158.437522-1-jiri@resnulli.us>
References: <20221205122158.437522-1-jiri@resnulli.us>
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

There is a common code in pr_out_port_handle_start() and
pr_out_port_handle_start_arr(). As the next patch is going to extend it
even more, push the code into common helper.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 devlink/devlink.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/devlink/devlink.c b/devlink/devlink.c
index 80c18d690c10..2d9ba32b4140 100644
--- a/devlink/devlink.c
+++ b/devlink/devlink.c
@@ -2764,7 +2764,8 @@ static void __pr_out_port_handle_start(struct dl *dl, const char *bus_name,
 	}
 }
 
-static void pr_out_port_handle_start(struct dl *dl, struct nlattr **tb, bool try_nice)
+static void __pr_out_port_handle_start_tb(struct dl *dl, struct nlattr **tb,
+					  bool try_nice, bool array)
 {
 	const char *bus_name;
 	const char *dev_name;
@@ -2773,19 +2774,17 @@ static void pr_out_port_handle_start(struct dl *dl, struct nlattr **tb, bool try
 	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
 	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
 	port_index = mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_INDEX]);
-	__pr_out_port_handle_start(dl, bus_name, dev_name, port_index, try_nice, false);
+	__pr_out_port_handle_start(dl, bus_name, dev_name, port_index, try_nice, array);
 }
 
-static void pr_out_port_handle_start_arr(struct dl *dl, struct nlattr **tb, bool try_nice)
+static void pr_out_port_handle_start(struct dl *dl, struct nlattr **tb, bool try_nice)
 {
-	const char *bus_name;
-	const char *dev_name;
-	uint32_t port_index;
+	__pr_out_port_handle_start_tb(dl, tb, try_nice, false);
+}
 
-	bus_name = mnl_attr_get_str(tb[DEVLINK_ATTR_BUS_NAME]);
-	dev_name = mnl_attr_get_str(tb[DEVLINK_ATTR_DEV_NAME]);
-	port_index = mnl_attr_get_u32(tb[DEVLINK_ATTR_PORT_INDEX]);
-	__pr_out_port_handle_start(dl, bus_name, dev_name, port_index, try_nice, true);
+static void pr_out_port_handle_start_arr(struct dl *dl, struct nlattr **tb, bool try_nice)
+{
+	__pr_out_port_handle_start_tb(dl, tb, try_nice, true);
 }
 
 static void pr_out_port_handle_end(struct dl *dl)
-- 
2.37.3

