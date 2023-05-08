Return-Path: <netdev+bounces-911-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D87DC6FB591
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91BFC280F4A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 16:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4E8B53AE;
	Mon,  8 May 2023 16:53:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C962C20F9
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 16:53:28 +0000 (UTC)
Received: from smtp.smtpout.orange.fr (smtp-25.smtpout.orange.fr [80.12.242.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C7D649DC
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 09:53:25 -0700 (PDT)
Received: from pop-os.home ([86.243.2.178])
	by smtp.orange.fr with ESMTPA
	id w46xpAkeMfMwtw46xpf0cB; Mon, 08 May 2023 18:53:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1683564803;
	bh=lm5x+NwYR0+zI73AdgqIwZ7OxGK1VHk4xnXiyrCtxyI=;
	h=From:To:Cc:Subject:Date;
	b=TffSdUf8plGRs/fzLhYW2m+zoyex7bE0y+J2jIt9i6EFeFdGap/wrfNTUt4hfOAD4
	 6hg7Rja0JgT98UjFX9lI6MgVAXfJiboQ01sQiV+qLQimAy6cwkQKY4Adg1/3BvV1Eq
	 Pe2qRSRCcKRv9jmq52vGIYVZpSvXRPAVQNa7qo7RBmglCKs8YvpWqTe7RaUhZ1sDfD
	 wGtE1gdhkYosYQlcn9jhjeQZUFOCPtfeyVpTuH7P/eqkdcw16IU/pllrekehtUXHme
	 iXKoxhMMWioWmwV/MGsDSmDLJ6df2NpYxfqA+pMTxJE1OyRoc3lrMQ2+6zh42oqw8s
	 9ZxmWry12MF5g==
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 08 May 2023 18:53:23 +0200
X-ME-IP: 86.243.2.178
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: [PATCH net-next] netfilter: Reorder fields in 'struct nf_conntrack_expect'
Date: Mon,  8 May 2023 18:53:14 +0200
Message-Id: <5cdb1f50f2e9dc80dbf86cf8667056eacfd36a09.1683564754.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Group some variables based on their sizes to reduce holes.
On x86_64, this shrinks the size of 'struct nf_conntrack_expect' from 264
to 256 bytes.

This structure deserve a dedicated cache, so reducing its size looks nice.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Using pahole

Before:
======
struct nf_conntrack_expect {
	struct hlist_node          lnode;                /*     0    16 */
	struct hlist_node          hnode;                /*    16    16 */
	struct nf_conntrack_tuple  tuple;                /*    32    40 */
	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
	struct nf_conntrack_tuple_mask mask;             /*    72    20 */

	/* XXX 4 bytes hole, try to pack */

	void                       (*expectfn)(struct nf_conn *, struct nf_conntrack_expect *); /*    96     8 */
	struct nf_conntrack_helper * helper;             /*   104     8 */
	struct nf_conn *           master;               /*   112     8 */
	struct timer_list          timeout;              /*   120    88 */
	/* --- cacheline 3 boundary (192 bytes) was 16 bytes ago --- */
	refcount_t                 use;                  /*   208     4 */
	unsigned int               flags;                /*   212     4 */
	unsigned int               class;                /*   216     4 */
	union nf_inet_addr         saved_addr;           /*   220    16 */
	union nf_conntrack_man_proto saved_proto;        /*   236     2 */

	/* XXX 2 bytes hole, try to pack */

	enum ip_conntrack_dir      dir;                  /*   240     4 */

	/* XXX 4 bytes hole, try to pack */

	struct callback_head       rcu __attribute__((__aligned__(8))); /*   248    16 */

	/* size: 264, cachelines: 5, members: 15 */
	/* sum members: 254, holes: 3, sum holes: 10 */
	/* forced alignments: 1, forced holes: 1, sum forced holes: 4 */
	/* last cacheline: 8 bytes */
} __attribute__((__aligned__(8)));


After:
=====
struct nf_conntrack_expect {
	struct hlist_node          lnode;                /*     0    16 */
	struct hlist_node          hnode;                /*    16    16 */
	struct nf_conntrack_tuple  tuple;                /*    32    40 */
	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
	struct nf_conntrack_tuple_mask mask;             /*    72    20 */
	refcount_t                 use;                  /*    92     4 */
	unsigned int               flags;                /*    96     4 */
	unsigned int               class;                /*   100     4 */
	void                       (*expectfn)(struct nf_conn *, struct nf_conntrack_expect *); /*   104     8 */
	struct nf_conntrack_helper * helper;             /*   112     8 */
	struct nf_conn *           master;               /*   120     8 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	struct timer_list          timeout;              /*   128    88 */
	/* --- cacheline 3 boundary (192 bytes) was 24 bytes ago --- */
	union nf_inet_addr         saved_addr;           /*   216    16 */
	union nf_conntrack_man_proto saved_proto;        /*   232     2 */

	/* XXX 2 bytes hole, try to pack */

	enum ip_conntrack_dir      dir;                  /*   236     4 */
	struct callback_head       rcu __attribute__((__aligned__(8))); /*   240    16 */

	/* size: 256, cachelines: 4, members: 15 */
	/* sum members: 254, holes: 1, sum holes: 2 */
	/* forced alignments: 1 */
} __attribute__((__aligned__(8)));
---
 include/net/netfilter/nf_conntrack_expect.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_expect.h b/include/net/netfilter/nf_conntrack_expect.h
index 0855b60fba17..cf0d81be5a96 100644
--- a/include/net/netfilter/nf_conntrack_expect.h
+++ b/include/net/netfilter/nf_conntrack_expect.h
@@ -26,6 +26,15 @@ struct nf_conntrack_expect {
 	struct nf_conntrack_tuple tuple;
 	struct nf_conntrack_tuple_mask mask;
 
+	/* Usage count. */
+	refcount_t use;
+
+	/* Flags */
+	unsigned int flags;
+
+	/* Expectation class */
+	unsigned int class;
+
 	/* Function to call after setup and insertion */
 	void (*expectfn)(struct nf_conn *new,
 			 struct nf_conntrack_expect *this);
@@ -39,15 +48,6 @@ struct nf_conntrack_expect {
 	/* Timer function; deletes the expectation. */
 	struct timer_list timeout;
 
-	/* Usage count. */
-	refcount_t use;
-
-	/* Flags */
-	unsigned int flags;
-
-	/* Expectation class */
-	unsigned int class;
-
 #if IS_ENABLED(CONFIG_NF_NAT)
 	union nf_inet_addr saved_addr;
 	/* This is the original per-proto part, used to map the
-- 
2.34.1


