Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EADCE35E2EA
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 17:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbhDMPcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 11:32:11 -0400
Received: from blyat.fensystems.co.uk ([54.246.183.96]:59012 "EHLO
        blyat.fensystems.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhDMPcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 11:32:09 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Apr 2021 11:32:09 EDT
Received: from dolphin.home (unknown [IPv6:2a00:23c6:5495:5e00:72b3:d5ff:feb1:e101])
        by blyat.fensystems.co.uk (Postfix) with ESMTPSA id 5E5C044289;
        Tue, 13 Apr 2021 15:25:18 +0000 (UTC)
From:   Michael Brown <mbrown@fensystems.co.uk>
To:     paul@xen.org, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org, wei.liu@kernel.org, pdurrant@amazon.com
Cc:     Michael Brown <mbrown@fensystems.co.uk>
Subject: [PATCH] xen-netback: Check for hotplug-status existence before watching
Date:   Tue, 13 Apr 2021 16:25:12 +0100
Message-Id: <20210413152512.903750-1-mbrown@fensystems.co.uk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
References: <54659eec-e315-5dc5-1578-d91633a80077@xen.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on
        blyat.fensystems.co.uk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 drivers/net/xen-netback/xenbus.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index a5439c130130..d24b7a7993aa 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -824,11 +824,15 @@ static void connect(struct backend_info *be)
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
2.29.2

