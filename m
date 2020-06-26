Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC3520B0BA
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 13:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgFZLle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 07:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgFZLlc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 07:41:32 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60A6C08C5C1
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:41:31 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id t25so5413374lji.12
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 04:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X9ZjmFnPdebHsYbp/UnHfvnMTe9lZZ6GefjuxZZCoUg=;
        b=TZk9m/ku2tPmO8BLtwbqjk7wNIHw2C9g78rLJDezbzhv555/+tQLaKIhG6YTRt/X3P
         yfW3L5qQX3hMONm7P/Ov/Z+62DAiJt2N9YiRmz9q3I4deQCdr7W8b2RPmLkt8BfDRjAp
         KWHajBovMp9vYC1vXylkG1YLY6LTol/zuSJ5IrejCkWsKyXP6/Mqx0n7P4Tb7/6T0iRQ
         zmFFJ6esQ1b5mv4guetTBIEt07GYsHpu9BKnvmGaHk3scp1zUQoIlJ2Pjry3BaJIxHrG
         dR0jQuEhV+iXcrjFGOanw+ujaUrX1SswfP9g8wC1DYeIws+5mRTXxHRb6tI9viaSdNv+
         RAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X9ZjmFnPdebHsYbp/UnHfvnMTe9lZZ6GefjuxZZCoUg=;
        b=l4ChDoWY31RY92ZTaid6Pada1JMs/OvZuHjXQjy/IidHfOXvpW/74Modnlaredrnae
         axmSfFigK7F6A6bySX7i8R9AqjyotwJ7IybRHlezRL1xmXE3gV9SXzezXGFdXn/kMn/F
         SxtBi7nybDp8KfE/DlQ4aFpFdizE4H4rIFPTDv/hf30Wi4+PzLYaMs2UTYXIHcCzeYgF
         9z9fn0SQ4vQlTa68W0gLvrgAAF5f+eYQS+aJ0e7P8Og6WmhhefIS0Z242OYFtdzCi4cb
         ZsE+hHKpZQIf5Efa7cv5i1bjtgP2AN2drTdy/8zVv//k3JbVkbX1QZ45dd5fcaJ1s2Qs
         NEVg==
X-Gm-Message-State: AOAM533gZqI7aVjc+SfJdvDSAxcj3bx64QXwsvt6c8wGr8HIVsJCyeks
        xZjpeGKbe8K8HsOX8yLGx2qNnxVxxtA7BA==
X-Google-Smtp-Source: ABdhPJzT1IgZjCWCSQe3FhAl2aEw5/v+1Qa9zrvKsIuz5QZ3ALQhgF9LEf939Zy0rmeiqsc6pHJgiQ==
X-Received: by 2002:a2e:9d99:: with SMTP id c25mr1230386ljj.404.1593171689787;
        Fri, 26 Jun 2020 04:41:29 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id v22sm5464237ljg.12.2020.06.26.04.41.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jun 2020 04:41:29 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v13 3/3] xen networking: add XDP offset adjustment to xen-netback
Date:   Fri, 26 Jun 2020 14:40:39 +0300
Message-Id: <1593171639-8136-4-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
References: <1593171639-8136-1-git-send-email-kda@linux-powerpc.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the patch basically adds the offset adjustment and netfront
state reading to make XDP work on netfront side.

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/net/xen-netback/common.h    |  4 ++++
 drivers/net/xen-netback/interface.c |  2 ++
 drivers/net/xen-netback/netback.c   |  7 +++++++
 drivers/net/xen-netback/rx.c        | 15 ++++++++++++++-
 drivers/net/xen-netback/xenbus.c    | 34 ++++++++++++++++++++++++++++++++++
 5 files changed, 61 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 05847eb..ae477f7 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -281,6 +281,9 @@ struct xenvif {
 	u8 ipv6_csum:1;
 	u8 multicast_control:1;
 
+	/* headroom requested by xen-netfront */
+	u16 xdp_headroom;
+
 	/* Is this interface disabled? True when backend discovers
 	 * frontend is rogue.
 	 */
@@ -395,6 +398,7 @@ static inline pending_ring_idx_t nr_pending_reqs(struct xenvif_queue *queue)
 irqreturn_t xenvif_interrupt(int irq, void *dev_id);
 
 extern bool separate_tx_rx_irq;
+extern bool provides_xdp_headroom;
 
 extern unsigned int rx_drain_timeout_msecs;
 extern unsigned int rx_stall_timeout_msecs;
diff --git a/drivers/net/xen-netback/interface.c b/drivers/net/xen-netback/interface.c
index 0c8a02a..8af49728 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -483,6 +483,8 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	vif->queues = NULL;
 	vif->num_queues = 0;
 
+	vif->xdp_headroom = 0;
+
 	spin_lock_init(&vif->lock);
 	INIT_LIST_HEAD(&vif->fe_mcast_addr);
 
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
index ef58870..ac034f6 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -258,6 +258,19 @@ static void xenvif_rx_next_skb(struct xenvif_queue *queue,
 		pkt->extra_count++;
 	}
 
+	if (queue->vif->xdp_headroom) {
+		struct xen_netif_extra_info *extra;
+
+		extra = &pkt->extras[XEN_NETIF_EXTRA_TYPE_XDP - 1];
+
+		memset(extra, 0, sizeof(struct xen_netif_extra_info));
+		extra->u.xdp.headroom = queue->vif->xdp_headroom;
+		extra->type = XEN_NETIF_EXTRA_TYPE_XDP;
+		extra->flags = 0;
+
+		pkt->extra_count++;
+	}
+
 	if (skb->sw_hash) {
 		struct xen_netif_extra_info *extra;
 
@@ -356,7 +369,7 @@ static void xenvif_rx_data_slot(struct xenvif_queue *queue,
 				struct xen_netif_rx_request *req,
 				struct xen_netif_rx_response *rsp)
 {
-	unsigned int offset = 0;
+	unsigned int offset = queue->vif->xdp_headroom;
 	unsigned int flags;
 
 	do {
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 286054b..7e62a6e 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -393,6 +393,24 @@ static void set_backend_state(struct backend_info *be,
 	}
 }
 
+static void read_xenbus_frontend_xdp(struct backend_info *be,
+				      struct xenbus_device *dev)
+{
+	struct xenvif *vif = be->vif;
+	u16 headroom;
+	int err;
+
+	err = xenbus_scanf(XBT_NIL, dev->otherend,
+			   "xdp-headroom", "%hu", &headroom);
+	if (err != 1) {
+		vif->xdp_headroom = 0;
+		return;
+	}
+	if (headroom > XEN_NETIF_MAX_XDP_HEADROOM)
+		headroom = XEN_NETIF_MAX_XDP_HEADROOM;
+	vif->xdp_headroom = headroom;
+}
+
 /**
  * Callback received when the frontend's state changes.
  */
@@ -417,6 +435,11 @@ static void frontend_changed(struct xenbus_device *dev,
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
@@ -947,6 +970,8 @@ static int read_xenbus_vif_flags(struct backend_info *be)
 	vif->ipv6_csum = !!xenbus_read_unsigned(dev->otherend,
 						"feature-ipv6-csum-offload", 0);
 
+	read_xenbus_frontend_xdp(be, dev);
+
 	return 0;
 }
 
@@ -1036,6 +1061,15 @@ static int netback_probe(struct xenbus_device *dev,
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

