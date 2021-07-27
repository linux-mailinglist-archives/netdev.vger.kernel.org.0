Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 171713D7A7E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhG0QFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 12:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbhG0QFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:05:44 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E27C061757;
        Tue, 27 Jul 2021 09:05:44 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id 10so12510453ill.10;
        Tue, 27 Jul 2021 09:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IT8W87nTmxnd1xF1raNSrwNIGogZJ+Lgs78HQ0tnAnc=;
        b=DWvC5dwDKkUvnV5V+zPVSI5XNpcE0B0YLJ0pSXpa9wRo6S7LNHADLO5NhZhYo3ttoZ
         PejMTfHpC9V6pKs2IyI9AFvxviqNIPoy0YvWOesf4X58VpRSiZkinrpFm0gLG6BvS3Kt
         TqC6IUMKzIVWjBY45IoBV1x3Vm2kiP1HysSKlOerWkyvuKtMe87RclAoTGgGv6zoAl6Z
         aegu+kxxi9xLpC2o+puAwpyNwo22FJoLrQo5oxnGj27mZ+PtkGRVPRQmjfgAxSXW4Qro
         2uCtUkSaDoGtKzBT9jsW07B+sufJXNI3ESgrwXlMgxJJgx7z+hta4/X3MwSjiWWXoMCV
         fqUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IT8W87nTmxnd1xF1raNSrwNIGogZJ+Lgs78HQ0tnAnc=;
        b=Ueccqxi0Om/AGZtbU8108cDncynRco8CyfV6+jb4RihbCzNetzc5Mb1ZyN+w7ntycB
         cxGMKvuhJJ+Cd0nPADabOj5jYtAGanp9LE+dmPU9uOaaDq3fjdi04rOrTM6Pz7K7ypuf
         3R/mODvCfwmxZT0ojAZheU314cFM/u0ttx+uAB1wmxHFsPKO1n6/6yRFk7O9rIVq94Fr
         5ZSZ1pCnEmT36MnTTL6u5FLmLdIOqZh8EjzobdIJm+5fXXASYC450XRbMt0WpPXeq7lC
         kfLkLk76d1chMe99XOyueUsicooXerY24I8hhNbzBRRkyX5VF4d2r/IAxZCgs+HjqgcV
         gDUg==
X-Gm-Message-State: AOAM533xsO12GAm50iLURMVth2OZRmXintL8fsmLaBqNPynpZ9x3P/Jz
        IxDjBxd8oZxkojCGN+8yd4E=
X-Google-Smtp-Source: ABdhPJyaS+YIYZnQ0y+ddCTs70uKRCPvglwzLLHIuFVKgBdphUvYnmVxaYH/XthxXZhbL+tYE5vUWg==
X-Received: by 2002:a05:6e02:14cc:: with SMTP id o12mr10073230ilk.76.1627401944027;
        Tue, 27 Jul 2021 09:05:44 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id p9sm2028689ilj.65.2021.07.27.09.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 09:05:43 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net,
        xiyou.wangcong@gmail.com, kafai@fb.com,
        alexei.starovoitov@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        john.fastabend@gmail.com
Subject: [PATCH bpf v3 3/3] bpf, sockmap: fix memleak on ingress msg enqueue
Date:   Tue, 27 Jul 2021 09:05:00 -0700
Message-Id: <20210727160500.1713554-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727160500.1713554-1-john.fastabend@gmail.com>
References: <20210727160500.1713554-1-john.fastabend@gmail.com>
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
index 96f319099744..14ab0c0bc924 100644
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
+static inline void sock_drop(struct sock *sk, struct sk_buff *skb)
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

