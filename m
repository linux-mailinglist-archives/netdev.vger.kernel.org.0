Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B483BFF0F
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 19:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfD3RpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 13:45:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:41116 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725942AbfD3RpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 13:45:17 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x3UHcgKj031182
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 10:45:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=5H4kRIjdm6+6H7bwEw+KHqfFYYGJK8d+cnYGte/qnqg=;
 b=O7coycKIj/N8oR6fXnsIfZ+z4RWY2BDPxwfJ9iWZSx/hd43AhqeTcXpyruL/5UGHmpqh
 ZcgdHW2Nrqbtqj1xhRyTkFHMopW7yjKtlTzFNyD3QtLvMPK6+duvMug/E5PwwGIOuVQF
 IFBRZaH1Nqvg+ap5H4qSLILXwWWlqB8OuAQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2s6m1whh5m-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 10:45:15 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 30 Apr 2019 10:45:13 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 822CF2941A1F; Tue, 30 Apr 2019 10:45:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Jonathan Lemon <bsd@fb.com>, <kernel-team@fb.com>,
        Wei Wang <weiwan@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH net] ipv6: A few fixes on dereferencing rt->from
Date:   Tue, 30 Apr 2019 10:45:12 -0700
Message-ID: <20190430174512.3898413-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-30_08:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a followup after the fix in
commit 9c69a1320515 ("route: Avoid crash from dereferencing NULL rt->from")

rt6_do_redirect():
1. NULL checking is needed on rt->from because a parallel
   fib6_info delete could happen that sets rt->from to NULL.
   (e.g. rt6_remove_exception() and fib6_drop_pcpu_from()).

2. fib6_info_hold() is not enough.  Same reason as (1).
   Meaning, holding dst->__refcnt cannot ensure
   rt->from is not NULL or rt->from->fib6_ref is not 0.

   Instead of using fib6_info_hold_safe() which ip6_rt_cache_alloc()
   is already doing, this patch chooses to extend the rcu section
   to keep "from" dereference-able after checking for NULL.

inet6_rtm_getroute():
1. NULL checking is also needed on rt->from for a similar reason.
   Note that inet6_rtm_getroute() is using RTNL_FLAG_DOIT_UNLOCKED.

Fixes: a68886a69180 ("net/ipv6: Make from in rt6_info rcu protected")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv6/route.c | 38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index b4899f0de0d0..73ef72c208af 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -3397,11 +3397,8 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
 
 	rcu_read_lock();
 	from = rcu_dereference(rt->from);
-	/* This fib6_info_hold() is safe here because we hold reference to rt
-	 * and rt already holds reference to fib6_info.
-	 */
-	fib6_info_hold(from);
-	rcu_read_unlock();
+	if (!from)
+		goto out;
 
 	nrt = ip6_rt_cache_alloc(from, &msg->dest, NULL);
 	if (!nrt)
@@ -3413,10 +3410,7 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
 
 	nrt->rt6i_gateway = *(struct in6_addr *)neigh->primary_key;
 
-	/* No need to remove rt from the exception table if rt is
-	 * a cached route because rt6_insert_exception() will
-	 * takes care of it
-	 */
+	/* rt6_insert_exception() will take care of duplicated exceptions */
 	if (rt6_insert_exception(nrt, from)) {
 		dst_release_immediate(&nrt->dst);
 		goto out;
@@ -3429,7 +3423,7 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
 	call_netevent_notifiers(NETEVENT_REDIRECT, &netevent);
 
 out:
-	fib6_info_release(from);
+	rcu_read_unlock();
 	neigh_release(neigh);
 }
 
@@ -5028,16 +5022,20 @@ static int inet6_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 
 	rcu_read_lock();
 	from = rcu_dereference(rt->from);
-
-	if (fibmatch)
-		err = rt6_fill_node(net, skb, from, NULL, NULL, NULL, iif,
-				    RTM_NEWROUTE, NETLINK_CB(in_skb).portid,
-				    nlh->nlmsg_seq, 0);
-	else
-		err = rt6_fill_node(net, skb, from, dst, &fl6.daddr,
-				    &fl6.saddr, iif, RTM_NEWROUTE,
-				    NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
-				    0);
+	if (from) {
+		if (fibmatch)
+			err = rt6_fill_node(net, skb, from, NULL, NULL, NULL,
+					    iif, RTM_NEWROUTE,
+					    NETLINK_CB(in_skb).portid,
+					    nlh->nlmsg_seq, 0);
+		else
+			err = rt6_fill_node(net, skb, from, dst, &fl6.daddr,
+					    &fl6.saddr, iif, RTM_NEWROUTE,
+					    NETLINK_CB(in_skb).portid,
+					    nlh->nlmsg_seq, 0);
+	} else {
+		err = -ENETUNREACH;
+	}
 	rcu_read_unlock();
 
 	if (err < 0) {
-- 
2.17.1

