Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870C5280CFB
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 07:01:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgJBFB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 01:01:29 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:41946 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbgJBFB1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 01:01:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3B77D20501;
        Fri,  2 Oct 2020 07:01:26 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id fSpsQ2jFBXWu; Fri,  2 Oct 2020 07:01:25 +0200 (CEST)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D83BE204EF;
        Fri,  2 Oct 2020 07:01:24 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 2 Oct 2020 07:01:24 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Fri, 2 Oct 2020
 07:01:23 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 5740731845EA;
 Fri,  2 Oct 2020 07:01:23 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 4/7] netlink/compat: Append NLMSG_DONE/extack to frag_list
Date:   Fri, 2 Oct 2020 07:01:10 +0200
Message-ID: <20201002050113.2210-5-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201002050113.2210-1-steffen.klassert@secunet.com>
References: <20201002050113.2210-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

Modules those use netlink may supply a 2nd skb, (via frag_list)
that contains an alternative data set meant for applications
using 32bit compatibility mode.

In such a case, netlink_recvmsg will use this 2nd skb instead of the
original one.

Without this patch, such compat applications will retrieve
all netlink dump data, but will then get an unexpected EOF.

Cc: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/netlink/af_netlink.c | 47 ++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f9efd2c1cb50..56ade862662e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2186,13 +2186,35 @@ EXPORT_SYMBOL(__nlmsg_put);
  * It would be better to create kernel thread.
  */
 
+static int netlink_dump_done(struct netlink_sock *nlk, struct sk_buff *skb,
+			     struct netlink_callback *cb,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put_answer(skb, cb, NLMSG_DONE, sizeof(nlk->dump_done_errno),
+			       NLM_F_MULTI | cb->answer_flags);
+	if (WARN_ON(!nlh))
+		return -ENOBUFS;
+
+	nl_dump_check_consistent(cb, nlh);
+	memcpy(nlmsg_data(nlh), &nlk->dump_done_errno, sizeof(nlk->dump_done_errno));
+
+	if (extack->_msg && nlk->flags & NETLINK_F_EXT_ACK) {
+		nlh->nlmsg_flags |= NLM_F_ACK_TLVS;
+		if (!nla_put_string(skb, NLMSGERR_ATTR_MSG, extack->_msg))
+			nlmsg_end(skb, nlh);
+	}
+
+	return 0;
+}
+
 static int netlink_dump(struct sock *sk)
 {
 	struct netlink_sock *nlk = nlk_sk(sk);
 	struct netlink_ext_ack extack = {};
 	struct netlink_callback *cb;
 	struct sk_buff *skb = NULL;
-	struct nlmsghdr *nlh;
 	struct module *module;
 	int err = -ENOBUFS;
 	int alloc_min_size;
@@ -2258,22 +2280,19 @@ static int netlink_dump(struct sock *sk)
 		return 0;
 	}
 
-	nlh = nlmsg_put_answer(skb, cb, NLMSG_DONE,
-			       sizeof(nlk->dump_done_errno),
-			       NLM_F_MULTI | cb->answer_flags);
-	if (WARN_ON(!nlh))
+	if (netlink_dump_done(nlk, skb, cb, &extack))
 		goto errout_skb;
 
-	nl_dump_check_consistent(cb, nlh);
-
-	memcpy(nlmsg_data(nlh), &nlk->dump_done_errno,
-	       sizeof(nlk->dump_done_errno));
-
-	if (extack._msg && nlk->flags & NETLINK_F_EXT_ACK) {
-		nlh->nlmsg_flags |= NLM_F_ACK_TLVS;
-		if (!nla_put_string(skb, NLMSGERR_ATTR_MSG, extack._msg))
-			nlmsg_end(skb, nlh);
+#ifdef CONFIG_COMPAT_NETLINK_MESSAGES
+	/* frag_list skb's data is used for compat tasks
+	 * and the regular skb's data for normal (non-compat) tasks.
+	 * See netlink_recvmsg().
+	 */
+	if (unlikely(skb_shinfo(skb)->frag_list)) {
+		if (netlink_dump_done(nlk, skb_shinfo(skb)->frag_list, cb, &extack))
+			goto errout_skb;
 	}
+#endif
 
 	if (sk_filter(sk, skb))
 		kfree_skb(skb);
-- 
2.17.1

