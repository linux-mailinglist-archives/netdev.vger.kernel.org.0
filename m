Return-Path: <netdev+bounces-11205-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BFF7731F27
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 19:33:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EBED3280D13
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 17:33:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A51B1D2A6;
	Thu, 15 Jun 2023 17:27:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7728A1D2A4;
	Thu, 15 Jun 2023 17:27:11 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34322977;
	Thu, 15 Jun 2023 10:27:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686850025; x=1718386025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tT8hmhkOiFG3f1duf7LxcmWuMCRIr+puRR6b9PUIl30=;
  b=GW8mNg+b5TW0MtwSemuazsJ/rqBB8V422B9i2022FY+ts+9KTf5V4Yho
   VTVvyj4DHXxquaqqPkCuVtlFUGce6a8ne3BDvU+yAgYVavd+fOCODOTE+
   KLJPPwRL/zc/gGiOzFvQroav3jBJA0wdXC1/NW3PmwG+ikn9QBf7D9ItJ
   e4/BLP+8P/moWV6eR9NwoFGEISqUSSBtp1CHKoRmRLFPVJL/xGRI0Z7Hb
   jWGiLjghEOE+zk6zDDIaGxOxW7UbuLsnw5NKZl4PGGMo1qtxyDYcVjK7x
   Mk2FMBwLd1v8XNaD7iWDSO6FXw1JJYxdDFejpdtgqeiuVxebBxrF3Jarv
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="358983620"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="358983620"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 10:26:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="689858818"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="689858818"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by orsmga006.jf.intel.com with ESMTP; 15 Jun 2023 10:26:56 -0700
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: bpf@vger.kernel.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org
Cc: netdev@vger.kernel.org,
	magnus.karlsson@intel.com,
	bjorn@kernel.org,
	tirthendu.sarkar@intel.com,
	maciej.fijalkowski@intel.com,
	simon.horman@corigine.com,
	toke@kernel.org
Subject: [PATCH v4 bpf-next 15/22] xsk: add multi-buffer documentation
Date: Thu, 15 Jun 2023 19:25:59 +0200
Message-Id: <20230615172606.349557-16-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20230615172606.349557-1-maciej.fijalkowski@intel.com>
References: <20230615172606.349557-1-maciej.fijalkowski@intel.com>
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

From: Magnus Karlsson <magnus.karlsson@intel.com>

Add AF_XDP multi-buffer support documentation including two
pseudo-code samples.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 Documentation/networking/af_xdp.rst | 177 ++++++++++++++++++++++++++++
 1 file changed, 177 insertions(+)

diff --git a/Documentation/networking/af_xdp.rst b/Documentation/networking/af_xdp.rst
index 247c6c4127e9..2b583f58967b 100644
--- a/Documentation/networking/af_xdp.rst
+++ b/Documentation/networking/af_xdp.rst
@@ -453,6 +453,93 @@ XDP_OPTIONS getsockopt
 Gets options from an XDP socket. The only one supported so far is
 XDP_OPTIONS_ZEROCOPY which tells you if zero-copy is on or not.
 
+Multi-Buffer Support
+--------------------
+
+With multi-buffer support, programs using AF_XDP sockets can receive
+and transmit packets consisting of multiple buffers both in copy and
+zero-copy mode. For example, a packet can consist of two
+frames/buffers, one with the header and the other one with the data,
+or a 9K Ethernet jumbo frame can be constructed by chaining together
+three 4K frames.
+
+Some definitions:
+
+* A packet consists of one or more frames
+
+* A descriptor in one of the AF_XDP rings always refers to a single
+  frame. In the case the packet consists of a single frame, the
+  descriptor refers to the whole packet.
+
+To enable multi-buffer support for an AF_XDP socket, use the new bind
+flag XDP_USE_SG. If this is not provided, all multi-buffer packets
+will be dropped just as before. Note that the XDP program loaded also
+needs to be in multi-buffer mode. This can be accomplished by using
+"xdp.frags" as the section name of the XDP program used.
+
+To represent a packet consisting of multiple frames, a new flag called
+XDP_PKT_CONTD is introduced in the options field of the Rx and Tx
+descriptors. If it is true (1) the packet continues with the next
+descriptor and if it is false (0) it means this is the last descriptor
+of the packet. Why the reverse logic of end-of-packet (eop) flag found
+in many NICs? Just to preserve compatibility with non-multi-buffer
+applications that have this bit set to false for all packets on Rx,
+and the apps set the options field to zero for Tx, as anything else
+will be treated as an invalid descriptor.
+
+These are the semantics for producing packets onto AF_XDP Tx ring
+consisting of multiple frames:
+
+* When an invalid descriptor is found, all the other
+  descriptors/frames of this packet are marked as invalid and not
+  completed. The next descriptor is treated as the start of a new
+  packet, even if this was not the intent (because we cannot guess
+  the intent). As before, if your program is producing invalid
+  descriptors you have a bug that must be fixed.
+
+* Zero length descriptors are treated as invalid descriptors.
+
+* For copy mode, the maximum supported number of frames in a packet is
+  equal to CONFIG_MAX_SKB_FRAGS + 1. If it is exceeded, all
+  descriptors accumulated so far are dropped and treated as
+  invalid. To produce an application that will work on any system
+  regardless of this config setting, limit the number of frags to 18,
+  as the minimum value of the config is 17.
+
+* For zero-copy mode, the limit is up to what the NIC HW
+  supports. Usually at least five on the NICs we have checked. We
+  consciously chose to not enforce a rigid limit (such as
+  CONFIG_MAX_SKB_FRAGS + 1) for zero-copy mode, as it would have
+  resulted in copy actions under the hood to fit into what limit
+  the NIC supports. Kind of defeats the purpose of zero-copy mode.
+
+* The ZC batch API guarantees that it will provide a batch of Tx
+  descriptors that ends with full packet at the end. If not, ZC
+  drivers would have to gather the full packet on their side. The
+  approach we picked makes ZC drivers' life much easier (at least on
+  Tx side).
+
+On the Rx path in copy-mode, the xsk core copies the XDP data into
+multiple descriptors, if needed, and sets the XDP_PKT_CONTD flag as
+detailed before. Zero-copy mode works the same, though the data is not
+copied. When the application gets a descriptor with the XDP_PKT_CONTD
+flag set to one, it means that the packet consists of multiple buffers
+and it continues with the next buffer in the following
+descriptor. When a descriptor with XDP_PKT_CONTD == 0 is received, it
+means that this is the last buffer of the packet. AF_XDP guarantees
+that only a complete packet (all frames in the packet) is sent to the
+application.
+
+If application reads a batch of descriptors, using for example the libxdp
+interfaces, it is not guaranteed that the batch will end with a full
+packet. It might end in the middle of a packet and the rest of the
+buffers of that packet will arrive at the beginning of the next batch,
+since the libxdp interface does not read the whole ring (unless you
+have an enormous batch size or a very small ring size).
+
+An example program each for Rx and Tx multi-buffer support can be found
+later in this document.
+
 Usage
 =====
 
@@ -532,6 +619,96 @@ like this:
 But please use the libbpf functions as they are optimized and ready to
 use. Will make your life easier.
 
+Usage Multi-Buffer Rx
+=====================
+
+Here is a simple Rx path pseudo-code example (using libxdp interfaces
+for simplicity). Error paths have been excluded to keep it short:
+
+.. code-block:: c
+
+    void rx_packets(struct xsk_socket_info *xsk)
+    {
+        static bool new_packet = true;
+        u32 idx_rx = 0, idx_fq = 0;
+        static char *pkt;
+
+        int rcvd = xsk_ring_cons__peek(&xsk->rx, opt_batch_size, &idx_rx);
+
+        xsk_ring_prod__reserve(&xsk->umem->fq, rcvd, &idx_fq);
+
+        for (int i = 0; i < rcvd; i++) {
+            struct xdp_desc *desc = xsk_ring_cons__rx_desc(&xsk->rx, idx_rx++);
+            char *frag = xsk_umem__get_data(xsk->umem->buffer, desc->addr);
+            bool eop = !(desc->options & XDP_PKT_CONTD);
+
+        if (new_packet)
+            pkt = frag;
+        else
+            add_frag_to_pkt(pkt, frag);
+
+        if (eop)
+            process_pkt(pkt);
+
+        new_packet = eop;
+
+        *xsk_ring_prod__fill_addr(&xsk->umem->fq, idx_fq++) = desc->addr;
+        }
+
+        xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
+        xsk_ring_cons__release(&xsk->rx, rcvd);
+    }
+
+Usage Multi-Buffer Tx
+=====================
+
+Here is an example Tx path pseudo-code (using libxdp interfaces for
+simplicity) ignoring that the umem is finite in size, and that we
+eventually will run out of packets to send. Also assumes pkts.addr
+points to a valid location in the umem.
+
+.. code-block:: c
+
+    void tx_packets(struct xsk_socket_info *xsk, struct pkt *pkts,
+                    int batch_size)
+    {
+        u32 idx, i, pkt_nb = 0;
+
+        xsk_ring_prod__reserve(&xsk->tx, batch_size, &idx);
+
+        for (i = 0; i < batch_size;) {
+            u64 addr = pkts[pkt_nb].addr;
+            u32 len = pkts[pkt_nb].size;
+
+            do {
+                struct xdp_desc *tx_desc;
+
+                tx_desc = xsk_ring_prod__tx_desc(&xsk->tx, idx + i++);
+                tx_desc->addr = addr;
+
+                if (len > xsk_frame_size) {
+                    tx_desc->len = xsk_frame_size;
+                    tx_desc->options = XDP_PKT_CONTD;
+                } else {
+                    tx_desc->len = len;
+                    tx_desc->options = 0;
+                    pkt_nb++;
+                }
+                len -= tx_desc->len;
+                addr += xsk_frame_size;
+
+                if (i == batch_size) {
+                    /* Remember len, addr, pkt_nb for next iteration.
+                     * Skipped for simplicity.
+                     */
+                    break;
+                }
+            } while (len);
+        }
+
+        xsk_ring_prod__submit(&xsk->tx, i);
+    }
+
 Sample application
 ==================
 
-- 
2.34.1


