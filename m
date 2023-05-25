Return-Path: <netdev+bounces-5328-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02DF2710CED
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 15:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA05D1C20F39
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 13:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767A0156F5;
	Thu, 25 May 2023 13:00:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64517156D1
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 13:00:30 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073A0E71;
	Thu, 25 May 2023 06:00:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685019620; x=1716555620;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8rv9nlvNwZI0m5eeZfeqrro4xCO6aRYBd1RceFAklCo=;
  b=ANQPDmw1CRzsr0S5nRkH/wfpSF7eeF25PoUQQE+kNeBksvpVXgpWFpnE
   fnmoigtKNDv+qNF+xgCeH71ECXcvfDCKxCxdSUAfVSJWuKJ6hsmDLcdm+
   9EpPnFeDs2OXhwuN3mUrxETYcHtiYcFOMdU/c7JOENzEQmjYGt9A5NxaF
   IGUIo5eED1Kyd16CxHDbfR5ra3vJCqBitcSFLGNtDG5gMng6IprS7L2kD
   6ss+5O7tM4ct2Q3fG4B70cUZm8sEb7KORBK3+ovwWtnQT9jpW+CRxiV0B
   LRVUF9u/Ha6BIT2sWMnEZRGloDFY0BIGtmGC/XzV14rbx2NCNfPxqAD5J
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351384460"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="351384460"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 05:59:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="817075192"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="817075192"
Received: from newjersey.igk.intel.com ([10.102.20.203])
  by fmsmga002.fm.intel.com with ESMTP; 25 May 2023 05:59:08 -0700
From: Alexander Lobakin <aleksander.lobakin@intel.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Alexander Lobakin <aleksander.lobakin@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Christoph Hellwig <hch@lst.de>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	netdev@vger.kernel.org,
	intel-wired-lan@lists.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 10/12] libie: add common queue stats
Date: Thu, 25 May 2023 14:57:44 +0200
Message-Id: <20230525125746.553874-11-aleksander.lobakin@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525125746.553874-1-aleksander.lobakin@intel.com>
References: <20230525125746.553874-1-aleksander.lobakin@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Next stop, per-queue private stats. They have only subtle differences
from driver to driver and can easily be resolved.
Define common structures, inline helpers and Ethtool helpers to collect,
update and export the statistics. Use u64_stats_t right from the start,
as well as the corresponding helpers to ensure tear-free operations.
For the NAPI parts of both Rx and Tx, also define small onstack
containers to update them in polling loops and then sync the actual
containers once a loop ends.
The drivers will be switched to use this API later on a per-driver
basis, along with conversion to PP.

Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
---
 drivers/net/ethernet/intel/libie/Makefile |   1 +
 drivers/net/ethernet/intel/libie/stats.c  | 119 ++++++++++++++
 include/linux/net/intel/libie/stats.h     | 179 ++++++++++++++++++++++
 3 files changed, 299 insertions(+)
 create mode 100644 drivers/net/ethernet/intel/libie/stats.c
 create mode 100644 include/linux/net/intel/libie/stats.h

diff --git a/drivers/net/ethernet/intel/libie/Makefile b/drivers/net/ethernet/intel/libie/Makefile
index 95e81d09b474..76f32253481b 100644
--- a/drivers/net/ethernet/intel/libie/Makefile
+++ b/drivers/net/ethernet/intel/libie/Makefile
@@ -4,3 +4,4 @@
 obj-$(CONFIG_LIBIE)	+= libie.o
 
 libie-objs		+= rx.o
+libie-objs		+= stats.o
diff --git a/drivers/net/ethernet/intel/libie/stats.c b/drivers/net/ethernet/intel/libie/stats.c
new file mode 100644
index 000000000000..61456842a362
--- /dev/null
+++ b/drivers/net/ethernet/intel/libie/stats.c
@@ -0,0 +1,119 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation. */
+
+#include <linux/ethtool.h>
+#include <linux/net/intel/libie/stats.h>
+
+/* Rx per-queue stats */
+
+static const char * const libie_rq_stats_str[] = {
+#define act(s)	__stringify(s),
+	DECLARE_LIBIE_RQ_STATS(act)
+#undef act
+};
+
+#define LIBIE_RQ_STATS_NUM	ARRAY_SIZE(libie_rq_stats_str)
+
+/**
+ * libie_rq_stats_get_sset_count - get the number of Ethtool RQ stats provided
+ *
+ * Returns the number of per-queue Rx stats supported by the library.
+ */
+u32 libie_rq_stats_get_sset_count(void)
+{
+	return LIBIE_RQ_STATS_NUM;
+}
+EXPORT_SYMBOL_NS_GPL(libie_rq_stats_get_sset_count, LIBIE);
+
+/**
+ * libie_rq_stats_get_strings - get the name strings of Ethtool RQ stats
+ * @data: reference to the cursor pointing to the output buffer
+ * @qid: RQ number to print in the prefix
+ */
+void libie_rq_stats_get_strings(u8 **data, u32 qid)
+{
+	for (u32 i = 0; i < LIBIE_RQ_STATS_NUM; i++)
+		ethtool_sprintf(data, "rq%u_%s", qid, libie_rq_stats_str[i]);
+}
+EXPORT_SYMBOL_NS_GPL(libie_rq_stats_get_strings, LIBIE);
+
+/**
+ * libie_rq_stats_get_data - get the RQ stats in Ethtool format
+ * @data: reference to the cursor pointing to the output array
+ * @stats: RQ stats container from the queue
+ */
+void libie_rq_stats_get_data(u64 **data, const struct libie_rq_stats *stats)
+{
+	u64 sarr[LIBIE_RQ_STATS_NUM];
+	u32 start;
+
+	do {
+		start = u64_stats_fetch_begin(&stats->syncp);
+
+		for (u32 i = 0; i < LIBIE_RQ_STATS_NUM; i++)
+			sarr[i] = u64_stats_read(&stats->raw[i]);
+	} while (u64_stats_fetch_retry(&stats->syncp, start));
+
+	for (u32 i = 0; i < LIBIE_RQ_STATS_NUM; i++)
+		(*data)[i] += sarr[i];
+
+	*data += LIBIE_RQ_STATS_NUM;
+}
+EXPORT_SYMBOL_NS_GPL(libie_rq_stats_get_data, LIBIE);
+
+/* Tx per-queue stats */
+
+static const char * const libie_sq_stats_str[] = {
+#define act(s)	__stringify(s),
+	DECLARE_LIBIE_SQ_STATS(act)
+#undef act
+};
+
+#define LIBIE_SQ_STATS_NUM	ARRAY_SIZE(libie_sq_stats_str)
+
+/**
+ * libie_sq_stats_get_sset_count - get the number of Ethtool SQ stats provided
+ *
+ * Returns the number of per-queue Tx stats supported by the library.
+ */
+u32 libie_sq_stats_get_sset_count(void)
+{
+	return LIBIE_SQ_STATS_NUM;
+}
+EXPORT_SYMBOL_NS_GPL(libie_sq_stats_get_sset_count, LIBIE);
+
+/**
+ * libie_sq_stats_get_strings - get the name strings of Ethtool SQ stats
+ * @data: reference to the cursor pointing to the output buffer
+ * @qid: SQ number to print in the prefix
+ */
+void libie_sq_stats_get_strings(u8 **data, u32 qid)
+{
+	for (u32 i = 0; i < LIBIE_SQ_STATS_NUM; i++)
+		ethtool_sprintf(data, "sq%u_%s", qid, libie_sq_stats_str[i]);
+}
+EXPORT_SYMBOL_NS_GPL(libie_sq_stats_get_strings, LIBIE);
+
+/**
+ * libie_sq_stats_get_data - get the SQ stats in Ethtool format
+ * @data: reference to the cursor pointing to the output array
+ * @stats: SQ stats container from the queue
+ */
+void libie_sq_stats_get_data(u64 **data, const struct libie_sq_stats *stats)
+{
+	u64 sarr[LIBIE_SQ_STATS_NUM];
+	u32 start;
+
+	do {
+		start = u64_stats_fetch_begin(&stats->syncp);
+
+		for (u32 i = 0; i < LIBIE_SQ_STATS_NUM; i++)
+			sarr[i] = u64_stats_read(&stats->raw[i]);
+	} while (u64_stats_fetch_retry(&stats->syncp, start));
+
+	for (u32 i = 0; i < LIBIE_SQ_STATS_NUM; i++)
+		(*data)[i] += sarr[i];
+
+	*data += LIBIE_SQ_STATS_NUM;
+}
+EXPORT_SYMBOL_NS_GPL(libie_sq_stats_get_data, LIBIE);
diff --git a/include/linux/net/intel/libie/stats.h b/include/linux/net/intel/libie/stats.h
new file mode 100644
index 000000000000..dbbc98bbd3a7
--- /dev/null
+++ b/include/linux/net/intel/libie/stats.h
@@ -0,0 +1,179 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation. */
+
+#ifndef __LIBIE_STATS_H
+#define __LIBIE_STATS_H
+
+#include <linux/u64_stats_sync.h>
+
+/* Common */
+
+/* Use 32-byte alignment to reduce false sharing */
+#define __libie_stats_aligned	__aligned(4 * sizeof(u64_stats_t))
+
+/**
+ * libie_stats_add - update one structure counter from a local struct
+ * @qs: queue stats structure to update (&libie_rq_stats or &libie_sq_stats)
+ * @ss: local/onstack stats structure
+ * @f: name of the field to update
+ *
+ * If a local/onstack stats structure is used to collect statistics during
+ * hotpath loops, this macro can be used to shorthand updates, given that
+ * the fields have the same name.
+ * Must be guarded with u64_stats_update_{begin,end}().
+ */
+#define libie_stats_add(qs, ss, f)			\
+	u64_stats_add(&(qs)->f, (ss)->f)
+
+/**
+ * __libie_stats_inc_one - safely increment one stats structure counter
+ * @s: queue stats structure to update (&libie_rq_stats or &libie_sq_stats)
+ * @f: name of the field to increment
+ * @n: name of the temporary variable, result of __UNIQUE_ID()
+ *
+ * To be used on exception or slow paths -- allocation fails, queue stops etc.
+ */
+#define __libie_stats_inc_one(s, f, n) ({		\
+	typeof(*(s)) *n = (s);				\
+							\
+	u64_stats_update_begin(&n->syncp);		\
+	u64_stats_inc(&n->f);				\
+	u64_stats_update_end(&n->syncp);		\
+})
+#define libie_stats_inc_one(s, f)			\
+	__libie_stats_inc_one(s, f, __UNIQUE_ID(qs_))
+
+/* Rx per-queue stats:
+ * packets: packets received on this queue
+ * bytes: bytes received on this queue
+ * fragments: number of processed descriptors carrying only a fragment
+ * alloc_page_fail: number of Rx page allocation fails
+ * build_skb_fail: number of build_skb() fails
+ */
+
+#define DECLARE_LIBIE_RQ_NAPI_STATS(act)		\
+	act(packets)					\
+	act(bytes)					\
+	act(fragments)
+
+#define DECLARE_LIBIE_RQ_FAIL_STATS(act)		\
+	act(alloc_page_fail)				\
+	act(build_skb_fail)
+
+#define DECLARE_LIBIE_RQ_STATS(act)			\
+	DECLARE_LIBIE_RQ_NAPI_STATS(act)		\
+	DECLARE_LIBIE_RQ_FAIL_STATS(act)
+
+struct libie_rq_stats {
+	struct u64_stats_sync	syncp;
+
+	union {
+		struct {
+#define act(s)	u64_stats_t	s;
+			DECLARE_LIBIE_RQ_NAPI_STATS(act);
+			DECLARE_LIBIE_RQ_FAIL_STATS(act);
+#undef act
+		};
+		DECLARE_FLEX_ARRAY(u64_stats_t, raw);
+	};
+} __libie_stats_aligned;
+
+/* Rx stats being modified frequently during the NAPI polling, to sync them
+ * with the queue stats once after the loop is finished.
+ */
+struct libie_rq_onstack_stats {
+	union {
+		struct {
+#define act(s)	u32		s;
+			DECLARE_LIBIE_RQ_NAPI_STATS(act);
+#undef act
+		};
+		DECLARE_FLEX_ARRAY(u32, raw);
+	};
+};
+
+/**
+ * libie_rq_napi_stats_add - add onstack Rx stats to the queue container
+ * @qs: Rx queue stats structure to update
+ * @ss: onstack structure to get the values from, updated during the NAPI loop
+ */
+static inline void
+libie_rq_napi_stats_add(struct libie_rq_stats *qs,
+			const struct libie_rq_onstack_stats *ss)
+{
+	u64_stats_update_begin(&qs->syncp);
+	libie_stats_add(qs, ss, packets);
+	libie_stats_add(qs, ss, bytes);
+	libie_stats_add(qs, ss, fragments);
+	u64_stats_update_end(&qs->syncp);
+}
+
+u32 libie_rq_stats_get_sset_count(void);
+void libie_rq_stats_get_strings(u8 **data, u32 qid);
+void libie_rq_stats_get_data(u64 **data, const struct libie_rq_stats *stats);
+
+/* Tx per-queue stats:
+ * packets: packets sent from this queue
+ * bytes: bytes sent from this queue
+ * busy: number of xmit failures due to the ring being full
+ * stops: number times the ring was stopped from the driver
+ * restarts: number times it was started after being stopped
+ * linearized: number of skbs linearized due to HW limits
+ */
+
+#define DECLARE_LIBIE_SQ_NAPI_STATS(act)		\
+	act(packets)					\
+	act(bytes)
+
+#define DECLARE_LIBIE_SQ_XMIT_STATS(act)		\
+	act(busy)					\
+	act(stops)					\
+	act(restarts)					\
+	act(linearized)
+
+#define DECLARE_LIBIE_SQ_STATS(act)			\
+	DECLARE_LIBIE_SQ_NAPI_STATS(act)		\
+	DECLARE_LIBIE_SQ_XMIT_STATS(act)
+
+struct libie_sq_stats {
+	struct u64_stats_sync	syncp;
+
+	union {
+		struct {
+#define act(s)	u64_stats_t	s;
+			DECLARE_LIBIE_SQ_STATS(act);
+#undef act
+		};
+		DECLARE_FLEX_ARRAY(u64_stats_t, raw);
+	};
+} __libie_stats_aligned;
+
+struct libie_sq_onstack_stats {
+#define act(s)	u32		s;
+	DECLARE_LIBIE_SQ_NAPI_STATS(act);
+#undef act
+};
+
+/**
+ * libie_sq_napi_stats_add - add onstack Tx stats to the queue container
+ * @qs: Tx queue stats structure to update
+ * @ss: onstack structure to get the values from, updated during the NAPI loop
+ */
+static inline void
+libie_sq_napi_stats_add(struct libie_sq_stats *qs,
+			const struct libie_sq_onstack_stats *ss)
+{
+	if (unlikely(!ss->packets))
+		return;
+
+	u64_stats_update_begin(&qs->syncp);
+	libie_stats_add(qs, ss, packets);
+	libie_stats_add(qs, ss, bytes);
+	u64_stats_update_end(&qs->syncp);
+}
+
+u32 libie_sq_stats_get_sset_count(void);
+void libie_sq_stats_get_strings(u8 **data, u32 qid);
+void libie_sq_stats_get_data(u64 **data, const struct libie_sq_stats *stats);
+
+#endif /* __LIBIE_STATS_H */
-- 
2.40.1


