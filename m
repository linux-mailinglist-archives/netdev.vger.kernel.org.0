Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9786359E2
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 11:29:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236682AbiKWK3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 05:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiKWK2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 05:28:24 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769C313C71C
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 02:10:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669198230;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=BA/VRe4F7sQRSn5Y+xXjhNKlOdleg/Hv6EUowTIJeu0=;
        b=O0aXwJT3ozxV8OmnJhSxkGsoM7fGDpz4RDmkLdnXZ1bS+VCtuxKkHSR03sKrsiQw3AL+Oe
        XN00E9sJiK1JL9/dnA9vXksZn8AxDT6h9cD514d+Pj5uwY1Q7gLzIeIu8TzpsE4Uyk8Doa
        NQNuVQUoHPKzbJymL7X47XZN2bSIOXY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-283-5pISMaFGOYy6UT-ZBjjA1w-1; Wed, 23 Nov 2022 05:10:25 -0500
X-MC-Unique: 5pISMaFGOYy6UT-ZBjjA1w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DF39B3C0ED4D;
        Wed, 23 Nov 2022 10:10:24 +0000 (UTC)
Received: from ibakolla.brq.csb (ovpn-192-93.brq.redhat.com [10.40.192.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9F8DD40C2086;
        Wed, 23 Nov 2022 10:10:13 +0000 (UTC)
From:   Izabela Bakollari <ibakolla@redhat.com>
To:     irusskikh@marvell.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, ibakolla@redhat.com
Subject: [PATCH net] aquantia: Do not purge addresses when setting the number of rings
Date:   Wed, 23 Nov 2022 11:10:08 +0100
Message-Id: <20221123101008.224389-1-ibakolla@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPV6 addresses are purged when setting the number of rx/tx
rings using ethtool -G. The function aq_set_ringparam
calls dev_close, which removes the addresses. As a solution,
call an internal function (aq_ndev_close).

Fixes: c1af5427954b ("net: aquantia: Ethtool based ring size configuration")

Signed-off-by: Izabela Bakollari <ibakolla@redhat.com>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c | 5 +++--
 drivers/net/ethernet/aquantia/atlantic/aq_main.c    | 4 ++--
 drivers/net/ethernet/aquantia/atlantic/aq_main.h    | 2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index a08f221e30d4..ac4ea93bd8dd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -13,6 +13,7 @@
 #include "aq_ptp.h"
 #include "aq_filters.h"
 #include "aq_macsec.h"
+#include "aq_main.h"
 
 #include <linux/ptp_clock_kernel.h>
 
@@ -858,7 +859,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 
 	if (netif_running(ndev)) {
 		ndev_running = true;
-		dev_close(ndev);
+		aq_ndev_close(ndev);
 	}
 
 	cfg->rxds = max(ring->rx_pending, hw_caps->rxds_min);
@@ -874,7 +875,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 		goto err_exit;
 
 	if (ndev_running)
-		err = dev_open(ndev, NULL);
+		err = aq_ndev_open(ndev);
 
 err_exit:
 	return err;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index 8a0af371e7dc..77609dc0a08d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -58,7 +58,7 @@ struct net_device *aq_ndev_alloc(void)
 	return ndev;
 }
 
-static int aq_ndev_open(struct net_device *ndev)
+int aq_ndev_open(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
@@ -88,7 +88,7 @@ static int aq_ndev_open(struct net_device *ndev)
 	return err;
 }
 
-static int aq_ndev_close(struct net_device *ndev)
+int aq_ndev_close(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.h b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
index 99870865f66d..a78c1a168d8e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
@@ -16,5 +16,7 @@ DECLARE_STATIC_KEY_FALSE(aq_xdp_locking_key);
 
 void aq_ndev_schedule_work(struct work_struct *work);
 struct net_device *aq_ndev_alloc(void);
+int aq_ndev_open(struct net_device *ndev);
+int aq_ndev_close(struct net_device *ndev);
 
 #endif /* AQ_MAIN_H */
-- 
2.31.1

