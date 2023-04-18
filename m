Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0E66E7008
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbjDRXow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjDRXou (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:44:50 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4878E76B6
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:48 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-187b70ab997so6838231fac.0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681861487; x=1684453487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQAPu1eSvMoNXmbccMUUpKP9ooQvfH4HvgAuLdI+JQ4=;
        b=ukLM4tGj+IPi5r7C3zWDm3+SQwIC7IjL2u1ZdSuBwAbyTHmh4vAAuJSJE4m16tIUpB
         zbeSnLaHaLLzjHvC2IvK/j1oKhj+lx/3649zN8evNHnsqX2y8in+8VDbGr9OsmOY/QEQ
         lxvSlZZ9CVGjXcVwhdhJHSaIfcsrXc5zXDeEWzmPWnlhvf5aPIbRGAxhLgCKa4Z3yIP0
         aVXuWWmpsOOkWW7SgKTru8oMRPzrfXRdLoA3FjdvbT5uleAnI4AV+5iAg1YmoL7WW4+0
         ZLGFaaaM5X+OcAy4nAj1uZ557h0ivtj/vxr77FrkwC7kIn6FE35yn6Rr+GbpJRSMEbyA
         eL1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681861487; x=1684453487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQAPu1eSvMoNXmbccMUUpKP9ooQvfH4HvgAuLdI+JQ4=;
        b=j7+y9ZM4tRKyOn0sgSIzjZ6pJwBuuOiRyIOONzxPtz7fSW9JdOtvDQbH3M99JnaVMO
         s/oXesPXGXoC3WCK+vqKgXC/JkTQ5g7pQHNdFsZgODD7HmcZaqnB8Sira+ed/dP/aKCB
         /AAFVSM6ik90fZRzduza9qQFrz2tajlPEnNdS4MejGoUpMqfAfOwmlbpPG47mzCNP36i
         geMYyo+ljEEjOCu42Rhq3Dy26aUNn5A2KfGT9UPxAWl84Ab5AZEuF+sZQWbJkjhIuzvt
         bBo6Ra8GoVRmIw7/LS0NQmalCBW8KxG3eQZ/AmIDaEc8AY+matOL2HuasF5XYtkshWf9
         evCA==
X-Gm-Message-State: AAQBX9dc05KRSdsPaWlRE8L6Jff4TATtyqNe9ppjs6MKKclCN4Wp3LAp
        INGHsHfQAgobZKNigp61+1yeW5uSvVWyv+hKaHc=
X-Google-Smtp-Source: AKy350bphb7cGNXTSzYZkvbmHL9w2lKweQPW0REyAFjIrfo2NrqMaoiY9ENUikcna4XIDqh1nAr/fA==
X-Received: by 2002:a05:6808:210b:b0:387:4229:c48f with SMTP id r11-20020a056808210b00b003874229c48fmr310614oiw.26.1681861487182;
        Tue, 18 Apr 2023 16:44:47 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:4981:84ab:7cf2:bd9a])
        by smtp.gmail.com with ESMTPSA id o10-20020acad70a000000b0038bae910f7bsm5084357oig.1.2023.04.18.16.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 16:44:46 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 2/5] net/sched: act_pedit: use extack in 'ex' parsing errors
Date:   Tue, 18 Apr 2023 20:43:51 -0300
Message-Id: <20230418234354.582693-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230418234354.582693-1-pctammela@mojatatu.com>
References: <20230418234354.582693-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have extack available when parsing 'ex' keys, so pass it to
tcf_pedit_keys_ex_parse and add more detailed error messages.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 90f5214e679e..c8f27a384800 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -35,7 +35,7 @@ static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
 };
 
 static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
-							u8 n)
+							u8 n, struct netlink_ext_ack *extack)
 {
 	struct tcf_pedit_key_ex *keys_ex;
 	struct tcf_pedit_key_ex *k;
@@ -56,37 +56,51 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
 		int ret;
 
-		if (!n)
+		if (!n) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't parse more extended keys than requested");
 			goto err_out;
+		}
+
 		n--;
 
-		if (nla_type(ka) != TCA_PEDIT_KEY_EX)
+		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
+			NL_SET_ERR_MSG_MOD(extack, "Unknown attribute, expected extended key");
 			goto err_out;
+		}
 
-		ret = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
-						  ka, pedit_key_ex_policy,
-						  NULL);
+		ret = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX, ka,
+						  pedit_key_ex_policy, extack);
 		if (ret) {
 			err = ret;
 			goto err_out;
 		}
 
-		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
-		    !tb[TCA_PEDIT_KEY_EX_CMD])
+		if (NL_REQ_ATTR_CHECK(extack, nla, tb, TCA_PEDIT_KEY_EX_HTYPE)) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute");
 			goto err_out;
+		}
+
+		if (NL_REQ_ATTR_CHECK(extack, nla, tb, TCA_PEDIT_KEY_EX_CMD)) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute");
+			goto err_out;
+		}
 
 		k->htype = nla_get_u16(tb[TCA_PEDIT_KEY_EX_HTYPE]);
 		k->cmd = nla_get_u16(tb[TCA_PEDIT_KEY_EX_CMD]);
 
 		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
-		    k->cmd > TCA_PEDIT_CMD_MAX)
+		    k->cmd > TCA_PEDIT_CMD_MAX) {
+			NL_SET_ERR_MSG_MOD(extack, "Extended key is malformed");
 			goto err_out;
+		}
 
 		k++;
 	}
 
-	if (n)
+	if (n) {
+		NL_SET_ERR_MSG_MOD(extack, "Not enough extended keys to parse");
 		goto err_out;
+	}
 
 	return keys_ex;
 
@@ -215,7 +229,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	nparms->tcfp_keys_ex =
-		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys, extack);
 	if (IS_ERR(nparms->tcfp_keys_ex)) {
 		ret = PTR_ERR(nparms->tcfp_keys_ex);
 		goto out_free;
-- 
2.34.1

