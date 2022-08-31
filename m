Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7345A7280
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 02:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiHaAet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 20:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiHaAen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 20:34:43 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6FF37A50CD;
        Tue, 30 Aug 2022 17:34:42 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 499E02045E28; Tue, 30 Aug 2022 17:34:42 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 499E02045E28
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1661906082;
        bh=mjntEKCOQ32F0z0a485Q4LpfxjrNXV7ylzcx5ZNkSaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=tG44ug2icTcPi/DQGQGH8N6f81EOpLWBb0hmLXZotuSOp7q1xRQeRxAXrE9+UcvqB
         LvEsiE1fP3FF2bvvFTbevAxgn97fBX0CxRu4fezQH99v1RmLcoR91MHxFKYLMKprkv
         Ct/BydgPHeDiqmHIEmzV2PLFLx4whnsQW6AsAn2U=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, edumazet@google.com,
        shiraz.saleem@intel.com, Ajay Sharma <sharmaajay@microsoft.com>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [Patch v5 03/12] net: mana: Handle vport sharing between devices
Date:   Tue, 30 Aug 2022 17:34:22 -0700
Message-Id: <1661906071-29508-4-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
References: <1661906071-29508-1-git-send-email-longli@linuxonhyperv.com>
Reply-To: longli@microsoft.com
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Long Li <longli@microsoft.com>

For outgoing packets, the PF requires the VF to configure the vport with
corresponding protection domain and doorbell ID for the kernel or user
context. The vport can't be shared between different contexts.

Implement the logic to exclusively take over the vport by either the
Ethernet device or RDMA device.

Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Long Li <longli@microsoft.com>
---
Change log:
v2: use refcount instead of directly using atomic variables
v4: change to mutex to avoid possible race with refcount
v5: add detailed comments explaining vport sharing, use EXPORT_SYMBOL_NS

 drivers/net/ethernet/microsoft/mana/mana.h    |  7 +++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 54 ++++++++++++++++++-
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index d36405af9432..2643036ee3e0 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -375,6 +375,10 @@ struct mana_port_context {
 
 	mana_handle_t port_handle;
 
+	/* Mutex for sharing access to vport_use_count */
+	struct mutex vport_mutex;
+	int vport_use_count;
+
 	u16 port_idx;
 
 	bool port_is_up;
@@ -561,4 +565,7 @@ struct mana_tx_package {
 	struct gdma_posted_wqe_info wqe_info;
 };
 
+int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
+		   u32 doorbell_pg_id);
+void mana_uncfg_vport(struct mana_port_context *apc);
 #endif /* _MANA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index bfe244aa0eca..f0bd0efd0b6a 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -531,13 +531,48 @@ static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_index,
 	return 0;
 }
 
-static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
-			  u32 doorbell_pg_id)
+void mana_uncfg_vport(struct mana_port_context *apc)
+{
+	mutex_lock(&apc->vport_mutex);
+	apc->vport_use_count--;
+	WARN_ON(apc->vport_use_count < 0);
+	mutex_unlock(&apc->vport_mutex);
+}
+EXPORT_SYMBOL_NS(mana_uncfg_vport, NET_MANA);
+
+int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
+		   u32 doorbell_pg_id)
 {
 	struct mana_config_vport_resp resp = {};
 	struct mana_config_vport_req req = {};
 	int err;
 
+	/* This function is used to program the Ethernet port in the hardware
+	 * table. It can be called from the Ethernet driver or the RDMA driver.
+	 *
+	 * For Ethernet usage, the hardware supports only one active user on a
+	 * physical port. The driver checks on the port usage before programming
+	 * the hardware when creating the RAW QP (RDMA driver) or exposing the
+	 * device to kernel NET layer (Ethernet driver).
+	 *
+	 * Because the RDMA driver doesn't know in advance which QP type the
+	 * user will create, it exposes the device with all its ports. The user
+	 * may not be able to create RAW QP on a port if this port is already
+	 * in used by the Ethernet driver from the kernel.
+	 *
+	 * This physical port limitation only applies to the RAW QP. For RC QP,
+	 * the hardware doesn't have this limitation. The user can create RC
+	 * QPs on a physical port up to the hardware limits independent of the
+	 * Ethernet usage on the same port.
+	 */
+	mutex_lock(&apc->vport_mutex);
+	if (apc->vport_use_count > 0) {
+		mutex_unlock(&apc->vport_mutex);
+		return -EBUSY;
+	}
+	apc->vport_use_count++;
+	mutex_unlock(&apc->vport_mutex);
+
 	mana_gd_init_req_hdr(&req.hdr, MANA_CONFIG_VPORT_TX,
 			     sizeof(req), sizeof(resp));
 	req.vport = apc->port_handle;
@@ -564,9 +599,16 @@ static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
 
 	apc->tx_shortform_allowed = resp.short_form_allowed;
 	apc->tx_vp_offset = resp.tx_vport_offset;
+
+	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
+		    apc->port_handle, protection_dom_id, doorbell_pg_id);
 out:
+	if (err)
+		mana_uncfg_vport(apc);
+
 	return err;
 }
+EXPORT_SYMBOL_NS(mana_cfg_vport, NET_MANA);
 
 static int mana_cfg_vport_steering(struct mana_port_context *apc,
 				   enum TRI_STATE rx,
@@ -627,6 +669,9 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 			   resp.hdr.status);
 		err = -EPROTO;
 	}
+
+	netdev_info(ndev, "Configured steering vPort %llu entries %u\n",
+		    apc->port_handle, num_entries);
 out:
 	kfree(req);
 	return err;
@@ -1679,6 +1724,8 @@ static void mana_destroy_vport(struct mana_port_context *apc)
 	}
 
 	mana_destroy_txq(apc);
+
+	mana_uncfg_vport(apc);
 }
 
 static int mana_create_vport(struct mana_port_context *apc,
@@ -1930,6 +1977,9 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->port_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
 
+	mutex_init(&apc->vport_mutex);
+	apc->vport_use_count = 0;
+
 	ndev->netdev_ops = &mana_devops;
 	ndev->ethtool_ops = &mana_ethtool_ops;
 	ndev->mtu = ETH_DATA_LEN;
-- 
2.17.1

