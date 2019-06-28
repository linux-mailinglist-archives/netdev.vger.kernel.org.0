Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C01D95958B
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 10:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbfF1IE0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 04:04:26 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:52839 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726650AbfF1IEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 04:04:25 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190628080423euoutp01580b4ab494fafa6e822f9d80ef76f088~sTh5-zw6c1727017270euoutp01B
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:04:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190628080423euoutp01580b4ab494fafa6e822f9d80ef76f088~sTh5-zw6c1727017270euoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1561709063;
        bh=q8MqjSyDIsmIpRYnJSjI1zGGjkLLK/XYbow98sx3X5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ceIZo7aMX8EpPeSA56EI97Ox967+TKZVVnhIggPScrwYk0HwUwKD19qHNbj/0Os3g
         BYIEk0Vcoocy49f6JitQ6e/wZm+ll0Vo66LmJvO0CYycbOHSWRrEPSDtuiVlTF36/l
         N+DgU5Fi+PfljTSvcjp92dljgGQ72sBoIZ2po2Vo=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190628080422eucas1p294f675502229b7f0f8d49707c3c09d21~sTh5Tk8VC3242232422eucas1p24;
        Fri, 28 Jun 2019 08:04:22 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 04.73.04377.60AC51D5; Fri, 28
        Jun 2019 09:04:22 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190628080422eucas1p26e61d31042662bbabe295f55ae80e6c9~sTh4fLKlT1971119711eucas1p2r;
        Fri, 28 Jun 2019 08:04:22 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190628080421eusmtrp18b2d2c214220b07e70ddb4e8ac75b81c~sTh4Q9LaM2335823358eusmtrp1G;
        Fri, 28 Jun 2019 08:04:21 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-a6-5d15ca06cdc9
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id AF.10.04140.50AC51D5; Fri, 28
        Jun 2019 09:04:21 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190628080421eusmtip19f73031fa8b970aef98ce6233ff0b3d0~sTh3miR6X2228022280eusmtip1W;
        Fri, 28 Jun 2019 08:04:21 +0000 (GMT)
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
Subject: [PATCH bpf v6 2/2] xdp: fix hang while unregistering device bound
 to xdp socket
Date:   Fri, 28 Jun 2019 11:04:07 +0300
Message-Id: <20190628080407.30354-3-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628080407.30354-1-i.maximets@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA0VSa0hTYRju2znbzszFaa58XWm1kkjzSj8OZVYQMfoVRBCG2NSTim7KjteE
        MlpqS9RcMDYszGWaUpnN21LLZSreCovSIuY1tYsaM9Fc1uaZ9O99nvd5n+d9Pz4CE+m5EiJB
        mUqrlPIkKc8Nb+hcHgjg9WyJDJ6c20vZc2sRZevo4lHGu4sYVfpajVPv8pb5VOe0mkeZH+kx
        6q25lEdVWbodXNlWqrGoDR3dKDM9GObImg2f+TJjywxHphkaxGS6G6OYrNBUjWS2Op9T/Ai3
        sFg6KSGdVgWFn3eLt5e3clLuhWc+7J/Cc1BviAYJCCAPgLF1GNcgN0JEViGYaqvAWLCAoCq/
        nM8CG4L2L4uc9RHt4guXqhLBr79WHguWECxo67lOFY/cDz01HchZi0kJ/GxqXLPCSD0GpvFb
        uLPhQUbA1br7ayKc9AXrimWNF5KHYMzUwGfjdkBNrTNOQAjIMJibykVOIyC1fNAY5h1phAMc
        hyfTGKv3gK9dJtfsdujVFuBsfRms6hnXbD4CnWXVdc8RMH0b4Dt9MHIfPDYHsfQxMH0aRKz9
        Jhj6sdlJY46ypEGHsbQQ8nNFrHoPrLRXujaQwPCszbWBDD5ef4nY9ylC0Hf7Jl6Mdhj+h5Uh
        VI086TRGEUczoUo6I5CRK5g0ZVxgTLKiDjk+TO9q10ITMtujLYgkkNRduLNZHCniytOZLIUF
        AYFJxUKvAQcljJVnXaRVyVGqtCSasaBtBC71FGZvGDknIuPkqXQiTafQqvUuhxBIctCV+vfe
        PVGaYmrh9IeRGP9XsaOMKtnL32d3olFSb3+zVNKtnnfnZUQXcM80Hm6O6ff9Mzt9iUu2BuPP
        RMHC54TUcOcgutYnNuh+f2/1Fe3iAKo4cXJ8rHhi0i/T20fQN5Id2JGhSmIyQy+cLTJN1An1
        2S3WvKqnhQGrbfmZE1KciZeH+GEqRv4PqdFUlSwDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFLMWRmVeSWpSXmKPExsVy+t/xu7qsp0RjDa4sMbT407aB0eLzkeNs
        FosXfmO2mHO+hcXiSvtPdotjL1rYLHatm8lscXnXHDaLFYdOAMUWiFls79/H6MDtsWXlTSaP
        nbPusnss3vOSyaPrxiVmj+ndD5k9+rasYvT4vEkugD1Kz6Yov7QkVSEjv7jEVina0MJIz9DS
        Qs/IxFLP0Ng81srIVEnfziYlNSezLLVI3y5BL+PPor1MBUvsKtaefc7SwHjasIuRk0NCwERi
        8rcDzF2MXBxCAksZJV6/nM4MkZCS+PHrAiuELSzx51oXG0TRN0aJxrlvmEASbAI6EqdWH2EE
        sUWAGj7u2M4OYjMLLGSW+DLJBMQWFoiQWPtvG1gNi4CqxP3fh1hAbF4Ba4lHW7axQyyQl1i9
        4QDYYk4BG4n3z9vA6oWAah7u/cU6gZFvASPDKkaR1NLi3PTcYiO94sTc4tK8dL3k/NxNjMBw
        33bs55YdjF3vgg8xCnAwKvHwKuwUiRViTSwrrsw9xCjBwawkwit5DijEm5JYWZValB9fVJqT
        WnyI0RToqInMUqLJ+cBYzCuJNzQ1NLewNDQ3Njc2s1AS5+0QOBgjJJCeWJKanZpakFoE08fE
        wSnVwHhQM6DmZMJxASER2xwDq8fW2stOOYv9tXP7ur076UtQt3EYh/ODNjfRc1XhZ7d9Dtwx
        +bqRkb9HbG6NkfNmjwSXibbmjVcE2teUnE9ViRP/8/ml+MnXGzo/iGrLMS35bKRd03B4y4S4
        Th6zK+8eBsp2sB+76nZB8cLCursPYm7NvZ9gsExmsxJLcUaioRZzUXEiALszZduNAgAA
X-CMS-MailID: 20190628080422eucas1p26e61d31042662bbabe295f55ae80e6c9
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190628080422eucas1p26e61d31042662bbabe295f55ae80e6c9
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190628080422eucas1p26e61d31042662bbabe295f55ae80e6c9
References: <20190628080407.30354-1-i.maximets@samsung.com>
        <CGME20190628080422eucas1p26e61d31042662bbabe295f55ae80e6c9@eucas1p2.samsung.com>
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
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
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
+		XSK_READY = 0,
+		XSK_BOUND,
+		XSK_UNBOUND,
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
+	if (!dev || xs->state != XSK_BOUND)
+		return;
+
+	xs->state = XSK_UNBOUND;
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
+	if (xs->state != XSK_READY) {
 		err = -EBUSY;
 		goto out_release;
 	}
@@ -492,6 +500,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 out_unlock:
 	if (err)
 		dev_put(dev);
+	else
+		xs->state = XSK_BOUND;
 out_release:
 	mutex_unlock(&xs->mutex);
 	return err;
@@ -520,6 +530,10 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return -EFAULT;
 
 		mutex_lock(&xs->mutex);
+		if (xs->state != XSK_READY) {
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
+		if (xs->state != XSK_READY || xs->umem) {
 			mutex_unlock(&xs->mutex);
 			return -EBUSY;
 		}
@@ -561,6 +575,10 @@ static int xsk_setsockopt(struct socket *sock, int level, int optname,
 			return -EFAULT;
 
 		mutex_lock(&xs->mutex);
+		if (xs->state != XSK_READY) {
+			mutex_unlock(&xs->mutex);
+			return -EBUSY;
+		}
 		if (!xs->umem) {
 			mutex_unlock(&xs->mutex);
 			return -EINVAL;
@@ -662,6 +680,9 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 	unsigned long pfn;
 	struct page *qpg;
 
+	if (xs->state != XSK_READY)
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
+	xs->state = XSK_READY;
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

