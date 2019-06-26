Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D71656820
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfFZMBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:01:13 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35518 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfFZMBJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 08:01:09 -0400
Received: by mail-wm1-f66.google.com with SMTP id c6so1836805wml.0
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 05:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7qDwGd3c4sCeMFAHDkfhj5K9wEcGkgb2UjwAg5DULeM=;
        b=eeTG0w9CT9gOGjHPMGWI+9YQEodVniHH8P0VXgJkiLr4++9XObLSA58+crSD1te9ZT
         KGoGmj589qHciQmsGacOhJvmk9tGurUjDkKlzFiXbc/jZN6PZ7HsOV0+RxB0qrXpSULB
         6i7zQn4wfiNgxe7pXcM6uNPvOpX9bfmMJffUw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7qDwGd3c4sCeMFAHDkfhj5K9wEcGkgb2UjwAg5DULeM=;
        b=nDglhimf8bla/I958NqY37ck//NKtdSgur9sMObAAJEeVTJ7Ej4nO97O/bqn75NX86
         dSFpv63e46UbKZs+orYCpElPoRVUooim63bd3lGDjHt1KwE0PxC1Bv6Tcz+IxuqmhH5S
         ZhhpEmWCYfmtjq6KslDE+7xcRwWfIb5bfsyrsrMWhZOVXci/pAO0KVywNuxw6FB23wHD
         fKQkIRCPpWlTZF7HixVdBk8qpiyYW2Dc8aPaESktEbehhPGbaApSlmKdXFIToVrkoBNu
         Skj6r1zj8C3lujnScAyf3I60/zgx30HXQJT/D6qFZ0NCiLilJhNBys2BLRCddFhUZ2i+
         922Q==
X-Gm-Message-State: APjAAAXnVRnrzTY8cnN9cfOFON8s7rkAVYzO9HtXewciCT2r+P4aFnZ3
        KoSJOZ8YUnGCTim85TfKAJnWaOUuMeU=
X-Google-Smtp-Source: APXvYqwx+/iGub3M6V6nApiz4nq4pt17vBYkg6boSXqPOsJqjZYXxwE1km0RXVIckI8/2glKAKYxNg==
X-Received: by 2002:a1c:c145:: with SMTP id r66mr2497082wmf.139.1561550467026;
        Wed, 26 Jun 2019 05:01:07 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id f190sm1676818wmg.13.2019.06.26.05.01.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 05:01:06 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next 4/5] net: sched: em_ipt: keep the user-specified nfproto and use it
Date:   Wed, 26 Jun 2019 14:58:54 +0300
Message-Id: <20190626115855.13241-5-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
References: <20190626115855.13241-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For NFPROTO_UNSPEC xt_matches there's no way to restrict the matching to a
specific family, in order to do so we record the user-specified family
and later enforce it while doing the match.

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/sched/em_ipt.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index d4257f5f1d94..cfb93ce340da 100644
--- a/net/sched/em_ipt.c
+++ b/net/sched/em_ipt.c
@@ -21,6 +21,7 @@
 struct em_ipt_match {
 	const struct xt_match *match;
 	u32 hook;
+	u8 nfproto;
 	u8 match_data[0] __aligned(8);
 };
 
@@ -115,6 +116,7 @@ static int em_ipt_change(struct net *net, void *data, int data_len,
 	struct em_ipt_match *im = NULL;
 	struct xt_match *match;
 	int mdata_len, ret;
+	u8 nfproto;
 
 	ret = nla_parse_deprecated(tb, TCA_EM_IPT_MAX, data, data_len,
 				   em_ipt_policy, NULL);
@@ -125,6 +127,16 @@ static int em_ipt_change(struct net *net, void *data, int data_len,
 	    !tb[TCA_EM_IPT_MATCH_DATA] || !tb[TCA_EM_IPT_NFPROTO])
 		return -EINVAL;
 
+	nfproto = nla_get_u8(tb[TCA_EM_IPT_NFPROTO]);
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+	case NFPROTO_UNSPEC:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	match = get_xt_match(tb);
 	if (IS_ERR(match)) {
 		pr_err("unable to load match\n");
@@ -140,6 +152,7 @@ static int em_ipt_change(struct net *net, void *data, int data_len,
 
 	im->match = match;
 	im->hook = nla_get_u32(tb[TCA_EM_IPT_HOOK]);
+	im->nfproto = nfproto;
 	nla_memcpy(im->match_data, tb[TCA_EM_IPT_MATCH_DATA], mdata_len);
 
 	ret = check_match(net, im, mdata_len);
@@ -187,16 +200,16 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 
 	switch (tc_skb_protocol(skb)) {
 	case htons(ETH_P_IP):
-		if (im->match->family != NFPROTO_UNSPEC &&
-		    im->match->family != NFPROTO_IPV4)
+		if (im->nfproto != NFPROTO_UNSPEC &&
+		    im->nfproto != NFPROTO_IPV4)
 			return 0;
 		if (!pskb_network_may_pull(skb, sizeof(struct iphdr)))
 			return 0;
 		state.pf = NFPROTO_IPV4;
 		break;
 	case htons(ETH_P_IPV6):
-		if (im->match->family != NFPROTO_UNSPEC &&
-		    im->match->family != NFPROTO_IPV6)
+		if (im->nfproto != NFPROTO_UNSPEC &&
+		    im->nfproto != NFPROTO_IPV6)
 			return 0;
 		if (!pskb_network_may_pull(skb, sizeof(struct ipv6hdr)))
 			return 0;
@@ -234,7 +247,7 @@ static int em_ipt_dump(struct sk_buff *skb, struct tcf_ematch *em)
 		return -EMSGSIZE;
 	if (nla_put_u8(skb, TCA_EM_IPT_MATCH_REVISION, im->match->revision) < 0)
 		return -EMSGSIZE;
-	if (nla_put_u8(skb, TCA_EM_IPT_NFPROTO, im->match->family) < 0)
+	if (nla_put_u8(skb, TCA_EM_IPT_NFPROTO, im->nfproto) < 0)
 		return -EMSGSIZE;
 	if (nla_put(skb, TCA_EM_IPT_MATCH_DATA,
 		    im->match->usersize ?: im->match->matchsize,
-- 
2.20.1

