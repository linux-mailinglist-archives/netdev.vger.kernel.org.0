Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CDC529D5A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244100AbiEQJFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235185AbiEQJEw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:04:52 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E82147063;
        Tue, 17 May 2022 02:04:48 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
        id 1511020F7224; Tue, 17 May 2022 02:04:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 1511020F7224
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
        s=default; t=1652778288;
        bh=Ssqwyn9buuJdDtO8VksCBiYTIi8iEmbq5gI64z2s+PY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:Reply-To:From;
        b=L/8+iOHGHmUS3/sbpCnwTFNk21iE2oBN/YzvRyTKlhRuoRb4NEzrU8ofUxR2swxWq
         sAeS25TLIQ0AgdFr+yyUwuZil/2HgRwEuS3/UGGtVbxnmLJdUaHFcFmCJ2LjAbdyqO
         i0Fh8Z5I5qetdcJy/8NH0B1x32GAkB3iTz2D9lpc=
From:   longli@linuxonhyperv.com
To:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>
Cc:     linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
Subject: [PATCH 03/12] net: mana: Handle vport sharing between devices
Date:   Tue, 17 May 2022 02:04:27 -0700
Message-Id: <1652778276-2986-4-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
References: <1652778276-2986-1-git-send-email-longli@linuxonhyperv.com>
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
 drivers/net/ethernet/microsoft/mana/mana.h    |  4 ++++
 drivers/net/ethernet/microsoft/mana/mana_en.c | 19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana.h b/drivers/net/ethernet/microsoft/mana/mana.h
index 51bff91b63ee..26f14fcb6a61 100644
--- a/drivers/net/ethernet/microsoft/mana/mana.h
+++ b/drivers/net/ethernet/microsoft/mana/mana.h
@@ -375,6 +375,7 @@ struct mana_port_context {
 	unsigned int num_queues;
 
 	mana_handle_t port_handle;
+	atomic_t port_use_count;
 
 	u16 port_idx;
 
@@ -567,4 +568,7 @@ struct mana_adev {
 	struct gdma_dev *mdev;
 };
 
+int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
+		   u32 doorbell_pg_id);
+void mana_uncfg_vport(struct mana_port_context *apc);
 #endif /* _MANA_H */
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index c706bf943e49..4f7a50ace9f6 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -530,13 +530,25 @@ static int mana_query_vport_cfg(struct mana_port_context *apc, u32 vport_index,
 	return 0;
 }
 
-static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
-			  u32 doorbell_pg_id)
+void mana_uncfg_vport(struct mana_port_context *apc)
+{
+	atomic_dec(&apc->port_use_count);
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
+	if (atomic_inc_return(&apc->port_use_count) != 1) {
+		atomic_dec(&apc->port_use_count);
+		return -ENODEV;
+	}
+
 	mana_gd_init_req_hdr(&req.hdr, MANA_CONFIG_VPORT_TX,
 			     sizeof(req), sizeof(resp));
 	req.vport = apc->port_handle;
@@ -566,6 +578,7 @@ static int mana_cfg_vport(struct mana_port_context *apc, u32 protection_dom_id,
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(mana_cfg_vport);
 
 static int mana_cfg_vport_steering(struct mana_port_context *apc,
 				   enum TRI_STATE rx,
@@ -1678,6 +1691,8 @@ static void mana_destroy_vport(struct mana_port_context *apc)
 	}
 
 	mana_destroy_txq(apc);
+
+	mana_uncfg_vport(apc);
 }
 
 static int mana_create_vport(struct mana_port_context *apc,
-- 
2.17.1

