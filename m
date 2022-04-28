Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8ACF5131F2
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345219AbiD1LDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345099AbiD1LCu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:02:50 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ACE9F3A1;
        Thu, 28 Apr 2022 03:59:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m62so2713241wme.5;
        Thu, 28 Apr 2022 03:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l7MRQY3AOdXRAcNH/9Z4xyz/tFFAixxWrYfyB94jPJ4=;
        b=bS/Df47ABvzpUrrBEZHO4AEMa9aD0mTGxqbkMhXx7MzhcRrQNxmOM+NvrEUKQnUDJi
         O8ai2W8akt3urkgm46EjCtZ0iAjamuwA65XKJ3fHNis0P0FO5aX+Fx56EAgw2nqe05pq
         ZLSPLTtReqTJ8Y2dYq98LP7tPooOOW204Spk1AW2cn9w5nA34lEO4o9MsqIWGUJWDvvf
         +yreBpuYnbkPwwU9azXNuPXw9E/VPcWVJ/7Z8YjEsTuJ1j1XlDN/ea/mkVwJxxcfbPia
         jqoTzthVPeVsO8SmXj/ksg3/wFT8yvtA83zYIVSbMpqz95V5P9dBskKiHErhN95AvCLv
         Ixzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l7MRQY3AOdXRAcNH/9Z4xyz/tFFAixxWrYfyB94jPJ4=;
        b=orCJX2fGqwO2XFoOuXht0MF1jphXHS3MMdxE72DMRb9HpkmoOCQpS+ueZfgV+taory
         oH0mkKnTkH8jBE7QiTUma0qJtb3uERJp90ykVuVkYG9kUN1wEGpldUnNus2a/+9AWHIU
         TQMzcewoHtev0lDIMidcMhTyCzUnawuiNCAJ/yqd8XmdK2xHxt8Myi/FLtnHBjMChPr5
         txqKPg1/4nBA9AuL+ERgnWihSKjszOy9mKmmcalUTiO8TuUcFNBnpc0R4Y++DEOx3UAq
         SiGip3ji0zAoTJCcg+re9B1A3VaxqWOyF045Sjm5IZY4bLyItxBzEyN8lliHQI0qEBHU
         w25Q==
X-Gm-Message-State: AOAM530MuFRbL2x19s0Y+Qw4FL/bZhdDf1h/ubT5SCb/PRDSD0O6+JbX
        xJPyxC567H2jMySXAzdSV+mpNOb5I6A=
X-Google-Smtp-Source: ABdhPJzh5xPJYIFuTf08eMtuhVLm3V7WRAIwzhlYMGI7mYBUFFcfnO3Wr7ivSW9Vmn9hCxCyyx1znQ==
X-Received: by 2002:a05:600c:48a8:b0:393:ff87:faf0 with SMTP id j40-20020a05600c48a800b00393ff87faf0mr8094114wmp.88.1651143539844;
        Thu, 28 Apr 2022 03:58:59 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id p4-20020a1c5444000000b00391ca5976c8sm4628139wmi.0.2022.04.28.03.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:58:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 3/3] sock: optimise sock_def_write_space barriers
Date:   Thu, 28 Apr 2022 11:58:19 +0100
Message-Id: <654332b3765fa728e1e149523bf7fb59c563a186.1650891417.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650891417.git.asml.silence@gmail.com>
References: <cover.1650891417.git.asml.silence@gmail.com>
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

Now we have a separate path for sock_def_write_space() and can go one
step further. When it's called from sock_wfree() we know that there is a
preceding atomic for putting down ->sk_wmem_alloc. We can use it to
replace to replace smb_mb() with a less expensive
smp_mb__after_atomic(). It also removes an extra RCU read lock/unlock as
a small bonus.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/sock.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 4ad4d6dd940e..85d0b04c7bc5 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -146,6 +146,7 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
+static void sock_def_write_space_wfree(struct sock *sk);
 static void sock_def_write_space(struct sock *sk);
 
 /**
@@ -2329,7 +2330,7 @@ void sock_wfree(struct sk_buff *skb)
 		    sk->sk_write_space == sock_def_write_space) {
 			rcu_read_lock();
 			free = refcount_sub_and_test(len, &sk->sk_wmem_alloc);
-			sock_def_write_space(sk);
+			sock_def_write_space_wfree(sk);
 			rcu_read_unlock();
 			if (unlikely(free))
 				__sk_free(sk);
@@ -3221,6 +3222,29 @@ static void sock_def_write_space(struct sock *sk)
 	rcu_read_unlock();
 }
 
+/* An optimised version of sock_def_write_space(), should only be called
+ * for SOCK_RCU_FREE sockets under RCU read section and after putting
+ * ->sk_wmem_alloc.
+ */
+static void sock_def_write_space_wfree(struct sock *sk)
+{
+	/* Do not wake up a writer until he can make "significant"
+	 * progress.  --DaveM
+	 */
+	if (sock_writeable(sk)) {
+		struct socket_wq *wq = rcu_dereference(sk->sk_wq);
+
+		/* rely on refcount_sub from sock_wfree() */
+		smp_mb__after_atomic();
+		if (wq && waitqueue_active(&wq->wait))
+			wake_up_interruptible_sync_poll(&wq->wait, EPOLLOUT |
+						EPOLLWRNORM | EPOLLWRBAND);
+
+		/* Should agree with poll, otherwise some programs break */
+		sk_wake_async(sk, SOCK_WAKE_SPACE, POLL_OUT);
+	}
+}
+
 static void sock_def_destruct(struct sock *sk)
 {
 }
-- 
2.36.0

