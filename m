Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1AE52A908F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 08:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgKFHk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 02:40:57 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35646 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726242AbgKFHk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 02:40:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---0UEPFJ9B_1604648452;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UEPFJ9B_1604648452)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 06 Nov 2020 15:40:53 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org
Subject: [PATCH] xdp: auto off xdp by bond fd
Date:   Fri,  6 Nov 2020 15:40:52 +0800
Message-Id: <c9649a2463f6ff6d55177498d2d8a36242e51ab7.1604648249.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, off xdp is implemented by actively calling netlink on the
command line or in the program. This is very inconvenient for apps based
on xdp. For example, an app based on xdp + xsk exits abnormally, but xdp
is still working, which may cause some exceptions. And xsk cannot be
automatically recycled. We need to bind xdp to the process in some
cases, so that xdp can always be automatically released when the process exits.

Although the signal can be used to handle this problem, it cannot handle
some signals that cannot be captured. At the same time, it is
inconvenient to use the signal to process in some cases. For example, a
library based on xdp + xsk is not very convenient to use the signal solve
this problem.

This patch requires the app to actively call RTM_GETLINK after setting
xdp and use RTEXT_FILTER_XDPFD flags to let the kernel generate an fd,
and return it to the app through netlink. In this way, when the app
closes fd or the process exits, the release callback of fd can trigger
to off xdp.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 include/uapi/linux/if_link.h   |  1 +
 include/uapi/linux/rtnetlink.h |  1 +
 net/core/rtnetlink.c           | 71 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 70 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index c4b23f0..c9f73a9 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1191,6 +1191,7 @@ enum {
 	IFLA_XDP_SKB_PROG_ID,
 	IFLA_XDP_HW_PROG_ID,
 	IFLA_XDP_EXPECTED_FD,
+	IFLA_XDP_BOND_FD,
 	__IFLA_XDP_MAX,
 };
 
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index d1325ff..e74b18c 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -785,6 +785,7 @@ enum {
 #define RTEXT_FILTER_MRP	(1 << 4)
 #define RTEXT_FILTER_CFM_CONFIG	(1 << 5)
 #define RTEXT_FILTER_CFM_STATUS	(1 << 6)
+#define RTEXT_FILTER_XDPFD	(1 << 7)
 
 /* End of information exported to user level */
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 7d72236..1b36fb8 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -37,6 +37,7 @@
 #include <linux/pci.h>
 #include <linux/etherdevice.h>
 #include <linux/bpf.h>
+#include <linux/anon_inodes.h>
 
 #include <linux/uaccess.h>
 
@@ -982,7 +983,8 @@ static size_t rtnl_xdp_size(void)
 	size_t xdp_size = nla_total_size(0) +	/* nest IFLA_XDP */
 			  nla_total_size(1) +	/* XDP_ATTACHED */
 			  nla_total_size(4) +	/* XDP_PROG_ID (or 1st mode) */
-			  nla_total_size(4);	/* XDP_<mode>_PROG_ID */
+			  nla_total_size(4) +	/* XDP_<mode>_PROG_ID */
+			  nla_total_size(4);	/* XDP_BOND_FD */
 
 	return xdp_size;
 }
@@ -1412,6 +1414,62 @@ static int rtnl_fill_link_ifmap(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
+static int xdp_release(struct inode *inode, struct file *filp)
+{
+	struct net_device *dev = filp->private_data;
+
+	rtnl_lock();
+
+	dev_change_xdp_fd(dev, NULL, -1, -1, 0);
+	dev_put(dev);
+
+	rtnl_unlock();
+
+	return 0;
+}
+
+static const struct file_operations xdp_fops = {
+	.release	= xdp_release,
+};
+
+static int rtnl_xdp_bond_fd(struct sk_buff *skb, struct net_device *dev)
+{
+	int err = 0, fd = -1, ret;
+	struct file *file;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	dev_hold(dev);
+
+	ret = get_unused_fd_flags(O_CLOEXEC);
+	if (ret < 0)
+		goto err;
+
+	fd = ret;
+
+	err = nla_put_u32(skb, IFLA_XDP_BOND_FD, fd);
+	if (err)
+		goto err;
+
+	file = anon_inode_getfile("xdp", &xdp_fops, dev, O_CLOEXEC);
+	if (IS_ERR(file)) {
+		err = PTR_ERR(file);
+		goto err;
+	}
+
+	fd_install(fd, file);
+
+	return 0;
+
+err:
+	if (fd > -1)
+		put_unused_fd(fd);
+
+	dev_put(dev);
+	return err;
+}
+
 static u32 rtnl_xdp_prog_skb(struct net_device *dev)
 {
 	const struct bpf_prog *generic_xdp_prog;
@@ -1458,7 +1516,8 @@ static int rtnl_xdp_report_one(struct sk_buff *skb, struct net_device *dev,
 	return 0;
 }
 
-static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
+static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev,
+			 u32 ext_filter_mask)
 {
 	struct nlattr *xdp;
 	u32 prog_id;
@@ -1492,6 +1551,12 @@ static int rtnl_xdp_fill(struct sk_buff *skb, struct net_device *dev)
 		err = nla_put_u32(skb, IFLA_XDP_PROG_ID, prog_id);
 		if (err)
 			goto err_cancel;
+
+		if (ext_filter_mask & RTEXT_FILTER_XDPFD) {
+			err = rtnl_xdp_bond_fd(skb, dev);
+			if (err)
+				goto err_cancel;
+		}
 	}
 
 	nla_nest_end(skb, xdp);
@@ -1787,7 +1852,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	if (rtnl_port_fill(skb, dev, ext_filter_mask))
 		goto nla_put_failure;
 
-	if (rtnl_xdp_fill(skb, dev))
+	if (rtnl_xdp_fill(skb, dev, ext_filter_mask))
 		goto nla_put_failure;
 
 	if (dev->rtnl_link_ops || rtnl_have_link_slave_info(dev)) {
-- 
1.8.3.1

