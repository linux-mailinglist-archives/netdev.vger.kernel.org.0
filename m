Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299C96BF21B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjCQUGJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:06:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbjCQUGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:06:06 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44664391F
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:03 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id f17-20020a9d7b51000000b00697349ab7e7so3486431oto.9
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:06:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679083562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g/bAeGvHYteqcW3oSY0dYVvGX85jsfFt01QzXBIzUag=;
        b=S+ylxZskVJXI5ljAwy9tfrqJU+wh9jBkuQ2HsoA51rpK2M7NQsy5Mu3EEWVdn4OsH1
         7gjskw2GAlv0TZyURYxrMfMIzv9RMVcM9YEwlDMebNB1ZNsFAZJtgjrj86A/ZkcszYdB
         H3NxJXkbYxcv29Bs/2TeapWZk3Tlrshzb8/1IhJwqVb+d19/norIoEqD8E7wfGQf826S
         1QWmRPSXlxiBGtaDePrOHO+N+7QGs5DZGAtlj6g3O7dj1CQD4afQp1BDzddmF9YiEM2t
         5YBCovZ1UJm8BLx1YfdL86zJMmioekliIN/ZegpHQ9LCjowhaXWf7eeK/szAug/mCW+Q
         EmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679083562;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g/bAeGvHYteqcW3oSY0dYVvGX85jsfFt01QzXBIzUag=;
        b=mW3KuunmpOPDXfyruCqqxUU2Xo2SeHtRXcN+0WLzczmHiXZjz5GloX9z1f34GeXwr2
         IMEq+JUKROdPVM+wqioBiJ/7e3tad1qQJC6Iyo6bCUxNmaFWH5Aq/kgUv6LhTN1R77vX
         s0EqgAkkWzKMdDqhehjaM9AfTbGC3JY3Obi4AitOdGYEgI1jXlZ5yT/GHRemTbAvgX8/
         M+UN8R2W4sU1ZpWRkVyn/987cRHfvNiV5TUxMR+VkJKGZ4UNsaaCP6TQ9PIQXyzlWfs2
         FCVkCIQy7HrK8B+GshSocquI72VjoV1GwJ/ebAeVsAcZb6eeYhw/UO4D7Qxn8E4sBT3s
         Z8YA==
X-Gm-Message-State: AO0yUKXcPsaLrjaw+KzqqOSUhhfZw5TpfkX9CQpnN8gxth9gRXywaeI1
        Nnzc/Nz8nOxWFU7aCSPsaD1StKPs/MCwTIje4Tc=
X-Google-Smtp-Source: AK7set9UwrRn7Z9gADtr0MzQer92+WiegOquKjuiWBnc8dz/ylK6RL5M9NoVB5TyXN+6c+32GyH6gg==
X-Received: by 2002:a05:6830:99:b0:699:7244:a372 with SMTP id a25-20020a056830009900b006997244a372mr378012oto.28.1679083562671;
        Fri, 17 Mar 2023 13:06:02 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:10c1:4b9b:b369:bda2])
        by smtp.gmail.com with ESMTPSA id z8-20020a056830128800b00698a88cfad1sm1304209otp.68.2023.03.17.13.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 13:06:02 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 1/4] net/sched: act_pedit: use extack in 'ex' parsing errors
Date:   Fri, 17 Mar 2023 16:51:32 -0300
Message-Id: <20230317195135.1142050-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230317195135.1142050-1-pctammela@mojatatu.com>
References: <20230317195135.1142050-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We have extack available when parsing 'ex' keys, so pass it to
tcf_pedit_keys_ex_parse and add more detailed error messages.
While at it, remove redundant code from the 'err_out' label code path.

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 4559a1507ea5..cd3cbe397e87 100644
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
@@ -56,25 +56,25 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
 
 		if (!n) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Can't parse more extended keys than requested");
 			goto err_out;
 		}
+
 		n--;
 
 		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Unknown attribute, expected extended key");
 			goto err_out;
 		}
 
-		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
-						  ka, pedit_key_ex_policy,
-						  NULL);
+		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX, ka,
+						  pedit_key_ex_policy, extack);
 		if (err)
 			goto err_out;
 
 		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
 		    !tb[TCA_PEDIT_KEY_EX_CMD]) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit missing required attributes");
 			goto err_out;
 		}
 
@@ -83,7 +83,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 
 		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
 		    k->cmd > TCA_PEDIT_CMD_MAX) {
-			err = -EINVAL;
+			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit key is malformed");
 			goto err_out;
 		}
 
@@ -91,7 +91,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 	}
 
 	if (n) {
-		err = -EINVAL;
+		NL_SET_ERR_MSG_MOD(extack, "Not enough extended keys to parse");
 		goto err_out;
 	}
 
@@ -222,7 +222,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
 	}
 
 	nparms->tcfp_keys_ex =
-		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
+		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys, extack);
 	if (IS_ERR(nparms->tcfp_keys_ex)) {
 		ret = PTR_ERR(nparms->tcfp_keys_ex);
 		goto out_free;
-- 
2.34.1

