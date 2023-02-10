Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C32B691EB9
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:58:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjBJL6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231400AbjBJL6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:58:31 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676B734020
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:58:30 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id lu11so15235319ejb.3
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kxeY3fQPZ8D33I6SG738zAS00V3d7G8VC1jm+AOQNi4=;
        b=6jK2IKUDx1s6P/3b1F8e2RkYvo1v6j/2C9NCte6GJj06FNALwtOe4+lSAOCGBMnpx5
         sPj1Kb6DAEzHHrfzM3Ne0ne8snezhSNkxp7GKmSlXfcQwfV9hAqI8bopod7O1f2KJKqK
         QcjmzooybfXdFvRaXxKtfikUEuCo6kKNhChtn+rxjeRrA1ChStkrqKgygxOZ4LyHQlG5
         mbS6yc/+IdDQXhfyB7bnQ6q3raH9Dwf1wNsiV20apnwlxLo1Wj7ZIe4Rgokc5SbGehsp
         usLm0i2pX9xA3BGJOgqMk5F5Gpet78S8MDyoSGpzWdvg0SoqbneDfi5aGqHXM8bwbnkk
         nRLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kxeY3fQPZ8D33I6SG738zAS00V3d7G8VC1jm+AOQNi4=;
        b=5qr/tX8EWDidXv510m3JwfT3ihMMUWhQiuCrWCeEr2kLvOoD3dd+gmO+vZgRZFk8hm
         xJtmV6GeJLjoEO5lCEPwnV3ZEaTDoVKQyosE/Wo3auNDQT2+3di9lRTyNqK6kv+5lJiV
         m/x+cs2+hgvt3YgORY7RK/UKYU51NqIBY7eIQXU9Zta2Lshb0pvf6l/9dp2dsUh6692d
         95KmbcHBNrzKt+5++UcJvr8aKPqg3DU3OxWPWv4em4Jd+fIS8l19k/iENXR7fArXtlml
         B3EN6bW+5QBtL26Du9tFdT4gm7jHjWUn70Wkv66n9indAQpjG8++BMOkEKSLsFTxeZZl
         xpsw==
X-Gm-Message-State: AO0yUKXuH/UucwSynvRtd8uZt1ydNEOA0jOl48aKKX9B/dTRpAVSmRIN
        HSIi/0Ejv5MrWusKhf8X0DaOCd4AaofgedBUUJE=
X-Google-Smtp-Source: AK7set87ulvE8EMoBOFsZju+FIfsP7woLOtdIymbbtZRkhP81YLHaAt7jMYZNQ79pQx1XMO4fExq8w==
X-Received: by 2002:a17:906:d1ca:b0:88b:f26d:7b25 with SMTP id bs10-20020a170906d1ca00b0088bf26d7b25mr10505188ejb.28.1676030308980;
        Fri, 10 Feb 2023 03:58:28 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id e20-20020a170906c01400b008ae3324c8adsm2278326ejz.214.2023.02.10.03.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 03:58:28 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com, moshe@nvidia.com,
        simon.horman@corigine.com
Subject: [patch net-next] devlink: don't allow to change net namespace for FW_ACTIVATE reload action
Date:   Fri, 10 Feb 2023 12:58:27 +0100
Message-Id: <20230210115827.3099567-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
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

The change on network namespace only makes sense during re-init reload
action. For FW activation it is not applicable. So check if user passed
an ATTR indicating network namespace change request and forbid it.

Fixes: ccdf07219da6 ("devlink: Add reload action option to devlink reload command")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
Sending to net-next as this is not actually fixing any real bug,
it just adds a forgotten check.
---
 net/devlink/dev.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/devlink/dev.c b/net/devlink/dev.c
index 78d824eda5ec..a6a2bcded723 100644
--- a/net/devlink/dev.c
+++ b/net/devlink/dev.c
@@ -474,6 +474,11 @@ int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[DEVLINK_ATTR_NETNS_PID] ||
 	    info->attrs[DEVLINK_ATTR_NETNS_FD] ||
 	    info->attrs[DEVLINK_ATTR_NETNS_ID]) {
+		if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT) {
+			NL_SET_ERR_MSG_MOD(info->extack,
+					   "Changing namespace is only supported for reinit action");
+			return -EOPNOTSUPP;
+		}
 		dest_net = devlink_netns_get(skb, info);
 		if (IS_ERR(dest_net))
 			return PTR_ERR(dest_net);
-- 
2.39.0

