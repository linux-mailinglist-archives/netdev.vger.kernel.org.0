Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE8F5A8E9F
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233370AbiIAGtG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiIAGtE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:49:04 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB37912E4FA
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 23:49:02 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id c66so6371038pfc.10
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 23:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=ZN0wlf/8I2US3eM7pqsH0yFkY6GDu2IDTHDWieRp2po=;
        b=X/CJF0Tr5QeNRrDvXvoVRBol7+/ExtpCIaUOem2xX6N7aXB60RtHYcKxwjMH6Vty9F
         NOQvGNdQVhvTFtGDc8xAODwnJvcxAxQyjyHd7InhTwWL9bZeIVFGpCBq76Rqb5hvYFJ8
         zcomzqblXd+aht5XULk69wevTCaYmnptDe7mg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=ZN0wlf/8I2US3eM7pqsH0yFkY6GDu2IDTHDWieRp2po=;
        b=M59yjZLL+bvg4qcGsUg9wOqsPZyiMlkIs88NCC1QjzaseBfD3FHT1lfqIROGm7UYt+
         dQNJxNnMo4+k3wcNNN2Jhoylw+vYCdEJmBCMy33EVIA8g5Qo0vKwqUA+c7IPaoU6YW0U
         bRz/lGy8sc1+1xoRUaUizOaeueVnTUp2gnLoJcuFzVQZTQvvJakDc/0Lb9Op7sAQkuI2
         AdfGd3r/Z3p0diiEhGbXe2W5SdMoK5OjTRnxpv+GkUK9hZxfiVkIqQWnMO5OoqAbbeNs
         VCbdV+lqTPsvtGrFBUa92eyA9YFluLYTZEtfgR/ZAt9iP5ZShhrkx9yMwvJh391dKtQt
         fNGg==
X-Gm-Message-State: ACgBeo0anDiejbiiimzw61M2Hi5It1S2tlLMs1bEW0seU20lQuoYojDg
        WLQ+NGVAtXpJbMhMAPzk6Gxo2g==
X-Google-Smtp-Source: AA6agR5Q403qJEV6Lfi3M3NQrLbZNuHS84/xKnEfJUrk+AQUgpa/ica9Wop9P5cEQBd2i673E/jetg==
X-Received: by 2002:a63:6e09:0:b0:430:663:7757 with SMTP id j9-20020a636e09000000b0043006637757mr7319766pgc.340.1662014942305;
        Wed, 31 Aug 2022 23:49:02 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w8-20020a1709026f0800b00172c298ba42sm1183219plk.28.2022.08.31.23.49.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 23:49:01 -0700 (PDT)
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
        netdev@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] netlink: Bounds-check struct nlmsgerr creation
Date:   Wed, 31 Aug 2022 23:48:58 -0700
Message-Id: <20220901064858.1417126-1-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5452; h=from:subject; bh=8yuSgL8t29LfBBmN/bpYmo03naVR7KsUIBiIJrZifO0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBjEFXZHG0g03slkKZAfp1i1tVcHkNwSK+Q/MIEK8Pi 0ZNnt3CJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYxBV2QAKCRCJcvTf3G3AJsmiD/ wJTp0r9y/BO4058/6vDENLnnoGFoC+r21uBcF3NIhXeMOmdPmT2z9jj/0KG7fE9ioheBknqClFywq5 tzEXntFpVSgzz/ve19Xc+0GrRFu5sC/n6eFFpOAtutaBFPngsQl9xLS4U15U5SSOMkiN0XGITpqqUK gL871NId+UsPPuWpbcX413rgxFFT30ekWQElg8UKlScStGzKygaTuK+sa7C9pCyQMxg0SlSIvL8DOp AXWHH6UQtq5/gTT5/Se3VXmcH+iMgEgj3sUtx/1QsImFoFqr0AxnvCeLOsZMR+bkRkEZGo5ID/Q9bA 1SwMFKbVDAXWvJyQS4zcajisUvZm5oLJnJb5xre2KPoS8LDg2c62xnzm/XJqfyDyWoRYEALpXuORGq Ix3Q2kg+E2vzGiQpfCvBasuyuY+lJyYWFIA4+fuRbK6DAsuqNshCU+0243DCrI3ctsRB7d0z8UQ4ji HHzNftkzyoOGhmbdEwBRkVTZ7rG83RwhkXU3tpv0TAyVG2mxG1XYABVgLB7RK/C7MyMoNVAI0go/PZ bh2YxAOUUHAHI7GrhPfA6anPg6Tpvb+dmGvBumWdnrf0+lnOM48U2J45XFwwLfkcxyDuzngsFmX6n4 fM0TxICZEQqj+oyBvM9k/i25vREXb98a0q9fhTORiJpGMayayLs+ZbALCohA==
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
v2: Rebased to -next
v1: https://lore.kernel.org/lkml/20220901030610.1121299-3-keescook@chromium.org
---
 net/netlink/af_netlink.c | 81 +++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 30 deletions(-)

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

