Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0ACD42EA0E
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 09:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233389AbhJOH3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 03:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235990AbhJOH27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 03:28:59 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B9BC061570;
        Fri, 15 Oct 2021 00:26:53 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 5so4520194edw.7;
        Fri, 15 Oct 2021 00:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DhHz8eH8N2xPyxOD62X+So2Azq25vjiSqD7wX9RfBH8=;
        b=oyqr0HIZJDSM8ya0EVRJWZaEtfJf+S38v9KEsYykCHcoVWo3W2LQHmlEXUJ63d6PuD
         Onm8MfIe3l/0lnj5V+gpqAr2tkRKHgB3piXeHycCu2xsuhjC9ZHgW/X5NMNZr8Xcz7l2
         7rF7AzyS2lLnD/oUlRFov6lJtOvLp5SpxyXLHwfZwnVMtw5C2MllfYw2nnayIFavAhru
         BhofPOKWQop/B9v7wqpkRRdClQdL45x9xdHBFcFNeTKw4qN/Cx4ZSgPSJ57jGry5tdbi
         ke9QKXLXEWxEBQMbVOr7nxiz5EdKis/v8t1zpnBud1Fz1dG96OZj0o9FwxI/ouGeInrm
         bHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DhHz8eH8N2xPyxOD62X+So2Azq25vjiSqD7wX9RfBH8=;
        b=LwRTLxnBYordyjzxn/Moylei9bZ0YNSdg4xyo5VxPmS/FDxybKPBSsRzgs4sIrDj7j
         X1ym3hSYYGkIxogeBwlYjcS7HpVjDEVmQQImZKwALxYu0qcbF6GAzOpdOIBX3cvdDvqA
         f5Hxww9k0xPLJP2IjoW8mu3mDN+o6keKpTlETyzoFHkqFS1CAjtvsVSqglNOADv93qgt
         Ib4EPYbixLnd8fDm12rS8QsbV+oa6zGx2k7nxQzayKzkAQLp1mZGzYDr2dFsPD8+v0ls
         7DU/ndjh/U6PcgsAEY2c0u+e8llhx7pTHS64u3tYd1aOqfRVUNSt/agQJzoVq4VlG4Y5
         /tHA==
X-Gm-Message-State: AOAM530gnQUpUho1GyejH9SUxuRcepNdGLwWIdo8an8L0s1QTJZ3z61t
        NmZFnsNk+dBr/AK/L1D0ao0=
X-Google-Smtp-Source: ABdhPJxWCNBBlTt3rX6Gr+axUFVIsuJzKQtGCSUhuqAtmJ5TJjb3MDo+xl7FDvAsH4zPjfJHa6Y2rQ==
X-Received: by 2002:a05:6402:1778:: with SMTP id da24mr15349517edb.318.1634282811780;
        Fri, 15 Oct 2021 00:26:51 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:bac1:743:3859:80df])
        by smtp.gmail.com with ESMTPSA id l25sm3873107edc.31.2021.10.15.00.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 00:26:51 -0700 (PDT)
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
Subject: [PATCH v3 1/4] tcp: md5: Fix overlap between vrf and non-vrf keys
Date:   Fri, 15 Oct 2021 10:26:04 +0300
Message-Id: <4b574659c7a3bcf2a2d3821acf1cf14c1cea3c61.1634282515.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1634282515.git.cdleonard@gmail.com>
References: <cover.1634282515.git.cdleonard@gmail.com>
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
Reviewed-by: David Ahern <dsahern@kernel.org>
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

