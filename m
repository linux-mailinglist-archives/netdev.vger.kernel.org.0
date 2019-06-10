Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9063B92E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391511AbfFJQPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:15:55 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58163 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391407AbfFJQPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:15:54 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190610161553euoutp02a560eefaafb1ce0bfba79048f0a399cd~m4n5UCfqX2369923699euoutp02g
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 16:15:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190610161553euoutp02a560eefaafb1ce0bfba79048f0a399cd~m4n5UCfqX2369923699euoutp02g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1560183353;
        bh=Bl4Z2kbZhq5qTBIXYpPKsmDTnUuT2A/5m5i+xHOe8Kk=;
        h=From:To:Cc:Subject:Date:References:From;
        b=pjKebCunbR5GjbXuAyBin7Un3Pg6ZEcbClqcovId1vnI3ysxRO/9Df12vveBhrSvf
         xeY7XuQtzMXC5qqmKd++L/e6BgSsxSB1Kulmuk1wsAKz0S+Cz2KJH3/hKUr4Mrb+qt
         PzlwQu76x+skrdy4hICMZl1oORjxWOvqjcLuMdN8=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190610161552eucas1p163b5c5f39ae0b54dffa0a1a2142a4d1c~m4n4nz1es1445614456eucas1p1f;
        Mon, 10 Jun 2019 16:15:52 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id A7.C4.04298.8328EFC5; Mon, 10
        Jun 2019 17:15:52 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df~m4n3ziPGM1445014450eucas1p1f;
        Mon, 10 Jun 2019 16:15:51 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190610161551eusmtrp2bb77719d05996361f774ddf6190ceb42~m4n3j43sU1476914769eusmtrp2f;
        Mon, 10 Jun 2019 16:15:51 +0000 (GMT)
X-AuditID: cbfec7f2-f2dff700000010ca-db-5cfe82386180
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 4B.C3.04140.7328EFC5; Mon, 10
        Jun 2019 17:15:51 +0100 (BST)
Received: from imaximets.rnd.samsung.ru (unknown [106.109.129.180]) by
        eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20190610161550eusmtip18b2cd7fd8af6f2194ff1a158e0e4afb5~m4n24B_uB2310323103eusmtip1K;
        Mon, 10 Jun 2019 16:15:50 +0000 (GMT)
From:   Ilya Maximets <i.maximets@samsung.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        xdp-newbies@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Ilya Maximets <i.maximets@samsung.com>
Subject: [PATCH bpf v3] xdp: fix hang while unregistering device bound to
 xdp socket
Date:   Mon, 10 Jun 2019 19:15:46 +0300
Message-Id: <20190610161546.30569-1-i.maximets@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42LZduznOV2Lpn8xBru62C3+tG1gtPh85Dib
        xZzzLSwWV9p/slsce9HCZrFr3Uxmi8u75rBZrDh0Aii2QMxie/8+Rgcujy0rbzJ57Jx1l91j
        8Z6XTB7Tux8ye/RtWcXo8XmTXABbFJdNSmpOZllqkb5dAlfGtK1zWQpWyFTsW3CEvYFxolgX
        IyeHhICJxL+Lt5m6GLk4hARWMEqcOrqKFcL5wigx8elWNgjnM6PEtHnbGWFa7lz4wQyRWA6U
        +NcD1fKDUWJr5yp2kCo2AR2JU6uPgHWICEhJfNyxnR2kiFngI5PE+5ffmUESwgJhEjeWtrKB
        2CwCqhKzZ68Csjk4eAWsJR5u9YTYJi+xesMBZgj7NZvE84mxELaLRMfc12wQtrDEq+Nb2CFs
        GYn/O+czQdj1EvdbXjKC7JUQ6GCUmH7oH1TCXmLL63PsILuYBTQl1u/SBzElBBwlNr1RgzD5
        JG68FQQpZgYyJ22bzgwR5pXoaBOCmKEi8fvgcqjDpCRuvvsMdYCHxPaudWBxIYFYiSnH57JO
        YJSbhbBqASPjKkbx1NLi3PTUYsO81HK94sTc4tK8dL3k/NxNjMB0cfrf8U87GL9eSjrEKMDB
        qMTDGxH9L0aINbGsuDL3EKMEB7OSCO8KKaAQb0piZVVqUX58UWlOavEhRmkOFiVx3mqGB9FC
        AumJJanZqakFqUUwWSYOTqkGxgkclcfz+/QE1tr5bczJyLUo+9pRx/Bjn7Wk8PWgt2wB0zjU
        Y4Nk6yapCbanHbbZnpvTkXP7l8q6fzfWaR7OcgmecI9Nwqb7q+XSql+rZ6x6xvb/inBx5/fv
        BZv9n8ukHVS+6D5P5LDf142dvXPm7PrMrW5jqxGobe5cocqvvfXesvOZ233fKLEUZyQaajEX
        FScCAEhtbw4TAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGLMWRmVeSWpSXmKPExsVy+t/xu7rmTf9iDNq3cVn8advAaPH5yHE2
        iznnW1gsrrT/ZLc49qKFzWLXupnMFpd3zWGzWHHoBFBsgZjF9v59jA5cHltW3mTy2DnrLrvH
        4j0vmTymdz9k9ujbsorR4/MmuQC2KD2bovzSklSFjPziElulaEMLIz1DSws9IxNLPUNj81gr
        I1MlfTublNSczLLUIn27BL2MaVvnshSskKnYt+AIewPjRLEuRk4OCQETiTsXfjCD2EICSxkl
        WlYwQsSlJH78usAKYQtL/LnWxdbFyAVU841R4n33crAGNgEdiVOrj4A1iAA1fNyxnR3EZhb4
        ziRx/F4wiC0sECKx4/oTsEEsAqoSs2evAhrEwcErYC3xcKsnxHx5idUbDjBPYORZwMiwilEk
        tbQ4Nz232EivODG3uDQvXS85P3cTIzBMtx37uWUHY9e74EOMAhyMSjy8EdH/YoRYE8uKK3MP
        MUpwMCuJ8K6QAgrxpiRWVqUW5ccXleakFh9iNAXaPZFZSjQ5HxhDeSXxhqaG5haWhubG5sZm
        FkrivB0CB2OEBNITS1KzU1MLUotg+pg4OKUaGC9qLD2WcXjtS+HFjB8zH58OPfQ1WVuLRbZa
        Wa3u+H3bm9arl+7gc1IofcVcP1FDYcbpuyzhn3drvpyf9bBv37aHW6ZnRTin9c9eIbjo17Zd
        jOrJLJ2q061nfb1m4KFZsHDfXINX2lasfE8i3gfn54n25Vq8Lsmv02fMPyvbnBb3R/hOVOua
        E0osxRmJhlrMRcWJAL+S1ohpAgAA
X-CMS-MailID: 20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df
References: <CGME20190610161551eucas1p1f370190ee6d0d5e921de1a21f3da72df@eucas1p1.samsung.com>
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

Version 3:

    * Declaration lines ordered from longest to shortest.
    * Checking of event type moved to the top to avoid unnecessary
      locking.

Version 2:

    * Completely re-implemented using netdev event handler.

 net/xdp/xsk.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index a14e8864e4fa..273a419a8c4d 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -693,6 +693,57 @@ static int xsk_mmap(struct file *file, struct socket *sock,
 			       size, vma->vm_page_prot);
 }
 
+static int xsk_notifier(struct notifier_block *this,
+			unsigned long msg, void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+	struct net *net = dev_net(dev);
+	int i, unregister_count = 0;
+	struct sock *sk;
+
+	switch (msg) {
+	case NETDEV_UNREGISTER:
+		mutex_lock(&net->xdp.lock);
+		sk_for_each(sk, &net->xdp.list) {
+			struct xdp_sock *xs = xdp_sk(sk);
+
+			mutex_lock(&xs->mutex);
+			if (dev != xs->dev) {
+				mutex_unlock(&xs->mutex);
+				continue;
+			}
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
+			mutex_unlock(&xs->mutex);
+			unregister_count++;
+		}
+		mutex_unlock(&net->xdp.lock);
+
+		if (unregister_count) {
+			/* Wait for umem clearing completion. */
+			synchronize_net();
+			for (i = 0; i < unregister_count; i++)
+				dev_put(dev);
+		}
+
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 static struct proto xsk_proto = {
 	.name =		"XDP",
 	.owner =	THIS_MODULE,
@@ -727,7 +778,8 @@ static void xsk_destruct(struct sock *sk)
 	if (!sock_flag(sk, SOCK_DEAD))
 		return;
 
-	xdp_put_umem(xs->umem);
+	if (xs->umem)
+		xdp_put_umem(xs->umem);
 
 	sk_refcnt_debug_dec(sk);
 }
@@ -784,6 +836,10 @@ static const struct net_proto_family xsk_family_ops = {
 	.owner	= THIS_MODULE,
 };
 
+static struct notifier_block xsk_netdev_notifier = {
+	.notifier_call	= xsk_notifier,
+};
+
 static int __net_init xsk_net_init(struct net *net)
 {
 	mutex_init(&net->xdp.lock);
@@ -816,8 +872,15 @@ static int __init xsk_init(void)
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

