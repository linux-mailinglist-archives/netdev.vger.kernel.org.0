Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B1067E9FE
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232692AbjA0PvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233260AbjA0PvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:51:03 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924042FCE6
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:51:00 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id a37so6010313ljq.0
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N4XM3hKLU3w6Jzh8RUxTOn6k2qZMx/HbUBKh7a2oQPs=;
        b=LPiCU9gUmVSM47dpItfccjlwo9Wt9SLq2C58I89m0epBYfaNFLR3uDiZU0+Wt5/iPk
         VlGspgTO5XO2iZUmlUWIpVE2rRT5fF7Id5jf9HjBz0gmHXhqQ8Sk4Z0HtP9rEwwTIBw2
         jO1mI3bN9Hr9s0ipqU/56Z8yIiZpimP0BuLir3AKU8tQ00rA06G5I0WOmNkxpbWgno/8
         K/fY3fJhBmjgql8Lr6Tppnm4hLeOybbqf6GY694uJWV4Q0E7f8iZp6Ehd3Y9slV6LeAk
         kMPQPNl+09k/OW3aSeB1ZAoM0G5TQFS5vU0jyv1qZ2x0zhTJWTwYZYNqgFK7S5DLnnTT
         MUOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4XM3hKLU3w6Jzh8RUxTOn6k2qZMx/HbUBKh7a2oQPs=;
        b=0UH9rd2jNvhybiq0SJZvfi14+WlqzZCy1eR/fmko0mjcauiX7pIepSu/pnxC9L/sYi
         y1CHOrcyTEnbatgADco7Y0YX6V+wpZnqtgRqGmvfuW04xYxjX9KiK1pFYuFH6ubHQDU6
         AlH1RGze891yV+WAwlk3TRqjJGLwERAWYKIoMelpiKgc0isQnGuipwyOYWrOJ427/wvF
         Mh59A89f/9HSvCQn5j/my4hDeKPJG7ytaY5RbrfDlksvUXxsqX8lBvLHjAu+CYHJxokq
         6XYH6wlAD7JhIZy95PktcKus0Grq3eQQfscrtRprgAhr0D3ggiUT1xzbMse7se2D/cpz
         UOGw==
X-Gm-Message-State: AO0yUKVJeLgz2Z91JFr16ZfI0bnxQ66tN9Mog9Lfv05ZaaN4dGBxj6ql
        fqTU+kgqeSwAMgUHNPHTjBz/XXwGmWA4dSngD1M=
X-Google-Smtp-Source: AMrXdXsQqGGHQwfNUJ3NRVKrMVAaZqpuYP4CGVHuG6sYVpvuo5lFT/gx/pZ1eyOLMIeB4a2QtUnRHg==
X-Received: by 2002:a17:906:4094:b0:854:956:1438 with SMTP id u20-20020a170906409400b0085409561438mr106063017ejj.25.1674834648759;
        Fri, 27 Jan 2023 07:50:48 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id ci22-20020a170906c35600b0087bcda2b07bsm1222977ejb.202.2023.01.27.07.50.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 07:50:48 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, jacob.e.keller@intel.com,
        gal@nvidia.com, mailhol.vincent@wanadoo.fr
Subject: [patch net-next 2/3] devlink: send objects notifications during devlink reload
Date:   Fri, 27 Jan 2023 16:50:41 +0100
Message-Id: <20230127155042.1846608-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230127155042.1846608-1-jiri@resnulli.us>
References: <20230127155042.1846608-1-jiri@resnulli.us>
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

Currently, the notifications are only sent for params. People who
introduced other objects forgot to add the reload notifications here.

To make sure all notifications happen according to existing comment,
benefit from existence of devlink_notify_register/unregister() helpers
and use them in reload code.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 20 ++------------------
 1 file changed, 2 insertions(+), 18 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index 24e20861a28b..4f78ef5a46af 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -4230,36 +4230,20 @@ static struct net *devlink_netns_get(struct sk_buff *skb,
 	return net;
 }
 
-static void devlink_param_notify(struct devlink *devlink,
-				 unsigned int port_index,
-				 struct devlink_param_item *param_item,
-				 enum devlink_command cmd);
-
 static void devlink_reload_netns_change(struct devlink *devlink,
 					struct net *curr_net,
 					struct net *dest_net)
 {
-	struct devlink_param_item *param_item;
-
 	/* Userspace needs to be notified about devlink objects
 	 * removed from original and entering new network namespace.
 	 * The rest of the devlink objects are re-created during
 	 * reload process so the notifications are generated separatelly.
 	 */
-
-	list_for_each_entry(param_item, &devlink->param_list, list)
-		devlink_param_notify(devlink, 0, param_item,
-				     DEVLINK_CMD_PARAM_DEL);
-	devlink_notify(devlink, DEVLINK_CMD_DEL);
-
+	devlink_notify_unregister(devlink);
 	move_netdevice_notifier_net(curr_net, dest_net,
 				    &devlink->netdevice_nb);
 	write_pnet(&devlink->_net, dest_net);
-
-	devlink_notify(devlink, DEVLINK_CMD_NEW);
-	list_for_each_entry(param_item, &devlink->param_list, list)
-		devlink_param_notify(devlink, 0, param_item,
-				     DEVLINK_CMD_PARAM_NEW);
+	devlink_notify_register(devlink);
 }
 
 static void devlink_reload_failed_set(struct devlink *devlink,
-- 
2.39.0

