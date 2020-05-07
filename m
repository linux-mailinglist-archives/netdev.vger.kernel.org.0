Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47E591C8B31
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 14:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgEGMlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 08:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725900AbgEGMle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 08:41:34 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAAE3C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 05:41:32 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id 188so4330430lfa.10
        for <netdev@vger.kernel.org>; Thu, 07 May 2020 05:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GypPYV6HuGetWivdyvI8gz0CRNcYKStU2Ah0mhMmqe4=;
        b=Z9rugAxJsGr04lJh5gMXuLjXMAo8zqcOOOczDSCIJek0R03usOMd0MiUPKNzIlF47J
         OMVEJuexQRH+cKkt91clPY6RpBhBDlzpaMacHGf+yJ3V0IKZu48hWFN/YCx2va+6vw2A
         JuEWRysFAVqW6Eoktjqc4IHx/9evKbjUJHfBaQqwl5zFbBk8bYScZJNQidFcVtkdeynu
         wSxhLnyd7YZTuVWF8NocCC65M4y30jlSZMMgC5M5fy6UpxbDD41WM/GlUwo37HoA1qyP
         WVZPTBn43Md0YBN3FsXWVxKtlofHEsx81I+IRQcQMbWMiLzMC9YnMd+bhPO6j6vRYuw/
         QzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GypPYV6HuGetWivdyvI8gz0CRNcYKStU2Ah0mhMmqe4=;
        b=B+zyE1VK2+aBHvysnD7C54IC1XozX+q99YgmXJoQT6RFmBErxSUnxPWtPrFNt4JIFS
         GbTHOpczprrDYkA2Rl4omuxDK26+Bnka/IJnGzYuw/6aXxdsD9iihdyJeTL2FKgxSpOQ
         PvocgAt54U0D3SCoORS50Sy9RJ9I0ONnYjQoKgAlzxXwpuZk7Yr25LYs97mRM83oYtSp
         4josE0CtK46Xdm0Rc4cwEdja3PlL1bQIlJR6eeOUDRdrHsUpkuc5xfg1O/UR9p0OTRZ1
         6hYJT7dCtoYI2UyBafGSLqyIF/5zRJL+/06X1GuxzJwlMayRC0UKi42N1n4VCQWiBvXr
         D6HA==
X-Gm-Message-State: AGi0PuakZQATahyhHskSGwJMkb3luuRUioCNzYNATVxKAZ9JtVHv3fvb
        pgNXoymdXRPvHeHRq8s5PY687hKgtrSeaA==
X-Google-Smtp-Source: APiQypJSMeHeU90Yd22M9EXZleTr6CbYfLol5s21FtyKqTShSwUyF+ibDVBUlbHwOPozTVYZ7m458Q==
X-Received: by 2002:ac2:5384:: with SMTP id g4mr8732957lfh.1.1588855290411;
        Thu, 07 May 2020 05:41:30 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.46.227])
        by smtp.gmail.com with ESMTPSA id i76sm3744231lfi.83.2020.05.07.05.41.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 07 May 2020 05:41:29 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v8 2/3] xen networking: add XDP offset adjustment to xen-netback
Date:   Thu,  7 May 2020 15:40:40 +0300
Message-Id: <1588855241-29141-2-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1588855241-29141-1-git-send-email-kda@linux-powerpc.org>
References: <1588855241-29141-1-git-send-email-kda@linux-powerpc.org>
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
index 286054b..9c1b837 100644
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

