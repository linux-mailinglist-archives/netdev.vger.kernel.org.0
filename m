Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324AD54D7DE
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 04:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358182AbiFPCHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 22:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348213AbiFPCHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 22:07:37 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 86C9BFC3;
        Wed, 15 Jun 2022 19:07:30 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 5ABA520C327C; Wed, 15 Jun 2022 19:07:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5ABA520C327C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1655345250;
        bh=6JaEm1a6tNhVzT6xGRcitQHJYk7ChgQN72DXm0YtbbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=Jx5UdVfQJKpe+FxNgQDTNx/0jCDaseIf4tI0Gg3G/XDf6hUFs4nPQRKXvTkicNPjG
         VEaczPPSZ9q9dNm81+30eUOmdN4GfYBNxPc88I80DEIsRKNhmHNXqWRNcVWTvIH1gH
         Bq4iM2gVupCYnIf50F3rrS+CmUjgZXptM3rojd3A=
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
Subject: [Patch v4 03/12] net: mana: Handle vport sharing between devices
Date:   Wed, 15 Jun 2022 19:07:11 -0700
Message-Id: <1655345240-26411-4-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
References: <1655345240-26411-1-git-send-email-longli@linuxonhyperv.com>
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
v4: change to mutex to avoid possible race with refcount

 drivers/net/ethernet/microsoft/mana/mana.h    |  7 ++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 40 ++++++++++++++++++-
 2 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 51bff91b63ee..8e58abdce906 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -376,6 +376,10 @@ struct mana_port_context {
 
 	mana_handle_t port_handle;
 
+	/* Mutex for sharing access to vport_use_count */
+	struct mutex vport_mutex;
+	int vport_use_count;
+
 	u16 port_idx;
 
 	bool port_is_up;
@@ -567,4 +571,7 @@ struct mana_adev {
 	struct gdma_dev *mdev;
 };
 
+int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
+		   u32 doorbell_pg_id);
+void mana_uncfg_vport(struct mana_port_context *apc);
 #endif /* _MANA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 745a9783dd70..23e7e423a544 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -530,13 +530,31 @@ static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_index,
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
+EXPORT_SYMBOL_GPL(mana_uncfg_vport);
+
+int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
+		   u32 doorbell_pg_id)
 {
 	struct mana_config_vport_resp resp = {};
 	struct mana_config_vport_req req = {};
 	int err;
 
+	/* Ethernet driver and IB driver can't take the port at the same time */
+	mutex_lock(&apc->vport_mutex);
+	if (apc->vport_use_count > 0) {
+		mutex_unlock(&apc->vport_mutex);
+		return -ENODEV;
+	}
+	apc->vport_use_count++;
+	mutex_unlock(&apc->vport_mutex);
+
 	mana_gd_init_req_hdr(&req.hdr, MANA_CONFIG_VPORT_TX,
 			     sizeof(req), sizeof(resp));
 	req.vport = apc->port_handle;
@@ -563,9 +581,19 @@ static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
 
 	apc->tx_shortform_allowed = resp.short_form_allowed;
 	apc->tx_vp_offset = resp.tx_vport_offset;
+
+	netdev_info(apc->ndev, "Configured vPort %llu PD %u DB %u\n",
+		    apc->port_handle, protection_dom_id, doorbell_pg_id);
 out:
+	if (err) {
+		mutex_lock(&apc->vport_mutex);
+		apc->vport_use_count--;
+		mutex_unlock(&apc->vport_mutex);
+	}
+
 	return err;
 }
+EXPORT_SYMBOL_GPL(mana_cfg_vport);
 
 static int mana_cfg_vport_steering(struct mana_port_context *apc,
 				   enum TRI_STATE rx,
@@ -626,6 +654,9 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 			   resp.hdr.status);
 		err = -EPROTO;
 	}
+
+	netdev_info(ndev, "Configured steering vPort %llu entries %u\n",
+		    apc->port_handle, num_entries);
 out:
 	kfree(req);
 	return err;
@@ -1678,6 +1709,8 @@ static void mana_destroy_vport(struct mana_port_context *apc)
 	}
 
 	mana_destroy_txq(apc);
+
+	mana_uncfg_vport(apc);
 }
 
 static int mana_create_vport(struct mana_port_context *apc,
@@ -1929,6 +1962,9 @@ static int mana_probe_port(struct mana_context *ac, int port_idx,
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

