Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EAC6BD3EE
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 16:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbjCPPgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 11:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjCPPgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 11:36:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D62AE2531
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:45 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id l84-20020a252557000000b00b61b96282a4so319671ybl.0
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 08:33:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678980736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UmOgXO+nSySCaj0+E/a6d02vxdvrD/cEi4HC5nbovbc=;
        b=ninT8o4fRLjVKivC7eOHJVa+HPT/ba1QqDK7t7wB3vJ9/UihCw9v8er2CHJIxiB9Yv
         wb3WeSqvKZl5nu6lnR1jcoenxt9JaqzyQ0/X+seTfrc0aTtnT28jhZJRHtMMNAqmWjVP
         yKUOUIhJamsKtaN5Acr/NIf60rmI1F+JNeWeVy4xd/iCYjodHerEtK+fT18Sqp2s6bbb
         QIsiI9K/Lse2tEz6xkeqANgjUUIvTsxmfz4wY42nzAM4pziZPbYkG0vid969jC8PzCMp
         zXbT5i20Xgq965BSR471bAx6Ipi8NncuwlKihK6ERv67SpsYLSylgimJocp9/GkMnuWN
         LF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678980736;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UmOgXO+nSySCaj0+E/a6d02vxdvrD/cEi4HC5nbovbc=;
        b=h3rTd5i1ULx7e1KPwDpSdqcYZCwoK4pc2TLFkJOIXIBi+aBjciEMjnUNnnbchGqcO3
         Tsqq4XFar7SkVU7ltwydeX3qN20nOj2+0BPfu7MjR6+N5DA0jlTnk8ENmICtcyXbZN55
         poULGwOrxQNYlBUHlI5Po+lK4b+T9JytMZWGucQjY6oqx8ueGKI741sUeNFB92hmNN0u
         7NO1SqiHmESPJC8M9iacpyc4f4m8TughAdJNwuICslf0m07XB61LiQDVobUy8wqbMqwO
         hg9cN9Bpok/ssDtfhwPYCAWOh1BGgxBvQlpwtJby0wsx1/RrMoBnBzImBh0J2qVLBHXi
         9sqg==
X-Gm-Message-State: AO0yUKU4M5JyiJB1Ozzbo70lGgPwve5dq0yTA/uWcqEi3yV6XfGKZGuW
        MP1RHVN1p/V8SQIXe2+BhQHAgT41j8ks7g==
X-Google-Smtp-Source: AK7set/BhMGmmiqkb4+PgaqXmHJ7/VOPM1/jxQC41En9+tk50S75dCHeuAWpVFdGGqkpvFZrCDtmeR5wOuUCJA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:b284:0:b0:533:99bb:c296 with SMTP id
 q126-20020a81b284000000b0053399bbc296mr2408893ywh.5.1678980735897; Thu, 16
 Mar 2023 08:32:15 -0700 (PDT)
Date:   Thu, 16 Mar 2023 15:32:01 +0000
In-Reply-To: <20230316153202.1354692-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230316153202.1354692-1-edumazet@google.com>
X-Mailer: git-send-email 2.40.0.rc2.332.ga46443480c-goog
Message-ID: <20230316153202.1354692-8-edumazet@google.com>
Subject: [PATCH v2 net-next 7/8] ipv4: raw: constify raw_v4_match() socket argument
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Simon Horman <simon.horman@corigine.com>,
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

This clarifies raw_v4_match() intent.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/raw.h | 2 +-
 net/ipv4/raw.c    | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index 2c004c20ed996d1dbe07f2c8d25edd2ce03cca03..7ad15830cf38460f1fae3a187986d74faef6dd1d 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -22,7 +22,7 @@
 extern struct proto raw_prot;
 
 extern struct raw_hashinfo raw_v4_hashinfo;
-bool raw_v4_match(struct net *net, struct sock *sk, unsigned short num,
+bool raw_v4_match(struct net *net, const struct sock *sk, unsigned short num,
 		  __be32 raddr, __be32 laddr, int dif, int sdif);
 
 int raw_abort(struct sock *sk, int err);
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 94df935ee0c5a83a4b1393653b79ac6060b4f12a..3cf68695b40ddc0e79c8fbd62f317048cf5c88e3 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -116,10 +116,10 @@ void raw_unhash_sk(struct sock *sk)
 }
 EXPORT_SYMBOL_GPL(raw_unhash_sk);
 
-bool raw_v4_match(struct net *net, struct sock *sk, unsigned short num,
+bool raw_v4_match(struct net *net, const struct sock *sk, unsigned short num,
 		  __be32 raddr, __be32 laddr, int dif, int sdif)
 {
-	struct inet_sock *inet = inet_sk(sk);
+	const struct inet_sock *inet = inet_sk(sk);
 
 	if (net_eq(sock_net(sk), net) && inet->inet_num == num	&&
 	    !(inet->inet_daddr && inet->inet_daddr != raddr) 	&&
-- 
2.40.0.rc2.332.ga46443480c-goog

