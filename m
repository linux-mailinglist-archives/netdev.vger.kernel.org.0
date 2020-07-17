Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69913223412
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 08:26:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbgGQG0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 02:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbgGQGY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 02:24:27 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53601C061755;
        Thu, 16 Jul 2020 23:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=ke6IxwSs5p7KD2PfPxkYUwJA5rYh272J6EZhbIQy4kY=; b=MxaBf8IdG4oPd47UVm2tZXLlpY
        Lj0kUlQbB1ZRjYfxYtQJbE06uDcQv69Ai/DLwk1bpkRfuf/Jq2/MAFkOdGdxJ7JwVqrTQ6cHzbbES
        UpuJYyT7FeWfdFe32t9OAbw443Y8bublO9rfbU+CPORFb/g2qc+AjGx3JIwnE+HGZpVuzkFNCu/TT
        BWIKQP4tO2HncJuy0u9oLDaTS42Z+rtg9RxsA4/Po+C8o5jRFn7lUt0oFhBTgcPr6Le1Bsj9sY6G9
        kTZ7bSAsM4ou68NnoUCrRR1I/mOtGV8h6aLpoiA3nDRrdKTCaI6dqv7MW45Lkr00tnDxSDW82t9zb
        q7aZii2Q==;
Received: from [2001:4bb8:105:4a81:3772:912d:640:e6c6] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jwJn6-00054N-1B; Fri, 17 Jul 2020 06:24:16 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chas Williams <3chas3@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-wpan@vger.kernel.org, mptcp@lists.01.org
Subject: [PATCH 13/22] netfilter: split nf_sockopt
Date:   Fri, 17 Jul 2020 08:23:22 +0200
Message-Id: <20200717062331.691152-14-hch@lst.de>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200717062331.691152-1-hch@lst.de>
References: <20200717062331.691152-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Split nf_sockopt into a getsockopt and setsockopt side as they share
very little code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 net/netfilter/nf_sockopt.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

diff --git a/net/netfilter/nf_sockopt.c b/net/netfilter/nf_sockopt.c
index 02870993d335c9..90469b1f628a8e 100644
--- a/net/netfilter/nf_sockopt.c
+++ b/net/netfilter/nf_sockopt.c
@@ -89,36 +89,32 @@ static struct nf_sockopt_ops *nf_sockopt_find(struct sock *sk, u_int8_t pf,
 	return ops;
 }
 
-/* Call get/setsockopt() */
-static int nf_sockopt(struct sock *sk, u_int8_t pf, int val,
-		      char __user *opt, int *len, int get)
+int nf_setsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
+		  unsigned int len)
 {
 	struct nf_sockopt_ops *ops;
 	int ret;
 
-	ops = nf_sockopt_find(sk, pf, val, get);
+	ops = nf_sockopt_find(sk, pf, val, 0);
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
-
-	if (get)
-		ret = ops->get(sk, val, opt, len);
-	else
-		ret = ops->set(sk, val, opt, *len);
-
+	ret = ops->set(sk, val, opt, len);
 	module_put(ops->owner);
 	return ret;
 }
-
-int nf_setsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
-		  unsigned int len)
-{
-	return nf_sockopt(sk, pf, val, opt, &len, 0);
-}
 EXPORT_SYMBOL(nf_setsockopt);
 
 int nf_getsockopt(struct sock *sk, u_int8_t pf, int val, char __user *opt,
 		  int *len)
 {
-	return nf_sockopt(sk, pf, val, opt, len, 1);
+	struct nf_sockopt_ops *ops;
+	int ret;
+
+	ops = nf_sockopt_find(sk, pf, val, 1);
+	if (IS_ERR(ops))
+		return PTR_ERR(ops);
+	ret = ops->get(sk, val, opt, len);
+	module_put(ops->owner);
+	return ret;
 }
 EXPORT_SYMBOL(nf_getsockopt);
-- 
2.27.0

