Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7BF957E03
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 10:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfF0INN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 04:13:13 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41276 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbfF0INK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 04:13:10 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so1398493wrm.8
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 01:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DJsPt3g8bhkgO2JHeRTiGtyDrVJGoI40dWwB8prxKY4=;
        b=Vmx3sL0QALyEtnFiAjEJMJ6WuMlczY/BSV2qJi58fdrrYSohgqLUYn1CcDkoWfhG+s
         szz2Qj90V3DpWRW3JkKjmaueoGBeluwnZAfsR3d1fc5/F1jsXx0D66si3sRfLqkLyYRT
         AvKYSRr42Y8WHSqKvk9VuYt/f72pE4W0A/GWk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DJsPt3g8bhkgO2JHeRTiGtyDrVJGoI40dWwB8prxKY4=;
        b=V2hXSWpzMkKRNeR49QWr7XuiiWaIVTs3rsz59O6KW4ecA3srpabjfwP0RY6r+0Negr
         kWAgoejD4NcpaCTS4NPklNcUheiyZjf905Yt76lgQc2nKeyhga5sN+1YMFGCVW8EZjeP
         RbcCPY0k6A6toOBaiQ/zg7h5XmsEid206XXhaMORYHrlg9vm3J+m1geXSKSHQhSxpW95
         KDzsqn+05i9SifuPKVVZnA0H+cpdXYNKGihw5L2MlhKBEowVe5kzUGJEaG4AAC54Qogy
         aYIrMuG94nDR/EX5Xi7aKjPGdo8NMosiaRx1BvcH0oRdWletseddi63bRUU+eLBC5QXC
         TG3w==
X-Gm-Message-State: APjAAAV9Bn8v2yVjGIFcpJC6j90WjvCLRiB48WBgoFC0Hsgi5IcGImcn
        PvDq0pPiGmPtHL7st0l4TMmQ4vdRKx0=
X-Google-Smtp-Source: APXvYqx6jYyQrRkUpVHH0D8AUAiG5/j8x3b8m4h68gtGCjuSFScP49vInr0aNHAKQwk2bgzxCOjrgg==
X-Received: by 2002:a5d:6743:: with SMTP id l3mr2197950wrw.284.1561623188035;
        Thu, 27 Jun 2019 01:13:08 -0700 (PDT)
Received: from localhost.localdomain (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o6sm6969949wmc.15.2019.06.27.01.13.06
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 01:13:07 -0700 (PDT)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     netdev@vger.kernel.org
Cc:     roopa@cumulusnetworks.com, davem@davemloft.net,
        pablo@netfilter.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        jhs@mojatatu.com, eyal.birger@gmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: [PATCH net-next v3 3/4] net: sched: em_ipt: keep the user-specified nfproto and dump it
Date:   Thu, 27 Jun 2019 11:10:46 +0300
Message-Id: <20190627081047.24537-4-nikolay@cumulusnetworks.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
References: <20190627081047.24537-1-nikolay@cumulusnetworks.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If we dump NFPROTO_UNSPEC as nfproto user-space libxtables can't handle
it and would exit with an error like:
"libxtables: unhandled NFPROTO in xtables_set_nfproto"
In order to avoid the error return the user-specified nfproto. If we
don't record it then the match family is used which can be
NFPROTO_UNSPEC. Even if we add support to mask NFPROTO_UNSPEC in
iproute2 we have to be compatible with older versions which would be
also be allowed to add NFPROTO_UNSPEC matches (e.g. addrtype after the
last patch).

v3: don't use the user nfproto for matching, only for dumping the rule,
    also don't allow the nfproto to be unspecified (explained above)
v2: adjust changes to missing patch, was patch 04 in v1

Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
---
Unfortunately we still have to save the user-nfproto for dumping
otherwise we'll break user-space because it can add a rule which it
won't be able to dump later and in fact will terminate the whole dump.
I also thought about masking it but that seems more hacky, I'd prefer
to return an expected value which was passed when the rule was created.

 net/sched/em_ipt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/sched/em_ipt.c b/net/sched/em_ipt.c
index fd7f5b288c31..3c356d6f719a 100644
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
@@ -125,6 +127,15 @@ static int em_ipt_change(struct net *net, void *data, int data_len,
 	    !tb[TCA_EM_IPT_MATCH_DATA] || !tb[TCA_EM_IPT_NFPROTO])
 		return -EINVAL;
 
+	nfproto = nla_get_u8(tb[TCA_EM_IPT_NFPROTO]);
+	switch (nfproto) {
+	case NFPROTO_IPV4:
+	case NFPROTO_IPV6:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	match = get_xt_match(tb);
 	if (IS_ERR(match)) {
 		pr_err("unable to load match\n");
@@ -140,6 +151,7 @@ static int em_ipt_change(struct net *net, void *data, int data_len,
 
 	im->match = match;
 	im->hook = nla_get_u32(tb[TCA_EM_IPT_HOOK]);
+	im->nfproto = nfproto;
 	nla_memcpy(im->match_data, tb[TCA_EM_IPT_MATCH_DATA], mdata_len);
 
 	ret = check_match(net, im, mdata_len);
@@ -231,7 +243,7 @@ static int em_ipt_dump(struct sk_buff *skb, struct tcf_ematch *em)
 		return -EMSGSIZE;
 	if (nla_put_u8(skb, TCA_EM_IPT_MATCH_REVISION, im->match->revision) < 0)
 		return -EMSGSIZE;
-	if (nla_put_u8(skb, TCA_EM_IPT_NFPROTO, im->match->family) < 0)
+	if (nla_put_u8(skb, TCA_EM_IPT_NFPROTO, im->nfproto) < 0)
 		return -EMSGSIZE;
 	if (nla_put(skb, TCA_EM_IPT_MATCH_DATA,
 		    im->match->usersize ?: im->match->matchsize,
-- 
2.21.0

