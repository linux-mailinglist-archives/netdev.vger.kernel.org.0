Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4A647C7C6
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 20:51:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241907AbhLUTvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 14:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhLUTvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 14:51:55 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3973FC061574;
        Tue, 21 Dec 2021 11:51:55 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id g28so112197qkk.9;
        Tue, 21 Dec 2021 11:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z3ANZDblh8W0f3X78t2Ravtf88SwPUjr+oRX6jB5xJI=;
        b=CJMpF6bjZDni5rbgTLiYYIg3O/nx0p1oKxM/5zcxXYNNs/DUlMfAvi2FiLIJHYb2EE
         AfofH8uPWNOoIsiV0oFwVar7Ot5ay5vw1wWaOX8iK3T93bntgHJtl18ebp/98NcLvrRw
         G515kG32yFWfPec9gHAccsMxX4zR9q95YVVc6ULSShMZhfXfsA9Ss0RQoyelFKd+te8Q
         4/uDuvYFxP6v/YA5sH+Cxag+sLSNu3UzZIjJVTllIu0U0y87UPS0mciQMRmF7QwCpeTo
         Jg9rp36T2Nn1Ni1RTd6rTE9/roAsBjbPcFv1CkWGvgn+Ij7UQYgyQI2PqOuWOYmMaR7R
         sPLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Z3ANZDblh8W0f3X78t2Ravtf88SwPUjr+oRX6jB5xJI=;
        b=u+JX8VFU3tg2ImPR8+VS9r+Uw6bdlCr2wMS3hirjU/PkkZsF3mt5IkmuzwaSb29rGG
         24ouwnTLlu9EmbT2ESHqJbq0A0jolfeQKpTGSMpg/vyO0lN3E6xXxAn+IOteJtQPMsZ3
         ec419d6s9qvG88A9+OnnjXvOEOd3EF8snORwMpZYgl9oSbC75+Hd/btJAVamN9TRaM8a
         Npdlx8f3+/7D9HwmTF62nkWtyZ8ea38gWVk3pJV514KMfTqe0j4zYelXZG6XpAW2Wumx
         Zd/xclKePll9Bw7XIQRW7a1LD7SzZihGogv041G4+QbGGEs2zd5peCqczKXFpfc9vxbl
         w8+A==
X-Gm-Message-State: AOAM531Mfau8rIDVBFH10IKE88ls0SP161upgfRnh7vQJdZF44XZ7Ao0
        itNj8EA4vKWx195cIFmMjiU8jEJ2uvNulg==
X-Google-Smtp-Source: ABdhPJzL2rCEQUssvmEws9/5TrmA7OZ2wJWnjuiK1379ED3/OpWT46NuHWfHK+NWbw0+ROcZNyPfGw==
X-Received: by 2002:a05:620a:a16:: with SMTP id i22mr3230644qka.362.1640116314171;
        Tue, 21 Dec 2021 11:51:54 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id v12sm9569489qkl.50.2021.12.21.11.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 11:51:53 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH net] sctp: use call_rcu to free endpoint
Date:   Tue, 21 Dec 2021 14:51:52 -0500
Message-Id: <fc90434665ed92ac9e02cd6e5a9d7e64816b0847.1640116312.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to delay the endpoint free by calling call_rcu() to fix
another use-after-free issue in sctp_sock_dump():

  BUG: KASAN: use-after-free in __lock_acquire+0x36d9/0x4c20
  Call Trace:
    __lock_acquire+0x36d9/0x4c20 kernel/locking/lockdep.c:3218
    lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
    __raw_spin_lock_bh include/linux/spinlock_api_smp.h:135 [inline]
    _raw_spin_lock_bh+0x31/0x40 kernel/locking/spinlock.c:168
    spin_lock_bh include/linux/spinlock.h:334 [inline]
    __lock_sock+0x203/0x350 net/core/sock.c:2253
    lock_sock_nested+0xfe/0x120 net/core/sock.c:2774
    lock_sock include/net/sock.h:1492 [inline]
    sctp_sock_dump+0x122/0xb20 net/sctp/diag.c:324
    sctp_for_each_transport+0x2b5/0x370 net/sctp/socket.c:5091
    sctp_diag_dump+0x3ac/0x660 net/sctp/diag.c:527
    __inet_diag_dump+0xa8/0x140 net/ipv4/inet_diag.c:1049
    inet_diag_dump+0x9b/0x110 net/ipv4/inet_diag.c:1065
    netlink_dump+0x606/0x1080 net/netlink/af_netlink.c:2244
    __netlink_dump_start+0x59a/0x7c0 net/netlink/af_netlink.c:2352
    netlink_dump_start include/linux/netlink.h:216 [inline]
    inet_diag_handler_cmd+0x2ce/0x3f0 net/ipv4/inet_diag.c:1170
    __sock_diag_cmd net/core/sock_diag.c:232 [inline]
    sock_diag_rcv_msg+0x31d/0x410 net/core/sock_diag.c:263
    netlink_rcv_skb+0x172/0x440 net/netlink/af_netlink.c:2477
    sock_diag_rcv+0x2a/0x40 net/core/sock_diag.c:274

This issue occurs when asoc is peeled off and the old sk is freed after
getting sk by asoc->base.sk and before calling lock_sock(sk).

To prevent the ep/sk free, this patch is to call call_rcu to free the ep
and hold it under rcu_read_lock to make sure that sk in sctp_sock_dump
is still alive when calling lock_sock().

Note that delaying endpint free won't delay the port release, as the port
release happens in sctp_endpoint_destroy() before calling call_rcu().
Also, freeing endpoint by call_rcu() makes it safe to access the sk by
asoc->base.sk in sctp_assocs_seq_show() and sctp_rcv().

Thanks Jones to bring this issue up.

Reported-by: syzbot+9276d76e83e3bcde6c99@syzkaller.appspotmail.com
Reported-by: Lee Jones <lee.jones@linaro.org>
Fixes: d25adbeb0cdb ("sctp: fix an use-after-free issue in sctp_sock_dump")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h    |  6 +++---
 include/net/sctp/structs.h |  3 ++-
 net/sctp/diag.c            | 12 ++++++------
 net/sctp/endpointola.c     | 22 ++++++++++++++--------
 net/sctp/socket.c          | 23 +++++++++++++++--------
 5 files changed, 40 insertions(+), 26 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 189fdb9db162..d314a180ab93 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -105,6 +105,7 @@ extern struct percpu_counter sctp_sockets_allocated;
 int sctp_asconf_mgmt(struct sctp_sock *, struct sctp_sockaddr_entry *);
 struct sk_buff *sctp_skb_recv_datagram(struct sock *, int, int, int *);
 
+typedef int (*sctp_callback_t)(struct sctp_endpoint *, struct sctp_transport *, void *);
 void sctp_transport_walk_start(struct rhashtable_iter *iter);
 void sctp_transport_walk_stop(struct rhashtable_iter *iter);
 struct sctp_transport *sctp_transport_get_next(struct net *net,
@@ -115,9 +116,8 @@ int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
 				  struct net *net,
 				  const union sctp_addr *laddr,
 				  const union sctp_addr *paddr, void *p);
-int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
-			    int (*cb_done)(struct sctp_transport *, void *),
-			    struct net *net, int *pos, void *p);
+int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
+				    struct net *net, int *pos, void *p);
 int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *), void *p);
 int sctp_get_sctp_info(struct sock *sk, struct sctp_association *asoc,
 		       struct sctp_info *info);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index 899c29c326ba..8dabd8800006 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1355,6 +1355,7 @@ struct sctp_endpoint {
 	      reconf_enable:1;
 
 	__u8  strreset_enable;
+	struct rcu_head rcu;
 };
 
 /* Recover the outter endpoint structure. */
@@ -1370,7 +1371,7 @@ static inline struct sctp_endpoint *sctp_ep(struct sctp_ep_common *base)
 struct sctp_endpoint *sctp_endpoint_new(struct sock *, gfp_t);
 void sctp_endpoint_free(struct sctp_endpoint *);
 void sctp_endpoint_put(struct sctp_endpoint *);
-void sctp_endpoint_hold(struct sctp_endpoint *);
+int sctp_endpoint_hold(struct sctp_endpoint *ep);
 void sctp_endpoint_add_asoc(struct sctp_endpoint *, struct sctp_association *);
 struct sctp_association *sctp_endpoint_lookup_assoc(
 	const struct sctp_endpoint *ep,
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index 760b367644c1..a7d623171501 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -290,9 +290,8 @@ static int sctp_tsp_dump_one(struct sctp_transport *tsp, void *p)
 	return err;
 }
 
-static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
+static int sctp_sock_dump(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
-	struct sctp_endpoint *ep = tsp->asoc->ep;
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	struct sk_buff *skb = commp->skb;
@@ -302,6 +301,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
 	int err = 0;
 
 	lock_sock(sk);
+	if (ep != tsp->asoc->ep)
+		goto release;
 	list_for_each_entry(assoc, &ep->asocs, asocs) {
 		if (cb->args[4] < cb->args[1])
 			goto next;
@@ -344,9 +345,8 @@ static int sctp_sock_dump(struct sctp_transport *tsp, void *p)
 	return err;
 }
 
-static int sctp_sock_filter(struct sctp_transport *tsp, void *p)
+static int sctp_sock_filter(struct sctp_endpoint *ep, struct sctp_transport *tsp, void *p)
 {
-	struct sctp_endpoint *ep = tsp->asoc->ep;
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *r = commp->r;
@@ -505,8 +505,8 @@ static void sctp_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	if (!(idiag_states & ~(TCPF_LISTEN | TCPF_CLOSE)))
 		goto done;
 
-	sctp_for_each_transport(sctp_sock_filter, sctp_sock_dump,
-				net, &pos, &commp);
+	sctp_transport_traverse_process(sctp_sock_filter, sctp_sock_dump,
+					net, &pos, &commp);
 	cb->args[2] = pos;
 
 done:
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index 48c9c2c7602f..81fb97d382d7 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -184,6 +184,17 @@ void sctp_endpoint_free(struct sctp_endpoint *ep)
 }
 
 /* Final destructor for endpoint.  */
+static void sctp_endpoint_destroy_rcu(struct rcu_head *head)
+{
+	struct sctp_endpoint *ep = container_of(head, struct sctp_endpoint, rcu);
+	struct sock *sk = ep->base.sk;
+
+	sctp_sk(sk)->ep = NULL;
+	sock_put(sk);
+
+	SCTP_DBG_OBJCNT_DEC(ep);
+}
+
 static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 {
 	struct sock *sk;
@@ -213,18 +224,13 @@ static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
 	if (sctp_sk(sk)->bind_hash)
 		sctp_put_port(sk);
 
-	sctp_sk(sk)->ep = NULL;
-	/* Give up our hold on the sock */
-	sock_put(sk);
-
-	kfree(ep);
-	SCTP_DBG_OBJCNT_DEC(ep);
+	call_rcu(&ep->rcu, sctp_endpoint_destroy_rcu);
 }
 
 /* Hold a reference to an endpoint. */
-void sctp_endpoint_hold(struct sctp_endpoint *ep)
+int sctp_endpoint_hold(struct sctp_endpoint *ep)
 {
-	refcount_inc(&ep->base.refcnt);
+	return refcount_inc_not_zero(&ep->base.refcnt);
 }
 
 /* Release a reference to an endpoint and clean up if there are
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 33391254fa82..ad5028a07b18 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5338,11 +5338,12 @@ int sctp_transport_lookup_process(int (*cb)(struct sctp_transport *, void *),
 }
 EXPORT_SYMBOL_GPL(sctp_transport_lookup_process);
 
-int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
-			    int (*cb_done)(struct sctp_transport *, void *),
-			    struct net *net, int *pos, void *p) {
+int sctp_transport_traverse_process(sctp_callback_t cb, sctp_callback_t cb_done,
+				    struct net *net, int *pos, void *p)
+{
 	struct rhashtable_iter hti;
 	struct sctp_transport *tsp;
+	struct sctp_endpoint *ep;
 	int ret;
 
 again:
@@ -5351,26 +5352,32 @@ int sctp_for_each_transport(int (*cb)(struct sctp_transport *, void *),
 
 	tsp = sctp_transport_get_idx(net, &hti, *pos + 1);
 	for (; !IS_ERR_OR_NULL(tsp); tsp = sctp_transport_get_next(net, &hti)) {
-		ret = cb(tsp, p);
-		if (ret)
-			break;
+		ep = tsp->asoc->ep;
+		if (sctp_endpoint_hold(ep)) { /* asoc can be peeled off */
+			ret = cb(ep, tsp, p);
+			if (ret)
+				break;
+			sctp_endpoint_put(ep);
+		}
 		(*pos)++;
 		sctp_transport_put(tsp);
 	}
 	sctp_transport_walk_stop(&hti);
 
 	if (ret) {
-		if (cb_done && !cb_done(tsp, p)) {
+		if (cb_done && !cb_done(ep, tsp, p)) {
 			(*pos)++;
+			sctp_endpoint_put(ep);
 			sctp_transport_put(tsp);
 			goto again;
 		}
+		sctp_endpoint_put(ep);
 		sctp_transport_put(tsp);
 	}
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(sctp_for_each_transport);
+EXPORT_SYMBOL_GPL(sctp_transport_traverse_process);
 
 /* 7.2.1 Association Status (SCTP_STATUS)
 
-- 
2.27.0

