Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365D34F0997
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 15:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiDCNKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 09:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235242AbiDCNKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 09:10:10 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16CD527154
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 06:08:14 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id p189so4336364wmp.3
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 06:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4tX9kkoFz5yjBrZACb+aZ/fkC3N1J9HdMrLaUNmfdJg=;
        b=f5aCWOX9MkjJiRsUA8aaJF86pIMSGy4B0KfIjEDZHD9mrZyIejY7r2md7eca/VIlbs
         0k9eOwj0fq8bZ5rM6jypCSgrft78WddDd+qQQdfb2btzE+iKUz0wORGhlzAuscE8Qsym
         h4HGtgm7JmPwGYsxb5iKmiV2XXnJ4z5v/lLPkrHkbV2BF/5cJAMZWhEUghrnkm3A2c1P
         RRzMkHG0XUviSY5tJFRISKkc7vIPL8zJ7AR++XAf8Pq/qMHUwbYCQz3vOFXAS/fU9iMR
         rnEq2pjyLCXPHWRdzZHO5aFgsKtW5O9Ypkc6991RB/qhO/bv62JqPf04qjBD6ikKaUW/
         Vohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4tX9kkoFz5yjBrZACb+aZ/fkC3N1J9HdMrLaUNmfdJg=;
        b=nI0GPaYjXTEBSDRENXpQQUmbagRHbdbm/RHHD3Kx0V36bo47L0q6S1c2jb1TvRw5Nf
         udVE4gna87sjGiIe89Xf93ebw+yM2Pds6t0MuOLIqbMb211PB0cX8CJO3CgUdiDKIKfB
         IUy8UeWbr4GFN6bmWFgM7PTxOZRaBjEHQlP8HT83sdR6a/fpiy+bRusf+BOKKUpWYwpQ
         GsN+lakNX4Myw94i1LEGFheCkndbJ/iHDFlGkUFTnVrweVzNOEGJX81CFmTqGmPnaWv7
         d6xKWKdU5vmtYk4DeweKyWOK2Pm8n9Ve9aXQ0wCmfyXgcGBJVTUhbTEASmO7mnQPuT5J
         MUIA==
X-Gm-Message-State: AOAM5308y8nS7AuA7R3Z/HfSEb9R20UgK/cc8xG0Idu16XkfeuIgWc9F
        tIfI2i7sBQ3tkCFJLo12OUzrIsRlH5Y=
X-Google-Smtp-Source: ABdhPJwjDkK/x/u2DToX7rJmhd65hMehjkMAhhYq2Wi3UYTyrohJ3jpablwHmOMmVERtWJWTOVtMhA==
X-Received: by 2002:a05:600c:4f86:b0:38c:bd13:e074 with SMTP id n6-20020a05600c4f8600b0038cbd13e074mr15857864wmq.97.1648991292461;
        Sun, 03 Apr 2022 06:08:12 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-233-133.dab.02.net. [82.132.233.133])
        by smtp.gmail.com with ESMTPSA id c12-20020a05600c0a4c00b00381141f4967sm7866995wmq.35.2022.04.03.06.08.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 06:08:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 02/27] sock: optimise sock_def_write_space send refcounting
Date:   Sun,  3 Apr 2022 14:06:14 +0100
Message-Id: <769468f1e09dc13caefaa5cebc3ed1e04f747bcc.1648981570.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648981570.git.asml.silence@gmail.com>
References: <cover.1648981570.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

sock_def_write_space() is extensively used by UDP and there is some
room for optimisation. When sock_wfree() needs to do ->sk_write_space(),
it modifies ->sk_wmem_alloc in two steps. First, it puts all but one
refs and calls ->sk_write_space(), and then puts down remaining 1.
That's needed because the callback relies on ->sk_wmem_alloc being
subbed but something should hold the socket alive.

The idea behind this patch is to take advantage of SOCK_RCU_FREE and
ensure the socket is not freed by wrapping ->sk_write_space() in an RCU
section. Then we can remove one extra refcount atomic.

Note: not all callbacks might be RCU prepared, so we carve out a
sock_def_write_space() specific path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/sock.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index f5766d6e27cb..9389bb602c64 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -144,6 +144,8 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
+static void sock_def_write_space(struct sock *sk);
+
 /**
  * sk_ns_capable - General socket capability test
  * @sk: Socket to use a capability on or through
@@ -2300,8 +2302,20 @@ void sock_wfree(struct sk_buff *skb)
 {
 	struct sock *sk = skb->sk;
 	unsigned int len = skb->truesize;
+	bool free;
 
 	if (!sock_flag(sk, SOCK_USE_WRITE_QUEUE)) {
+		if (sock_flag(sk, SOCK_RCU_FREE) &&
+		    sk->sk_write_space == sock_def_write_space) {
+			rcu_read_lock();
+			free = refcount_sub_and_test(len, &sk->sk_wmem_alloc);
+			sock_def_write_space(sk);
+			rcu_read_unlock();
+			if (unlikely(free))
+				__sk_free(sk);
+			return;
+		}
+
 		/*
 		 * Keep a reference on sk_wmem_alloc, this will be released
 		 * after sk_write_space() call
-- 
2.35.1

