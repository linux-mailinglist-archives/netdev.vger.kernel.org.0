Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5AA43195C
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 05:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfFADgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 23:36:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:51456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726713AbfFADgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 23:36:21 -0400
Received: from kenny.it.cumulusnetworks.com. (fw.cumulusnetworks.com [216.129.126.126])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 575E7270EA;
        Sat,  1 Jun 2019 03:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559360181;
        bh=mi/3mclhCpyIrqrAc+72JMuPVNYaMauW+2k9YnYf7zo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E8DW50s7Pu9a28WsShcQGxPDqiZzXXyAvLhVsmMzBbxQhxXisXCrYqqFmhZBVgBSA
         JmYRdZ1nnp+8NsKlgMaRkuR0k4g23BkIVC/e6eqYL4A0hT4JYxzmI/8tHMNehu9mSV
         FRzo0qNS4PYzIriRDvZ3EQPN01E6OF4/JdupFPzA=
From:   David Ahern <dsahern@kernel.org>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexei.starovoitov@gmail.com, David Ahern <dsahern@gmail.com>
Subject: [PATCH RFC net-next 08/27] nexthops: Add ipv6 helper to walk all fib6_nh in a nexthop struct
Date:   Fri, 31 May 2019 20:35:59 -0700
Message-Id: <20190601033618.27702-9-dsahern@kernel.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190601033618.27702-1-dsahern@kernel.org>
References: <20190601033618.27702-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

IPv6 has traditionally had a single fib6_nh per fib6_info. With
nexthops we can have multiple fib6_nh associated with a fib6_info.
Add a nexthop helper to invoke a callback for each fib6_nh in a
'struct nexthop'. If the callback returns non-0, the loop is
stopped and the return value passed to the caller.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/nexthop.h |  4 ++++
 net/ipv4/nexthop.c    | 31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index aff7b2410057..448249968903 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -305,4 +305,8 @@ static inline void nexthop_path_fib6_result(struct fib6_result *res, int hash)
 		res->nh = &nhi->fib6_nh;
 	}
 }
+
+int nexthop_for_each_fib6_nh(struct nexthop *nh,
+			     int (*cb)(struct fib6_nh *nh, void *arg),
+			     void *arg);
 #endif
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 5e48762b6b5f..6d1c8927e6d3 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -517,6 +517,37 @@ struct nexthop *nexthop_select_path(struct nexthop *nh, int hash)
 }
 EXPORT_SYMBOL_GPL(nexthop_select_path);
 
+int nexthop_for_each_fib6_nh(struct nexthop *nh,
+			     int (*cb)(struct fib6_nh *nh, void *arg),
+			     void *arg)
+{
+	struct nh_info *nhi;
+	int err;
+
+	if (nh->is_group) {
+		struct nh_group *nhg;
+		int i;
+
+		nhg = rcu_dereference_rtnl(nh->nh_grp);
+		for (i = 0; i < nhg->num_nh; ++i) {
+			struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+
+			nhi = rcu_dereference_rtnl(nhge->nh->nh_info);
+			err = cb(&nhi->fib6_nh, arg);
+			if (err)
+				return err;
+		}
+	} else {
+		nhi = rcu_dereference_rtnl(nh->nh_info);
+		err = cb(&nhi->fib6_nh, arg);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(nexthop_for_each_fib6_nh);
+
 int fib6_check_nexthop(struct nexthop *nh, struct fib6_config *cfg,
 		       struct netlink_ext_ack *extack)
 {
-- 
2.11.0

