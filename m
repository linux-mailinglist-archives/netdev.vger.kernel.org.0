Return-Path: <netdev+bounces-3733-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 514B270878B
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:09:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CB6C281961
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:09:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39304449C8;
	Thu, 18 May 2023 18:06:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B204449B1;
	Thu, 18 May 2023 18:06:13 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121A6F9;
	Thu, 18 May 2023 11:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433172; x=1715969172;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wMV2V2E1sFrBlyO+yBc8Em/Okxc0+BCvYpMSJeYiI1E=;
  b=F38MvkiJveQ9m6STgjlFecEBRKzj/Yva2vOgiUD8Tpj6GPwCyre0hdQu
   PbJq1QHA1DRhGQhyGfWec3GLrh3hyNiAq21g2ykCGuQ+dGvWTjtcCcztZ
   UBqbH1P8TeFcosgfWodAVHPfmunVDIZZFv2wR3ySQqSBB7wE593wpfGuD
   IcJXpszKWc14lMCCDcXW5P1X/Rpqh9udizySxNUF4PaGiNL8FkznDsKMz
   DQ6G2TXbl7R39fnjn0PPL4rDDF8nMi1WNTsdG0Dis+/xbmVcsEu36mToq
   QlTufUWlqYy7euB7tcgPV+/7/N1mqIo0Mc06jGaFSkqpws6mFnALbpeQW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350984820"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350984820"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780250"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780250"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:09 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	bjorn@kernel.org
Subject: [PATCH bpf-next 07/21] xsk: allow core/drivers to test EOP bit
Date: Thu, 18 May 2023 20:05:31 +0200
Message-Id: <20230518180545.159100-8-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Drivers are used to check for EOP bit whereas AF_XDP operates on
inverted logic - user space indicates that current frag is not the last
one and packet continues. For AF_XDP core needs, add xp_mb_desc() that
will simply test XDP_PKT_CONTD from xdp_desc::options, but in order to
preserve drivers default behavior, introduce an interface for ZC drivers
that will negate xp_mb_desc() result and therefore make it easier to
test EOP bit from during production of HW Tx descriptors.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 include/net/xdp_sock_drv.h  | 10 ++++++++++
 include/net/xsk_buff_pool.h |  5 +++++
 2 files changed, 15 insertions(+)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 9c0d860609ba..a3e18b958d93 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -89,6 +89,11 @@ static inline struct xdp_buff *xsk_buff_alloc(struct xsk_buff_pool *pool)
 	return xp_alloc(pool);
 }
 
+static inline bool xsk_is_eop_desc(struct xdp_desc *desc)
+{
+	return !xp_mb_desc(desc);
+}
+
 /* Returns as many entries as possible up to max. 0 <= N <= max. */
 static inline u32 xsk_buff_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
 {
@@ -241,6 +246,11 @@ static inline struct xdp_buff *xsk_buff_alloc(struct xsk_buff_pool *pool)
 	return NULL;
 }
 
+static inline bool xsk_is_eop_desc(struct xdp_desc *desc)
+{
+	return false;
+}
+
 static inline u32 xsk_buff_alloc_batch(struct xsk_buff_pool *pool, struct xdp_buff **xdp, u32 max)
 {
 	return 0;
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index a8d7b8a3688a..4dcca163e076 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -184,6 +184,11 @@ static inline bool xp_desc_crosses_non_contig_pg(struct xsk_buff_pool *pool,
 	       !(pool->dma_pages[addr >> PAGE_SHIFT] & XSK_NEXT_PG_CONTIG_MASK);
 }
 
+static inline bool xp_mb_desc(struct xdp_desc *desc)
+{
+	return desc->options & XDP_PKT_CONTD;
+}
+
 static inline u64 xp_aligned_extract_addr(struct xsk_buff_pool *pool, u64 addr)
 {
 	return addr & pool->chunk_mask;
-- 
2.34.1


