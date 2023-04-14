Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD2D6E2A47
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 20:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjDNSyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 14:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDNSyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 14:54:10 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C94AA276
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 11:54:05 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1879502e2afso6906610fac.5
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 11:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681498444; x=1684090444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=76XxDD6/9vSUzkATpVj85RFC/Zu8lOoLfsLxuBaR2PI=;
        b=EIUjDdUFL5o2KP3k/q+Jlfky8icEsm3qOkM0bWZG21QarVuO8VDiLou9SqOrTtFLoY
         qD3u0k6XcnXnI72lGMkx/xFRM9WMasmqwDZUv+QIFyooJPc+vUEBq4lKp4IocaYeexVY
         3rMpZu3fiKcpLsp5kN4HfStZU40JL/0GQZxwTMCqeFGXUxciQfxOqfMRlMipJKUA85Y8
         xj22/3/xhr8AldEba1cL1qKuowrOfVY43nrBM5SPwhrc0IzqI7IMxijjcL+BGyCjiXE3
         9d3dIG8tu0zR+tayAMfl2VrFfsFStqv64SIXc7+1tebtm1ouxwyxnC4wpHqoZoQv0unP
         HG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681498444; x=1684090444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=76XxDD6/9vSUzkATpVj85RFC/Zu8lOoLfsLxuBaR2PI=;
        b=IVqGkI8aE5hfZUd3vmEDqMQObqymWyvkGLRUZ9ewow/KnzfF9Q73vhnTNkIn4KaHbz
         hPFfXaZ0s4r/1BGB3ADAbCCYYwqesQC85VfzXHeQhxKYMZNVCEHrpGRxizFL2YsEkDTb
         d2fU5Ng440tCL6deqjfJ7rjFqYrQbKCCeyLn+VvY1iNxYDLCly+U/UfwRefngJfa6M9X
         EVGI7wHZ/0mrXrB9owbRhre0RxvK1BBGTRHnAYrhEuH4PQgXp+FAu3XZmuHPbeL5KzEx
         T/Lgk2hoo8OamvGWLJ3p89z3aKStl7Q7X9mB8jwHnDpVmkNd9i2v3F04bMGhgif6CDcs
         jNLA==
X-Gm-Message-State: AAQBX9e2/KPOAeV5R6eHF5ChVjHHpD9Lx0KCBDizEk5J8aWWgHeRtPt3
        mp2ETXrxT8IW/c7mGUkWlVlsvvX2dvzpjsFMYFg=
X-Google-Smtp-Source: AKy350Zau9Cn5gVCzrOghAX1MWCDrEJCU4B6ovIVjMry8jsWSETwwKAvtOMOdr9ZvZT0+y3pM7pAqQ==
X-Received: by 2002:a05:6870:a54d:b0:172:7fc0:9188 with SMTP id p13-20020a056870a54d00b001727fc09188mr5130819oal.35.1681498444698;
        Fri, 14 Apr 2023 11:54:04 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:bb6:61a2:bf8b:4710])
        by smtp.gmail.com with ESMTPSA id z21-20020a056870515500b0017f647294f5sm2096061oak.16.2023.04.14.11.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 11:54:04 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 2/2] net/sched: sch_qfq: use extack on errors messages
Date:   Fri, 14 Apr 2023 15:53:10 -0300
Message-Id: <20230414185309.220286-3-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230414185309.220286-1-pctammela@mojatatu.com>
References: <20230414185309.220286-1-pctammela@mojatatu.com>
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

Some error messages are still being printed to dmesg.
Since extack is available, report error messages there instead.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_qfq.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index cf5ebe43b3b4..b2a4cf01766c 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -403,19 +403,20 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	int delta_w;
 
 	if (tca[TCA_OPTIONS] == NULL) {
-		pr_notice("qfq: no options\n");
+		NL_SET_ERR_MSG_MOD(extack, "missing options");
 		return -EINVAL;
 	}
 
 	err = nla_parse_nested_deprecated(tb, TCA_QFQ_MAX, tca[TCA_OPTIONS],
-					  qfq_policy, NULL);
+					  qfq_policy, extack);
 	if (err < 0)
 		return err;
 
 	if (tb[TCA_QFQ_WEIGHT]) {
 		weight = nla_get_u32(tb[TCA_QFQ_WEIGHT]);
 		if (!weight || weight > (1UL << QFQ_MAX_WSHIFT)) {
-			pr_notice("qfq: invalid weight %u\n", weight);
+			NL_SET_ERR_MSG_FMT_MOD(extack, "invalid weight %u\n",
+					       weight);
 			return -EINVAL;
 		}
 	} else
@@ -424,7 +425,8 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	if (tb[TCA_QFQ_LMAX]) {
 		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
 		if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-			pr_notice("qfq: invalid max length %u\n", lmax);
+			NL_SET_ERR_MSG_FMT_MOD(extack,
+					       "invalid max length %u\n", lmax);
 			return -EINVAL;
 		}
 	} else
@@ -441,8 +443,9 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	delta_w = weight - (cl ? cl->agg->class_weight : 0);
 
 	if (q->wsum + delta_w > QFQ_MAX_WSUM) {
-		pr_notice("qfq: total weight out of range (%d + %u)\n",
-			  delta_w, q->wsum);
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "qfq: total weight out of range (%d + %u)\n",
+				       delta_w, q->wsum);
 		return -EINVAL;
 	}
 
-- 
2.34.1

