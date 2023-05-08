Return-Path: <netdev+bounces-773-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 473136F9D9F
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 04:08:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 678361C2092D
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 02:08:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B39A125DF;
	Mon,  8 May 2023 02:08:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBF2125DB
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 02:08:04 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30B512E8E
	for <netdev@vger.kernel.org>; Sun,  7 May 2023 19:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683511682; x=1715047682;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mFaatJLpJq7HHZ2p1l/gRBk3sanArxaIGY5X+yudg4I=;
  b=n8zw3IIpDek0xuLO14KLu5Zc55MrmbQQRoe/4JvuqYIDQCMM/t+ZcQbE
   RHIeW+I7GpFVP+jDguIsT/TxDft8w9RAEixNAHDkOpZRiX4GayZe1KsHf
   GwPCGb3WBl1QHVH6IZrg1wonFR30WRKSaXO77+pxa97VurYOdcZiqKi3U
   +qsPLTU9/zgI1P3A6amUGQvUvsmT2/eEjXC9fZnCdEecmR9UKSs4/cp4i
   reMdFcpTUwPYyiaxZZEispSlbHqHsQ5m+hZzioe5eKRxWhLDOMJY7+zeO
   s4MzlR2aXuI726HGudshe3RvZIpJPTIuoTshEPRXP/viCpozOBkuOhAzB
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="348362370"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="348362370"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2023 19:08:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10703"; a="728880990"
X-IronPort-AV: E=Sophos;i="5.99,258,1677571200"; 
   d="scan'208";a="728880990"
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
Subject: [PATCH net-next 2/2] net: Add sysctl_reclaim_threshold
Date: Sun,  7 May 2023 19:08:01 -0700
Message-Id: <20230508020801.10702-3-cathy.zhang@intel.com>
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
 include/net/sock.h                       | 13 +++++++++++--
 net/core/sysctl_net_core.c               | 14 ++++++++++++++
 3 files changed, 37 insertions(+), 2 deletions(-)

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
index 6d2960479a80..3ca4c03a23ba 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -89,6 +89,10 @@ void SOCK_DEBUG(const struct sock *sk, const char *msg, ...)
 }
 #endif
 
+#if IS_ENABLED(CONFIG_SYSCTL)
+extern unsigned int sysctl_reclaim_threshold __read_mostly;
+#endif
+
 /* This is the per-socket lock.  The spinlock provides a synchronization
  * between user contexts and software interrupt processing, whereas the
  * mini-semaphore synchronizes multiple users amongst themselves.
@@ -1663,6 +1667,11 @@ static inline void sk_mem_charge(struct sock *sk, int size)
 static inline void sk_mem_uncharge(struct sock *sk, int size)
 {
 	int reclaimable;
+#if IS_ENABLED(CONFIG_SYSCTL)
+	int reclaim_threshold = READ_ONCE(sysctl_reclaim_threshold);
+#else
+	int reclaim_threshold = SK_RECLAIM_THRESHOLD;
+#endif
 
 	if (!sk_has_account(sk))
 		return;
@@ -1680,8 +1689,8 @@ static inline void sk_mem_uncharge(struct sock *sk, int size)
 	 * In order to avoid the above issue, it's necessary to keep
 	 * sk->sk_forward_alloc with a proper size while doing reclaim.
 	 */
-	if (reclaimable > SK_RECLAIM_THRESHOLD) {
-		reclaimable -= SK_RECLAIM_THRESHOLD;
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


