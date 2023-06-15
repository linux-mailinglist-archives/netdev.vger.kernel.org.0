Return-Path: <netdev+bounces-11199-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 82768731F0B
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:30:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A3A31C20F31
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA19518B0B;
	Thu, 15 Jun 2023 17:26:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBA62E0C6;
	Thu, 15 Jun 2023 17:26:56 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC632719;
	Thu, 15 Jun 2023 10:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686850002; x=1718386002;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EsUcyGLX/1e3p/Xfu/7Y1Zlz4JefwYwv/uRem1HNiiE=;
  b=Wmo9+LXssv33VsV6G9UhJG2fKdazhiEGavpKTblu7hva0PmEV5e3LMvJ
   T3YpmPQum7qBodm2Vdt0avavWpJnlD1w0pTCkKTLj2SX7giFiVf2FIs6W
   pi4A4PUN/TRwlBBNyBpanxvRK1XrbBDIdXTxJUtWypVax54l5B6PaLpFu
   d/i59kAU+le7wn40f8IYo1Aimq7nfFFppA747QRibKUiJtv/00amYbdle
   rXK/FObpUwO7bXnA6sxuEqIgEVDr6S9S4LnCNuO4FX3jPcVTovEBMZ381
   rbCSzHWxR0xnvRD0kXhbUNkH5KZAabkI5UdPzdL4Ys0c/8iXzDXhCh6RU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358983540"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="358983540"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:26:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="689858617"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="689858617"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 15 Jun 2023 10:26:39 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	simon.horman@corigine.com,
	toke@kernel.org
Subject: [PATCH v4 bpf-next 09/22] xsk: discard zero length descriptors in Tx path
Date: Thu, 15 Jun 2023 19:25:53 +0200
Message-Id: <20230615172606.349557-10-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230615172606.349557-1-maciej.fijalkowski@intel.com>
References: <20230615172606.349557-1-maciej.fijalkowski@intel.com>
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

From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>

Descriptors with zero length are not supported by many NICs. To preserve
uniform behavior discard any zero length desc as invvalid desc.

Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk_queue.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index 2d2af9fc2744..ab0d13d6d90e 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -140,6 +140,9 @@ static inline bool xp_aligned_validate_desc(struct xsk_buff_pool *pool,
 {
 	u64 offset = desc->addr & (pool->chunk_size - 1);
 
+	if (!desc->len)
+		return false;
+
 	if (offset + desc->len > pool->chunk_size)
 		return false;
 
@@ -156,6 +159,9 @@ static inline bool xp_unaligned_validate_desc(struct xsk_buff_pool *pool,
 {
 	u64 addr = xp_unaligned_add_offset_to_addr(desc->addr);
 
+	if (!desc->len)
+		return false;
+
 	if (desc->len > pool->chunk_size)
 		return false;
 
-- 
2.34.1


