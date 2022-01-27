Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7F849D6D1
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233952AbiA0Agt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiA0Agn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:43 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848DDC061749;
        Wed, 26 Jan 2022 16:36:42 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id p12so1391968edq.9;
        Wed, 26 Jan 2022 16:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Owvd8F/4d0c7x5po9puWXUYvkgw1reQHYkIouzUNwg8=;
        b=MkuJbGgjL1dT1EY2gDe0pRvIOCi2WqXM1ttb2U8n8dkpQbkjk37m23aqjOmyCy0DuH
         MwmVIClLw6NU38AOLggaW/wiGjwr3QVKrTXNx00NjO5F0596PsLq3fDms6mxXp219ltd
         WIcWB2G7Bxuf5AKoOj7JSe6TBi6SWFVH3idkjWnyR64a5FpHVc6AVMqdVsYpGWi7zxIc
         8pRWD8ea8fxb7eVZ0cqcTU2IWC84qzhJ1Kd5LJ0VIH1NcuVNfV5epq9lLbOmiREaLq+5
         KGCuRiGRTaN6oUpYFWYS3RbCcjLQVUJ0Zazh9NvQ7LwOE95PzniPddLPWw4Szl4U0QY9
         Mwpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Owvd8F/4d0c7x5po9puWXUYvkgw1reQHYkIouzUNwg8=;
        b=i67QmQh8vJapyLBbxky3K2vtVs3c7g1KZf59Si5VDjQvnVqKBycyXhxSf41bQT5zxG
         pFJLSMkrKIUccahMtQ30bfu1nyWgU3HN4qTbnlOdXj+USHUcqO6E1uxAcSxGPbElUJq9
         OtCzFPQ+LAPemTyd0t0w3+x9jjY8mD1QaLNhGLpLTYv3zxjE6t2ng2E1TVMqw9Ey2t/r
         uo2QQYybDhS6xbCMOcUgplIKb8rQA6BZTLYAj9L3XNndW4RrNV2YVrAEdTniF8r1OYhh
         +MUt7VXLQvgtOoZhyH2KlHqB5Pq5WjHPGM6UC5lO9knkb7FGYtcjt923RgqVpHj+AtHe
         le2Q==
X-Gm-Message-State: AOAM533s+H3PAOBzG4DSmdw65K+JbhUIC2l/H92Rrj2tR12++lEp/2IY
        U9YFmcEWTE3XHZsQ0Y3dm8HoP0b43f4=
X-Google-Smtp-Source: ABdhPJzxbKWXnssnXJN5sgEHoB8hnWwsH5a0J/70J+3ajgY7rVorb7h2O8g2cOzoPqQm5DS2r419PQ==
X-Received: by 2002:a05:6402:27c8:: with SMTP id c8mr1362036ede.87.1643243800938;
        Wed, 26 Jan 2022 16:36:40 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 04/10] ipv6: clean up cork setup/release
Date:   Thu, 27 Jan 2022 00:36:25 +0000
Message-Id: <7c774539bb6c4d55f62026328c22fc32ab5562da.1643243773.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up ip6_setup_cork() and ip6_cork_release() adding a local variable
for v6_cork->opt. It's a preparation patch for further changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 44 +++++++++++++++++++++----------------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 4acd577d5ec5..88349e49717a 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1354,7 +1354,7 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	unsigned int mtu;
-	struct ipv6_txoptions *opt = ipc6->opt;
+	struct ipv6_txoptions *nopt, *opt = ipc6->opt;
 
 	/*
 	 * setup for corking
@@ -1363,32 +1363,28 @@ static int ip6_setup_cork(struct sock *sk, struct inet_cork_full *cork,
 		if (WARN_ON(v6_cork->opt))
 			return -EINVAL;
 
-		v6_cork->opt = kzalloc(sizeof(*opt), sk->sk_allocation);
-		if (unlikely(!v6_cork->opt))
+		nopt = v6_cork->opt = kzalloc(sizeof(*opt), sk->sk_allocation);
+		if (unlikely(!nopt))
 			return -ENOBUFS;
 
-		v6_cork->opt->tot_len = sizeof(*opt);
-		v6_cork->opt->opt_flen = opt->opt_flen;
-		v6_cork->opt->opt_nflen = opt->opt_nflen;
+		nopt->tot_len = sizeof(*opt);
+		nopt->opt_flen = opt->opt_flen;
+		nopt->opt_nflen = opt->opt_nflen;
 
-		v6_cork->opt->dst0opt = ip6_opt_dup(opt->dst0opt,
-						    sk->sk_allocation);
-		if (opt->dst0opt && !v6_cork->opt->dst0opt)
+		nopt->dst0opt = ip6_opt_dup(opt->dst0opt, sk->sk_allocation);
+		if (opt->dst0opt && !nopt->dst0opt)
 			return -ENOBUFS;
 
-		v6_cork->opt->dst1opt = ip6_opt_dup(opt->dst1opt,
-						    sk->sk_allocation);
-		if (opt->dst1opt && !v6_cork->opt->dst1opt)
+		nopt->dst1opt = ip6_opt_dup(opt->dst1opt, sk->sk_allocation);
+		if (opt->dst1opt && !nopt->dst1opt)
 			return -ENOBUFS;
 
-		v6_cork->opt->hopopt = ip6_opt_dup(opt->hopopt,
-						   sk->sk_allocation);
-		if (opt->hopopt && !v6_cork->opt->hopopt)
+		nopt->hopopt = ip6_opt_dup(opt->hopopt, sk->sk_allocation);
+		if (opt->hopopt && !nopt->hopopt)
 			return -ENOBUFS;
 
-		v6_cork->opt->srcrt = ip6_rthdr_dup(opt->srcrt,
-						    sk->sk_allocation);
-		if (opt->srcrt && !v6_cork->opt->srcrt)
+		nopt->srcrt = ip6_rthdr_dup(opt->srcrt, sk->sk_allocation);
+		if (opt->srcrt && !nopt->srcrt)
 			return -ENOBUFS;
 
 		/* need source address above miyazawa*/
@@ -1820,11 +1816,13 @@ static void ip6_cork_release(struct inet_cork_full *cork,
 			     struct inet6_cork *v6_cork)
 {
 	if (v6_cork->opt) {
-		kfree(v6_cork->opt->dst0opt);
-		kfree(v6_cork->opt->dst1opt);
-		kfree(v6_cork->opt->hopopt);
-		kfree(v6_cork->opt->srcrt);
-		kfree(v6_cork->opt);
+		struct ipv6_txoptions *opt = v6_cork->opt;
+
+		kfree(opt->dst0opt);
+		kfree(opt->dst1opt);
+		kfree(opt->hopopt);
+		kfree(opt->srcrt);
+		kfree(opt);
 		v6_cork->opt = NULL;
 	}
 
-- 
2.34.1

