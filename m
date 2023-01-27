Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9E4D67E9FB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 16:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjA0Puw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 10:50:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbjA0Put (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 10:50:49 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C7D1713
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:50:48 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id k4so9372462eje.1
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 07:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qcnd6KUn6UvpeAXoLnPapnXYZeifl1aUYi7RJCSi148=;
        b=INbduqnlS83Ny6FUqWj4Jyi/3D9q9Qk2h2jAMZPy4d2ORIxIGEu/uWrSvIBzt+Pe9R
         nmXXZz+JdHNFC4IwYmDmy3P1H3h0kXshsE70Wq+nYEUkL1af3ew4OD3/6Two4CXx0JbA
         D8o8c16NMjXC6c6FFxdT+d9OO4M/lRsihsIGcWkXi16PSFg32+5xqTjT5l8bCsp68qRD
         gVqtrrrGVuA9utReC8JhMYjZgBf3Z7OkToJMGhBZoqYl14nUoc50pj12DIuy5hUyyIPk
         7s7lMPTbeKjfk9ODvT8lo0UPiOIQoWjP2VyV3NsjBwpiSdPc9XICJnc7B5BqmBPKCOjs
         NXDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qcnd6KUn6UvpeAXoLnPapnXYZeifl1aUYi7RJCSi148=;
        b=xZowLckAogLs69YCsNnPdo922GYpBnhMzHRV2YmTN63ibC5DacILafwB6V+CmrFsI6
         wjXZ8tKALtR32hNPUTCy/XW2F+Z/B3DZJMeLHN5xQT5dlZzcq+bc4QVsXu//2KLyCg1q
         qQmphCHGCDzktcZPyP74yTe83cDAvZAADRJiqP85qmcnj2SuDqG9zEsEJBIXmxX7BrSf
         5cPUOquE7U7md5bFhqcucIlIQIlbsWbCwmAOeQRRwdeFzmViwoL8PJPsDjakxgTuJUjk
         bBu/zY1ulcMtiut+SN8otRCYWGrnVq8u+ZIANzRr27C+jtpb8tTb4vwbqiRqpK2LcuCg
         NU2A==
X-Gm-Message-State: AFqh2koUHpqDXHzIrpaGYfP28+JxIbu7LOekcWiHj1XOKnit30boImdX
        6pgf6IaOpV1bb5yEjgnZluVfZhG7iYDH3nR9paA=
X-Google-Smtp-Source: AMrXdXv95KPoal49FZd8P/13bFcurKSLtIcp3QlVaM3+2qGwOX9tMvsfnQYxWRZJn8v3D91v4OFx6g==
X-Received: by 2002:a17:907:971d:b0:870:d15a:c2dc with SMTP id jg29-20020a170907971d00b00870d15ac2dcmr55616598ejc.74.1674834647015;
        Fri, 27 Jan 2023 07:50:47 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id f17-20020a1709064dd100b0087853fbb55dsm2425042ejw.40.2023.01.27.07.50.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jan 2023 07:50:46 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, jacob.e.keller@intel.com,
        gal@nvidia.com, mailhol.vincent@wanadoo.fr
Subject: [patch net-next 1/3] devlink: move devlink reload notifications back in between _down() and _up() calls
Date:   Fri, 27 Jan 2023 16:50:40 +0100
Message-Id: <20230127155042.1846608-2-jiri@resnulli.us>
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

This effectively reverts commit 05a7f4a8dff1 ("devlink: Break parameter
notification sequence to be before/after unload/load driver").

Cited commit resolved a problem in mlx5 params implementation,
when param notification code accessed memory previously freed
during reload.

Now, when the params can be registered and unregistered when devlink
instance is registered, mlx5 code unregisters the problematic param
during devlink reload. The fix is therefore no longer needed.

Current behavior is a it problematic, as it sends DEL notifications even
in potential case when reload_down() call fails which might confuse
userspace notifications listener.

So move the reload notifications back where they were originally in
between reload_down() and reload_up() calls.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/devlink/leftover.c | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index bd4c5d2dd612..24e20861a28b 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -4235,12 +4235,11 @@ static void devlink_param_notify(struct devlink *devlink,
 				 struct devlink_param_item *param_item,
 				 enum devlink_command cmd);
 
-static void devlink_ns_change_notify(struct devlink *devlink,
-				     struct net *dest_net, struct net *curr_net,
-				     bool new)
+static void devlink_reload_netns_change(struct devlink *devlink,
+					struct net *curr_net,
+					struct net *dest_net)
 {
 	struct devlink_param_item *param_item;
-	enum devlink_command cmd;
 
 	/* Userspace needs to be notified about devlink objects
 	 * removed from original and entering new network namespace.
@@ -4248,18 +4247,19 @@ static void devlink_ns_change_notify(struct devlink *devlink,
 	 * reload process so the notifications are generated separatelly.
 	 */
 
-	if (!dest_net || net_eq(dest_net, curr_net))
-		return;
+	list_for_each_entry(param_item, &devlink->param_list, list)
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_DEL);
+	devlink_notify(devlink, DEVLINK_CMD_DEL);
 
-	if (new)
-		devlink_notify(devlink, DEVLINK_CMD_NEW);
+	move_netdevice_notifier_net(curr_net, dest_net,
+				    &devlink->netdevice_nb);
+	write_pnet(&devlink->_net, dest_net);
 
-	cmd = new ? DEVLINK_CMD_PARAM_NEW : DEVLINK_CMD_PARAM_DEL;
+	devlink_notify(devlink, DEVLINK_CMD_NEW);
 	list_for_each_entry(param_item, &devlink->param_list, list)
-		devlink_param_notify(devlink, 0, param_item, cmd);
-
-	if (!new)
-		devlink_notify(devlink, DEVLINK_CMD_DEL);
+		devlink_param_notify(devlink, 0, param_item,
+				     DEVLINK_CMD_PARAM_NEW);
 }
 
 static void devlink_reload_failed_set(struct devlink *devlink,
@@ -4341,24 +4341,19 @@ int devlink_reload(struct devlink *devlink, struct net *dest_net,
 	memcpy(remote_reload_stats, devlink->stats.remote_reload_stats,
 	       sizeof(remote_reload_stats));
 
-	curr_net = devlink_net(devlink);
-	devlink_ns_change_notify(devlink, dest_net, curr_net, false);
 	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit, extack);
 	if (err)
 		return err;
 
-	if (dest_net && !net_eq(dest_net, curr_net)) {
-		move_netdevice_notifier_net(curr_net, dest_net,
-					    &devlink->netdevice_nb);
-		write_pnet(&devlink->_net, dest_net);
-	}
+	curr_net = devlink_net(devlink);
+	if (dest_net && !net_eq(dest_net, curr_net))
+		devlink_reload_netns_change(devlink, curr_net, dest_net);
 
 	err = devlink->ops->reload_up(devlink, action, limit, actions_performed, extack);
 	devlink_reload_failed_set(devlink, !!err);
 	if (err)
 		return err;
 
-	devlink_ns_change_notify(devlink, dest_net, curr_net, true);
 	WARN_ON(!(*actions_performed & BIT(action)));
 	/* Catch driver on updating the remote action within devlink reload */
 	WARN_ON(memcmp(remote_reload_stats, devlink->stats.remote_reload_stats,
-- 
2.39.0

