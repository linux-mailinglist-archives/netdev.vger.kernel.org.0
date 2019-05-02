Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC7011599
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 10:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfEBIkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 04:40:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:64550 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfEBIkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 04:40:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 01:40:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,421,1549958400"; 
   d="scan'208";a="296322500"
Received: from mkarlsso-mobl.ger.corp.intel.com (HELO VM.isw.intel.com) ([10.103.211.43])
  by orsmga004.jf.intel.com with ESMTP; 02 May 2019 01:40:00 -0700
From:   Magnus Karlsson <magnus.karlsson@intel.com>
To:     magnus.karlsson@intel.com, bjorn.topel@intel.com, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Cc:     bpf@vger.kernel.org, bruce.richardson@intel.com,
        ciara.loftus@intel.com, jakub.kicinski@netronome.com,
        xiaolong.ye@intel.com, qi.z.zhang@intel.com, maximmi@mellanox.com,
        sridhar.samudrala@intel.com, kevin.laatz@intel.com
Subject: [RFC bpf-next 6/7] libbpf: add busy-poll support to XDP sockets
Date:   Thu,  2 May 2019 10:39:22 +0200
Message-Id: <1556786363-28743-7-git-send-email-magnus.karlsson@intel.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
References: <1556786363-28743-1-git-send-email-magnus.karlsson@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds busy-poll support for XDP sockets to libbpf. A new
option is provided in the xsk_socket_config struct called
busy_poll. The value of it is the desired batch size. A value between
1 and NAPI_WEIGHT (64) will turn it on, 0 will turn it off and any
other value will return an error.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/include/uapi/linux/if_xdp.h |  1 +
 tools/lib/bpf/xsk.c               | 23 +++++++++++++----------
 tools/lib/bpf/xsk.h               |  1 +
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/tools/include/uapi/linux/if_xdp.h b/tools/include/uapi/linux/if_xdp.h
index caed8b1..be28a78 100644
--- a/tools/include/uapi/linux/if_xdp.h
+++ b/tools/include/uapi/linux/if_xdp.h
@@ -46,6 +46,7 @@ struct xdp_mmap_offsets {
 #define XDP_UMEM_FILL_RING		5
 #define XDP_UMEM_COMPLETION_RING	6
 #define XDP_STATISTICS			7
+#define XDP_BUSY_POLL_BATCH_SIZE	8
 
 struct xdp_umem_reg {
 	__u64 addr; /* Start of packet data area */
diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 557ef8d..b5538f1 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -120,10 +120,7 @@ static void xsk_set_umem_config(struct xsk_umem_config *cfg,
 		return;
 	}
 
-	cfg->fill_size = usr_cfg->fill_size;
-	cfg->comp_size = usr_cfg->comp_size;
-	cfg->frame_size = usr_cfg->frame_size;
-	cfg->frame_headroom = usr_cfg->frame_headroom;
+	memcpy(cfg, usr_cfg, sizeof(*usr_cfg));
 }
 
 static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
@@ -135,18 +132,14 @@ static int xsk_set_xdp_socket_config(struct xsk_socket_config *cfg,
 		cfg->libbpf_flags = 0;
 		cfg->xdp_flags = 0;
 		cfg->bind_flags = 0;
+		cfg->busy_poll = 0;
 		return 0;
 	}
 
 	if (usr_cfg->libbpf_flags & ~XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD)
 		return -EINVAL;
 
-	cfg->rx_size = usr_cfg->rx_size;
-	cfg->tx_size = usr_cfg->tx_size;
-	cfg->libbpf_flags = usr_cfg->libbpf_flags;
-	cfg->xdp_flags = usr_cfg->xdp_flags;
-	cfg->bind_flags = usr_cfg->bind_flags;
-
+	memcpy(cfg, usr_cfg, sizeof(*usr_cfg));
 	return 0;
 }
 
@@ -632,6 +625,16 @@ int xsk_socket__create(struct xsk_socket **xsk_ptr, const char *ifname,
 	}
 	xsk->tx = tx;
 
+	if (xsk->config.busy_poll) {
+		err = setsockopt(xsk->fd, SOL_XDP, XDP_BUSY_POLL_BATCH_SIZE,
+				 &xsk->config.busy_poll,
+				 sizeof(xsk->config.busy_poll));
+		if (err) {
+			err = -errno;
+			goto out_mmap_tx;
+		}
+	}
+
 	sxdp.sxdp_family = PF_XDP;
 	sxdp.sxdp_ifindex = xsk->ifindex;
 	sxdp.sxdp_queue_id = xsk->queue_id;
diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
index 82ea71a..517a56a 100644
--- a/tools/lib/bpf/xsk.h
+++ b/tools/lib/bpf/xsk.h
@@ -187,6 +187,7 @@ struct xsk_socket_config {
 	__u32 libbpf_flags;
 	__u32 xdp_flags;
 	__u16 bind_flags;
+	__u16 busy_poll;
 };
 
 /* Set config to NULL to get the default configuration. */
-- 
2.7.4

