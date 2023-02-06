Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF22968B8D7
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBFJl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBFJl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:41:57 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D591A48C
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:41:54 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id dr8so32351808ejc.12
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 01:41:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G88L8O/YazxqXyKSn4qeEPlmWGXBeWeWoZD30RT6Jvw=;
        b=OATrDfN+NZi0PRc7TGkFndQ8F1/apJzbDX8XCMcvQhtxNnWP5HUOfd1NOo1ZoafYXP
         F2ZdVcHJIJH+C7EL3ZlTM2tN8SW2d1ClfXSDosxv4Dx2RV8wtJUVtv535FkW2/1cKBbI
         vE8Pzm7/PZPODutY1ZSTHEbGn/yiHke2CbTsy2Iav95YRvP0P8vhG2TLxEoNGe2Or4cx
         1K1aLrwVptzYxi+LYz+6qx6AR+WBs59+Y62RtBKCjO7f99GrRXhUn0VWHAR2O2CBRYhC
         nwlqvC3Fg15whuTbrejnxd7PZhmDOP7mdmvOe1QQsV/L5E2qS2ldLFgfh5EEjcI329tG
         9A1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G88L8O/YazxqXyKSn4qeEPlmWGXBeWeWoZD30RT6Jvw=;
        b=7HTGoTZBhIh73m3OfuRiy4893GT9vGoYT4Ui+2jt0+4zWIFik7oMMX+GBhuN2waGsS
         7+58yQKTR3jKWEigeRmewqZosFc7/5pqvlufNKOVRUUkldHGs6w7cYkFg6roC5o9CkbU
         7/YhVFetFt+5l8Xd3ufKvaFGnep1hh0ZKcBEnTSsYV60fLZKwY5t1uAVRM35WSBYMwvn
         ug5BX2o/ULA+07cDfUE8IfATQ0e7FaboznjUxplBrihWir6YdlDtyBdAAPJ1KIMmp0UG
         6qNg4+ImWedoLsAXveDzxcWbfciL+cYBs0pkaDZP9R7m6Fi5T3oh4U1PpO/RkjtHpEnK
         Waxg==
X-Gm-Message-State: AO0yUKVpZPrIQA6T+hs5mZh77GhdH5SkFr7ptNpmOJb+oMZY5Enw6ukA
        Sg1aXcu7BEUUW5D38aDH5J7yazK3feb10yvCVE8=
X-Google-Smtp-Source: AK7set+liSabGGvCdh4lA5wbfBkLwpYEz81DI3AXlydLawnZMtaGkRrMOqqPhvpKEVG4azIkPqbDyA==
X-Received: by 2002:a17:907:3e0a:b0:88d:ba89:1842 with SMTP id hp10-20020a1709073e0a00b0088dba891842mr16861488ejc.19.1675676513395;
        Mon, 06 Feb 2023 01:41:53 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id h20-20020a1709066d9400b0088c224bf5adsm5279788ejt.147.2023.02.06.01.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Feb 2023 01:41:52 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jacob.e.keller@intel.com
Subject: [patch net] devlink: change port event netdev notifier from per-net to global
Date:   Mon,  6 Feb 2023 10:41:51 +0100
Message-Id: <20230206094151.2557264-1-jiri@resnulli.us>
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

Currently only the network namespace of devlink instance is monitored
for port events. If netdev is moved to a different namespace and then
unregistered, NETDEV_PRE_UNINIT is missed which leads to trigger
following WARN_ON in devl_port_unregister().
WARN_ON(devlink_port->type != DEVLINK_PORT_TYPE_NOTSET);

Fix this by changing the netdev notifier from per-net to global so no
event is missed.

Fixes: 02a68a47eade ("net: devlink: track netdev with devlink_port assigned")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
---
 net/core/devlink.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 032d6d0a5ce6..909a10e4b0dd 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9979,7 +9979,7 @@ struct devlink *devlink_alloc_ns(const struct devlink_ops *ops,
 		goto err_xa_alloc;
 
 	devlink->netdevice_nb.notifier_call = devlink_netdevice_event;
-	ret = register_netdevice_notifier_net(net, &devlink->netdevice_nb);
+	ret = register_netdevice_notifier(&devlink->netdevice_nb);
 	if (ret)
 		goto err_register_netdevice_notifier;
 
@@ -10171,8 +10171,7 @@ void devlink_free(struct devlink *devlink)
 	xa_destroy(&devlink->snapshot_ids);
 	xa_destroy(&devlink->ports);
 
-	WARN_ON_ONCE(unregister_netdevice_notifier_net(devlink_net(devlink),
-						       &devlink->netdevice_nb));
+	WARN_ON_ONCE(unregister_netdevice_notifier(&devlink->netdevice_nb));
 
 	xa_erase(&devlinks, devlink->index);
 
@@ -10503,6 +10502,8 @@ static int devlink_netdevice_event(struct notifier_block *nb,
 		break;
 	case NETDEV_REGISTER:
 	case NETDEV_CHANGENAME:
+		if (devlink_net(devlink) != dev_net(netdev))
+			return NOTIFY_OK;
 		/* Set the netdev on top of previously set type. Note this
 		 * event happens also during net namespace change so here
 		 * we take into account netdev pointer appearing in this
@@ -10512,6 +10513,8 @@ static int devlink_netdevice_event(struct notifier_block *nb,
 					netdev);
 		break;
 	case NETDEV_UNREGISTER:
+		if (devlink_net(devlink) != dev_net(netdev))
+			return NOTIFY_OK;
 		/* Clear netdev pointer, but not the type. This event happens
 		 * also during net namespace change so we need to clear
 		 * pointer to netdev that is going to another net namespace.
-- 
2.39.0

