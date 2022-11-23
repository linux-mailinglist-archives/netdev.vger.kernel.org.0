Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF35A636767
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239093AbiKWRj0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbiKWRjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:39:18 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4CE5657A
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:39:11 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso2010937wme.5
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 09:39:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olRr0NxHpe7WEA5OvPe/+zbTbmND6iy3IpcPyCocNn4=;
        b=MGZ7QykbkGij1YHktOvviVyuOHcrM4D71hg6bgmigrwh1aI2PXhTjkh/bhjj80SOLu
         HIfRLgpltd7ZARZGjE8AfzX4m8IsaSfJOMB4KF38mYZKM5amck060zKzxudmYDdpZ+cF
         7sFTyBnqskBT8GbYEpR+TPRglwVIl7YThS7+wOU2BaMr79APWYKsHN3P9KG4x8i1/QqX
         qudcetSody7PYuQhyKZehAViaumz+mkzZgueaiUNLLb5nAMCUDQG3mACdNuZIfOzhYpP
         2f9dk7nWj9UIChiAGAeP7So0MTiWDgUhuep5AMUJYEfeuK6QOimTBM0b32ceKoMp1If+
         kXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=olRr0NxHpe7WEA5OvPe/+zbTbmND6iy3IpcPyCocNn4=;
        b=eBmvUObgxqazYsmg62kl6gVHWRJxzO9Kr+QgyCrCmT5LneBMz8HAhBbHEWIZgP+Sgy
         N1mynBxc8JGjwKy7gI/+EqTUuNER4SbepUHVAG4S/iI2mLT110MKDy9a26JSntQ5XbdE
         uj+BD4dvilGpz3nDpDFAQIx8UcAtAlpnYlef3KFMwkUV12CZVRy0l0pvJ2w4rDiwQDoU
         ebtLWCbHs6LpZKqr1K7vo1oIjnnbioVwMkiUMPWRisayVYyEVlFP3aT8WivlsbuR3K1K
         TULlpGWsuG3ssP/VB1blVtNOuR6x0lkNVRnCxERZi1vPu4RkLIqtls2PQqyHL//2dhDu
         wdZg==
X-Gm-Message-State: ANoB5pkuIzWq5heSipXZY0bQKEDzEAKQNuSWgYyfm9lmrUOw804/H9hj
        lNFvxBA5675nT+uHvZt+QDVciA==
X-Google-Smtp-Source: AA0mqf5ZXb831DoeJ91bgKnU9Kw8Xp3nNPKytEPtbgieWFiQ8KaRRWhshV8qQr+zStcrrQyYDk138g==
X-Received: by 2002:a05:600c:ac1:b0:3c6:d18b:304b with SMTP id c1-20020a05600c0ac100b003c6d18b304bmr9474739wmr.142.1669225149831;
        Wed, 23 Nov 2022 09:39:09 -0800 (PST)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id v10-20020adfe28a000000b0023647841c5bsm17464636wri.60.2022.11.23.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 09:39:09 -0800 (PST)
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
Subject: [PATCH v6 2/5] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Wed, 23 Nov 2022 17:38:56 +0000
Message-Id: <20221123173859.473629-3-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123173859.473629-1-dima@arista.com>
References: <20221123173859.473629-1-dima@arista.com>
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

