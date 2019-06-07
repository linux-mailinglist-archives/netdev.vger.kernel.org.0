Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE07039343
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 19:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731482AbfFGRbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 13:31:52 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43317 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730286AbfFGRbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 13:31:51 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190607173150euoutp023b8045b04ffd532225a0a9fda32cf29c~l_uXHFJaL1871718717euoutp02L
        for <netdev@vger.kernel.org>; Fri,  7 Jun 2019 17:31:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190607173150euoutp023b8045b04ffd532225a0a9fda32cf29c~l_uXHFJaL1871718717euoutp02L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559928710;
        bh=+73Xx1qoe9dIGh6MmIDsGi8BapXTIg12votyZnFlISI=;
        h=From:To:Cc:Subject:Date:References:From;
        b=sLLAwIUxOqhzZ7smW7FMmXst7BUn8JjHePJefEnWwGWPK8WWQOwkK9OysCQhjLi3F
         LqynihpWKs6gBr5ghbXFqXq6BnjFW8xMiq9l1cfm+0zTaEwCUqzJOZAEpO2LU2iLmc
         +bC4ZCRd9laT+5Hc39k+MkBxgV9g8fXxCBO/pb+M=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190607173149eucas1p11b7d792ce73f147ba7879ee56252cb97~l_uWWVTLb2870928709eucas1p13;
        Fri,  7 Jun 2019 17:31:49 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 13.34.04377.58F9AFC5; Fri,  7
        Jun 2019 18:31:49 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e~l_uVkCxMF2999029990eucas1p10;
        Fri,  7 Jun 2019 17:31:49 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190607173148eusmtrp1086bbfb6ddf7478b05dda0e5f83a2bd9~l_uVUQeRM1793017930eusmtrp1c;
        Fri,  7 Jun 2019 17:31:48 +0000 (GMT)
X-AuditID: cbfec7f4-12dff70000001119-b2-5cfa9f85fc37
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id E6.50.04146.48F9AFC5; Fri,  7
        Jun 2019 18:31:48 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190607173148eusmtip15d73adf5d01bf9d16607a46150301b7a~l_uUtUX7t3005530055eusmtip1o;
        Fri,  7 Jun 2019 17:31:48 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v2] xdp: fix hang while unregistering device bound to
 xdp socket
Date:   Fri,  7 Jun 2019 20:31:43 +0300
Message-Id: <20190607173143.4919-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsWy7djP87qt83/FGLSuUbL407aB0eLzkeNs
        FnPOt7BYXGn/yW6xa91MZovLu+awWaw4dILd4tgCMYvt/fsYHTg9tqy8yeSxc9Zddo/Fe14y
        efRtWcXo8XmTXABrFJdNSmpOZllqkb5dAlfGrcnH2QuapCqWHkxsYDwi0sXIySEhYCKx5MpX
        1i5GLg4hgRWMEpfPdzKCJIQEvjBKvHwUAJH4zCjRvOERE0zH+fVd7BCJ5YwSr8+vZYFwfjBK
        HD76lhWkik1AR+LU6iNgo0QEpCQ+7tgO1sEscIBJ4vacSWwgCWGBMImnnVvAbBYBVYlbc76w
        g9i8AlYSXR0dbBDr5CVWbzjADNIsIfCYTaL91XR2iISLxJslJ6BuEpZ4dXwLVFxG4vTkHhYI
        u17ifstLRojmDkaJ6Yf+QTXYS2x5fQ6ogQPoJE2J9bv0IcKOEt8vtYOFJQT4JG68FQQJMwOZ
        k7ZNZ4YI80p0tAlBVKtI/D64nBnClpK4+e4z1AUeEqe2QCwSEoiVWHqzhXkCo9wshF0LGBlX
        MYqnlhbnpqcWG+WllusVJ+YWl+al6yXn525iBCaH0/+Of9nBuOtP0iFGAQ5GJR7eFyW/YoRY
        E8uKK3MPMUpwMCuJ8JZd+BEjxJuSWFmVWpQfX1Sak1p8iFGag0VJnLea4UG0kEB6Yklqdmpq
        QWoRTJaJg1OqgTHpetnTK/V8c00W3Pj+qmLK/sWfJB0mTM85f+nmxTimr0mPVi6fvNI/7aS3
        emnJ5fOCB55G/7h9Zv45JW1hY8/sw8t7gp9NWdKrIFogfnneyl/2hibpxa9VI/wMbrqvOi4t
        u/vLwaf1FjcLL4W5P+X9ynlakH2y9++pGz8yCD4pW3PM22B149xYJZbijERDLeai4kQABz1a
        HQoDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t/xu7ot83/FGOzr07f407aB0eLzkeNs
        FnPOt7BYXGn/yW6xa91MZovLu+awWaw4dILd4tgCMYvt/fsYHTg9tqy8yeSxc9Zddo/Fe14y
        efRtWcXo8XmTXABrlJ5NUX5pSapCRn5xia1StKGFkZ6hpYWekYmlnqGxeayVkamSvp1NSmpO
        Zllqkb5dgl7GrcnH2QuapCqWHkxsYDwi0sXIySEhYCJxfn0XexcjF4eQwFJGiU/rDrFDJKQk
        fvy6wAphC0v8udbFBlH0jVHiyc/ZLCAJNgEdiVOrjzCC2CJADR93bAebxCxwjEni6rUnzCAJ
        YYEQifOP/4JNYhFQlbg15wvYBl4BK4mujg42iA3yEqs3HGCewMizgJFhFaNIamlxbnpusaFe
        cWJucWleul5yfu4mRmBYbjv2c/MOxksbgw8xCnAwKvHwvij5FSPEmlhWXJl7iFGCg1lJhLfs
        wo8YId6UxMqq1KL8+KLSnNTiQ4ymQMsnMkuJJucDYyavJN7Q1NDcwtLQ3Njc2MxCSZy3Q+Bg
        jJBAemJJanZqakFqEUwfEwenVANj7Qz+h39sNk9tKbyW+/eBhK5IgHeTfOy9l+V8VruvKpX5
        BcevlPFTXTVFafOC5s8Z0Z5VtxZXHV8e/jwxNO1secs3IV2tE7fD+VhyJ5x2nj/liuX9Netm
        h6fYt3FeXiGuv3TOMcULsuya/Bs2zoryVlzUkiJSes/abNud5iucTltXnJ2offGGEktxRqKh
        FnNRcSIAOd1uoGECAAA=
X-CMS-MailID: 20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e
References: <CGME20190607173149eucas1p1d2ebedcab469ebd66acfe7c7dcd18d7e@eucas1p1.samsung.com>
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
 net/xdp/xsk.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..3f3979579d21 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -693,6 +693,54 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 			       size, vma->vm_page_prot);
 }
 
+static int xsk_notifier(struct notifier_block *this,
+			unsigned long msg, void *ptr)
+{
+	struct sock *sk;
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+	int i, unregister_count = 0;
+
+	mutex_lock(&net->xdp.lock);
+	sk_for_each(sk, &net->xdp.list) {
+		struct xdp_sock *xs = xdp_sk(sk);
+
+		mutex_lock(&xs->mutex);
+		switch (msg) {
+		case NETDEV_UNREGISTER:
+			if (dev != xs->dev)
+				break;
+
+			sk->sk_err = ENETDOWN;
+			if (!sock_flag(sk, SOCK_DEAD))
+				sk->sk_error_report(sk);
+
+			/* Wait for driver to stop using the xdp socket. */
+			xdp_del_sk_umem(xs->umem, xs);
+			xs->dev = NULL;
+			synchronize_net();
+
+			/* Clear device references in umem. */
+			xdp_put_umem(xs->umem);
+			xs->umem = NULL;
+
+			unregister_count++;
+			break;
+		}
+		mutex_unlock(&xs->mutex);
+	}
+	mutex_unlock(&net->xdp.lock);
+
+	if (unregister_count) {
+		/* Wait for umem clearing completion. */
+		synchronize_net();
+		for (i = 0; i < unregister_count; i++)
+			dev_put(dev);
+	}
+
+	return NOTIFY_DONE;
+}
+
 static struct proto xsk_proto = {
 	.name =		"XDP",
 	.owner =	THIS_MODULE,
@@ -727,7 +775,8 @@ static void xsk_destruct(struct sock *sk)
 	if (!sock_flag(sk, SOCK_DEAD))
 		return;
 
-	xdp_put_umem(xs->umem);
+	if (xs->umem)
+		xdp_put_umem(xs->umem);
 
 	sk_refcnt_debug_dec(sk);
 }
@@ -784,6 +833,10 @@ static const struct net_proto_family xsk_family_ops = {
 	.owner	= THIS_MODULE,
 };
 
+static struct notifier_block xsk_netdev_notifier = {
+	.notifier_call	= xsk_notifier,
+};
+
 static int __net_init xsk_net_init(struct net *net)
 {
 	mutex_init(&net->xdp.lock);
@@ -816,8 +869,15 @@ static int __init xsk_init(void)
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

