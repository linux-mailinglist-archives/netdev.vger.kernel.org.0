Return-Path: <netdev+bounces-8060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BAA47229B8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 16:49:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B66102812B8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:49:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51D872106A;
	Mon,  5 Jun 2023 14:45:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A1B21064;
	Mon,  5 Jun 2023 14:45:22 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8979D9C;
	Mon,  5 Jun 2023 07:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685976320; x=1717512320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EsUcyGLX/1e3p/Xfu/7Y1Zlz4JefwYwv/uRem1HNiiE=;
  b=Omk04OU/+85e+TJGWW1meYkitSCeV+nAw+aeeV016q/Bke3B6H8XQoAU
   IQV4nvxpaxGiw33BK1GKpIVQwxBvi/mGVAvUllxMCu0XUOhsLHlCu0doM
   dNKhJ9p4mToHEKRcGaVC4qir2ksYNGOgab54kzUq5/j9KYJYQ3xZ5vrDO
   3FuWsUihnqmFFZs6w9GEa690tpAeRLbF/sz6oIARjTHIzAsIagufJA7OW
   DqCh9lhSJenCaDZrORwKeJVjchEIKu79J7GCy/H04OpUAPBY7T4mlC8Mt
   xzqwCELFGcdsR7vn4HK0qG9EocKIP3BHlZd8EpQZ9ZrujBv+fOK+6rp8I
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="442757910"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="442757910"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 07:45:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="798464225"
X-IronPort-AV: E=Sophos;i="6.00,217,1681196400"; 
   d="scan'208";a="798464225"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2023 07:45:17 -0700
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
	simon.horman@corigine.com
Subject: [PATCH v3 bpf-next 09/22] xsk: discard zero length descriptors in Tx path
Date: Mon,  5 Jun 2023 16:44:20 +0200
Message-Id: <20230605144433.290114-10-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
References: <20230605144433.290114-1-maciej.fijalkowski@intel.com>
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


