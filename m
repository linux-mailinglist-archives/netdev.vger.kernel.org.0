Return-Path: <netdev+bounces-3738-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B32A7708796
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:11:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6ED32281A76
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86C2B134DD;
	Thu, 18 May 2023 18:06:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACD4134A3;
	Thu, 18 May 2023 18:06:55 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B9A8F;
	Thu, 18 May 2023 11:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684433214; x=1715969214;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tgDv88hQgZCzP3VrYKShZSuN3qxZaUyFZJ4hl9hdzEo=;
  b=ZZH5i0cBmBX7wHrufJqKJHphQTEZcPdagF4U8WsEC/+lDllozSxFSvHx
   b89/Se3nTj82VktNVdXJQ7N1Z1G/3lzhCQxmVG43r8+6IgevSH2srzfSr
   8dPvlXigngfQkJpLrA/XJefEDDMsuheKaL8/IFt/78LGvbqOimBS6WS/g
   HRwtyiLES+JVIWGj35zs3P7vjtMixP25IQuHjXt+mKpCnCRIk7wZd0/p5
   vgr/nlxNMaXcf0dqOdbvK/pdovO/PxyBFtftV2fu2TCupRSbuT0qMWaRL
   aNmycoyfR9XAqbrmNjlzDxYFr0vdyy4bMRVZ54xUC0pJAbu5ICGcnz54U
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="350984990"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="350984990"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 11:06:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="948780479"
X-IronPort-AV: E=Sophos;i="6.00,174,1681196400"; 
   d="scan'208";a="948780479"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by fmsmga006.fm.intel.com with ESMTP; 18 May 2023 11:06:21 -0700
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
Subject: [PATCH bpf-next 12/21] xsk: support ZC Tx multi-buffer in batch API
Date: Thu, 18 May 2023 20:05:36 +0200
Message-Id: <20230518180545.159100-13-maciej.fijalkowski@intel.com>
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

Modify xskq_cons_read_desc_batch() in a way that each processed
descriptor will be checked if it is an EOP one or not and act
accordingly to that.

Change the behavior of mentioned function to break the processing when
stumbling upon invalid descriptor instead of skipping it. Furthermore,
let us give only full packets down to ZC driver.
With these two assumptions ZC drivers will not have to take care of an
intermediate state of incomplete frames, which will simplify its
implementations a lot.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk_queue.h | 41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index ab0d13d6d90e..a8f11a41609a 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -48,6 +48,11 @@ struct xsk_queue {
 	size_t ring_vmalloc_size;
 };
 
+struct parsed_desc {
+	u32 mb;
+	u32 valid;
+};
+
 /* The structure of the shared state of the rings are a simple
  * circular buffer, as outlined in
  * Documentation/core-api/circular-buffers.rst. For the Rx and
@@ -218,30 +223,48 @@ static inline void xskq_cons_release_n(struct xsk_queue *q, u32 cnt)
 	q->cached_cons += cnt;
 }
 
-static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
-					    u32 max)
+static inline void parse_desc(struct xsk_queue *q, struct xsk_buff_pool *pool,
+			      struct xdp_desc *desc, struct parsed_desc *parsed)
+{
+	parsed->valid = xskq_cons_is_valid_desc(q, desc, pool);
+	parsed->mb = xp_mb_desc(desc);
+}
+
+static inline
+u32 xskq_cons_read_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
+			      u32 max)
 {
 	u32 cached_cons = q->cached_cons, nb_entries = 0;
 	struct xdp_desc *descs = pool->tx_descs;
+	u32 total_descs = 0, nr_frags = 0;
 
+	/* track first entry, if stumble upon *any* invalid descriptor, rewind
+	 * current packet that consists of frags and stop the processing
+	 */
 	while (cached_cons != q->cached_prod && nb_entries < max) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
 		u32 idx = cached_cons & q->ring_mask;
+		struct parsed_desc parsed;
 
 		descs[nb_entries] = ring->desc[idx];
-		if (unlikely(!xskq_cons_is_valid_desc(q, &descs[nb_entries], pool))) {
-			/* Skip the entry */
-			cached_cons++;
-			continue;
-		}
+		cached_cons++;
+		parse_desc(q, pool, &descs[nb_entries], &parsed);
+		if (unlikely(!parsed.valid))
+			break;
 
 		nb_entries++;
-		cached_cons++;
+		if (likely(!parsed.mb)) {
+			total_descs += (nr_frags + 1);
+			nr_frags = 0;
+		} else {
+			nr_frags++;
+		}
 	}
 
+	cached_cons -= nr_frags;
 	/* Release valid plus any invalid entries */
 	xskq_cons_release_n(q, cached_cons - q->cached_cons);
-	return nb_entries;
+	return total_descs;
 }
 
 /* Functions for consumers */
-- 
2.34.1


