Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945C13D6595
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 19:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbhGZQkA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 12:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235921AbhGZQjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 12:39:23 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75264C0BB56C;
        Mon, 26 Jul 2021 09:53:42 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id a13so12723451iol.5;
        Mon, 26 Jul 2021 09:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TST9Evg7YSFkD3gtj7vE6ssLhHqcDOyzBWsiW3nAOtU=;
        b=EtQVp/7xn4iOGk0sx21Sc6VgUSdHlqVsdJGC7DKW1MbFDrNgvJXlaou2doksWKup3y
         ICQ1SleyQr9qCMMIEc1PhRzALxZzTjrXwWOGgN5LE8az6q/ugwVVKfs3imEN7QA+rAZd
         3idQFzHsZS8dMl3+jgx7uz5aPaPfm6Uiqkhow0ghf5SMBBXy5prxaJjHvKBWpaKgDnEI
         zjovrYuFnBfa4k47PEyG/lk7rlsU/tiheC/JRyVNLVFE1sSAjg9SsFCfvayiISWg1FA6
         ZSTAXPeHoxStKzVN1Keq2ge23YNDzPO9HhHImWskxj78/7nb+SG18/gW+Qn8XUbVOs9J
         08Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TST9Evg7YSFkD3gtj7vE6ssLhHqcDOyzBWsiW3nAOtU=;
        b=gchGfsaocSPgKsWMpJe6zx6bb3NvPup7wbzXwI0mGF6HXDPDEcHqABYjxMC0M/NVby
         hqGlQBh5wagjh7eupzNuP/ZVSUNaDiaNeAALauxocd0Vp2B4oFmKlVFZhcELXMFE5P26
         5SuarMv8NZ+ZJRr35Ikl0sBmrywy+JWyCi9PkXauwm0fSBoDAXpwECtuUcDvOvBN3PNF
         Utt2owIlw0zNgf41pKCQjH6aHOQBPVo7Vw7WtPdu7rR/XGfPHgdJwncy0NjeR6LdMmft
         tMUQhRJ3Jnbc8Kg9SSCHHztW4nWgWolqB1uXsjQzA+N+E0pvDB8U+Jp0jNWoD0HYpEKO
         2BZg==
X-Gm-Message-State: AOAM53177bSzhk4fAJyesNRP/791aXv+qTOfmgDVf45oUr4Ob7IGjJ2R
        ocOME1kWcRWpu3ecyJYHthRtdmjrAoi5eg==
X-Google-Smtp-Source: ABdhPJw1g0qO1f6KWN5aZ++YxD8UtDOSc7QJOoGlV3iBJakUdcthFmj7aaqnx22VRXz9jd9Jfbpipw==
X-Received: by 2002:a05:6638:538:: with SMTP id j24mr17268989jar.59.1627318421937;
        Mon, 26 Jul 2021 09:53:41 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r198sm254483ior.7.2021.07.26.09.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 09:53:41 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net,
        xiyou.wangcong@gmail.com, alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf v2 3/3] bpf, sockmap: fix memleak on ingress msg enqueue
Date:   Mon, 26 Jul 2021 09:53:04 -0700
Message-Id: <20210726165304.1443836-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210726165304.1443836-1-john.fastabend@gmail.com>
References: <20210726165304.1443836-1-john.fastabend@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If backlog handler is running during a tear down operation we may enqueue
data on the ingress msg queue while tear down is trying to free it.

 sk_psock_backlog()
   sk_psock_handle_skb()
     skb_psock_skb_ingress()
       sk_psock_skb_ingress_enqueue()
         sk_psock_queue_msg(psock,msg)
                                           spin_lock(ingress_lock)
                                            sk_psock_zap_ingress()
                                             _sk_psock_purge_ingerss_msg()
                                              _sk_psock_purge_ingress_msg()
                                            -- free ingress_msg list --
                                           spin_unlock(ingress_lock)
           spin_lock(ingress_lock)
           list_add_tail(msg,ingress_msg) <- entry on list with no one
                                             left to free it.
           spin_unlock(ingress_lock)

To fix we only enqueue from backlog if the ENABLED bit is set. The tear
down logic clears the bit with ingress_lock set so we wont enqueue the
msg in the last step.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h | 54 ++++++++++++++++++++++++++++---------------
 net/core/skmsg.c      |  6 -----
 2 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 96f319099744..94b4b61ba775 100644
--- a/include/linux/skmsg.h
+++ b/include/linux/skmsg.h
@@ -285,11 +285,45 @@ static inline struct sk_psock *sk_psock(const struct sock *sk)
 	return rcu_dereference_sk_user_data(sk);
 }
 
+static inline void sk_psock_set_state(struct sk_psock *psock,
+				      enum sk_psock_state_bits bit)
+{
+	set_bit(bit, &psock->state);
+}
+
+static inline void sk_psock_clear_state(struct sk_psock *psock,
+					enum sk_psock_state_bits bit)
+{
+	clear_bit(bit, &psock->state);
+}
+
+static inline bool sk_psock_test_state(const struct sk_psock *psock,
+				       enum sk_psock_state_bits bit)
+{
+	return test_bit(bit, &psock->state);
+}
+
+static void sock_drop(struct sock *sk, struct sk_buff *skb)
+{
+	sk_drops_add(sk, skb);
+	kfree_skb(skb);
+}
+
+static inline void drop_sk_msg(struct sk_psock *psock, struct sk_msg *msg)
+{
+	if (msg->skb)
+		sock_drop(psock->sk, msg->skb);
+	kfree(msg);
+}
+
 static inline void sk_psock_queue_msg(struct sk_psock *psock,
 				      struct sk_msg *msg)
 {
 	spin_lock_bh(&psock->ingress_lock);
-	list_add_tail(&msg->list, &psock->ingress_msg);
+	if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
+		list_add_tail(&msg->list, &psock->ingress_msg);
+	else
+		drop_sk_msg(psock, msg);
 	spin_unlock_bh(&psock->ingress_lock);
 }
 
@@ -406,24 +440,6 @@ static inline void sk_psock_restore_proto(struct sock *sk,
 		psock->psock_update_sk_prot(sk, psock, true);
 }
 
-static inline void sk_psock_set_state(struct sk_psock *psock,
-				      enum sk_psock_state_bits bit)
-{
-	set_bit(bit, &psock->state);
-}
-
-static inline void sk_psock_clear_state(struct sk_psock *psock,
-					enum sk_psock_state_bits bit)
-{
-	clear_bit(bit, &psock->state);
-}
-
-static inline bool sk_psock_test_state(const struct sk_psock *psock,
-				       enum sk_psock_state_bits bit)
-{
-	return test_bit(bit, &psock->state);
-}
-
 static inline struct sk_psock *sk_psock_get(struct sock *sk)
 {
 	struct sk_psock *psock;
diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 036cdb33a94a..2d6249b28928 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -584,12 +584,6 @@ static int sk_psock_handle_skb(struct sk_psock *psock, struct sk_buff *skb,
 	return sk_psock_skb_ingress(psock, skb);
 }
 
-static void sock_drop(struct sock *sk, struct sk_buff *skb)
-{
-	sk_drops_add(sk, skb);
-	kfree_skb(skb);
-}
-
 static void sk_psock_skb_state(struct sk_psock *psock,
 			       struct sk_psock_work_state *state,
 			       struct sk_buff *skb,
-- 
2.25.1

