Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFFB763440D
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 19:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234627AbiKVSzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 13:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiKVSzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 13:55:46 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEFF7EBD5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:46 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id t4so11390326wmj.5
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 10:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olRr0NxHpe7WEA5OvPe/+zbTbmND6iy3IpcPyCocNn4=;
        b=XDyTerCb8EVV6AoUL3AxZE7MLj0YRCgmrGvU9upIGo6MXa8PHKk/Eo5mbUQCOr67yV
         F55ZLJdSshWxSeRO3TvWT2gJp+xiXb71JMxc5NHC/6tZLiGbTmvCTGtIxlD1U5tSk+2B
         DUT4rN0P5GV4GZ5xcGwBkx2Usf7rsSEekk5roNt4hlmuSJ46fVcW3YKiAc2oykxhPdWQ
         e8POFl3V8hRLsJtxmGiyU5VQRN1vrwQSFdzIYdtd6OOR3fWd00MGjOOJEqg1wgaNJWec
         YQ80VxJrvOkF7zu1SU54jP3Mdq9F4+acG+jCQBr57pBv/Vo8rcfj9ocnQljcXIwlLbvw
         DEOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=olRr0NxHpe7WEA5OvPe/+zbTbmND6iy3IpcPyCocNn4=;
        b=4gU1rScJ4E76l7yfoIplieotjpB/u5B/KIL99dX9sXPX78H9/1hYJZ5dkE6Sdxl/LB
         TvoY4W0EdvMfZsf7aNXr/DDW87BW1xOLDmry+ejdZSwNAU04Mu3nitM7suiQrIhO8AXS
         4OeYR3LziRXha81TYCtDVEJZnrxWy0evCGGXei7e+CB1IBG1Bv1TnnittrgcyU4m1WNm
         k7X726ZV2/gA2LqU3KtUph6Y/QMEXj7ZtUZilVWPRPmfW+uY9ArJZLKm00ZLVNgO24z5
         7Fk4T6L0jh/JMzOeAvVhsBhE3cBWo2jy+WAVkEItvPmHw4nztZYqwu1PS7nP/mTRzeDM
         i6Pw==
X-Gm-Message-State: ANoB5pn57aHhZT7zbe2GohptVtWYFad8bU3w7j4h7KKUSV5MmHipKuuy
        5kIjZSA0JbwM4BJpEwpq4AM7sQ==
X-Google-Smtp-Source: AA0mqf79PKvGbOF/tQ/G6OyTaH6xguh1xaQVj8z/yXj3fo+32O5rhTgAeCKHWUYyLB29XaV4o2JI6w==
X-Received: by 2002:a05:600c:3d08:b0:3cf:e84d:6010 with SMTP id bh8-20020a05600c3d0800b003cfe84d6010mr8195465wmb.197.1669143344628;
        Tue, 22 Nov 2022 10:55:44 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id c18-20020adffb12000000b002365730eae8sm14478044wrr.55.2022.11.22.10.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 10:55:44 -0800 (PST)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     Dmitry Safonov <dima@arista.com>, Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: [PATCH v5 2/5] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Tue, 22 Nov 2022 18:55:31 +0000
Message-Id: <20221122185534.308643-3-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221122185534.308643-1-dima@arista.com>
References: <20221122185534.308643-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to allocate tcp_md5sig_info, that will help later to
do/allocate things when info allocated, once per socket.

Signed-off-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index f0343538d1f8..2d76d50b8ae8 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1172,6 +1172,24 @@ struct tcp_md5sig_key *tcp_v4_md5_lookup(const struct sock *sk,
 }
 EXPORT_SYMBOL(tcp_v4_md5_lookup);
 
+static int tcp_md5sig_info_add(struct sock *sk, gfp_t gfp)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+	struct tcp_md5sig_info *md5sig;
+
+	if (rcu_dereference_protected(tp->md5sig_info, lockdep_sock_is_held(sk)))
+		return 0;
+
+	md5sig = kmalloc(sizeof(*md5sig), gfp);
+	if (!md5sig)
+		return -ENOMEM;
+
+	sk_gso_disable(sk);
+	INIT_HLIST_HEAD(&md5sig->head);
+	rcu_assign_pointer(tp->md5sig_info, md5sig);
+	return 0;
+}
+
 /* This can be called on a newly created socket, from other files */
 int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		   int family, u8 prefixlen, int l3index, u8 flags,
@@ -1202,17 +1220,11 @@ int tcp_md5_do_add(struct sock *sk, const union tcp_md5_addr *addr,
 		return 0;
 	}
 
+	if (tcp_md5sig_info_add(sk, gfp))
+		return -ENOMEM;
+
 	md5sig = rcu_dereference_protected(tp->md5sig_info,
 					   lockdep_sock_is_held(sk));
-	if (!md5sig) {
-		md5sig = kmalloc(sizeof(*md5sig), gfp);
-		if (!md5sig)
-			return -ENOMEM;
-
-		sk_gso_disable(sk);
-		INIT_HLIST_HEAD(&md5sig->head);
-		rcu_assign_pointer(tp->md5sig_info, md5sig);
-	}
 
 	key = sock_kmalloc(sk, sizeof(*key), gfp | __GFP_ZERO);
 	if (!key)
-- 
2.38.1

