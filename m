Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4220A58004
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfF0KPp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:15:45 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:32939 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfF0KPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:15:43 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190627101542euoutp0252c70044dce5ac82dcd0888267de1b75~sBrQ-k4s82427524275euoutp02H
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 10:15:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190627101542euoutp0252c70044dce5ac82dcd0888267de1b75~sBrQ-k4s82427524275euoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561630542;
        bh=ewGgSJyzIeD7ePyy+n9aXIUYEvCgBhc3/skDqXmLnZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSdy04+plboMz+NndDAdgqP5Xp70gu5GPnkCuDBbcFUP03Ul59HeUMPfnzyU+lX80
         CAI0vOxuNyhZ5rEBaG6MpRkgnQEAO280/rr8mecaeM2HowfKdEJ4+WRy9nlaNAnTX0
         v3AC47lpwA6MwgRF1Zest8cUu0KXimiVGS7Wvfq8=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190627101541eucas1p1ba3d737a9d0012faa69cf5c48b2077af~sBrQMP-PB3079030790eucas1p1n;
        Thu, 27 Jun 2019 10:15:41 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id 43.FE.04298.C47941D5; Thu, 27
        Jun 2019 11:15:40 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934~sBrPcHNQb1058210582eucas1p1u;
        Thu, 27 Jun 2019 10:15:40 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190627101540eusmtrp22a29ad59094009437f905d83b56bb9dd~sBrPN_WIE2684426844eusmtrp2l;
        Thu, 27 Jun 2019 10:15:40 +0000 (GMT)
X-AuditID: cbfec7f2-f2dff700000010ca-e0-5d14974c931d
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 03.B4.04146.B47941D5; Thu, 27
        Jun 2019 11:15:40 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190627101539eusmtip1c337cfe136cef52b74b468393bf64989~sBrOfEwXU0967709677eusmtip1N;
        Thu, 27 Jun 2019 10:15:39 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v5 2/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date:   Thu, 27 Jun 2019 13:15:29 +0300
Message-Id: <20190627101529.11234-3-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190627101529.11234-1-i.maximets@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsWy7djPc7o+00ViDa78MbL407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK+PwpunMBWvs
        KhrfT2FtYLxh2MXIySEhYCJxadZcpi5GLg4hgRWMEvOXrmACSQgJfGGUuDtVGyLxmVFi6t7J
        bDAdrX1fmCGKljNK7PmqA1H0g1Fi4s33rCAJNgEdiVOrjzCC2CICUhIfd2xnByliFpjJLLHl
        8RQWkISwQJTEgjlvwGwWAVWJH/fOgK3mFbCWWH/sBgvENnmJ1RsOAG3j4OAUsJG42JgNEZ7O
        LnGqxxHCdpF48PQZ1HHCEq+Ob2GHsGUk/u+czwRh10vcb3nJCHKDhEAHo8T0Q/+gEvYSW16f
        YweZzyygKbF+lz6IKSHgKHF4phaEySdx460gSDEzkDlp23RmiDCvREebEMQMFYnfB5czQ9hS
        EjfffWaHKPGQWHVXFBI4/YwS9x6/YZzAKD8LYdUCRsZVjOKppcW56anFhnmp5XrFibnFpXnp
        esn5uZsYgWnl9L/jn3Ywfr2UdIhRgINRiYeXYY9wrBBrYllxZe4hRgkOZiUR3vwwkVgh3pTE
        yqrUovz4otKc1OJDjNIcLErivNUMD6KFBNITS1KzU1MLUotgskwcnFINjJtUWiSONT7e/6Tq
        TlVz/n3Goua7972nVGjP/GsY9+VmutmzEL4X3IIcrkqO0Z1+c7l+vVi1Radds63qy3nlzJLD
        i2Y8C6pwlv94i+m+qf6HmddFm3vPK+yesWfz6Sn3WuQDskQPcCvaVly77535atWdibHxFtLy
        s/8+jnX87VfLfm6mqIj8IyWW4oxEQy3mouJEAMkXLK0nAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xu7o+00ViDf7WWfxp28Bo8fnIcTaL
        xQu/MVvMOd/CYnGl/Se7xbEXLWwWu9bNZLa4vGsOm8WKQyeAYgvELLb372N04PbYsvImk8fO
        WXfZPRbvecnk0XXjErPH9O6HzB59W1YxenzeJBfAHqVnU5RfWpKqkJFfXGKrFG1oYaRnaGmh
        Z2RiqWdobB5rZWSqpG9nk5Kak1mWWqRvl6CXcXjTdOaCNXYVje+nsDYw3jDsYuTkkBAwkWjt
        +8IMYgsJLGWUWDhXCCIuJfHj1wVWCFtY4s+1LrYuRi6gmm+MEu2/NjCCJNgEdCROrT4CZosA
        NXzcsZ0dxGYWWMgs8WWSCYgtLBAhcWR5G9gCFgFViR/3zjCB2LwC1hLrj91ggVggL7F6wwGg
        Gg4OTgEbiYuN2RD3WEt8OPqTbQIj3wJGhlWMIqmlxbnpucWGesWJucWleel6yfm5mxiBgb7t
        2M/NOxgvbQw+xCjAwajEw7tip3CsEGtiWXFl7iFGCQ5mJRHe/DCRWCHelMTKqtSi/Pii0pzU
        4kOMpkA3TWSWEk3OB0ZhXkm8oamhuYWlobmxubGZhZI4b4fAwRghgfTEktTs1NSC1CKYPiYO
        TqkGxu708CzxCbdvLcv7bNGmsHV9/ZI3+8WXcX5z0NOar748tsxbMNRj925u+1UcmZ+LVi9a
        eM8+siu8/7ORy5uNG3K6/i3NNhMLjtSVaDl0wzH0yf8pG7Ykzv3C/PjJY45C0QDX+Y9Ezryc
        JDnzxuaSgJWOp5d+2fvjxR7DRt5qW6WFvmlF269cy1ViKc5INNRiLipOBACiKJa/igIAAA==
X-CMS-MailID: 20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934
References: <20190627101529.11234-1-i.maximets@samsung.com>
        <CGME20190627101540eucas1p149805b39e12bf7ecf5864b7ff1b0c934@eucas1p1.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Device that bound to XDP socket will not have zero refcount until the
userspace application will not close it. This leads to hang inside
'netdev_wait_allrefs()' if device unregistering requested:

  # ip link del p1
  < hang on recvmsg on netlink socket >

  # ps -x | grep ip
  5126  pts/0    D+   0:00 ip link del p1

  # journalctl -b

  Jun 05 07:19:16 kernel:
  unregister_netdevice: waiting for p1 to become free. Usage count = 1

  Jun 05 07:19:27 kernel:
  unregister_netdevice: waiting for p1 to become free. Usage count = 1
  ...

Fix that by implementing NETDEV_UNREGISTER event notification handler
to properly clean up all the resources and unref device.

This should also allow socket killing via ss(8) utility.

Fixes: 965a99098443 ("xsk: add support for bind for Rx")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---
 include/net/xdp_sock.h |  5 +++
 net/xdp/xdp_umem.c     | 10 ++---
 net/xdp/xdp_umem.h     |  1 +
 net/xdp/xsk.c          | 87 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 87 insertions(+), 16 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index d074b6d60f8a..82d153a637c7 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -61,6 +61,11 @@ struct xdp_sock {
 	struct xsk_queue *tx ____cacheline_aligned_in_smp;
 	struct list_head list;
 	bool zc;
+	enum {
+		XSK_UNINITIALIZED = 0,
+		XSK_BINDED,
+		XSK_UNBINDED,
+	} state;
 	/* Protects multiple processes in the control path */
 	struct mutex mutex;
 	/* Mutual exclusion of NAPI TX thread and sendmsg error paths
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 267b82a4cbcf..20c91f02d3d8 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -140,11 +140,13 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	return err;
 }
 
-static void xdp_umem_clear_dev(struct xdp_umem *umem)
+void xdp_umem_clear_dev(struct xdp_umem *umem)
 {
 	struct netdev_bpf bpf;
 	int err;
 
+	ASSERT_RTNL();
+
 	if (!umem->dev)
 		return;
 
@@ -153,17 +155,13 @@ static void xdp_umem_clear_dev(struct xdp_umem *umem)
 		bpf.xsk.umem = NULL;
 		bpf.xsk.queue_id = umem->queue_id;
 
-		rtnl_lock();
 		err = umem->dev->netdev_ops->ndo_bpf(umem->dev, &bpf);
-		rtnl_unlock();
 
 		if (err)
 			WARN(1, "failed to disable umem!\n");
 	}
 
-	rtnl_lock();
 	xdp_clear_umem_at_qid(umem->dev, umem->queue_id);
-	rtnl_unlock();
 
 	dev_put(umem->dev);
 	umem->dev = NULL;
@@ -195,7 +193,9 @@ static void xdp_umem_unaccount_pages(struct xdp_umem *umem)
 
 static void xdp_umem_release(struct xdp_umem *umem)
 {
+	rtnl_lock();
 	xdp_umem_clear_dev(umem);
+	rtnl_unlock();
 
 	ida_simple_remove(&umem_ida, umem->id);
 
diff --git a/net/xdp/xdp_umem.h b/net/xdp/xdp_umem.h
index 27603227601b..a63a9fb251f5 100644
--- a/net/xdp/xdp_umem.h
+++ b/net/xdp/xdp_umem.h
@@ -10,6 +10,7 @@
 
 int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 			u16 queue_id, u16 flags);
+void xdp_umem_clear_dev(struct xdp_umem *umem);
 bool xdp_umem_validate_queues(struct xdp_umem *umem);
 void xdp_get_umem(struct xdp_umem *umem);
 void xdp_put_umem(struct xdp_umem *umem);
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..336723948a36 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -335,6 +335,22 @@ static int xsk_init_queue(u32 entries, struct xsk_queue **queue,
 	return 0;
 }
 
+static void xsk_unbind_dev(struct xdp_sock *xs)
+{
+	struct net_device *dev = xs->dev;
+
+	if (!dev || xs->state != XSK_BINDED)
+		return;
+
+	xs->state = XSK_UNBINDED;
+
+	/* Wait for driver to stop using the xdp socket. */
+	xdp_del_sk_umem(xs->umem, xs);
+	xs->dev = NULL;
+	synchronize_net();
+	dev_put(dev);
+}
+
 static int xsk_release(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -354,15 +370,7 @@ static int xsk_release(struct socket *sock)
 	sock_prot_inuse_add(net, sk->sk_prot, -1);
 	local_bh_enable();
 
-	if (xs->dev) {
-		struct net_device *dev = xs->dev;
-
-		/* Wait for driver to stop using the xdp socket. */
-		xdp_del_sk_umem(xs->umem, xs);
-		xs->dev = NULL;
-		synchronize_net();
-		dev_put(dev);
-	}
+	xsk_unbind_dev(xs);
 
 	xskq_destroy(xs->rx);
 	xskq_destroy(xs->tx);
@@ -412,7 +420,7 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		return -EINVAL;
 
 	mutex_lock(&xs->mutex);
-	if (xs->dev) {
+	if (xs->state != XSK_UNINITIALIZED) {
 		err = -EBUSY;
 		goto out_release;
 	}
@@ -492,6 +500,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 out_unlock:
 	if (err)
 		dev_put(dev);
+	else
+		xs->state = XSK_BINDED;
 out_release:
 	mutex_unlock(&xs->mutex);
 	return err;
@@ -520,6 +530,10 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return -EFAULT;
 
 		mutex_lock(&xs->mutex);
+		if (xs->state != XSK_UNINITIALIZED) {
+			mutex_unlock(&xs->mutex);
+			return -EBUSY;
+		}
 		q = (optname == XDP_TX_RING) ? &xs->tx : &xs->rx;
 		err = xsk_init_queue(entries, q, false);
 		mutex_unlock(&xs->mutex);
@@ -534,7 +548,7 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return -EFAULT;
 
 		mutex_lock(&xs->mutex);
-		if (xs->umem) {
+		if (xs->state != XSK_UNINITIALIZED || xs->umem) {
 			mutex_unlock(&xs->mutex);
 			return -EBUSY;
 		}
@@ -561,6 +575,10 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return -EFAULT;
 
 		mutex_lock(&xs->mutex);
+		if (xs->state != XSK_UNINITIALIZED) {
+			mutex_unlock(&xs->mutex);
+			return -EBUSY;
+		}
 		if (!xs->umem) {
 			mutex_unlock(&xs->mutex);
 			return -EINVAL;
@@ -662,6 +680,9 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	unsigned long pfn;
 	struct page *qpg;
 
+	if (xs->state != XSK_UNINITIALIZED)
+		return -EBUSY;
+
 	if (offset == XDP_PGOFF_RX_RING) {
 		q = READ_ONCE(xs->rx);
 	} else if (offset == XDP_PGOFF_TX_RING) {
@@ -693,6 +714,38 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 			       size, vma->vm_page_prot);
 }
 
+static int xsk_notifier(struct notifier_block *this,
+			unsigned long msg, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+	struct sock *sk;
+
+	switch (msg) {
+	case NETDEV_UNREGISTER:
+		mutex_lock(&net->xdp.lock);
+		sk_for_each(sk, &net->xdp.list) {
+			struct xdp_sock *xs = xdp_sk(sk);
+
+			mutex_lock(&xs->mutex);
+			if (xs->dev == dev) {
+				sk->sk_err = ENETDOWN;
+				if (!sock_flag(sk, SOCK_DEAD))
+					sk->sk_error_report(sk);
+
+				xsk_unbind_dev(xs);
+
+				/* Clear device references in umem. */
+				xdp_umem_clear_dev(xs->umem);
+			}
+			mutex_unlock(&xs->mutex);
+		}
+		mutex_unlock(&net->xdp.lock);
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
 static struct proto xsk_proto = {
 	.name =		"XDP",
 	.owner =	THIS_MODULE,
@@ -764,6 +817,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	sock_set_flag(sk, SOCK_RCU_FREE);
 
 	xs = xdp_sk(sk);
+	xs->state = XSK_UNINITIALIZED;
 	mutex_init(&xs->mutex);
 	spin_lock_init(&xs->tx_completion_lock);
 
@@ -784,6 +838,10 @@ static const struct net_proto_family xsk_family_ops = {
 	.owner	= THIS_MODULE,
 };
 
+static struct notifier_block xsk_netdev_notifier = {
+	.notifier_call	= xsk_notifier,
+};
+
 static int __net_init xsk_net_init(struct net *net)
 {
 	mutex_init(&net->xdp.lock);
@@ -816,8 +874,15 @@ static int __init xsk_init(void)
 	err = register_pernet_subsys(&xsk_net_ops);
 	if (err)
 		goto out_sk;
+
+	err = register_netdevice_notifier(&xsk_netdev_notifier);
+	if (err)
+		goto out_pernet;
+
 	return 0;
 
+out_pernet:
+	unregister_pernet_subsys(&xsk_net_ops);
 out_sk:
 	sock_unregister(PF_XDP);
 out_proto:
-- 
2.17.1

