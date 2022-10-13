Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310EB5FDC3C
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 16:17:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiJMORQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 13 Oct 2022 10:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230134AbiJMORO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 10:17:14 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [205.139.111.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B27812586F
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 07:17:12 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-8RVoGSSZNMy9IKnfolHQQg-1; Thu, 13 Oct 2022 10:17:06 -0400
X-MC-Unique: 8RVoGSSZNMy9IKnfolHQQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3740885A583;
        Thu, 13 Oct 2022 14:16:55 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.192.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBE84112D42A;
        Thu, 13 Oct 2022 14:16:47 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net 1/5] Revert "net: macsec: report real_dev features when HW offloading is enabled"
Date:   Thu, 13 Oct 2022 16:15:39 +0200
Message-Id: <dc221ba5aefd21ff2a0b89d3f58ff714899613aa.1665416630.git.sd@queasysnail.net>
In-Reply-To: <cover.1665416630.git.sd@queasysnail.net>
References: <cover.1665416630.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit c850240b6c4132574a00f2da439277ab94265b66.

Copying the features of the real device doesn't work when it also
supports IPsec offload, because then we'll have a device with
NETIF_F_HW_ESP but no netdev->xfrmdev_ops.

Example perf trace when running
  ip link add link eni1np1 type macsec port 4 offload mac

    ip   737 [003]   795.477676: probe:xfrm_dev_event__REGISTER      name="macsec0" features=0x1c000080014869
              xfrm_dev_event+0x3a
              notifier_call_chain+0x47
              register_netdevice+0x846
              macsec_newlink+0x25a

    ip   737 [003]   795.477687:   probe:xfrm_dev_event__return      ret=0x8002 (NOTIFY_BAD)
             notifier_call_chain+0x47
             register_netdevice+0x846
             macsec_newlink+0x25a

dev->features includes NETIF_F_HW_ESP (0x04000000000000), so
xfrm_api_check returns NOTIFY_BAD because we don't have
dev->xfrmdev_ops on the macsec device.

We could probably propagate GSO and a few other features from the
lower device, similar to macvlan. This will be done in a future patch.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 drivers/net/macsec.c | 27 ++++-----------------------
 1 file changed, 4 insertions(+), 23 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c891b60937a7..b3f76e8071f2 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -2654,11 +2654,6 @@ static int macsec_upd_offload(struct sk_buff *skb, struct genl_info *info)
 	if (ret)
 		goto rollback;
 
-	/* Force features update, since they are different for SW MACSec and
-	 * HW offloading cases.
-	 */
-	netdev_update_features(dev);
-
 	rtnl_unlock();
 	return 0;
 
@@ -3432,16 +3427,9 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
 	return ret;
 }
 
-#define SW_MACSEC_FEATURES \
+#define MACSEC_FEATURES \
 	(NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_FRAGLIST)
 
-/* If h/w offloading is enabled, use real device features save for
- *   VLAN_FEATURES - they require additional ops
- *   HW_MACSEC - no reason to report it
- */
-#define REAL_DEV_FEATURES(dev) \
-	((dev)->features & ~(NETIF_F_VLAN_FEATURES | NETIF_F_HW_MACSEC))
-
 static int macsec_dev_init(struct net_device *dev)
 {
 	struct macsec_dev *macsec = macsec_priv(dev);
@@ -3458,12 +3446,8 @@ static int macsec_dev_init(struct net_device *dev)
 		return err;
 	}
 
-	if (macsec_is_offloaded(macsec)) {
-		dev->features = REAL_DEV_FEATURES(real_dev);
-	} else {
-		dev->features = real_dev->features & SW_MACSEC_FEATURES;
-		dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
-	}
+	dev->features = real_dev->features & MACSEC_FEATURES;
+	dev->features |= NETIF_F_LLTX | NETIF_F_GSO_SOFTWARE;
 
 	dev->needed_headroom = real_dev->needed_headroom +
 			       MACSEC_NEEDED_HEADROOM;
@@ -3495,10 +3479,7 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 	struct macsec_dev *macsec = macsec_priv(dev);
 	struct net_device *real_dev = macsec->real_dev;
 
-	if (macsec_is_offloaded(macsec))
-		return REAL_DEV_FEATURES(real_dev);
-
-	features &= (real_dev->features & SW_MACSEC_FEATURES) |
+	features &= (real_dev->features & MACSEC_FEATURES) |
 		    NETIF_F_GSO_SOFTWARE | NETIF_F_SOFT_FEATURES;
 	features |= NETIF_F_LLTX;
 
-- 
2.38.0

