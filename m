Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4B457061
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 20:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfFZSPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 14:15:32 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:40500 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbfFZSPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 14:15:31 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190626181530euoutp02c45007c85ce989d5da5c1c7e1832835d~r0k6GrSiR0824508245euoutp02I
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 18:15:30 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190626181530euoutp02c45007c85ce989d5da5c1c7e1832835d~r0k6GrSiR0824508245euoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561572930;
        bh=WkLhGIJlQzAKt0bE59R1xSvsdzmc16YuEOu86ZIEiTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LeyyD96tuiTiBL22erhiED1zNE/XPL2npAB2XaHMAesl84EUB9HRM4VC+4U4qdf+A
         bzM1nSQJWtFD+IdX23NCZtBQj3x8rt7yvwqdGO4H1jPFTGsIrf8jSPHxPmLcERD8qi
         uKxMj0Xuz51faqNoowmHRxarnRvg9hFfBpuK3CmA=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190626181529eucas1p16ca5632a26d65dbc6e52e1ecd121c861~r0k5SFnDp1404414044eucas1p1v;
        Wed, 26 Jun 2019 18:15:29 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id 4A.B8.04325.146B31D5; Wed, 26
        Jun 2019 19:15:29 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826~r0k4fFl1F2194421944eucas1p1g;
        Wed, 26 Jun 2019 18:15:28 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190626181528eusmtrp1cf85ab9d4345fd62a61318fd5ccdef91~r0k4RDPXb0317303173eusmtrp1o;
        Wed, 26 Jun 2019 18:15:28 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-b0-5d13b6419f44
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id 99.2B.04146.046B31D5; Wed, 26
        Jun 2019 19:15:28 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190626181527eusmtip2dcc42653ee3aab95b66d65cc2a2315c0~r0k3j1Qs30894308943eusmtip2F;
        Wed, 26 Jun 2019 18:15:27 +0000 (GMT)
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
Subject: [PATCH bpf v4 2/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date:   Wed, 26 Jun 2019 21:15:15 +0300
Message-Id: <20190626181515.1640-3-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190626181515.1640-1-i.maximets@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsWy7djPc7qO24RjDRq2iFj8advAaPH5yHE2
        i8ULvzFbzDnfwmJxpf0nu8WxFy1sFrvWzWS2uLxrDpvFikMngGILxCy29+9jdOD22LLyJpPH
        zll32T0W73nJ5NF14xKzx/Tuh8wefVtWMXp83iQXwB7FZZOSmpNZllqkb5fAlTHj+jf2ghe2
        Ff+O32FvYOw37GLk5JAQMJHYfWMZK4gtJLCCUeLkAaA4F5D9hVFiTfd2dgjnM6PErSXTmWA6
        Tq9bxQyRWM4oMW1rPyuE84NR4uflyWwgVWwCOhKnVh9hBLFFBKQkPu6AGMUsMJNZYsvjKSwg
        CWGBKImF57+ALWcRUJX4f3IFO4jNK2AlcfLzfBaIdfISqzccYAaxOQWsJU5M+MQIMkhCYDq7
        xMQTF6FucpHYdOM+I4QtLPHq+BZ2CFtG4vTkHqhB9RL3W15CNXcwSkw/9A+q2V5iy+tzQA0c
        QOdpSqzfpQ8RdpTYduM9E0hYQoBP4sZbQZAwM5A5adt0Zogwr0RHmxBEtYrE74PLmSFsKYmb
        7z5DXeAh8ffwRUZIAPUxSuzcv595AqP8LIRlCxgZVzGKp5YW56anFhvnpZbrFSfmFpfmpesl
        5+duYgQmmNP/jn/dwbjvT9IhRgEORiUe3gZ5oVgh1sSy4srcQ4wSHMxKIrxLEwVihXhTEiur
        Uovy44tKc1KLDzFKc7AoifNWMzyIFhJITyxJzU5NLUgtgskycXBKNTAWrmT5cizY4/nN4ypt
        6kIlG3TC3Z4ZugUVPZl5uP8M23c7H3fdAs+j7CFrsrL+e0a8evlkX6LH8mcFv31eeftZpos7
        sj6UkI7kndxg/Oqvs9aF+993Pn5v514k4RN1bZ/ZEc0ThmUZjvKhjuZ7F01od/KNa7dpPn3A
        XFH1+VuDXazzUr26/iqxFGckGmoxFxUnAgBaldoSLAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xe7oO24RjDSa1yVr8advAaPH5yHE2
        i8ULvzFbzDnfwmJxpf0nu8WxFy1sFrvWzWS2uLxrDpvFikMngGILxCy29+9jdOD22LLyJpPH
        zll32T0W73nJ5NF14xKzx/Tuh8wefVtWMXp83iQXwB6lZ1OUX1qSqpCRX1xiqxRtaGGkZ2hp
        oWdkYqlnaGwea2VkqqRvZ5OSmpNZllqkb5eglzHj+jf2ghe2Ff+O32FvYOw37GLk5JAQMJE4
        vW4VcxcjF4eQwFJGiek7VzJDJKQkfvy6wAphC0v8udbFBmILCXxjlLh7mBfEZhPQkTi1+ggj
        iC0CVP9xx3Z2EJtZYCGzxJdJJiC2sECExO8V68BmsgioSvw/uQKshlfASuLk5/ksEPPlJVZv
        OABWwylgLXFiwiegmRxAu6wktnVwTmDkW8DIsIpRJLW0ODc9t9hQrzgxt7g0L10vOT93EyMw
        1Lcd+7l5B+OljcGHGAU4GJV4eBvkhWKFWBPLiitzDzFKcDArifAuTRSIFeJNSaysSi3Kjy8q
        zUktPsRoCnTTRGYp0eR8YBzmlcQbmhqaW1gamhubG5tZKInzdggcjBESSE8sSc1OTS1ILYLp
        Y+LglGpgZOO5rb5KtzqRNXCmQ4Tt+hW710cu3ci6rPGU0tl1Gze+jJt+7oDFO8tHjlwTbBak
        nuFh9jGaHs0n/STc+v8Wg9TmI+5fvm1lfa3/cr77mjWy5eeVF3G1+35Z98hjNYfjfuFtO8UP
        zY58z2L17kFmRF3wRlHFG4r5e0s/Wx/bamF16WCeaPGnJUosxRmJhlrMRcWJAJXMim6LAgAA
X-CMS-MailID: 20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826
References: <20190626181515.1640-1-i.maximets@samsung.com>
        <CGME20190626181528eucas1p190f20427a1d2a64f2efa6cedcfac0826@eucas1p1.samsung.com>
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
 net/xdp/xdp_umem.c     | 16 +++++---
 net/xdp/xdp_umem.h     |  1 +
 net/xdp/xsk.c          | 88 ++++++++++++++++++++++++++++++++++++------
 4 files changed, 93 insertions(+), 17 deletions(-)

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
index 267b82a4cbcf..56729e74cbea 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -140,34 +140,38 @@ int xdp_umem_assign_dev(struct xdp_umem *umem, struct net_device *dev,
 	return err;
 }
 
-static void xdp_umem_clear_dev(struct xdp_umem *umem)
+void xdp_umem_clear_dev(struct xdp_umem *umem)
 {
+	bool lock = rtnl_is_locked();
 	struct netdev_bpf bpf;
 	int err;
 
+	if (!lock)
+		rtnl_lock();
+
 	if (!umem->dev)
-		return;
+		goto out_unlock;
 
 	if (umem->zc) {
 		bpf.command = XDP_SETUP_XSK_UMEM;
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
 	umem->zc = false;
+
+out_unlock:
+	if (!lock)
+		rtnl_unlock();
 }
 
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
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
index a14e8864e4fa..883dfd3cdc49 100644
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
@@ -693,6 +715,38 @@ static int xsk_mmap(struct file *file, struct socket *sock,
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
@@ -764,6 +818,7 @@ static int xsk_create(struct net *net, struct socket *sock, int protocol,
 	sock_set_flag(sk, SOCK_RCU_FREE);
 
 	xs = xdp_sk(sk);
+	xs->state = XSK_UNINITIALIZED;
 	mutex_init(&xs->mutex);
 	spin_lock_init(&xs->tx_completion_lock);
 
@@ -784,6 +839,10 @@ static const struct net_proto_family xsk_family_ops = {
 	.owner	= THIS_MODULE,
 };
 
+static struct notifier_block xsk_netdev_notifier = {
+	.notifier_call	= xsk_notifier,
+};
+
 static int __net_init xsk_net_init(struct net *net)
 {
 	mutex_init(&net->xdp.lock);
@@ -816,8 +875,15 @@ static int __init xsk_init(void)
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

