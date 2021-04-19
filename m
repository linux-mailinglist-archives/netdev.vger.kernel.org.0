Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0EA364BF8
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241476AbhDSUrq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242629AbhDSUp5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CADB0613C8;
        Mon, 19 Apr 2021 20:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865105;
        bh=hfnn5x2akktqak++VJChzBVIiGX8W28jFNoDTYZIixI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euNo6YjoIKZlJQSCNAw5YP6XXZlunL3mAbT+azAfUDunwxZbIegBWMqbzWMubo/FC
         sEPQvq9fdWxQChgEBOEfLAh8G/2+W4DKvp/liXn+oYAzGGkwa/8TbW/gQdT1q7vh/x
         CTMFNikx5arDZNj9GHiwVP5KNfHynfrQvPmUHoSn8HPL1g6bFN9xOdPnSrJY2Ktk44
         1tcoQVhjix+veo4QzsNc/OalyLlW72agKi6gr4uJIUgCoM7TGW/OH8PK0WqBaYJXqH
         6opAlMYG/+6f3a9AdV30bwq5MUakUN5nHca1QJlfShm39ie8FcZZwV2XEpX5mz1klL
         EjMoGPQLBoDIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Brown <mbrown@fensystems.co.uk>,
        Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/14] xen-netback: Check for hotplug-status existence before watching
Date:   Mon, 19 Apr 2021 16:44:47 -0400
Message-Id: <20210419204454.6601-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204454.6601-1-sashal@kernel.org>
References: <20210419204454.6601-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Brown <mbrown@fensystems.co.uk>

[ Upstream commit 2afeec08ab5c86ae21952151f726bfe184f6b23d ]

The logic in connect() is currently written with the assumption that
xenbus_watch_pathfmt() will return an error for a node that does not
exist.  This assumption is incorrect: xenstore does allow a watch to
be registered for a nonexistent node (and will send notifications
should the node be subsequently created).

As of commit 1f2565780 ("xen-netback: remove 'hotplug-status' once it
has served its purpose"), this leads to a failure when a domU
transitions into XenbusStateConnected more than once.  On the first
domU transition into Connected state, the "hotplug-status" node will
be deleted by the hotplug_status_changed() callback in dom0.  On the
second or subsequent domU transition into Connected state, the
hotplug_status_changed() callback will therefore never be invoked, and
so the backend will remain stuck in InitWait.

This failure prevents scenarios such as reloading the xen-netfront
module within a domU, or booting a domU via iPXE.  There is
unfortunately no way for the domU to work around this dom0 bug.

Fix by explicitly checking for existence of the "hotplug-status" node,
thereby creating the behaviour that was previously assumed to exist.

Signed-off-by: Michael Brown <mbrown@fensystems.co.uk>
Reviewed-by: Paul Durrant <paul@xen.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 9e61a6f29464..416305e6d093 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -979,11 +979,15 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
-				   hotplug_status_changed,
-				   "%s/%s", dev->nodename, "hotplug-status");
-	if (!err)
+	if (xenbus_exists(XBT_NIL, dev->nodename, "hotplug-status")) {
+		err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
+					   NULL, hotplug_status_changed,
+					   "%s/%s", dev->nodename,
+					   "hotplug-status");
+		if (err)
+			goto err;
 		be->have_hotplug_status_watch = 1;
+	}
 
 	netif_tx_wake_all_queues(be->vif->dev);
 
-- 
2.30.2

