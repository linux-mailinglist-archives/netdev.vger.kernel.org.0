Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBB8203334
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgFVJVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgFVJVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 05:21:44 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE39C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:21:43 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id t74so9190330lff.2
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 02:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FYWwENwhD0QpX1bHTVokEE+o8fXxR6ouv90UAH4he4g=;
        b=i7oMIPoAqGmwZR8KjcZ8tgDVL/S3JkBSBCfqC4z4lQFrT6Xy8LWmMO7SnGQcQ5HT1k
         7A3tSsLZZbTgtQoHVF5W/UfHDPReI2qumF1DOEX4CIv8TW7iG6WwhXqv7SqJrqba/yBw
         gjuyMUjOP6yiAwaLjXCFF9ODF0/mZLslIJuo8BYe0LM+P4Ky51+WcGstKAWZfww4FpVw
         cMZvpdiubbD3eNILT4gyyxQREML5sq3uZHwtBcJyvI/PDkDGCqb3hNDpC/ucpjCVlBUn
         9pWjtt1Bf36fAoQ+vTSOUKXLCPk+FkejLDMKQKDPPpsdoKlUPEsy3SAqgJjW2u8wJ8n3
         7CuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FYWwENwhD0QpX1bHTVokEE+o8fXxR6ouv90UAH4he4g=;
        b=VARsdJCeG2NCr9uBnuYhHIN45xyN8ZL4pXLVVGPiQNbLyaUUIi8esy5M5X6l5B7DEd
         0VRJigkd1k6eVSGp/YzKBfeSH5AWbL2MGFCWuORizcXXN/YsTT3G3w+IlvXuZGW1+cht
         hvD0dev1Bq7xI3hoDY1nz6il1j6m5AFBgEgv7HwBydggGwR50Z9hJVuFxfTnWhy+bTtD
         seLTXO6Tn+WjpVoDyRrtr7wBiPeOZZRa4soIKEFM4yuY0AxufO1Nvr8uP8PqKVgmIm7i
         ZoOj3JhKzkvqkvePNpXgJLfAcexOGV8C02hclwiZaf9T446mbbIwOzkC8/P6KL084Jdl
         QfRw==
X-Gm-Message-State: AOAM533cZ4u4Hlx7B21f4k9pd4MVZLpmWUARwS1HWhX/3UTf5Kv/XSPL
        cjQMZJsxkk/U/ny2OHxm1k5tayN/0wFj9g==
X-Google-Smtp-Source: ABdhPJz6VJ1g3I5N5a13s5cLRZFMBnNSlcHoCOh4tnT7KKTHZCP45DnapUVBUVvknmKrOw3soVSNRQ==
X-Received: by 2002:a19:22d6:: with SMTP id i205mr9285200lfi.50.1592817702141;
        Mon, 22 Jun 2020 02:21:42 -0700 (PDT)
Received: from centos7-pv-guest.localdomain ([5.35.13.201])
        by smtp.gmail.com with ESMTPSA id w17sm3048028ljj.108.2020.06.22.02.21.41
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jun 2020 02:21:41 -0700 (PDT)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     brouer@redhat.com, jgross@suse.com, wei.liu@kernel.org,
        paul@xen.org, ilias.apalodimas@linaro.org
Subject: [PATCH net-next v10 3/3] xen networking: add XDP offset adjustment to xen-netback
Date:   Mon, 22 Jun 2020 12:21:12 +0300
Message-Id: <1592817672-2053-4-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
References: <1592817672-2053-1-git-send-email-kda@linux-powerpc.org>
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
 drivers/net/xen-netback/xenbus.c    | 32 ++++++++++++++++++++++++++++++++
 5 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/drivers/net/xen-netback/common.h b/drivers/net/xen-netback/common.h
index 05847eb..f14dc10 100644
--- a/drivers/net/xen-netback/common.h
+++ b/drivers/net/xen-netback/common.h
@@ -281,6 +281,9 @@ struct xenvif {
 	u8 ipv6_csum:1;
 	u8 multicast_control:1;
 
+	/* headroom requested by xen-netfront */
+	u16 netfront_xdp_headroom;
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
index 0c8a02a..fc16edd 100644
--- a/drivers/net/xen-netback/interface.c
+++ b/drivers/net/xen-netback/interface.c
@@ -483,6 +483,8 @@ struct xenvif *xenvif_alloc(struct device *parent, domid_t domid,
 	vif->queues = NULL;
 	vif->num_queues = 0;
 
+	vif->netfront_xdp_headroom = 0;
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
index ef58870..c5e9e14 100644
--- a/drivers/net/xen-netback/rx.c
+++ b/drivers/net/xen-netback/rx.c
@@ -258,6 +258,19 @@ static void xenvif_rx_next_skb(struct xenvif_queue *queue,
 		pkt->extra_count++;
 	}
 
+	if (queue->vif->netfront_xdp_headroom) {
+		struct xen_netif_extra_info *extra;
+
+		extra = &pkt->extras[XEN_NETIF_EXTRA_TYPE_XDP - 1];
+
+		memset(extra, 0, sizeof(struct xen_netif_extra_info));
+		extra->u.xdp.headroom = queue->vif->netfront_xdp_headroom;
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
+	unsigned int offset = queue->vif->netfront_xdp_headroom;
 	unsigned int flags;
 
 	do {
diff --git a/drivers/net/xen-netback/xenbus.c b/drivers/net/xen-netback/xenbus.c
index 286054b..c67abc5 100644
--- a/drivers/net/xen-netback/xenbus.c
+++ b/drivers/net/xen-netback/xenbus.c
@@ -393,6 +393,22 @@ static void set_backend_state(struct backend_info *be,
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
+			   "netfront-xdp-headroom", "%hu", &headroom);
+	if (err < 0) {
+		vif->netfront_xdp_headroom = 0;
+		return;
+	}
+	vif->netfront_xdp_headroom = headroom;
+}
+
 /**
  * Callback received when the frontend's state changes.
  */
@@ -417,6 +433,11 @@ static void frontend_changed(struct xenbus_device *dev,
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
@@ -947,6 +968,8 @@ static int read_xenbus_vif_flags(struct backend_info *be)
 	vif->ipv6_csum = !!xenbus_read_unsigned(dev->otherend,
 						"feature-ipv6-csum-offload", 0);
 
+	read_xenbus_frontend_xdp(be, dev);
+
 	return 0;
 }
 
@@ -1036,6 +1059,15 @@ static int netback_probe(struct xenbus_device *dev,
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

