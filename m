Return-Path: <netdev+bounces-772-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0804E6F9D9E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 04:08:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EAC1C1C20949
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 02:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8F5125D4;
	Mon,  8 May 2023 02:08:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5E0125D1
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 02:08:03 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A979E124BE
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 19:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683511682; x=1715047682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L5KUIFPLxNLMN0p8mHK/YNfDea8mjJB/A+5Q/PFtLck=;
  b=KU/G5RdgsY18bmdrEfoBBUfbkT4UzbXtjqqkM5iTdDJCScerbrbRO3gp
   YwEEmKNi9YFhqmD+kuHqxNY90/C5QIeULkMxQCQhzBfKOspctIeDDQ+YK
   gtFB+zUuq1Yt5iQXnpLaGsc5iwW51AMOkiEGf9ODTv2/J/7IFMCeyZ81G
   HkssJa4Wt/mbnv7odh9MXaNIDwvDFLc+N45OevA5u5qXOrUIdZGz0c0Bg
   w1AqDr9nN+AEcJIPuI5HI3VrchijfTaLHBDhHRdnnFkOq1IYEasZpmQR+
   9e1M0WhAdqFIWHaM0qjmcRtxr3BDRC/b33RHk0ka5nIkwhNnP5lUROiXV
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="348362364"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="348362364"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 19:08:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="728880987"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="728880987"
Received: from b49691a74c54.jf.intel.com ([10.45.76.121])
  by orsmga008.jf.intel.com with ESMTP; 07 May 2023 19:08:01 -0700
From: Cathy Zhang <cathy.zhang@intel.com>
To: edumazet@google.com,
	davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: jesse.brandeburg@intel.com,
	suresh.srinivas@intel.com,
	tim.c.chen@intel.com,
	lizhen.you@intel.com,
	cathy.zhang@intel.com,
	eric.dumazet@gmail.com,
	netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Sun,  7 May 2023 19:08:00 -0700
Message-Id: <20230508020801.10702-2-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230508020801.10702-1-cathy.zhang@intel.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com>
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

Before commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
possible"), each TCP can forward allocate up to 2 MB of memory and
tcp_memory_allocated might hit tcp memory limitation quite soon. To
reduce the memory pressure, that commit keeps sk->sk_forward_alloc as
small as possible, which will be less than 1 page size if SO_RESERVE_MEM
is not specified.

However, with commit 4890b686f408 ("net: keep sk->sk_forward_alloc as
small as possible"), memcg charge hot paths are observed while system is
stressed with a large amount of connections. That is because
sk->sk_forward_alloc is too small and it's always less than
sk->truesize, network handlers like tcp_rcv_established() should jump to
slow path more frequently to increase sk->sk_forward_alloc. Each memory
allocation will trigger memcg charge, then perf top shows the following
contention paths on the busy system.

    16.77%  [kernel]            [k] page_counter_try_charge
    16.56%  [kernel]            [k] page_counter_cancel
    15.65%  [kernel]            [k] try_charge_memcg

In order to avoid the memcg overhead and performance penalty,
sk->sk_forward_alloc should be kept with a proper size instead of as
small as possible. Keep memory up to 64KB from reclaims when uncharging
sk_buff memory, which is closer to the maximum size of sk_buff. It will
help reduce the frequency of allocating memory during TCP connection.
The original reclaim threshold for reserved memory per-socket is 2MB, so
the extraneous memory reserved now is about 32 times less than before
commit 4890b686f408 ("net: keep sk->sk_forward_alloc as small as
possible").

Run memcached with memtier_benchamrk to verify the optimization fix. 8
server-client pairs are created with bridge network on localhost, server
and client of the same pair share 28 logical CPUs.

Results (Average for 5 run)
RPS (with/without patch)	+2.07x

Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Lizhen You <lizhen.you@intel.com>
Tested-by: Long Tao <tao.long@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Suresh Srinivas <suresh.srinivas@intel.com>
---
 include/net/sock.h | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 8b7ed7167243..6d2960479a80 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1657,12 +1657,33 @@ static inline void sk_mem_charge(struct sock *sk, int size)
 	sk->sk_forward_alloc -= size;
 }
 
+/* The following macro controls memory reclaiming in sk_mem_uncharge().
+ */
+#define SK_RECLAIM_THRESHOLD	(1 << 16)
 static inline void sk_mem_uncharge(struct sock *sk, int size)
 {
+	int reclaimable;
+
 	if (!sk_has_account(sk))
 		return;
 	sk->sk_forward_alloc += size;
-	sk_mem_reclaim(sk);
+
+	reclaimable = sk->sk_forward_alloc - sk_unused_reserved_mem(sk);
+
+	/* Reclaim memory to reduce memory pressure when multiple sockets
+	 * run in parallel. However, if we reclaim all pages and keep
+	 * sk->sk_forward_alloc as small as possible, it will cause
+	 * paths like tcp_rcv_established() going to the slow path with
+	 * much higher rate for forwarded memory expansion, which leads
+	 * to contention hot points and performance drop.
+	 *
+	 * In order to avoid the above issue, it's necessary to keep
+	 * sk->sk_forward_alloc with a proper size while doing reclaim.
+	 */
+	if (reclaimable > SK_RECLAIM_THRESHOLD) {
+		reclaimable -= SK_RECLAIM_THRESHOLD;
+		__sk_mem_reclaim(sk, reclaimable);
+	}
 }
 
 /*
-- 
2.34.1


