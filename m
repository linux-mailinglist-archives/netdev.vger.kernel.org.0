Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72FDC6E99E5
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 18:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbjDTQuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 12:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjDTQuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 12:50:10 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AC92721
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:00 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 46e09a7af769-6a604259983so921462a34.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 09:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682009399; x=1684601399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tgTuNzspbyApr+G6Zp0R1bfTdKEOJFb43e3NBF/vvss=;
        b=zFMh5tQFjusVCSykgY6uRLPRP+S8Y+4G/MmHCYM28EA8+qV296CN6j4ScLaxQrgoSh
         3GVUxaB0+S5Ia2HUdrnwfrVcUGNiskbOtwItuKQR8sQAOjsfRodPXGilLh3+xjz/uxT3
         TsvLSJaYYL13MsD2W6BtOKWDjApR8J9/rpCVebTouMVyEJCxqGXSlaxnpFoNbUgFHW3x
         Bl+UfJbwJiUk4elHQ1tNMi9MT/X5iCSeAYKtQO+gORWgxR0gOoHYolyknFKqGTRl04Pt
         7kCcnALUOV4Bbw+fTD/UDpD91t6w+HoQptYII7s54ff0NKfsh5Ibgw7lSymT9m51dvVq
         n8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682009399; x=1684601399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tgTuNzspbyApr+G6Zp0R1bfTdKEOJFb43e3NBF/vvss=;
        b=GjpEPuw1w8nqg67FBS/wQJAXn8+E7Qj4OonGROsisk9ei/p+ihZ1EYPbKYB19BmxvI
         Mlv1wm/1cRdIC1uzE8XG0oWeLd424GXqX4Aek0ONqAi9CwYYXg4+pXDZbpyovKUedKBj
         oREymDH131FdwX5dXfpQEIez3w6rqpU2laje94YxGH94eA06NrJb0ASt38Z2S9V1kVMV
         RCs0KArKtvzZhnuNMpH69Wfaz12MtqidVTaFAWzVjx2BPyLKWcYP0kkfgC95SY5T7TYM
         vYkFg+IWVdJu/2Dt+e3m6R9ddkdUtz5WF7wSCRSyelw5F3s7aFCGRQJbZvyFY0l8fjOg
         YfwQ==
X-Gm-Message-State: AAQBX9dFDRvL+JpgWH9VzfQAeA4qt72XNbif/ZoyHOJyKyYBSivZ86lI
        Loytl4fTSXIdunHTEo0ZYUKZDDynD+4DcdlxuZI=
X-Google-Smtp-Source: AKy350bu3xBvJHDXxGzYOECNn984FArT0DfbmA2F8bd5vLiHow/01e65mWjir+z6vEDRhR05Mw30ow==
X-Received: by 2002:a05:6870:d612:b0:187:fa5e:f209 with SMTP id a18-20020a056870d61200b00187fa5ef209mr1903241oaq.5.1682009399710;
        Thu, 20 Apr 2023 09:49:59 -0700 (PDT)
Received: from localhost.localdomain ([2804:14d:5c5e:44fb:7668:3bb3:e9e3:6d75])
        by smtp.gmail.com with ESMTPSA id p26-20020a9d695a000000b006a13dd5c8a2sm894542oto.5.2023.04.20.09.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 09:49:59 -0700 (PDT)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, simon.horman@corigine.com,
        Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v3 1/5] net/sched: sch_htb: use extack on errors messages
Date:   Thu, 20 Apr 2023 13:49:24 -0300
Message-Id: <20230420164928.237235-2-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230420164928.237235-1-pctammela@mojatatu.com>
References: <20230420164928.237235-1-pctammela@mojatatu.com>
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

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/sch_htb.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 92f2975b6a82..8aef7dd9fb88 100644
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
+				NL_SET_ERR_MSG_WEAK(extack,
+						    "Failed to offload TC_HTB_LEAF_ALLOC_QUEUE");
 				goto err_kill_estimator;
 			}
 			dev_queue = netdev_get_tx_queue(dev, offload_opt.qid);
@@ -1937,8 +1937,8 @@ static int htb_change_class(struct Qdisc *sch, u32 classid,
 			};
 			err = htb_offload(dev, &offload_opt);
 			if (err) {
-				pr_err("htb: TC_HTB_LEAF_TO_INNER failed with err = %d\n",
-				       err);
+				NL_SET_ERR_MSG_WEAK(extack,
+						    "Failed to offload TC_HTB_LEAF_TO_INNER");
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

