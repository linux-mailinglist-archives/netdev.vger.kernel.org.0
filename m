Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA784E3A11
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiCVIFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:05:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiCVIFV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:05:21 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA6C22516
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 01:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1647936224;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=YmgJN0Q8VX6L0M3HoGrOXFFyBCfgudicpXcC/BXV55o=;
    b=OkarGCvd8V7B74mn5zHF2y7DtDsHIq+e91DJWloHMnTBB52sWEhjA1fokn7ik1GsEM
    Srm89s2iPa80IBr3AIH7xe54Xh0NJwTx92Fqmk3kL+TRcjaOAW8uApr8LSU/4M1iAPu4
    +IykgkQeXb4JjTScWQgDq+SE72UXh4/Oy89WVgB8zXwTDaFoDiclU1dM9qispuEbT4wc
    WrMlppkNIFc8yVjikh0EAq0rQyj+nb8qU/OPSSLroGvwNT2BTn5yWN81jbWxpQkkFOeZ
    jf7m7yOrexE5hfOo9GITbcnVrZtnoGQIkx6Ui6NP9/XtW3kUThbwEH4bL/S5UBSLSb2Q
    t/Pg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUvprl4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.41.1 AUTH)
    with ESMTPSA id cc2803y2M83iDdJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 22 Mar 2022 09:03:44 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     netdev@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH net-next v3] net: remove noblock parameter from skb_recv_datagram()
Date:   Tue, 22 Mar 2022 09:03:17 +0100
Message-Id: <20220322080317.54887-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

skb_recv_datagram() has two parameters 'flags' and 'noblock' that are
merged inside skb_recv_datagram() by 'flags | (noblock ? MSG_DONTWAIT : 0)'

As 'flags' may contain MSG_DONTWAIT as value most callers split the 'flags'
into 'flags' and 'noblock' with finally obsolete bit operations like this:

skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &rc);

And this is not even done consistently with the 'flags' parameter.

This patch removes the obsolete and costly splitting into two parameters
and only performs bit operations when really needed on the caller side.

One missing conversion thankfully reported by kernel test robot. I missed
to enable kunit tests to build the mctp code.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 drivers/isdn/mISDN/socket.c    | 2 +-
 drivers/net/ppp/pppoe.c        | 3 +--
 include/linux/skbuff.h         | 3 +--
 net/appletalk/ddp.c            | 3 +--
 net/atm/common.c               | 2 +-
 net/ax25/af_ax25.c             | 3 +--
 net/bluetooth/af_bluetooth.c   | 3 +--
 net/bluetooth/hci_sock.c       | 3 +--
 net/caif/caif_socket.c         | 2 +-
 net/can/bcm.c                  | 5 +----
 net/can/isotp.c                | 4 +---
 net/can/j1939/socket.c         | 2 +-
 net/can/raw.c                  | 6 +-----
 net/core/datagram.c            | 5 ++---
 net/ieee802154/socket.c        | 6 ++++--
 net/ipv4/ping.c                | 3 ++-
 net/ipv4/raw.c                 | 3 ++-
 net/ipv6/raw.c                 | 3 ++-
 net/iucv/af_iucv.c             | 3 +--
 net/key/af_key.c               | 2 +-
 net/l2tp/l2tp_ip.c             | 3 ++-
 net/l2tp/l2tp_ip6.c            | 3 ++-
 net/l2tp/l2tp_ppp.c            | 3 +--
 net/mctp/af_mctp.c             | 2 +-
 net/mctp/test/route-test.c     | 8 ++++----
 net/netlink/af_netlink.c       | 3 +--
 net/netrom/af_netrom.c         | 3 ++-
 net/nfc/llcp_sock.c            | 3 +--
 net/nfc/rawsock.c              | 3 +--
 net/packet/af_packet.c         | 2 +-
 net/phonet/datagram.c          | 3 ++-
 net/phonet/pep.c               | 6 ++++--
 net/qrtr/af_qrtr.c             | 3 +--
 net/rose/af_rose.c             | 3 ++-
 net/unix/af_unix.c             | 5 +++--
 net/vmw_vsock/vmci_transport.c | 5 +----
 net/x25/af_x25.c               | 3 +--
 37 files changed, 57 insertions(+), 70 deletions(-)

diff --git a/drivers/isdn/mISDN/socket.c b/drivers/isdn/mISDN/socket.c
index a6606736d8c5..2776ca5fc33f 100644
--- a/drivers/isdn/mISDN/socket.c
+++ b/drivers/isdn/mISDN/socket.c
@@ -119,11 +119,11 @@ mISDN_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		return -EOPNOTSUPP;
 
 	if (sk->sk_state == MISDN_CLOSED)
 		return 0;
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		return err;
 
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_mISDN *, maddr, msg->msg_name);
diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 3619520340b7..1b41cd9732d7 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -1009,12 +1009,11 @@ static int pppoe_recvmsg(struct socket *sock, struct msghdr *m,
 	if (sk->sk_state & PPPOX_BOUND) {
 		error = -EIO;
 		goto end;
 	}
 
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &error);
+	skb = skb_recv_datagram(sk, flags, &error);
 	if (error < 0)
 		goto end;
 
 	if (skb) {
 		total_len = min_t(size_t, total_len, skb->len);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 26538ceb4b01..255274bd8141 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -3834,12 +3834,11 @@ struct sk_buff *__skb_try_recv_datagram(struct sock *sk,
 					unsigned int flags, int *off, int *err,
 					struct sk_buff **last);
 struct sk_buff *__skb_recv_datagram(struct sock *sk,
 				    struct sk_buff_head *sk_queue,
 				    unsigned int flags, int *off, int *err);
-struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned flags, int noblock,
-				  int *err);
+struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags, int *err);
 __poll_t datagram_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
 			   struct iov_iter *to, int size);
 static inline int skb_copy_datagram_msg(const struct sk_buff *from, int offset,
diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index bf5736c1d458..a06f4d4a6f47 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -1751,12 +1751,11 @@ static int atalk_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	int copied = 0;
 	int offset = 0;
 	int err = 0;
 	struct sk_buff *skb;
 
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-						flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	lock_sock(sk);
 
 	if (!skb)
 		goto out;
 
diff --git a/net/atm/common.c b/net/atm/common.c
index 1cfa9bf1d187..d0c8ab7ff8f6 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -538,11 +538,11 @@ int vcc_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	if (test_bit(ATM_VF_RELEASED, &vcc->flags) ||
 	    test_bit(ATM_VF_CLOSE, &vcc->flags) ||
 	    !test_bit(ATM_VF_READY, &vcc->flags))
 		return 0;
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &error);
+	skb = skb_recv_datagram(sk, flags, &error);
 	if (!skb)
 		return error;
 
 	copied = skb->len;
 	if (copied > size) {
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 6bd097180772..1bd507f099d4 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -1654,12 +1654,11 @@ static int ax25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		err =  -ENOTCONN;
 		goto out;
 	}
 
 	/* Now we can treat all alike */
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (skb == NULL)
 		goto out;
 
 	if (!sk_to_ax25(sk)->pidincl)
 		skb_pull(skb, 1);		/* Remove PID */
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index ee319779781e..2fa15c44c3ca 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -249,11 +249,10 @@ struct sock *bt_accept_dequeue(struct sock *parent, struct socket *newsock)
 EXPORT_SYMBOL(bt_accept_dequeue);
 
 int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		    int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	size_t copied;
 	size_t skblen;
 	int err;
@@ -261,11 +260,11 @@ int bt_sock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	BT_DBG("sock %p sk %p len %zu", sock, sk, len);
 
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
 
 		return err;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 33b3c0ffc339..189e3115c8c6 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -1451,11 +1451,10 @@ static void hci_sock_cmsg(struct sock *sk, struct msghdr *msg,
 }
 
 static int hci_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			    size_t len, int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int copied, err;
 	unsigned int skblen;
 
@@ -1468,11 +1467,11 @@ static int hci_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 		return -EOPNOTSUPP;
 
 	if (sk->sk_state == BT_CLOSED)
 		return 0;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		return err;
 
 	skblen = skb->len;
 	copied = skb->len;
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 2b8892d502f7..251e666ba9a2 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -280,11 +280,11 @@ static int caif_seqpkt_recvmsg(struct socket *sock, struct msghdr *m,
 
 	ret = -EOPNOTSUPP;
 	if (flags & MSG_OOB)
 		goto read_error;
 
-	skb = skb_recv_datagram(sk, flags, 0 , &ret);
+	skb = skb_recv_datagram(sk, flags, &ret);
 	if (!skb)
 		goto read_error;
 	copylen = skb->len;
 	if (len < copylen) {
 		m->msg_flags |= MSG_TRUNC;
diff --git a/net/can/bcm.c b/net/can/bcm.c
index 95d209b52e6a..64c07e650bb4 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -1630,16 +1630,13 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		       int flags)
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int error = 0;
-	int noblock;
 	int err;
 
-	noblock =  flags & MSG_DONTWAIT;
-	flags   &= ~MSG_DONTWAIT;
-	skb = skb_recv_datagram(sk, flags, noblock, &error);
+	skb = skb_recv_datagram(sk, flags, &error);
 	if (!skb)
 		return error;
 
 	if (skb->len < size)
 		size = skb->len;
diff --git a/net/can/isotp.c b/net/can/isotp.c
index f6f8ba1f816d..5c52f9889277 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1045,21 +1045,19 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 			 int flags)
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	struct isotp_sock *so = isotp_sk(sk);
-	int noblock = flags & MSG_DONTWAIT;
 	int ret = 0;
 
 	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC))
 		return -EINVAL;
 
 	if (!so->bound)
 		return -EADDRNOTAVAIL;
 
-	flags &= ~MSG_DONTWAIT;
-	skb = skb_recv_datagram(sk, flags, noblock, &ret);
+	skb = skb_recv_datagram(sk, flags, &ret);
 	if (!skb)
 		return ret;
 
 	if (size < skb->len)
 		msg->msg_flags |= MSG_TRUNC;
diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 6dff4510687a..0bb4fd3f6264 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -800,11 +800,11 @@ static int j1939_sk_recvmsg(struct socket *sock, struct msghdr *msg,
 
 	if (flags & MSG_ERRQUEUE)
 		return sock_recv_errqueue(sock->sk, msg, size, SOL_CAN_J1939,
 					  SCM_J1939_ERRQUEUE);
 
-	skb = skb_recv_datagram(sk, flags, 0, &ret);
+	skb = skb_recv_datagram(sk, flags, &ret);
 	if (!skb)
 		return ret;
 
 	if (size < skb->len)
 		msg->msg_flags |= MSG_TRUNC;
diff --git a/net/can/raw.c b/net/can/raw.c
index 7105fa4824e4..0cf728dcff36 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -844,20 +844,16 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		       int flags)
 {
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int err = 0;
-	int noblock;
-
-	noblock = flags & MSG_DONTWAIT;
-	flags &= ~MSG_DONTWAIT;
 
 	if (flags & MSG_ERRQUEUE)
 		return sock_recv_errqueue(sk, msg, size,
 					  SOL_CAN_RAW, SCM_CAN_RAW_ERRQUEUE);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		return err;
 
 	if (size < skb->len)
 		msg->msg_flags |= MSG_TRUNC;
diff --git a/net/core/datagram.c b/net/core/datagram.c
index ee290776c661..70126d15ca6e 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -308,16 +308,15 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk,
 	return NULL;
 }
 EXPORT_SYMBOL(__skb_recv_datagram);
 
 struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags,
-				  int noblock, int *err)
+				  int *err)
 {
 	int off = 0;
 
-	return __skb_recv_datagram(sk, &sk->sk_receive_queue,
-				   flags | (noblock ? MSG_DONTWAIT : 0),
+	return __skb_recv_datagram(sk, &sk->sk_receive_queue, flags,
 				   &off, err);
 }
 EXPORT_SYMBOL(skb_recv_datagram);
 
 void skb_free_datagram(struct sock *sk, struct sk_buff *skb)
diff --git a/net/ieee802154/socket.c b/net/ieee802154/socket.c
index 3b2366a88c3c..a725dd9bbda8 100644
--- a/net/ieee802154/socket.c
+++ b/net/ieee802154/socket.c
@@ -312,11 +312,12 @@ static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 {
 	size_t copied = 0;
 	int err = -EOPNOTSUPP;
 	struct sk_buff *skb;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
 	if (len < copied) {
@@ -701,11 +702,12 @@ static int dgram_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	int err = -EOPNOTSUPP;
 	struct sk_buff *skb;
 	struct dgram_sock *ro = dgram_sk(sk);
 	DECLARE_SOCKADDR(struct sockaddr_ieee802154 *, saddr, msg->msg_name);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
 	if (len < copied) {
diff --git a/net/ipv4/ping.c b/net/ipv4/ping.c
index 3ee947557b88..550dc5c795c0 100644
--- a/net/ipv4/ping.c
+++ b/net/ipv4/ping.c
@@ -859,11 +859,12 @@ int ping_recvmsg(struct sock *sk, struct msghdr *msg, size_t len, int noblock,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE)
 		return inet_recv_error(sk, msg, len, addr_len);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
 	if (copied > len) {
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 9f97b9cbf7b3..c9dd9603f2e7 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -767,11 +767,12 @@ static int raw_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 	if (flags & MSG_ERRQUEUE) {
 		err = ip_recv_error(sk, msg, len, addr_len);
 		goto out;
 	}
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
 	if (len < copied) {
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index c51d5ce3711c..8bb41f3b246a 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -475,11 +475,12 @@ static int rawv6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
 	if (np->rxpmtu && np->rxopt.bits.rxpmtu)
 		return ipv6_recv_rxpmtu(sk, msg, len, addr_len);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
 	if (copied > len) {
diff --git a/net/iucv/af_iucv.c b/net/iucv/af_iucv.c
index a1760add5bf1..a0385ddbffcf 100644
--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1221,11 +1221,10 @@ static void iucv_process_message_q(struct sock *sk)
 }
 
 static int iucv_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			     size_t len, int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct iucv_sock *iucv = iucv_sk(sk);
 	unsigned int copied, rlen;
 	struct sk_buff *skb, *rskb, *cskb;
 	int err = 0;
@@ -1240,11 +1239,11 @@ static int iucv_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
 	/* receive/dequeue next skb:
 	 * the function understands MSG_PEEK and, thus, does not dequeue skb */
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb) {
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
 			return 0;
 		return err;
 	}
diff --git a/net/key/af_key.c b/net/key/af_key.c
index fd51db3be91c..d09ec26b1081 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3694,11 +3694,11 @@ static int pfkey_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 
 	err = -EINVAL;
 	if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT))
 		goto out;
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (skb == NULL)
 		goto out;
 
 	copied = skb->len;
 	if (copied > len) {
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index b3edafa5fba4..c6a5cc2d88e7 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -524,11 +524,12 @@ static int l2tp_ip_recvmsg(struct sock *sk, struct msghdr *msg,
 	struct sk_buff *skb;
 
 	if (flags & MSG_OOB)
 		goto out;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
 	if (len < copied) {
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 96f975777438..97fde8a9209b 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -669,11 +669,12 @@ static int l2tp_ip6_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		goto out;
 
 	if (flags & MSG_ERRQUEUE)
 		return ipv6_recv_error(sk, msg, len, addr_len);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto out;
 
 	copied = skb->len;
 	if (len < copied) {
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index bf35710127dd..8be1fdc68a0b 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -189,12 +189,11 @@ static int pppol2tp_recvmsg(struct socket *sock, struct msghdr *msg,
 	err = -EIO;
 	if (sk->sk_state & PPPOX_BOUND)
 		goto end;
 
 	err = 0;
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb)
 		goto end;
 
 	if (len > skb->len)
 		len = skb->len;
diff --git a/net/mctp/af_mctp.c b/net/mctp/af_mctp.c
index f0702d920d8d..5f204eb8abd2 100644
--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -194,11 +194,11 @@ static int mctp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	int rc;
 
 	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
 		return -EOPNOTSUPP;
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &rc);
+	skb = skb_recv_datagram(sk, flags, &rc);
 	if (!skb)
 		return rc;
 
 	if (!skb->len) {
 		rc = 0;
diff --git a/net/mctp/test/route-test.c b/net/mctp/test/route-test.c
index 61205cf40074..24df29e135ed 100644
--- a/net/mctp/test/route-test.c
+++ b/net/mctp/test/route-test.c
@@ -350,19 +350,19 @@ static void mctp_test_route_input_sk(struct kunit *test)
 	rc = mctp_route_input(&rt->rt, skb);
 
 	if (params->deliver) {
 		KUNIT_EXPECT_EQ(test, rc, 0);
 
-		skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+		skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
 		KUNIT_EXPECT_EQ(test, skb->len, 1);
 
 		skb_free_datagram(sock->sk, skb2);
 
 	} else {
 		KUNIT_EXPECT_NE(test, rc, 0);
-		skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+		skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 		KUNIT_EXPECT_PTR_EQ(test, skb2, NULL);
 	}
 
 	__mctp_route_test_fini(test, dev, rt, sock);
 }
@@ -421,11 +421,11 @@ static void mctp_test_route_input_sk_reasm(struct kunit *test)
 		__mctp_cb(skb);
 
 		rc = mctp_route_input(&rt->rt, skb);
 	}
 
-	skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+	skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 
 	if (params->rx_len) {
 		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
 		KUNIT_EXPECT_EQ(test, skb2->len, params->rx_len);
 		skb_free_datagram(sock->sk, skb2);
@@ -580,11 +580,11 @@ static void mctp_test_route_input_sk_keys(struct kunit *test)
 	__mctp_cb(skb);
 
 	rc = mctp_route_input(&rt->rt, skb);
 
 	/* (potentially) receive message */
-	skb2 = skb_recv_datagram(sock->sk, 0, 1, &rc);
+	skb2 = skb_recv_datagram(sock->sk, MSG_DONTWAIT, &rc);
 
 	if (params->deliver)
 		KUNIT_EXPECT_NOT_ERR_OR_NULL(test, skb2);
 	else
 		KUNIT_EXPECT_PTR_EQ(test, skb2, NULL);
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 7b344035bfe3..cf397e0760b7 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1927,21 +1927,20 @@ static int netlink_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			   int flags)
 {
 	struct scm_cookie scm;
 	struct sock *sk = sock->sk;
 	struct netlink_sock *nlk = nlk_sk(sk);
-	int noblock = flags & MSG_DONTWAIT;
 	size_t copied;
 	struct sk_buff *skb, *data_skb;
 	int err, ret;
 
 	if (flags & MSG_OOB)
 		return -EOPNOTSUPP;
 
 	copied = 0;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (skb == NULL)
 		goto out;
 
 	data_skb = skb;
 
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index fa9dc2ba3941..6f7f4392cffb 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -1157,11 +1157,12 @@ static int nr_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		release_sock(sk);
 		return -ENOTCONN;
 	}
 
 	/* Now we can treat all alike */
-	if ((skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &er)) == NULL) {
+	skb = skb_recv_datagram(sk, flags, &er);
+	if (!skb) {
 		release_sock(sk);
 		return er;
 	}
 
 	skb_reset_transport_header(skb);
diff --git a/net/nfc/llcp_sock.c b/net/nfc/llcp_sock.c
index 4ca35791c93b..77642d18a3b4 100644
--- a/net/nfc/llcp_sock.c
+++ b/net/nfc/llcp_sock.c
@@ -819,11 +819,10 @@ static int llcp_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 }
 
 static int llcp_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 			     size_t len, int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	unsigned int copied, rlen;
 	struct sk_buff *skb, *cskb;
 	int err = 0;
 
@@ -840,11 +839,11 @@ static int llcp_sock_recvmsg(struct socket *sock, struct msghdr *msg,
 	release_sock(sk);
 
 	if (flags & (MSG_OOB))
 		return -EOPNOTSUPP;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 	if (!skb) {
 		pr_err("Recv datagram failed state %d %d %d",
 		       sk->sk_state, err, sock_error(sk));
 
 		if (sk->sk_shutdown & RCV_SHUTDOWN)
diff --git a/net/nfc/rawsock.c b/net/nfc/rawsock.c
index 0ca214ab5aef..8dd569765f96 100644
--- a/net/nfc/rawsock.c
+++ b/net/nfc/rawsock.c
@@ -236,19 +236,18 @@ static int rawsock_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 }
 
 static int rawsock_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 			   int flags)
 {
-	int noblock = flags & MSG_DONTWAIT;
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	int copied;
 	int rc;
 
 	pr_debug("sock=%p sk=%p len=%zu flags=%d\n", sock, sk, len, flags);
 
-	skb = skb_recv_datagram(sk, flags, noblock, &rc);
+	skb = skb_recv_datagram(sk, flags, &rc);
 	if (!skb)
 		return rc;
 
 	copied = skb->len;
 	if (len < copied) {
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c39c09899fd0..d3caaf4d4b3e 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3419,11 +3419,11 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 	 *
 	 *	Now it will return ENETDOWN, if device have just gone down,
 	 *	but then it will block.
 	 */
 
-	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &err);
+	skb = skb_recv_datagram(sk, flags, &err);
 
 	/*
 	 *	An error occurred so return it. Because skb_recv_datagram()
 	 *	handles the blocking we don't see and worry about blocking
 	 *	retries.
diff --git a/net/phonet/datagram.c b/net/phonet/datagram.c
index 393e6aa7a592..3f2e62b63dd4 100644
--- a/net/phonet/datagram.c
+++ b/net/phonet/datagram.c
@@ -121,11 +121,12 @@ static int pn_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 
 	if (flags & ~(MSG_PEEK|MSG_TRUNC|MSG_DONTWAIT|MSG_NOSIGNAL|
 			MSG_CMSG_COMPAT))
 		goto out_nofree;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &rval);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &rval);
 	if (skb == NULL)
 		goto out_nofree;
 
 	pn_skb_get_src_sockaddr(skb, &sa);
 
diff --git a/net/phonet/pep.c b/net/phonet/pep.c
index 65d463ad8770..441a26706592 100644
--- a/net/phonet/pep.c
+++ b/net/phonet/pep.c
@@ -770,11 +770,12 @@ static struct sock *pep_sock_accept(struct sock *sk, int flags, int *errp,
 	int err;
 	u16 peer_type;
 	u8 pipe_handle, enabled, n_sb;
 	u8 aligned = 0;
 
-	skb = skb_recv_datagram(sk, 0, flags & O_NONBLOCK, errp);
+	skb = skb_recv_datagram(sk, (flags & O_NONBLOCK) ? MSG_DONTWAIT : 0,
+				errp);
 	if (!skb)
 		return NULL;
 
 	lock_sock(sk);
 	if (sk->sk_state != TCP_LISTEN) {
@@ -1265,11 +1266,12 @@ static int pep_recvmsg(struct sock *sk, struct msghdr *msg, size_t len,
 		}
 		if (flags & MSG_OOB)
 			return -EINVAL;
 	}
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags |= (noblock ? MSG_DONTWAIT : 0);
+	skb = skb_recv_datagram(sk, flags, &err);
 	lock_sock(sk);
 	if (skb == NULL) {
 		if (err == -ENOTCONN && sk->sk_state == TCP_CLOSE_WAIT)
 			err = -ECONNRESET;
 		release_sock(sk);
diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index ec2322529727..5c2fb992803b 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -1033,12 +1033,11 @@ static int qrtr_recvmsg(struct socket *sock, struct msghdr *msg,
 	if (sock_flag(sk, SOCK_ZAPPED)) {
 		release_sock(sk);
 		return -EADDRNOTAVAIL;
 	}
 
-	skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-				flags & MSG_DONTWAIT, &rc);
+	skb = skb_recv_datagram(sk, flags, &rc);
 	if (!skb) {
 		release_sock(sk);
 		return rc;
 	}
 	cb = (struct qrtr_cb *)skb->cb;
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 30a1cf4c16c6..bf2d986a6bc3 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1228,11 +1228,12 @@ static int rose_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	 */
 	if (sk->sk_state != TCP_ESTABLISHED)
 		return -ENOTCONN;
 
 	/* Now we can treat all alike */
-	if ((skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT, flags & MSG_DONTWAIT, &er)) == NULL)
+	skb = skb_recv_datagram(sk, flags, &er);
+	if (!skb)
 		return er;
 
 	qbit = (skb->data[0] & ROSE_Q_BIT) == ROSE_Q_BIT;
 
 	skb_pull(skb, ROSE_MIN_LEN);
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 3e0d6281fd1e..198aa86196b0 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -1641,11 +1641,12 @@ static int unix_accept(struct socket *sock, struct socket *newsock, int flags,
 
 	/* If socket state is TCP_LISTEN it cannot change (for now...),
 	 * so that no locks are necessary.
 	 */
 
-	skb = skb_recv_datagram(sk, 0, flags&O_NONBLOCK, &err);
+	skb = skb_recv_datagram(sk, (flags & O_NONBLOCK) ? MSG_DONTWAIT : 0,
+				&err);
 	if (!skb) {
 		/* This means receive shutdown. */
 		if (err == 0)
 			err = -EINVAL;
 		goto out;
@@ -2498,11 +2499,11 @@ static int unix_read_sock(struct sock *sk, read_descriptor_t *desc,
 		struct unix_sock *u = unix_sk(sk);
 		struct sk_buff *skb;
 		int used, err;
 
 		mutex_lock(&u->iolock);
-		skb = skb_recv_datagram(sk, 0, 1, &err);
+		skb = skb_recv_datagram(sk, MSG_DONTWAIT, &err);
 		mutex_unlock(&u->iolock);
 		if (!skb)
 			return err;
 
 		used = recv_actor(desc, skb, 0, skb->len);
diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index b17dc9745188..b14f0ed7427b 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1730,23 +1730,20 @@ static int vmci_transport_dgram_enqueue(
 static int vmci_transport_dgram_dequeue(struct vsock_sock *vsk,
 					struct msghdr *msg, size_t len,
 					int flags)
 {
 	int err;
-	int noblock;
 	struct vmci_datagram *dg;
 	size_t payload_len;
 	struct sk_buff *skb;
 
-	noblock = flags & MSG_DONTWAIT;
-
 	if (flags & MSG_OOB || flags & MSG_ERRQUEUE)
 		return -EOPNOTSUPP;
 
 	/* Retrieve the head sk_buff from the socket's receive queue. */
 	err = 0;
-	skb = skb_recv_datagram(&vsk->sk, flags, noblock, &err);
+	skb = skb_recv_datagram(&vsk->sk, flags, &err);
 	if (!skb)
 		return err;
 
 	dg = (struct vmci_datagram *)skb->data;
 	if (!dg)
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 3583354a7d7f..bb2ece38f0a3 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -1313,12 +1313,11 @@ static int x25_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 		msg->msg_flags |= MSG_OOB;
 	} else {
 		/* Now we can treat all alike */
 		release_sock(sk);
-		skb = skb_recv_datagram(sk, flags & ~MSG_DONTWAIT,
-					flags & MSG_DONTWAIT, &rc);
+		skb = skb_recv_datagram(sk, flags, &rc);
 		lock_sock(sk);
 		if (!skb)
 			goto out;
 
 		if (!pskb_may_pull(skb, header_len))
-- 
2.30.2

