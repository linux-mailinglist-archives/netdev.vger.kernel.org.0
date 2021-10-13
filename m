Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B7942B7F5
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238094AbhJMGw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233247AbhJMGw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 02:52:56 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18ADFC061570;
        Tue, 12 Oct 2021 23:50:53 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id w19so5882495edd.2;
        Tue, 12 Oct 2021 23:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RYCKTVD13R38t3WR/vos+HLpCIiXFIXTlTL/zxQSSKw=;
        b=SnEw/GhaqO5KlOEO8Hzvk0UBbd1OS83DRJyCeWeH1RscJs+pMIu0dOxxyT6cawkP7t
         sYXtHVWsTnzk5QGYtH0a1GeDmtRC0H0L1hDZOx+c8M+Sl6W36viaG1RXrsan6gIwAQVX
         8S3Wvk9RVqdy1zSWBcABrIqxREbEAk9Zk9S5lZsC7evYe2RNfou5kRV87hnuqOEMeO/y
         X9EympOYFd4ZgH63RnxxqLn+jEklYri7Uj3V/ecrROX2BftFAQ199xF7sWxpCI4xvpJ9
         Z0KBzQhm8ESQHzFtl/f/dY4Al6a/1dO8o0i55n0Mstx7TRKdh4cMntkJmUzOKbZ+zBHh
         xUjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RYCKTVD13R38t3WR/vos+HLpCIiXFIXTlTL/zxQSSKw=;
        b=Am7R8xz4X1Ap6a+NbqUKk4M1UDj1jo1DLjGO/fzqSqfpuLsw3lctfsRYzSfC6o3xwx
         goMBtuf3I8kLE0eyxDms8qstawgM9v8DS+WgNI8SO+TbYXZu3hRM4e9Aq0ZDG40LOLYQ
         nGUUhoUUap40IaW85c2Fi3qFWz1S0903iZGrXjvsMQH+AS2ZmlOJZRX1uoKNTxVpFr2w
         0MRmC3agg97m7TJaan7ojWaM91Lr7F9fxGjpUr0LIjLZ+ASAiWI0D+x7gS9n0ON++v/+
         XajW8DsrkqAcCitP7Leqgyiv2pFUpDAyWvk7CbGYUCNPXeZeO4Kk3+8ltDdScHnE8OsN
         AcRw==
X-Gm-Message-State: AOAM532fRFvYVeFA9xeu1RAfq0c+VCE9Ezc+T74O4q2quDftdvTQFoFK
        DIKMmHpeqd8Q5Qt9XOl8kfI=
X-Google-Smtp-Source: ABdhPJw4Omo9b4Hq97vOhIHDiwGyV/cs39eLeCUzvUb1XQeIZd9/WydchaaorVIjOHJjh4zTM/9uRw==
X-Received: by 2002:a50:e184:: with SMTP id k4mr7047706edl.217.1634107851671;
        Tue, 12 Oct 2021 23:50:51 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:6346:a6a3:f7ea:349e])
        by smtp.gmail.com with ESMTPSA id m15sm4568710edd.5.2021.10.12.23.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 23:50:49 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] tcp: md5: Fix overlap between vrf and non-vrf keys
Date:   Wed, 13 Oct 2021 09:50:35 +0300
Message-Id: <6d99312c4863c37ad394c815f8529ee635bdb0d0.1634107317.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634107317.git.cdleonard@gmail.com>
References: <cover.1634107317.git.cdleonard@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With net.ipv4.tcp_l3mdev_accept=1 it is possible for a listen socket to
accept connection from the same client address in different VRFs. It is
also possible to set different MD5 keys for these clients which differ
only in the tcpm_l3index field.

This appears to work when distinguishing between different VRFs but not
between non-VRF and VRF connections. In particular:

 * tcp_md5_do_lookup_exact will match a non-vrf key against a vrf key.
This means that adding a key with l3index != 0 after a key with l3index
== 0 will cause the earlier key to be deleted. Both keys can be present
if the non-vrf key is added later.
 * _tcp_md5_do_lookup can match a non-vrf key before a vrf key. This
casues failures if the passwords differ.

Fix this by making tcp_md5_do_lookup_exact perform an actual exact
comparison on l3index and by making  __tcp_md5_do_lookup perfer
vrf-bound keys above other considerations like prefixlen.

Fixes: dea53bb80e07 ("tcp: Add l3index to tcp_md5sig_key and md5 functions")
Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
---
 net/ipv4/tcp_ipv4.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 29a57bd159f0..a9a6a6d598c6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1035,10 +1035,24 @@ static void tcp_v4_reqsk_destructor(struct request_sock *req)
  */
 
 DEFINE_STATIC_KEY_FALSE(tcp_md5_needed);
 EXPORT_SYMBOL(tcp_md5_needed);
 
+static bool better_md5_match(struct tcp_md5sig_key *old, struct tcp_md5sig_key *new)
+{
+	if (!old)
+		return true;
+
+	/* l3index always overrides non-l3index */
+	if (old->l3index && new->l3index == 0)
+		return false;
+	if (old->l3index == 0 && new->l3index)
+		return true;
+
+	return old->prefixlen < new->prefixlen;
+}
+
 /* Find the Key structure for an address.  */
 struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 					   const union tcp_md5_addr *addr,
 					   int family)
 {
@@ -1072,12 +1086,11 @@ struct tcp_md5sig_key *__tcp_md5_do_lookup(const struct sock *sk, int l3index,
 #endif
 		} else {
 			match = false;
 		}
 
-		if (match && (!best_match ||
-			      key->prefixlen > best_match->prefixlen))
+		if (match && better_md5_match(best_match, key))
 			best_match = key;
 	}
 	return best_match;
 }
 EXPORT_SYMBOL(__tcp_md5_do_lookup);
@@ -1103,11 +1116,11 @@ static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
 #endif
 	hlist_for_each_entry_rcu(key, &md5sig->head, node,
 				 lockdep_sock_is_held(sk)) {
 		if (key->family != family)
 			continue;
-		if (key->l3index && key->l3index != l3index)
+		if (key->l3index != l3index)
 			continue;
 		if (!memcmp(&key->addr, addr, size) &&
 		    key->prefixlen == prefixlen)
 			return key;
 	}
-- 
2.25.1

