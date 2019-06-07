Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6353538E9A
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbfFGPK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729586AbfFGPJn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 11:09:43 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C04721473;
        Fri,  7 Jun 2019 15:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559920183;
        bh=u/mOVGBsNkn28ZYrN5uLf2fw0hIa/okUOO0O32rtkK4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNYRfkhTmfmU16fNixYNDXFhLa/rpOBYNGTLPMTygqxcnVNn1kuXVysWIlQZBhP2j
         Ufz62RpQYmafIKeJJfwqruMof1U0Cxp8hy1L+XmHdqzO4hCQGvIf2Rd9RrTU7BlrU8
         BiG8ZHCME54VpprFRkkbWyWZzvRwHZWXUiOuzUQQ=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 net-next 04/20] ipv6: Handle all fib6_nh in a nexthop in __find_rr_leaf
Date:   Fri,  7 Jun 2019 08:09:25 -0700
Message-Id: <20190607150941.11371-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190607150941.11371-1-dsahern@kernel.org>
References: <20190607150941.11371-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Add a hook in __find_rr_leaf to handle nexthop struct in a fib6_info.
nexthop_for_each_fib6_nh is used to walk each fib6_nh in a nexthop and
call find_match. On a match, use the fib6_nh saved in the callback arg
to setup fib6_result.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/route.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 8cb59554c023..0ba867dd1ba0 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -769,6 +769,24 @@ static bool find_match(struct fib6_nh *nh, u32 fib6_flags,
 	return rc;
 }
 
+struct fib6_nh_frl_arg {
+	u32		flags;
+	int		oif;
+	int		strict;
+	int		*mpri;
+	bool		*do_rr;
+	struct fib6_nh	*nh;
+};
+
+static int rt6_nh_find_match(struct fib6_nh *nh, void *_arg)
+{
+	struct fib6_nh_frl_arg *arg = _arg;
+
+	arg->nh = nh;
+	return find_match(nh, arg->flags, arg->oif, arg->strict,
+			  arg->mpri, arg->do_rr);
+}
+
 static void __find_rr_leaf(struct fib6_info *f6i_start,
 			   struct fib6_info *nomatch, u32 metric,
 			   struct fib6_result *res, struct fib6_info **cont,
@@ -779,6 +797,7 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
 	for (f6i = f6i_start;
 	     f6i && f6i != nomatch;
 	     f6i = rcu_dereference(f6i->fib6_next)) {
+		bool matched = false;
 		struct fib6_nh *nh;
 
 		if (cont && f6i->fib6_metric != metric) {
@@ -789,8 +808,34 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
 		if (fib6_check_expired(f6i))
 			continue;
 
-		nh = f6i->fib6_nh;
-		if (find_match(nh, f6i->fib6_flags, oif, strict, mpri, do_rr)) {
+		if (unlikely(f6i->nh)) {
+			struct fib6_nh_frl_arg arg = {
+				.flags  = f6i->fib6_flags,
+				.oif    = oif,
+				.strict = strict,
+				.mpri   = mpri,
+				.do_rr  = do_rr
+			};
+
+			if (nexthop_is_blackhole(f6i->nh)) {
+				res->fib6_flags = RTF_REJECT;
+				res->fib6_type = RTN_BLACKHOLE;
+				res->f6i = f6i;
+				res->nh = nexthop_fib6_nh(f6i->nh);
+				return;
+			}
+			if (nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_find_match,
+						     &arg)) {
+				matched = true;
+				nh = arg.nh;
+			}
+		} else {
+			nh = f6i->fib6_nh;
+			if (find_match(nh, f6i->fib6_flags, oif, strict,
+				       mpri, do_rr))
+				matched = true;
+		}
+		if (matched) {
 			res->f6i = f6i;
 			res->nh = nh;
 			res->fib6_flags = f6i->fib6_flags;
-- 
2.11.0

