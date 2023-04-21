Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702106EB13C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 19:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233345AbjDURyS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 13:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233476AbjDURyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 13:54:17 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 325CB1738
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:16 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-18807540d5aso1752292fac.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 10:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682099655; x=1684691655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6oCjMzDCo666o0o05nA5ZEezvfE07tQGy7QyCkzH2Wo=;
        b=dmoSKZqWMov0zlKYNIcMyn+vp1yRCW7GED8f/zdXObiNrGZQbEXcfseEs1BUm1Rr7+
         sXkkJMXJbeokEQSypJZ1vmeLgaZ/ERBwxmlQl7zphRvKlTlfBzQKC16U4Vg2nwrhiDVJ
         KatTcM7st5YiGvS0XlPXkYMLM3yuoa0+nYWNfYqcEuK4gijwQm8K2Pi7U+geLMfRj4MK
         mJm0AgHm5bLDpmH4FNv2Na0kbN0S2Xq92bZ2H6ZlFS32DE69BEOIcX6WcJI3qm+NFOkx
         QYE/YdI/kk+HiYG0ur8MZD2m0dYYmiIl93p7Bl1eZrFTHA3lHp4a6kvi7v5kZJk5qXvq
         13zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682099655; x=1684691655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6oCjMzDCo666o0o05nA5ZEezvfE07tQGy7QyCkzH2Wo=;
        b=U6aHOHwJhE8eG4WMxfRCrE+UPQAY4FGC4VNdILdcvZgAMqYuc1NpH1xo8d1uxwcGoQ
         dcdMcw1DGcYHUCJ8/mpKm4185Q6JONmU8gV8PGVjrTkd+HeL/sPv0/Ik0y7exJv0mHW/
         JtMWYtjGzCU6+yehTDHEtvafUv2w++YO53hbj46JwW+awG9G8J21GfiasPMVtcTuiMoE
         m9R8aIhmQq7r4gSOrlqEK4+MuSeNmOKlm0O4npY4qyxR/Pt2BL6OYLWIl/gQNkgX3BYk
         H60MdhMwbNot0TZ35e3vz7AhDGymylW2yUTat4E+Lyl+rB0WxS7+FBf0iGfQRrvBBFiH
         i+Bw==
X-Gm-Message-State: AAQBX9dsKEtncMctu2Y8/gVuHNJ5jrWUjrXhuh90F0CN0cdQ86LIJixx
        SGst7R34LmKFaoCmV3dMMObsQ8DPgrwGfx/BF60=
X-Google-Smtp-Source: AKy350a3j2HAk56TX7umB9Jbq+QKeEpRRWWK8c2lySDCH8JvRqUlIGuD5dMuS8wjic1/rQpUAH7HQA==
X-Received: by 2002:a05:6870:c0c6:b0:184:832b:baf9 with SMTP id e6-20020a056870c0c600b00184832bbaf9mr4792869oad.3.1682099655392;
        Fri, 21 Apr 2023 10:54:15 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7380:c348:a30c:7e82])
        by smtp.gmail.com with ESMTPSA id e3-20020a9d5603000000b006a633d75310sm850426oti.16.2023.04.21.10.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 10:54:15 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v4 3/4] net/sched: sch_qfq: refactor parsing of netlink parameters
Date:   Fri, 21 Apr 2023 14:53:43 -0300
Message-Id: <20230421175344.299496-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230421175344.299496-1-pctammela@mojatatu.com>
References: <20230421175344.299496-1-pctammela@mojatatu.com>
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_qfq.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 323609cfbc67..dfd9a99e6257 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -113,6 +113,7 @@
 
 #define QFQ_MTU_SHIFT		16	/* to support TSO/GSO */
 #define QFQ_MIN_LMAX		512	/* see qfq_slot_insert */
+#define QFQ_MAX_LMAX		(1UL << QFQ_MTU_SHIFT)
 
 #define QFQ_MAX_AGG_CLASSES	8 /* max num classes per aggregate allowed */
 
@@ -214,9 +215,14 @@ static struct qfq_class *qfq_find_class(struct Qdisc *sch, u32 classid)
 	return container_of(clc, struct qfq_class, common);
 }
 
+static struct netlink_range_validation lmax_range = {
+	.min = QFQ_MIN_LMAX,
+	.max = QFQ_MAX_LMAX,
+};
+
 static const struct nla_policy qfq_policy[TCA_QFQ_MAX + 1] = {
-	[TCA_QFQ_WEIGHT] = { .type = NLA_U32 },
-	[TCA_QFQ_LMAX] = { .type = NLA_U32 },
+	[TCA_QFQ_WEIGHT] = NLA_POLICY_RANGE(NLA_U32, 1, QFQ_MAX_WEIGHT),
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

