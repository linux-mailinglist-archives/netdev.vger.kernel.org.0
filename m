Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84B1468A15
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 09:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232456AbhLEIZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 03:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229877AbhLEIZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Dec 2021 03:25:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2056C061751;
        Sun,  5 Dec 2021 00:22:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DE5A60F4C;
        Sun,  5 Dec 2021 08:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE08C341C1;
        Sun,  5 Dec 2021 08:22:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638692541;
        bh=ciKStScTKqhzFKEKOa4+CWfCFsDssmEW0cTT/bPmL4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mm5mnlfsr39FLl/l8V2onh+glC0aAcgB1ljmxuoarhdLuNpsacsmIvhwrPYQ48G5s
         pQIzOcHHVlnyFIzBH6d76SW4TDqrPLEhiZ31SrzLIxNqughykf6m6L+iYKvMAYvpSb
         NhDuZlog5jETnzyYJIxazuYU2AqYn/C/U7Slvj+LAYYzEEtBiF+4txw6w+kZ+fHZf8
         CsTln2ZKaLh60hTgBRcQApqrAJkQ+PkTwofJnPSGVyIVg5o5YZP67xmO2swvpMD1aF
         nd6TxeQDALQ7DfuqlXzL6pMUvnP4ZffKKxNAJdZ7mOV3O+IJsuVlky1lNDRqecFOzT
         Uf3a1h396fB2g==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 1/6] devlink: Clean registration of devlink port
Date:   Sun,  5 Dec 2021 10:22:01 +0200
Message-Id: <f3ce2879f0f16dbbf9c320aa6c225e1a6a23d2c0.1638690564.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1638690564.git.leonro@nvidia.com>
References: <cover.1638690564.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

devlink_port_register() is in-kernel API and as such can't really
fail as long as driver author didn't make a mistake by providing
already existing port index.

Instead of relying on various error prints from the driver, convert
the existence check to be WARN_ON(), so such a mistake will be caught
immediately.

Tested-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/core/devlink.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index db3b52110cf2..34d0f623b2a9 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -268,12 +268,6 @@ static struct devlink_port *devlink_port_get_by_index(struct devlink *devlink,
 	return NULL;
 }
 
-static bool devlink_port_index_exists(struct devlink *devlink,
-				      unsigned int port_index)
-{
-	return devlink_port_get_by_index(devlink, port_index);
-}
-
 static struct devlink_port *devlink_port_get_from_attrs(struct devlink *devlink,
 							struct nlattr **attrs)
 {
@@ -9255,25 +9249,24 @@ int devlink_port_register(struct devlink *devlink,
 			  struct devlink_port *devlink_port,
 			  unsigned int port_index)
 {
-	mutex_lock(&devlink->lock);
-	if (devlink_port_index_exists(devlink, port_index)) {
-		mutex_unlock(&devlink->lock);
-		return -EEXIST;
-	}
-
+	WARN_ON(devlink_port_get_by_index(devlink, port_index));
 	WARN_ON(devlink_port->devlink);
+
 	devlink_port->devlink = devlink;
 	devlink_port->index = port_index;
 	spin_lock_init(&devlink_port->type_lock);
 	INIT_LIST_HEAD(&devlink_port->reporter_list);
 	mutex_init(&devlink_port->reporters_lock);
-	list_add_tail(&devlink_port->list, &devlink->port_list);
 	INIT_LIST_HEAD(&devlink_port->param_list);
 	INIT_LIST_HEAD(&devlink_port->region_list);
-	mutex_unlock(&devlink->lock);
 	INIT_DELAYED_WORK(&devlink_port->type_warn_dw, &devlink_port_type_warn);
-	devlink_port_type_warn_schedule(devlink_port);
+
+	mutex_lock(&devlink->lock);
+	list_add_tail(&devlink_port->list, &devlink->port_list);
+	mutex_unlock(&devlink->lock);
+
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
+	devlink_port_type_warn_schedule(devlink_port);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(devlink_port_register);
-- 
2.33.1

