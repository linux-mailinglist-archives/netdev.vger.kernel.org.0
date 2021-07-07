Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB3FB3BE8A0
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231748AbhGGNQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbhGGNQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:16:31 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3117C061574;
        Wed,  7 Jul 2021 06:13:49 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id n14so3973068lfu.8;
        Wed, 07 Jul 2021 06:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GWFQPZdk6tgSx4CMjQNACsarfDXRdB/FboAGk1SQ38c=;
        b=RwIiLF7sIBdjS7Wfxt1T3vsh9oNDHFhfVdtSNNCNnA6jWpD3GbgPKGKSvBQQMz/nqK
         C27KObtRpbOY3WRp/I0KIRZRSEwrnmfCRUx19A9MZoRI412o08/o2InENuBUUM4sC4rL
         JjLIz2AYefLSHPKtjXig1Tl9XENxABqIGPTrcJUbyuwvLX49pGK3Cu5/oSZBsieSQrHC
         fuu0xAJU2yip5c2meHUsMC/jfmeaZgBO3bWzsR3QruKRJCkr+i49V3xm/2/IqZphjdZt
         aXrR5eVkBp4GASttuFrLwC47Sw3wa0s/aAmGIoHgLCzHR4TjCR0YZE/uFccv2fDR6ogZ
         fCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GWFQPZdk6tgSx4CMjQNACsarfDXRdB/FboAGk1SQ38c=;
        b=o3mUMysTt5GdYvfilo5lAk1UMOqLPKHYUFjrXHLsMejQPIeN7xMHW6k/X7K0/nn3lb
         S9GDAoCXCD755sBoqLBhsCnSBtC2ZDnAhD0azz02RuYgqtMHdI/78sSU5fpIxY8tjdsX
         JUxaNKJcXacvWKhCrmAdDOH8iOLTaK0VlU7bCEbZtave2VtChATkLRUFfgsD2pN6+TMB
         dXQvkaEyrzZPBAme9XZpUfrJK6XaX8C0lVTtxDIOb/SZSPGNa2oMP2ANszyIbjf4xiJn
         wjJKO7fBsVVreBrJwesyAyoQLE6CQXwslbHBbuE/DBrWxxGDnf+JT3zhug92RTd4gKoz
         +qww==
X-Gm-Message-State: AOAM532hn9QlaIpzEKRiy/2YCt5vDAkhG09ieeW3J++vlizvu5pNtEce
        9sU+PEDD5VY+w6cAsoCKDN9miFu16wCY85st9Q==
X-Google-Smtp-Source: ABdhPJxqOYHxSlxumI+Qz9oa2KWDNowTYmmYM9tqJV0snz2+y7DYSeKB9qjnoQw+a9XLDtbYwBgJIw==
X-Received: by 2002:a19:e04a:: with SMTP id g10mr19238059lfj.561.1625663627953;
        Wed, 07 Jul 2021 06:13:47 -0700 (PDT)
Received: from localhost.localdomain ([89.42.43.188])
        by smtp.gmail.com with ESMTPSA id u9sm1423571lfm.127.2021.07.07.06.13.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:13:47 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v3 2/5] net: core: Add support for XDP redirection to slave device
Date:   Wed,  7 Jul 2021 11:25:48 +0000
Message-Id: <20210707112551.9782-3-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707112551.9782-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210707112551.9782-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds the ndo_xdp_get_xmit_slave hook for transforming XDP_TX
into XDP_REDIRECT after BPF program run when the ingress device
is a bond slave.

The dev_xdp_prog_count is exposed so that slave devices can be checked
for loaded XDP programs in order to avoid the situation where both
bond master and slave have programs loaded according to xdp_state.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 include/linux/filter.h    | 13 ++++++++++++-
 include/linux/netdevice.h |  6 ++++++
 net/core/dev.c            |  9 ++++++++-
 net/core/filter.c         | 25 +++++++++++++++++++++++++
 4 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 472f97074da0..63b426c58a45 100644
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
@@ -767,7 +771,14 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 * under local_bh_disable(), which provides the needed RCU protection
 	 * for accessing map entries.
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
index eaf5bb008aa9..d3b1d882d6fa 100644
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
@@ -4069,6 +4074,7 @@ typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, int expected_fd, u32 flags);
 int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
+u8 dev_xdp_prog_count(struct net_device *dev);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2aafe97..05aac85b2bbc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9334,7 +9334,7 @@ static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
 	return dev->xdp_state[mode].prog;
 }
 
-static u8 dev_xdp_prog_count(struct net_device *dev)
+u8 dev_xdp_prog_count(struct net_device *dev)
 {
 	u8 count = 0;
 	int i;
@@ -9344,6 +9344,7 @@ static u8 dev_xdp_prog_count(struct net_device *dev)
 			count++;
 	return count;
 }
+EXPORT_SYMBOL_GPL(dev_xdp_prog_count);
 
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
 {
@@ -9379,6 +9380,7 @@ static int dev_xdp_install(struct net_device *dev, enum bpf_xdp_mode mode,
 	xdp.flags = flags;
 	xdp.prog = prog;
 
+
 	/* Drivers assume refcnt is already incremented (i.e, prog pointer is
 	 * "moved" into driver), so they don't increment it on their own, but
 	 * they do decrement refcnt when program is detached or replaced.
@@ -9467,6 +9469,11 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
 		NL_SET_ERR_MSG(extack, "XDP_FLAGS_REPLACE is not specified");
 		return -EINVAL;
 	}
+	/* don't allow loading XDP programs to a bonded device */
+	if (netif_is_bond_slave(dev)) {
+		NL_SET_ERR_MSG(extack, "XDP program can not be attached to a bond slave");
+		return -EINVAL;
+	}
 
 	mode = dev_xdp_mode(dev, flags);
 	/* can't replace attached link */
diff --git a/net/core/filter.c b/net/core/filter.c
index d70187ce851b..10b12577f71d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3950,6 +3950,31 @@ void bpf_clear_redirect_map(struct bpf_map *map)
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

