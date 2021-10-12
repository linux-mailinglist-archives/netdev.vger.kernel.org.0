Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC4C42A8F3
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbhJLQAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 12:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237319AbhJLQAu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 12:00:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 592F2610CE;
        Tue, 12 Oct 2021 15:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634054328;
        bh=aYwfR4QYHSoTkFLeIQuMNSaAVXpMVebjmLmvBiTyz78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bHXfuFoGym8Tb8p8ttH+BlEs2X4AD+6i7DY6sNwI8sLRu5H6fk4QTqZ7A0TF4Z5hJ
         J5GttT2Z4NmYM0qpg45kyX0AvgNUbW252QttKwAoDQ+KL6dwnzfMBJ2tjS/sdrzRiz
         0bjr4lhJ2/6z8e+wuQO+FyqrJcRnHuLI3oxe4ZXliwXi6bkHurzJnr6UCUa3khlP9+
         Ge4oMdN6bo2EwdvbZDzUsQUi9451o56vRBZmd3ljB5swv6wIxwKsVf+VCAvXgfmzCb
         xsZAeTS6qY5PmkpcOcLDiErBhKr3AVZnq8W/mz+DGDtg7VjlXB5lX1H5v/g2cWNlJ0
         k4oIZGABQL9rA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, ralf@linux-mips.org, jreuter@yaina.de,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, jmaloy@redhat.com,
        ying.xue@windriver.com, linux-hams@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/6] ax25: constify dev_addr passing
Date:   Tue, 12 Oct 2021 08:58:35 -0700
Message-Id: <20211012155840.4151590-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211012155840.4151590-1-kuba@kernel.org>
References: <20211012155840.4151590-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for netdev->dev_addr being constant
make all relevant arguments in AX25 constant.

Modify callers as well (netrom, rose).

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/ax25.h     | 13 +++++++------
 net/ax25/af_ax25.c     |  2 +-
 net/ax25/ax25_dev.c    |  2 +-
 net/ax25/ax25_iface.c  |  6 +++---
 net/ax25/ax25_in.c     |  4 ++--
 net/ax25/ax25_out.c    |  2 +-
 net/netrom/af_netrom.c |  4 ++--
 net/netrom/nr_dev.c    |  6 +++---
 net/netrom/nr_route.c  |  4 ++--
 net/rose/rose_link.c   |  8 ++++----
 10 files changed, 26 insertions(+), 25 deletions(-)

diff --git a/include/net/ax25.h b/include/net/ax25.h
index 8b7eb46ad72d..03d409de61ad 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -304,7 +304,7 @@ extern spinlock_t ax25_list_lock;
 void ax25_cb_add(ax25_cb *);
 struct sock *ax25_find_listener(ax25_address *, int, struct net_device *, int);
 struct sock *ax25_get_socket(ax25_address *, ax25_address *, int);
-ax25_cb *ax25_find_cb(ax25_address *, ax25_address *, ax25_digi *,
+ax25_cb *ax25_find_cb(const ax25_address *, ax25_address *, ax25_digi *,
 		      struct net_device *);
 void ax25_send_to_raw(ax25_address *, struct sk_buff *, int);
 void ax25_destroy_socket(ax25_cb *);
@@ -384,10 +384,11 @@ struct ax25_linkfail {
 
 void ax25_linkfail_register(struct ax25_linkfail *lf);
 void ax25_linkfail_release(struct ax25_linkfail *lf);
-int __must_check ax25_listen_register(ax25_address *, struct net_device *);
-void ax25_listen_release(ax25_address *, struct net_device *);
+int __must_check ax25_listen_register(const ax25_address *,
+				      struct net_device *);
+void ax25_listen_release(const ax25_address *, struct net_device *);
 int(*ax25_protocol_function(unsigned int))(struct sk_buff *, ax25_cb *);
-int ax25_listen_mine(ax25_address *, struct net_device *);
+int ax25_listen_mine(const ax25_address *, struct net_device *);
 void ax25_link_failed(ax25_cb *, int);
 int ax25_protocol_is_registered(unsigned int);
 
@@ -401,8 +402,8 @@ netdev_tx_t ax25_ip_xmit(struct sk_buff *skb);
 extern const struct header_ops ax25_header_ops;
 
 /* ax25_out.c */
-ax25_cb *ax25_send_frame(struct sk_buff *, int, ax25_address *, ax25_address *,
-			 ax25_digi *, struct net_device *);
+ax25_cb *ax25_send_frame(struct sk_buff *, int, const ax25_address *,
+			 ax25_address *, ax25_digi *, struct net_device *);
 void ax25_output(ax25_cb *, int, struct sk_buff *);
 void ax25_kick(ax25_cb *);
 void ax25_transmit_buffer(ax25_cb *, struct sk_buff *, int);
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 2631efc6e359..2f34bbdde0e8 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -202,7 +202,7 @@ struct sock *ax25_get_socket(ax25_address *my_addr, ax25_address *dest_addr,
  *	Find an AX.25 control block given both ends. It will only pick up
  *	floating AX.25 control blocks or non Raw socket bound control blocks.
  */
-ax25_cb *ax25_find_cb(ax25_address *src_addr, ax25_address *dest_addr,
+ax25_cb *ax25_find_cb(const ax25_address *src_addr, ax25_address *dest_addr,
 	ax25_digi *digi, struct net_device *dev)
 {
 	ax25_cb *s;
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index 4ac2e0847652..d0a043a51848 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -35,7 +35,7 @@ ax25_dev *ax25_addr_ax25dev(ax25_address *addr)
 
 	spin_lock_bh(&ax25_dev_lock);
 	for (ax25_dev = ax25_dev_list; ax25_dev != NULL; ax25_dev = ax25_dev->next)
-		if (ax25cmp(addr, (ax25_address *)ax25_dev->dev->dev_addr) == 0) {
+		if (ax25cmp(addr, (const ax25_address *)ax25_dev->dev->dev_addr) == 0) {
 			res = ax25_dev;
 		}
 	spin_unlock_bh(&ax25_dev_lock);
diff --git a/net/ax25/ax25_iface.c b/net/ax25/ax25_iface.c
index b4083f30af0d..979bc4b828a0 100644
--- a/net/ax25/ax25_iface.c
+++ b/net/ax25/ax25_iface.c
@@ -98,7 +98,7 @@ void ax25_linkfail_release(struct ax25_linkfail *lf)
 
 EXPORT_SYMBOL(ax25_linkfail_release);
 
-int ax25_listen_register(ax25_address *callsign, struct net_device *dev)
+int ax25_listen_register(const ax25_address *callsign, struct net_device *dev)
 {
 	struct listen_struct *listen;
 
@@ -121,7 +121,7 @@ int ax25_listen_register(ax25_address *callsign, struct net_device *dev)
 
 EXPORT_SYMBOL(ax25_listen_register);
 
-void ax25_listen_release(ax25_address *callsign, struct net_device *dev)
+void ax25_listen_release(const ax25_address *callsign, struct net_device *dev)
 {
 	struct listen_struct *s, *listen;
 
@@ -171,7 +171,7 @@ int (*ax25_protocol_function(unsigned int pid))(struct sk_buff *, ax25_cb *)
 	return res;
 }
 
-int ax25_listen_mine(ax25_address *callsign, struct net_device *dev)
+int ax25_listen_mine(const ax25_address *callsign, struct net_device *dev)
 {
 	struct listen_struct *listen;
 
diff --git a/net/ax25/ax25_in.c b/net/ax25/ax25_in.c
index cd6afe895db9..1cac25aca637 100644
--- a/net/ax25/ax25_in.c
+++ b/net/ax25/ax25_in.c
@@ -181,7 +181,7 @@ static int ax25_process_rx_frame(ax25_cb *ax25, struct sk_buff *skb, int type, i
 }
 
 static int ax25_rcv(struct sk_buff *skb, struct net_device *dev,
-	ax25_address *dev_addr, struct packet_type *ptype)
+		    const ax25_address *dev_addr, struct packet_type *ptype)
 {
 	ax25_address src, dest, *next_digi = NULL;
 	int type = 0, mine = 0, dama;
@@ -447,5 +447,5 @@ int ax25_kiss_rcv(struct sk_buff *skb, struct net_device *dev,
 
 	skb_pull(skb, AX25_KISS_HEADER_LEN);	/* Remove the KISS byte */
 
-	return ax25_rcv(skb, dev, (ax25_address *)dev->dev_addr, ptype);
+	return ax25_rcv(skb, dev, (const ax25_address *)dev->dev_addr, ptype);
 }
diff --git a/net/ax25/ax25_out.c b/net/ax25/ax25_out.c
index 22f2f66c6e0a..3db76d2470e9 100644
--- a/net/ax25/ax25_out.c
+++ b/net/ax25/ax25_out.c
@@ -29,7 +29,7 @@
 
 static DEFINE_SPINLOCK(ax25_frag_lock);
 
-ax25_cb *ax25_send_frame(struct sk_buff *skb, int paclen, ax25_address *src, ax25_address *dest, ax25_digi *digi, struct net_device *dev)
+ax25_cb *ax25_send_frame(struct sk_buff *skb, int paclen, const ax25_address *src, ax25_address *dest, ax25_digi *digi, struct net_device *dev)
 {
 	ax25_dev *ax25_dev;
 	ax25_cb *ax25;
diff --git a/net/netrom/af_netrom.c b/net/netrom/af_netrom.c
index 6d16e1ab1a8a..775064cdd0ee 100644
--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -633,7 +633,7 @@ static int nr_connect(struct socket *sock, struct sockaddr *uaddr,
 	struct sock *sk = sock->sk;
 	struct nr_sock *nr = nr_sk(sk);
 	struct sockaddr_ax25 *addr = (struct sockaddr_ax25 *)uaddr;
-	ax25_address *source = NULL;
+	const ax25_address *source = NULL;
 	ax25_uid_assoc *user;
 	struct net_device *dev;
 	int err = 0;
@@ -673,7 +673,7 @@ static int nr_connect(struct socket *sock, struct sockaddr *uaddr,
 			err = -ENETUNREACH;
 			goto out_release;
 		}
-		source = (ax25_address *)dev->dev_addr;
+		source = (const ax25_address *)dev->dev_addr;
 
 		user = ax25_findbyuid(current_euid());
 		if (user) {
diff --git a/net/netrom/nr_dev.c b/net/netrom/nr_dev.c
index d1ca413d3317..3aaac4a22b38 100644
--- a/net/netrom/nr_dev.c
+++ b/net/netrom/nr_dev.c
@@ -108,7 +108,7 @@ static int __must_check nr_set_mac_address(struct net_device *dev, void *addr)
 		if (err)
 			return err;
 
-		ax25_listen_release((ax25_address *)dev->dev_addr, NULL);
+		ax25_listen_release((const ax25_address *)dev->dev_addr, NULL);
 	}
 
 	dev_addr_set(dev, sa->sa_data);
@@ -120,7 +120,7 @@ static int nr_open(struct net_device *dev)
 {
 	int err;
 
-	err = ax25_listen_register((ax25_address *)dev->dev_addr, NULL);
+	err = ax25_listen_register((const ax25_address *)dev->dev_addr, NULL);
 	if (err)
 		return err;
 
@@ -131,7 +131,7 @@ static int nr_open(struct net_device *dev)
 
 static int nr_close(struct net_device *dev)
 {
-	ax25_listen_release((ax25_address *)dev->dev_addr, NULL);
+	ax25_listen_release((const ax25_address *)dev->dev_addr, NULL);
 	netif_stop_queue(dev);
 	return 0;
 }
diff --git a/net/netrom/nr_route.c b/net/netrom/nr_route.c
index ddd5cbd455e3..baea3cbd76ca 100644
--- a/net/netrom/nr_route.c
+++ b/net/netrom/nr_route.c
@@ -598,7 +598,7 @@ struct net_device *nr_dev_get(ax25_address *addr)
 	rcu_read_lock();
 	for_each_netdev_rcu(&init_net, dev) {
 		if ((dev->flags & IFF_UP) && dev->type == ARPHRD_NETROM &&
-		    ax25cmp(addr, (ax25_address *)dev->dev_addr) == 0) {
+		    ax25cmp(addr, (const ax25_address *)dev->dev_addr) == 0) {
 			dev_hold(dev);
 			goto out;
 		}
@@ -825,7 +825,7 @@ int nr_route_frame(struct sk_buff *skb, ax25_cb *ax25)
 
 	ax25s = nr_neigh->ax25;
 	nr_neigh->ax25 = ax25_send_frame(skb, 256,
-					 (ax25_address *)dev->dev_addr,
+					 (const ax25_address *)dev->dev_addr,
 					 &nr_neigh->callsign,
 					 nr_neigh->digipeat, nr_neigh->dev);
 	if (ax25s)
diff --git a/net/rose/rose_link.c b/net/rose/rose_link.c
index f6102e6f5161..8b96a56d3a49 100644
--- a/net/rose/rose_link.c
+++ b/net/rose/rose_link.c
@@ -94,11 +94,11 @@ static void rose_t0timer_expiry(struct timer_list *t)
  */
 static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
 {
-	ax25_address *rose_call;
+	const ax25_address *rose_call;
 	ax25_cb *ax25s;
 
 	if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
-		rose_call = (ax25_address *)neigh->dev->dev_addr;
+		rose_call = (const ax25_address *)neigh->dev->dev_addr;
 	else
 		rose_call = &rose_callsign;
 
@@ -117,11 +117,11 @@ static int rose_send_frame(struct sk_buff *skb, struct rose_neigh *neigh)
  */
 static int rose_link_up(struct rose_neigh *neigh)
 {
-	ax25_address *rose_call;
+	const ax25_address *rose_call;
 	ax25_cb *ax25s;
 
 	if (ax25cmp(&rose_callsign, &null_ax25_address) == 0)
-		rose_call = (ax25_address *)neigh->dev->dev_addr;
+		rose_call = (const ax25_address *)neigh->dev->dev_addr;
 	else
 		rose_call = &rose_callsign;
 
-- 
2.31.1

