Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE1EE6E4EE6
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbjDQRMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230093AbjDQRMp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:12:45 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4876A7B
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:42 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id k101-20020a9d19ee000000b006a14270bc7eso10080937otk.6
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681751561; x=1684343561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XAykbLVeHziw0JUwYHoJmyn/25zTSaV2zD2m1EHgVFo=;
        b=oIYtJ0vmwaCldoTz/3/9KbR9ugwcYFmhZOvUgE2KJzM6ytLR6JXrTMohzOEiHQ/ISb
         iaIg/WzZ95f0/glBak3MIEl1hIW3svxMLAk8u/ZD+k+DtXNt5ClE2m1eBhC/FPDegTzL
         45M+SlY8ItNGD0LFr9irE1uEoTwCm/5o3d8nKLEZUTYQcDyfRVyktydqdOc9DQORundR
         +FSxGSG7GLrKevXcBhK4wEFoBVOxQOXgGuOgH39Sz1n0ShMDP5H8sns1wbaOttpFuGwE
         jYuOgKWZHlt6DZ549ZrWcafZLWDB37fHwXMdAmkX8oJVMmia3RcvMXv/4aOwTznBtJ6a
         Js6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681751561; x=1684343561;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XAykbLVeHziw0JUwYHoJmyn/25zTSaV2zD2m1EHgVFo=;
        b=gVZ/86F6McXqdtr7ghHqorwLunWRiqK5QUDriMQbnz2YORYP5HkhuENeZuosa0k5oM
         Vh0G/F4HKDfo4W/yoLm/MDDp7nOmNPYlq1ndOsSokIC8EDJA984kBCKWh5A3ZVyU9rob
         FYEny0HHTOPNVBZ7VrtruZcOuu14TN8LOuXzix9j/sy0PQ14speJrEiEU2/3du1/fgM8
         mf7+9CzmQtt/V9OvtkGoX5/8LKIEw03Ei9vZLxZswSTAxq3fD3U/L0CwpAMZ0p77wWre
         htrankt7KUlkFV81PKQizkYAz69XfDnFssyITOCzezEvqyyy38+pkLT0UKqKBmvvleuX
         R3Ww==
X-Gm-Message-State: AAQBX9dgxokQ8hLYWFnfrjNwsZcBV8XnrJHub5/j+h8iT56YFfnqzZKG
        9EgXahbXuqbd+YlkMM0FmCh2FqGQWb9bQsRiuoo=
X-Google-Smtp-Source: AKy350bLZJts96elB29dckb3mEn3vrZtrZ6JEHAqbeum2zxZxLtVNpabLWvI1gllSOKZE9Vas5jZXA==
X-Received: by 2002:a05:6830:4424:b0:6a5:dafc:3d1e with SMTP id q36-20020a056830442400b006a5dafc3d1emr5868371otv.5.1681751561711;
        Mon, 17 Apr 2023 10:12:41 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:150:be5b:9489:90ac])
        by smtp.gmail.com with ESMTPSA id v17-20020a9d5a11000000b006a205a8d5bdsm4761248oth.45.2023.04.17.10.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 10:12:41 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 3/4] net/sched: sch_qfq: refactor parsing of netlink parameters
Date:   Mon, 17 Apr 2023 14:12:17 -0300
Message-Id: <20230417171218.333567-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230417171218.333567-1-pctammela@mojatatu.com>
References: <20230417171218.333567-1-pctammela@mojatatu.com>
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

Two parameters can be transformed into netlink policies and
validated while parsing the netlink message.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_qfq.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 323609cfbc67..151102ac8cce 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -214,9 +214,15 @@ static struct qfq_class *qfq_find_class(struct Qdisc *sch, u32 classid)
 	return container_of(clc, struct qfq_class, common);
 }
 
+static struct netlink_range_validation lmax_range = {
+	.min = QFQ_MIN_LMAX,
+	.max = (1UL << QFQ_MTU_SHIFT),
+};
+
 static const struct nla_policy qfq_policy[TCA_QFQ_MAX + 1] = {
-	[TCA_QFQ_WEIGHT] = { .type = NLA_U32 },
-	[TCA_QFQ_LMAX] = { .type = NLA_U32 },
+	[TCA_QFQ_WEIGHT] =
+		NLA_POLICY_RANGE(NLA_U32, 1, (1UL << QFQ_MAX_WSHIFT)),
+	[TCA_QFQ_LMAX] = NLA_POLICY_FULL_RANGE(NLA_U32, &lmax_range),
 };
 
 /*
@@ -408,26 +414,18 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 	}
 
 	err = nla_parse_nested_deprecated(tb, TCA_QFQ_MAX, tca[TCA_OPTIONS],
-					  qfq_policy, NULL);
+					  qfq_policy, extack);
 	if (err < 0)
 		return err;
 
-	if (tb[TCA_QFQ_WEIGHT]) {
+	if (tb[TCA_QFQ_WEIGHT])
 		weight = nla_get_u32(tb[TCA_QFQ_WEIGHT]);
-		if (!weight || weight > (1UL << QFQ_MAX_WSHIFT)) {
-			pr_notice("qfq: invalid weight %u\n", weight);
-			return -EINVAL;
-		}
-	} else
+	else
 		weight = 1;
 
-	if (tb[TCA_QFQ_LMAX]) {
+	if (tb[TCA_QFQ_LMAX])
 		lmax = nla_get_u32(tb[TCA_QFQ_LMAX]);
-		if (lmax < QFQ_MIN_LMAX || lmax > (1UL << QFQ_MTU_SHIFT)) {
-			pr_notice("qfq: invalid max length %u\n", lmax);
-			return -EINVAL;
-		}
-	} else
+	else
 		lmax = psched_mtu(qdisc_dev(sch));
 
 	inv_w = ONE_FP / weight;
-- 
2.34.1

