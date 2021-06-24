Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9013B2B40
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhFXJVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231603AbhFXJVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:21:17 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89B8FC061760;
        Thu, 24 Jun 2021 02:18:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id d11so5871795wrm.0;
        Thu, 24 Jun 2021 02:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vS8g0zj6zL+KuMBhQFf8+phEIPa45AKdG3rxwIAoGNY=;
        b=JgSYzc3lOUjQ+ah0z8tOMZNyrQDD1F+1nxmKMl+4zydpttRnPbUXPEtTcAOsFKu0tx
         Qc+3Gs6RiiEGDARD0CyOUnKV9yFyjSj5uEMishglmQzfkl5re7KRwU71FtYQgWVtrfFG
         WbXlx1rmYkegFED8o8Pl97sSse9c/qr4SuGiPDbuNyNY1yQwDFMmtG1SLTM6bEtivDoW
         5jvAf38ZjlY3aKT0ffjSawMxSKmUpqppZA6OwB16WcHOHOnZgEAa3U703gg7FGzA+mo5
         TECJE6FF5/SIKbwvzp0K0L1dqvy/691ElKQrr/0qtb6GVQA1rTKI3rwhDjgXFxqRBozq
         TLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vS8g0zj6zL+KuMBhQFf8+phEIPa45AKdG3rxwIAoGNY=;
        b=o1DzrW2fod1bCaDmUc5wbIdhgTc0s/OUcsMqEs8vGgVHTPTHaCVrBV0W4OhYLxI8b2
         qkBWgYhazW8KMRQE1fSa1Ceiu87kujUqRv1uUk9fSR20y78HtDeZzFSNXCGXbx4NEGu+
         juKXVzIE34KXhVfCdqzxxR0d5MGKtWjD4hcHfJ+cicAa+qLFyZNedRh289FKLZg3/gku
         NBH1synJF2SIFhW5myhUJoDbO+bbggxq8gh4FSAoA9eIzir04m1WogzxS9fJjX99D8Sd
         I6kfsV6OLntTpV2p9jjbU5PEBce+T1MLJFDMD/NR4Lqq3jBrNGkAZFBacz6B3AtH+DuK
         7HKQ==
X-Gm-Message-State: AOAM531qTfvCxFrnd28c6ndQlcCH0iOC4AK4nH2KPhB27bTH5VWfLFlM
        JlZEEqHXF7pmoWzCktDRZw/jstz6Dnxp0W0=
X-Google-Smtp-Source: ABdhPJx7XSoRy4JfwINT/RVetdLoo3Bw2yJvfDws93WZkVTe6eXcPoZhLg66ViVfBRi3yTYk9DHoAQ==
X-Received: by 2002:a5d:6c64:: with SMTP id r4mr3276737wrz.316.1624526336859;
        Thu, 24 Jun 2021 02:18:56 -0700 (PDT)
Received: from localhost.localdomain (212-51-151-130.fiber7.init7.net. [212.51.151.130])
        by smtp.gmail.com with ESMTPSA id r1sm2456216wmh.32.2021.06.24.02.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 02:18:56 -0700 (PDT)
From:   joamaki@gmail.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v2 2/4] net: core: Add support for XDP redirection to slave device
Date:   Thu, 24 Jun 2021 09:18:41 +0000
Message-Id: <20210624091843.5151-3-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210624091843.5151-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210624091843.5151-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

This adds the ndo_xdp_get_xmit_slave hook for transforming XDP_TX
into XDP_REDIRECT after BPF program run when the ingress device
is a bond slave.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 include/linux/filter.h    | 13 ++++++++++++-
 include/linux/netdevice.h |  5 +++++
 net/core/filter.c         | 25 +++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index c5ad7df029ed..752ba6a474a4 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -760,6 +760,10 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 
 DECLARE_BPF_DISPATCHER(xdp)
 
+DECLARE_STATIC_KEY_FALSE(bpf_master_redirect_enabled_key);
+
+u32 xdp_master_redirect(struct xdp_buff *xdp);
+
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
@@ -769,7 +773,14 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
-	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+	u32 act = __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+
+	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
+		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
+			act = xdp_master_redirect(xdp);
+	}
+
+	return act;
 }
 
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..1a6cc6356498 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1321,6 +1321,9 @@ struct netdev_net_notifier {
  *	that got dropped are freed/returned via xdp_return_frame().
  *	Returns negative number, means general error invoking ndo, meaning
  *	no frames were xmit'ed and core-caller will free all frames.
+ * struct net_device *(*ndo_xdp_get_xmit_slave)(struct net_device *dev,
+ *					        struct xdp_buff *xdp);
+ *      Get the xmit slave of master device based on the xdp_buff.
  * int (*ndo_xsk_wakeup)(struct net_device *dev, u32 queue_id, u32 flags);
  *      This function is used to wake up the softirq, ksoftirqd or kthread
  *	responsible for sending and/or receiving packets on a specific
@@ -1539,6 +1542,8 @@ struct net_device_ops {
 	int			(*ndo_xdp_xmit)(struct net_device *dev, int n,
 						struct xdp_frame **xdp,
 						u32 flags);
+	struct net_device *	(*ndo_xdp_get_xmit_slave)(struct net_device *dev,
+							  struct xdp_buff *xdp);
 	int			(*ndo_xsk_wakeup)(struct net_device *dev,
 						  u32 queue_id, u32 flags);
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
diff --git a/net/core/filter.c b/net/core/filter.c
index caa88955562e..3c20edb0a0ff 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3947,6 +3947,31 @@ void bpf_clear_redirect_map(struct bpf_map *map)
 	}
 }
 
+DEFINE_STATIC_KEY_FALSE(bpf_master_redirect_enabled_key);
+EXPORT_SYMBOL_GPL(bpf_master_redirect_enabled_key);
+
+u32 xdp_master_redirect(struct xdp_buff *xdp)
+{
+	struct net_device *master, *slave;
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	master = netdev_master_upper_dev_get_rcu(xdp->rxq->dev);
+	slave = master->netdev_ops->ndo_xdp_get_xmit_slave(master, xdp);
+	if (slave && slave != xdp->rxq->dev) {
+		/* The target device is different from the receiving device, so
+		 * redirect it to the new device.
+		 * Using XDP_REDIRECT gets the correct behaviour from XDP enabled
+		 * drivers to unmap the packet from their rx ring.
+		 */
+		ri->tgt_index = slave->ifindex;
+		ri->map_id = INT_MAX;
+		ri->map_type = BPF_MAP_TYPE_UNSPEC;
+		return XDP_REDIRECT;
+	}
+	return XDP_TX;
+}
+EXPORT_SYMBOL_GPL(xdp_master_redirect);
+
 int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		    struct bpf_prog *xdp_prog)
 {
-- 
2.27.0

