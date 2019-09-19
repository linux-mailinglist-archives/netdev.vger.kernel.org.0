Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EE4B712C
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 03:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387738AbfISBpF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 21:45:05 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44427 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387561AbfISBpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 21:45:05 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so1136255pfn.11
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 18:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glrVZTGv8aYQUd2jDJTvxAIRlmb/V80278CbSfWIIrs=;
        b=W2wIkBau+twpf1v68kLs1GMtZLZ5vmwDFmiu2oKZ4Ds/WfySy+Asm7AdpdHFY8S8g2
         EiCIdnLn09LMr61gZ0gH0WQdwmzSx92/WEEImyNbAxSOLCnb/KHFeE6EsxYThzwibs6g
         1owaHV+uSOzqRY7s+6bslmVoWe7BHi9+kb1uuRBbv5YMOUuatFQ0BoU6CyPQJLCE6qmA
         l2bCCIikr9MSreEQTjMlw3ZA3weTX81bNdj1q/fjQneYCEkUhW8LCp83S94OOrGPKUJc
         x5H5+tnJJykND3nQApgblqIUOYlKIxf8fmFgRVc6CKPhBmxO/1kTA6cETcIBV9uRB4+T
         BrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=glrVZTGv8aYQUd2jDJTvxAIRlmb/V80278CbSfWIIrs=;
        b=uiFMF2iTsug1kDpieW6zTJ8Ub50ZtaZWQ1OCJJlVe5r2uJNPi+2u/vDmLLTHXcsoBP
         UYIofX/tTueGVdnmr42r+fgATir6uoZ0VRiU78X/k2k6/vIulzL8vR+qEVLm3QY8HX0h
         K+GEaXssTDN+RirEK4AsM+m6aZP9RFiWfmkDoS16iFAo//5CubPaJ7zZpqUHibjLsLvd
         WTYvd87DCYLDKKYTk75KgUXxHiDpeVirjTyowcF7NTeyhcFev738efSCXtdbr/wL5Q96
         rfqWsOz2E0tsSuFCcWeztC3CDDuqwcHARN6dp3YD0BXUiOLh4DqDYLAmK9qWoYVqiu41
         rfNQ==
X-Gm-Message-State: APjAAAWRySTzPTkj/uHIEdiLxBGR96j/alT6K/dBO0uZ58UlTa63kvfT
        Or/jMAR9vGTv2+j9oCBtNgCkGQzW
X-Google-Smtp-Source: APXvYqxaZWkPlFoHl0G3kkkVuJTibze7LPrd7g+l9UEHZrqkAg7QkaFoxGB5h9rbYuq2uxZOWPPYvQ==
X-Received: by 2002:a17:90a:24a1:: with SMTP id i30mr996176pje.128.1568857503974;
        Wed, 18 Sep 2019 18:45:03 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id q13sm5585098pjq.0.2019.09.18.18.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 18:45:03 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: add policy validation for action attributes
Date:   Wed, 18 Sep 2019 18:44:43 -0700
Message-Id: <20190919014443.32581-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similar to commit 8b4c3cdd9dd8
("net: sched: Add policy validation for tc attributes"), we need
to add proper policy validation for TC action attributes too.

Cc: David Ahern <dsahern@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/act_api.c | 34 ++++++++++++++++++----------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 835adde28a7e..da99667589f8 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -831,6 +831,15 @@ static struct tc_cookie *nla_memdup_cookie(struct nlattr **tb)
 	return c;
 }
 
+static const struct nla_policy tcf_action_policy[TCA_ACT_MAX + 1] = {
+	[TCA_ACT_KIND]		= { .type = NLA_NUL_STRING,
+				    .len = IFNAMSIZ - 1 },
+	[TCA_ACT_INDEX]		= { .type = NLA_U32 },
+	[TCA_ACT_COOKIE]	= { .type = NLA_BINARY,
+				    .len = TC_COOKIE_MAX_SIZE },
+	[TCA_ACT_OPTIONS]	= { .type = NLA_NESTED },
+};
+
 struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 				    struct nlattr *nla, struct nlattr *est,
 				    char *name, int ovr, int bind,
@@ -846,8 +855,8 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 	int err;
 
 	if (name == NULL) {
-		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL,
-						  extack);
+		err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+						  tcf_action_policy, extack);
 		if (err < 0)
 			goto err_out;
 		err = -EINVAL;
@@ -856,18 +865,9 @@ struct tc_action *tcf_action_init_1(struct net *net, struct tcf_proto *tp,
 			NL_SET_ERR_MSG(extack, "TC action kind must be specified");
 			goto err_out;
 		}
-		if (nla_strlcpy(act_name, kind, IFNAMSIZ) >= IFNAMSIZ) {
-			NL_SET_ERR_MSG(extack, "TC action name too long");
-			goto err_out;
-		}
-		if (tb[TCA_ACT_COOKIE]) {
-			int cklen = nla_len(tb[TCA_ACT_COOKIE]);
-
-			if (cklen > TC_COOKIE_MAX_SIZE) {
-				NL_SET_ERR_MSG(extack, "TC cookie size above the maximum");
-				goto err_out;
-			}
+		nla_strlcpy(act_name, kind, IFNAMSIZ);
 
+		if (tb[TCA_ACT_COOKIE]) {
 			cookie = nla_memdup_cookie(tb);
 			if (!cookie) {
 				NL_SET_ERR_MSG(extack, "No memory to generate TC cookie");
@@ -1097,7 +1097,8 @@ static struct tc_action *tcf_action_get_1(struct net *net, struct nlattr *nla,
 	int index;
 	int err;
 
-	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+					  tcf_action_policy, extack);
 	if (err < 0)
 		goto err_out;
 
@@ -1151,7 +1152,8 @@ static int tca_action_flush(struct net *net, struct nlattr *nla,
 
 	b = skb_tail_pointer(skb);
 
-	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla, NULL, extack);
+	err = nla_parse_nested_deprecated(tb, TCA_ACT_MAX, nla,
+					  tcf_action_policy, extack);
 	if (err < 0)
 		goto err_out;
 
@@ -1439,7 +1441,7 @@ static struct nlattr *find_dump_kind(struct nlattr **nla)
 
 	if (tb[1] == NULL)
 		return NULL;
-	if (nla_parse_nested_deprecated(tb2, TCA_ACT_MAX, tb[1], NULL, NULL) < 0)
+	if (nla_parse_nested_deprecated(tb2, TCA_ACT_MAX, tb[1], tcf_action_policy, NULL) < 0)
 		return NULL;
 	kind = tb2[TCA_ACT_KIND];
 
-- 
2.21.0

