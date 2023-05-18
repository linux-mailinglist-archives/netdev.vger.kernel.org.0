Return-Path: <netdev+bounces-3735-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C0A70878F
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 72A2E1C211AA
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A053134A7;
	Thu, 18 May 2023 18:06:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF44134A3;
	Thu, 18 May 2023 18:06:18 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00054C2;
	Thu, 18 May 2023 11:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433177; x=1715969177;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EsUcyGLX/1e3p/Xfu/7Y1Zlz4JefwYwv/uRem1HNiiE=;
  b=SN9lovzri7w6hRKyRKq83fnpVZnEQU07Tulct4aoOusHDJi4M40PVPAf
   SpIMUBAx7nMpwNCB8leoV5spFMKjZeWztUDKdi6cfwZDUX6kSiI1S1hX3
   +T1E7G/B0C9uN1+/428OcVzEsQmdXLa9vnZf+Fk+96jBabq3KTSKAn6mV
   +8VQ3QnHsVOMnCmV1l0FAEL6H8eAauEeajovfeJ5s57fb0WdHPYAOzzMt
   pGpQ8RR75LLhcUNfYrvb9Vwo6EMqXhpMD+meDzyD9XktAfdzSRzg4KRV9
   9jRyn8hVPcIh0KxUumm49c4TYdblCZcExHeTewkQzPPrlGeRYUfNZ6AnM
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350984862"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350984862"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780320"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780320"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:14 -0700
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
Subject: [PATCH bpf-next 09/21] xsk: discard zero length descriptors in Tx path
Date: Thu, 18 May 2023 20:05:33 +0200
Message-Id: <20230518180545.159100-10-maciej.fijalkowski@intel.com>
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


