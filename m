Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB11650EB6
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 16:37:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231972AbiLSPhY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 10:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiLSPhX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 10:37:23 -0500
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA91FCE2;
        Mon, 19 Dec 2022 07:37:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1671464241; x=1703000241;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9p+mxbd5kh6SOfLyESUFNEms88GQjCAKJPms8yWVsvk=;
  b=oMQV3JCJM7WJ12K6f01S4tuvmp5Z6DYNPivvPll4s4vCaM542QfpRKuZ
   PgdUWXgJDtHvU4dtjh8+E0mf6Se1u8fsKqJrTc10X50/a/3SNm0eTCBgE
   8MUWnS/aikUQmlwM8+CocSLtQSg5cwvrsvCRwQkNlHR4tFUuZ3gnxxlaA
   s=;
X-IronPort-AV: E=Sophos;i="5.96,255,1665446400"; 
   d="scan'208";a="280451857"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 15:37:16 +0000
Received: from EX13D31EUA004.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-0ec33b60.us-west-2.amazon.com (Postfix) with ESMTPS id 3DFD6A2BBC;
        Mon, 19 Dec 2022 15:37:15 +0000 (UTC)
Received: from EX19D008EUA004.ant.amazon.com (10.252.50.158) by
 EX13D31EUA004.ant.amazon.com (10.43.165.161) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Mon, 19 Dec 2022 15:37:14 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX19D008EUA004.ant.amazon.com (10.252.50.158) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.20;
 Mon, 19 Dec 2022 15:37:13 +0000
Received: from dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (10.15.11.255)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.42 via Frontend Transport; Mon, 19 Dec 2022 15:37:12 +0000
Received: by dev-dsk-ptyadav-1c-37607b33.eu-west-1.amazon.com (Postfix, from userid 23027615)
        id A716920D70; Mon, 19 Dec 2022 16:37:11 +0100 (CET)
From:   Pratyush Yadav <ptyadav@amazon.de>
To:     <stable@vger.kernel.org>
CC:     Pratyush Yadav <ptyadav@amazon.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Sasha Levin" <sashal@kernel.org>, Puranjay Mohan <pjy@amazon.de>,
        Maximilian Heyne <mheyne@amazon.de>,
        Julien Grall <julien@xen.org>,
        <xen-devel@lists.xenproject.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 5.4] xen-netback: move removal of "hotplug-status" to the right place
Date:   Mon, 19 Dec 2022 16:37:10 +0100
Message-ID: <20221219153710.23782-1-ptyadav@amazon.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The removal of "hotplug-status" has moved around a bit. First it was
moved from netback_remove() to hotplug_status_changed() in upstream
commit 1f2565780e9b ("xen-netback: remove 'hotplug-status' once it has
served its purpose"). Then the change was reverted in upstream commit
0f4558ae9187 ("Revert "xen-netback: remove 'hotplug-status' once it has
served its purpose""), but it moved the removal to backend_disconnect().
Then the upstream commit c55f34b6aec2 ("xen-netback: only remove
'hotplug-status' when the vif is actually destroyed") moved it finally
back to netback_remove(). The thing to note being it is removed
unconditionally this time around.

The story on v5.4.y adds to this confusion. Commit 60e4e3198ce8 ("Revert
"xen-netback: remove 'hotplug-status' once it has served its purpose"")
is backported to v5.4.y but the original commit that it tries to revert
was never present on 5.4. So the backport incorrectly ends up just
adding another xenbus_rm() of "hotplug-status" in backend_disconnect().

Now in v5.4.y it is removed in both backend_disconnect() and
netback_remove(). But it should only be removed in netback_remove(), as
the upstream version does.

Removing "hotplug-status" in backend_disconnect() causes problems when
the frontend unilaterally disconnects, as explained in
c55f34b6aec2 ("xen-netback: only remove 'hotplug-status' when the vif is
actually destroyed").

Remove "hotplug-status" in the same place as it is done on the upstream
version to ensure unilateral re-connection of frontend continues to
work.

Fixes: 60e4e3198ce8 ("Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
---
 drivers/net/xen-netback/xenbus.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 44e353dd2ba1..43bd881ab3dd 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -202,10 +202,10 @@ static int netback_remove(struct xenbus_device *dev)
 	set_backend_state(be, XenbusStateClosed);

 	unregister_hotplug_status_watch(be);
+	xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		xen_unregister_watchers(be->vif);
-		xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 		xenvif_free(be->vif);
 		be->vif = NULL;
 	}
@@ -435,7 +435,6 @@ static void backend_disconnect(struct backend_info *be)
 		unsigned int queue_index;

 		xen_unregister_watchers(vif);
-		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */
--
2.38.1

