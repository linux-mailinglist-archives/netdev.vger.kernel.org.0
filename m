Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCDA540128
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 16:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245274AbiFGOWW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 10:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238699AbiFGOWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 10:22:21 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDD737034;
        Tue,  7 Jun 2022 07:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654611740; x=1686147740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1uENdlWbgyIkZuBUo+RfpSMI6cTOPA2zidXVukSPb6s=;
  b=h56I9pFe6sGjzTNqyczd4aOQbXgcIPKQ1Xo60N1DdFETVYlB5q2SYLUS
   IUV219RHnKpuQ9eIeUZpZH3SNoW+E9hKi3m4qa+NPiIOzcBlUv7zmmsdc
   dYXBHPmJk8BO+KCxCGr2aRZC8lgzpJYao5II/ko3wSH1FMpOGtyOnTud8
   6WV034eLTGMC64F9cVK4k79f7yl7QyvNiNO/dGh7NyVGfOe+sJhp8aQBW
   Jj/k93c8YUmFynDqlSOvfNGuri7JApIr9OihQbAE3y0NrCSx/ChC8gnGe
   B7xX1pB0OmSpV16JociGu9riBrsrU65uJRwt/xsSIKT7kVXjB4dY6zZGb
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="275498003"
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="275498003"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 07:22:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,284,1647327600"; 
   d="scan'208";a="565456527"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga002.jf.intel.com with ESMTP; 07 Jun 2022 07:22:18 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf] xsk: Fix handling of invalid descriptors in XSK Tx batching API
Date:   Tue,  7 Jun 2022 16:22:00 +0200
Message-Id: <20220607142200.576735-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xdpxceiver run on a AF_XDP ZC enabled driver revealed a problem with XSK
Tx batching API. There is a test that checks how invalid Tx descriptors
are handled by AF_XDP. Each valid descriptor is followed by invalid one
on Tx side whereas the Rx side expects only to receive a set of valid
descriptors.

In current xsk_tx_peek_release_desc_batch() function, the amount of
available descriptors is hidden inside xskq_cons_peek_desc_batch(). This
can be problematic in cases where invalid descriptors are present due to
the fact that xskq_cons_peek_desc_batch() returns only a count of valid
descriptors. This means that it is impossible to properly update XSK
ring state when calling xskq_cons_release_n().

To address this issue, pull out the contents of
xskq_cons_peek_desc_batch() so that callers (currently only
xsk_tx_peek_release_desc_batch()) will always be able to update the
state of ring properly, as total count of entries is now available and
use this value as an argument in xskq_cons_release_n(). By
doing so, xskq_cons_peek_desc_batch() can be dropped altogether.

Fixes: 9349eb3a9d2a ("xsk: Introduce batched Tx descriptor interfaces")
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 net/xdp/xsk.c       | 5 +++--
 net/xdp/xsk_queue.h | 8 --------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index e0a4526ab66b..19ac872a6624 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -373,7 +373,8 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 		goto out;
 	}
 
-	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, pool, max_entries);
+	max_entries = xskq_cons_nb_entries(xs->tx, max_entries);
+	nb_pkts = xskq_cons_read_desc_batch(xs->tx, pool, max_entries);
 	if (!nb_pkts) {
 		xs->tx->queue_empty_descs++;
 		goto out;
@@ -389,7 +390,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 	if (!nb_pkts)
 		goto out;
 
-	xskq_cons_release_n(xs->tx, nb_pkts);
+	xskq_cons_release_n(xs->tx, max_entries);
 	__xskq_cons_release(xs->tx);
 	xs->sk.sk_write_space(&xs->sk);
 
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index a794410989cc..fb20bf7207cf 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -282,14 +282,6 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 	return xskq_cons_read_desc(q, desc, pool);
 }
 
-static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
-					    u32 max)
-{
-	u32 entries = xskq_cons_nb_entries(q, max);
-
-	return xskq_cons_read_desc_batch(q, pool, entries);
-}
-
 /* To improve performance in the xskq_cons_release functions, only update local state here.
  * Reflect this to global state when we get new entries from the ring in
  * xskq_cons_get_entries() and whenever Rx or Tx processing are completed in the NAPI loop.
-- 
2.27.0

