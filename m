Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56086E2A46
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjDNSyG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 14:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjDNSyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 14:54:05 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF321900B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 11:54:02 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-1879502e2afso6906487fac.5
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 11:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1681498442; x=1684090442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qSoqFwt7+H1OOSAj/UltcwIpxh1Rmjza6T4iPRFz5fU=;
        b=TSyScEEXOSspRLuGg7/uUU/YiEh7/YSv2Ph3qqsIeKnVU3CBJ1Rjz5CYiAo4Kd9thA
         OuPLrESaJuUqmQiPd4+k1jJNlW1LASs8TfkWkSwGZUvFsWctPlT7zLgfXZt+AqVhgtVw
         595MAmRxuwDRNottZfrqyhlssJFhndQBDoiW4+gHXgcv0l3Lc29fMuVfcpPONLOyYfB+
         YYuDQ/Bd/Tm25fIY0SxU3e6sjRczHfvsGHR9hBF/asjDV+gI68oNT444j6ln4Qj33YvJ
         s6FTVttdMs44ACENhBi9UMWRgQdW2pJU9CGRSpbbQ220eOBhQehmUXJSkFeXNlWb2LsT
         AkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681498442; x=1684090442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qSoqFwt7+H1OOSAj/UltcwIpxh1Rmjza6T4iPRFz5fU=;
        b=NzMXsqAQ8wM2kUBY7oXYODT6mchtyVZKSCBYbIK7M69ojnftyWuHuZFxFL7ltpDeDj
         0GlIHgYt0O4m0BaJu+DDtSAHM9FZSDkoXbZkUV6Xy7HESqs8DP9lJRVGyptO0b3TmBkS
         KHl/fFMk+zsguelu4wJWnEZhWvfvCIbPSGAmZVoSGuE8OHoQL4MjcGxswwyugWgH79MR
         jpnG9xKCkkvrOL+XYveQO3uJgIglv4G0FiM72sYqo0czViuLU7ncBTvG80ZNp3OROmLF
         x2/pzG++9oTxmJe6k0hVr424hDLXfKuOhSQ+E0r6iJije1Gz71g7heL1GkZknK5s5oJe
         0J4g==
X-Gm-Message-State: AAQBX9e122+pbLUFf5B54xh9GElxXgItD7jblHKiJhEnYtrhApg8PhEY
        Vyek7XKE3FbblIRh+eAtCXq0K1Slcdnn7Gcl25Y=
X-Google-Smtp-Source: AKy350a6zSWYVchSjZ/J4feBYxBQ7OwooINn/Pjgq7VdA2jHGImOAL3M7GdzW84GSuYyOM6im/Saww==
X-Received: by 2002:a05:6870:9123:b0:184:3c53:655a with SMTP id o35-20020a056870912300b001843c53655amr4122414oae.21.1681498441980;
        Fri, 14 Apr 2023 11:54:01 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:bb6:61a2:bf8b:4710])
        by smtp.gmail.com with ESMTPSA id z21-20020a056870515500b0017f647294f5sm2096061oak.16.2023.04.14.11.53.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 11:54:01 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 1/2] net/sched: sch_htb: use extack on errors messages
Date:   Fri, 14 Apr 2023 15:53:09 -0300
Message-Id: <20230414185309.220286-2-pctammela@mojatatu.com>
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
Since extack is available, provide error messages there.

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_htb.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 92f2975b6a82..bc2da8027650 100644
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
@@ -1917,8 +1917,9 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			};
 			err = htb_offload(dev, &offload_opt);
 			if (err) {
-				pr_err("htb: TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
-				       err);
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "TC_HTB_LEAF_ALLOC_QUEUE failed with err = %d\n",
+						       err);
 				goto err_kill_estimator;
 			}
 			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
@@ -1937,8 +1938,9 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			};
 			err = htb_offload(dev, &offload_opt);
 			if (err) {
-				pr_err("htb: TC_HTB_LEAF_TO_INNER failed with err = %d\n",
-				       err);
+				NL_SET_ERR_MSG_FMT_MOD(extack,
+						       "TC_HTB_LEAF_TO_INNER failed with err = %d",
+						       err);
 				htb_graft_helper(dev_queue, old_q);
 				goto err_kill_estimator;
 			}
@@ -2067,8 +2069,9 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
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

