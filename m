Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C02691612A0
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 14:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgBQNEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 08:04:43 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36390 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgBQNEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 08:04:42 -0500
Received: by mail-lj1-f193.google.com with SMTP id r19so18770217ljg.3
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 05:04:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-powerpc-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=6hOeyZrMKgFHOZbYX5UAnYovJ8ELr43TsqrRy8rHPkc=;
        b=uNnqmGyrHh02I1JyGWNRDNLo0QFdUCaTDXbSBeH3A31Z6bzIIFCSVkoO3R2h2+VV1X
         x/VF/rQmDTQYV3wgJlZP1Je5PSKTFuoODgXojkW+jBSoDfIIuiTpKuj5N+qcHG/C+5Dw
         QH2O4VVjcX6aJ/CBrqp9tzxzlvXHl6fZ9TFKdsusUOB7lxSYP7ZX39TmH+CvH8vu11LC
         Vc3qbn7A9oi7OHdPToIblIhKrimWynwnJQ/7K3l0+qRKW7uF+40npM+Djyr0/tET8ugg
         WQ5NJ7Lic4SH0wtEcovyIzhKWPCnxzPV1mSwBh3Bj8OaRPiul7Xb2LDgBabXVzrYzKUF
         dMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6hOeyZrMKgFHOZbYX5UAnYovJ8ELr43TsqrRy8rHPkc=;
        b=aOAb0v3wybUC9b3iaXfjBRxtBRH2LhQoPLwnhERK4UgqPVglORIN7iUpN9AruQYJ1S
         CnnKgRncK7SZTeqjkvHhkzKaFRPVQhO/Hu56Ma5ZUoCxdMGtAhwLlEyjgSAwl7EiqccG
         D5lZ5ItfmBrhsPs00E+c+ZcIqboPgt3FNISfF+UVDWtO/6vWGvrW76+WjYqhOxOf4qD5
         V4nZkkhFYxYVB/ErbDDEaGXwDH4zZXQp5xUHT+O+VHRhWd7R4Xr9olErjHWlDq3S5sMV
         aQVYy2dFNlTXbTMmTF6CyLE69sxbP6ut4DtV+IWmycCGMyFPj3H6EDCkHJGZbMZi1xee
         PE0w==
X-Gm-Message-State: APjAAAV5xAS4vMJYXkfdeiAscL2fCzTWawwl+DhaPMapXRpjxQteD7kh
        hFeAuSCCgI46a5A+myy4uH5fDCq6SlQ=
X-Google-Smtp-Source: APXvYqyJazYerQxgwEzZ/EdKfRnGnyiHRhIL9in1riWf+YddMf7D2MhQFJzh17/2X3YDYGgjVraE7w==
X-Received: by 2002:a2e:b0c4:: with SMTP id g4mr9993816ljl.83.1581944679095;
        Mon, 17 Feb 2020 05:04:39 -0800 (PST)
Received: from centos7-pv-guest.localdomain ([5.35.99.143])
        by smtp.gmail.com with ESMTPSA id w9sm355821ljh.106.2020.02.17.05.04.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Feb 2020 05:04:38 -0800 (PST)
From:   Denis Kirjanov <kda@linux-powerpc.org>
To:     netdev@vger.kernel.org
Cc:     Denis Kirjanov <kda@linux-powerpc.org>
Subject: [PATCH net-next] xen-netfront: add basic XDP support
Date:   Mon, 17 Feb 2020 16:04:17 +0300
Message-Id: <1581944657-13384-1-git-send-email-kda@linux-powerpc.org>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the patch adds a basic xdp logic to the netfront driver

Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
---
 drivers/net/xen-netfront.c | 125 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 125 insertions(+)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 482c6c8..06dd088 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -44,6 +44,8 @@
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <net/ip.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
 
 #include <xen/xen.h>
 #include <xen/xenbus.h>
@@ -102,6 +104,8 @@ struct netfront_queue {
 	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
 	struct netfront_info *info;
 
+	struct bpf_prog __rcu *xdp_prog;
+
 	struct napi_struct napi;
 
 	/* Split event channels support, tx_* == rx_* when using
@@ -778,6 +782,53 @@ static int xennet_get_extras(struct netfront_queue *queue,
 	return err;
 }
 
+u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
+		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
+		   struct xdp_buff *xdp)
+{
+	void *data = page_address(pdata);
+	u32 len = rx->status;
+	struct page *page = NULL;
+	u32 act = XDP_PASS;
+
+	page = alloc_page(GFP_ATOMIC);
+	if (!page) {
+		act = XDP_DROP;
+		goto out;
+	}
+
+	xdp->data_hard_start = page_address(page);
+	xdp->data = xdp->data_hard_start + 256;
+	xdp_set_data_meta_invalid(xdp);
+	xdp->data_end = xdp->data + len;
+	xdp->handle = 0;
+
+	memcpy(xdp->data, data, len);
+
+	act = bpf_prog_run_xdp(prog, xdp);
+	switch (act) {
+	case XDP_PASS:
+	case XDP_TX:
+	case XDP_DROP:
+		break;
+
+	case XDP_ABORTED:
+		trace_xdp_exception(queue->info->netdev, prog, act);
+		break;
+
+	default:
+		bpf_warn_invalid_xdp_action(act);
+	}
+
+out:
+	if (page && act != XDP_PASS && act != XDP_TX) {
+		__free_page(page);
+		xdp->data_hard_start = NULL;
+	}
+
+	return act;
+}
+
 static int xennet_get_responses(struct netfront_queue *queue,
 				struct netfront_rx_info *rinfo, RING_IDX rp,
 				struct sk_buff_head *list)
@@ -792,6 +843,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
 	int slots = 1;
 	int err = 0;
 	unsigned long ret;
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	u32 verdict;
 
 	if (rx->flags & XEN_NETRXF_extra_info) {
 		err = xennet_get_extras(queue, extras, rp);
@@ -827,6 +881,21 @@ static int xennet_get_responses(struct netfront_queue *queue,
 
 		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
 
+		rcu_read_lock();
+		xdp_prog = rcu_dereference(queue->xdp_prog);
+		if (xdp_prog) {
+			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
+			verdict = xennet_run_xdp(queue,
+				       skb_frag_page(&skb_shinfo(skb)->frags[0]),
+				       rx, xdp_prog, &xdp);
+
+			if (verdict != XDP_PASS && verdict != XDP_TX) {
+				err = -EINVAL;
+				goto next;
+			}
+
+		}
+		rcu_read_unlock();
 		__skb_queue_tail(list, skb);
 
 next:
@@ -1261,6 +1330,61 @@ static void xennet_poll_controller(struct net_device *dev)
 }
 #endif
 
+static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
+			struct netlink_ext_ack *extack)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	struct bpf_prog *old_prog;
+	unsigned int i;
+
+	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
+	if (!old_prog && !prog)
+		return 0;
+
+	if (prog)
+		bpf_prog_add(prog, dev->real_num_tx_queues);
+
+	for (i = 0; i < dev->real_num_tx_queues; ++i)
+		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
+
+	if (old_prog)
+		for (i = 0; i < dev->real_num_tx_queues; ++i)
+			bpf_prog_put(old_prog);
+
+	return 0;
+}
+
+static u32 xennet_xdp_query(struct net_device *dev)
+{
+	struct netfront_info *np = netdev_priv(dev);
+	unsigned int num_queues = dev->real_num_tx_queues;
+	unsigned int i;
+	struct netfront_queue *queue;
+	const struct bpf_prog *xdp_prog;
+
+	for (i = 0; i < num_queues; ++i) {
+		queue = &np->queues[i];
+		xdp_prog = rtnl_dereference(queue->xdp_prog);
+		if (xdp_prog)
+			return xdp_prog->aux->id;
+	}
+
+	return 0;
+}
+
+static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return xennet_xdp_set(dev, xdp->prog, xdp->extack);
+	case XDP_QUERY_PROG:
+		xdp->prog_id = xennet_xdp_query(dev);
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
 static const struct net_device_ops xennet_netdev_ops = {
 	.ndo_open            = xennet_open,
 	.ndo_stop            = xennet_close,
@@ -1272,6 +1396,7 @@ static void xennet_poll_controller(struct net_device *dev)
 	.ndo_fix_features    = xennet_fix_features,
 	.ndo_set_features    = xennet_set_features,
 	.ndo_select_queue    = xennet_select_queue,
+	.ndo_bpf            = xennet_xdp,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = xennet_poll_controller,
 #endif
-- 
1.8.3.1

