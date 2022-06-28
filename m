Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4547855EE6E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 21:59:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiF1Tvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 15:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiF1Tuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 15:50:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865E425C6E;
        Tue, 28 Jun 2022 12:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656445767; x=1687981767;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h7GfN6EnBGflCzZCdEPR/mE/rqKzDdKMQ5giru4caVw=;
  b=CMV1qtcdyI8q50+aCMlNgjDlrcgJC1a+viCx5Q1HGbvgOUC3Va6Poxt5
   99iug9ITq0Flsqc1cWxZ5IIfolMidWTp4WQldokI2V0mA6bS1YtZwiPfo
   nDNxhJqhF2HxODfKRReoa59uEXKba7lw941oJyu7NQwCzeN/aYK38bG0t
   E0nSl9ZwnRHkALPi6DCg4FGKtWapwsz5elAp7s7wkpwLTZO0URN1AjHa7
   StU27kgTkGEE0zqckf4C1Rp8Y/1nClKEzLVQoL3KYAbnUCxN56cj8rhDR
   /EpZi9u++B9hzzPHSEJFOLXQkrPmls+wbSwPGjyIP7Px424yLru0YRRmp
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10392"; a="281869581"
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="281869581"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jun 2022 12:49:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,229,1650956400"; 
   d="scan'208";a="623054112"
Received: from irvmail001.ir.intel.com ([10.43.11.63])
  by orsmga001.jf.intel.com with ESMTP; 28 Jun 2022 12:49:22 -0700
Received: from newjersey.igk.intel.com (newjersey.igk.intel.com [10.102.20.203])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id 25SJmr9K022013;
        Tue, 28 Jun 2022 20:49:20 +0100
From:   Alexander Lobakin <alexandr.lobakin@intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Toke Hoiland-Jorgensen <toke@redhat.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yajun Deng <yajun.deng@linux.dev>,
        Willem de Bruijn <willemb@google.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xdp-hints@xdp-project.net
Subject: [PATCH RFC bpf-next 20/52] net, xdp: move XDP metadata helpers into new xdp_meta.h
Date:   Tue, 28 Jun 2022 21:47:40 +0200
Message-Id: <20220628194812.1453059-21-alexandr.lobakin@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
References: <20220628194812.1453059-1-alexandr.lobakin@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

<net/xdp.h> gets included indirectly into tons of different files
across the kernel. To not make them dependent on the header files
needed for the XDP metadata definitions, which will be used only
by several driver and XDP core files, and have the metadata code
logically separated, create a new header file, <net/xdp_meta.h>,
and move several already existing metadata helpers to it.

Signed-off-by: Alexander Lobakin <alexandr.lobakin@intel.com>
---
 MAINTAINERS                                   |  1 +
 .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   |  1 +
 drivers/net/ethernet/netronome/nfp/nfd3/xsk.c |  1 +
 drivers/net/tun.c                             |  2 +-
 include/net/xdp.h                             | 20 -------------
 include/net/xdp_meta.h                        | 29 +++++++++++++++++++
 net/bpf/core.c                                |  2 +-
 net/bpf/prog_ops.c                            |  1 +
 net/bpf/test_run.c                            |  2 +-
 net/xdp/xsk.c                                 |  2 +-
 10 files changed, 37 insertions(+), 24 deletions(-)
 create mode 100644 include/net/xdp_meta.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 91190e12a157..24a640c8a306 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21722,6 +21722,7 @@ L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Supported
 F:	include/net/xdp.h
+F:	include/net/xdp_meta.h
 F:	include/net/xdp_priv.h
 F:	include/trace/events/xdp.h
 F:	kernel/bpf/cpumap.c
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
index 9a1553598a7c..c1fc5c79d90f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -3,6 +3,7 @@
 
 #include "rx.h"
 #include "en/xdp.h"
+#include <net/xdp_meta.h>
 #include <net/xdp_sock_drv.h>
 #include <linux/filter.h>
 
diff --git a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
index 454fea4c8be2..0957e866799b 100644
--- a/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
+++ b/drivers/net/ethernet/netronome/nfp/nfd3/xsk.c
@@ -4,6 +4,7 @@
 
 #include <linux/bpf_trace.h>
 #include <linux/netdevice.h>
+#include <net/xdp_meta.h>
 
 #include "../nfp_app.h"
 #include "../nfp_net.h"
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 87a635aac008..0eb0cc6966e4 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -61,7 +61,7 @@
 #include <net/netns/generic.h>
 #include <net/rtnetlink.h>
 #include <net/sock.h>
-#include <net/xdp.h>
+#include <net/xdp_meta.h>
 #include <net/ip_tunnels.h>
 #include <linux/seq_file.h>
 #include <linux/uio.h>
diff --git a/include/net/xdp.h b/include/net/xdp.h
index 7b8ba068d28a..1663d0b3a05a 100644
--- a/include/net/xdp.h
+++ b/include/net/xdp.h
@@ -378,26 +378,6 @@ int xdp_reg_mem_model(struct xdp_mem_info *mem,
 		      enum xdp_mem_type type, void *allocator);
 void xdp_unreg_mem_model(struct xdp_mem_info *mem);
 
-/* Drivers not supporting XDP metadata can use this helper, which
- * rejects any room expansion for metadata as a result.
- */
-static __always_inline void
-xdp_set_data_meta_invalid(struct xdp_buff *xdp)
-{
-	xdp->data_meta = xdp->data + 1;
-}
-
-static __always_inline bool
-xdp_data_meta_unsupported(const struct xdp_buff *xdp)
-{
-	return unlikely(xdp->data_meta > xdp->data);
-}
-
-static inline bool xdp_metalen_invalid(unsigned long metalen)
-{
-	return (metalen & (sizeof(__u32) - 1)) || (metalen > 32);
-}
-
 struct xdp_attachment_info {
 	struct bpf_prog *prog;
 	u64 btf_id;
diff --git a/include/net/xdp_meta.h b/include/net/xdp_meta.h
new file mode 100644
index 000000000000..e1f3df9ceb93
--- /dev/null
+++ b/include/net/xdp_meta.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright (C) 2022, Intel Corporation. */
+
+#ifndef __LINUX_NET_XDP_META_H__
+#define __LINUX_NET_XDP_META_H__
+
+#include <net/xdp.h>
+
+/* Drivers not supporting XDP metadata can use this helper, which
+ * rejects any room expansion for metadata as a result.
+ */
+static __always_inline void
+xdp_set_data_meta_invalid(struct xdp_buff *xdp)
+{
+	xdp->data_meta = xdp->data + 1;
+}
+
+static __always_inline bool
+xdp_data_meta_unsupported(const struct xdp_buff *xdp)
+{
+	return unlikely(xdp->data_meta > xdp->data);
+}
+
+static inline bool xdp_metalen_invalid(unsigned long metalen)
+{
+	return (metalen & (sizeof(__u32) - 1)) || (metalen > 32);
+}
+
+#endif /* __LINUX_NET_XDP_META_H__ */
diff --git a/net/bpf/core.c b/net/bpf/core.c
index dcd3b6ae86b7..18174d6d8687 100644
--- a/net/bpf/core.c
+++ b/net/bpf/core.c
@@ -14,7 +14,7 @@
 #include <linux/bug.h>
 #include <net/page_pool.h>
 
-#include <net/xdp.h>
+#include <net/xdp_meta.h>
 #include <net/xdp_priv.h> /* struct xdp_mem_allocator */
 #include <trace/events/xdp.h>
 #include <net/xdp_sock_drv.h>
diff --git a/net/bpf/prog_ops.c b/net/bpf/prog_ops.c
index 33f02842e715..bf174b8d8a36 100644
--- a/net/bpf/prog_ops.c
+++ b/net/bpf/prog_ops.c
@@ -2,6 +2,7 @@
 
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
+#include <net/xdp_meta.h>
 #include <net/xdp_sock.h>
 #include <trace/events/xdp.h>
 
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 2ca96acbc50a..596b523ccced 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -19,7 +19,7 @@
 #include <linux/error-injection.h>
 #include <linux/smp.h>
 #include <linux/sock_diag.h>
-#include <net/xdp.h>
+#include <net/xdp_meta.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/bpf_test_run.h>
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 19ac872a6624..ebf6a67424cd 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -24,7 +24,7 @@
 #include <linux/rculist.h>
 #include <net/xdp_sock_drv.h>
 #include <net/busy_poll.h>
-#include <net/xdp.h>
+#include <net/xdp_meta.h>
 
 #include "xsk_queue.h"
 #include "xdp_umem.h"
-- 
2.36.1

