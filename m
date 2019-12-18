Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A1D5124123
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 09:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfLRIMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 03:12:17 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33295 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfLRIMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 03:12:17 -0500
Received: by mail-pg1-f193.google.com with SMTP id 6so869186pgk.0
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 00:12:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fdrg7pXIFdmkZXBXqqGPFpoVsvu4bx6CHYx/j0Dy2RE=;
        b=vKkbxOtQZi617+I9UDYWxOKiIP7NMuEZ/RVkg6YoSXEvtO+PQ/MQbT+68v9WE3a/I2
         4kH2XyBPgUJ8jn/40HbXYfQTIfxErWhVt5B9BNu5tTeVrRLs8rd/Oi0n29WglRJvJVdY
         Z/qdAul2U9xXn0QEI6ULzn91lMh0U2RGBwUm/ZX3ajkZ5uIhFd1bOp0e14+0KTrRd7xs
         L37o5zJGU1s68DfW0JsvUbA4FpgdxJ+ztTKqANhbEv+qqW1IQmFAvwO5J0+acNdPr+VI
         qkwH8SLARFrPyg8hIPu9UFXYwX6HcUAT7zKDhyPY4ap+hmD5Tt1WwHrgU9+4/SjgGrw1
         afCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fdrg7pXIFdmkZXBXqqGPFpoVsvu4bx6CHYx/j0Dy2RE=;
        b=FXH3ebH0OMSe+o1AliqnFINa7r0MmLgB1oj7A4OT/TJ9ggBDAyStvstFaiLqCPJaPd
         iVSUDs8SGttImCfPhVUJVaK39KAVWnHkMX8Cbj1oVLLoc2QkYCI0VNQUlshLjCGAv/Uh
         AT9PR1Es2MN4PrNaqd+S+TExHflgWZFi20nGWL/Ay40R6dwv4GwK6atYoD3uOPWi0r2b
         xde9CW9cVdlH2ecyR4iSrmaKACPBR0GloQpbIUa6MGYIPVMY7mEssU6eVMtG2JRvrMAZ
         ubUtLdC3QgsRDf7YkFwg3Zz2mE4jd630tBdbAeVS6uprKF4UqpRAucsTNVuHQs/xX67B
         /y9Q==
X-Gm-Message-State: APjAAAX90bQmvaKM6wJhAYMRdRz5GyuQnuRGkpniuOz9puAehRqKqbSE
        pcFiF899EaI3eWTa+2OEPlA=
X-Google-Smtp-Source: APXvYqz+8LqndK9e4rbZUiJhuPzcklXhmIdQG+yGkQqMIrAjBn/sOU64f7iF+rXo8xhGPP62wNa1+w==
X-Received: by 2002:a63:f901:: with SMTP id h1mr1570294pgi.445.1576656736718;
        Wed, 18 Dec 2019 00:12:16 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s1sm1799181pgv.87.2019.12.18.00.12.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 00:12:16 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Cc:     David Ahern <dahern@digitalocean.com>,
        Jason Wang <jasowang@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 01/14] net: add tx path XDP support
Date:   Wed, 18 Dec 2019 17:10:37 +0900
Message-Id: <20191218081050.10170-2-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
References: <20191218081050.10170-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dahern@digitalocean.com>

Add a way to run XDP program in tx path. Drivers those want to support
tx path XDP needs to handle XDP_SETUP_PROG_TX and XDP_QUERY_PROG_TX
cases in their ndo_bpf handler.

Signed-off-by: David Ahern <dahern@digitalocean.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 include/linux/netdevice.h    |   4 +-
 include/uapi/linux/if_link.h |   1 +
 net/core/dev.c               |  31 +++++++---
 net/core/rtnetlink.c         | 112 ++++++++++++++++++++++++++++++++++-
 4 files changed, 137 insertions(+), 11 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 30745068fb39..7b5256d374d2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -864,8 +864,10 @@ enum bpf_netdev_command {
 	 */
 	XDP_SETUP_PROG,
 	XDP_SETUP_PROG_HW,
+	XDP_SETUP_PROG_TX,
 	XDP_QUERY_PROG,
 	XDP_QUERY_PROG_HW,
+	XDP_QUERY_PROG_TX,
 	/* BPF program for offload callbacks, invoked at program load time. */
 	BPF_OFFLOAD_MAP_ALLOC,
 	BPF_OFFLOAD_MAP_FREE,
@@ -3724,7 +3726,7 @@ struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 
 typedef int (*bpf_op_t)(struct net_device *dev, struct netdev_bpf *bpf);
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags);
+		      int fd, u32 flags, bool tx);
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t xdp_op,
 		    enum bpf_netdev_command cmd);
 int xdp_umem_query(struct net_device *dev, u16 queue_id);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 1d69f637c5d6..be97c9787140 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -170,6 +170,7 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_XDP_TX,
 	__IFLA_MAX
 };
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 2c277b8aba38..a46db72759cf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8540,7 +8540,7 @@ u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
 
 static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 			   struct netlink_ext_ack *extack, u32 flags,
-			   struct bpf_prog *prog)
+			   struct bpf_prog *prog, bool tx)
 {
 	struct netdev_bpf xdp;
 
@@ -8548,7 +8548,8 @@ static int dev_xdp_install(struct net_device *dev, bpf_op_t bpf_op,
 	if (flags & XDP_FLAGS_HW_MODE)
 		xdp.command = XDP_SETUP_PROG_HW;
 	else
-		xdp.command = XDP_SETUP_PROG;
+		xdp.command = tx ? XDP_SETUP_PROG_TX : XDP_SETUP_PROG;
+
 	xdp.extack = extack;
 	xdp.flags = flags;
 	xdp.prog = prog;
@@ -8562,7 +8563,8 @@ static void dev_xdp_uninstall(struct net_device *dev)
 	bpf_op_t ndo_bpf;
 
 	/* Remove generic XDP */
-	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL));
+	WARN_ON(dev_xdp_install(dev, generic_xdp_install, NULL, 0, NULL,
+				false));
 
 	/* Remove from the driver */
 	ndo_bpf = dev->netdev_ops->ndo_bpf;
@@ -8574,14 +8576,21 @@ static void dev_xdp_uninstall(struct net_device *dev)
 	WARN_ON(ndo_bpf(dev, &xdp));
 	if (xdp.prog_id)
 		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
-					NULL));
+					NULL, false));
 
 	/* Remove HW offload */
 	memset(&xdp, 0, sizeof(xdp));
 	xdp.command = XDP_QUERY_PROG_HW;
 	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
 		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
-					NULL));
+					NULL, false));
+
+	/* Remove HW offload */
+	memset(&xdp, 0, sizeof(xdp));
+	xdp.command = XDP_QUERY_PROG_TX;
+	if (!ndo_bpf(dev, &xdp) && xdp.prog_id)
+		WARN_ON(dev_xdp_install(dev, ndo_bpf, NULL, xdp.prog_flags,
+					NULL, true));
 }
 
 /**
@@ -8594,7 +8603,7 @@ static void dev_xdp_uninstall(struct net_device *dev)
  *	Set or clear a bpf program for a device
  */
 int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
-		      int fd, u32 flags)
+		      int fd, u32 flags, bool tx)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
 	enum bpf_netdev_command query;
@@ -8606,7 +8615,10 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	ASSERT_RTNL();
 
 	offload = flags & XDP_FLAGS_HW_MODE;
-	query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
+	if (tx)
+		query = XDP_QUERY_PROG_TX;
+	else
+		query = offload ? XDP_QUERY_PROG_HW : XDP_QUERY_PROG;
 
 	bpf_op = bpf_chk = ops->ndo_bpf;
 	if (!bpf_op && (flags & (XDP_FLAGS_DRV_MODE | XDP_FLAGS_HW_MODE))) {
@@ -8621,7 +8633,8 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 	if (fd >= 0) {
 		u32 prog_id;
 
-		if (!offload && __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
+		if (!offload && !tx &&
+		    __dev_xdp_query(dev, bpf_chk, XDP_QUERY_PROG)) {
 			NL_SET_ERR_MSG(extack, "native and generic XDP can't be active at the same time");
 			return -EEXIST;
 		}
@@ -8653,7 +8666,7 @@ int dev_change_xdp_fd(struct net_device *dev, struct netlink_ext_ack *extack,
 			return 0;
 	}
 
-	err = dev_xdp_install(dev, bpf_op, extack, flags, prog);
+	err = dev_xdp_install(dev, bpf_op, extack, flags, prog, tx);
 	if (err < 0 && prog)
 		bpf_prog_put(prog);
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 20bc406f3871..9dc4b2547f62 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1395,6 +1395,36 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
+static u32 rtnl_xdp_tx_prog_drv(struct net_device *dev)
+{
+	return __dev_xdp_query(dev, dev->netdev_ops->ndo_bpf,
+			       XDP_QUERY_PROG_TX);
+}
+
+static int rtnl_xdp_tx_report_one(struct sk_buff *skb, struct net_device *dev,
+				  u32 *prog_id, u8 *mode, u8 tgt_mode, u32 attr,
+				  u32 (*get_prog_id)(struct net_device *dev))
+{
+	u32 curr_id;
+	int err;
+
+	curr_id = get_prog_id(dev);
+	if (!curr_id)
+		return 0;
+
+	*prog_id = curr_id;
+	err = nla_put_u32(skb, attr, curr_id);
+	if (err)
+		return err;
+
+	if (*mode != XDP_ATTACHED_NONE)
+		*mode = XDP_ATTACHED_MULTI;
+	else
+		*mode = tgt_mode;
+
+	return 0;
+}
+
 static u32 rtnl_xdp_prog_skb(struct net_device *dev)
 {
 	const struct bpf_prog *generic_xdp_prog;
@@ -1486,6 +1516,41 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 	return err;
 }
 
+static int rtnl_xdp_tx_fill(struct sk_buff *skb, struct net_device *dev)
+{
+	u8 mode = XDP_ATTACHED_NONE;
+	struct nlattr *xdp;
+	u32 prog_id = 0;
+	int err;
+
+	xdp = nla_nest_start_noflag(skb, IFLA_XDP_TX);
+	if (!xdp)
+		return -EMSGSIZE;
+
+	err = rtnl_xdp_tx_report_one(skb, dev, &prog_id, &mode,
+				     XDP_ATTACHED_DRV, IFLA_XDP_DRV_PROG_ID,
+				     rtnl_xdp_tx_prog_drv);
+	if (err)
+		goto err_cancel;
+
+	err = nla_put_u8(skb, IFLA_XDP_ATTACHED, mode);
+	if (err)
+		goto err_cancel;
+
+	if (prog_id && mode != XDP_ATTACHED_MULTI) {
+		err = nla_put_u32(skb, IFLA_XDP_PROG_ID, prog_id);
+		if (err)
+			goto err_cancel;
+	}
+
+	nla_nest_end(skb, xdp);
+	return 0;
+
+err_cancel:
+	nla_nest_cancel(skb, xdp);
+	return err;
+}
+
 static u32 rtnl_get_event(unsigned long event)
 {
 	u32 rtnl_event_type = IFLA_EVENT_NONE;
@@ -1743,6 +1808,9 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_xdp_fill(skb, dev))
 		goto nla_put_failure;
 
+	if (rtnl_xdp_tx_fill(skb, dev))
+		goto nla_put_failure;
+
 	if (dev->rtnl_link_ops || rtnl_have_link_slave_info(dev)) {
 		if (rtnl_link_fill(skb, dev) < 0)
 			goto nla_put_failure;
@@ -1827,6 +1895,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
 				    .len = ALTIFNAMSIZ - 1 },
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
+	[IFLA_XDP_TX]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2801,7 +2870,48 @@ static int do_setlink(const struct sk_buff *skb,
 		if (xdp[IFLA_XDP_FD]) {
 			err = dev_change_xdp_fd(dev, extack,
 						nla_get_s32(xdp[IFLA_XDP_FD]),
-						xdp_flags);
+						xdp_flags, false);
+			if (err)
+				goto errout;
+			status |= DO_SETLINK_NOTIFY;
+		}
+	}
+
+	if (tb[IFLA_XDP_TX]) {
+		struct nlattr *xdp[IFLA_XDP_MAX + 1];
+		u32 xdp_flags = 0;
+
+		err = nla_parse_nested_deprecated(xdp, IFLA_XDP_MAX,
+						  tb[IFLA_XDP_TX],
+						  ifla_xdp_policy, NULL);
+		if (err < 0)
+			goto errout;
+
+		if (xdp[IFLA_XDP_ATTACHED] || xdp[IFLA_XDP_PROG_ID]) {
+			err = -EINVAL;
+			goto errout;
+		}
+
+		if (xdp[IFLA_XDP_FLAGS]) {
+			xdp_flags = nla_get_u32(xdp[IFLA_XDP_FLAGS]);
+			if (xdp_flags & XDP_FLAGS_HW_MODE) {
+				err = -EINVAL;
+				goto errout;
+			}
+			if (xdp_flags & ~XDP_FLAGS_MASK) {
+				err = -EINVAL;
+				goto errout;
+			}
+			if (hweight32(xdp_flags & XDP_FLAGS_MODES) > 1) {
+				err = -EINVAL;
+				goto errout;
+			}
+		}
+
+		if (xdp[IFLA_XDP_FD]) {
+			err = dev_change_xdp_fd(dev, extack,
+						nla_get_s32(xdp[IFLA_XDP_FD]),
+						xdp_flags, true);
 			if (err)
 				goto errout;
 			status |= DO_SETLINK_NOTIFY;
-- 
2.21.0

