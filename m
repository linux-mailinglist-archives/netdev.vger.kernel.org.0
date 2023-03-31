Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A476D1C0F
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 11:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbjCaJYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 05:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaJYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 05:24:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD1DBBA9
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 02:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680254627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LDfAVyOaRe33ksvmHZfHXjEPvZPlItSYY9EwWMh9y6o=;
        b=UWsXbhsQm9Um0Nn2ctCwDBakIpo8yY+6Q8lIUOyhQScrFl0a4qNkZEmms2pZfXsIUPrSe2
        YxT5uEuQQIh2UOrk1wCjvN5f/81T9WleEYtEcbX9jYZWkLIP2Ypb84/fqoKJ1UdvQS8P9b
        K9ZCXJF9vB2lgI6dc0M3h6fjaBIYyF4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-76-N28GOr3fMiCxCp67ka2qTg-1; Fri, 31 Mar 2023 05:23:43 -0400
X-MC-Unique: N28GOr3fMiCxCp67ka2qTg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3EE4438149A8;
        Fri, 31 Mar 2023 09:23:43 +0000 (UTC)
Received: from calimero.vinschen.de (unknown [10.39.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EEF474020C82;
        Fri, 31 Mar 2023 09:23:42 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id 4904DA80CAB; Fri, 31 Mar 2023 11:23:41 +0200 (CEST)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: stmmac: allow ethtool action on PCI devices if device is down
Date:   Fri, 31 Mar 2023 11:23:41 +0200
Message-Id: <20230331092341.268964-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far stmmac is only able to handle ethtool commands if the device
is UP.  However, PCI devices usually just have to be in the active
state for ethtool commands.

Rename stmmac_check_if_running to stmmac_ethtool_begin and add a
stmmac_ethtool_complete action.  Check if the device is connected
to PCI and if so, just make sure the device is active.  Reset it
to idle state as complete action.

Tested on Intel Elkhart Lake system.

Signed-off-by: Corinna Vinschen <vinschen@redhat.com>
---
 .../ethernet/stmicro/stmmac/stmmac_ethtool.c  | 20 +++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 35c8dd92d369..5a57970dc06a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -14,6 +14,7 @@
 #include <linux/mii.h>
 #include <linux/phylink.h>
 #include <linux/net_tstamp.h>
+#include <linux/pm_runtime.h>
 #include <asm/io.h>
 
 #include "stmmac.h"
@@ -429,13 +430,27 @@ static void stmmac_ethtool_setmsglevel(struct net_device *dev, u32 level)
 
 }
 
-static int stmmac_check_if_running(struct net_device *dev)
+static int stmmac_ethtool_begin(struct net_device *dev)
 {
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	if (priv->plat->pdev) {
+		pm_runtime_get_sync(&priv->plat->pdev->dev);
+		return 0;
+	}
 	if (!netif_running(dev))
 		return -EBUSY;
 	return 0;
 }
 
+static void stmmac_ethtool_complete(struct net_device *dev)
+{
+	struct stmmac_priv *priv = netdev_priv(dev);
+
+	if (priv->plat->pdev)
+		pm_runtime_put(&priv->plat->pdev->dev);
+}
+
 static int stmmac_ethtool_get_regs_len(struct net_device *dev)
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
@@ -1152,7 +1167,8 @@ static int stmmac_set_tunable(struct net_device *dev,
 static const struct ethtool_ops stmmac_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES,
-	.begin = stmmac_check_if_running,
+	.begin = stmmac_ethtool_begin,
+	.complete = stmmac_ethtool_complete,
 	.get_drvinfo = stmmac_ethtool_getdrvinfo,
 	.get_msglevel = stmmac_ethtool_getmsglevel,
 	.set_msglevel = stmmac_ethtool_setmsglevel,
-- 
2.39.2

