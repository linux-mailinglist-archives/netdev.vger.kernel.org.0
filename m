Return-Path: <netdev+bounces-680-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 888156F8E8E
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 06:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE83B1C21A9D
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 04:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E88C185B;
	Sat,  6 May 2023 04:30:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEE97E
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 04:30:01 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B32E47DAD
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 21:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683347399; x=1714883399;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kYnoriSTSuT4AS/YHsRMbxkYam/5OI5KU4BV16/guzs=;
  b=Su5e2oSdP9t1/VLV6scggPybO0QP6ui1SPlVezcrabU2vEd+YCh0i4kT
   rEq7Zdq6BKp/fNq7HdESNriENyt5xuxuA3QbZKgKjMKTjz8yHUItAYpzl
   7DuDtXbe2+WbYmgKY+gIxwPgU9UTAMd4JaT1LyNUWY7ApV9+JB/bSY0g8
   jEC7qWHEwNcxSWIpk7rArRkTL4Rr0o3uQ1QlFipj7+vHdpSam6gpAKqCm
   O6Isml3MzbXCHaKhmMmRr66AvCHVhkI9MN0E7b5/0d1UwIoGacpLs1kzE
   WGNDNlE3FIYkK0eQ60I40aEhwqH09NIhmNCY0aT0n4L/VZGZysv+F+cyV
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="377424896"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="377424896"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 21:29:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="944157221"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="944157221"
Received: from b49691a74c54.jf.intel.com ([10.45.76.121])
  by fmsmga006.fm.intel.com with ESMTP; 05 May 2023 21:29:58 -0700
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
Subject: [PATCH 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Fri,  5 May 2023 21:29:57 -0700
Message-Id: <20230506042958.15051-2-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230506042958.15051-1-cathy.zhang@intel.com>
References: <20230506042958.15051-1-cathy.zhang@intel.com>
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
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
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
RPS (with/without patch)	+2.01x

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


