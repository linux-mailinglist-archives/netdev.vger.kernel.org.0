Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4274C696F18
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 22:17:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232374AbjBNVRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 16:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232289AbjBNVQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 16:16:58 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811AF2DE63
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:17 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id c15so14129890oic.8
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 13:16:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KavwqUj3uZm7yt5naYHAZ7q+9drM8jRotSOvbOQo82k=;
        b=RJpn1ZoaR2bER05VBVPWCn5fZeNFiWU01LSPun4XOex7rkX2VKdbWC8kDxMjCCU54I
         BMyTPxRqC7whljCuwyXmI2d4J4LY9Q1cgT3oSMFkYaTCDVDV83y5GxbGjTdw37S3K+MZ
         P5wgWCRBU0YpqZYQKspRqNpVwfigxSPcySMkx9UnVwBYijKF8QPPdlIQ6SQen8yvO3Mj
         pnsgNiGZQamUhDvtJs8vcQODzSMUJcToB4iEL/VsppZz4ixayLQzvuwTaKEvk2wv88T3
         Kgjwv92T2P/6x1GrNKdjlTd2a+4Li6kgma3yJ7T1ovTUuqLcHet6u2qIEyNoeaXo4Pjw
         VJoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KavwqUj3uZm7yt5naYHAZ7q+9drM8jRotSOvbOQo82k=;
        b=bDje2wlwqEWy4IYzmdjOTusYAdGFmQ5Q5DcKOlXtrCNs8/i+3k66FtK7oSwW0Dpt7W
         +7oIht+Sko6aq2Jok5+W2yl39urCyIufZbBLTfF3oDsl5KtxzZX0gw9hA7vr2kVv+32U
         YRM1phhkH2hsw7xaARLrMOd4v8i0TnQ1NtTKUYn9QZ1fkarSHuABA3Jh15fjPDwuTOp2
         iuymrHc6dbZyy5dK7N/xjiTTH4lSeTsT4ZTEDbe/iUl5kbUzgYD6FTjjbOEHX0pHj6os
         ugqeYkiOTpNRH+WRelfPiw2PR8IMnEWFX8H3CGsMA+c/9EHISKQMdnexP1ZdJKO6H5XK
         P70g==
X-Gm-Message-State: AO0yUKUttefpcBo4btu6RXB58/TEhqGDvGFyBX4/wCUmMchDU5gP6iqX
        laWcyqL3cSO5a1Bc023RB1dPQ5/1u2zaGLqw
X-Google-Smtp-Source: AK7set+Br5NvnP/CTx/qyJLksJzgl4qh+GkRQDsIlltanR4FTmgCn4vB6430R60cFjXyF82dL2tELA==
X-Received: by 2002:aca:1907:0:b0:37a:ec66:a28 with SMTP id l7-20020aca1907000000b0037aec660a28mr1875993oii.25.1676409360609;
        Tue, 14 Feb 2023 13:16:00 -0800 (PST)
Received: from localhost.localdomain ([2804:14d:5c5e:4698:565a:c0a1:97af:209b])
        by smtp.gmail.com with ESMTPSA id b6-20020a9d5d06000000b0068bd3001922sm6949754oti.45.2023.02.14.13.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Feb 2023 13:15:59 -0800 (PST)
From:   Pedro Tammela <pctammela@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v2 3/4] net/sched: act_gate: use percpu stats
Date:   Tue, 14 Feb 2023 18:15:33 -0300
Message-Id: <20230214211534.735718-4-pctammela@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230214211534.735718-1-pctammela@mojatatu.com>
References: <20230214211534.735718-1-pctammela@mojatatu.com>
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
 net/sched/act_gate.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 9b8def0be41e..c9a811f4c7ee 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -119,35 +119,37 @@ TC_INDIRECT_SCOPE int tcf_gate_act(struct sk_buff *skb,
 				   struct tcf_result *res)
 {
 	struct tcf_gate *gact = to_gate(a);
-
-	spin_lock(&gact->tcf_lock);
+	int action = READ_ONCE(gact->tcf_action);
 
 	tcf_lastuse_update(&gact->tcf_tm);
-	bstats_update(&gact->tcf_bstats, skb);
+	tcf_action_update_bstats(&gact->common, skb);
 
+	spin_lock(&gact->tcf_lock);
 	if (unlikely(gact->current_gate_status & GATE_ACT_PENDING)) {
 		spin_unlock(&gact->tcf_lock);
-		return gact->tcf_action;
+		return action;
 	}
 
-	if (!(gact->current_gate_status & GATE_ACT_GATE_OPEN))
+	if (!(gact->current_gate_status & GATE_ACT_GATE_OPEN)) {
+		spin_unlock(&gact->tcf_lock);
 		goto drop;
+	}
 
 	if (gact->current_max_octets >= 0) {
 		gact->current_entry_octets += qdisc_pkt_len(skb);
 		if (gact->current_entry_octets > gact->current_max_octets) {
-			gact->tcf_qstats.overlimits++;
-			goto drop;
+			spin_unlock(&gact->tcf_lock);
+			goto overlimit;
 		}
 	}
-
 	spin_unlock(&gact->tcf_lock);
 
-	return gact->tcf_action;
-drop:
-	gact->tcf_qstats.drops++;
-	spin_unlock(&gact->tcf_lock);
+	return action;
 
+overlimit:
+	tcf_action_inc_overlimit_qstats(&gact->common);
+drop:
+	tcf_action_inc_drop_qstats(&gact->common);
 	return TC_ACT_SHOT;
 }
 
@@ -357,8 +359,8 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
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

