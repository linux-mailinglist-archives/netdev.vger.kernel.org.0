Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125973DD6FF
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhHBNYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233862AbhHBNYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:24:39 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A7B6C06175F;
        Mon,  2 Aug 2021 06:24:30 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id c9so1217415wri.8;
        Mon, 02 Aug 2021 06:24:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=050+77Lvmakbmg/oW8vuJtJ6Uj/giiIJA4LvjifrVT8=;
        b=up/b+kBJXeCZVYKelCpuTk2HjoqXZfULiDOVncoLuQiLfxBeV1Hr40/ObEB46XnyYd
         oQneJcJwh6eAyTsLRgFFi0hQ2RQCL4wP0N3aMn5Br7UFrEmgKIbH6DMZJTqp5nj9x3He
         RkY5KzncHhFGTqWiWUmNTxHmJzpe475DbPkDk25e8KBdf6tUpUFLCWZe3Uetx7e2cBQl
         SqiLSFrMfeKO2zq0pOX3Z9e1euSPV84SYvV28mxbWR1CfdTLBT1QnpsvQepO56yY9J32
         o/wmw1mdy7UPuNQ+4vjcq4tsC3WHAA8p2Ar8/bEjVMUhz1vA6iAe/aBUeV44hiZ73PSp
         GZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=050+77Lvmakbmg/oW8vuJtJ6Uj/giiIJA4LvjifrVT8=;
        b=Phpzeg7TP/qwprxwMqm4w5syeDEIQhnU8FBJIVzx47r6oM4yCGQVdXBVPiDCpx0qDy
         gj/KmQnkEeMM6BQBybIpJza8t/iOXtBssrZvs3y4dBNOuytdO3T45m0p9MOdWro8AE8J
         WWDSoHy1MNemcQJfn8BkQXPdCJI8O8tjbVddwiCGi5XG4XcvofatbkqV0wdnTzNJvD6J
         8kSFz1r/PhSlxqGY6896zVdXvKImrdrJga/nY4vYtIEHOQRCH3XzqhbZfSR4BfziC89U
         kY+HUIFfxRjxB6PXO1aNhvvpJejIBk7QB9Uhc9ENc6MZN0p+j2dOzuh/Hm1OdxilswcK
         9qaw==
X-Gm-Message-State: AOAM531Q/WnGBnuMBWcZwurejhM+irtmFgXf84tmjuEYWCZgbyP0LqCx
        y6mH/tQ3WR24gpQ5htaFpK4ChgrEJtpVoQI=
X-Google-Smtp-Source: ABdhPJyXnuMKePVXTRjAWf/BLnFIqdeHkOn4aTn/7+hF3jmRXHxr2RyRVVjnbTZypO+swXGybSsm8A==
X-Received: by 2002:adf:8169:: with SMTP id 96mr17295593wrm.424.1627910668783;
        Mon, 02 Aug 2021 06:24:28 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id o28sm11731404wra.71.2021.08.02.06.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:24:28 -0700 (PDT)
From:   joamaki@gmail.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v4 2/6] net: core: Add support for XDP redirection to slave device
Date:   Wed, 28 Jul 2021 23:43:46 +0000
Message-Id: <20210728234350.28796-3-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728234350.28796-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210728234350.28796-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

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
 net/core/dev.c            |  8 +++++++-
 net/core/filter.c         | 25 +++++++++++++++++++++++++
 4 files changed, 50 insertions(+), 2 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index ba36989f711a..7ea1cc378042 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -761,6 +761,10 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 
 DECLARE_BPF_DISPATCHER(xdp)
 
+DECLARE_STATIC_KEY_FALSE(bpf_master_redirect_enabled_key);
+
+u32 xdp_master_redirect(struct xdp_buff *xdp);
+
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
@@ -768,7 +772,14 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
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
index 42f6f866d5f3..a380786429e1 100644
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
@@ -4071,6 +4076,7 @@ typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 		      int fd, int expected_fd, u32 flags);
 int bpf_xdp_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
+u8 dev_xdp_prog_count(struct net_device *dev);
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
diff --git a/net/core/dev.c b/net/core/dev.c
index 3ee58876e8f5..99cb14242164 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9353,7 +9353,7 @@ static struct bpf_prog *dev_xdp_prog(struct net_device *dev,
 	return dev->xdp_state[mode].prog;
 }
 
-static u8 dev_xdp_prog_count(struct net_device *dev)
+u8 dev_xdp_prog_count(struct net_device *dev)
 {
 	u8 count = 0;
 	int i;
@@ -9363,6 +9363,7 @@ static u8 dev_xdp_prog_count(struct net_device *dev)
 			count++;
 	return count;
 }
+EXPORT_SYMBOL_GPL(dev_xdp_prog_count);
 
 u32 dev_xdp_prog_id(struct net_device *dev, enum bpf_xdp_mode mode)
 {
@@ -9486,6 +9487,11 @@ static int dev_xdp_attach(struct net_device *dev, struct netlink_ext_ack *extack
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
index faf29fd82276..ff62cd39046d 100644
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
2.17.1

