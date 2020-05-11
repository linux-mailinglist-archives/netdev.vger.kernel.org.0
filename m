Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3CC1CD676
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 12:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgEKKWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 06:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729439AbgEKKWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 06:22:48 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59A9C061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 03:22:47 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u4so7024787lfm.7
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 03:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/dAscbGex4Z26Q8pLRBBuS1XkReHZTzfb+uXyS2LklM=;
        b=QWXXt2j+qqsp85WfVoydmf4MzRtJME4X8YsS3yc1U6NQODTQGU+ld8AV3eNtv0Nfbb
         pPtI/p9ZMgmj1o7+ZSDYQQ9pbJGjtxGv5eSBdogDPru61IH0GkGnMpzPpzI2fQ00jicd
         4/Lg9DBzoy4r8gFDCcAM5BpCfpe/GKzU3Rz49de6cQwo0yNlIXNMRPI+Qtje6wp0qhAm
         CUjML3FIL4SCE0Uu6twM9YkH2ulJ/otKqE+tQ7c4hlGZMxMK8UBVgt52xp+hek5zc2t0
         r97lLUF8T7hxFPgwbXPkKvKF6dH9zLrpoybN1r/EWfMPnryRYAZXU2BVKaoFK/R+Vd9P
         dtlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/dAscbGex4Z26Q8pLRBBuS1XkReHZTzfb+uXyS2LklM=;
        b=HC3n7O3umrHb4GD2NYMPOBtj3dq/DHTCHdOLJ4O5Js0wToA2V5VG0So8EfuIwwEBhx
         Nj0AFq/ZH2TxEooMB9GUs/1eWFUa0poY8fvrb0rNYFhpriTw0T1LZ9MPBQ3Rj/EMEu2O
         CcIUHWGaj2l+9HxPqfxuC4x56tELSWcUMG/ex/JbsYUTP/pGbC6tYp3F6T3FkZlBIV3h
         WwUqKSmD3d4wvKIovmkDkBKnILXHPzsN76FoIn9e1MibeblMIWPPKgKH4XkmIV0jG1vq
         HFREEOYUdMw8+j7KBOapyMV3Q9ssQfmnJWa5BHi4kzNxqeB/3jnvK2HUgVe2+ZoShwQ+
         X9Ww==
X-Gm-Message-State: AOAM533KW44MaYUYdBMKDY5kmRBw1t0z8UdG0YrYFzCLD1lzrdMTA1SH
        IdFMrzCXuV7Ssn1G+rtuCzOYXTGqSm0gRA==
X-Google-Smtp-Source: ABdhPJzjsRA0WNjkMuY556DNSPi+bLOltbJVozIfyKZdHNqnSznLe3qEMHRvG6p79fDvD620daGIdQ==
X-Received: by 2002:ac2:5607:: with SMTP id v7mr10636137lfd.134.1589192565905;
        Mon, 11 May 2020 03:22:45 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.46.227])
        by smtp.gmail.com with ESMTPSA id j15sm10199453lji.18.2020.05.11.03.22.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 03:22:45 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v9 2/2] xen networking: add XDP offset adjustment to xen-netback
Date:   Mon, 11 May 2020 13:22:21 +0300
Message-Id: <1589192541-11686-3-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
References: <1589192541-11686-1-git-send-email-kda@linux-powerpc.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the patch basically adds the offset adjustment and netfront
state reading to make XDP work on netfront side.

Signed-off-by: Denis Kirjanov <denis.kirjanov@suse.com>
---
 drivers/net/xen-netback/common.h  |  2 ++
 drivers/net/xen-netback/netback.c |  7 +++++++
 drivers/net/xen-netback/rx.c      |  7 ++++++-
 drivers/net/xen-netback/xenbus.c  | 28 ++++++++++++++++++++++++++++
 4 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 05847eb..4a148d6 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -280,6 +280,7 @@ struct xenvif {
 	u8 ip_csum:1;
 	u8 ipv6_csum:1;
 	u8 multicast_control:1;
+	u8 xdp_enabled:1;
 
 	/* Is this interface disabled? True when backend discovers
 	 * frontend is rogue.
@@ -395,6 +396,7 @@ static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 irqreturn_t xenvif_interrupt(int irq, void *dev_id);
 
 extern bool separate_tx_rx_irq;
+extern bool provides_xdp_headroom;
 
 extern unsigned int rx_drain_timeout_msecs;
 extern unsigned int rx_stall_timeout_msecs;
diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
index 315dfc6..6dfca72 100644
--- a/drivers/net/xen-netback/netback.c
+++ b/drivers/net/xen-netback/netback.c
@@ -96,6 +96,13 @@
 module_param_named(hash_cache_size, xenvif_hash_cache_size, uint, 0644);
 MODULE_PARM_DESC(hash_cache_size, "Number of flows in the hash cache");
 
+/* The module parameter tells that we have to put data
+ * for xen-netfront with the XDP_PACKET_HEADROOM offset
+ * needed for XDP processing
+ */
+bool provides_xdp_headroom = true;
+module_param(provides_xdp_headroom, bool, 0644);
+
 static void xenvif_idx_release(struct xenvif_queue *queue, u16 pending_idx,
 			       u8 status);
 
diff --git a/drivers/net/xen-netback/rx.c b/drivers/net/xen-netback/rx.c
index ef58870..c97c98e 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -33,6 +33,11 @@
 #include <xen/xen.h>
 #include <xen/events.h>
 
+static int xenvif_rx_xdp_offset(struct xenvif *vif)
+{
+	return vif->xdp_enabled ? XDP_PACKET_HEADROOM : 0;
+}
+
 static bool xenvif_rx_ring_slots_available(struct xenvif_queue *queue)
 {
 	RING_IDX prod, cons;
@@ -356,7 +361,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue *queue,
 				struct xen_netif_rx_request *req,
 				struct xen_netif_rx_response *rsp)
 {
-	unsigned int offset = 0;
+	unsigned int offset = xenvif_rx_xdp_offset(queue->vif);
 	unsigned int flags;
 
 	do {
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 286054b..d447191 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info *be,
 	}
 }
 
+static void read_xenbus_frontend_xdp(struct backend_info *be,
+				     struct xenbus_device *dev)
+{
+	struct xenvif *vif = be->vif;
+	unsigned int val;
+	int err;
+
+	err = xenbus_scanf(XBT_NIL, dev->otherend,
+			   "feature-xdp", "%u", &val);
+	if (err != 1)
+		return;
+	vif->xdp_enabled = val;
+}
+
 /**
  * Callback received when the frontend's state changes.
  */
@@ -417,6 +431,11 @@ static void frontend_changed(struct xenbus_device *dev,
 		set_backend_state(be, XenbusStateConnected);
 		break;
 
+	case XenbusStateReconfiguring:
+		read_xenbus_frontend_xdp(be, dev);
+		xenbus_switch_state(dev, XenbusStateReconfigured);
+		break;
+
 	case XenbusStateClosing:
 		set_backend_state(be, XenbusStateClosing);
 		break;
@@ -1036,6 +1055,15 @@ static int netback_probe(struct xenbus_device *dev,
 			goto abort_transaction;
 		}
 
+		/* we can adjust a headroom for netfront XDP processing */
+		err = xenbus_printf(xbt, dev->nodename,
+				    "feature-xdp-headroom", "%d",
+				    provides_xdp_headroom);
+		if (err) {
+			message = "writing feature-xdp-headroom";
+			goto abort_transaction;
+		}
+
 		/* We don't support rx-flip path (except old guests who
 		 * don't grok this feature flag).
 		 */
-- 
1.8.3.1

