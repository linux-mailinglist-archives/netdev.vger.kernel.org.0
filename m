Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463E5551538
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 12:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240756AbiFTKFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 06:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240916AbiFTKFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 06:05:18 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC7A23B5
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 03:05:13 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id w6so2612100pfw.5
        for <netdev@vger.kernel.org>; Mon, 20 Jun 2022 03:05:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KasjhJppKUKQgIcHdKRWFl/wWcQF/YU/pt/hl/7I538=;
        b=Wnf8Ze4GPM8D2q7NRM78cM+a8s9+xfFCR8BGiTaao7MhDmQRtMiaDtXQkzVFXyoO+R
         l/5o0qwVpqXghNmFL6c8DB8QfUUObE6Fhp/FUFDViStvhOoP0jfDGmGdYeNn3FmV0Lfh
         i8814FQPRdzoQ8AGGU3iU1YZE5PmA5Oe6Kmz1rJ1SOMoMqutdyKlc8CM4WxbWKr9V8Z+
         N5JxIaIeekfDRvSn81l44yvno9QUxGXHbSK5FTSAHSyPfCWXiHUAzc4ervxwiFUfXp2z
         V0ZHW8QWVC2nUJn/GzI7nbu24SarpUjTFgnQSqZId5qS78V5UJmmc36LqjeE19xo1Ag6
         2oIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KasjhJppKUKQgIcHdKRWFl/wWcQF/YU/pt/hl/7I538=;
        b=EW5GeaAC8bI3qvl65nTR2rObzTncwsWIJ7W7hsC5hotcvDLyIO/NZVBbJD2J2eI9xV
         qNp6ogwE2xbqUTrNCENAhtBlgBuqP+6zefFuuEuiNHiXbhUu3rtl49MCcuAKP0FkUgZU
         qpGgXgaw6Bv5VP+FHpzHZSB2q04mU1FRNXweBUVypmBrLnDeOnI0QorecXD9aFqKRChi
         pHCrgJ0RakOk2CSuv+OR+Ow2SMscVPfF0SfQPGc1KZuNlImS0LtXBAhMlHbbKi5ncmg2
         JltKiuEG1JovRMOzwYq1d4XRDTICGChC4F9G4IZnQKCTQnUpLXdOxeeq6APZYqmrUqJE
         LX5A==
X-Gm-Message-State: AJIora9Ot1mMpNEoOF3IWLvW4gcM8g4uxPYJ2QC1I8juoRXJWiXloTtY
        d0Y9M2nzMpmiL3JVqe9hHs8=
X-Google-Smtp-Source: AGRyM1uNWIXX/DMhKIihLI96TgdNPKpTZK90lCfmwXtDWSeZeMnnsqSq/E1qqU/b4s79W+K/tXR8pw==
X-Received: by 2002:a05:6a00:c88:b0:51c:1001:65f9 with SMTP id a8-20020a056a000c8800b0051c100165f9mr23498665pfv.66.1655719513155;
        Mon, 20 Jun 2022 03:05:13 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:394d:a9d5:3c7b:868e])
        by smtp.gmail.com with ESMTPSA id j3-20020a170903024300b001624965d83bsm8276854plh.228.2022.06.20.03.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 03:05:12 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next] raw: complete rcu conversion
Date:   Mon, 20 Jun 2022 03:05:09 -0700
Message-Id: <20220620100509.3493504-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
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

From: Eric Dumazet <edumazet@google.com>

raw_diag_dump() can use rcu_read_lock() instead of read_lock()

Now the hashinfo lock is only used from process context,
in write mode only, we can convert it to a spinlock,
and we do not need to block BH anymore.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/raw.h   | 4 ++--
 net/ipv4/raw.c      | 8 ++++----
 net/ipv4/raw_diag.c | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/raw.h b/include/net/raw.h
index d81eeeb8f1e6790c398eaa7cb9921f7387b2afcf..d224376360e11c838f02a84595f7040a8a3f4bb0 100644
--- a/include/net/raw.h
+++ b/include/net/raw.h
@@ -32,7 +32,7 @@ int raw_rcv(struct sock *, struct sk_buff *);
 #define RAW_HTABLE_SIZE	MAX_INET_PROTOS
 
 struct raw_hashinfo {
-	rwlock_t lock;
+	spinlock_t lock;
 	struct hlist_nulls_head ht[RAW_HTABLE_SIZE];
 };
 
@@ -40,7 +40,7 @@ static inline void raw_hashinfo_init(struct raw_hashinfo *hashinfo)
 {
 	int i;
 
-	rwlock_init(&hashinfo->lock);
+	spin_lock_init(&hashinfo->lock);
 	for (i = 0; i < RAW_HTABLE_SIZE; i++)
 		INIT_HLIST_NULLS_HEAD(&hashinfo->ht[i], i);
 }
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 959bea12dc484258d372c039800d29e81b7ea18b..027389969915e456b0009e2a0b4ad81afb836e9d 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -95,10 +95,10 @@ int raw_hash_sk(struct sock *sk)
 
 	hlist = &h->ht[inet_sk(sk)->inet_num & (RAW_HTABLE_SIZE - 1)];
 
-	write_lock_bh(&h->lock);
+	spin_lock(&h->lock);
 	__sk_nulls_add_node_rcu(sk, hlist);
 	sock_set_flag(sk, SOCK_RCU_FREE);
-	write_unlock_bh(&h->lock);
+	spin_unlock(&h->lock);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 
 	return 0;
@@ -109,10 +109,10 @@ void raw_unhash_sk(struct sock *sk)
 {
 	struct raw_hashinfo *h = sk->sk_prot->h.raw_hash;
 
-	write_lock_bh(&h->lock);
+	spin_lock(&h->lock);
 	if (__sk_nulls_del_node_init_rcu(sk))
 		sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
-	write_unlock_bh(&h->lock);
+	spin_unlock(&h->lock);
 }
 EXPORT_SYMBOL_GPL(raw_unhash_sk);
 
diff --git a/net/ipv4/raw_diag.c b/net/ipv4/raw_diag.c
index ac4b6525d3c67bd44fbf8f56d05279a9fa6acf16..999321834b94a8f7f2a4996575b7cfaafb6fa2b7 100644
--- a/net/ipv4/raw_diag.c
+++ b/net/ipv4/raw_diag.c
@@ -156,7 +156,7 @@ static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	s_slot = cb->args[0];
 	num = s_num = cb->args[1];
 
-	read_lock(&hashinfo->lock);
+	rcu_read_lock();
 	for (slot = s_slot; slot < RAW_HTABLE_SIZE; s_num = 0, slot++) {
 		num = 0;
 
@@ -184,7 +184,7 @@ static void raw_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 	}
 
 out_unlock:
-	read_unlock(&hashinfo->lock);
+	rcu_read_unlock();
 
 	cb->args[0] = slot;
 	cb->args[1] = num;
-- 
2.36.1.476.g0c4daa206d-goog

