Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1799C6BC324
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 02:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbjCPBKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 21:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCPBKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 21:10:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3912926C32
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:34 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o130-20020a257388000000b00b3a7d06fd2eso171346ybc.22
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 18:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678929033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=k711e50qQkGPLXQp2eEaxBU61C2DaCcRl1dngoXQeYs=;
        b=QOAAHK8oE4FHULjoxSrdvBVjEXCot9bkNlpmSP52VN+skUJwFntMAQK2tuV5/xPUXU
         94Xy1wz5W0bC8s5ECzSuoQunt20TBvxjewZCT7x3IlrtzMzM7V75bOJrpRkVn9kBC/6e
         cvgRm+Dv1jl5N6LJUfFRbveP0tTzZbwOodwMx9hAcctlk9Pobp8aTpB1Un7MWjBJORHr
         GC41FEb82RN4bhDEzbuHqfysUXdaAZ75Kj0khibr5PzeXViM41avg3/7F66NDRm1HX0i
         lKnGgxXj3dh//DOVc7WgVmr5X8XfLEdccnHJ0RHTYtQes2TJ5pY0YKi/soT0Bo3ZW2jH
         5Zmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678929033;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k711e50qQkGPLXQp2eEaxBU61C2DaCcRl1dngoXQeYs=;
        b=1pfaHeSJfC7vrAg2FD45nPIDCRK1c7h6u0nUaWCzGFcNLCosKyCBFwmfXzx4TGfbZw
         drjeuiRfSz03QbWQ1WvO23EYb5KtifJuTya05l7fSAITPkRyRKnLRR8OZAPeiOkJM7/H
         H9NORsgEPzHi/FvoI1C/FHsZpttbcsee2wQ6e50C+1aa/BMDz/4PjLeA3+4r1mx0Lk6u
         N7B4bSh5i8URKnLmPhWdXS+YHCtNHUlFH4H9JrD0jsqd0RbzNsfgcUgj2j5lm+RNSXwv
         W+79VP4EEkYAcIqgntYGlwfcNTMyeY1aQCvs+o/Fxi6R3n+lmHJAxJpkVaKKl7tjhpsO
         J53g==
X-Gm-Message-State: AO0yUKWRvXh8+QqwROJIeR+dP9nbFgyehDZAgCPwuQ9H6frqqjeuNEJX
        t3K+8GRNWbyaIhhD78ooO9mw0ljR5Vo8DQ==
X-Google-Smtp-Source: AK7set8oBkRzC1ikc5Tv6sCQR+knE4ilSuBbu8iac4KGLh2Xra9gzC1ILQMjZADmvfyFQyA8vfrt12V0gQkGnQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a5b:24a:0:b0:997:c919:4484 with SMTP id
 g10-20020a5b024a000000b00997c9194484mr17337365ybp.6.1678929033410; Wed, 15
 Mar 2023 18:10:33 -0700 (PDT)
Date:   Thu, 16 Mar 2023 01:10:13 +0000
In-Reply-To: <20230316011014.992179-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316011014.992179-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316011014.992179-9-edumazet@google.com>
Subject: [PATCH net-next 8/9] net/packet: convert po->running to an atomic flag
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of consuming 32 bits for po->running, use
one available bit in po->flags.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/packet/af_packet.c | 20 ++++++++++----------
 net/packet/diag.c      |  2 +-
 net/packet/internal.h  |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 5a6b05e17ca214e1faeac201e647e0d34686c89a..ec446452bbe8d1b140b551006a3b2c9e5bace787 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -340,14 +340,14 @@ static void __register_prot_hook(struct sock *sk)
 {
 	struct packet_sock *po = pkt_sk(sk);
 
-	if (!po->running) {
+	if (!packet_sock_flag(po, PACKET_SOCK_RUNNING)) {
 		if (po->fanout)
 			__fanout_link(sk, po);
 		else
 			dev_add_pack(&po->prot_hook);
 
 		sock_hold(sk);
-		po->running = 1;
+		packet_sock_flag_set(po, PACKET_SOCK_RUNNING, 1);
 	}
 }
 
@@ -369,7 +369,7 @@ static void __unregister_prot_hook(struct sock *sk, bool sync)
 
 	lockdep_assert_held_once(&po->bind_lock);
 
-	po->running = 0;
+	packet_sock_flag_set(po, PACKET_SOCK_RUNNING, 0);
 
 	if (po->fanout)
 		__fanout_unlink(sk, po);
@@ -389,7 +389,7 @@ static void unregister_prot_hook(struct sock *sk, bool sync)
 {
 	struct packet_sock *po = pkt_sk(sk);
 
-	if (po->running)
+	if (packet_sock_flag(po, PACKET_SOCK_RUNNING))
 		__unregister_prot_hook(sk, sync);
 }
 
@@ -1782,7 +1782,7 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 	err = -EINVAL;
 
 	spin_lock(&po->bind_lock);
-	if (po->running &&
+	if (packet_sock_flag(po, PACKET_SOCK_RUNNING) &&
 	    match->type == type &&
 	    match->prot_hook.type == po->prot_hook.type &&
 	    match->prot_hook.dev == po->prot_hook.dev) {
@@ -3222,7 +3222,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 
 	if (need_rehook) {
 		dev_hold(dev);
-		if (po->running) {
+		if (packet_sock_flag(po, PACKET_SOCK_RUNNING)) {
 			rcu_read_unlock();
 			/* prevents packet_notifier() from calling
 			 * register_prot_hook()
@@ -3235,7 +3235,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 								 dev->ifindex);
 		}
 
-		BUG_ON(po->running);
+		BUG_ON(packet_sock_flag(po, PACKET_SOCK_RUNNING));
 		WRITE_ONCE(po->num, proto);
 		po->prot_hook.type = proto;
 
@@ -4159,7 +4159,7 @@ static int packet_notifier(struct notifier_block *this,
 		case NETDEV_DOWN:
 			if (dev->ifindex == po->ifindex) {
 				spin_lock(&po->bind_lock);
-				if (po->running) {
+				if (packet_sock_flag(po, PACKET_SOCK_RUNNING)) {
 					__unregister_prot_hook(sk, false);
 					sk->sk_err = ENETDOWN;
 					if (!sock_flag(sk, SOCK_DEAD))
@@ -4470,7 +4470,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 
 	/* Detach socket from network */
 	spin_lock(&po->bind_lock);
-	was_running = po->running;
+	was_running = packet_sock_flag(po, PACKET_SOCK_RUNNING);
 	num = po->num;
 	if (was_running) {
 		WRITE_ONCE(po->num, 0);
@@ -4681,7 +4681,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 			   s->sk_type,
 			   ntohs(READ_ONCE(po->num)),
 			   READ_ONCE(po->ifindex),
-			   po->running,
+			   packet_sock_flag(po, PACKET_SOCK_RUNNING),
 			   atomic_read(&s->sk_rmem_alloc),
 			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)),
 			   sock_i_ino(s));
diff --git a/net/packet/diag.c b/net/packet/diag.c
index 56240aaf032b25fdbbaf2ed6421cdbcc3669d1ec..de4ced5cf3e8c5798530ab3bfbe162cc3913b318 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -21,7 +21,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 	pinfo.pdi_tstamp = READ_ONCE(po->tp_tstamp);
 
 	pinfo.pdi_flags = 0;
-	if (po->running)
+	if (packet_sock_flag(po, PACKET_SOCK_RUNNING))
 		pinfo.pdi_flags |= PDI_RUNNING;
 	if (packet_sock_flag(po, PACKET_SOCK_AUXDATA))
 		pinfo.pdi_flags |= PDI_AUXDATA;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 2521176807f4f8ba430c5a94c7c50a0372b1a92a..58f042c631723118b4b2115142b37b828a4d9e9f 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -117,7 +117,6 @@ struct packet_sock {
 	spinlock_t		bind_lock;
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
-	unsigned int		running;	/* bind_lock must be held */
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
@@ -146,6 +145,7 @@ enum packet_sock_flags {
 	PACKET_SOCK_TX_HAS_OFF,
 	PACKET_SOCK_TP_LOSS,
 	PACKET_SOCK_HAS_VNET_HDR,
+	PACKET_SOCK_RUNNING,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.40.0.rc2.332.ga46443480c-goog

