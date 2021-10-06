Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B696424525
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 19:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238424AbhJFRuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 13:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbhJFRuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 13:50:50 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4A16C061746;
        Wed,  6 Oct 2021 10:48:57 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id r18so12916513edv.12;
        Wed, 06 Oct 2021 10:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+bvluinKsgnt8SdPjCe1xgt0c7uhHIR0hYS5LPAxuM8=;
        b=OnbcshcxL2Xh7+GyBnpHqlFALpCN3p9lb3bUhPCbA7jKvqS3lASuCSWVCd8hIcagiL
         0YNA4o0+nvDBAVHoWS7xZgcJ3tcuVnm/Qgi8jj0IPdrSh2k0GFKE/geDvcb6I/oNnzWI
         OYjhpqrnIFEXgHkwkDtgiWLNVzfHFtu5/1cGNLo9BebFvdAfXo87cpVpyxdDweXFpT4q
         dQnJV6GMwkmC7uSpW4qHh/iEdAp0BJuSz8TuAQOfLY+/SSCcFf45YIyuhnqmenSFOfHy
         KllnF67/DbHKmygJZ0DXrt3GmuWMcEuFSZCmxQ+uLWUeBH/A1Qe5US6VrwKym89NLFzj
         OIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+bvluinKsgnt8SdPjCe1xgt0c7uhHIR0hYS5LPAxuM8=;
        b=JO4b/kIpZIvbC5jlj/QN3PAxMFdCIE6Uvo3NxTzTN/ajSmDLjAH540sjcWi40tblO4
         WJxuliUd4BzMCuguA3Cz4y7+Rc1RPbLUJ9S1EtPpaZR5FcTXMZopFjzrL4FhnIamCG8c
         Wm5EgZUumzLSzMoX1G5vjLG3bGYm5k/T1mrGdDDTUM3gQc1/3w6BAlswmvGvZFqNcA4b
         q0UjzEvMLRMPYqdM5Q/QoLFnkIvMEpWwbNDGR9r717ZM9BqaZfy9TM+ZGRozum7ZimS+
         07Yznk3RMoyaEGHuom6GC+2z/b5mYl+i96HGPwkhedrTeQdgFjMVGIYzQm4MV+AEZRZh
         eXBg==
X-Gm-Message-State: AOAM533HwnnU1fJCeb/S9rrK88C+IeJo0H/3K1bGw01T130fs9NclIu+
        97je2KDLpeJ/MIS3n9JrM4E=
X-Google-Smtp-Source: ABdhPJwo+ossLbDaruK65mWBQdsaGLvTRLeFeX6YzYcPee3PZPkXWBSW+L/FF2qp/H2C9eBopYLGvQ==
X-Received: by 2002:a17:906:318b:: with SMTP id 11mr35370639ejy.493.1633542535971;
        Wed, 06 Oct 2021 10:48:55 -0700 (PDT)
Received: from ponky.lan ([2a04:241e:501:3870:42b8:ea57:99f8:734b])
        by smtp.gmail.com with ESMTPSA id ck9sm2094815ejb.56.2021.10.06.10.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 10:48:54 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tcp: md5: Fix overlap between vrf and non-vrf keys
Date:   Wed,  6 Oct 2021 20:48:42 +0300
Message-Id: <3d8387d499f053dba5cd9184c0f7b8445c4470c6.1633542093.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With net.ipv4.tcp_l3mdev_accept=1 it is possible for a listen socket to
accept connection from the same client address in different VRFs. It is
also possible to set different MD5 keys for these clients which
different only in the tcpm_l3index field.

This appears to work when distinguishing between different VRFs but not
between non-VRF and VRF connections. In particular:

 * tcp_md5_do_lookup_exact will match a non-vrf key against a vrf key.
This means that adding a key with l3index != 0 after a key with l3index
== 0 will cause the earlier key to be deleted. Both keys can be present
if the non-vrf key is added later.
 * _tcp_md5_do_lookup can match a non-vrf key before a vrf key. This
casues failures if the passwords differ.

This was found while working on TCP-AO tests, the exact failing tests
are among test_vrf_overlap*_md5 from this file:
https://github.com/cdleonard/tcp-authopt-test/blob/main/tcp_authopt_test/test_vrf_bind.py

There is also a test for overlapping between vrfs
(test_vrf_overlap12_md5) and that works correctly without this change.

Reproducing this with nettest and fcnal-test.sh would require support
for multiple keys inside the nettest server.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>

---
 net/ipv4/tcp_ipv4.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

The fact that keys with l3index==0 affect VRF connections might not be
desirable at all. It might make more sense to have an option to completely
ignore keys outside the vrf for connections inside the VRF.

At least this patch makes it behave in a well defined manner that doesn't
depend on the order of key addition.

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

base-commit: 9cbfc51af026f5b721a1b36cf622ada591b3c5de
-- 
2.25.1

