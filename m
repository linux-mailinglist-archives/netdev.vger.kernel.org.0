Return-Path: <netdev+bounces-6118-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4CB8714D7F
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 17:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 59CCB1C20856
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 15:54:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22C73107A4;
	Mon, 29 May 2023 15:50:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C88107A0;
	Mon, 29 May 2023 15:50:54 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8F99C4;
	Mon, 29 May 2023 08:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685375450; x=1716911450;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AilTsEvxp/AWGPKL5B7pI6JA0eOe2QWyzInjE4LTUdk=;
  b=CNFTVkVHXZSZmaikHkS/e8Y9qG/7qDrOauGyr6NxNQaGjOPNx0muhOIe
   hqAD1THvh7Fs3bj+MmVtv2oCbvfUlTSAn5oaoP3Z26nF8k2jRwFpdHaeq
   83SRBdrCQD2nYzKaQ8j1AQ/28B0CwoLBXhf94nhqaXYEtV+GOlQjF5ivi
   ZWnBFbL5N4MFc20QWSi1a1n480aZr15ibFTTAknLGGLxjlzMO7qjZ0NOQ
   pBn7syLDe2khqNeNltpGtJvrOdfmjxIw3Sd9a9K06vfgP36+YhzkOB/5l
   THVqXXdthKeUhwiMqTrjs7ev5ESErmr0KqKkKt/yP/MZNROmuulLNsvAL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="344229009"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="344229009"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2023 08:50:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10725"; a="880441088"
X-IronPort-AV: E=Sophos;i="6.00,201,1681196400"; 
   d="scan'208";a="880441088"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga005.jf.intel.com with ESMTP; 29 May 2023 08:50:48 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 09/22] xsk: discard zero length descriptors in Tx path
Date: Mon, 29 May 2023 17:50:11 +0200
Message-Id: <20230529155024.222213-10-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
References: <20230529155024.222213-1-maciej.fijalkowski@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
2.35.3


