Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E0A3A7304
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhFOAdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:33:46 -0400
Received: from mail-lj1-f172.google.com ([209.85.208.172]:34529 "EHLO
        mail-lj1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbhFOAdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:33:45 -0400
Received: by mail-lj1-f172.google.com with SMTP id e25so1363904ljj.1
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8SNH56xDgFaJVGhuv5FEXCpqYqAJ/EXSXsZGOQBgUwQ=;
        b=Rxos9mueYH3IVB/3P3IIMTFmTCDJKJK007OBHHZaUHnxUJBjuOaLzVY4w2qjT8Ua3g
         5yKmimGv3DSam8JMYxoueikEbmX3l477uX8FbFXmoo4rDpuZVLENpCKC/Yd/H7Q1sQP5
         zUlxwKA0qX3HyX8Gm3vlALYAZzY7ATx5vrdrA8/2yu+z0H6quLdRCEaPNTZXD9ugF9/c
         v1VS3N5hVkPJY2YudaBicBDWQyNqkJPcFt5JqyuRTuf2GSFisCPSR+hMaGR6kIZyox5V
         R+QHlbrkedrk8K8AYmVIrQsypD2AnM3KRC8vabHPk10wUlg7IZEK37oG1C4fkBb3c9PC
         f99A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8SNH56xDgFaJVGhuv5FEXCpqYqAJ/EXSXsZGOQBgUwQ=;
        b=HCbkQL8Z9TumKmlGMy63BoWy5spwG+VR8f3dOfqBWHE9sIM4AedufDWBR912zXiHgB
         txN7F5GJTVyQs8v9OOmCfLpHPt16flvUT5io5airlapxWK9O50i8BQ6of5zuo6/wD5BU
         BvmhRLlykJCjYtg9oDKPPY2PR1UHhS/uRfOnj3iAPiaDvu7wsjKDpYVdYD6VDsRSNbKd
         i+320yLOQ6yP656TM8N5ainVL4XE/+MVXdKN6Jljih2d2XEqcXdgrp9LLzvf8Z7X0ya8
         v6/rV0AZl7AA4J/D4E+QFNwTgRapVkXMgSlMcIQSMb+pymG4T6GSop3dvkb+eDsQx9rn
         PFlQ==
X-Gm-Message-State: AOAM532EFGFLOtJQLQearHd3C1MyN48CmLS2ClJoW1duaXVpKUHcJfLq
        IxLKPaf2S0lWTCsnir2MqCk=
X-Google-Smtp-Source: ABdhPJxIjMHxZqXhpBIEQJVMxDibQLRYHDPkvrKi1PVira2bLjjgGe9YGxl9nar0P7eEGy0Lyj2fzg==
X-Received: by 2002:a05:651c:50c:: with SMTP id o12mr15947895ljp.364.1623717025109;
        Mon, 14 Jun 2021 17:30:25 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:24 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 05/10] wwan: core: remove all netdevs on ops unregistering
Date:   Tue, 15 Jun 2021 03:30:11 +0300
Message-Id: <20210615003016.477-6-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210615003016.477-1-ryazanov.s.a@gmail.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use the ops owner module hold to protect against ops memory
disappearing. But this approach does not protect us from a driver that
unregisters ops but forgets to remove netdev(s) that were created using
this ops. In such case, we are left with netdev(s), which can not be
removed since ops is gone. Moreover, batch netdevs removing on
deinitialization is a desireable option for WWAN drivers as it is a
quite common task.

Implement deletion of all created links on WWAN netdev ops unregistering
in the same way that RTNL removes all links on RTNL ops unregistering.
Simply remove all child netdevs of a device whose WWAN netdev ops is
unregistering. This way we protecting the kernel from buggy drivers and
make it easier to write a driver deinitialization code.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/wwan_core.c | 40 ++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wwan/wwan_core.c b/drivers/net/wwan/wwan_core.c
index 634f0a7a2dc6..3f04e674cdaa 100644
--- a/drivers/net/wwan/wwan_core.c
+++ b/drivers/net/wwan/wwan_core.c
@@ -933,6 +933,17 @@ int wwan_register_ops(struct device *parent, const struct wwan_ops *ops,
 }
 EXPORT_SYMBOL_GPL(wwan_register_ops);
 
+/* Enqueue child netdev deletion */
+static int wwan_child_dellink(struct device *dev, void *data)
+{
+	struct list_head *kill_list = data;
+
+	if (dev->type == &wwan_type)
+		wwan_rtnl_dellink(to_net_dev(dev), kill_list);
+
+	return 0;
+}
+
 /**
  * wwan_unregister_ops - remove WWAN device ops
  * @parent: Device to use as parent and shared by all WWAN ports and
@@ -941,26 +952,37 @@ EXPORT_SYMBOL_GPL(wwan_register_ops);
 void wwan_unregister_ops(struct device *parent)
 {
 	struct wwan_device *wwandev = wwan_dev_get_by_parent(parent);
-	bool has_ops;
+	struct module *owner;
+	LIST_HEAD(kill_list);
 
 	if (WARN_ON(IS_ERR(wwandev)))
 		return;
-
-	has_ops = wwandev->ops;
+	if (WARN_ON(!wwandev->ops)) {
+		put_device(&wwandev->dev);
+		return;
+	}
 
 	/* put the reference obtained by wwan_dev_get_by_parent(),
 	 * we should still have one (that the owner is giving back
-	 * now) due to the ops being assigned, check that below
-	 * and return if not.
+	 * now) due to the ops being assigned.
 	 */
 	put_device(&wwandev->dev);
 
-	if (WARN_ON(!has_ops))
-		return;
+	owner = wwandev->ops->owner;	/* Preserve ops owner */
+
+	rtnl_lock();	/* Prevent concurent netdev(s) creation/destroying */
+
+	/* Remove all child netdev(s), using batch removing */
+	device_for_each_child(&wwandev->dev, &kill_list,
+			      wwan_child_dellink);
+	unregister_netdevice_many(&kill_list);
+
+	wwandev->ops = NULL;	/* Finally remove ops */
+
+	rtnl_unlock();
 
-	module_put(wwandev->ops->owner);
+	module_put(owner);
 
-	wwandev->ops = NULL;
 	wwandev->ops_ctxt = NULL;
 	wwan_remove_dev(wwandev);
 }
-- 
2.26.3

