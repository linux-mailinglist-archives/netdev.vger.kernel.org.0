Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A659B95E
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 02:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726079AbfHXALv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 20:11:51 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38197 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfHXALv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 20:11:51 -0400
Received: by mail-io1-f65.google.com with SMTP id p12so24070685iog.5
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 17:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=sP3dIIzvbA0qq5q/wqz2sRzRAKEwLhEknaTavnGX+uk=;
        b=t8rF/h+/KRBzEzSOVmajNs9s4/hLl4ReghuzgmwLY/9FIZ5KsLHIKFfHUtQLBdCwsR
         53LzPa9vICjBI7J9mJM5M8Fez/2omZCj986rlSmsqqfEE3xmKq9jePU6UwE+kvjlPczB
         RqcxTmIpLC3AKSwxivfrgtMpo65gqk2YIFbKWrzhbRWf9Q0W9cC3kEvHn8anKBTT5QQT
         IYcOUXORrPiI8BnXoeWP84wbCM41y8mdTdnsWvgjxClls90J/LQoDMfDj46OkcfruuJn
         7QPGcyC9jYVSgWSj7wX6RZ+Gcwb7ScJYlov7AUhgpaBkZZ8B3U1m1ah4MAjMMH6fNppU
         1FkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=sP3dIIzvbA0qq5q/wqz2sRzRAKEwLhEknaTavnGX+uk=;
        b=bpJX+eZVNPk2SPnf6VRWRpEy/HTaoI9ICy++H6e/fJV5vpR1aCW4hczGhxQcCBojGo
         kXUSCm+9b8udNrazsjKLmJZWacJVic52CIswR09Ze6tlBAHCbAuRBL/GLB2lKLP1FnR7
         2dEHEVB0urfAouQjGqHtTsB/5gawN3oE3RVqyxeNC3Ex8jb395xgrr8L++f3h6LO6Fvm
         wbtSJG+3LDEen+uFKAor/fnM7AcNBtAe4BfV0XW+eM5sNO+dXbtteEXt311ZGdNxyqmO
         D2gs6K505JCksP4oH7wnD3E+7WPlXt4Il4TZMb26+Yk+2xKkDHsvqseOKOxuyP2G+jck
         EnUA==
X-Gm-Message-State: APjAAAW8XHbaXLTiprqrSw7GL9h0+GPpsBmduIPhbTqn4Q9MsQPGaOb1
        0gyVNL/4DbB2xrFJbpRMAI4=
X-Google-Smtp-Source: APXvYqxkvApI9t1kmKCFhv/+YJm2Xk6p1G0i0h8xvvdTylMbjJpil1Y0ogUm2SE+jos0hL84Sw0spw==
X-Received: by 2002:a5d:8f02:: with SMTP id f2mr10858032iof.192.1566605510253;
        Fri, 23 Aug 2019 17:11:50 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j16sm4090225iok.34.2019.08.23.17.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2019 17:11:49 -0700 (PDT)
Subject: [net PATCH] net: route dump netlink NLM_F_MULTI flag missing
From:   John Fastabend <john.fastabend@gmail.com>
To:     sbrivio@redhat.com, davem@davemloft.net, dsahern@gmail.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com
Date:   Fri, 23 Aug 2019 17:11:38 -0700
Message-ID: <156660549861.5753.7912871726096518275.stgit@john-XPS-13-9370>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An excerpt from netlink(7) man page,

  In multipart messages (multiple nlmsghdr headers with associated payload
  in one byte stream) the first and all following headers have the
  NLM_F_MULTI flag set, except for the last  header  which  has the type
  NLMSG_DONE.

but, after (ee28906) there is a missing NLM_F_MULTI flag in the middle of a
FIB dump. The result is user space applications following above man page
excerpt may get confused and may stop parsing msg believing something went
wrong.

In the golang netlink lib [0] the library logic stops parsing believing the
message is not a multipart message. Found this running Cilium[1] against
net-next while adding a feature to auto-detect routes. I noticed with
multiple route tables we no longer could detect the default routes on net
tree kernels because the library logic was not returning them.

Fix this by handling the fib_dump_info_fnhe() case the same way the
fib_dump_info() handles it by passing the flags argument through the
call chain and adding a flags argument to rt_fill_info().

Tested with Cilium stack and auto-detection of routes works again. Also
annotated libs to dump netlink msgs and inspected NLM_F_MULTI and
NLMSG_DONE flags look correct after this.

Note: In inet_rtm_getroute() pass rt_fill_info() '0' for flags the same
as is done for fib_dump_info() so this looks correct to me.

[0] https://github.com/vishvananda/netlink/
[1] https://github.com/cilium/

Fixes: ee28906fd7a14 ("ipv4: Dump route exceptions if requested")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/net/route.h |    2 +-
 net/ipv4/fib_trie.c |    2 +-
 net/ipv4/route.c    |   17 ++++++++++-------
 3 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/net/route.h b/include/net/route.h
index 630a0493f1f3..dfce19c9fa96 100644
--- a/include/net/route.h
+++ b/include/net/route.h
@@ -233,7 +233,7 @@ void rt_del_uncached_list(struct rtable *rt);
 
 int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
 		       u32 table_id, struct fib_info *fi,
-		       int *fa_index, int fa_start);
+		       int *fa_index, int fa_start, unsigned int flags);
 
 static inline void ip_rt_put(struct rtable *rt)
 {
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 2b2b3d291ab0..1ab2fb6bb37d 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2145,7 +2145,7 @@ static int fn_trie_dump_leaf(struct key_vector *l, struct fib_table *tb,
 
 		if (filter->dump_exceptions) {
 			err = fib_dump_info_fnhe(skb, cb, tb->tb_id, fi,
-						 &i_fa, s_fa);
+						 &i_fa, s_fa, flags);
 			if (err < 0)
 				goto stop;
 		}
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 517300d587a7..b6a6f18c3dd1 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2728,7 +2728,8 @@ EXPORT_SYMBOL_GPL(ip_route_output_flow);
 /* called with rcu_read_lock held */
 static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 			struct rtable *rt, u32 table_id, struct flowi4 *fl4,
-			struct sk_buff *skb, u32 portid, u32 seq)
+			struct sk_buff *skb, u32 portid, u32 seq,
+			unsigned int flags)
 {
 	struct rtmsg *r;
 	struct nlmsghdr *nlh;
@@ -2736,7 +2737,7 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 	u32 error;
 	u32 metrics[RTAX_MAX];
 
-	nlh = nlmsg_put(skb, portid, seq, RTM_NEWROUTE, sizeof(*r), 0);
+	nlh = nlmsg_put(skb, portid, seq, RTM_NEWROUTE, sizeof(*r), flags);
 	if (!nlh)
 		return -EMSGSIZE;
 
@@ -2860,7 +2861,7 @@ static int rt_fill_info(struct net *net, __be32 dst, __be32 src,
 static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
 			    struct netlink_callback *cb, u32 table_id,
 			    struct fnhe_hash_bucket *bucket, int genid,
-			    int *fa_index, int fa_start)
+			    int *fa_index, int fa_start, unsigned int flags)
 {
 	int i;
 
@@ -2891,7 +2892,7 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
 			err = rt_fill_info(net, fnhe->fnhe_daddr, 0, rt,
 					   table_id, NULL, skb,
 					   NETLINK_CB(cb->skb).portid,
-					   cb->nlh->nlmsg_seq);
+					   cb->nlh->nlmsg_seq, flags);
 			if (err)
 				return err;
 next:
@@ -2904,7 +2905,7 @@ static int fnhe_dump_bucket(struct net *net, struct sk_buff *skb,
 
 int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
 		       u32 table_id, struct fib_info *fi,
-		       int *fa_index, int fa_start)
+		       int *fa_index, int fa_start, unsigned int flags)
 {
 	struct net *net = sock_net(cb->skb->sk);
 	int nhsel, genid = fnhe_genid(net);
@@ -2922,7 +2923,8 @@ int fib_dump_info_fnhe(struct sk_buff *skb, struct netlink_callback *cb,
 		err = 0;
 		if (bucket)
 			err = fnhe_dump_bucket(net, skb, cb, table_id, bucket,
-					       genid, fa_index, fa_start);
+					       genid, fa_index, fa_start,
+					       flags);
 		rcu_read_unlock();
 		if (err)
 			return err;
@@ -3183,7 +3185,8 @@ static int inet_rtm_getroute(struct sk_buff *in_skb, struct nlmsghdr *nlh,
 				    fl4.flowi4_tos, res.fi, 0);
 	} else {
 		err = rt_fill_info(net, dst, src, rt, table_id, &fl4, skb,
-				   NETLINK_CB(in_skb).portid, nlh->nlmsg_seq);
+				   NETLINK_CB(in_skb).portid,
+				   nlh->nlmsg_seq, 0);
 	}
 	if (err < 0)
 		goto errout_rcu;

