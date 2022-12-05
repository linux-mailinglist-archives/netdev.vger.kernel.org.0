Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7F1642B9B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 16:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbiLEP0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 10:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232397AbiLEPZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 10:25:53 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFF61F606
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 07:23:04 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id c17so7695741edj.13
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 07:23:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nytOOCtj+t+VV6OI8ONHh+GMp4FBx8NOKIgoo3+htdY=;
        b=w7CFZN9yZ55pathx9HwKa5DygByOxZbNGr9EvR9z//j9ndzbBmHLY2xyybqvbHOYmP
         Xg1qzlKwGKbveZiBQIr38SJfdvjgswBUmrSMFt2tweFRhNskA3rvoXfeIRVn/qBHLUwD
         OaVcXakuIEheO+sFAA8Z3FkvNCpnzHhXyUWKaHk24uU5lnIQxVW2IDlBHOgLfxXgJopa
         PPXB5gLYp4hZDdzaXA+PpreBUm6xzrDfxUteQk1BDy63OFfucznt2qGx2Vc/KH9G40g5
         AmjnYZgdUesu0N7pxgMo48jgUkGNeRL6QIpR0AlwegdRQXbOrjrMQeGKL8n5OrbQ1tm/
         jEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nytOOCtj+t+VV6OI8ONHh+GMp4FBx8NOKIgoo3+htdY=;
        b=gCJ8HhoU/gVl/HQFhnPtAk0bLYcPt3ER7kScXmAAETEz64tduEjgo7RCgwRotL29Iu
         hci3HrKv8J1Wb1gz1nG5P2mBJdgQqmaaRuMiucohwmC/I6B2XVT/iEjWegRw969lppRL
         1024Xs6URSd8h9OS/XbhzGvxz6+MLVgZIOz3Y3azOklmDN2yr0xWmmHgg2cOJnWqPVPq
         sww6wPJqap+lwGtSIx5RQvL6ed+eSFoKIL2C1y5y59xbIzOtqYWl5LmOcMDeynO0p7ap
         Te9MVz41hcRCwjh3OqJ/BdUPWs2KSqpPEyGgUKIpaFLJry6oeQfT/ijYO8rlLB2U7Izg
         MXyw==
X-Gm-Message-State: ANoB5pktvDDEdO32o8snp8lqCHD0WVgieqelkoTtcrCE+Ayv2MZCI67M
        S60aCP5nE0wtcJg7FAA4sU2kEDQIZUIkf4DOcF658Q==
X-Google-Smtp-Source: AA0mqf4yB/dl9tB/3EtD43F6yWY44y59J4H/nkcCCVy7u9g47JGpatiy2FgduhfFbw2uAyjotB/ZBg==
X-Received: by 2002:aa7:d58e:0:b0:46c:3f7e:d7a5 with SMTP id r14-20020aa7d58e000000b0046c3f7ed7a5mr11684346edq.363.1670253783193;
        Mon, 05 Dec 2022 07:23:03 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kx4-20020a170907774400b0079e11b8e891sm6290950ejc.125.2022.12.05.07.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 07:23:02 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        ioana.ciornei@nxp.com, dmichail@fungible.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tchornyi@marvell.com, tariqt@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, idosch@nvidia.com, petrm@nvidia.com,
        vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, simon.horman@corigine.com,
        shannon.nelson@amd.com, brett.creeley@amd.com
Subject: [patch net-next 2/8] netdevsim: call devl_port_register/unregister() on registered instance
Date:   Mon,  5 Dec 2022 16:22:51 +0100
Message-Id: <20221205152257.454610-3-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221205152257.454610-1-jiri@resnulli.us>
References: <20221205152257.454610-1-jiri@resnulli.us>
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
RFC->v1:
- shortened patch subject
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

