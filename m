Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F21E85A96B2
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 14:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233408AbiIAM0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 08:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232779AbiIAM0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 08:26:02 -0400
X-Greylist: delayed 1791 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 01 Sep 2022 05:26:01 PDT
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8C45C363
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 05:26:01 -0700 (PDT)
Received: from xenbits.xenproject.org ([104.239.192.120])
        by mail.xenproject.org with esmtp (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1oTinp-0002b8-IH; Thu, 01 Sep 2022 11:56:09 +0000
Received: from [54.239.6.185] (helo=debian.cbg12.amazon.com)
        by xenbits.xenproject.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <pdurrant@amazon.com>)
        id 1oTinp-000695-79; Thu, 01 Sep 2022 11:56:09 +0000
From:   Paul Durrant <pdurrant@amazon.com>
To:     netdev@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     Paul Durrant <pdurrant@amazon.com>, Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Subject: [PATCH net] xen-netback: only remove 'hotplug-status' when the vif is actually destroyed
Date:   Thu,  1 Sep 2022 12:55:54 +0100
Message-Id: <20220901115554.16996-1-pdurrant@amazon.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_ADSP_ALL,
        RCVD_IN_DNSWL_MED,SPF_FAIL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing 'hotplug-status' in backend_disconnected() means that it will be
removed even in the case that the frontend unilaterally disconnects (which
it is free to do at any time). The consequence of this is that, when the
frontend attempts to re-connect, the backend gets stuck in 'InitWait'
rather than moving straight to 'Connected' (which it can do because the
hotplug script has already run).
Instead, the 'hotplug-status' mode should be removed in netback_remove()
i.e. when the vif really is going away.

Fixes: 0f4558ae9187 ("Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"")
Signed-off-by: Paul Durrant <pdurrant@amazon.com>
---
Cc: Wei Liu <wei.liu@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: "Marek Marczykowski-Górecki" <marmarek@invisiblethingslab.com>
---
 drivers/net/xen-netback/xenbus.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 990360d75cb6..e85b3c5d4acc 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -256,7 +256,6 @@ static void backend_disconnect(struct backend_info *be)
 		unsigned int queue_index;
 
 		xen_unregister_watchers(vif);
-		xenbus_rm(XBT_NIL, be->dev->nodename, "hotplug-status");
 #ifdef CONFIG_DEBUG_FS
 		xenvif_debugfs_delif(vif);
 #endif /* CONFIG_DEBUG_FS */
@@ -984,6 +983,7 @@ static int netback_remove(struct xenbus_device *dev)
 	struct backend_info *be = dev_get_drvdata(&dev->dev);
 
 	unregister_hotplug_status_watch(be);
+	xenbus_rm(XBT_NIL, dev->nodename, "hotplug-status");
 	if (be->vif) {
 		kobject_uevent(&dev->dev.kobj, KOBJ_OFFLINE);
 		backend_disconnect(be);
-- 
2.20.1

