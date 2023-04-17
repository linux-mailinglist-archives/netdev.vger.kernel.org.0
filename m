Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438B26E4EE4
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 19:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjDQRMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 13:12:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjDQRMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 13:12:37 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6344C37
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:36 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id x11-20020a056830244b00b006a5f4f2cf62so528217otr.0
        for <netdev@vger.kernel.org>; Mon, 17 Apr 2023 10:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681751555; x=1684343555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXdXDzyGk6iT5YQWWTrZVDCFohkn9nQAvWnRKQAv8zM=;
        b=G8L5sFBGLdfuLG3/QbJYQgNaPiMJLfNqcQ6qgODjnYusqPFw0cE8nPx6fE8i9knj70
         7t8XRxPdZljSMkrSPuct8gVATFnIA2ULe3qsOiMUMul+IC/8StEkp59i+sZoc/6+uL5r
         WlgtFUIRTYK9fWHNtLtnewVTzLZ8RCtHe03Z1dLiDPDIKC3hXMjAdySHGi2Ap0QHGZTr
         e/rwkIgD5iY8zE4CqZ5bNWQYEOVpHydpECvClbQc8JsxsOFaDz9rp2gSTaKPQQZZ63Pk
         9g70n4yCAuZ1k0RuLcaYb53lb7WwK+l9u/0LOWnMDHuUZQ1X5ParoUe/c3iEwnZBlwim
         ge7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681751555; x=1684343555;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXdXDzyGk6iT5YQWWTrZVDCFohkn9nQAvWnRKQAv8zM=;
        b=Z2QUqeMDx1LMa8gaN2s3CqWJ1gfNWnJss7v+96XjmS52HLwF9OA7REkbsIsPNWlkgO
         M1V61N3xBi1cKwxJSNm1s3LAqxzd2NqdlG2kYwCvGlmGk70GEjpqGVrvKenqWwv8mmS6
         F8LxsV4vpdZGamiiVqU6wmqt5jOYFFFCnfs+6H2Rqe50iZH0VzJuz11fFOWMCklIS3Gq
         I93bYlhgJaunFBrePGjK1cerNTDYA91ka2/Qvrm/wf9zpL5G/QK0evSfU2CbTCsgagZJ
         n/6gvXtrQi84Pery4xY8gXjgk7/gkr2vIRIdNTPIIcn5EygqaanQaKrlYgJKpHIUY5vW
         uenQ==
X-Gm-Message-State: AAQBX9c21lrFPEaxhnQa5rag9hDEL/j9lHtg1Zw/GlchpDVMsO+D6sTc
        NKah3r1GZOZUtysjTzCVxFU3KA2KxjLoinAPeuQ=
X-Google-Smtp-Source: AKy350Yopg3tlNImacX//7muwu6vlMVBs4WAVHBhxKWDcbcEE1W0Kpwku9ewgBbJZkUUlZwbgJPERQ==
X-Received: by 2002:a05:6830:1144:b0:6a5:f719:c2f2 with SMTP id x4-20020a056830114400b006a5f719c2f2mr30679otq.30.1681751555506;
        Mon, 17 Apr 2023 10:12:35 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:150:be5b:9489:90ac])
        by smtp.gmail.com with ESMTPSA id v17-20020a9d5a11000000b006a205a8d5bdsm4761248oth.45.2023.04.17.10.12.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 10:12:35 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 1/4] net/sched: sch_htb: use extack on errors messages
Date:   Mon, 17 Apr 2023 14:12:15 -0300
Message-Id: <20230417171218.333567-2-pctammela@mojatatu.com>
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

Some error messages are still being printed to dmesg.
Since extack is available, provide error messages there.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_htb.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 92f2975b6a82..79f5c4454fc3 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -1786,7 +1786,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 		goto failure;
 
 	err = nla_parse_nested_deprecated(tb, TCA_HTB_MAX, opt, htb_policy,
-					  NULL);
+					  extack);
 	if (err < 0)
 		goto failure;
 
@@ -1858,7 +1858,7 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 
 		/* check maximal depth */
 		if (parent && parent->parent && parent->parent->level < 2) {
-			pr_err("htb: tree is too deep\n");
+			NL_SET_ERR_MSG_MOD(extack, "tree is too deep");
 			goto failure;
 		}
 		err = -ENOBUFS;
@@ -1917,8 +1917,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			};
 			err = htb_offload(dev, &offload_opt);
 			if (err) {
-				pr_err("htb: TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
-				       err);
+				NL_SET_ERR_MSG(extack,
+					       "Failed to offload leaf alloc queue");
 				goto err_kill_estimator;
 			}
 			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
@@ -1937,8 +1937,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			};
 			err = htb_offload(dev, &offload_opt);
 			if (err) {
-				pr_err("htb: TC_HTB_LEAF_TO_INNER failed with err = %d\n",
-				       err);
+				NL_SET_ERR_MSG(extack,
+					       "Failed to offload leaf to inner");
 				htb_graft_helper(dev_queue, old_q);
 				goto err_kill_estimator;
 			}
@@ -2067,8 +2067,9 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 	qdisc_put(parent_qdisc);
 
 	if (warn)
-		pr_warn("HTB: quantum of class %X is %s. Consider r2q change.\n",
-			    cl->common.classid, (warn == -1 ? "small" : "big"));
+		NL_SET_ERR_MSG_FMT_MOD(extack,
+				       "quantum of class %X is %s. Consider r2q change.",
+				       cl->common.classid, (warn == -1 ? "small" : "big"));
 
 	qdisc_class_hash_grow(sch, &q->clhash);
 
-- 
2.34.1

