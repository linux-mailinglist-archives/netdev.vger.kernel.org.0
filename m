Return-Path: <netdev+bounces-3554-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 34DD9707D9A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 12:09:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2356F1C21065
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:09:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9178C125C0;
	Thu, 18 May 2023 10:08:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87214125AA
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 10:08:19 +0000 (UTC)
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670981716;
	Thu, 18 May 2023 03:08:18 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1pzaYO-0005oB-61; Thu, 18 May 2023 12:08:12 +0200
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel <netfilter-devel@vger.kernel.org>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 4/9] netfilter: Reorder fields in 'struct nf_conntrack_expect'
Date: Thu, 18 May 2023 12:07:54 +0200
Message-Id: <20230518100759.84858-5-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518100759.84858-1-fw@strlen.de>
References: <20230518100759.84858-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Group some variables based on their sizes to reduce holes.
On x86_64, this shrinks the size of 'struct nf_conntrack_expect' from 264
to 256 bytes.

This structure deserve a dedicated cache, so reducing its size looks nice.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.40.1


