Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAAF276AC3
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 09:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgIXH2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 03:28:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:12504 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726655AbgIXH2l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 03:28:41 -0400
IronPort-SDR: 3et7oN3Ef9p9yfBUztsFqnHmmlfA9goc2DhdrfWy1JcQevpmcUUYMUtJWkQ0N5+1T8JwwZJxVB
 jJPE9NxfE8/Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9753"; a="225266295"
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="225266295"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 00:28:39 -0700
IronPort-SDR: CmxRrJmT622dnpjeKoa98mzwPCEFk9eR1X/qyZ8uo5D90CEPCE8QelkekNOni+3W2jRhLkUMgz
 qoFPvUKnk+hg==
X-IronPort-AV: E=Sophos;i="5.77,296,1596524400"; 
   d="scan'208";a="291948177"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 00:28:37 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org
Cc:     bjorn.topel@intel.com, Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH iproute2-next] ss: add support for xdp statistics
Date:   Thu, 24 Sep 2020 07:03:27 +0000
Message-Id: <20200924070327.28182-1-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch exposes statistics for XDP sockets which can be useful for
debugging purposes.

The stats exposed are:
    rx dropped
    rx invalid
    rx queue full
    rx fill ring empty
    tx invalid
    tx ring empty

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 misc/ss.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/misc/ss.c b/misc/ss.c
index 458e381f..77e1847e 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -4536,6 +4536,21 @@ static void xdp_show_umem(struct xdp_diag_umem *umem, struct xdp_diag_ring *fr,
 		xdp_show_ring("cr", cr);
 }
 
+static void xdp_show_stats(struct xdp_diag_stats *stats)
+{
+	if (oneline)
+		out(" stats(");
+	else
+		out("\n\tstats(");
+	out("rx dropped:%llu", stats->n_rx_dropped);
+	out(",rx invalid:%llu", stats->n_rx_invalid);
+	out(",rx queue full:%llu", stats->n_rx_full);
+	out(",rx fill ring empty:%llu", stats->n_fill_ring_empty);
+	out(",tx invalid:%llu", stats->n_tx_invalid);
+	out(",tx ring empty:%llu", stats->n_tx_ring_empty);
+	out(")");
+}
+
 static int xdp_show_sock(struct nlmsghdr *nlh, void *arg)
 {
 	struct xdp_diag_ring *rx = NULL, *tx = NULL, *fr = NULL, *cr = NULL;
@@ -4543,6 +4558,7 @@ static int xdp_show_sock(struct nlmsghdr *nlh, void *arg)
 	struct rtattr *tb[XDP_DIAG_MAX + 1];
 	struct xdp_diag_info *info = NULL;
 	struct xdp_diag_umem *umem = NULL;
+	struct xdp_diag_stats *stats = NULL;
 	const struct filter *f = arg;
 	struct sockstat stat = {};
 
@@ -4577,6 +4593,8 @@ static int xdp_show_sock(struct nlmsghdr *nlh, void *arg)
 
 		stat.rq = skmeminfo[SK_MEMINFO_RMEM_ALLOC];
 	}
+	if (tb[XDP_DIAG_STATS])
+		stats = RTA_DATA(tb[XDP_DIAG_STATS]);
 
 	if (xdp_stats_print(&stat, f))
 		return 0;
@@ -4588,6 +4606,8 @@ static int xdp_show_sock(struct nlmsghdr *nlh, void *arg)
 			xdp_show_ring("tx", tx);
 		if (umem)
 			xdp_show_umem(umem, fr, cr);
+		if (stats)
+			xdp_show_stats(stats);
 	}
 
 	if (show_mem)
@@ -4606,7 +4626,7 @@ static int xdp_show(struct filter *f)
 
 	req.r.sdiag_family = AF_XDP;
 	req.r.xdiag_show = XDP_SHOW_INFO | XDP_SHOW_RING_CFG | XDP_SHOW_UMEM |
-			   XDP_SHOW_MEMINFO;
+			   XDP_SHOW_MEMINFO | XDP_SHOW_STATS;
 
 	return handle_netlink_request(f, &req.nlh, sizeof(req), xdp_show_sock);
 }
-- 
2.17.1

