Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24CCE618A81
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 22:25:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiKCVZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 17:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiKCVZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 17:25:36 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D47817AAA
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 14:25:35 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id v7so1960473wmn.0
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 14:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CbvR8VuafE8eZOle2gcxzJnLTEWWuPtnJ8HojgPG8FI=;
        b=i0Pj5NJz6BQy2jzDSR6PRBtsI8yVo2CSGPtcH20TBjjb0Eigv4jxwlEhO8yQewQ8gH
         TiLzklJ8a4fuq4UgSoiR2bKq7VKewD+BleRukwzDpX1pYCq+a763u7xPO494HGRUESdb
         uCMqWOEDMDvnt59ZJl6Lu3qptYJFIetxLTzlixabS9d/g32OMDUMUy0QxG3j4EZqLJQ2
         UkQj2eezhrK20k+ck1D+w6CBq+Uuql8KexWefgZ/0mlOFTpbmvlCU1baxTy+BfgbNqkX
         GcdLXy2/MiPCllet8CvSMCeoOB5MFDDQ+VzLD2WhRFeTp0lxZ9L+Zci9j6OemjU3GezS
         VlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CbvR8VuafE8eZOle2gcxzJnLTEWWuPtnJ8HojgPG8FI=;
        b=e9MwA8IDViXAmfRi5yl/xjS7utt6tQjw3QWSnrWSQlkRGWltssxMP/2rIaW0QIh8z8
         ilBF1LClFw+yf53fIsNdhwr69vxBHe/kSipk6RrR/GZhldDeqJ2WggHeLtukvph4Mgh4
         Ty0SLkjvwGbWNsS4zxjneotemriqBGEqhRTmqOnRFosQid1P7Q8C49p9s6vHxivruR4o
         evjmZLj8v+z8DkwdIO3ev6B1Rvx+byVUGJnQHwQHU8VF1nSNKgPzMiP2k7Gkvv4QHk9h
         Gfx/tKAqgM3dHh3I0XjAUF+H3tCqhgkk4m/ncHt3sJVgzQfjsrZifX1sISsFz7fnl4dx
         V/LA==
X-Gm-Message-State: ACrzQf0EKKQyo5ZsTuZ/qEgmp5o+XQcmloVWbxMtqP4fpADFiJFTAZs7
        s5ZBubgOvs98hsU2XLaRU85GFw==
X-Google-Smtp-Source: AMsMyM4bseqKfK3bTLh/t5jbhrShEK9i2dZWcfeLz21e0CvKezlCw+x6zmm3+Zs63xkXsOu2bL25ng==
X-Received: by 2002:a05:600c:689b:b0:3c2:fd6e:1fe5 with SMTP id fn27-20020a05600c689b00b003c2fd6e1fe5mr21011103wmb.99.1667510734087;
        Thu, 03 Nov 2022 14:25:34 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t18-20020a05600c199200b003a601a1c2f7sm1038652wmq.19.2022.11.03.14.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 14:25:33 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Safonov <dima@arista.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/3] net/tcp: Separate tcp_md5sig_info allocation into tcp_md5sig_info_add()
Date:   Thu,  3 Nov 2022 21:25:23 +0000
Message-Id: <20221103212524.865762-3-dima@arista.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221103212524.865762-1-dima@arista.com>
References: <20221103212524.865762-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
---
 net/ipv4/tcp_ipv4.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 87d440f47a70..fae80b1a1796 100644
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

