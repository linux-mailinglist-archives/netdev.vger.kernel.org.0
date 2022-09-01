Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5154B5A8F85
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233742AbiIAHOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233494AbiIAHOU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:14:20 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C97212486A
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 00:13:45 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id y141so16698446pfb.7
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 00:13:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ji1yguuJygsNwGdk0+egr8fSwQLEnYJ61odz+JVdIzc=;
        b=AtgKxHqF8qd5AeXxyEc8c97eQeXxKRJkkBI/Y5hzH0KSmC4DcTOMPW1wiHmYFtrw+/
         a0v82x4xX2L0oG6ThDaAH1xAZc9ii744jqK+60YiJEQESz0uuwEclhUESy3TYCaYVNE3
         tYSWOrZSs1dPMBl/UbzpkkRkldWydnME47Sss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ji1yguuJygsNwGdk0+egr8fSwQLEnYJ61odz+JVdIzc=;
        b=ywT2MbZzxj+RksftnyXN51lyw4j1ujw1hJTR1XtRk4jfb7zthTQL6mNE3HM0mzL4Y5
         dGO1cmQ09/7X6vtvp+Mi+2XhB6W1HnIQehtoMvCvAJI11BJ495LvDgziR4ftZpbluQly
         IK1NuUe62T+VkXq9X74mNbek2AYhs4xVA02RwHu3LMt7OZglmyTP7toTJA+MJ+OkWQqq
         j32Mlb6wqMtS45rLaYZJeeXrTt2/ZZB8/Ws14+SXe2CFg2FvBd2xWxsdqW6UQXdP8GeL
         TSkqDuqNmOz59UmvCuK4z7vdVG1QsC+HSI4HGtVuDqgq6IQQ6f8AlULZdo87Kgbx80Ix
         nSCQ==
X-Gm-Message-State: ACgBeo05c1dlbgNT3VabXN4S1V6QPPz9WQNOSM2Q09/PvSlT9v9P8oqN
        /F5DEwUynkHdeAbVAEtrxGjVyQ==
X-Google-Smtp-Source: AA6agR5Y43BFdDHFiN3oqTLC4PpU5LtMLbxGujI8Z5RxYqRoPwLWFV8UrvDcTynLK5iWMXS5whc/YA==
X-Received: by 2002:a63:8948:0:b0:430:3da6:7d45 with SMTP id v69-20020a638948000000b004303da67d45mr4555891pgd.109.1662016419362;
        Thu, 01 Sep 2022 00:13:39 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h187-20020a62dec4000000b00537aa0fbb57sm12654892pfg.51.2022.09.01.00.13.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 00:13:38 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        syzbot <syzkaller@googlegroups.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v3] netlink: Bounds-check struct nlmsgerr creation
Date:   Thu,  1 Sep 2022 00:13:36 -0700
Message-Id: <20220901071336.1418572-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6941; h=from:subject; bh=FNyKFk/4PsI7cC3QEEU2mAQQO3afv1KG6BW/MMNkv1U=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjEFuf7SIeB7tx5L9iUFI45uqnmg/ZRhzUxCFAAv03 30TcJMOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYxBbnwAKCRCJcvTf3G3AJl1CD/ 9op1SW4gH7T5WfFYz+cL/X7Ikfz0e7nQYha17lRzQL7kM2pQjEd+7LJ84dVllYQaonAi1NKCHjRXfD MUHYOkNn1/GNhINww1mhaxMqqIhO0/3VZh4z/TnWkOfViFkf7vOQdbJL3u7pUIdNrEWGJXJ5wDXRbT 3Mt6JEDdw3EqKStP8qykeUzavguM15jUw2MayYI+e5VXLpgx3jKuRqr2ZUzyO7JePYQhjwHqzVUhW0 a/AUspNyhRR/Kk1nFdTi0bYfqj0LBLbRiVxh20APhSNAs0tD7iGGEZ+jbxFZiJLoS7h+dvwaDNLupS NM9PxPMlDP3MXb1ZvKot6XSH9/YTRa7rl9EIU0b/ydH5n1vxSgEHjTwZD/W6juOUgdyvjEYQTZ7kJ3 VyZNtINz8eLJqEz7uGPNq+W9+VpZL96yv1m7AJ961HQYeZQWeTtNU3OaDhQpOnqPIdqnhj9xB5iLJr KJXvMV1mCbC26+Ed6SAmtqHJaDAvZmQxH0bbdSvIv/fNdFXIaAqTHj4U0STOnfNHDWUKU8+Ix0tKHk Qhhre1bknn2sSj4oYgDYSmJ444ezH7iWIq8/ZRq6OHHJQf2e6ovNtj5aquyW9+Js3iudl+UUgS8NgR ArM83WYJC+fAa//IcfNdr/njMuc6YsTiwfSApvXWMrEtfWYJ38/NOOSvH5dw==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For 32-bit systems, it might be possible to wrap lnmsgerr content
lengths beyond SIZE_MAX. Explicitly test for all overflows, and mark the
memcpy() as being unable to internally diagnose overflows.

This also excludes netlink from the coming runtime bounds check on
memcpy(), since it's an unusual case of open-coded sizing and
allocation. Avoid this future run-time warning:

  memcpy: detected field-spanning write (size 32) of single field "&errmsg->msg" at net/netlink/af_netlink.c:2447 (size 16)

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: syzbot <syzkaller@googlegroups.com>
Cc: netfilter-devel@vger.kernel.org
Cc: coreteam@netfilter.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v3: add back ip_set_core patch
v2: https://lore.kernel.org/lkml/20220901064858.1417126-1-keescook@chromium.org
v1: https://lore.kernel.org/lkml/20220901030610.1121299-3-keescook@chromium.org
---
 net/netfilter/ipset/ip_set_core.c | 10 ++--
 net/netlink/af_netlink.c          | 81 +++++++++++++++++++------------
 2 files changed, 58 insertions(+), 33 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
index 16ae92054baa..43576f68f53d 100644
--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1709,13 +1709,14 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 		struct nlmsghdr *rep, *nlh = nlmsg_hdr(skb);
 		struct sk_buff *skb2;
 		struct nlmsgerr *errmsg;
-		size_t payload = min(SIZE_MAX,
-				     sizeof(*errmsg) + nlmsg_len(nlh));
+		size_t payload;
 		int min_len = nlmsg_total_size(sizeof(struct nfgenmsg));
 		struct nlattr *cda[IPSET_ATTR_CMD_MAX + 1];
 		struct nlattr *cmdattr;
 		u32 *errline;
 
+		if (check_add_overflow(sizeof(*errmsg), nlmsg_len(nlh), &payload))
+			return -ENOMEM;
 		skb2 = nlmsg_new(payload, GFP_KERNEL);
 		if (!skb2)
 			return -ENOMEM;
@@ -1723,7 +1724,10 @@ call_ad(struct net *net, struct sock *ctnl, struct sk_buff *skb,
 				  nlh->nlmsg_seq, NLMSG_ERROR, payload, 0);
 		errmsg = nlmsg_data(rep);
 		errmsg->error = ret;
-		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
+		unsafe_memcpy(&errmsg->msg, nlh, nlh->nlmsg_len,
+			      /* "payload" was explicitly bounds-checked, based on
+			       * the size of nlh->nlmsg_len.
+			       */);
 		cmdattr = (void *)&errmsg->msg + min_len;
 
 		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index f89ba302ac6e..1285779d9ab6 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2400,35 +2400,44 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 }
 EXPORT_SYMBOL(__netlink_dump_start);
 
-static size_t
+/* Returns false on overflow */
+static bool __must_check
 netlink_ack_tlv_len(struct netlink_sock *nlk, int err,
-		    const struct netlink_ext_ack *extack)
+		    const struct netlink_ext_ack *extack,
+		    size_t *tlvlen)
 {
-	size_t tlvlen;
+	*tlvlen = 0;
 
 	if (!extack || !(nlk->flags & NETLINK_F_EXT_ACK))
-		return 0;
+		return true;
 
-	tlvlen = 0;
-	if (extack->_msg)
-		tlvlen += nla_total_size(strlen(extack->_msg) + 1);
-	if (extack->cookie_len)
-		tlvlen += nla_total_size(extack->cookie_len);
+	if (extack->_msg &&
+	    check_add_overflow(*tlvlen, nla_total_size(strlen(extack->_msg) + 1), tlvlen))
+		return false;
+
+	if (extack->cookie_len &&
+	    check_add_overflow(*tlvlen, nla_total_size(extack->cookie_len), tlvlen))
+		return false;
 
 	/* Following attributes are only reported as error (not warning) */
 	if (!err)
-		return tlvlen;
+		return true;
 
-	if (extack->bad_attr)
-		tlvlen += nla_total_size(sizeof(u32));
-	if (extack->policy)
-		tlvlen += netlink_policy_dump_attr_size_estimate(extack->policy);
-	if (extack->miss_type)
-		tlvlen += nla_total_size(sizeof(u32));
-	if (extack->miss_nest)
-		tlvlen += nla_total_size(sizeof(u32));
+	if (extack->bad_attr &&
+	    check_add_overflow(*tlvlen, nla_total_size(sizeof(u32)), tlvlen))
+		return false;
+	if (extack->policy &&
+	    check_add_overflow(*tlvlen, netlink_policy_dump_attr_size_estimate(extack->policy),
+			       tlvlen))
+		return false;
+	if (extack->miss_type &&
+	    check_add_overflow(*tlvlen, nla_total_size(sizeof(u32)), tlvlen))
+		return false;
+	if (extack->miss_nest &&
+	    check_add_overflow(*tlvlen, nla_total_size(sizeof(u32)), tlvlen))
+		return false;
 
-	return tlvlen;
+	return true;
 }
 
 static void
@@ -2472,33 +2481,39 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	size_t payload = sizeof(*errmsg);
 	struct netlink_sock *nlk = nlk_sk(NETLINK_CB(in_skb).sk);
 	unsigned int flags = 0;
-	size_t tlvlen;
+	size_t alloc_size, tlvlen = 0;
 
 	/* Error messages get the original request appened, unless the user
 	 * requests to cap the error message, and get extra error data if
 	 * requested.
 	 */
-	if (err && !(nlk->flags & NETLINK_F_CAP_ACK))
-		payload += nlmsg_len(nlh);
+	if (err && !(nlk->flags & NETLINK_F_CAP_ACK) &&
+	    check_add_overflow(payload, (size_t)nlmsg_len(nlh), &payload))
+		goto failure;
 	else
 		flags |= NLM_F_CAPPED;
 
-	tlvlen = netlink_ack_tlv_len(nlk, err, extack);
+	if (!netlink_ack_tlv_len(nlk, err, extack, &tlvlen))
+		goto failure;
 	if (tlvlen)
 		flags |= NLM_F_ACK_TLVS;
 
-	skb = nlmsg_new(payload + tlvlen, GFP_KERNEL);
-	if (!skb) {
-		NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
-		sk_error_report(NETLINK_CB(in_skb).sk);
-		return;
-	}
+	if (check_add_overflow(payload, tlvlen, &alloc_size))
+		goto failure;
+
+	skb = nlmsg_new(alloc_size, GFP_KERNEL);
+	if (!skb)
+		goto failure;
 
 	rep = __nlmsg_put(skb, NETLINK_CB(in_skb).portid, nlh->nlmsg_seq,
 			  NLMSG_ERROR, payload, flags);
 	errmsg = nlmsg_data(rep);
 	errmsg->error = err;
-	memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg) ? nlh->nlmsg_len : sizeof(*nlh));
+	unsafe_memcpy(&errmsg->msg, nlh, payload > sizeof(*errmsg)
+					 ?  nlh->nlmsg_len : sizeof(*nlh),
+		      /* "payload" was bounds checked against nlh->nlmsg_len,
+		       * and overflow-checked as tlvlen was constructed.
+		       */);
 
 	if (tlvlen)
 		netlink_ack_tlv_fill(in_skb, skb, nlh, err, extack);
@@ -2506,6 +2521,12 @@ void netlink_ack(struct sk_buff *in_skb, struct nlmsghdr *nlh, int err,
 	nlmsg_end(skb, rep);
 
 	nlmsg_unicast(in_skb->sk, skb, NETLINK_CB(in_skb).portid);
+	return;
+
+failure:
+	NETLINK_CB(in_skb).sk->sk_err = ENOBUFS;
+	sk_error_report(NETLINK_CB(in_skb).sk);
+	return;
 }
 EXPORT_SYMBOL(netlink_ack);
 
-- 
2.34.1

