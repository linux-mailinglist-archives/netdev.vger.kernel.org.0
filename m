Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C68193D03
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 11:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCZKiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 06:38:23 -0400
Received: from zimbra.alphalink.fr ([217.15.80.77]:58787 "EHLO
        zimbra.alphalink.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbgCZKiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 06:38:23 -0400
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2020 06:38:20 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id EF4E92B52099;
        Thu, 26 Mar 2020 11:32:44 +0100 (CET)
Received: from zimbra.alphalink.fr ([127.0.0.1])
        by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id eUOqV9Rr6eSK; Thu, 26 Mar 2020 11:32:43 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTP id 04E072B520E2;
        Thu, 26 Mar 2020 11:32:43 +0100 (CET)
X-Virus-Scanned: amavisd-new at mail-2-cbv2.admin.alphalink.fr
Received: from zimbra.alphalink.fr ([127.0.0.1])
        by localhost (mail-2-cbv2.admin.alphalink.fr [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id z2xZceEQnnXJ; Thu, 26 Mar 2020 11:32:42 +0100 (CET)
Received: from debian.localdomain (94-84-15-217.reverse.alphalink.fr [217.15.84.94])
        by mail-2-cbv2.admin.alphalink.fr (Postfix) with ESMTPSA id 640412B52034;
        Thu, 26 Mar 2020 11:32:42 +0100 (CET)
From:   Simon Chopin <s.chopin@alphalink.fr>
To:     netdev@vger.kernel.org
Cc:     Michal Ostrowski <mostrows@earthlink.net>,
        "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Guillaume Nault <gnault@redhat.com>,
        Simon Chopin <s.chopin@alphalink.fr>
Subject: [PATCH net-next] pppoe: new ioctl to extract per-channel stats
Date:   Thu, 26 Mar 2020 11:32:30 +0100
Message-Id: <20200326103230.121447-1-s.chopin@alphalink.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PPP subsystem uses the abstractions of channels and units, the
latter being an aggregate of the former, exported to userspace as a
single network interface.  As such, it keeps traffic statistics at the
unit level, but there are no statistics on the individual channels,
partly because most PPP units only have one channel.

However, it is sometimes useful to have statistics at the channel level,
for instance to monitor multilink PPP connections. Such statistics
already exist for PPPoL2TP via the PPPIOCGL2TPSTATS ioctl, this patch
introduces a very similar mechanism for PPPoE via a new
PPPIOCGPPPOESTATS ioctl.

The contents of this patch were greatly inspired by the L2TP
implementation, many thanks to its authors.

Signed-off-by: Simon Chopin <s.chopin@alphalink.fr>
---
 drivers/net/ppp/pppoe.c        | 45 ++++++++++++++++++++++++++++++++++
 include/uapi/linux/ppp-ioctl.h |  9 +++++++
 2 files changed, 54 insertions(+)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index d760a36db28c..6a3d98d720d5 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -72,6 +72,7 @@
 #include <linux/file.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/atomic.h>
=20
 #include <linux/nsproxy.h>
 #include <net/net_namespace.h>
@@ -104,6 +105,13 @@ struct pppoe_net {
 	rwlock_t hash_lock;
 };
=20
+struct pppoe_stats {
+	atomic_long_t	tx_packets;
+	atomic_long_t	tx_bytes;
+	atomic_long_t	rx_packets;
+	atomic_long_t	rx_bytes;
+};
+
 /*
  * PPPoE could be in the following stages:
  * 1) Discovery stage (to obtain remote MAC and Session ID)
@@ -366,6 +374,8 @@ static int pppoe_rcv_core(struct sock *sk, struct sk_=
buff *skb)
 {
 	struct pppox_sock *po =3D pppox_sk(sk);
 	struct pppox_sock *relay_po;
+	struct pppoe_stats *stats;
+	size_t len =3D skb->len;
=20
 	/* Backlog receive. Semantics of backlog rcv preclude any code from
 	 * executing in lock_sock()/release_sock() bounds; meaning sk->sk_state
@@ -395,6 +405,10 @@ static int pppoe_rcv_core(struct sock *sk, struct sk=
_buff *skb)
 			goto abort_kfree;
 	}
=20
+	stats =3D sk_pppox(po)->sk_user_data;
+	atomic_long_inc(&stats->rx_packets);
+	atomic_long_add(len, &stats->rx_bytes);
+
 	return NET_RX_SUCCESS;
=20
 abort_put:
@@ -549,6 +563,8 @@ static int pppoe_create(struct net *net, struct socke=
t *sock, int kern)
 	sk->sk_family		=3D PF_PPPOX;
 	sk->sk_protocol		=3D PX_PROTO_OE;
=20
+	sk->sk_user_data =3D kzalloc(sizeof(struct pppoe_stats), GFP_KERNEL);
+
 	INIT_WORK(&pppox_sk(sk)->proto.pppoe.padt_work,
 		  pppoe_unbind_sock_work);
=20
@@ -593,6 +609,8 @@ static int pppoe_release(struct socket *sock)
 	delete_item(pn, po->pppoe_pa.sid, po->pppoe_pa.remote,
 		    po->pppoe_ifindex);
=20
+	kfree(sk->sk_user_data);
+	sk->sk_user_data =3D NULL;
 	sock_orphan(sk);
 	sock->sk =3D NULL;
=20
@@ -730,11 +748,23 @@ static int pppoe_getname(struct socket *sock, struc=
t sockaddr *uaddr,
 	return len;
 }
=20
+static void pppoe_copy_stats(struct pppoe_ioc_stats *dest,
+			     const struct pppoe_stats *stats)
+{
+	memset(dest, 0, sizeof(*dest));
+
+	dest->tx_packets =3D atomic_long_read(&stats->tx_packets);
+	dest->tx_bytes =3D atomic_long_read(&stats->tx_bytes);
+	dest->rx_packets =3D atomic_long_read(&stats->rx_packets);
+	dest->rx_bytes =3D atomic_long_read(&stats->rx_bytes);
+}
+
 static int pppoe_ioctl(struct socket *sock, unsigned int cmd,
 		unsigned long arg)
 {
 	struct sock *sk =3D sock->sk;
 	struct pppox_sock *po =3D pppox_sk(sk);
+	struct pppoe_ioc_stats stats;
 	int val;
 	int err;
=20
@@ -823,6 +853,18 @@ static int pppoe_ioctl(struct socket *sock, unsigned=
 int cmd,
 		err =3D 0;
 		break;
=20
+	case PPPIOCGPPPOESTATS:
+		err =3D -EBUSY;
+		/* Check that the stats struct hasn't been freed yet */
+		if (sk->sk_state & PPPOX_DEAD)
+			break;
+
+		pppoe_copy_stats(&stats, sk->sk_user_data);
+		err =3D 0;
+		if (copy_to_user((void __user *)arg, &stats, sizeof(stats)))
+			err =3D -EFAULT;
+		break;
+
 	default:
 		err =3D -ENOTTY;
 	}
@@ -910,6 +952,7 @@ static int __pppoe_xmit(struct sock *sk, struct sk_bu=
ff *skb)
 {
 	struct pppox_sock *po =3D pppox_sk(sk);
 	struct net_device *dev =3D po->pppoe_dev;
+	struct pppoe_stats *stats =3D sk->sk_user_data;
 	struct pppoe_hdr *ph;
 	int data_len =3D skb->len;
=20
@@ -950,6 +993,8 @@ static int __pppoe_xmit(struct sock *sk, struct sk_bu=
ff *skb)
 			po->pppoe_pa.remote, NULL, data_len);
=20
 	dev_queue_xmit(skb);
+	atomic_long_inc(&stats->tx_packets);
+	atomic_long_add(data_len, &stats->tx_bytes);
 	return 1;
=20
 abort:
diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioct=
l.h
index 7bd2a5a75348..a0abc68eceb5 100644
--- a/include/uapi/linux/ppp-ioctl.h
+++ b/include/uapi/linux/ppp-ioctl.h
@@ -79,6 +79,14 @@ struct pppol2tp_ioc_stats {
 	__aligned_u64	rx_errors;
 };
=20
+/* For PPPIOCGPPPOESTATS */
+struct pppoe_ioc_stats {
+	__aligned_u64	tx_packets;
+	__aligned_u64	tx_bytes;
+	__aligned_u64	rx_packets;
+	__aligned_u64	rx_bytes;
+};
+
 /*
  * Ioctl definitions.
  */
@@ -115,6 +123,7 @@ struct pppol2tp_ioc_stats {
 #define PPPIOCATTCHAN	_IOW('t', 56, int)	/* attach to ppp channel */
 #define PPPIOCGCHAN	_IOR('t', 55, int)	/* get ppp channel number */
 #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
+#define PPPIOCGPPPOESTATS _IOR('t', 53, struct pppoe_ioc_stats)
=20
 #define SIOCGPPPSTATS   (SIOCDEVPRIVATE + 0)
 #define SIOCGPPPVER     (SIOCDEVPRIVATE + 1)	/* NEVER change this!! */

base-commit: 16fbf79b0f83bc752cee8589279f1ebfe57b3b6e
--=20
2.25.1

