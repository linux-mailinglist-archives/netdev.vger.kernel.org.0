Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3E03A251
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 00:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727914AbfFHWWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jun 2019 18:22:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:44484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727679AbfFHWWY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jun 2019 18:22:24 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B30821721;
        Sat,  8 Jun 2019 21:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560030824;
        bh=Yc5pCkMNNMBqJttn8+XK2KNFKrbMkTzC/rNQPmYUBGY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JkRF6on+K5dRLyDqe31rdQlsQ2keaOj6VkhLieQhmnKqHVAH/2FZUhrvabtvkpeA9
         5fdzk3sa/mSmtmOS6D7+2nEQesyNacKVlM1mBkQlqHFWuIo4UMiCUWy8C5IBvBVFd5
         9jD2INtfzlSUViFNEPagA9gcvlnx/kJ67FODYHas=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@mellanox.com, kafai@fb.com, weiwan@google.com,
        sbrivio@redhat.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH v4 net-next 04/20] ipv6: Handle all fib6_nh in a nexthop in __find_rr_leaf
Date:   Sat,  8 Jun 2019 14:53:25 -0700
Message-Id: <20190608215341.26592-5-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190608215341.26592-1-dsahern@kernel.org>
References: <20190608215341.26592-1-dsahern@kernel.org>
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
index aac209381903..740df725b9fc 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -765,6 +765,24 @@ static bool find_match(struct fib6_nh *nh, u32 fib6_flags,
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
@@ -775,6 +793,7 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
 	for (f6i = f6i_start;
 	     f6i && f6i != nomatch;
 	     f6i = rcu_dereference(f6i->fib6_next)) {
+		bool matched = false;
 		struct fib6_nh *nh;
 
 		if (cont && f6i->fib6_metric != metric) {
@@ -785,8 +804,34 @@ static void __find_rr_leaf(struct fib6_info *f6i_start,
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

