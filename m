Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79C6C65F427
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234942AbjAETOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:14:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231845AbjAETOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:14:03 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 865095F90A
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 11:14:02 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id w72so842611vkw.7
        for <netdev@vger.kernel.org>; Thu, 05 Jan 2023 11:14:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zgV0Iz4KSXhUadj9hWyepECQxY5j2Cw8WCt7E8snnzA=;
        b=aX3dbVTxz9Osq9D8JpF4vgedfqA1KNgt/tSXMYuUMFjfxWnfJZlPWVVDA3nVCPgHcZ
         BLEq7doLCe25Cn27XHs/fee1CX0Z6uJX+AJ9OcFq/CPD2acxoCYusRntMyR8eUoRcSul
         EJL75BB4t9Pd2tGJa+215GoUVK5I2Sj0Vp58vPiQxB03wGOfi4eTL4nS/wta1onKct2r
         lJhhqIJF1YEAHkW+E1nGhrN3Vic11jgFFJFmxw6DLbcLst7tWIMH+NrKaDKtjsKuqhxV
         Fr6QnbCN5zGReHzDQpVhC8JqXx+Y3iN2OelaBrk09jxPwp/otS3DCjpIM0uuuu+j3gaS
         cWvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zgV0Iz4KSXhUadj9hWyepECQxY5j2Cw8WCt7E8snnzA=;
        b=BH9kA7+8Y0u8QyjHLNJQR4KFyetnxpIjvBAm8F2TC7N4ydzvAemdORCFsg9gNKZuHF
         NwiJCe/en1dv0YeiAGZ/dWs0ILqE7CCznfHBXRRsDiH2zP8ucLBGIj2Jaf+3yhLELuzh
         xUP9wdjFK59sco17jiC9ra1mewf9yTpatJymxuD0KChL7UliRRS2/wH4Xlu8r7e5wgZ9
         1lOSjSSIQv0zPlMcw39kEH2O95jhQUZRpfx0R2S5VAAqK5vsYzyq3KgwyMC2HgM+c1Xk
         dmy2DRgNPx8jOY60Ty59BFLyzqNOSPZPrInl3BEhF2leH9FeF7UhRwp8lzjCk15OHufq
         RLWA==
X-Gm-Message-State: AFqh2krKPg7M3NvZU4Y0mLLcfoeQJWNQIFZOE0UwFqclRL1apZeYL48P
        IbExhY0fKXomjSOs2/g9NVgEd/7bv58=
X-Google-Smtp-Source: AMrXdXt+95ZGtLHGC0bkvWkMFyi8IRobaXIwa376ib61aQSJsm3gN54mQncvIP9EKHpPE2VhHHgEBg==
X-Received: by 2002:a05:6122:1242:b0:3af:2f11:81fc with SMTP id b2-20020a056122124200b003af2f1181fcmr20634774vkp.14.1672946041217;
        Thu, 05 Jan 2023 11:14:01 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:65a0:ab60:2455:1dfe:a46b:fd61])
        by smtp.gmail.com with ESMTPSA id 195-20020a370ccc000000b006fec1c0754csm25721804qkm.87.2023.01.05.11.13.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 11:14:00 -0800 (PST)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     g.nault@alphalink.fr, Cong Wang <cong.wang@bytedance.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net 1/2] l2tp: convert l2tp_tunnel_list to idr
Date:   Thu,  5 Jan 2023 11:13:38 -0800
Message-Id: <20230105191339.506839-2-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
References: <20230105191339.506839-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <cong.wang@bytedance.com>

l2tp uses l2tp_tunnel_list to track all registered tunnels and
to allocate tunnel ID's. IDR can do the same job.

More importantly, with IDR we can hold the ID before a successful
registration so that we don't need to worry about late error
hanlding, it is not easy to rollback socket changes.

This is a preparation for the following fix.

Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Guillaume Nault <g.nault@alphalink.fr>
Cc: Jakub Sitnicki <jakub@cloudflare.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <cong.wang@bytedance.com>
---
 net/l2tp/l2tp_core.c    | 93 ++++++++++++++++++++++-------------------
 net/l2tp/l2tp_core.h    |  3 +-
 net/l2tp/l2tp_netlink.c |  3 +-
 net/l2tp/l2tp_ppp.c     |  3 +-
 4 files changed, 57 insertions(+), 45 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 9a1415fe3fa7..570249a91c6c 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -104,9 +104,9 @@ static struct workqueue_struct *l2tp_wq;
 /* per-net private data for this module */
 static unsigned int l2tp_net_id;
 struct l2tp_net {
-	struct list_head l2tp_tunnel_list;
-	/* Lock for write access to l2tp_tunnel_list */
-	spinlock_t l2tp_tunnel_list_lock;
+	/* Lock for write access to l2tp_tunnel_idr */
+	spinlock_t l2tp_tunnel_idr_lock;
+	struct idr l2tp_tunnel_idr;
 	struct hlist_head l2tp_session_hlist[L2TP_HASH_SIZE_2];
 	/* Lock for write access to l2tp_session_hlist */
 	spinlock_t l2tp_session_hlist_lock;
@@ -208,13 +208,10 @@ struct l2tp_tunnel *l2tp_tunnel_get(const struct net *net, u32 tunnel_id)
 	struct l2tp_tunnel *tunnel;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (tunnel->tunnel_id == tunnel_id &&
-		    refcount_inc_not_zero(&tunnel->ref_count)) {
-			rcu_read_unlock_bh();
-
-			return tunnel;
-		}
+	tunnel = idr_find(&pn->l2tp_tunnel_idr, tunnel_id);
+	if (tunnel && refcount_inc_not_zero(&tunnel->ref_count)) {
+		rcu_read_unlock_bh();
+		return tunnel;
 	}
 	rcu_read_unlock_bh();
 
@@ -224,13 +221,14 @@ EXPORT_SYMBOL_GPL(l2tp_tunnel_get);
 
 struct l2tp_tunnel *l2tp_tunnel_get_nth(const struct net *net, int nth)
 {
-	const struct l2tp_net *pn = l2tp_pernet(net);
+	struct l2tp_net *pn = l2tp_pernet(net);
+	unsigned long tunnel_id, tmp;
 	struct l2tp_tunnel *tunnel;
 	int count = 0;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		if (++count > nth &&
+	idr_for_each_entry_ul(&pn->l2tp_tunnel_idr, tunnel, tmp, tunnel_id) {
+		if (tunnel && ++count > nth &&
 		    refcount_inc_not_zero(&tunnel->ref_count)) {
 			rcu_read_unlock_bh();
 			return tunnel;
@@ -1234,7 +1232,6 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 						  del_work);
 	struct sock *sk = tunnel->sock;
 	struct socket *sock = sk->sk_socket;
-	struct l2tp_net *pn;
 
 	l2tp_tunnel_closeall(tunnel);
 
@@ -1248,12 +1245,7 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 		}
 	}
 
-	/* Remove the tunnel struct from the tunnel list */
-	pn = l2tp_pernet(tunnel->l2tp_net);
-	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
-	list_del_rcu(&tunnel->list);
-	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-
+	l2tp_tunnel_remove(tunnel);
 	/* drop initial ref */
 	l2tp_tunnel_dec_refcount(tunnel);
 
@@ -1386,16 +1378,37 @@ static int l2tp_tunnel_sock_create(struct net *net,
 
 static struct lock_class_key l2tp_socket_class;
 
-int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
-		       struct l2tp_tunnel_cfg *cfg, struct l2tp_tunnel **tunnelp)
+void l2tp_tunnel_remove(struct l2tp_tunnel *tunnel)
+{
+	struct l2tp_net *pn = l2tp_pernet(tunnel->l2tp_net);
+
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_remove(&pn->l2tp_tunnel_idr, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
+}
+EXPORT_SYMBOL_GPL(l2tp_tunnel_remove);
+
+int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
+		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
+		       struct l2tp_tunnel **tunnelp)
 {
 	struct l2tp_tunnel *tunnel = NULL;
 	int err;
 	enum l2tp_encap_type encap = L2TP_ENCAPTYPE_UDP;
+	struct l2tp_net *pn = l2tp_pernet(net);
 
 	if (cfg)
 		encap = cfg->encap;
 
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	err = idr_alloc_u32(&pn->l2tp_tunnel_idr, NULL, &tunnel_id, tunnel_id,
+			    GFP_ATOMIC);
+	if (err) {
+		spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
+		return err;
+	}
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
+
 	tunnel = kzalloc(sizeof(*tunnel), GFP_KERNEL);
 	if (!tunnel) {
 		err = -ENOMEM;
@@ -1412,6 +1425,7 @@ int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
 	tunnel->acpt_newsess = true;
 
 	tunnel->encap = encap;
+	tunnel->l2tp_net = net;
 
 	refcount_set(&tunnel->ref_count, 1);
 	tunnel->fd = fd;
@@ -1425,6 +1439,11 @@ int l2tp_tunnel_create(int fd, int version, u32 tunnel_id, u32 peer_tunnel_id,
 err:
 	if (tunnelp)
 		*tunnelp = tunnel;
+	if (err) {
+		spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+		idr_remove(&pn->l2tp_tunnel_idr, tunnel_id);
+		spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
+	}
 
 	return err;
 }
@@ -1455,7 +1474,6 @@ static int l2tp_validate_socket(const struct sock *sk, const struct net *net,
 int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			 struct l2tp_tunnel_cfg *cfg)
 {
-	struct l2tp_tunnel *tunnel_walk;
 	struct l2tp_net *pn;
 	struct socket *sock;
 	struct sock *sk;
@@ -1481,23 +1499,14 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 	rcu_assign_sk_user_data(sk, tunnel);
 	write_unlock_bh(&sk->sk_callback_lock);
 
-	tunnel->l2tp_net = net;
 	pn = l2tp_pernet(net);
 
 	sock_hold(sk);
 	tunnel->sock = sk;
 
-	spin_lock_bh(&pn->l2tp_tunnel_list_lock);
-	list_for_each_entry(tunnel_walk, &pn->l2tp_tunnel_list, list) {
-		if (tunnel_walk->tunnel_id == tunnel->tunnel_id) {
-			spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
-			sock_put(sk);
-			ret = -EEXIST;
-			goto err_sock;
-		}
-	}
-	list_add_rcu(&tunnel->list, &pn->l2tp_tunnel_list);
-	spin_unlock_bh(&pn->l2tp_tunnel_list_lock);
+	spin_lock_bh(&pn->l2tp_tunnel_idr_lock);
+	idr_replace(&pn->l2tp_tunnel_idr, tunnel, tunnel->tunnel_id);
+	spin_unlock_bh(&pn->l2tp_tunnel_idr_lock);
 
 	if (tunnel->encap == L2TP_ENCAPTYPE_UDP) {
 		struct udp_tunnel_sock_cfg udp_cfg = {
@@ -1523,9 +1532,6 @@ int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 
 	return 0;
 
-err_sock:
-	write_lock_bh(&sk->sk_callback_lock);
-	rcu_assign_sk_user_data(sk, NULL);
 err_inval_sock:
 	write_unlock_bh(&sk->sk_callback_lock);
 
@@ -1647,8 +1653,8 @@ static __net_init int l2tp_init_net(struct net *net)
 	struct l2tp_net *pn = net_generic(net, l2tp_net_id);
 	int hash;
 
-	INIT_LIST_HEAD(&pn->l2tp_tunnel_list);
-	spin_lock_init(&pn->l2tp_tunnel_list_lock);
+	idr_init(&pn->l2tp_tunnel_idr);
+	spin_lock_init(&pn->l2tp_tunnel_idr_lock);
 
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++)
 		INIT_HLIST_HEAD(&pn->l2tp_session_hlist[hash]);
@@ -1662,11 +1668,13 @@ static __net_exit void l2tp_exit_net(struct net *net)
 {
 	struct l2tp_net *pn = l2tp_pernet(net);
 	struct l2tp_tunnel *tunnel = NULL;
+	unsigned long tunnel_id, tmp;
 	int hash;
 
 	rcu_read_lock_bh();
-	list_for_each_entry_rcu(tunnel, &pn->l2tp_tunnel_list, list) {
-		l2tp_tunnel_delete(tunnel);
+	idr_for_each_entry_ul(&pn->l2tp_tunnel_idr, tunnel, tmp, tunnel_id) {
+		if (tunnel)
+			l2tp_tunnel_delete(tunnel);
 	}
 	rcu_read_unlock_bh();
 
@@ -1676,6 +1684,7 @@ static __net_exit void l2tp_exit_net(struct net *net)
 
 	for (hash = 0; hash < L2TP_HASH_SIZE_2; hash++)
 		WARN_ON_ONCE(!hlist_empty(&pn->l2tp_session_hlist[hash]));
+	idr_destroy(&pn->l2tp_tunnel_idr);
 }
 
 static struct pernet_operations l2tp_net_ops = {
diff --git a/net/l2tp/l2tp_core.h b/net/l2tp/l2tp_core.h
index a88e070b431d..aec7e0611591 100644
--- a/net/l2tp/l2tp_core.h
+++ b/net/l2tp/l2tp_core.h
@@ -236,9 +236,10 @@ struct l2tp_session *l2tp_session_get_by_ifname(const struct net *net,
  * Creation of a new instance is a two-step process: create, then register.
  * Destruction is triggered using the *_delete functions, and completes asynchronously.
  */
-int l2tp_tunnel_create(int fd, int version, u32 tunnel_id,
+int l2tp_tunnel_create(struct net *net, int fd, int version, u32 tunnel_id,
 		       u32 peer_tunnel_id, struct l2tp_tunnel_cfg *cfg,
 		       struct l2tp_tunnel **tunnelp);
+void l2tp_tunnel_remove(struct l2tp_tunnel *tunnel);
 int l2tp_tunnel_register(struct l2tp_tunnel *tunnel, struct net *net,
 			 struct l2tp_tunnel_cfg *cfg);
 void l2tp_tunnel_delete(struct l2tp_tunnel *tunnel);
diff --git a/net/l2tp/l2tp_netlink.c b/net/l2tp/l2tp_netlink.c
index a901fd14fe3b..6fcf36a8eafd 100644
--- a/net/l2tp/l2tp_netlink.c
+++ b/net/l2tp/l2tp_netlink.c
@@ -233,7 +233,7 @@ static int l2tp_nl_cmd_tunnel_create(struct sk_buff *skb, struct genl_info *info
 	switch (cfg.encap) {
 	case L2TP_ENCAPTYPE_UDP:
 	case L2TP_ENCAPTYPE_IP:
-		ret = l2tp_tunnel_create(fd, proto_version, tunnel_id,
+		ret = l2tp_tunnel_create(net, fd, proto_version, tunnel_id,
 					 peer_tunnel_id, &cfg, &tunnel);
 		break;
 	}
@@ -244,6 +244,7 @@ static int l2tp_nl_cmd_tunnel_create(struct sk_buff *skb, struct genl_info *info
 	l2tp_tunnel_inc_refcount(tunnel);
 	ret = l2tp_tunnel_register(tunnel, net, &cfg);
 	if (ret < 0) {
+		l2tp_tunnel_remove(tunnel);
 		kfree(tunnel);
 		goto out;
 	}
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index db2e584c625e..813ada637485 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -711,7 +711,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 				goto end;
 			}
 
-			error = l2tp_tunnel_create(info.fd,
+			error = l2tp_tunnel_create(sock_net(sk), info.fd,
 						   info.version,
 						   info.tunnel_id,
 						   info.peer_tunnel_id, &tcfg,
@@ -723,6 +723,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 			error = l2tp_tunnel_register(tunnel, sock_net(sk),
 						     &tcfg);
 			if (error < 0) {
+				l2tp_tunnel_remove(tunnel);
 				kfree(tunnel);
 				goto end;
 			}
-- 
2.34.1

