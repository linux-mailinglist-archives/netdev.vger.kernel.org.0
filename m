Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743434C9614
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 21:18:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237950AbiCAUSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 15:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbiCAUSp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 15:18:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A36F3DDD6;
        Tue,  1 Mar 2022 12:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCF5361764;
        Tue,  1 Mar 2022 20:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2002FC340EE;
        Tue,  1 Mar 2022 20:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165882;
        bh=pw0Qj8vjosGWO4vo4tauge3HBJo809oseTBs39UMTuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHAGf/B8QH90/Ba7i60IjQtmaoPSJVbHFBwhp2w6ftD1c1EkxmOoUXSG+bEaI5VbX
         9nfaSFQe/npJ1IBPaZXzzedJ4azBajOXIXyO0SY0rxqvPv0Y6nC0fBkRb1/wlszNNT
         HE7NbmdetzuGRDqlQH5ckDe1KuD+/hOUTuIr7RbcyIJJPddnebzABJLI5PsRdayNFH
         O+q8Hwg1u/EALhXpegotjJMzmzVjgVqh9UfQ0ouBNmArfx1VHMCDn24j4YGRLT+s5j
         h0ezFxAV96V+6LvtnQB0L/2OVJMMGQDo/CcfVkyU456jvMFJ6QQD2nNhTUFhx5L8pK
         Y3b9fiLoD6c6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>, Paul Durrant <paul@xen.org>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, wei.liu@kernel.org,
        davem@davemloft.net, xen-devel@lists.xenproject.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 18/23] Revert "xen-netback: Check for hotplug-status existence before watching"
Date:   Tue,  1 Mar 2022 15:16:17 -0500
Message-Id: <20220301201629.18547-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201629.18547-1-sashal@kernel.org>
References: <20220301201629.18547-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>

[ Upstream commit e8240addd0a3919e0fd7436416afe9aa6429c484 ]

This reverts commit 2afeec08ab5c86ae21952151f726bfe184f6b23d.

The reasoning in the commit was wrong - the code expected to setup the
watch even if 'hotplug-status' didn't exist. In fact, it relied on the
watch being fired the first time - to check if maybe 'hotplug-status' is
already set to 'connected'. Not registering a watch for non-existing
path (which is the case if hotplug script hasn't been executed yet),
made the backend not waiting for the hotplug script to execute. This in
turns, made the netfront think the interface is fully operational, while
in fact it was not (the vif interface on xen-netback side might not be
configured yet).

This was a workaround for 'hotplug-status' erroneously being removed.
But since that is reverted now, the workaround is not necessary either.

More discussion at
https://lore.kernel.org/xen-devel/afedd7cb-a291-e773-8b0d-4db9b291fa98@ipxe.org/T/#u

Signed-off-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Reviewed-by: Paul Durrant <paul@xen.org>
Reviewed-by: Michael Brown <mbrown@fensystems.co.uk>
Link: https://lore.kernel.org/r/20220222001817.2264967-2-marmarek@invisiblethingslab.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/xen-netback/xenbus.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 3fad58d22155b..990360d75cb64 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -824,15 +824,11 @@ static void connect(struct backend_info *be)
 	xenvif_carrier_on(be->vif);
 
 	unregister_hotplug_status_watch(be);
-	if (xenbus_exists(XBT_NIL, dev->nodename, "hotplug-status")) {
-		err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch,
-					   NULL, hotplug_status_changed,
-					   "%s/%s", dev->nodename,
-					   "hotplug-status");
-		if (err)
-			goto err;
+	err = xenbus_watch_pathfmt(dev, &be->hotplug_status_watch, NULL,
+				   hotplug_status_changed,
+				   "%s/%s", dev->nodename, "hotplug-status");
+	if (!err)
 		be->have_hotplug_status_watch = 1;
-	}
 
 	netif_tx_wake_all_queues(be->vif->dev);
 
-- 
2.34.1

