Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFEAF4B71BF
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241326AbiBOQBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 11:01:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241335AbiBOQA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 11:00:57 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9F2D0053
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 08:00:41 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id e16so19006693qtq.6
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 08:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y0YWNQman/TOUOAGnU8g5ZC8m51kOIcjRpBM9e83B7Y=;
        b=FcgPsnpyk2nUz1iikgPR3bOWeBmIYueSWuCeO3cPKaJ4tV3Ja+Kq/ez49qgXrXz/Vi
         bTZ4ZWdoX+UPwffxbR30QD5ixOZmVrBJh667ACSRrq9/VJe7vyv5bh20SusK6YYT5UR7
         n397aHooa25BXOV+hUZGlHI6ztMi7ZnRGYuDQOdrmGK7t55307xSq7+f6JZtirMvDQWJ
         38LICbK6CBKiOEiSH2Qg5KEGngYun5kjpVzIj/ZB1JHOx79Ucpe+SJ9WZX9Bd0Ph7kzY
         yuT537qeXERQyRThoVMPaiijEPQRuU03QVmPLaNoetaVMkWYkSfY5QeoRKCp5kwem2h1
         ki+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=y0YWNQman/TOUOAGnU8g5ZC8m51kOIcjRpBM9e83B7Y=;
        b=HiEiC2V/be7G7/N1cAjA6X1my2v9VhT3Yo5GP6E9XNQc21vH345LV3XOXy++DshT9A
         fUW8Lyc3WXAjgMrsFom4cyg6bnzEXIU36hrb2kh6OJ74Reu6rGGIL1yBsIVXegrp41l+
         FnZTpOFwlPecByOum+0P+ga6vQ4Tq5gSss52sZtqqP/n4oGSbEiVvy/AZo3JaeRvFtBP
         pd3qchkF4IsVRxxRLRymOCm+qaWlwk+YkizFMPe9+ERhSFJjjxzODBuanM0InUjwr0nS
         5udL27vqz+vE4AUe97E4aaFimzAaAX9SKlBdFpHXVVL2bTSCqp8MHTtnH4yJcnlz93XL
         AJ9Q==
X-Gm-Message-State: AOAM531AfNzVXQUUF54p3yNstt+JTJhTAYcow6Ca69EBUzfDXChL49OY
        BhFD6qRUPLQCPjnalVUhhEeHKOVymjI=
X-Google-Smtp-Source: ABdhPJwhnbh4QAjIeouG094mwFfgSODo4ndqkagWhMVlMmEurTCMUrQtWPAb6ngcJsnBgTgpmSMfNQ==
X-Received: by 2002:ac8:5c96:: with SMTP id r22mr3186240qta.228.1644940840286;
        Tue, 15 Feb 2022 08:00:40 -0800 (PST)
Received: from willemb.c.googlers.com.com (55.87.194.35.bc.googleusercontent.com. [35.194.87.55])
        by smtp.gmail.com with ESMTPSA id y9sm10964463qtx.85.2022.02.15.08.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 08:00:39 -0800 (PST)
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Willem de Bruijn <willemb@google.com>,
        Congyu Liu <liu3101@purdue.edu>
Subject: [PATCH net v2] ipv6: per-netns exclusive flowlabel checks
Date:   Tue, 15 Feb 2022 11:00:37 -0500
Message-Id: <20220215160037.1976072-1-willemdebruijn.kernel@gmail.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
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

Changes
  v2
    - wrap in IS_ENABLED(CONFIG_IPV6) to avoid breakage if disabled

Fixes: 59c820b2317f ("ipv6: elide flowlabel check if no exclusive leases exist")
Link: https://lore.kernel.org/netdev/MWHPR2201MB1072BCCCFCE779E4094837ACD0329@MWHPR2201MB1072.namprd22.prod.outlook.com/
Reported-by: Congyu Liu <liu3101@purdue.edu>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Tested-by: Congyu Liu <liu3101@purdue.edu>
---
 include/net/ipv6.h       | 5 ++++-
 include/net/netns/ipv6.h | 3 ++-
 net/ipv6/ip6_flowlabel.c | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 3afcb128e064..92eec13d1693 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -393,17 +393,20 @@ static inline void txopt_put(struct ipv6_txoptions *opt)
 		kfree_rcu(opt, rcu);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 struct ip6_flowlabel *__fl6_sock_lookup(struct sock *sk, __be32 label);
 
 extern struct static_key_false_deferred ipv6_flowlabel_exclusive;
 static inline struct ip6_flowlabel *fl6_sock_lookup(struct sock *sk,
 						    __be32 label)
 {
-	if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key))
+	if (static_branch_unlikely(&ipv6_flowlabel_exclusive.key) &&
+	    READ_ONCE(sock_net(sk)->ipv6.flowlabel_has_excl))
 		return __fl6_sock_lookup(sk, label) ? : ERR_PTR(-ENOENT);
 
 	return NULL;
 }
+#endif
 
 struct ipv6_txoptions *fl6_merge_options(struct ipv6_txoptions *opt_space,
 					 struct ip6_flowlabel *fl,
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

