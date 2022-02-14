Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184624B5B0C
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:40:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiBNUTY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:19:24 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiBNUTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:19:23 -0500
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96053AA6C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:19:09 -0800 (PST)
Received: by mail-qt1-f179.google.com with SMTP id t1so16488650qtq.13
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pqBwcF4YvHD4OBoaDlpWJJY2D7mKx5h302J7i1Paroc=;
        b=TZeHEqU9QNvmuOgh7IxK+sme+acyrG/8RpPccZY8AXd9TR+MwnB+ILXJc/inEd8Wfq
         GKFRhu5Hchtg5brodXpvOj4phbFI8iuVJBqQVINJGF2+UrGDQsCxeg3Oj4lN2DUU4Lmj
         5zNEYSOtwwMwIXtZsISKNIw0dORL0gErSbZIL9J9lIYAM7+eWqwp2ANu7tacohLQPJQc
         HSdSi27Qd1Rac0w48GuoQQ/t0MmCJ4I5gLan3Fn2MHRuy5zAVCzVQIZPbUQgV1vw2G5e
         unpSB+e85FJLYL3u8CxTS1zJfcVogmBGSDOkBH22/715LnWMGFwjVAj3B9QA8MowBQGr
         2b7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pqBwcF4YvHD4OBoaDlpWJJY2D7mKx5h302J7i1Paroc=;
        b=B91c4jrQB61e307f/pL/oaR2xkOn1uEQOkj7pJNkIWAaG2guQuRJaaKiHy9dnqH6wn
         hHeGSf5TWVB3aeDfbgfPw2pSYkjdpTYB/lK5XZbosOgjKN+a6yKbkFDkrZ5412GR61XM
         Yok4DVP/865Wwu1NCtInOO4EZyfwy1pA2STHYhpGpnU6/b8NK0gl0KQf2Kqcyma2P/rQ
         FwWWJCyO5Zzptn8jBJTcYGu8L5RXqmSYPyI7ny/CmbJBEO1bTHjyGeODPMyGfxTSftqI
         G3qFhKmGdSwyJ1t/ns+cFjgzuon8wyGeByepTPsgFf+1CoHPqOvS3LhfuVUXmCakckda
         gUiw==
X-Gm-Message-State: AOAM531WvRCZDxapDAtUFDVBicpY9q1hgj7LvIvlL4gbcMMoFgltdeH+
        Hk+EWCoSerkUCKXRVW+5AL6grM9uaEo=
X-Google-Smtp-Source: ABdhPJxN1rIMbp3ZSGn0uebm+1I82vBfQXThxnIARvvl6TiIr43k0f9/a3SnrxFoM11JoLLyjA0Spw==
X-Received: by 2002:a05:620a:1511:: with SMTP id i17mr329386qkk.77.1644869043730;
        Mon, 14 Feb 2022 12:04:03 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id u36sm7289296qtc.42.2022.02.14.12.04.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 12:04:03 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Congyu Liu <liu3101@purdue.edu>
Subject: [PATCH net] ipv6: per-netns exclusive flowlabel checks
Date:   Mon, 14 Feb 2022 15:04:00 -0500
Message-Id: <20220214200400.513069-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

Ipv6 flowlabels historically require a reservation before use.
Optionally in exclusive mode (e.g., user-private).

Commit 59c820b2317f ("ipv6: elide flowlabel check if no exclusive
leases exist") introduced a fastpath that avoids this check when no
exclusive leases exist in the system, and thus any flowlabel use
will be granted.

That allows skipping the control operation to reserve a flowlabel
entirely. Though with a warning if the fast path fails:

  This is an optimization. Robust applications still have to revert to
  requesting leases if the fast path fails due to an exclusive lease.

Still, this is subtle. Better isolate network namespaces from each
other. Flowlabels are per-netns. Also record per-netns whether
exclusive leases are in use. Then behavior does not change based on
activity in other netns.

Fixes: 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases exist")
Link: https://lore.kernel.org/netdev/MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com/
Reported-by: Congyu Liu <liu3101@purdue.edu>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Tested-by: Congyu Liu <liu3101@purdue.edu>
---
 include/net/ipv6.h       | 3 ++-
 include/net/netns/ipv6.h | 3 ++-
 net/ipv6/ip6_flowlabel.c | 4 +++-
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 3afcb128e064..49b885784298 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -399,7 +399,8 @@ extern struct static_key_false_deferred ipv6_flowlabel_exclusive;
 static inline struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk,
 						    __be32 label)
 {
-	if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key))
+	if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
+	    READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
 		return __fl6_sock_lookup(sk, label) ? : ERR_PTR(-ENOENT);
 
 	return NULL;
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index a4b550380316..6bd7e5a85ce7 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -77,9 +77,10 @@ struct netns_ipv6 {
 	spinlock_t		fib6_gc_lock;
 	unsigned int		 ip6_rt_gc_expire;
 	unsigned long		 ip6_rt_last_gc;
+	unsigned char		flowlabel_has_excl;
 #ifdef CONFIG_IPV6_MULTIPLE_TABLES
-	unsigned int		fib6_rules_require_fldissect;
 	bool			fib6_has_custom_rules;
+	unsigned int		fib6_rules_require_fldissect;
 #ifdef CONFIG_IPV6_SUBTREES
 	unsigned int		fib6_routes_require_src;
 #endif
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index aa673a6a7e43..ceb85c67ce39 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -450,8 +450,10 @@ fl_create(struct net *net, struct sock *sk, struct in6_flowlabel_req *freq,
 		err = -EINVAL;
 		goto done;
 	}
-	if (fl_shared_exclusive(fl) || fl->opt)
+	if (fl_shared_exclusive(fl) || fl->opt) {
+		WRITE_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl, 1);
 		static_branch_deferred_inc(&ipv6_flowlabel_exclusive);
+	}
 	return fl;
 
 done:
-- 
2.35.1.265.g69c8d7142f-goog

