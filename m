Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44F8137461
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 14:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbfFFMkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 08:40:24 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:34922 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbfFFMkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 08:40:23 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190606124022euoutp01dcdf292251145816a4965a5798e78af7~lnGlUKcXU2157721577euoutp01-
        for <netdev@vger.kernel.org>; Thu,  6 Jun 2019 12:40:22 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190606124022euoutp01dcdf292251145816a4965a5798e78af7~lnGlUKcXU2157721577euoutp01-
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1559824822;
        bh=Y5QDbSvNeJjyie1lOqEuseCVGP7F8cCUInKekAvvG8s=;
        h=From:To:Cc:Subject:Date:References:From;
        b=mCjsyQdzHSvSQ9J8osPL8ATnipjdtHVWfp+ElTXUbIkAbeYpOupgYJIE6KiRMrclt
         SexngE9WhUCURkJMZwcpwCt9hoPH+8rMAka8fikFXWm5bri4H/ZRNDklFUAPZNqgqY
         wZer+Nfu7j1+bcrrvWIMnph2FvUmkHS+h9OrB4bg=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190606124021eucas1p20a3254ac4d556cc87f7c2e2074de1841~lnGkts2QI1479514795eucas1p23;
        Thu,  6 Jun 2019 12:40:21 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id D8.02.04325.5B909FC5; Thu,  6
        Jun 2019 13:40:21 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190606124020eucas1p2007396ae8f23a426a17e0e5481636187~lnGj5SaWH0841208412eucas1p2l;
        Thu,  6 Jun 2019 12:40:20 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190606124020eusmtrp1a52d1f8862b9a721124ad34e778095d3~lnGjpu4L42301723017eusmtrp1D;
        Thu,  6 Jun 2019 12:40:20 +0000 (GMT)
X-AuditID: cbfec7f5-fbbf09c0000010e5-9f-5cf909b54579
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 86.A4.04140.4B909FC5; Thu,  6
        Jun 2019 13:40:20 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20190606124019eusmtip29b381735e734cfd699abae670fd3bb78~lnGjE83rr2301123011eusmtip2-;
        Thu,  6 Jun 2019 12:40:19 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH] net: Fix hang while unregistering device bound to xdp
 socket
Date:   Thu,  6 Jun 2019 15:40:14 +0300
Message-Id: <20190606124014.23231-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPIsWRmVeSWpSXmKPExsWy7djP87pbOX/GGHycz2Pxp20Do8XnI8fZ
        LOacb2GxuNL+k93i8q45bBYrDp1gtzi2QMxie/8+RgcOjy0rbzJ5LN7zksmjb8sqRo/Pm+QC
        WKK4bFJSczLLUov07RK4Mp6ubGEumKpZcWTRbcYGxgbFLkZODgkBE4mmCSvZuhi5OIQEVjBK
        LPjexAzhfGGU2Le7ESrzmVHic9MmRpiWHRf/Q1UtZ5T49WUnC4Tzg1HibP9iZpAqNgEdiVOr
        j4B1iAhISXzcsZ0dpIhZYDKTxMuXf9lBEsIC/hKvXrwFs1kEVCUuPl0AZvMKWEu8n/aCHWKd
        vMTqDQfA1kkIXGeTmHDlJtQdLhLLuw5A2cISr45vgWqQkTg9uYcFwq6XuN/ykhGiuYNRYvqh
        f0wQCXuJLa/PATVwAJ2kKbF+lz5E2FGiZWErE0hYQoBP4sZbQZAwM5A5adt0Zogwr0RHmxBE
        tYrE74PLmSFsKYmb7z5DXeAhsfXdVlYQW0ggVuJ0/zLGCYxysxB2LWBkXMUonlpanJueWmyc
        l1quV5yYW1yal66XnJ+7iRGYDE7/O/51B+O+P0mHGAU4GJV4eD3Yf8YIsSaWFVfmHmKU4GBW
        EuEtu/AjRog3JbGyKrUoP76oNCe1+BCjNAeLkjhvNcODaCGB9MSS1OzU1ILUIpgsEwenVAOj
        6jaf/Um7pkR2PWUXPfm+b3/RyyVHFkXLHA6r23x2m7vvPJsUh8mTFUIbzgu0/W6qCpwTs/QV
        r6snQ+yUXE8jLvbGt8phlhPKFXK/B+a/32popVev389TwNmZ9V1qq9EyXXHVYwG7HbqiH3PO
        8Tl+ym3Ho60BBVET7TbtVj06bePHJZfEOMSUWIozEg21mIuKEwH3UwNyAgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xe7pbOH/GGMy7L2Txp20Do8XnI8fZ
        LOacb2GxuNL+k93i8q45bBYrDp1gtzi2QMxie/8+RgcOjy0rbzJ5LN7zksmjb8sqRo/Pm+QC
        WKL0bIryS0tSFTLyi0tslaINLYz0DC0t9IxMLPUMjc1jrYxMlfTtbFJSczLLUov07RL0Mp6u
        bGEumKpZcWTRbcYGxgbFLkZODgkBE4kdF/8zdzFycQgJLGWU6H34hhEiISXx49cFVghbWOLP
        tS42iKJvjBKL2mazgyTYBHQkTq0+AtYgAtTwccd2dpAiZoGZTBJ7+k+wgCSEBXwl1r19Dmaz
        CKhKXHy6AKyZV8Ba4v20F+wQG+QlVm84wDyBkWcBI8MqRpHU0uLc9NxiI73ixNzi0rx0veT8
        3E2MwCDcduznlh2MXe+CDzEKcDAq8fDOYPoZI8SaWFZcmXuIUYKDWUmEt+zCjxgh3pTEyqrU
        ovz4otKc1OJDjKZAyycyS4km5wMjJK8k3tDU0NzC0tDc2NzYzEJJnLdD4GCMkEB6Yklqdmpq
        QWoRTB8TB6dUA+OKr74Wx27qrnT/Z+B8pndz10bpJVMrLN47bdvTpWbU8mKRV/DCqol1BnEn
        /67tSzQrF8jjVT/jZVDLsZ/9xNdjx3v+xVr8X37ajbduyf5zsxlPvmCdmqyxVnT5p9YIM6aJ
        DeYFuT9+lwXOfb1mR8WvAytn+Fh9++N8+n5MObP17BLlueEMKjOUWIozEg21mIuKEwFLF3FS
        WAIAAA==
X-CMS-MailID: 20190606124020eucas1p2007396ae8f23a426a17e0e5481636187
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190606124020eucas1p2007396ae8f23a426a17e0e5481636187
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190606124020eucas1p2007396ae8f23a426a17e0e5481636187
References: <CGME20190606124020eucas1p2007396ae8f23a426a17e0e5481636187@eucas1p2.samsung.com>
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

Fix that by counting XDP references for the device and failing
RTM_DELLINK with EBUSY if device is still in use by any XDP socket.

With this change:

  # ip link del p1
  RTNETLINK answers: Device or resource busy

Fixes: 965a99098443 ("xsk: add support for bind for Rx")
Signed-off-by: Ilya Maximets <i.maximets@samsung.com>
---

Another option could be to force closing all the corresponding AF_XDP
sockets, but I didn't figure out how to do this properly yet.

 include/linux/netdevice.h | 25 +++++++++++++++++++++++++
 net/core/dev.c            | 10 ++++++++++
 net/core/rtnetlink.c      |  6 ++++++
 net/xdp/xsk.c             |  7 ++++++-
 4 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 44b47e9df94a..24451cfc5590 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1705,6 +1705,7 @@ enum netdev_priv_flags {
  *	@watchdog_timer:	List of timers
  *
  *	@pcpu_refcnt:		Number of references to this device
+ *	@pcpu_xdp_refcnt:	Number of XDP socket references to this device
  *	@todo_list:		Delayed register/unregister
  *	@link_watch_list:	XXX: need comments on this one
  *
@@ -1966,6 +1967,7 @@ struct net_device {
 	struct timer_list	watchdog_timer;
 
 	int __percpu		*pcpu_refcnt;
+	int __percpu		*pcpu_xdp_refcnt;
 	struct list_head	todo_list;
 
 	struct list_head	link_watch_list;
@@ -2636,6 +2638,7 @@ static inline void unregister_netdevice(struct net_device *dev)
 }
 
 int netdev_refcnt_read(const struct net_device *dev);
+int netdev_xdp_refcnt_read(const struct net_device *dev);
 void free_netdev(struct net_device *dev);
 void netdev_freemem(struct net_device *dev);
 void synchronize_net(void);
@@ -3739,6 +3742,28 @@ static inline void dev_hold(struct net_device *dev)
 	this_cpu_inc(*dev->pcpu_refcnt);
 }
 
+/**
+ *	dev_put_xdp - release xdp reference to device
+ *	@dev: network device
+ *
+ * Decrease the reference counter of XDP sockets bound to device.
+ */
+static inline void dev_put_xdp(struct net_device *dev)
+{
+	this_cpu_dec(*dev->pcpu_xdp_refcnt);
+}
+
+/**
+ *	dev_hold_xdp - get xdp reference to device
+ *	@dev: network device
+ *
+ * Increase the reference counter of XDP sockets bound to device.
+ */
+static inline void dev_hold_xdp(struct net_device *dev)
+{
+	this_cpu_inc(*dev->pcpu_xdp_refcnt);
+}
+
 /* Carrier loss detection, dial on demand. The functions netif_carrier_on
  * and _off may be called from IRQ context, but it is caller
  * who is responsible for serialization of these calls.
diff --git a/net/core/dev.c b/net/core/dev.c
index 66f7508825bd..f6f7cf3d8e93 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8840,6 +8840,16 @@ int netdev_refcnt_read(const struct net_device *dev)
 }
 EXPORT_SYMBOL(netdev_refcnt_read);
 
+int netdev_xdp_refcnt_read(const struct net_device *dev)
+{
+	int i, refcnt = 0;
+
+	for_each_possible_cpu(i)
+		refcnt += *per_cpu_ptr(dev->pcpu_xdp_refcnt, i);
+	return refcnt;
+}
+EXPORT_SYMBOL(netdev_xdp_refcnt_read);
+
 /**
  * netdev_wait_allrefs - wait until all references are gone.
  * @dev: target net_device
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index adcc045952c2..f88bf52d41b3 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2777,6 +2777,9 @@ static int rtnl_group_dellink(const struct net *net, int group)
 			ops = dev->rtnl_link_ops;
 			if (!ops || !ops->dellink)
 				return -EOPNOTSUPP;
+
+			if (netdev_xdp_refcnt_read(dev))
+				return -EBUSY;
 		}
 	}
 
@@ -2805,6 +2808,9 @@ int rtnl_delete_link(struct net_device *dev)
 	if (!ops || !ops->dellink)
 		return -EOPNOTSUPP;
 
+	if (netdev_xdp_refcnt_read(dev))
+		return -EBUSY;
+
 	ops->dellink(dev, &list_kill);
 	unregister_netdevice_many(&list_kill);
 
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..215cc8712b8d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -361,6 +361,7 @@ static int xsk_release(struct socket *sock)
 		xdp_del_sk_umem(xs->umem, xs);
 		xs->dev = NULL;
 		synchronize_net();
+		dev_put_xdp(dev);
 		dev_put(dev);
 	}
 
@@ -423,6 +424,8 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 		goto out_release;
 	}
 
+	dev_hold_xdp(dev);
+
 	if (!xs->rx && !xs->tx) {
 		err = -EINVAL;
 		goto out_unlock;
@@ -490,8 +493,10 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 	xdp_add_sk_umem(xs->umem, xs);
 
 out_unlock:
-	if (err)
+	if (err) {
+		dev_put_xdp(dev);
 		dev_put(dev);
+	}
 out_release:
 	mutex_unlock(&xs->mutex);
 	return err;
-- 
2.17.1

