Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C04C02B455B
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729730AbgKPN7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 08:59:14 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:53871 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729674AbgKPN7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 08:59:13 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kef2A-0001Eu-PR; Mon, 16 Nov 2020 14:59:06 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1kef29-0004bc-Jd; Mon, 16 Nov 2020 14:59:05 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 1EBE9240049;
        Mon, 16 Nov 2020 14:59:05 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 92F64240047;
        Mon, 16 Nov 2020 14:59:04 +0100 (CET)
Received: from mschiller01.dev.tdt.de (unknown [10.2.3.20])
        by mail.dev.tdt.de (Postfix) with ESMTPSA id AE8B8200AE;
        Mon, 16 Nov 2020 14:59:03 +0100 (CET)
From:   Martin Schiller <ms@dev.tdt.de>
To:     andrew.hendry@gmail.com, davem@davemloft.net, kuba@kernel.org,
        xie.he.0141@gmail.com
Cc:     linux-x25@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Martin Schiller <ms@dev.tdt.de>
Subject: [PATCH net-next v2 2/6] net/x25: make neighbour params configurable
Date:   Mon, 16 Nov 2020 14:55:20 +0100
Message-ID: <20201116135522.21791-3-ms@dev.tdt.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201116135522.21791-1-ms@dev.tdt.de>
References: <20201116135522.21791-1-ms@dev.tdt.de>
MIME-Version: 1.0
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Content-Transfer-Encoding: quoted-printable
X-purgate-ID: 151534::1605535146-0000CF01-311A93D8/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended struct x25_neigh and x25_subscrip_struct to configure following
params through SIOCX25SSUBSCRIP:
  o mode (DTE/DCE)
  o number of channels
  o facilities (packet size, window size)
  o timer T20

Based on this configuration options the following changes/extensions
where made:
  o DTE/DCE handling to select the next lc (DCE=3Dfrom bottom / DTE=3Dfro=
m
    top)
  o DTE/DCE handling to set correct clear/reset/restart cause
  o take default facilities from neighbour settings

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
---

Change from v1:
o fix 'subject_prefix' and 'checkpatch' warnings
o fix incompatible assignment of 'struct compat_x25_facilities'

---
 include/net/x25.h        |   8 ++-
 include/uapi/linux/x25.h |  56 ++++++++-------
 net/x25/af_x25.c         | 145 ++++++++++++++++++++++++++++++++-------
 net/x25/x25_facilities.c |   6 +-
 net/x25/x25_link.c       |  97 ++++++++++++++++++++++----
 net/x25/x25_subr.c       |  22 +++++-
 6 files changed, 268 insertions(+), 66 deletions(-)

diff --git a/include/net/x25.h b/include/net/x25.h
index 4c1502e8b2b2..ec00f595fcc6 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -140,6 +140,9 @@ struct x25_neigh {
 	struct net_device	*dev;
 	unsigned int		state;
 	unsigned int		extended;
+	unsigned int		dce;
+	unsigned int		lc;
+	struct x25_facilities	facilities;
 	struct sk_buff_head	queue;
 	unsigned long		t20;
 	struct timer_list	t20timer;
@@ -164,6 +167,8 @@ struct x25_sock {
 	struct timer_list	timer;
 	struct x25_causediag	causediag;
 	struct x25_facilities	facilities;
+	/* set, if facilities changed by SIOCX25SFACILITIES */
+	unsigned int		socket_defined_facilities;
 	struct x25_dte_facilities dte_facilities;
 	struct x25_calluserdata	calluserdata;
 	unsigned long 		vc_facil_mask;	/* inc_call facilities mask */
@@ -215,7 +220,8 @@ int x25_create_facilities(unsigned char *, struct x25=
_facilities *,
 			  struct x25_dte_facilities *, unsigned long);
 int x25_negotiate_facilities(struct sk_buff *, struct sock *,
 			     struct x25_facilities *,
-			     struct x25_dte_facilities *);
+				struct x25_dte_facilities *,
+				struct x25_neigh *);
 void x25_limit_facilities(struct x25_facilities *, struct x25_neigh *);
=20
 /* x25_forward.c */
diff --git a/include/uapi/linux/x25.h b/include/uapi/linux/x25.h
index 034b7dc5593a..094dc2cff37b 100644
--- a/include/uapi/linux/x25.h
+++ b/include/uapi/linux/x25.h
@@ -63,31 +63,6 @@ struct sockaddr_x25 {
 	struct x25_address sx25_addr;		/* X.121 Address */
 };
=20
-/*
- *	DTE/DCE subscription options.
- *
- *      As this is missing lots of options, user should expect major
- *	changes of this structure in 2.5.x which might break compatibilty.
- *      The somewhat ugly dimension 200-sizeof() is needed to maintain
- *	backward compatibility.
- */
-struct x25_subscrip_struct {
-	char device[200-sizeof(unsigned long)];
-	unsigned long	global_facil_mask;	/* 0 to disable negotiation */
-	unsigned int	extended;
-};
-
-/* values for above global_facil_mask */
-
-#define	X25_MASK_REVERSE	0x01=09
-#define	X25_MASK_THROUGHPUT	0x02
-#define	X25_MASK_PACKET_SIZE	0x04
-#define	X25_MASK_WINDOW_SIZE	0x08
-
-#define X25_MASK_CALLING_AE 0x10
-#define X25_MASK_CALLED_AE 0x20
-
-
 /*
  *	Routing table control structure.
  */
@@ -127,6 +102,37 @@ struct x25_dte_facilities {
 	__u8 called_ae[20];
 };
=20
+/*
+ *	DTE/DCE subscription options.
+ *
+ *      As this is missing lots of options, user should expect major
+ *	changes of this structure in 2.5.x which might break compatibility.
+ *      The somewhat ugly dimension 200-sizeof() is needed to maintain
+ *	backward compatibility.
+ */
+struct x25_subscrip_struct {
+	char device[200 - ((2 * sizeof(unsigned long)) +
+		    sizeof(struct x25_facilities) +
+		    (2 * sizeof(unsigned int)))];
+	unsigned int		dce;
+	unsigned int		lc;
+	struct x25_facilities	facilities;
+	unsigned long		t20;
+	unsigned long		global_facil_mask;	/* 0 to disable negotiation */
+	unsigned int		extended;
+};
+
+/* values for above global_facil_mask */
+
+#define	X25_MASK_REVERSE	0x01
+#define	X25_MASK_THROUGHPUT	0x02
+#define	X25_MASK_PACKET_SIZE	0x04
+#define	X25_MASK_WINDOW_SIZE	0x08
+
+#define X25_MASK_CALLING_AE 0x10
+#define X25_MASK_CALLED_AE 0x20
+
+
 /*
  *	Call User Data structure.
  */
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index d2a52c254cca..4c2a395fdbdb 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -72,8 +72,21 @@ static const struct proto_ops x25_proto_ops;
 static const struct x25_address null_x25_address =3D {"               "}=
;
=20
 #ifdef CONFIG_COMPAT
+struct compat_x25_facilities {
+	compat_uint_t	winsize_in, winsize_out;
+	compat_uint_t	pacsize_in, pacsize_out;
+	compat_uint_t	throughput;
+	compat_uint_t	reverse;
+};
+
 struct compat_x25_subscrip_struct {
-	char device[200-sizeof(compat_ulong_t)];
+	char device[200 - ((2 * sizeof(compat_ulong_t)) +
+		    sizeof(struct compat_x25_facilities) +
+		    (2 * sizeof(compat_uint_t)))];
+	compat_uint_t		dce;
+	compat_uint_t		lc;
+	struct compat_x25_facilities	facilities;
+	compat_ulong_t		t20;
 	compat_ulong_t global_facil_mask;
 	compat_uint_t extended;
 };
@@ -373,13 +386,26 @@ static unsigned int x25_new_lci(struct x25_neigh *n=
b)
 	unsigned int lci =3D 1;
 	struct sock *sk;
=20
-	while ((sk =3D x25_find_socket(lci, nb)) !=3D NULL) {
-		sock_put(sk);
-		if (++lci =3D=3D 4096) {
-			lci =3D 0;
-			break;
+	if (nb->dce) {
+		while ((sk =3D x25_find_socket(lci, nb)) !=3D NULL) {
+			sock_put(sk);
+			if (++lci > nb->lc) {
+				lci =3D 0;
+				break;
+			}
+			cond_resched();
+		}
+	} else {
+		lci =3D nb->lc;
+
+		while ((sk =3D x25_find_socket(lci, nb)) !=3D NULL) {
+			sock_put(sk);
+			if (--lci =3D=3D 0) {
+				lci =3D 0;
+				break;
+			}
+			cond_resched();
 		}
-		cond_resched();
 	}
=20
 	return lci;
@@ -813,6 +839,10 @@ static int x25_connect(struct socket *sock, struct s=
ockaddr *uaddr,
 	if (!x25->neighbour)
 		goto out_put_route;
=20
+	if (!x25->socket_defined_facilities)
+		memcpy(&x25->facilities, &x25->neighbour->facilities,
+		       sizeof(struct x25_facilities));
+
 	x25_limit_facilities(&x25->facilities, x25->neighbour);
=20
 	x25->lci =3D x25_new_lci(x25->neighbour);
@@ -1046,7 +1076,7 @@ int x25_rx_call_request(struct sk_buff *skb, struct=
 x25_neigh *nb,
 	/*
 	 *	Try to reach a compromise on the requested facilities.
 	 */
-	len =3D x25_negotiate_facilities(skb, sk, &facilities, &dte_facilities)=
;
+	len =3D x25_negotiate_facilities(skb, sk, &facilities, &dte_facilities,=
 nb);
 	if (len =3D=3D -1)
 		goto out_sock_put;
=20
@@ -1460,10 +1490,15 @@ static int x25_ioctl(struct socket *sock, unsigne=
d int cmd, unsigned long arg)
 		rc =3D x25_subscr_ioctl(cmd, argp);
 		break;
 	case SIOCX25GFACILITIES: {
+		rc =3D -EINVAL;
 		lock_sock(sk);
+		if (sk->sk_state !=3D TCP_ESTABLISHED &&
+		    !x25->socket_defined_facilities)
+			goto out_gfac_release;
 		rc =3D copy_to_user(argp, &x25->facilities,
 				  sizeof(x25->facilities))
 			? -EFAULT : 0;
+out_gfac_release:
 		release_sock(sk);
 		break;
 	}
@@ -1477,16 +1512,16 @@ static int x25_ioctl(struct socket *sock, unsigne=
d int cmd, unsigned long arg)
 		lock_sock(sk);
 		if (sk->sk_state !=3D TCP_LISTEN &&
 		    sk->sk_state !=3D TCP_CLOSE)
-			goto out_fac_release;
+			goto out_sfac_release;
 		if (facilities.pacsize_in < X25_PS16 ||
 		    facilities.pacsize_in > X25_PS4096)
-			goto out_fac_release;
+			goto out_sfac_release;
 		if (facilities.pacsize_out < X25_PS16 ||
 		    facilities.pacsize_out > X25_PS4096)
-			goto out_fac_release;
+			goto out_sfac_release;
 		if (facilities.winsize_in < 1 ||
 		    facilities.winsize_in > 127)
-			goto out_fac_release;
+			goto out_sfac_release;
 		if (facilities.throughput) {
 			int out =3D facilities.throughput & 0xf0;
 			int in  =3D facilities.throughput & 0x0f;
@@ -1494,19 +1529,20 @@ static int x25_ioctl(struct socket *sock, unsigne=
d int cmd, unsigned long arg)
 				facilities.throughput |=3D
 					X25_DEFAULT_THROUGHPUT << 4;
 			else if (out < 0x30 || out > 0xD0)
-				goto out_fac_release;
+				goto out_sfac_release;
 			if (!in)
 				facilities.throughput |=3D
 					X25_DEFAULT_THROUGHPUT;
 			else if (in < 0x03 || in > 0x0D)
-				goto out_fac_release;
+				goto out_sfac_release;
 		}
 		if (facilities.reverse &&
 		    (facilities.reverse & 0x81) !=3D 0x81)
-			goto out_fac_release;
+			goto out_sfac_release;
 		x25->facilities =3D facilities;
+		x25->socket_defined_facilities =3D 1;
 		rc =3D 0;
-out_fac_release:
+out_sfac_release:
 		release_sock(sk);
 		break;
 	}
@@ -1658,6 +1694,9 @@ static int compat_x25_subscr_ioctl(unsigned int cmd=
,
 	struct net_device *dev;
 	int rc =3D -EINVAL;
=20
+	if (cmd !=3D SIOCX25GSUBSCRIP && cmd !=3D SIOCX25SSUBSCRIP)
+		goto out;
+
 	rc =3D -EFAULT;
 	if (copy_from_user(&x25_subscr, x25_subscr32, sizeof(*x25_subscr32)))
 		goto out;
@@ -1671,28 +1710,86 @@ static int compat_x25_subscr_ioctl(unsigned int c=
md,
 	if (nb =3D=3D NULL)
 		goto out_dev_put;
=20
-	dev_put(dev);
-
 	if (cmd =3D=3D SIOCX25GSUBSCRIP) {
 		read_lock_bh(&x25_neigh_list_lock);
 		x25_subscr.extended =3D nb->extended;
+		x25_subscr.dce		     =3D nb->dce;
+		x25_subscr.lc		     =3D nb->lc;
+		x25_subscr.facilities.winsize_in =3D nb->facilities.winsize_in;
+		x25_subscr.facilities.winsize_out =3D nb->facilities.winsize_out;
+		x25_subscr.facilities.pacsize_in =3D nb->facilities.pacsize_in;
+		x25_subscr.facilities.pacsize_out =3D nb->facilities.pacsize_out;
+		x25_subscr.facilities.throughput =3D nb->facilities.throughput;
+		x25_subscr.facilities.reverse =3D nb->facilities.reverse;
+		x25_subscr.t20		     =3D nb->t20;
 		x25_subscr.global_facil_mask =3D nb->global_facil_mask;
 		read_unlock_bh(&x25_neigh_list_lock);
 		rc =3D copy_to_user(x25_subscr32, &x25_subscr,
 				sizeof(*x25_subscr32)) ? -EFAULT : 0;
 	} else {
 		rc =3D -EINVAL;
-		if (x25_subscr.extended =3D=3D 0 || x25_subscr.extended =3D=3D 1) {
-			rc =3D 0;
-			write_lock_bh(&x25_neigh_list_lock);
-			nb->extended =3D x25_subscr.extended;
-			nb->global_facil_mask =3D x25_subscr.global_facil_mask;
-			write_unlock_bh(&x25_neigh_list_lock);
+
+		if (dev->flags & IFF_UP)
+			return -EBUSY;
+
+		if (x25_subscr.extended !=3D 0 && x25_subscr.extended !=3D 1)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.dce !=3D 0 && x25_subscr.dce !=3D 1)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.lc < 1 || x25_subscr.lc > 4095)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.facilities.pacsize_in < X25_PS16 ||
+		    x25_subscr.facilities.pacsize_in > X25_PS4096)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.facilities.pacsize_out < X25_PS16 ||
+		    x25_subscr.facilities.pacsize_out > X25_PS4096)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.facilities.winsize_in < 1 ||
+		    x25_subscr.facilities.winsize_in > 127)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.facilities.throughput) {
+			int out =3D x25_subscr.facilities.throughput & 0xf0;
+			int in  =3D x25_subscr.facilities.throughput & 0x0f;
+
+			if (!out)
+				x25_subscr.facilities.throughput |=3D
+					X25_DEFAULT_THROUGHPUT << 4;
+			else if (out < 0x30 || out > 0xD0)
+				goto out_dev_and_neigh_put;
+			if (!in)
+				x25_subscr.facilities.throughput |=3D
+					X25_DEFAULT_THROUGHPUT;
+			else if (in < 0x03 || in > 0x0D)
+				goto out_dev_and_neigh_put;
 		}
+		if (x25_subscr.facilities.reverse &&
+		    (x25_subscr.facilities.reverse & 0x81) !=3D 0x81)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.t20 < 1 * HZ || x25_subscr.t20 > 300 * HZ)
+			goto out_dev_and_neigh_put;
+
+		rc =3D 0;
+		write_lock_bh(&x25_neigh_list_lock);
+		nb->extended	      =3D x25_subscr.extended;
+		nb->dce		      =3D x25_subscr.dce;
+		nb->lc		      =3D x25_subscr.lc;
+		nb->facilities.winsize_in =3D x25_subscr.facilities.winsize_in;
+		nb->facilities.winsize_out =3D x25_subscr.facilities.winsize_out;
+		nb->facilities.pacsize_in =3D x25_subscr.facilities.pacsize_in;
+		nb->facilities.pacsize_out =3D x25_subscr.facilities.pacsize_out;
+		nb->facilities.throughput =3D x25_subscr.facilities.throughput;
+		nb->facilities.reverse =3D x25_subscr.facilities.reverse;
+		nb->t20		      =3D x25_subscr.t20;
+		nb->global_facil_mask =3D x25_subscr.global_facil_mask;
+		write_unlock_bh(&x25_neigh_list_lock);
 	}
+	dev_put(dev);
+
 	x25_neigh_put(nb);
 out:
 	return rc;
+out_dev_and_neigh_put:
+	x25_neigh_put(nb);
 out_dev_put:
 	dev_put(dev);
 	goto out;
diff --git a/net/x25/x25_facilities.c b/net/x25/x25_facilities.c
index 8e1a49b0c0dc..e6c9f9376206 100644
--- a/net/x25/x25_facilities.c
+++ b/net/x25/x25_facilities.c
@@ -263,13 +263,17 @@ int x25_create_facilities(unsigned char *buffer,
  *	The only real problem is with reverse charging.
  */
 int x25_negotiate_facilities(struct sk_buff *skb, struct sock *sk,
-		struct x25_facilities *new, struct x25_dte_facilities *dte)
+		struct x25_facilities *new, struct x25_dte_facilities *dte,
+		struct x25_neigh *nb)
 {
 	struct x25_sock *x25 =3D x25_sk(sk);
 	struct x25_facilities *ours =3D &x25->facilities;
 	struct x25_facilities theirs;
 	int len;
=20
+	if (!x25->socket_defined_facilities)
+		ours =3D &nb->facilities;
+
 	memset(&theirs, 0, sizeof(theirs));
 	memcpy(new, ours, sizeof(*new));
 	memset(dte, 0, sizeof(*dte));
diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
index 92828a8a4ada..2af50d585b4b 100644
--- a/net/x25/x25_link.c
+++ b/net/x25/x25_link.c
@@ -125,8 +125,16 @@ static void x25_transmit_restart_request(struct x25_=
neigh *nb)
 	*dptr++ =3D nb->extended ? X25_GFI_EXTSEQ : X25_GFI_STDSEQ;
 	*dptr++ =3D 0x00;
 	*dptr++ =3D X25_RESTART_REQUEST;
-	*dptr++ =3D 0x00;
-	*dptr++ =3D 0;
+
+	*dptr =3D 0x00;	/* cause */
+
+	/* set bit 8, if DTE and cause !=3D 0x00 */
+	if (!nb->dce && *dptr !=3D 0x00)
+		*dptr |=3D (unsigned char)0x80;
+
+	dptr++;
+
+	*dptr++ =3D 0x00;	/* diagnostic */
=20
 	skb->sk =3D NULL;
=20
@@ -181,8 +189,16 @@ void x25_transmit_clear_request(struct x25_neigh *nb=
, unsigned int lci,
 					 X25_GFI_STDSEQ);
 	*dptr++ =3D (lci >> 0) & 0xFF;
 	*dptr++ =3D X25_CLEAR_REQUEST;
-	*dptr++ =3D cause;
-	*dptr++ =3D 0x00;
+
+	*dptr =3D cause;	/* cause */
+
+	/* set bit 8, if DTE and cause !=3D 0x00 */
+	if (!nb->dce && *dptr !=3D 0x00)
+		*dptr |=3D (unsigned char)0x80;
+
+	dptr++;
+
+	*dptr++ =3D 0x00;	/* diagnostic */
=20
 	skb->sk =3D NULL;
=20
@@ -261,6 +277,15 @@ void x25_link_device_add(struct net_device *dev)
 	nb->dev      =3D dev;
 	nb->state    =3D X25_LINK_STATE_0;
 	nb->extended =3D 0;
+	nb->dce      =3D 0;
+	nb->lc       =3D 10;
+	nb->facilities.winsize_in  =3D X25_DEFAULT_WINDOW_SIZE;
+	nb->facilities.winsize_out =3D X25_DEFAULT_WINDOW_SIZE;
+	nb->facilities.pacsize_in  =3D X25_DEFAULT_PACKET_SIZE;
+	nb->facilities.pacsize_out =3D X25_DEFAULT_PACKET_SIZE;
+	/* by default don't negotiate throughput */
+	nb->facilities.throughput  =3D 0;
+	nb->facilities.reverse     =3D X25_DEFAULT_REVERSE;
 	/*
 	 * Enables negotiation
 	 */
@@ -389,28 +414,76 @@ int x25_subscr_ioctl(unsigned int cmd, void __user =
*arg)
 	if ((nb =3D x25_get_neigh(dev)) =3D=3D NULL)
 		goto out_dev_put;
=20
-	dev_put(dev);
-
 	if (cmd =3D=3D SIOCX25GSUBSCRIP) {
 		read_lock_bh(&x25_neigh_list_lock);
 		x25_subscr.extended	     =3D nb->extended;
+		x25_subscr.dce		     =3D nb->dce;
+		x25_subscr.lc		     =3D nb->lc;
+		x25_subscr.facilities	     =3D nb->facilities;
+		x25_subscr.t20		     =3D nb->t20;
 		x25_subscr.global_facil_mask =3D nb->global_facil_mask;
 		read_unlock_bh(&x25_neigh_list_lock);
 		rc =3D copy_to_user(arg, &x25_subscr,
 				  sizeof(x25_subscr)) ? -EFAULT : 0;
 	} else {
 		rc =3D -EINVAL;
-		if (!(x25_subscr.extended && x25_subscr.extended !=3D 1)) {
-			rc =3D 0;
-			write_lock_bh(&x25_neigh_list_lock);
-			nb->extended	     =3D x25_subscr.extended;
-			nb->global_facil_mask =3D x25_subscr.global_facil_mask;
-			write_unlock_bh(&x25_neigh_list_lock);
+
+		if (dev->flags & IFF_UP)
+			return -EBUSY;
+
+		if (x25_subscr.extended !=3D 0 && x25_subscr.extended !=3D 1)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.dce !=3D 0 && x25_subscr.dce !=3D 1)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.lc < 1 || x25_subscr.lc > 4095)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.facilities.pacsize_in < X25_PS16 ||
+		    x25_subscr.facilities.pacsize_in > X25_PS4096)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.facilities.pacsize_out < X25_PS16 ||
+		    x25_subscr.facilities.pacsize_out > X25_PS4096)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.facilities.winsize_in < 1 ||
+		    x25_subscr.facilities.winsize_in > 127)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.facilities.throughput) {
+			int out =3D x25_subscr.facilities.throughput & 0xf0;
+			int in  =3D x25_subscr.facilities.throughput & 0x0f;
+
+			if (!out)
+				x25_subscr.facilities.throughput |=3D
+					X25_DEFAULT_THROUGHPUT << 4;
+			else if (out < 0x30 || out > 0xD0)
+				goto out_dev_and_neigh_put;
+			if (!in)
+				x25_subscr.facilities.throughput |=3D
+					X25_DEFAULT_THROUGHPUT;
+			else if (in < 0x03 || in > 0x0D)
+				goto out_dev_and_neigh_put;
 		}
+		if (x25_subscr.facilities.reverse &&
+		    (x25_subscr.facilities.reverse & 0x81) !=3D 0x81)
+			goto out_dev_and_neigh_put;
+		if (x25_subscr.t20 < 1 * HZ || x25_subscr.t20 > 300 * HZ)
+			goto out_dev_and_neigh_put;
+
+		rc =3D 0;
+		write_lock_bh(&x25_neigh_list_lock);
+		nb->extended	      =3D x25_subscr.extended;
+		nb->dce		      =3D x25_subscr.dce;
+		nb->lc		      =3D x25_subscr.lc;
+		nb->facilities	      =3D x25_subscr.facilities;
+		nb->t20		      =3D x25_subscr.t20;
+		nb->global_facil_mask =3D x25_subscr.global_facil_mask;
+		write_unlock_bh(&x25_neigh_list_lock);
 	}
+	dev_put(dev);
+
 	x25_neigh_put(nb);
 out:
 	return rc;
+out_dev_and_neigh_put:
+	x25_neigh_put(nb);
 out_dev_put:
 	dev_put(dev);
 	goto out;
diff --git a/net/x25/x25_subr.c b/net/x25/x25_subr.c
index 0285aaa1e93c..c195d1c89ad7 100644
--- a/net/x25/x25_subr.c
+++ b/net/x25/x25_subr.c
@@ -218,15 +218,31 @@ void x25_write_internal(struct sock *sk, int framet=
ype)
 		case X25_CLEAR_REQUEST:
 			dptr    =3D skb_put(skb, 3);
 			*dptr++ =3D frametype;
-			*dptr++ =3D x25->causediag.cause;
+
+			*dptr =3D x25->causediag.cause;
+
+			/* set bit 8, if DTE and cause !=3D 0x00 */
+			if (!x25->neighbour->dce && *dptr !=3D 0x00)
+				*dptr |=3D (unsigned char)0x80;
+
+			dptr++;
+
 			*dptr++ =3D x25->causediag.diagnostic;
 			break;
=20
 		case X25_RESET_REQUEST:
 			dptr    =3D skb_put(skb, 3);
 			*dptr++ =3D frametype;
-			*dptr++ =3D 0x00;		/* XXX */
-			*dptr++ =3D 0x00;		/* XXX */
+
+			*dptr =3D 0x00;	/* cause */
+
+			/* set bit 8, if DTE and cause !=3D 0x00 */
+			if (!x25->neighbour->dce && *dptr !=3D 0x00)
+				*dptr |=3D (unsigned char)0x80;
+
+			dptr++;
+
+			*dptr++ =3D 0x00;	/* diagnostic */
 			break;
=20
 		case X25_RR:
--=20
2.20.1

