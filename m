Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BCE822F72B
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 19:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731396AbgG0R6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 13:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729205AbgG0R6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 13:58:02 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DECFC0619D4
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:58:02 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id z187so13264477pgd.11
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 10:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=v79kbmUkhVfOjNte7kKJtv1wRDHs0zSXbmGajTvWXv4=;
        b=HEMVnZX7jaCR6Dx3/f8jO8MM2TJn10Vgm+3WwNJZC2gGx5Xuheqe2zDflWymTVnCb6
         Td3RdtBmv1zC+GgRd5hCzx10VyDj6FvqTBDw8mynJPtkZBo7qAmX5R5CiJEPTJCBbKXS
         1xFnzfN/29lJsw2grBcfZCyN3/rXzo62GQYeBwHWOgbmeDicxMkfDb9/XxUjS3T22Fr2
         dLnaF9pFF3ZyLmQ1rihimEBPxc8QQKj9u8KL6EUbn0RwyyGlM8/hRHa0Hns+GBTDNbJn
         RTlJ+tXPR90s7DOfGAosp8XIQPTn6Lm7wjjG4iuRdjJMk2qBWcJey87UyBHuaJVHnyYd
         Jm7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=v79kbmUkhVfOjNte7kKJtv1wRDHs0zSXbmGajTvWXv4=;
        b=GJXhcbqgN8wb3CgURafToM+ca6saE0KRR4TWZUvJCpX5mo/9Ax3ecyBf0pdKQSvx68
         24MixrtrCfzwKqUQfMsNIV2YMajGNTVgRUDJ1PW0JLOCos6p6G9sE9UoJgBC/jAubRVM
         qMVI/npQbuuVYlVycDJGsIBdzVDhtwqrldY1aEK1o0ANUYIQywtTMyQOGacNGK4Uop2I
         1fvXcfjr6GB8ldjE2t0guUYxHmN3G/p7T0P6bL3ksAoI8hIBY7eUDfPsZD1wnPdqjM1B
         +YLR9iv3Uv8URnzvG2j0A/ThB/t2gDRN1ryQXPdSmZQFBqB3B7f8orxL1SrPc/wCQUSE
         qtcA==
X-Gm-Message-State: AOAM531Grrm0c5Vlj30eWMZTfJIUmMrujbEX/OSd1Q2GV7XUNxP9dJ/F
        4zuEs4pyl1cVX3ClLJQQkKmBte613tL0BSETQK8=
X-Google-Smtp-Source: ABdhPJyb0sm0pWa5ByI1RgPKb62bIHEnGcfdYmL0NVmKgoJbCACCmb96SrUbd51FxVdHNXFIvotUvmJ8NstJCkhTP5w=
X-Received: by 2002:a65:6086:: with SMTP id t6mr20167995pgu.342.1595872681997;
 Mon, 27 Jul 2020 10:58:01 -0700 (PDT)
Date:   Mon, 27 Jul 2020 17:57:20 +0000
In-Reply-To: <20200727175720.4022402-1-willmcvicker@google.com>
Message-Id: <20200727175720.4022402-2-willmcvicker@google.com>
Mime-Version: 1.0
References: <20200727175720.4022402-1-willmcvicker@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH 1/1] netfilter: nat: add range checks for access to nf_nat_l[34]protos[]
From:   Will McVicker <willmcvicker@google.com>
To:     security@kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Will McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The indexes to the nf_nat_l[34]protos arrays come from userspace. So we
need to make sure that before indexing the arrays, we verify the index
is within the array bounds in order to prevent an OOB memory access.
Here is an example kernel panic on 4.14.180 when userspace passes in an
index greater than NFPROTO_NUMPROTO.

Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:...
Process poc (pid: 5614, stack limit = 0x00000000a3933121)
CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
task: 000000002a3dfffe task.stack: 00000000a3933121
pc : __cfi_check_fail+0x1c/0x24
lr : __cfi_check_fail+0x1c/0x24
...
Call trace:
__cfi_check_fail+0x1c/0x24
name_to_dev_t+0x0/0x468
nfnetlink_parse_nat_setup+0x234/0x258
ctnetlink_parse_nat_setup+0x4c/0x228
ctnetlink_new_conntrack+0x590/0xc40
nfnetlink_rcv_msg+0x31c/0x4d4
netlink_rcv_skb+0x100/0x184
nfnetlink_rcv+0xf4/0x180
netlink_unicast+0x360/0x770
netlink_sendmsg+0x5a0/0x6a4
___sys_sendmsg+0x314/0x46c
SyS_sendmsg+0xb4/0x108
el0_svc_naked+0x34/0x38

Signed-off-by: Will McVicker <willmcvicker@google.com>
---
 net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |  6 ++++--
 net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |  5 +++--
 net/netfilter/nf_nat_core.c              | 27 ++++++++++++++++++++++--
 net/netfilter/nf_nat_helper.c            |  4 ++++
 4 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
index 6115bf1ff6f0..1912fc66147c 100644
--- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
+++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
@@ -218,7 +218,8 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 		return 1;
 
 	l4proto = __nf_nat_l4proto_find(NFPROTO_IPV4, inside->ip.protocol);
-	if (!nf_nat_ipv4_manip_pkt(skb, hdrlen + sizeof(inside->icmp),
+	if (!l4proto ||
+	    !nf_nat_ipv4_manip_pkt(skb, hdrlen + sizeof(inside->icmp),
 				   l4proto, &ct->tuplehash[!dir].tuple, !manip))
 		return 0;
 
@@ -234,7 +235,8 @@ int nf_nat_icmp_reply_translation(struct sk_buff *skb,
 	/* Change outer to look like the reply to an incoming packet */
 	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
 	l4proto = __nf_nat_l4proto_find(NFPROTO_IPV4, 0);
-	if (!nf_nat_ipv4_manip_pkt(skb, 0, l4proto, &target, manip))
+	if (!l4proto ||
+	    !nf_nat_ipv4_manip_pkt(skb, 0, l4proto, &target, manip))
 		return 0;
 
 	return 1;
diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
index ca6d38698b1a..a72840baf27b 100644
--- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
@@ -228,7 +228,8 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 		return 1;
 
 	l4proto = __nf_nat_l4proto_find(NFPROTO_IPV6, inside->ip6.nexthdr);
-	if (!nf_nat_ipv6_manip_pkt(skb, hdrlen + sizeof(inside->icmp6),
+	if (!l4proto ||
+	    !nf_nat_ipv6_manip_pkt(skb, hdrlen + sizeof(inside->icmp6),
 				   l4proto, &ct->tuplehash[!dir].tuple, !manip))
 		return 0;
 
@@ -245,7 +246,7 @@ int nf_nat_icmpv6_reply_translation(struct sk_buff *skb,
 
 	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
 	l4proto = __nf_nat_l4proto_find(NFPROTO_IPV6, IPPROTO_ICMPV6);
-	if (!nf_nat_ipv6_manip_pkt(skb, 0, l4proto, &target, manip))
+	if (!l4proto || !nf_nat_ipv6_manip_pkt(skb, 0, l4proto, &target, manip))
 		return 0;
 
 	return 1;
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2268b10a9dcf..d28185f38955 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -64,12 +64,16 @@ struct nat_net {
 inline const struct nf_nat_l3proto *
 __nf_nat_l3proto_find(u8 family)
 {
+	if (family >= NFPROTO_NUMPROTO)
+		return NULL;
 	return rcu_dereference(nf_nat_l3protos[family]);
 }
 
 inline const struct nf_nat_l4proto *
 __nf_nat_l4proto_find(u8 family, u8 protonum)
 {
+	if (family >= NFPROTO_NUMPROTO)
+		return NULL;
 	return rcu_dereference(nf_nat_l4protos[family][protonum]);
 }
 EXPORT_SYMBOL_GPL(__nf_nat_l4proto_find);
@@ -317,7 +321,7 @@ find_best_ips_proto(const struct nf_conntrack_zone *zone,
  * range. It might not be possible to get a unique tuple, but we try.
  * At worst (or if we race), we will end up with a final duplicate in
  * __ip_conntrack_confirm and drop the packet. */
-static void
+static int
 get_unique_tuple(struct nf_conntrack_tuple *tuple,
 		 const struct nf_conntrack_tuple *orig_tuple,
 		 const struct nf_nat_range2 *range,
@@ -328,13 +332,22 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	const struct nf_nat_l3proto *l3proto;
 	const struct nf_nat_l4proto *l4proto;
 	struct net *net = nf_ct_net(ct);
+	int ret = 0;
 
 	zone = nf_ct_zone(ct);
 
 	rcu_read_lock();
 	l3proto = __nf_nat_l3proto_find(orig_tuple->src.l3num);
+	if (!l3proto) {
+		ret = -EINVAL;
+		goto out;
+	}
 	l4proto = __nf_nat_l4proto_find(orig_tuple->src.l3num,
 					orig_tuple->dst.protonum);
+	if (!l4proto) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	/* 1) If this srcip/proto/src-proto-part is currently mapped,
 	 * and that same mapping gives a unique tuple within the given
@@ -387,6 +400,7 @@ get_unique_tuple(struct nf_conntrack_tuple *tuple,
 	l4proto->unique_tuple(l3proto, tuple, range, maniptype, ct);
 out:
 	rcu_read_unlock();
+	return ret;
 }
 
 struct nf_conn_nat *nf_ct_nat_ext_add(struct nf_conn *ct)
@@ -409,6 +423,7 @@ nf_nat_setup_info(struct nf_conn *ct,
 {
 	struct net *net = nf_ct_net(ct);
 	struct nf_conntrack_tuple curr_tuple, new_tuple;
+	int err;
 
 	/* Can't setup nat info for confirmed ct. */
 	if (nf_ct_is_confirmed(ct))
@@ -428,7 +443,9 @@ nf_nat_setup_info(struct nf_conn *ct,
 	nf_ct_invert_tuplepr(&curr_tuple,
 			     &ct->tuplehash[IP_CT_DIR_REPLY].tuple);
 
-	get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
+	err = get_unique_tuple(&new_tuple, &curr_tuple, range, ct, maniptype);
+	if (err < 0)
+		return NF_DROP;
 
 	if (!nf_ct_tuple_equal(&new_tuple, &curr_tuple)) {
 		struct nf_conntrack_tuple reply;
@@ -509,8 +526,12 @@ static unsigned int nf_nat_manip_pkt(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_invert_tuplepr(&target, &ct->tuplehash[!dir].tuple);
 
 	l3proto = __nf_nat_l3proto_find(target.src.l3num);
+	if (!l3proto)
+		return NF_DROP;
 	l4proto = __nf_nat_l4proto_find(target.src.l3num,
 					target.dst.protonum);
+	if (!l4proto)
+		return NF_DROP;
 	if (!l3proto->manip_pkt(skb, 0, l4proto, &target, mtype))
 		return NF_DROP;
 
@@ -816,6 +837,8 @@ static int nfnetlink_parse_nat_proto(struct nlattr *attr,
 		return err;
 
 	l4proto = __nf_nat_l4proto_find(nf_ct_l3num(ct), nf_ct_protonum(ct));
+	if (!l4proto)
+		return -EINVAL;
 	if (l4proto->nlattr_to_range)
 		err = l4proto->nlattr_to_range(tb, range);
 
diff --git a/net/netfilter/nf_nat_helper.c b/net/netfilter/nf_nat_helper.c
index 99606baedda4..6f694444137e 100644
--- a/net/netfilter/nf_nat_helper.c
+++ b/net/netfilter/nf_nat_helper.c
@@ -121,6 +121,8 @@ bool __nf_nat_mangle_tcp_packet(struct sk_buff *skb,
 	datalen = skb->len - protoff;
 
 	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
+	if (!l3proto)
+		return false;
 	l3proto->csum_recalc(skb, IPPROTO_TCP, tcph, &tcph->check,
 			     datalen, oldlen);
 
@@ -179,6 +181,8 @@ nf_nat_mangle_udp_packet(struct sk_buff *skb,
 		return true;
 
 	l3proto = __nf_nat_l3proto_find(nf_ct_l3num(ct));
+	if (!l3proto)
+		return false;
 	l3proto->csum_recalc(skb, IPPROTO_UDP, udph, &udph->check,
 			     datalen, oldlen);
 
-- 
2.28.0.rc0.142.g3c755180ce-goog

