Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120E36C61EB
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbjCWIhZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbjCWIhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:37:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FA2166D0
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 01:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679560483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=wnCcLT+6/JjWKKpdL8dFobAiLz9IUksiUSNp7mgedxU=;
        b=fip4EENqFSUFAikGpIWkXAeed4oquHiwTzcG1fNWlx1vLaWGuXcQG1DlK48t4KJKUzJvqh
        +gk6VJ3+OkZdL0WTvSOZUl4LXT4cg2MX0lCtZe23bu/B6hp9HREGhihxhw2K6ByoS8Upu9
        m1KBoSVnXpULMWB3nnSulbiom9q8Vik=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-BehEh8hyPSmoalPdwjqyjA-1; Thu, 23 Mar 2023 04:34:38 -0400
X-MC-Unique: BehEh8hyPSmoalPdwjqyjA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BF3C2185A7A9;
        Thu, 23 Mar 2023 08:34:37 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.204])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E5EC7492B01;
        Thu, 23 Mar 2023 08:34:35 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Tianhao Zhao <tizhao@redhat.com>,
        Jonathan Cooper <jonathan.s.cooper@amd.com>
Subject: [PATCH v2 net] sfc: ef10: don't overwrite offload features at NIC reset
Date:   Thu, 23 Mar 2023 09:34:17 +0100
Message-Id: <20230323083417.7345-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At NIC reset, some offload features related to encapsulated traffic
might have changed (this mainly happens if the firmware-variant is
changed with the sfboot userspace tool). Because of this, features are
checked and set again at reset time.

However, this was not done right, and some features were improperly
overwritten at NIC reset:
- Tunneled IPv6 segmentation was always disabled
- Features disabled with ethtool were reenabled
- Features that becomes unsupported after the reset were not disabled

Also, checking if the device supports IPV6_CSUM to enable TSO6 is no
longer necessary because all currently supported devices support it.
Additionally, move the assignment of some other features to the
EF10_OFFLOAD_FEATURES macro, like it is done in ef100, leaving the
selection of features in efx_pci_probe_post_io a bit cleaner.

Fixes: ffffd2454a7a ("sfc: correctly advertise tunneled IPv6 segmentation")
Fixes: 24b2c3751aa3 ("sfc: advertise encapsulated offloads on EF10")
Reported-by: Tianhao Zhao <tizhao@redhat.com>
Suggested-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Tested-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
v2: reworded the paragraph that explains the code cleanup in efx_pci_probe_post_io
because it was not very clear
---
 drivers/net/ethernet/sfc/ef10.c | 38 ++++++++++++++++++++++-----------
 drivers/net/ethernet/sfc/efx.c  | 17 ++++++---------
 2 files changed, 33 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 7022fb2005a2..d30459dbfe8f 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1304,7 +1304,8 @@ static void efx_ef10_fini_nic(struct efx_nic *efx)
 static int efx_ef10_init_nic(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	netdev_features_t hw_enc_features = 0;
+	struct net_device *net_dev = efx->net_dev;
+	netdev_features_t tun_feats, tso_feats;
 	int rc;
 
 	if (nic_data->must_check_datapath_caps) {
@@ -1349,20 +1350,30 @@ static int efx_ef10_init_nic(struct efx_nic *efx)
 		nic_data->must_restore_piobufs = false;
 	}
 
-	/* add encapsulated checksum offload features */
+	/* encap features might change during reset if fw variant changed */
 	if (efx_has_cap(efx, VXLAN_NVGRE) && !efx_ef10_is_vf(efx))
-		hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
-	/* add encapsulated TSO features */
-	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
-		netdev_features_t encap_tso_features;
+		net_dev->hw_enc_features |= NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM;
+	else
+		net_dev->hw_enc_features &= ~(NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM);
 
-		encap_tso_features = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
-			NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+	tun_feats = NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_GRE |
+		    NETIF_F_GSO_UDP_TUNNEL_CSUM | NETIF_F_GSO_GRE_CSUM;
+	tso_feats = NETIF_F_TSO | NETIF_F_TSO6;
 
-		hw_enc_features |= encap_tso_features | NETIF_F_TSO;
-		efx->net_dev->features |= encap_tso_features;
+	if (efx_has_cap(efx, TX_TSO_V2_ENCAP)) {
+		/* If this is first nic_init, or if it is a reset and a new fw
+		 * variant has added new features, enable them by default.
+		 * If the features are not new, maintain their current value.
+		 */
+		if (!(net_dev->hw_features & tun_feats))
+			net_dev->features |= tun_feats;
+		net_dev->hw_enc_features |= tun_feats | tso_feats;
+		net_dev->hw_features |= tun_feats;
+	} else {
+		net_dev->hw_enc_features &= ~(tun_feats | tso_feats);
+		net_dev->hw_features &= ~tun_feats;
+		net_dev->features &= ~tun_feats;
 	}
-	efx->net_dev->hw_enc_features = hw_enc_features;
 
 	/* don't fail init if RSS setup doesn't work */
 	rc = efx->type->rx_push_rss_config(efx, false,
@@ -4021,7 +4032,10 @@ static unsigned int efx_ef10_recycle_ring_size(const struct efx_nic *efx)
 	 NETIF_F_HW_VLAN_CTAG_FILTER |	\
 	 NETIF_F_IPV6_CSUM |		\
 	 NETIF_F_RXHASH |		\
-	 NETIF_F_NTUPLE)
+	 NETIF_F_NTUPLE |		\
+	 NETIF_F_SG |			\
+	 NETIF_F_RXCSUM |		\
+	 NETIF_F_RXALL)
 
 const struct efx_nic_type efx_hunt_a0_vf_nic_type = {
 	.is_vf = true,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 02c2adeb0a12..884d8d168862 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1001,21 +1001,18 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 	}
 
 	/* Determine netdevice features */
-	net_dev->features |= (efx->type->offload_features | NETIF_F_SG |
-			      NETIF_F_TSO | NETIF_F_RXCSUM | NETIF_F_RXALL);
-	if (efx->type->offload_features & (NETIF_F_IPV6_CSUM | NETIF_F_HW_CSUM)) {
-		net_dev->features |= NETIF_F_TSO6;
-		if (efx_has_cap(efx, TX_TSO_V2_ENCAP))
-			net_dev->hw_enc_features |= NETIF_F_TSO6;
-	}
-	/* Check whether device supports TSO */
-	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+	net_dev->features |= efx->type->offload_features;
+
+	/* Add TSO features */
+	if (efx->type->tso_versions && efx->type->tso_versions(efx))
+		net_dev->features |= NETIF_F_TSO | NETIF_F_TSO6;
+
 	/* Mask for features that also apply to VLAN devices */
 	net_dev->vlan_features |= (NETIF_F_HW_CSUM | NETIF_F_SG |
 				   NETIF_F_HIGHDMA | NETIF_F_ALL_TSO |
 				   NETIF_F_RXCSUM);
 
+	/* Determine user configurable features */
 	net_dev->hw_features |= net_dev->features & ~efx->fixed_features;
 
 	/* Disable receiving frames with bad FCS, by default. */
-- 
2.39.2

