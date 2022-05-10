Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39320520FEA
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 10:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238176AbiEJItF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 04:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbiEJItD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 04:49:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E45FE2A2F71
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 01:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652172306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HSTF3Y32hwg9VhtSm1YWx5yoGh71K2SCy1twxLuciQ4=;
        b=PtCyX7WJCq+Eu+F4gANqUxCk3sJt306N0vKNy6ho+JZ/NZFE4gyHzSyqX0qxM3pBteJHZz
        3RbwOnCMn70+axnD+X4yzbKLqte5JJTbjUhp3HZP9x9tMPbNlLz7aEhyVzlCIxXsJDTZhp
        4XyTwKdtLOdpK0NBI4xH+nYE28A6CmY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-62-VhP2wT9_Ply6d99KpFBirA-1; Tue, 10 May 2022 04:45:03 -0400
X-MC-Unique: VhP2wT9_Ply6d99KpFBirA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BE76185A7A4;
        Tue, 10 May 2022 08:45:02 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.180])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D28C7413721;
        Tue, 10 May 2022 08:45:00 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        ap420073@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 3/5] sfc: rename set_channels to set_queues and document it
Date:   Tue, 10 May 2022 10:44:41 +0200
Message-Id: <20220510084443.14473-4-ihuguet@redhat.com>
In-Reply-To: <20220510084443.14473-1-ihuguet@redhat.com>
References: <20220510084443.14473-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function efx_set_channels had a bit missleading name because it was only
setting some parameters related to queues, but the name suggests that
much more things related to channels are being configured.

Also, function efx_set_xdp_channels has been renamed to
efx_xdp_tx_queues. It was even more missleading because there are cases
where XDP dedicated channels might not exist, but there are still some
xdp_tx queues parameters to configure, for example when sharing tx
queues from normal channels for XDP.

Finally, added some comments as documentation for these functions.

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ef100_netdev.c |  2 +-
 drivers/net/ethernet/sfc/efx.c          |  2 +-
 drivers/net/ethernet/sfc/efx_channels.c | 16 ++++++++++++----
 drivers/net/ethernet/sfc/efx_channels.h |  2 +-
 4 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 67fe44db6b61..fe8253d59782 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -118,7 +118,7 @@ static int ef100_net_open(struct net_device *net_dev)
 	if (rc)
 		goto fail;
 
-	rc = efx_set_channels(efx);
+	rc = efx_set_queues(efx);
 	if (rc)
 		goto fail;
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 5a772354da83..3d8a83b94e0a 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -289,7 +289,7 @@ static int efx_probe_nic(struct efx_nic *efx)
 		if (rc)
 			goto fail1;
 
-		rc = efx_set_channels(efx);
+		rc = efx_set_queues(efx);
 		if (rc)
 			goto fail1;
 
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 8feba80f0a34..1c05063a7215 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -780,6 +780,7 @@ static inline int efx_alloc_xdp_tx_queues(struct efx_nic *efx)
 	return 0;
 }
 
+/* Assign a tx queue to one CPU for XDP_TX action */
 static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
 				struct efx_tx_queue *tx_queue)
 {
@@ -794,7 +795,11 @@ static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
 	return 0;
 }
 
-static void efx_set_xdp_channels(struct efx_nic *efx)
+/* Create the cpu to tx_queue mappings for XDP_TX. Depending on the value of
+ * efx->xdp_txq_queues_mode, it may use dedicated XDP channels or shared queues
+ * with netdev core
+ */
+static void efx_set_xdp_tx_queues(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
@@ -915,7 +920,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		efx_init_napi_channel(efx->channel[i]);
 	}
 
-	efx_set_xdp_channels(efx);
+	efx_set_xdp_tx_queues(efx);
 out:
 	/* Destroy unused channel structures */
 	for (i = 0; i < efx->n_channels; i++) {
@@ -948,7 +953,10 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	goto out;
 }
 
-int efx_set_channels(struct efx_nic *efx)
+/* Assign hw queues to each RX and TX queue, create the cpu->tx_queue mapping
+ * for XDP_TX and register the RX and TX queues with netdev core
+ */
+int efx_set_queues(struct efx_nic *efx)
 {
 	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
@@ -982,7 +990,7 @@ int efx_set_channels(struct efx_nic *efx)
 	rc = efx_alloc_xdp_tx_queues(efx);
 	if (rc)
 		return rc;
-	efx_set_xdp_channels(efx);
+	efx_set_xdp_tx_queues(efx);
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
diff --git a/drivers/net/ethernet/sfc/efx_channels.h b/drivers/net/ethernet/sfc/efx_channels.h
index 64abb99a56b8..148e22415b05 100644
--- a/drivers/net/ethernet/sfc/efx_channels.h
+++ b/drivers/net/ethernet/sfc/efx_channels.h
@@ -35,7 +35,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries);
 void efx_set_channel_names(struct efx_nic *efx);
 int efx_init_channels(struct efx_nic *efx);
 int efx_probe_channels(struct efx_nic *efx);
-int efx_set_channels(struct efx_nic *efx);
+int efx_set_queues(struct efx_nic *efx);
 void efx_remove_channel(struct efx_channel *channel);
 void efx_remove_channels(struct efx_nic *efx);
 void efx_fini_channels(struct efx_nic *efx);
-- 
2.34.1

