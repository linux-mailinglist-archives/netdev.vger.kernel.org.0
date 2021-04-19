Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 188F6364C21
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 22:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243153AbhDSUsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 16:48:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242748AbhDSUqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 16:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE98613D5;
        Mon, 19 Apr 2021 20:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618865128;
        bh=YW3vYxnGOhg3+Kycggdg534bAnAV6eoJFWmNIQVXieA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K9TYCxGLIY+pqb0D1V8jokw0yBXWMpGJ5NottRjQZ+TP1MUOsLvjEXGPYZmZ/Y2aO
         vtlWC9kud8Eo9kj9U1mg5DMyy2nymBOEDYuuFBLvQhLutFuk1InPQuIu8lAvUFGwhx
         RAzEW+Gh2t2ksNQAiEl3M9paAVBaNI+1OtOJQ8Y0TQw70rR8rUPFEvAdtU4O1m6fuV
         LkaLeBtVUG3d/ksLcVP4ia6zVsXoJJwumhjApKwvf5FEgu5pS40nPFCyx4lk/M7/dE
         Bj253pCFE2UHDbrTwvK2sJPhvUCzRDa4+0U511gFkFfWTxhFK/O97Qv6OXJVfBynSB
         rbSt7k4x3BJJw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Brown <mbrown@fensystems.co.uk>,
        Paul Durrant <paul@xen.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/12] xen-netback: Check for hotplug-status existence before watching
Date:   Mon, 19 Apr 2021 16:45:12 -0400
Message-Id: <20210419204517.6770-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210419204517.6770-1-sashal@kernel.org>
References: <20210419204517.6770-1-sashal@kernel.org>
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
index 107bbd4ae825..78c56149559c 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -1043,11 +1043,15 @@ static void connect(struct backend_info *be)
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

