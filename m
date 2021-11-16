Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 646FE452BA1
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 08:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbhKPHl0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 02:41:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:42900 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhKPHlY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 02:41:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="231099046"
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="231099046"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 23:38:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,238,1631602800"; 
   d="scan'208";a="671857302"
Received: from silpixa00401086.ir.intel.com (HELO localhost.localdomain) ([10.55.129.110])
  by orsmga005.jf.intel.com with ESMTP; 15 Nov 2021 23:38:25 -0800
From:   Ciara Loftus <ciara.loftus@intel.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com, maciej.fijalkowski@intel.com,
        Ciara Loftus <ciara.loftus@intel.com>
Subject: [RFC PATCH bpf-next 1/8] xsk: add struct xdp_sock to netdev_rx_queue
Date:   Tue, 16 Nov 2021 07:37:35 +0000
Message-Id: <20211116073742.7941-2-ciara.loftus@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211116073742.7941-1-ciara.loftus@intel.com>
References: <20211116073742.7941-1-ciara.loftus@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Storing a reference to the XDP socket in the netdev_rx_queue structure
makes a single socket accessible without requiring a lookup in the XSKMAP.
A future commit will introduce the XDP_REDIRECT_XSK action which
indicates to use this reference instead of performing the lookup. Since
an rx ring is required for redirection, only store the reference if an
rx ring is configured.

When multiple sockets exist for a given context (netdev, qid), a
reference is not stored because in this case we fallback to the default
behavior of using the XSKMAP to redirect the packets.

Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
---
 include/linux/netdevice.h |  2 ++
 net/xdp/xsk.c             | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 3ec42495a43a..1ad2491f0391 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -736,6 +736,8 @@ struct netdev_rx_queue {
 	struct net_device		*dev;
 #ifdef CONFIG_XDP_SOCKETS
 	struct xsk_buff_pool            *pool;
+	struct xdp_sock			*xsk;
+	refcount_t			xsk_refcnt;
 #endif
 } ____cacheline_aligned_in_smp;
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f16074eb53c7..94ee524b9ca8 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -728,6 +728,30 @@ static void xsk_unbind_dev(struct xdp_sock *xs)
 
 	/* Wait for driver to stop using the xdp socket. */
 	xp_del_xsk(xs->pool, xs);
+	if (xs->rx) {
+		if (refcount_read(&dev->_rx[xs->queue_id].xsk_refcnt) == 1) {
+			refcount_set(&dev->_rx[xs->queue_id].xsk_refcnt, 0);
+			WRITE_ONCE(xs->dev->_rx[xs->queue_id].xsk, NULL);
+		} else {
+			refcount_dec(&dev->_rx[xs->queue_id].xsk_refcnt);
+			/* If the refcnt returns to one again store the reference to the
+			 * remaining socket in the netdev_rx_queue.
+			 */
+			if (refcount_read(&dev->_rx[xs->queue_id].xsk_refcnt) == 1) {
+				struct net *net = dev_net(dev);
+				struct xdp_sock *xsk;
+				struct sock *sk;
+
+				mutex_lock(&net->xdp.lock);
+				sk = sk_head(&net->xdp.list);
+				xsk = xdp_sk(sk);
+				mutex_lock(&xsk->mutex);
+				WRITE_ONCE(xs->dev->_rx[xs->queue_id].xsk, xsk);
+				mutex_unlock(&xsk->mutex);
+				mutex_unlock(&net->xdp.lock);
+			}
+		}
+	}
 	xs->dev = NULL;
 	synchronize_net();
 	dev_put(dev);
@@ -972,6 +996,16 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	xs->queue_id = qid;
 	xp_add_xsk(xs->pool, xs);
 
+	if (xs->rx) {
+		if (refcount_read(&dev->_rx[xs->queue_id].xsk_refcnt) == 0) {
+			WRITE_ONCE(dev->_rx[qid].xsk, xs);
+			refcount_set(&dev->_rx[qid].xsk_refcnt, 1);
+		} else {
+			refcount_inc(&dev->_rx[qid].xsk_refcnt);
+			WRITE_ONCE(dev->_rx[qid].xsk, NULL);
+		}
+	}
+
 out_unlock:
 	if (err) {
 		dev_put(dev);
-- 
2.17.1

