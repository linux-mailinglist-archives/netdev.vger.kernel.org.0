Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0B9692892
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 21:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjBJUpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 15:45:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233455AbjBJUpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 15:45:06 -0500
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753BE7BFF4
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:45:05 -0800 (PST)
Received: by mail-ot1-x32c.google.com with SMTP id j6-20020a9d7686000000b0068d4ba9d141so1913018otl.6
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 12:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=klTTMIfmdsm2ecsXNiJzppXWn6h+94D9gmx9QXWwnPw=;
        b=o8HCLPjj5QrMmIfV9mks9EmiaiWj4xQdqkMJLpr7ks4YRJTJ1hdIWNBp2uJqRa2l0x
         x0y9f8LEZGD0bRlDdln/WHtjE0SZnsXroT6as+g/2zQICh7wTboOBUeC+Thzx5UP2Y0+
         BKBIgHEYo9M5cXRieXQUL1k/r5v8VUgoO2mD5u+7qDGLgA8CusahzZQAfKZs9EMqHCIM
         Do2rw8ALGGlnFSPLoTu9x7nHKKbsLfZ2l1O6IZA3gXZcOI7r9aKHmXbSfaUxXeirzobH
         35GbfVtu8Du3Fz5VOG8xLRDDLPY5w8l24HOvw6kLp1E+RPOyUOarH05xko2ha5WatGag
         AaMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=klTTMIfmdsm2ecsXNiJzppXWn6h+94D9gmx9QXWwnPw=;
        b=aaLrMakolmCK1iHtvvHATrY/5mIW7BdBHj7UWyr62YcXMqYfNjCEoKmCM9X+5Tj77x
         uDZwIImWDZ0EdSlUoNV4bOumNg1rn/iw8GACCzXg/YX7pKnlTRDE6AvMRmtzNxesbtTw
         8ETpXaptZ5RY1PMoKVSWrJq/yHLi1C47nUe5Z/RVPxci+Ttg3ULCU8Sqf40gyGbpNtMm
         l6z7aJiXB1OX4BBdxU0tz8jT0IyZRmA/MFkwAj8XpFAsWPr7FMLORwRN1Z7ezeA5nw2Y
         K4uEAa/JfLcnB4ii5kdDVdJv5XwNgJIlHaP0/YK0umQUZ0BAw7CrpCORTtAjnh4tvCwA
         RHOg==
X-Gm-Message-State: AO0yUKX3uNkuUSlpx4KWqEpC6w3VVjZVISP05cecj6uSlnGzgK0KHyzU
        fEBLsHvQ7N2R9kUIN5nCgys4Dw5uEPXFamKT
X-Google-Smtp-Source: AK7set9ue7VHnN8mn7PTYKj4E0NIaMUgKSpC9JzAHhsOsyYvgS5P4N0GsfdMQJ9ofUKzNVNZ3AyHcQ==
X-Received: by 2002:a9d:6e96:0:b0:671:e5c1:219c with SMTP id a22-20020a9d6e96000000b00671e5c1219cmr9274851otr.21.1676061904702;
        Fri, 10 Feb 2023 12:45:04 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:2ce0:9122:6880:760c])
        by smtp.gmail.com with ESMTPSA id v23-20020a9d5a17000000b0068bc8968753sm2396681oth.17.2023.02.10.12.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 12:45:04 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next 3/3] net/sched: act_gate: use percpu stats
Date:   Fri, 10 Feb 2023 17:27:26 -0300
Message-Id: <20230210202725.446422-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230210202725.446422-1-pctammela@mojatatu.com>
References: <20230210202725.446422-1-pctammela@mojatatu.com>
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

The tc action act_gate was using shared stats, move it to percpu stats.

tdc results:
1..12
ok 1 5153 - Add gate action with priority and sched-entry
ok 2 7189 - Add gate action with base-time
ok 3 a721 - Add gate action with cycle-time
ok 4 c029 - Add gate action with cycle-time-ext
ok 5 3719 - Replace gate base-time action
ok 6 d821 - Delete gate action with valid index
ok 7 3128 - Delete gate action with invalid index
ok 8 7837 - List gate actions
ok 9 9273 - Flush gate actions
ok 10 c829 - Add gate action with duplicate index
ok 11 3043 - Add gate action with invalid index
ok 12 2930 - Add gate action with cookie

Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
---
 net/sched/act_gate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 9b8def0be..684b7a79f 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -120,10 +120,10 @@ TC_INDIRECT_SCOPE int tcf_gate_act(struct sk_buff *skb,
 {
 	struct tcf_gate *gact = to_gate(a);
 
-	spin_lock(&gact->tcf_lock);
-
 	tcf_lastuse_update(&gact->tcf_tm);
-	bstats_update(&gact->tcf_bstats, skb);
+	tcf_action_update_bstats(&gact->common, skb);
+
+	spin_lock(&gact->tcf_lock);
 
 	if (unlikely(gact->current_gate_status & GATE_ACT_PENDING)) {
 		spin_unlock(&gact->tcf_lock);
@@ -357,8 +357,8 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 		return 0;
 
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_gate_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_gate_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
-- 
2.34.1

