Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36BD556E26
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbfFZP4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 11:56:37 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43225 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726447AbfFZP4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 11:56:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so3316038wru.10
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 08:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3c4S6lo7RWwT0H7lp2yCDwGWt2YlM+1HaTguCzugqN4=;
        b=D5cQ5MApvjILwqiUFpXHcgI3StUnFjd6fNi1BHur5CAxtTCNDlBO05G+lgkgEaENVU
         KQj5oRq+Y3yHi7u+yDIjn4xPfaNwLQWRxQCL9Lp3NbiB7pyLNpq7OsXybYyh4oZqzVBF
         dckpBdkHYjOSf0sD6fkufhqNbo1GnNoGE1SD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3c4S6lo7RWwT0H7lp2yCDwGWt2YlM+1HaTguCzugqN4=;
        b=Pvgx3r2WBqkOsn6HGxXOJSvHLMs6iVpuhbAWOnjMLXw0z+SwRiAeB6r1r2W7wZhvgl
         tMBTMR038lMo67LggteMrvRhYaGEoUCz3sJkXgtS+nZzSq2QhdpjNq+JVLc2Zr/SAHE6
         xsomOTawRf2D7BFMyFFeffVU1OVOyMyfWz3fOYnU2664Cetjude5Vcs1l//fqJdLdBTz
         VRoXy6Srs7u0q5g7jEYOJSU7GHZ2+jSopH++eZRHQDN1+Uof3onsiQ95hwpg0jbRq3Pu
         eQcFv24yVZliauhgnUADq6r1YqJWOwk+tdDirQd2fYjLZhBnKFoZU0JZZGDuP2Ca7HT0
         6hsQ==
X-Gm-Message-State: APjAAAUVw1H3sZP1B025t8+A3IWiBiV1y+wlxoDpTZXfJUrG+9yQ8Leu
        AvXAoHHIiF0a1pzJ/aiH/erSgFhnx1E=
X-Google-Smtp-Source: APXvYqx86L5C7EAnWn/hDGJUtLZ3z0828Q+KHm+7Szh3Ae6/f+smY2Ra7ZjcYilOVjWMSC2WLXV4XQ==
X-Received: by 2002:adf:fb81:: with SMTP id a1mr3956791wrr.329.1561564591421;
        Wed, 26 Jun 2019 08:56:31 -0700 (PDT)
Received: from localhost.localdomain ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id h8sm1832556wmf.12.2019.06.26.08.56.30
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 08:56:30 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, pablo@netfilter.org,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v2 3/4] net: sched: em_ipt: keep the user-specified nfproto and use it
Date:   Wed, 26 Jun 2019 18:56:14 +0300
Message-Id: <20190626155615.16639-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
References: <20190626155615.16639-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For NFPROTO_UNSPEC xt_matches there's no way to restrict the matching to a
specific family, in order to do so we record the user-specified family
and later enforce it while doing the match.

v2: adjust changes to missing patch, was patch 04 in v1

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
 net/sched/em_ipt.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index fd7f5b288c31..ce91f3cea0bd 100644
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
@@ -182,8 +195,8 @@ static int em_ipt_match(struct sk_buff *skb, struct tcf_ematch *em,
 	const struct em_ipt_match *im = (const void *)em->data;
 	struct xt_action_param acpar = {};
 	struct net_device *indev = NULL;
-	u8 nfproto = im->match->family;
 	struct nf_hook_state state;
+	u8 nfproto = im->nfproto;
 	int ret;
 
 	switch (tc_skb_protocol(skb)) {
@@ -231,7 +244,7 @@ static int em_ipt_dump(struct sk_buff *skb, struct tcf_ematch *em)
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

