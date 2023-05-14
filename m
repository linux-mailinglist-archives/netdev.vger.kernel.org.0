Return-Path: <netdev+bounces-2405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54E56701BEB
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 08:18:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10DCD1C20A6E
	for <lists+netdev@lfdr.de>; Sun, 14 May 2023 06:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB90B1876;
	Sun, 14 May 2023 06:18:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C992B186D
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 06:18:32 +0000 (UTC)
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CB2C1FC0;
	Sat, 13 May 2023 23:18:31 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1004)
	id 7B06E20EB22D; Sat, 13 May 2023 23:18:28 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7B06E20EB22D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxonhyperv.com;
	s=default; t=1684045108;
	bh=mkDSgMixtmxFXZXt8h2/2gvZqMCg8aIpGWf4AZFjQjw=;
	h=From:To:Cc:Subject:Date:From;
	b=o3tQbgag6GQZOid6zYnnPELIjRY/dITiZBdzdIRYYIK+RMpGY7myQnUVzTUY1srOJ
	 T93Js7yLO7FYg4tJmMkz03daMN/OAJIKsxVoyE6e+rYNnIHu5CPhDSFER+uAWOtjl8
	 tbFBzDCYUH4kuO01D69S24hKIQxAZYHgbpD29o30=
From: longli@linuxonhyperv.com
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Ajay Sharma <sharmaajay@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-rdma@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Long Li <longli@microsoft.com>
Subject: [PATCH v2] RDMA/mana_ib: Use v2 version of cfg_rx_steer_req to enable RX coalescing
Date: Sat, 13 May 2023 23:18:15 -0700
Message-Id: <1684045095-31228-1-git-send-email-longli@linuxonhyperv.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-11.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

From: Long Li <longli@microsoft.com>

With RX coalescing, one CQE entry can be used to indicate multiple packets
on the receive queue. This saves processing time and PCI bandwidth over
the CQ.

The MANA Ethernet driver also uses the v2 version of the protocol. It
doesn't use RX coalescing and its behavior is not changed.

Signed-off-by: Long Li <longli@microsoft.com>
---

Change log
v2: remove the definition of v1 protocol

 drivers/infiniband/hw/mana/qp.c               | 5 ++++-
 drivers/net/ethernet/microsoft/mana/mana_en.c | 5 ++++-
 include/net/mana/mana.h                       | 4 +++-
 3 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 54b61930a7fd..4b3b5b274e84 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -13,7 +13,7 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 				      u8 *rx_hash_key)
 {
 	struct mana_port_context *mpc = netdev_priv(ndev);
-	struct mana_cfg_rx_steer_req *req = NULL;
+	struct mana_cfg_rx_steer_req_v2 *req;
 	struct mana_cfg_rx_steer_resp resp = {};
 	mana_handle_t *req_indir_tab;
 	struct gdma_context *gc;
@@ -33,6 +33,8 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX, req_buf_size,
 			     sizeof(resp));
 
+	req->hdr.req.msg_version = GDMA_MESSAGE_V2;
+
 	req->vport = mpc->port_handle;
 	req->rx_enable = 1;
 	req->update_default_rxobj = 1;
@@ -46,6 +48,7 @@ static int mana_ib_cfg_vport_steering(struct mana_ib_dev *dev,
 	req->num_indir_entries = MANA_INDIRECT_TABLE_SIZE;
 	req->indir_tab_offset = sizeof(*req);
 	req->update_indir_tab = true;
+	req->cqe_coalescing_enable = 1;
 
 	req_indir_tab = (mana_handle_t *)(req + 1);
 	/* The ind table passed to the hardware must have
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 06d6292e09b3..b3fcb767b9ab 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -972,7 +972,7 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 				   bool update_tab)
 {
 	u16 num_entries = MANA_INDIRECT_TABLE_SIZE;
-	struct mana_cfg_rx_steer_req *req = NULL;
+	struct mana_cfg_rx_steer_req_v2 *req;
 	struct mana_cfg_rx_steer_resp resp = {};
 	struct net_device *ndev = apc->ndev;
 	mana_handle_t *req_indir_tab;
@@ -987,6 +987,8 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 	mana_gd_init_req_hdr(&req->hdr, MANA_CONFIG_VPORT_RX, req_buf_size,
 			     sizeof(resp));
 
+	req->hdr.req.msg_version = GDMA_MESSAGE_V2;
+
 	req->vport = apc->port_handle;
 	req->num_indir_entries = num_entries;
 	req->indir_tab_offset = sizeof(*req);
@@ -996,6 +998,7 @@ static int mana_cfg_vport_steering(struct mana_port_context *apc,
 	req->update_hashkey = update_key;
 	req->update_indir_tab = update_tab;
 	req->default_rxobj = apc->default_rxobj;
+	req->cqe_coalescing_enable = 0;
 
 	if (update_key)
 		memcpy(&req->hashkey, apc->hashkey, MANA_HASH_KEY_SIZE);
diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
index cd386aa7c7cc..1512bd48df81 100644
--- a/include/net/mana/mana.h
+++ b/include/net/mana/mana.h
@@ -581,7 +581,7 @@ struct mana_fence_rq_resp {
 }; /* HW DATA */
 
 /* Configure vPort Rx Steering */
-struct mana_cfg_rx_steer_req {
+struct mana_cfg_rx_steer_req_v2 {
 	struct gdma_req_hdr hdr;
 	mana_handle_t vport;
 	u16 num_indir_entries;
@@ -594,6 +594,8 @@ struct mana_cfg_rx_steer_req {
 	u8 reserved;
 	mana_handle_t default_rxobj;
 	u8 hashkey[MANA_HASH_KEY_SIZE];
+	u8 cqe_coalescing_enable;
+	u8 reserved2[7];
 }; /* HW DATA */
 
 struct mana_cfg_rx_steer_resp {
-- 
2.34.1


