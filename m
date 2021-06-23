Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18FE3B17ED
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 12:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhFWKPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 06:15:22 -0400
Received: from m12-11.163.com ([220.181.12.11]:44602 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230031AbhFWKPV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 06:15:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=vlDzL
        m3SGWxnAleIDs6M/KJHtnSdzsTl1pSKaX3/3T0=; b=PSnz6isaahpCNeWT1f7xM
        3DiJBdfQzEBhgeG6okZHLEQUY69C73pV8+G1wuslJUr5n1eMvTTSK32ND5E59O4P
        F2e/pabBgbNMS93RN4GHSG0wu2xjgTT5kBr+gbdCWXyNkB/8f2bBHXVajQwy9LAt
        0TUyFS+/E6rSgs693jRMpQ=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowACnzEwPCdNgyY_rjQ--.10248S2;
        Wed, 23 Jun 2021 18:12:32 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gushengxian <gushengxian@yulong.com>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] decnet: af_decnet: pmc should not be referenced when it's NULL
Date:   Wed, 23 Jun 2021 03:12:25 -0700
Message-Id: <20210623101225.2855-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowACnzEwPCdNgyY_rjQ--.10248S2
X-Coremail-Antispam: 1Uf129KBjvJXoWfJrWrtFyUKFy5KFyDCFWDCFg_yoWDtFy5pF
        4jka1DCr48tFW7WrZYyaykur4Syw18tryxCryIga4SyFyqgr1rJa48AFyYyr4rWrWkCw43
        Aa1qgFs0kr47WrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bFNVkUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiyhC6g1QHMfjXYAAAsO
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

pmc should not be referenced when it's NULL.

Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>): fix compile error.
Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/decnet/af_decnet.c | 68 ++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 42 deletions(-)

diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 5dbd45dc35ad..2270882dfff8 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -152,7 +152,8 @@ static atomic_long_t decnet_memory_allocated;
 
 static int __dn_setsockopt(struct socket *sock, int level, int optname,
 		sockptr_t optval, unsigned int optlen, int flags);
-static int __dn_getsockopt(struct socket *sock, int level, int optname, char __user *optval, int __user *optlen, int flags);
+static int __dn_getsockopt(struct socket *sock, int level, int optname,
+		char __user *optval, int __user *optlen, int flags);
 
 static struct hlist_head *dn_find_list(struct sock *sk)
 {
@@ -176,6 +177,7 @@ static int check_port(__le16 port)
 
 	sk_for_each(sk, &dn_sk_hash[le16_to_cpu(port) & DN_SK_HASH_MASK]) {
 		struct dn_scp *scp = DN_SK(sk);
+
 		if (scp->addrloc == port)
 			return -1;
 	}
@@ -373,6 +375,7 @@ struct sock *dn_sklist_find_listener(struct sockaddr_dn *addr)
 	read_lock(&dn_hash_lock);
 	sk_for_each(sk, list) {
 		struct dn_scp *scp = DN_SK(sk);
+
 		if (sk->sk_state != TCP_LISTEN)
 			continue;
 		if (scp->addr.sdn_objnum) {
@@ -427,8 +430,6 @@ struct sock *dn_find_by_skb(struct sk_buff *skb)
 	return sk;
 }
 
-
-
 static void dn_destruct(struct sock *sk)
 {
 	struct dn_scp *scp = DN_SK(sk);
@@ -444,9 +445,8 @@ static unsigned long dn_memory_pressure;
 
 static void dn_enter_memory_pressure(struct sock *sk)
 {
-	if (!dn_memory_pressure) {
+	if (!dn_memory_pressure)
 		dn_memory_pressure = 1;
-	}
 }
 
 static struct proto dn_proto = {
@@ -548,7 +548,6 @@ static void dn_keepalive(struct sock *sk)
 		dn_nsp_send_link(sk, DN_NOCHANGE, 0);
 }
 
-
 /*
  * Timer for shutdown/destroyed sockets.
  * When socket is dead & no packets have been sent for a
@@ -664,8 +663,6 @@ char *dn_addr2asc(__u16 addr, char *buf)
 	return buf;
 }
 
-
-
 static int dn_create(struct net *net, struct socket *sock, int protocol,
 		     int kern)
 {
@@ -688,7 +685,6 @@ static int dn_create(struct net *net, struct socket *sock, int protocol,
 		return -ESOCKTNOSUPPORT;
 	}
 
-
 	if ((sk = dn_alloc_sock(net, sock, GFP_KERNEL, kern)) == NULL)
 		return -ENOBUFS;
 
@@ -755,7 +751,7 @@ static int dn_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 				}
 			}
 			rcu_read_unlock();
-			if (ldev == NULL)
+			if (!ldev)
 				return -EADDRNOTAVAIL;
 		}
 	}
@@ -775,7 +771,6 @@ static int dn_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	return rv;
 }
 
-
 static int dn_auto_bind(struct socket *sock)
 {
 	struct sock *sk = sock->sk;
@@ -793,7 +788,6 @@ static int dn_auto_bind(struct socket *sock)
 	 */
 	if ((scp->accessdata.acc_accl != 0) &&
 		(scp->accessdata.acc_accl <= 12)) {
-
 		scp->addr.sdn_objnamel = cpu_to_le16(scp->accessdata.acc_accl);
 		memcpy(scp->addr.sdn_objname, scp->accessdata.acc_acc, le16_to_cpu(scp->addr.sdn_objnamel));
 
@@ -926,7 +920,7 @@ static int __dn_connect(struct sock *sk, struct sockaddr_dn *addr, int addrlen,
 	if (scp->state != DN_O)
 		goto out;
 
-	if (addr == NULL || addrlen != sizeof(struct sockaddr_dn))
+	if (!addr || addrlen != sizeof(struct sockaddr_dn))
 		goto out;
 	if (addr->sdn_family != AF_DECnet)
 		goto out;
@@ -958,9 +952,8 @@ static int __dn_connect(struct sock *sk, struct sockaddr_dn *addr, int addrlen,
 
 	dn_nsp_send_conninit(sk, NSP_CI);
 	err = -EINPROGRESS;
-	if (*timeo) {
+	if (*timeo)
 		err = dn_wait_run(sk, timeo);
-	}
 out:
 	return err;
 }
@@ -998,7 +991,6 @@ static inline int dn_check_state(struct sock *sk, struct sockaddr_dn *addr, int
 	return -EINVAL;
 }
 
-
 static void dn_access_copy(struct sk_buff *skb, struct accessdata_dn *acc)
 {
 	unsigned char *ptr = skb->data;
@@ -1015,7 +1007,6 @@ static void dn_access_copy(struct sk_buff *skb, struct accessdata_dn *acc)
 	memcpy(&acc->acc_acc, ptr, acc->acc_accl);
 
 	skb_pull(skb, acc->acc_accl + acc->acc_passl + acc->acc_userl + 3);
-
 }
 
 static void dn_user_copy(struct sk_buff *skb, struct optdata_dn *opt)
@@ -1040,12 +1031,12 @@ static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
 	for(;;) {
 		release_sock(sk);
 		skb = skb_dequeue(&sk->sk_receive_queue);
-		if (skb == NULL) {
+		if (!skb) {
 			*timeo = schedule_timeout(*timeo);
 			skb = skb_dequeue(&sk->sk_receive_queue);
 		}
 		lock_sock(sk);
-		if (skb != NULL)
+		if (skb)
 			break;
 		err = -EINVAL;
 		if (sk->sk_state != TCP_LISTEN)
@@ -1060,7 +1051,7 @@ static struct sk_buff *dn_wait_for_connect(struct sock *sk, long *timeo)
 	}
 	finish_wait(sk_sleep(sk), &wait);
 
-	return skb == NULL ? ERR_PTR(err) : skb;
+	return !skb ? ERR_PTR(err) : skb;
 }
 
 static int dn_accept(struct socket *sock, struct socket *newsock, int flags,
@@ -1083,7 +1074,7 @@ static int dn_accept(struct socket *sock, struct socket *newsock, int flags,
 	}
 
 	skb = skb_dequeue(&sk->sk_receive_queue);
-	if (skb == NULL) {
+	if (!skb) {
 		skb = dn_wait_for_connect(sk, &timeo);
 		if (IS_ERR(skb)) {
 			release_sock(sk);
@@ -1094,7 +1085,7 @@ static int dn_accept(struct socket *sock, struct socket *newsock, int flags,
 	cb = DN_SKB_CB(skb);
 	sk_acceptq_removed(sk);
 	newsk = dn_alloc_sock(sock_net(sk), newsock, sk->sk_allocation, kern);
-	if (newsk == NULL) {
+	if (!newsk) {
 		release_sock(sk);
 		kfree_skb(skb);
 		return -ENOBUFS;
@@ -1172,8 +1163,7 @@ static int dn_accept(struct socket *sock, struct socket *newsock, int flags,
 	return err;
 }
 
-
-static int dn_getname(struct socket *sock, struct sockaddr *uaddr,int peer)
+static int dn_getname(struct socket *sock, struct sockaddr *uaddr, int peer)
 {
 	struct sockaddr_dn *sa = (struct sockaddr_dn *)uaddr;
 	struct sock *sk = sock->sk;
@@ -1199,7 +1189,6 @@ static int dn_getname(struct socket *sock, struct sockaddr *uaddr,int peer)
 	return sizeof(struct sockaddr_dn);
 }
 
-
 static __poll_t dn_poll(struct file *file, struct socket *sock, poll_table  *wait)
 {
 	struct sock *sk = sock->sk;
@@ -1221,8 +1210,7 @@ static int dn_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 	struct sk_buff *skb;
 	int val;
 
-	switch(cmd)
-	{
+	switch (cmd) {
 	case SIOCGIFADDR:
 	case SIOCSIFADDR:
 		return dn_dev_ioctl(cmd, (void __user *)arg);
@@ -1249,7 +1237,7 @@ static int dn_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 			amount = skb->len;
 		} else {
 			skb_queue_walk(&sk->sk_receive_queue, skb)
-				amount += skb->len;
+				continue;
 		}
 		release_sock(sk);
 		err = put_user(amount, (int __user *)arg);
@@ -1288,7 +1276,6 @@ static int dn_listen(struct socket *sock, int backlog)
 	return err;
 }
 
-
 static int dn_shutdown(struct socket *sock, int how)
 {
 	struct sock *sk = sock->sk;
@@ -1537,7 +1524,7 @@ static int __dn_getsockopt(struct socket *sock, int level,int optname, char __us
 	void *r_data = NULL;
 	unsigned int val;
 
-	if(get_user(r_len , optlen))
+	if (get_user(r_len, optlen))
 		return -EFAULT;
 
 	switch (optname) {
@@ -1639,7 +1626,6 @@ static int __dn_getsockopt(struct socket *sock, int level,int optname, char __us
 	return 0;
 }
 
-
 static int dn_data_ready(struct sock *sk, struct sk_buff_head *q, int flags, int target)
 {
 	struct sk_buff *skb;
@@ -1650,6 +1636,7 @@ static int dn_data_ready(struct sock *sk, struct sk_buff_head *q, int flags, int
 
 	skb_queue_walk(q, skb) {
 		struct dn_skb_cb *cb = DN_SKB_CB(skb);
+
 		len += skb->len;
 
 		if (cb->nsp_flags & 0x40) {
@@ -1669,7 +1656,6 @@ static int dn_data_ready(struct sock *sk, struct sk_buff_head *q, int flags, int
 	return 0;
 }
 
-
 static int dn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		      int flags)
 {
@@ -1711,7 +1697,6 @@ static int dn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	if (flags & MSG_WAITALL)
 		target = size;
 
-
 	/*
 	 * See if there is data ready to read, sleep if there isn't
 	 */
@@ -1756,6 +1741,7 @@ static int dn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 	skb_queue_walk_safe(queue, skb, n) {
 		unsigned int chunk = skb->len;
+
 		cb = DN_SKB_CB(skb);
 
 		if ((chunk + copied) > size)
@@ -1801,7 +1787,6 @@ static int dn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 
 	rv = copied;
 
-
 	if (eor && (sk->sk_type == SOCK_SEQPACKET))
 		msg->msg_flags |= MSG_EOR;
 
@@ -1820,7 +1805,6 @@ static int dn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	return rv;
 }
 
-
 static inline int dn_queue_too_long(struct dn_scp *scp, struct sk_buff_head *queue, int flags)
 {
 	unsigned char fctype = scp->services_rem & NSP_FC_MASK;
@@ -1849,8 +1833,10 @@ static inline int dn_queue_too_long(struct dn_scp *scp, struct sk_buff_head *que
 unsigned int dn_mss_from_pmtu(struct net_device *dev, int mtu)
 {
 	unsigned int mss = 230 - DN_MAX_NSP_DATA_HEADER;
+
 	if (dev) {
 		struct dn_dev *dn_db = rcu_dereference_raw(dev->dn_ptr);
+
 		mtu -= LL_RESERVED_SPACE(dev);
 		if (dn_db->use_long)
 			mtu -= 21;
@@ -1881,6 +1867,7 @@ static inline unsigned int dn_current_mss(struct sock *sk, int flags)
 	/* This works out the maximum size of segment we can send out */
 	if (dst) {
 		u32 mtu = dst_mtu(dst);
+
 		mss_now = min_t(int, dn_mss_from_pmtu(dst->dev, mtu), mss_now);
 	}
 
@@ -1944,7 +1931,6 @@ static int dn_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		flags |= MSG_EOR;
 	}
 
-
 	err = dn_check_state(sk, addr, addr_len, &timeo, flags);
 	if (err)
 		goto out_err;
@@ -2063,7 +2049,6 @@ static int dn_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		skb = NULL;
 
 		scp->persist = dn_nsp_persist(sk);
-
 	}
 out:
 
@@ -2159,11 +2144,11 @@ static struct sock *socket_get_idx(struct seq_file *seq, loff_t *pos)
 static void *dn_socket_get_idx(struct seq_file *seq, loff_t pos)
 {
 	void *rc;
+
 	read_lock_bh(&dn_hash_lock);
 	rc = socket_get_idx(seq, &pos);
-	if (!rc) {
+	if (!rc)
 		read_unlock_bh(&dn_hash_lock);
-	}
 	return rc;
 }
 
@@ -2261,8 +2246,8 @@ static inline void dn_socket_format_entry(struct seq_file *seq, struct sock *sk)
 	struct dn_scp *scp = DN_SK(sk);
 	char buf1[DN_ASCBUF_LEN];
 	char buf2[DN_ASCBUF_LEN];
-	char local_object[DN_MAXOBJL+3];
-	char remote_object[DN_MAXOBJL+3];
+	char local_object[DN_MAXOBJL + 3];
+	char remote_object[DN_MAXOBJL + 3];
 
 	dn_printable_object(&scp->addr, local_object);
 	dn_printable_object(&scp->peer, remote_object);
@@ -2368,7 +2353,6 @@ static int __init decnet_init(void)
 	dn_register_sysctl();
 out:
 	return rc;
-
 }
 module_init(decnet_init);
 
-- 
2.25.1

