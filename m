Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717F81BA724
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgD0PAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727824AbgD0PAu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:00:50 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02988C0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 08:00:50 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id l19so17910593lje.10
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 08:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=v2bMkb1nPd6plhIMDei6vzeqGLpjINaQXWr60Iirw4w=;
        b=AvcWiXmasrA+l5yKl19SWDwtXI8ZtvIaAAkvj4wbzAbmslr6m1lMByT4tg4ZwfLTnN
         09dxz7gL/b6mTnV+V/PFU5IK3ftzuY09El2X0cbt5/RW3ZKNrs+2LvJEYVMZBQWb098T
         bhuODHcTNKbNkQBJadZK36Elwe5Df1uny8MFypACvraXdtvTFJDzXiPslyCJcGs2kiU1
         4/C3K21gbWW9bFj70vjMjF7fFOQuOILYPuNX8gBKMGNk2VV9AXFUhdgp4MDgwUJgbGgv
         dYUCcmjlTJoXwDv6w+PtkdPc4Mkdu47YfTqwwfDIN95UOo/MswvA2OEIuTMvTvSQxyAe
         cw9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=v2bMkb1nPd6plhIMDei6vzeqGLpjINaQXWr60Iirw4w=;
        b=c8i6B/hdtBvXMXhY4QiNWzhZCdwuYFhvwR4I+7/Wd89RmCuWzWOpXIalx9Rj8p9my4
         CZRPVjRky19mYenncibdNP/d15zEf9uToh9gdj4qRU6E4H4T+/Nup4UaxqIXK6aZE9V5
         ghtesm7YGTTVjQ84Iq+JsQbQIkjTuRrTPCRYDCxUEcCLYWWMea4ily//ZYCBSjKMYXRQ
         WTkbuTaae67AgYPVuEBEkxfTXqF9yL7R9zNoLnsBLlG3u5b+oyyl+MHOf39oFtmIFklK
         WXGgiZWcM/BtlDmne6mOa5mVxbcHEM9WYSazwjQV3bCyLr4FiCvJg8h7pE+M5AuxVeul
         3s/Q==
X-Gm-Message-State: AGi0PuYF9EvX4+R3dUTY+CNae4wfYitzp1rDZG5yIbYL8Ayki2u/6T9/
        8R6TuLGNDCVDVDYRjWa2F5Lpk2kaQM4sOg==
X-Google-Smtp-Source: APiQypJ59BTBUyKDRBTS73Z9oD4qNwiomBl+Gvm6wiqfPRA9j6iWgP6kQpWBoF/T+RvI6ukZmI4bsQ==
X-Received: by 2002:a2e:9a4a:: with SMTP id k10mr14604639ljj.115.1587999646796;
        Mon, 27 Apr 2020 08:00:46 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.46.227])
        by smtp.gmail.com with ESMTPSA id y21sm10360774ljg.66.2020.04.27.08.00.46
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 27 Apr 2020 08:00:46 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     jgross@suse.com, wei.liu@kernel.org, paul@xen.org,
        ilias.apalodimas@linaro.org, Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH v5 net-next 2/2] xen networking: add XDP offset adjustment to xen-netback
Date:   Mon, 27 Apr 2020 18:00:32 +0300
Message-Id: <1587999632-1206-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1587999632-1206-1-git-send-email-kda@linux-powerpc.org>
References: <1587999632-1206-1-git-send-email-kda@linux-powerpc.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the patch basically adds the offset adjustment and netfront
state reading to make XDP work on netfront side.
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
index ef58870..1c0cf8a 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -33,6 +33,11 @@
 #include <xen/xen.h>
 #include <xen/events.h>
 
+static inline int xenvif_rx_xdp_offset(struct xenvif *vif)
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
index 286054b..7c0450e 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -393,6 +393,20 @@ static void set_backend_state(struct backend_info *be,
 	}
 }
 
+static void read_xenbus_frontend_xdp(struct backend_info *be,
+				      struct xenbus_device *dev)
+{
+	struct xenvif *vif = be->vif;
+	unsigned int val;
+	int err;
+
+	err = xenbus_scanf(XBT_NIL, dev->otherend,
+			   "feature-xdp", "%u", &val);
+	if (err < 0)
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
+				    !!provides_xdp_headroom);
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

