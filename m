Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F160691C22
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjBJKBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:01:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjBJKBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:01:37 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F08812A9BF
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:35 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id fj20so4320230edb.1
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugEBnDmWs5ehTIeO1DDJDyYOLmcj06gUkAdvMGOnbkc=;
        b=DDXGaBpORo3WguMtMB5oiaCHLoggv5ZoaZmqXFahHj/Ezt1L+YPkZg1dGCjz50gtik
         VkJk8Bb/KRhUGUCbP0Fegm6wbHJquaBTaaXCIt4DRxd84VnpOHgJXPs2WTNWmn1i/4x5
         XOQ3WZNtXsb92EPbGZLc00Oil106SkCL/Lk+hLyuFuz1n9qnYp7jSmpiXUCvyiIV7nGI
         /M3Xo+Cax+qDivAgjNltjZE9D+/6PdPjxX43NP0EfF05UGqBQcKCtJWE6nZ2gBOzcRhW
         izg7fhOnIy4GMfs7cTFr3/B1XxKZ8aJznxxaQsuKYwXDNB18gDYj/9JIB1AjtUjwfmDg
         l/7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ugEBnDmWs5ehTIeO1DDJDyYOLmcj06gUkAdvMGOnbkc=;
        b=xIc1x8ZwUuktoKb2i8fJYwijTeD4BYPlVHBt1VR7gzXB+f8TraXN9zr9PduVWJMiG3
         RKUgjI5dS3mRqvkPRrN7iBZ0fpfDwl3B66r2BsUmfdsYVWJpf25AQ9jGwCPlREUy29Ix
         yziqDhueHJJGkjVswUnqZ6THJ+Z8DoUbcAcFYV+5bY8uhPzY9xKN4dxcUh4UZyVESMUC
         9Vz3UCs81ZudDWMgcJyqfBE58skbpqZdHOZM+CkdyZykF+IAvFjz/6Xuhq/jX0KIIk2D
         4AtheTvYvYMMMhMsN9lEd4nwifOiyr1GOlxOLyhDLrmHgJrzjVz/h5/p++aSusO5htNe
         mVUg==
X-Gm-Message-State: AO0yUKVkKrTweBs42jDz21yfTpXZG6qRoNBsCpDT7E7bcX0LDuph3zjN
        p3ZePtujLUiOz+0xwx3cqp/ogz6dkJVX7RiAAyQ=
X-Google-Smtp-Source: AK7set/gEgCM52e9lLt8heXeAy3oEdKybf0u4xq5CyRDV07nhgXhysJF4XBqyb4y7GNioZFCwc4CXg==
X-Received: by 2002:a50:d781:0:b0:4ac:89b:b605 with SMTP id w1-20020a50d781000000b004ac089bb605mr185153edi.22.1676023294623;
        Fri, 10 Feb 2023 02:01:34 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id r23-20020a50aad7000000b0049f29a7c0d6sm1982141edc.34.2023.02.10.02.01.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 02:01:34 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tariqt@nvidia.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, gal@nvidia.com, kim.phillips@amd.com,
        moshe@nvidia.com, simon.horman@corigine.com, idosch@nvidia.com
Subject: [patch net-next v2 1/7] devlink: don't use strcpy() to copy param value
Date:   Fri, 10 Feb 2023 11:01:25 +0100
Message-Id: <20230210100131.3088240-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230210100131.3088240-1-jiri@resnulli.us>
References: <20230210100131.3088240-1-jiri@resnulli.us>
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

No need to treat string params any different comparing to other types.
Rely on the struct assign to copy the whole struct, including the
string.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/devlink/leftover.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index f05ab093d231..f2f6a2f42864 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -4388,10 +4388,7 @@ static int __devlink_nl_cmd_param_set_doit(struct devlink *devlink,
 		return -EOPNOTSUPP;
 
 	if (cmode == DEVLINK_PARAM_CMODE_DRIVERINIT) {
-		if (param->type == DEVLINK_PARAM_TYPE_STRING)
-			strcpy(param_item->driverinit_value.vstr, value.vstr);
-		else
-			param_item->driverinit_value = value;
+		param_item->driverinit_value = value;
 		param_item->driverinit_value_valid = true;
 	} else {
 		if (!param->set)
@@ -9656,10 +9653,7 @@ int devl_param_driverinit_value_get(struct devlink *devlink, u32 param_id,
 						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
 		return -EOPNOTSUPP;
 
-	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
-		strcpy(init_val->vstr, param_item->driverinit_value.vstr);
-	else
-		*init_val = param_item->driverinit_value;
+	*init_val = param_item->driverinit_value;
 
 	return 0;
 }
@@ -9690,10 +9684,7 @@ void devl_param_driverinit_value_set(struct devlink *devlink, u32 param_id,
 						      DEVLINK_PARAM_CMODE_DRIVERINIT)))
 		return;
 
-	if (param_item->param->type == DEVLINK_PARAM_TYPE_STRING)
-		strcpy(param_item->driverinit_value.vstr, init_val.vstr);
-	else
-		param_item->driverinit_value = init_val;
+	param_item->driverinit_value = init_val;
 	param_item->driverinit_value_valid = true;
 
 	devlink_param_notify(devlink, 0, param_item, DEVLINK_CMD_PARAM_NEW);
-- 
2.39.0

