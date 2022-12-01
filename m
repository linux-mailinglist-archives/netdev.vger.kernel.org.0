Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8250663F593
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiLAQqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbiLAQqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:46:19 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E57B956F
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:46:15 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id fy37so5529640ejc.11
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KkPC04q2E5HTXjNLsMckFEW+LV/JOlSKL22EoOe/qm4=;
        b=TsKpBhrgA3blPp5YB5lM9OSq6pcco1h3cGTXZ9AHUpjdzD5nkfYsDlDncpUP/eU4zs
         teJm1El9p+NkMc1T+WWQwb0ztuH9p0QfVMIh+Ot/4aJT9zCfeT23f+KJXct73ibT8qSn
         LmYmPouRRSFNNNow/PHgDMEPRffQXI6IxHWM/Rl2FWxs2CmbsR00asj8ldUHi8ZTw0Nr
         D6BT1lVpFm/UflJUXKKlf2k56FVuv1PhAvD/59WaPV254ifZ1OTRUA6WsO8gi3dvxp9V
         aSW85XsIf+2pJdUsCNIw+Ed9r64X/+V7oLqY7VYO3rsTBLkouygrHrrgAjJpDWWaZRpT
         zEdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KkPC04q2E5HTXjNLsMckFEW+LV/JOlSKL22EoOe/qm4=;
        b=ossM6W+m3SGwTCagK2CKQwod/DqQg4v6a6h9HywXvLycmKkDBc3coA16wdTYZ8716F
         LtexNRoUwLh0f23ub+9Tamps3YOFRq6PBxfcly1KxuLtNRPIT49Be4oqdDvxeEaddPGp
         2aHoocl7PD4F/vKnsI9R43I7gd/CNUT6dxBNBEDrmH2L9qIQRMuPvPbvlhzjHEEpUuTq
         YTrGFSvuQlCniSqnUquOq1oXjszDfV3tttaCUu+rUgR4uD1XzTCxsywf8XnTvnKicoZB
         27S29vCQjwFaYlzd2gSQBE6FykGwyYg4JoqZAX/A02oIv6ErJBe8T7uikushnSGkto8o
         w22Q==
X-Gm-Message-State: ANoB5pn2Pbtf2Nbpyq0VacPJiebGq+y1QejUKatHPlZFXcDJQ+4izJ/8
        r1R+iH0gLdQwnyjYgKyXsk5PKhxgT5fvloV6
X-Google-Smtp-Source: AA0mqf5rFKqvItNMHX6nNt9fMYQCJ1iGUAzChBg/hm7WRMQjOGfQKpC4g0i6CQhpxQWdf3okutnnzA==
X-Received: by 2002:a17:906:805:b0:78d:8267:3379 with SMTP id e5-20020a170906080500b0078d82673379mr55712732ejd.415.1669913173864;
        Thu, 01 Dec 2022 08:46:13 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id v25-20020a056402185900b00467c3cbab6fsm1911235edy.77.2022.12.01.08.46.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 08:46:12 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yangyingliang@huawei.com, leon@kernel.org
Subject: [patch net-next RFC 2/7] netdevsim: Reorder devl_port_register/unregister() calls to be done when devlink is registered
Date:   Thu,  1 Dec 2022 17:46:03 +0100
Message-Id: <20221201164608.209537-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221201164608.209537-1-jiri@resnulli.us>
References: <20221201164608.209537-1-jiri@resnulli.us>
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

Move the code so devl_port_register/unregister() are called only
then devlink is registered.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/netdevsim/dev.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index b962fc8e1397..8ed235ac986f 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -949,6 +949,7 @@ static void nsim_dev_traps_exit(struct devlink *devlink)
 
 static int nsim_dev_reload_create(struct nsim_dev *nsim_dev,
 				  struct netlink_ext_ack *extack);
+static void nsim_dev_reload_ports_destroy(struct nsim_dev *nsim_dev);
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev);
 
 static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
@@ -965,6 +966,7 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 		return -EOPNOTSUPP;
 	}
 
+	nsim_dev_reload_ports_destroy(nsim_dev);
 	nsim_dev_reload_destroy(nsim_dev);
 	return 0;
 }
@@ -1600,17 +1602,22 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	if (err)
 		goto err_psample_exit;
 
-	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
-	if (err)
-		goto err_hwstats_exit;
-
 	nsim_dev->esw_mode = DEVLINK_ESWITCH_MODE_LEGACY;
 	devlink_set_features(devlink, DEVLINK_F_RELOAD);
 	devl_unlock(devlink);
 	devlink_register(devlink);
+
+	devl_lock(devlink);
+	err = nsim_dev_port_add_all(nsim_dev, nsim_bus_dev->port_count);
+	devl_unlock(devlink);
+	if (err)
+		goto err_devlink_unregister;
+
 	return 0;
 
-err_hwstats_exit:
+err_devlink_unregister:
+	devlink_unregister(devlink);
+	devl_lock(devlink);
 	nsim_dev_hwstats_exit(nsim_dev);
 err_psample_exit:
 	nsim_dev_psample_exit(nsim_dev);
@@ -1640,6 +1647,15 @@ int nsim_drv_probe(struct nsim_bus_dev *nsim_bus_dev)
 	return err;
 }
 
+static void nsim_dev_reload_ports_destroy(struct nsim_dev *nsim_dev)
+{
+	struct devlink *devlink = priv_to_devlink(nsim_dev);
+
+	if (devlink_is_reload_failed(devlink))
+		return;
+	nsim_dev_port_del_all(nsim_dev);
+}
+
 static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 {
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
@@ -1654,7 +1670,6 @@ static void nsim_dev_reload_destroy(struct nsim_dev *nsim_dev)
 			nsim_esw_legacy_enable(nsim_dev, NULL);
 	}
 
-	nsim_dev_port_del_all(nsim_dev);
 	nsim_dev_hwstats_exit(nsim_dev);
 	nsim_dev_psample_exit(nsim_dev);
 	nsim_dev_health_exit(nsim_dev);
@@ -1668,6 +1683,10 @@ void nsim_drv_remove(struct nsim_bus_dev *nsim_bus_dev)
 	struct nsim_dev *nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	struct devlink *devlink = priv_to_devlink(nsim_dev);
 
+	devl_lock(devlink);
+	nsim_dev_reload_ports_destroy(nsim_dev);
+	devl_unlock(devlink);
+
 	devlink_unregister(devlink);
 	devl_lock(devlink);
 	nsim_dev_reload_destroy(nsim_dev);
-- 
2.37.3

