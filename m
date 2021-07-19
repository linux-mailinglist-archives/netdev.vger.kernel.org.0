Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAF73CF036
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 01:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443685AbhGSXE7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 19:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243039AbhGSVTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 17:19:21 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8B69C0613E3;
        Mon, 19 Jul 2021 14:49:15 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id z9so21704706iob.8;
        Mon, 19 Jul 2021 14:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Oe1SKP5YIMosFqeN5ivgaQq1fUhcitjsPyLRfiW25uM=;
        b=aAc7KRItp6RQv4Tk/+D4sxiZR55bYF24kfN2s/eixizGz3jj31OrzGBcAzBMX2uZto
         +/8xO3G6O69EH30T28uaHLe8kk3LeMw0BeArWa1hcihWuP6mi9A7ik/jw60J4C3cjYiu
         at6fnRgFrxqkxfA/TOk8JSRJxGRIBwSyp9QYNjf5xk+FKqzBe3ArbDXJJdNB2r/fbz/3
         Q5vTtGCf9BdgHHGM9Hg+rReiNPjTj6VPu7EQRn71q8IHT1Nii3L2LQY+5BAM++7jpXz5
         77py+gCTEMRxBZRFHvmK23FBB6qIEqSpNuREcBmx/069tTU21iwZdo8lYeb/vO4RyOlC
         sZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Oe1SKP5YIMosFqeN5ivgaQq1fUhcitjsPyLRfiW25uM=;
        b=EQWlisGA12r/B+aVWc2oXQr01xdCgc+3O1y7YDcwLMlOoR7IoJeB734VhxadZhF0ge
         +xOPcxyfSKhb3aSIspYfa7jdSnp9nTCYFGXspMqhOepKha1SS8WpG0blri0uHTyoWC0p
         8cVYFMOP33QCAortlQ/eB7fFPqFbuwOIkgUBKGjqAaex0TV71NW7kOdAHMKyUuPiSBIE
         aMOhEmtVa+R89cYjqYV8B6qam+/dxOAeZayrpdT8MXbf8oqC3y/GtacRng7MuX8vpLGc
         cjX16Hp+WC0DdXK7rCG5xZ0792gSpnTLDnCIueMlkDqLiOZJti97HhKZUO01rZyzXXzt
         RcbQ==
X-Gm-Message-State: AOAM531AKUpqo4rH+urMyw2Th2syNmX+dk8FLRz7uqPzFu28JnXfE9U6
        qZ7trUP9xbtknn15nXIqqdU=
X-Google-Smtp-Source: ABdhPJxN1SSqIuzUGiMMZL7aBZF1LP8up5CTa2MaVakgn2LWSGWPKUqQhnWxhrSHw2GCIV2wHpXMxw==
X-Received: by 2002:a5e:9306:: with SMTP id k6mr21206715iom.157.1626731355460;
        Mon, 19 Jul 2021 14:49:15 -0700 (PDT)
Received: from john-XPS-13-9370.lan ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id d14sm10124758iln.48.2021.07.19.14.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 14:49:15 -0700 (PDT)
From:   John Fastabend <john.fastabend@gmail.com>
To:     jakub@cloudflare.com, daniel@iogearbox.net,
        xiyou.wangcong@gmail.com, alexei.starovoitov@gmail.com
Cc:     john.fastabend@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH bpf 3/3] bpf, sockmap: fix memleak on ingress msg enqueue
Date:   Mon, 19 Jul 2021 14:48:34 -0700
Message-Id: <20210719214834.125484-4-john.fastabend@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210719214834.125484-1-john.fastabend@gmail.com>
References: <20210719214834.125484-1-john.fastabend@gmail.com>
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
           list_add_tail(msg,ingress_msg) <- entry on list with no on
                                             left to free it.
           spin_unlock(ingress_lock)

To fix we only enqueue from backlog if the ENABLED bit is set. The tear
down logic clears the bit with ingress_lock set so we wont enqueue the
msg in the last step.

Fixes: 799aa7f98d53 ("skmsg: Avoid lock_sock() in sk_psock_backlog()")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/skmsg.h | 54 ++++++++++++++++++++++++++++---------------
 net/core/skmsg.c      |  6 -----
 2 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
index 96f319099744..883638888f93 100644
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
+        if (sk_psock_test_state(psock, SK_PSOCK_TX_ENABLED))
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
index 5d956e91d05a..3ee407bed768 100644
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

