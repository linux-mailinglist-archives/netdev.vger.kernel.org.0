Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E01749D6CF
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:37:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbiA0Agp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbiA0Agl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:36:41 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9CBC06161C;
        Wed, 26 Jan 2022 16:36:41 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id s5so2216336ejx.2;
        Wed, 26 Jan 2022 16:36:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PIyy1S882MJEdPQ345mTMhYul/4iG3UJWg4AQv8ZfsM=;
        b=Vs+eFN3GvnoXPrSn/v5w2h17QddAImMR3zY6a+2yAQ6VLg7WZnc71MOtbzAKD0xwvK
         QxVgP+VRshzGKldX7TwBTXQZ1AqIE3T50lfxHrR10kenB5njR2do3XRfXgwUN4xWEMIb
         eNJhbRPy9iGXPPpt2YX7bdecUsgomSGwbLDhcM64VkHcjFI18aQy7dOIjC8ymwJB17os
         BvX+wzwgl6WyVNEA+wD+QSCUsrPT93grzeXhAj3IY78YyOB022/d326ELOuPPvNc64Jh
         aVNf+Weu6zv3sCP/hJ+otFQ7Fwyi1d+1HixSrfRu5quGR/k8OVUEx6Govl1Wx3kw04Zf
         gMmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PIyy1S882MJEdPQ345mTMhYul/4iG3UJWg4AQv8ZfsM=;
        b=XhnAkxhQcc9BWEq0hBS4s1gh+s3J3XFB1EU6ub5TVFffPBdOBaeUtZh1EWqKLITqj4
         jLZCZzdrWzODNfNTQ3aYO0aHpXQJ0ulUsrrA0rp1wn9SpnYjQCQ0aMdzaD1M8roqv1Oa
         z1P/1SlFgEnNPp7M4KNYPho3RvhoydLE6ZC8c+9yL2sJT1tyDfLTUNTyvkdEXduEBMot
         ztxwqVHiDsMvPwS3fH3xdoPybqyMQXb08nNSn0Es7vh7xfr/LK1AdexSDdikP599vOYT
         PmylskMSh1S0tSK6zVMdgGyi/cYCrvlydLsbVre87w6i0+4EWmxnIauyJoMRAVEBJuPo
         e7Sw==
X-Gm-Message-State: AOAM530sXVw63ViA8xgPIIWtmj59R7AxgpJc0WDSXRV1+nfj89XCVHLD
        r6W56JRQlj8sLmPFQw4dMnlbPmAN3NM=
X-Google-Smtp-Source: ABdhPJwT7dr42MSzLWWRj+EZ2vzWIe6zAxtvQU0DfaOJvqiWn+Fy6Z8OtOl2cHPSRlwi0dMUnC8aHg==
X-Received: by 2002:a17:907:2d94:: with SMTP id gt20mr1085743ejc.118.1643243800011;
        Wed, 26 Jan 2022 16:36:40 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.222])
        by smtp.gmail.com with ESMTPSA id op27sm8039235ejb.103.2022.01.26.16.36.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 16:36:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH net-next v2 03/10] ipv6: remove daddr temp buffer in __ip6_make_skb
Date:   Thu, 27 Jan 2022 00:36:24 +0000
Message-Id: <e622cbe82ae21b740cb818abc9f6efe02cb0dede.1643243772.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1643243772.git.asml.silence@gmail.com>
References: <cover.1643243772.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6_push_nfrag_opts() doesn't change passed daddr, and so
__ip6_make_skb() doesn't actually need to keep an on-stack copy of
fl6->daddr. Set initially final_dst to fl6->daddr,
ipv6_push_nfrag_opts() will override it if needed, and get rid of extra
copies.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 net/ipv6/ip6_output.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 14d607ccfeea..4acd577d5ec5 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1843,7 +1843,7 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 {
 	struct sk_buff *skb, *tmp_skb;
 	struct sk_buff **tail_skb;
-	struct in6_addr final_dst_buf, *final_dst = &final_dst_buf;
+	struct in6_addr *final_dst;
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct net *net = sock_net(sk);
 	struct ipv6hdr *hdr;
@@ -1873,9 +1873,9 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	/* Allow local fragmentation. */
 	skb->ignore_df = ip6_sk_ignore_df(sk);
-
-	*final_dst = fl6->daddr;
 	__skb_pull(skb, skb_network_header_len(skb));
+
+	final_dst = &fl6->daddr;
 	if (opt && opt->opt_flen)
 		ipv6_push_frag_opts(skb, opt, &proto);
 	if (opt && opt->opt_nflen)
@@ -1895,7 +1895,6 @@ struct sk_buff *__ip6_make_skb(struct sock *sk,
 
 	skb->priority = sk->sk_priority;
 	skb->mark = cork->base.mark;
-
 	skb->tstamp = cork->base.transmit_time;
 
 	ip6_cork_steal_dst(skb, cork);
-- 
2.34.1

