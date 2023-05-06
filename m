Return-Path: <netdev+bounces-681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F366F8E8F
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 06:30:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9CF5528118C
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 04:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1608E1FB6;
	Sat,  6 May 2023 04:30:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B091C20
	for <netdev@vger.kernel.org>; Sat,  6 May 2023 04:30:01 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A333E7DA7
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 21:30:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683347400; x=1714883400;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JI/w9/igqNLjeH4DKtcFcwgaGApfwXUd64SikLBAfow=;
  b=Mco6/VPIS6wB0N1fPtuDPUD49xBan3cxgdAto6eXiivB73zk7ECRZb6W
   o3nfattRRjsMPKFlaPtFJOZSOD5RfPt9b5FynDS1sfTjUmNp1rZQ8AMzM
   Y86O7ETMS5N/tVM52w81Bt0FFlvvrm4GNdaHu0jWw+5M8cZIcXW7lj+ZC
   qXtcTybXAKGu4e1dH/wsxCUsx9ST8R6oAPQ9lEoR2o0tTx6BzKEbcXm4R
   eNzgRstrEGlWCZ9oS9UOgsa7e48FMPRdILCiOvtoC46PPVKO0u9ldd6u3
   wgptytOfJfkS/8IHZXlCDAtK4M1kfoUun5idQCCnU3QVvZtG25w/0inuU
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="377424902"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="377424902"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2023 21:29:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10701"; a="944157224"
X-IronPort-AV: E=Sophos;i="5.99,254,1677571200"; 
   d="scan'208";a="944157224"
Received: from b49691a74c54.jf.intel.com ([10.45.76.121])
  by fmsmga006.fm.intel.com with ESMTP; 05 May 2023 21:29:59 -0700
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
Subject: [PATCH 2/2] net: Add sysctl_reclaim_threshold
Date: Fri,  5 May 2023 21:29:58 -0700
Message-Id: <20230506042958.15051-3-cathy.zhang@intel.com>
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

Add a new ABI /proc/sys/net/core/reclaim_threshold which allows to
change the size of reserved memory from reclaiming in sk_mem_uncharge.
It allows to keep sk->sk_forward_alloc as small as possible when
system is under memory pressure, it also allows to change it larger to
avoid memcg charge overhead and improve performance when system is not
under memory pressure. The original reclaim threshold for reserved
memory per-socket is 2MB, it's selected as the max value, while the
default value is 64KB which is closer to the maximum size of sk_buff.

Issue the following command as root to change the default value:

	echo 16384 > /proc/sys/net/core/reclaim_threshold

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Lizhen You <lizhen.you@intel.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: Suresh Srinivas <suresh.srinivas@intel.com>
---
 Documentation/admin-guide/sysctl/net.rst | 12 ++++++++++++
 include/net/sock.h                       | 11 ++++++-----
 net/core/sysctl_net_core.c               | 14 ++++++++++++++
 3 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 466c560b0c30..2981278af3d9 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -413,6 +413,18 @@ historical importance.
 
 Default: 0
 
+reclaim_threshold
+------------------------
+
+The threshold indicates when it can start to reclaim memory during a TCP
+connection lifecycle. If the per-socket forward allocated memory is beyond the
+threshold, it will reclaim the part exceeding this value. It could help keep
+per-socket forward allocated memory with a proper size to improve performance
+and make system away from memory pressure meanwhile. The threshold value is
+allowed to be changed in [4096, 2097152].
+
+Default: 64 KB
+
 2. /proc/sys/net/unix - Parameters for Unix domain sockets
 ----------------------------------------------------------
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 6d2960479a80..bd8162ed2056 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -89,6 +89,8 @@ void SOCK_DEBUG(const struct sock *sk, const char *msg, ...)
 }
 #endif
 
+extern unsigned int sysctl_reclaim_threshold __read_mostly;
+
 /* This is the per-socket lock.  The spinlock provides a synchronization
  * between user contexts and software interrupt processing, whereas the
  * mini-semaphore synchronizes multiple users amongst themselves.
@@ -1657,12 +1659,10 @@ static inline void sk_mem_charge(struct sock *sk, int size)
 	sk->sk_forward_alloc -= size;
 }
 
-/* The following macro controls memory reclaiming in sk_mem_uncharge().
- */
-#define SK_RECLAIM_THRESHOLD	(1 << 16)
 static inline void sk_mem_uncharge(struct sock *sk, int size)
 {
 	int reclaimable;
+	int reclaim_threshold;
 
 	if (!sk_has_account(sk))
 		return;
@@ -1680,8 +1680,9 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 	 * In order to avoid the above issue, it's necessary to keep
 	 * sk->sk_forward_alloc with a proper size while doing reclaim.
 	 */
-	if (reclaimable > SK_RECLAIM_THRESHOLD) {
-		reclaimable -= SK_RECLAIM_THRESHOLD;
+	reclaim_threshold = READ_ONCE(sysctl_reclaim_threshold);
+	if (reclaimable > reclaim_threshold) {
+		reclaimable -= reclaim_threshold;
 		__sk_mem_reclaim(sk, reclaimable);
 	}
 }
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 782273bb93c2..82aee37769ba 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -46,6 +46,11 @@ EXPORT_SYMBOL(sysctl_fb_tunnels_only_for_init_net);
 int sysctl_devconf_inherit_init_net __read_mostly;
 EXPORT_SYMBOL(sysctl_devconf_inherit_init_net);
 
+static unsigned int min_reclaim = PAGE_SIZE;
+static unsigned int max_reclaim = 2 * 1024 * 1024;
+unsigned int sysctl_reclaim_threshold __read_mostly = 64 * 1024;
+EXPORT_SYMBOL(sysctl_reclaim_threshold);
+
 #if IS_ENABLED(CONFIG_NET_FLOW_LIMIT) || IS_ENABLED(CONFIG_RPS)
 static void dump_cpumask(void *buffer, size_t *lenp, loff_t *ppos,
 			 struct cpumask *mask)
@@ -407,6 +412,15 @@ static struct ctl_table net_core_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= &min_rcvbuf,
 	},
+	{
+		.procname	= "reclaim_threshold",
+		.data		= &sysctl_reclaim_threshold,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_douintvec_minmax,
+		.extra1		= &min_reclaim,
+		.extra2		= &max_reclaim,
+	},
 	{
 		.procname	= "dev_weight",
 		.data		= &weight_p,
-- 
2.34.1


