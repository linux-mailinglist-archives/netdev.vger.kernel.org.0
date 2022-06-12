Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A8D547C46
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiFLVPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:15:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235735AbiFLVPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:15:10 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 255A713CCA;
        Sun, 12 Jun 2022 14:15:10 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id D9C0120C14C9; Sun, 12 Jun 2022 14:15:09 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D9C0120C14C9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655068509;
        bh=HmE3yStdCPEAS6wUO5BsxoUHsQSxeQL72W//rVfgedU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=rl0OMU26pOTg3EoadpQQ3gX0j9IjF2yKSFQqHLaErWZj0xq/OUJn968EiJJxorLhG
         GNJY4bT7TBjlAq7k5RyCZL59ToW41P9Ug3jqY9SldGqav9aEQaMH15Alch28rEY8Jq
         OgYM/INa1FCmcWrx9iNBuOjtFcUxDIREHnJJ2CRk=
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
Subject: [Patch v3 03/12] net: mana: Handle vport sharing between devices
Date:   Sun, 12 Jun 2022 14:14:45 -0700
Message-Id: <1655068494-16440-4-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
References: <1655068494-16440-1-git-send-email-longli@linuxonhyperv.com>
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

Signed-off-by: Long Li <longli@microsoft.com>
---
Change log:
v2: use refcount instead of directly using atomic variables

 drivers/net/ethernet/microsoft/mana/mana.h    |  4 +++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 27 +++++++++++++++++--
 2 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 51bff91b63ee..6aacbf42aeaf 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -375,6 +375,7 @@ struct mana_port_context {
 	unsigned int num_queues;
 
 	mana_handle_t port_handle;
+	refcount_t port_use_count;
 
 	u16 port_idx;
 
@@ -567,4 +568,7 @@ struct mana_adev {
 	struct gdma_dev *mdev;
 };
 
+int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
+		   u32 doorbell_pg_id);
+void mana_uncfg_vport(struct mana_port_context *apc);
 #endif /* _MANA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 745a9783dd70..839f7099ac2d 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -530,13 +530,26 @@ static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_index,
 	return 0;
 }
 
-static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
-			  u32 doorbell_pg_id)
+void mana_uncfg_vport(struct mana_port_context *apc)
+{
+	refcount_dec(&apc->port_use_count);
+}
+EXPORT_SYMBOL_GPL(mana_uncfg_vport);
+
+int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
+		   u32 doorbell_pg_id)
 {
 	struct mana_config_vport_resp resp = {};
 	struct mana_config_vport_req req = {};
 	int err;
 
+	/* Ethernet driver and IB driver can't take the port at the same time */
+	refcount_inc(&apc->port_use_count);
+	if (refcount_read(&apc->port_use_count) > 2) {
+		refcount_dec(&apc->port_use_count);
+		return -ENODEV;
+	}
+
 	mana_gd_init_req_hdr(&req.hdr, MANA_CONFIG_VPORT_TX,
 			     sizeof(req), sizeof(resp));
 	req.vport = apc->port_handle;
@@ -563,9 +576,13 @@ static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
 
 	apc->tx_shortform_allowed = resp.short_form_allowed;
 	apc->tx_vp_offset = resp.tx_vport_offset;
+
+	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
+		    apc->port_handle, protection_dom_id, doorbell_pg_id);
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(mana_cfg_vport);
 
 static int mana_cfg_vport_steering(struct mana_port_context *apc,
 				   enum TRI_STATE rx,
@@ -626,6 +643,9 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 			   resp.hdr.status);
 		err = -EPROTO;
 	}
+
+	netdev_info(ndev, "Configured steering vPort %llu entries %u\n",
+		    apc->port_handle, num_entries);
 out:
 	kfree(req);
 	return err;
@@ -1678,6 +1698,8 @@ static void mana_destroy_vport(struct mana_port_context *apc)
 	}
 
 	mana_destroy_txq(apc);
+
+	mana_uncfg_vport(apc);
 }
 
 static int mana_create_vport(struct mana_port_context *apc,
@@ -1928,6 +1950,7 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
 	apc->num_queues = gc->max_num_queues;
 	apc->port_handle = INVALID_MANA_HANDLE;
 	apc->port_idx = port_idx;
+	refcount_set(&apc->port_use_count, 1);
 
 	ndev->netdev_ops = &mana_devops;
 	ndev->ethtool_ops = &mana_ethtool_ops;
-- 
2.17.1

