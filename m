Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A47EA34E71E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 14:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232117AbhC3MGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 08:06:22 -0400
Received: from mga12.intel.com ([192.55.52.136]:33814 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231924AbhC3MF7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 08:05:59 -0400
IronPort-SDR: JJjQFt6vf5go/RXfTcaBT2l1hR4RRpuAMBOsMMUqHYnsR5k/obI5UJ4WE9RdqOgs5DBo4EmqIu
 awJ9RWjgXreA==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="171158243"
X-IronPort-AV: E=Sophos;i="5.81,290,1610438400"; 
   d="scan'208";a="171158243"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2021 05:05:59 -0700
IronPort-SDR: MIUsMmASUIfa9P1GnO/m3uu0jK9dWgqgPNwC+OMdh6l0706oCM6YSNdk+2Ce5FfwmbO75LpAj2
 8qQ7DDRptjSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,290,1610438400"; 
   d="scan'208";a="418145859"
Received: from silpixa00399839.ir.intel.com (HELO localhost.localdomain) ([10.237.222.142])
  by orsmga008.jf.intel.com with ESMTP; 30 Mar 2021 05:05:57 -0700
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org,
        alexei.starovoitov@gmail.com
Cc:     Ciara Loftus <ciara.loftus@intel.com>
Subject: [PATCH v3 bpf 3/3] libbpf: only create rx and tx XDP rings when necessary
Date:   Tue, 30 Mar 2021 11:34:19 +0000
Message-Id: <20210330113419.4616-4-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210330113419.4616-1-ciara.loftus@intel.com>
References: <20210330113419.4616-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior to this commit xsk_socket__create(_shared) always attempted to create
the rx and tx rings for the socket. However this causes an issue when the
socket being setup is that which shares the fd with the UMEM. If a
previous call to this function failed with this socket after the rings were
set up, a subsequent call would always fail because the rings are not torn
down after the first call and when we try to set them up again we encounter
an error because they already exist. Solve this by remembering whether the
rings were set up by introducing a new flag to struct xsk_umem, and
checking it before setting up the rings for sockets which share the fd
with the UMEM.

Fixes: 1cad07884239 ("libbpf: add support for using AF_XDP sockets")

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 tools/lib/bpf/xsk.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index d4991ddff05a..12110bba4cc0 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -14,6 +14,7 @@
 #include <unistd.h>
 #include <arpa/inet.h>
 #include <asm/barrier.h>
+#include <linux/bitops.h>
 #include <linux/compiler.h>
 #include <linux/ethtool.h>
 #include <linux/filter.h>
@@ -46,6 +47,9 @@
  #define PF_XDP AF_XDP
 #endif
 
+#define XDP_RX_RING_SETUP_DONE BIT(0)
+#define XDP_TX_RING_SETUP_DONE BIT(1)
+
 enum xsk_prog {
 	XSK_PROG_FALLBACK,
 	XSK_PROG_REDIRECT_FLAGS,
@@ -59,6 +63,7 @@ struct xsk_umem {
 	int fd;
 	int refcount;
 	struct list_head ctx_list;
+	__u8 ring_setup_status;
 };
 
 struct xsk_ctx {
@@ -855,6 +860,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	struct xsk_ctx *ctx;
 	int err, ifindex;
 	bool unmap = umem->fill_save != fill;
+	bool rx_setup_done = false, tx_setup_done = false;
 
 	if (!umem || !xsk_ptr || !(rx || tx))
 		return -EFAULT;
@@ -882,6 +888,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 		}
 	} else {
 		xsk->fd = umem->fd;
+		rx_setup_done = umem->ring_setup_status & XDP_RX_RING_SETUP_DONE;
+		tx_setup_done = umem->ring_setup_status & XDP_TX_RING_SETUP_DONE;
 	}
 
 	ctx = xsk_get_ctx(umem, ifindex, queue_id);
@@ -900,7 +908,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 	}
 	xsk->ctx = ctx;
 
-	if (rx) {
+	if (rx && !rx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_RX_RING,
 				 &xsk->config.rx_size,
 				 sizeof(xsk->config.rx_size));
@@ -908,8 +916,10 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->ring_setup_status |= XDP_RX_RING_SETUP_DONE;
 	}
-	if (tx) {
+	if (tx && !tx_setup_done) {
 		err = setsockopt(xsk->fd, SOL_XDP, XDP_TX_RING,
 				 &xsk->config.tx_size,
 				 sizeof(xsk->config.tx_size));
@@ -917,6 +927,8 @@ int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
 			err = -errno;
 			goto out_put_ctx;
 		}
+		if (xsk->fd == umem->fd)
+			umem->ring_setup_status |= XDP_TX_RING_SETUP_DONE;
 	}
 
 	err = xsk_get_mmap_offsets(xsk->fd, &off);
-- 
2.17.1

