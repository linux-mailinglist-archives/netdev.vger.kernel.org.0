Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29B2E47C8DC
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 22:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232458AbhLUVke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 16:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbhLUVkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 16:40:33 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 194F4C061574;
        Tue, 21 Dec 2021 13:40:33 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id q14so143345qtx.10;
        Tue, 21 Dec 2021 13:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uKO0d8LlVhtNEJi0H4frJ+JbdxHCtAkTzEvX5o/uRks=;
        b=mnumMKNB87zC6S7WZ9qBW+Vaw72/bpHxG5+Z++rb9s5dSvkmDay5rRhDJZSc3qY9B7
         HLyO9l2tTXD0GDtWYiIeisXMRPQIPhGbym63b/IMECwc0tcMvJOLJhmI4SfOpxKF2Of0
         wgqMZru1tlnorTodse2/w3I8punF2YW1WN8HngZAOz+zfAGSxS32GqE8U4F00cgKzlWD
         CFOXdkRTqq0mrgCcLdR4C0gw96v1mdz1nDLg5arkKMDXJ7bAE9+OELGXI+BeSSkx6rk7
         NE+u7jJPfrHFOlDwXchYMW+1fW3JKnaYt3/L7Pss28dp+SsiC3BNXCo6IwbTuvWDGnRu
         tKhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uKO0d8LlVhtNEJi0H4frJ+JbdxHCtAkTzEvX5o/uRks=;
        b=6MM59mMt4dS7JPMoYmQKfBfdXepeIcPqs6zPtcWXzIqZ+hd+Eokgebo6dERqHQGE4q
         VxJ3UWjYJp9o3C0WRUEp8wTVCinTLv/n0JmB0TLbu/ovKZrNS2TjGgTqPgprNKFkPvko
         wrh4BlzG8u7uy+FRLYNDnXq6W8TI86D0Jn9ZatQOIeAagSd3/qaSVbos1iQ7nDdsUTLw
         bsJRFazEni/Tj0Y25J4/rtyAJ2fbHOvwswUnx4Obd27AHskLMx0UtJ/l9UobfZRRCGEH
         8PYHhMLPbV0061CkxaF5+rYAVzP8bQG3cspFEQ/D1rCdw1Zf4xDgaM9Xa0R5ZW+30NyQ
         VeRg==
X-Gm-Message-State: AOAM533H8RRFTEL9BqaTz9Ig4HbAK3TQY4uJrj/jj+kCc96vtvsZl8lJ
        lJkSoat4yofYT/nN+3Ccw7WBZzQxvEBiow==
X-Google-Smtp-Source: ABdhPJynwBFeB+aJkXsi7m0fOOpMVr7Dui8HUw0bBc+l1ziNNclXh4lWOu+xB8NIdfLN7KJflPCtzw==
X-Received: by 2002:ac8:5b8c:: with SMTP id a12mr129212qta.353.1640122832051;
        Tue, 21 Dec 2021 13:40:32 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d1sm108223qtn.56.2021.12.21.13.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 13:40:31 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH net-next] sctp: move hlist_node and hashent out of sctp_ep_common
Date:   Tue, 21 Dec 2021 16:40:30 -0500
Message-Id: <21619581e3ed03aa08156f280b3181b9c2823600.1640122830.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Struct sctp_ep_common is included in both asoc and ep, but hlist_node
and hashent are only needed by ep after asoc_hashtable was dropped by
Commit b5eff7128366 ("sctp: drop the old assoc hashtable of sctp").

So it is better to move hlist_node and hashent from sctp_ep_common to
sctp_endpoint, and it saves some space for each asoc.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 include/net/sctp/sctp.h    |  4 ++--
 include/net/sctp/structs.h |  8 ++++----
 net/sctp/input.c           | 27 ++++++++++-----------------
 net/sctp/proc.c            | 10 ++++------
 net/sctp/socket.c          |  6 +++---
 5 files changed, 23 insertions(+), 32 deletions(-)

diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 189fdb9db162..33cf4789009f 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -510,8 +510,8 @@ static inline int sctp_ep_hashfn(struct net *net, __u16 lport)
 	return (net_hash_mix(net) + lport) & (sctp_ep_hashsize - 1);
 }
 
-#define sctp_for_each_hentry(epb, head) \
-	hlist_for_each_entry(epb, head, node)
+#define sctp_for_each_hentry(ep, head) \
+	hlist_for_each_entry(ep, head, node)
 
 /* Is a socket of this style? */
 #define sctp_style(sk, style) __sctp_style((sk), (SCTP_SOCKET_##style))
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index e7d1ed7a3dfb..8826b47e4ff7 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1243,10 +1243,6 @@ enum sctp_endpoint_type {
  */
 
 struct sctp_ep_common {
-	/* Fields to help us manage our entries in the hash tables. */
-	struct hlist_node node;
-	int hashent;
-
 	/* Runtime type information.  What kind of endpoint is this? */
 	enum sctp_endpoint_type type;
 
@@ -1298,6 +1294,10 @@ struct sctp_endpoint {
 	/* Common substructure for endpoint and association. */
 	struct sctp_ep_common base;
 
+	/* Fields to help us manage our entries in the hash tables. */
+	struct hlist_node node;
+	int hashent;
+
 	/* Associations: A list of current associations and mappings
 	 *	      to the data consumers for each association. This
 	 *	      may be in the form of a hash table or other
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 1f1786021d9c..90e12bafdd48 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -746,23 +746,21 @@ static int __sctp_hash_endpoint(struct sctp_endpoint *ep)
 	struct sock *sk = ep->base.sk;
 	struct net *net = sock_net(sk);
 	struct sctp_hashbucket *head;
-	struct sctp_ep_common *epb;
 
-	epb = &ep->base;
-	epb->hashent = sctp_ep_hashfn(net, epb->bind_addr.port);
-	head = &sctp_ep_hashtable[epb->hashent];
+	ep->hashent = sctp_ep_hashfn(net, ep->base.bind_addr.port);
+	head = &sctp_ep_hashtable[ep->hashent];
 
 	if (sk->sk_reuseport) {
 		bool any = sctp_is_ep_boundall(sk);
-		struct sctp_ep_common *epb2;
+		struct sctp_endpoint *ep2;
 		struct list_head *list;
 		int cnt = 0, err = 1;
 
 		list_for_each(list, &ep->base.bind_addr.address_list)
 			cnt++;
 
-		sctp_for_each_hentry(epb2, &head->chain) {
-			struct sock *sk2 = epb2->sk;
+		sctp_for_each_hentry(ep2, &head->chain) {
+			struct sock *sk2 = ep2->base.sk;
 
 			if (!net_eq(sock_net(sk2), net) || sk2 == sk ||
 			    !uid_eq(sock_i_uid(sk2), sock_i_uid(sk)) ||
@@ -789,7 +787,7 @@ static int __sctp_hash_endpoint(struct sctp_endpoint *ep)
 	}
 
 	write_lock(&head->lock);
-	hlist_add_head(&epb->node, &head->chain);
+	hlist_add_head(&ep->node, &head->chain);
 	write_unlock(&head->lock);
 	return 0;
 }
@@ -811,19 +809,16 @@ static void __sctp_unhash_endpoint(struct sctp_endpoint *ep)
 {
 	struct sock *sk = ep->base.sk;
 	struct sctp_hashbucket *head;
-	struct sctp_ep_common *epb;
 
-	epb = &ep->base;
+	ep->hashent = sctp_ep_hashfn(sock_net(sk), ep->base.bind_addr.port);
 
-	epb->hashent = sctp_ep_hashfn(sock_net(sk), epb->bind_addr.port);
-
-	head = &sctp_ep_hashtable[epb->hashent];
+	head = &sctp_ep_hashtable[ep->hashent];
 
 	if (rcu_access_pointer(sk->sk_reuseport_cb))
 		reuseport_detach_sock(sk);
 
 	write_lock(&head->lock);
-	hlist_del_init(&epb->node);
+	hlist_del_init(&ep->node);
 	write_unlock(&head->lock);
 }
 
@@ -856,7 +851,6 @@ static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
 					const union sctp_addr *paddr)
 {
 	struct sctp_hashbucket *head;
-	struct sctp_ep_common *epb;
 	struct sctp_endpoint *ep;
 	struct sock *sk;
 	__be16 lport;
@@ -866,8 +860,7 @@ static struct sctp_endpoint *__sctp_rcv_lookup_endpoint(
 	hash = sctp_ep_hashfn(net, ntohs(lport));
 	head = &sctp_ep_hashtable[hash];
 	read_lock(&head->lock);
-	sctp_for_each_hentry(epb, &head->chain) {
-		ep = sctp_ep(epb);
+	sctp_for_each_hentry(ep, &head->chain) {
 		if (sctp_endpoint_is_match(ep, net, laddr))
 			goto hit;
 	}
diff --git a/net/sctp/proc.c b/net/sctp/proc.c
index 982a87b3e11f..f13d6a34f32f 100644
--- a/net/sctp/proc.c
+++ b/net/sctp/proc.c
@@ -161,7 +161,6 @@ static void *sctp_eps_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 static int sctp_eps_seq_show(struct seq_file *seq, void *v)
 {
 	struct sctp_hashbucket *head;
-	struct sctp_ep_common *epb;
 	struct sctp_endpoint *ep;
 	struct sock *sk;
 	int    hash = *(loff_t *)v;
@@ -171,18 +170,17 @@ static int sctp_eps_seq_show(struct seq_file *seq, void *v)
 
 	head = &sctp_ep_hashtable[hash];
 	read_lock_bh(&head->lock);
-	sctp_for_each_hentry(epb, &head->chain) {
-		ep = sctp_ep(epb);
-		sk = epb->sk;
+	sctp_for_each_hentry(ep, &head->chain) {
+		sk = ep->base.sk;
 		if (!net_eq(sock_net(sk), seq_file_net(seq)))
 			continue;
 		seq_printf(seq, "%8pK %8pK %-3d %-3d %-4d %-5d %5u %5lu ", ep, sk,
 			   sctp_sk(sk)->type, sk->sk_state, hash,
-			   epb->bind_addr.port,
+			   ep->base.bind_addr.port,
 			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(sk)),
 			   sock_i_ino(sk));
 
-		sctp_seq_dump_local_addrs(seq, epb);
+		sctp_seq_dump_local_addrs(seq, &ep->base);
 		seq_printf(seq, "\n");
 	}
 	read_unlock_bh(&head->lock);
diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 055a6d3ec6e2..eed3b87f51f4 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -5294,14 +5294,14 @@ int sctp_for_each_endpoint(int (*cb)(struct sctp_endpoint *, void *),
 			   void *p) {
 	int err = 0;
 	int hash = 0;
-	struct sctp_ep_common *epb;
+	struct sctp_endpoint *ep;
 	struct sctp_hashbucket *head;
 
 	for (head = sctp_ep_hashtable; hash < sctp_ep_hashsize;
 	     hash++, head++) {
 		read_lock_bh(&head->lock);
-		sctp_for_each_hentry(epb, &head->chain) {
-			err = cb(sctp_ep(epb), p);
+		sctp_for_each_hentry(ep, &head->chain) {
+			err = cb(ep, p);
 			if (err)
 				break;
 		}
-- 
2.27.0

