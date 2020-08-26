Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975ED252543
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 03:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgHZBur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 21:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726818AbgHZBt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 21:49:56 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1723CC061756
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:56 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b18so159034wrs.7
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 18:49:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=googlenew;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p4z/80YMT7r/2XPt+q1H560KQo/33xQgEXp21sNkmO4=;
        b=pJhf4HaYxbpq0Az8ZRTtZewR7KRrnMlpRJJoVod4OUsQFPPO6h94qY2T7lCXbJnc2J
         rOc9KDyeB5iL735kUZS7QLrwf2/gjG6msLAUUOsGFDmcayGsXM+3En+n++2Er7TUdozq
         pjztsU65wqrb7nPJGhk8yJINiN+yF+ygjNSUgwXe0292sGzHwsKhhJaxFFkIxVwTGbpg
         zyKGGrPADDRZUr88pEKElho+Zk+F7chW+zFHVQKG6jsQHIZhom1X/t++zZkWF99rLdMQ
         98Aw6iziI/KubH6D91LkfdGDT0FzsZiSv3H7O+idoIAWIL5dNz4c8QmAouazotBBITtb
         zU3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p4z/80YMT7r/2XPt+q1H560KQo/33xQgEXp21sNkmO4=;
        b=C/4n6LuSvKU4nd9UaLX1JZRYs9x3YmNAJUzFQWePAPLgF3fHxAhnGZCiBxsDZG++xs
         zi/BmAZD3BuimVTQC10E/B/l8Hg99U2s2ufsselrTMlx+myfWn2ybe3JPLj4LZ1OdbZO
         XQDKuj9rHr3bnt/0VBbZhlTrrA9b30Yf7isX9YmnsWIQSsRh1OBVYRgieZ3U/vbe68Dp
         VVMgPEuZGn6bX4/bkfsIR8i8GcsGQQhtXcMpHCxmxihVpMLr8xDM79otCK072T/aqcW+
         63esMCR7pbz8xwFfOPepduKbD32qJiY8DMAC5foF3m9eSd11kcy4WAuekzZfTMwN7+G7
         BgFA==
X-Gm-Message-State: AOAM530M4IgFnfcKGxeOuJC69RHYQPwHu+XwVXd/WPQqpbRVHFjOKQi5
        TEIjGr6xYP9HNXtcztZqgmtRDw==
X-Google-Smtp-Source: ABdhPJwLo0u0fGc8+tWN58LJlQ1Cdd8blAm5no4gadCnQY3WbtMGLn97rB4tU1ljN5J2HQQYr6DiuQ==
X-Received: by 2002:adf:9ec5:: with SMTP id b5mr12277714wrf.190.1598406594695;
        Tue, 25 Aug 2020 18:49:54 -0700 (PDT)
Received: from localhost.localdomain ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id c10sm1263661wmk.30.2020.08.25.18.49.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2020 18:49:54 -0700 (PDT)
From:   Dmitry Safonov <dima@arista.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dmitry Safonov <0x7f454c46@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Stephen Suryaputra <ssuryaextr@gmail.com>,
        netdev@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 3/6] netlink/compat: Append NLMSG_DONE/extack to frag_list
Date:   Wed, 26 Aug 2020 02:49:46 +0100
Message-Id: <20200826014949.644441-4-dima@arista.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200826014949.644441-1-dima@arista.com>
References: <20200826014949.644441-1-dima@arista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/netlink/af_netlink.c | 48 ++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 14 deletions(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index b5f30d7d30d0..b096f2b4a50d 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2186,13 +2186,36 @@ EXPORT_SYMBOL(__nlmsg_put);
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
+	memcpy(nlmsg_data(nlh), &nlk->dump_done_errno,
+			sizeof(nlk->dump_done_errno));
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
@@ -2258,22 +2281,19 @@ static int netlink_dump(struct sock *sk)
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
2.27.0

