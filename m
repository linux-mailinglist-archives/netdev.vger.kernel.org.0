Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26DD06EB395
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 23:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233213AbjDUVZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 17:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbjDUVZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 17:25:47 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DDF270D
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:46 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 5614622812f47-38bcc5914ecso902738b6e.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 14:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682112345; x=1684704345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D5/e9XMudMN/In9k0qq3cI/EgMi4otvzooQkp2HZCZk=;
        b=MConKEzyznXq9fCGod3HBEKVKytaglPHjU85VmDSguQeD9KXRWoRxWp0QwqTBCs9Z3
         InM3m7w8csyOd+J3b2EOvUf1fKcY+cV5eo9nfeHRNMuiIe9VgpIoBRGwpplFCm+6yKvr
         2cGVedoIvyREeadxRi9+MrH6WS0DUyjk98/NNGGl5JSEVVL6rT1CirCW4MBcut+zny0g
         rQMEeMVVtwnvXAGRX2d43SoqcCTL0jIdRQI0s4rJirylY48A/Q6DXwkvzPkYIHqdFiB+
         eJv0g0J2gTjfbsb8vpKHPpinZ/MM9NckD280sq7hWY/ws7JqztAHIqxP1V2Af2CsRxk4
         PP5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682112345; x=1684704345;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D5/e9XMudMN/In9k0qq3cI/EgMi4otvzooQkp2HZCZk=;
        b=VpacRllqPMeDqm53p7YAuaZz0in2MtyQIR03N7zp3WHLdXtLbvwltpozQg8GQmSXDg
         0t8gDnwZqRsC66xdqUFgZZ2U3aRAD4e4m7AYdtli+cMVAgUjAhzwcgNOp1eef4Xh1VJx
         iYq4b+EY6pDMPdU5ysZcLmtK6CmPfVJBIYfLLL8JJDkz43IXUdf6FuhadECM80ZbOnb7
         mUxBuelUylhrBszdax/PI9c0pFSuEwPSUlpVUglgjwEh9ke3e7WVaKBSEsIneHeqTeW6
         pomOF16VkVUF02wj3vgcjIa9Idvcpv13tHU0mAZKoJ7ynnjYWCMHP4F4EK0meHWDJ2rx
         +MEw==
X-Gm-Message-State: AAQBX9fjM6qR3c4nLon/htRgyD8kZThlW2Tsm9FVbeYWk9CiwXl7xdyd
        cQ7zXmdGZw0O8bWFYvTY4oLb900tY3exaohX+RM=
X-Google-Smtp-Source: AKy350b8TKI5JpaNIzHdoAPmk+RlGEFxbxztIRTzlM/zIRNN8vwpmpYW2bkVd5jrw0oDGJS6aASnaw==
X-Received: by 2002:aca:a982:0:b0:38e:56b9:aa69 with SMTP id s124-20020acaa982000000b0038e56b9aa69mr3028808oie.7.1682112345188;
        Fri, 21 Apr 2023 14:25:45 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id j11-20020a4a888b000000b00524fe20aee5sm2147663ooa.34.2023.04.21.14.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 14:25:44 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v5 2/5] net/sched: act_pedit: use extack in 'ex' parsing errors
Date:   Fri, 21 Apr 2023 18:25:14 -0300
Message-Id: <20230421212516.406726-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421212516.406726-1-pctammela@mojatatu.com>
References: <20230421212516.406726-1-pctammela@mojatatu.com>
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 45201f75e896..24976cd4e4a2 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -36,7 +36,7 @@ static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
 };
 
 static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
-							u8 n)
+							u8 n, struct netlink_ext_ack *extack)
 {
 	struct tcf_pedit_key_ex *keys_ex;
 	struct tcf_pedit_key_ex *k;
@@ -57,12 +57,14 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
 
 		if (!n) {
+			NL_SET_ERR_MSG_MOD(extack, "Can't parse more extended keys than requested");
 			err = -EINVAL;
 			goto err_out;
 		}
 		n--;
 
 		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
+			NL_SET_ERR_MSG_ATTR(extack, ka, "Unknown attribute, expected extended key");
 			err = -EINVAL;
 			goto err_out;
 		}
@@ -73,8 +75,14 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 		if (err)
 			goto err_out;
 
-		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
-		    !tb[TCA_PEDIT_KEY_EX_CMD]) {
+		if (NL_REQ_ATTR_CHECK(extack, nla, tb, TCA_PEDIT_KEY_EX_HTYPE)) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute");
+			err = -EINVAL;
+			goto err_out;
+		}
+
+		if (NL_REQ_ATTR_CHECK(extack, nla, tb, TCA_PEDIT_KEY_EX_CMD)) {
+			NL_SET_ERR_MSG(extack, "Missing required attribute");
 			err = -EINVAL;
 			goto err_out;
 		}
@@ -86,6 +94,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 	}
 
 	if (n) {
+		NL_SET_ERR_MSG_MOD(extack, "Not enough extended keys to parse");
 		err = -EINVAL;
 		goto err_out;
 	}
@@ -217,7 +226,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	nparms->tcfp_keys_ex =
-		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys, extack);
 	if (IS_ERR(nparms->tcfp_keys_ex)) {
 		ret = PTR_ERR(nparms->tcfp_keys_ex);
 		goto out_free;
-- 
2.34.1

