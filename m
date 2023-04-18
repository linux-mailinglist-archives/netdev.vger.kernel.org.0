Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6CF6E7007
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 01:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbjDRXov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 19:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbjDRXop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 19:44:45 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67027AA1
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:44 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id 006d021491bc7-5416faa1f2cso706378eaf.0
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 16:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681861484; x=1684453484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ba0qF/rc0XT7HspkuZIoGRu2q/iy/JtWq3jiGeoj8lI=;
        b=bBYKVb8Lw20l5DnYNdUwahXIqPI6UEVvGXzgf3KZXHTgYKXc8G7MXSLphlrBON5zUg
         hsdaMVKw2vYgos7SZ5BUSD/1yvyFojV77ocZHg4CAQQZsM9O3XB3z7k1rHtnR83l4fev
         gmPVRAEh96O1pm/eWmE5/CbCctK0v+4+tTbSna88ViKvUek6u0zD95ssaDsGNljQSG38
         rbBs+/W7UL29Upg07VVSxmyozxyhQzYxPrgt3tzOKbY4CZZ72UL3eM0E4/nmbKA0GD+A
         UyIkBvcpk+r+qFn3P99UVxyIWzUck+n2c3kGFa8224yvok9zNfNzIuflg6Vu7JDMMuld
         nbEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681861484; x=1684453484;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ba0qF/rc0XT7HspkuZIoGRu2q/iy/JtWq3jiGeoj8lI=;
        b=VBzTxJZ5wM184KVmDlmWRkheLfl7efwxOuGVmRCid3cAWoLAFtQg8dfUz92SmG72+e
         Q5vCSBK1OFxMXgJyqf64hgtfniuiLkS8HDnLhR+EN34nYFMnosEjnjNuflg+nu5EPzLG
         H3j7dL5DibwULan4v2dd/OlbgbXABeW+jNe3TzmcYiLc9nvDnF5Q6UsVt7tQL5HG05/t
         eNuvDHhxP9wP3PgCmnjU3HKEW4MAaWkj2P33+AN26ztJ4zwhLKqVFt6gKbPhjfyQHS0C
         xGs7qlS+7GNirrGmLRAj9MuFn5Tjw9H95MedIYY3lmAeQyhYHaS0QSY0YhR0BEvdkGSA
         p07w==
X-Gm-Message-State: AAQBX9dM6BSuAPaag7cbUYKHqTc5bmVG/JQznhq4zooKoAUQWAnwWxEu
        OVGBh9xkJ8Cfk4HXbu3YF09JOVl6VwxXwY6CBUE=
X-Google-Smtp-Source: AKy350ZVIR/T/n4jXac7XP5Rd/CNmCRi3y10fL0/KZ2MQyzO896TL2aPGti016y/ReO+jNsE3PsqTA==
X-Received: by 2002:a05:6808:120c:b0:38e:2cca:12d8 with SMTP id a12-20020a056808120c00b0038e2cca12d8mr2233349oil.14.1681861484015;
        Tue, 18 Apr 2023 16:44:44 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:4981:84ab:7cf2:bd9a])
        by smtp.gmail.com with ESMTPSA id o10-20020acad70a000000b0038bae910f7bsm5084357oig.1.2023.04.18.16.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 16:44:43 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 1/5] net/sched: act_pedit: simplify 'ex' key parsing error propagation
Date:   Tue, 18 Apr 2023 20:43:50 -0300
Message-Id: <20230418234354.582693-2-pctammela@mojatatu.com>
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

'err' is returned -EINVAL most of the time.
Make the exception be the netlink parsing and remove the
redundant error assignments in the other code paths.

Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_pedit.c | 27 ++++++++++-----------------
 1 file changed, 10 insertions(+), 17 deletions(-)

diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
index 4559a1507ea5..90f5214e679e 100644
--- a/net/sched/act_pedit.c
+++ b/net/sched/act_pedit.c
@@ -54,46 +54,39 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
 
 	nla_for_each_nested(ka, nla, rem) {
 		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
+		int ret;
 
-		if (!n) {
-			err = -EINVAL;
+		if (!n)
 			goto err_out;
-		}
 		n--;
 
-		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
-			err = -EINVAL;
+		if (nla_type(ka) != TCA_PEDIT_KEY_EX)
 			goto err_out;
-		}
 
-		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
+		ret = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
 						  ka, pedit_key_ex_policy,
 						  NULL);
-		if (err)
+		if (ret) {
+			err = ret;
 			goto err_out;
+		}
 
 		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
-		    !tb[TCA_PEDIT_KEY_EX_CMD]) {
-			err = -EINVAL;
+		    !tb[TCA_PEDIT_KEY_EX_CMD])
 			goto err_out;
-		}
 
 		k->htype = nla_get_u16(tb[TCA_PEDIT_KEY_EX_HTYPE]);
 		k->cmd = nla_get_u16(tb[TCA_PEDIT_KEY_EX_CMD]);
 
 		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
-		    k->cmd > TCA_PEDIT_CMD_MAX) {
-			err = -EINVAL;
+		    k->cmd > TCA_PEDIT_CMD_MAX)
 			goto err_out;
-		}
 
 		k++;
 	}
 
-	if (n) {
-		err = -EINVAL;
+	if (n)
 		goto err_out;
-	}
 
 	return keys_ex;
 
-- 
2.34.1

