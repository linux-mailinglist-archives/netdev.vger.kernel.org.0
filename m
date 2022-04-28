Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E225131EF
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 13:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345227AbiD1LDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 07:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344894AbiD1LCs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 07:02:48 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920AAA1457;
        Thu, 28 Apr 2022 03:58:59 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q23so6255022wra.1;
        Thu, 28 Apr 2022 03:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SrhHhC4OSzNzBDK0GAKFTGso0tFf64ad1cEfyYa4l14=;
        b=n5Tt+aHeTdA3GyiiN/j4yGT4hJ5/W1FWa95Mq1/ALsVVWONE8D4sN5YjHHd2L+3tZb
         H4ZxhqjR0QMmRBYLdKt1w8ZtRTnemQBlUH/xvgzJwghSgRAe2fLHRrDdEKf8A+SlPQHF
         IrwcTGZz9/d5OlFC8hFXswRdcoNFmp5Q9QXliD69zK+wZ9wDf+LXzGcF4aBGZnKxZ57V
         A+/YTcdPA9oE5laLAe8xn84zD0ygX4tFvloUaHuCzTVV+kIVSEL9lb2jthVffx60svD+
         hG7KTrvWLie36ioh3tuQjDRNCkGcyOG5U8hf8f8gHmnnQuFCGfWu7ne+66imaUAH8rVL
         obRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SrhHhC4OSzNzBDK0GAKFTGso0tFf64ad1cEfyYa4l14=;
        b=wEdZEzD4uts4SCN2pqRwHRJmrZxQYCmdZwjxE7Zj4B5/ONIzx0U0CqFsyn1Zfy5REX
         Xg16QoeQuumfi4OdgwuRWZUXiX6owbPPTFEfbe7pyMpBGdWUxZXfgEG8JnhDPUtOI9vV
         lyvcdhEqV57jvgPGBOVnewbfnIXtHlnqOw+8RxiA9SFXvAr9RJ++H+fCB5EYwDEpRwHQ
         sIn3n8047tnJbjTu/AZrb1wvtFZzC3hxi1OqWgRJw1C/9g5KQXdCSgEMp+z24HHuSJoq
         DBgHOfubkeWM4h7wkCEcsagvqeS38mbimbunHxP0z7YCt8iRCFIEnz9yYEtA9QAvOpYH
         Oi+Q==
X-Gm-Message-State: AOAM533zrvCGoMLL2lM5scEtw4skiNKZ+FpydDazuXyMJYbtg1pv5daS
        euk4cx8A7qZDopXVPNviP+WwYQaB77A=
X-Google-Smtp-Source: ABdhPJzxkVXH4VMZUgFhULZAk+43zKGd1vXLm+7Vk9zs4sqRwQ80/Es+zJXS1CjGvGHsNFmPWX3RIg==
X-Received: by 2002:a5d:64a3:0:b0:20a:ef5c:adfe with SMTP id m3-20020a5d64a3000000b0020aef5cadfemr6316488wrp.146.1651143537984;
        Thu, 28 Apr 2022 03:58:57 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-8.dab.02.net. [82.132.230.8])
        by smtp.gmail.com with ESMTPSA id p4-20020a1c5444000000b00391ca5976c8sm4628139wmi.0.2022.04.28.03.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 03:58:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next 2/3] sock: optimise UDP sock_wfree() refcounting
Date:   Thu, 28 Apr 2022 11:58:18 +0100
Message-Id: <8b7878e1f57af29e4a693c588d3a0cc70dcf5003.1650891417.git.asml.silence@gmail.com>
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

For non SOCK_USE_WRITE_QUEUE sockets, sock_wfree() (atomically) puts
->sk_wmem_alloc twice. It's needed to keep the socket alive while
calling ->sk_write_space() after the first put.

However, some sockets, such as UDP, are freed by RCU
(i.e. SOCK_RCU_FREE) and use already RCU-safe sock_def_write_space().
Carve a fast path for such sockets, put down all refs in one go before
calling sock_def_write_space() but guard the socket from being freed
by an RCU read section.

note: because TCP sockets are marked with SOCK_USE_WRITE_QUEUE it
doesn't add extra checks in its path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/core/sock.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 976ff871969e..4ad4d6dd940e 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -146,6 +146,8 @@
 static DEFINE_MUTEX(proto_list_mutex);
 static LIST_HEAD(proto_list);
 
+static void sock_def_write_space(struct sock *sk);
+
 /**
  * sk_ns_capable - General socket capability test
  * @sk: Socket to use a capability on or through
@@ -2320,8 +2322,20 @@ void sock_wfree(struct sk_buff *skb)
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
2.36.0

