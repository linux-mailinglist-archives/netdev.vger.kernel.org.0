Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD751FA042
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730095AbgFOT3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:29:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39015 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729780AbgFOT3q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:29:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592249385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AV2xqA1wqNYV+em9IYm4pp4fMrDQzxhV9zZdRR+JjNc=;
        b=S9tcpmswpbK4ocuzLp6DkQsv/n5xMAsHd7oomHfWcM3fVYugKIearfNYUfQC2XFWtr97/N
        +pGd4NDa35wb9zl4x9O5dt4yLTkyPdFIPsFuaEUgmBsjACcxX3cAZeCn6e1QNT+Go8ZBR9
        w/b5fkn7Gdu6uWRL6Y+nu77agq/0W0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-223-yFtPpP5DOGaBdXCnAK6CSQ-1; Mon, 15 Jun 2020 15:29:41 -0400
X-MC-Unique: yFtPpP5DOGaBdXCnAK6CSQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2B1E5107B470;
        Mon, 15 Jun 2020 19:29:40 +0000 (UTC)
Received: from new-host-5.redhat.com (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD15C6ED96;
        Mon, 15 Jun 2020 19:29:38 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Po Liu <Po.Liu@nxp.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net v2 2/2] net/sched: act_gate: fix configuration of the periodic timer
Date:   Mon, 15 Jun 2020 21:28:27 +0200
Message-Id: <4a4a840333d6ba06042b9faf7e181048d5dc2433.1592247564.git.dcaratti@redhat.com>
In-Reply-To: <cover.1592247564.git.dcaratti@redhat.com>
References: <cover.1592247564.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

assigning a dummy value of 'clock_id' to avoid cancellation of the cycle
timer before its initialization was a temporary solution, and we still
need to handle the case where act_gate timer parameters are changed by
commands like the following one:

 # tc action replace action gate <parameters>

the fix consists in the following items:

1) remove the workaround assignment of 'clock_id', and init the list of
   entries before the first error path after IDR atomic check/allocation
2) validate 'clock_id' earlier: there is no need to do IDR atomic
   check/allocation if we know that 'clock_id' is a bad value
3) use a dedicated function, 'gate_setup_timer()', to ensure that the
   timer is cancelled and re-initialized on action overwrite, and also
   ensure we initialize the timer in the error path of tcf_gate_init()

v2: avoid 'goto' in gate_setup_timer (thanks to Cong Wang)

CC: Ivan Vecera <ivecera@redhat.com>
Fixes: a01c245438c5 ("net/sched: fix a couple of splats in the error path of tfc_gate_init()")
Fixes: a51c328df310 ("net: qos: introduce a gate control flow action")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
---
 net/sched/act_gate.c | 88 ++++++++++++++++++++++++++------------------
 1 file changed, 53 insertions(+), 35 deletions(-)

diff --git a/net/sched/act_gate.c b/net/sched/act_gate.c
index 6775ccf355b0..3c529a4bcca5 100644
--- a/net/sched/act_gate.c
+++ b/net/sched/act_gate.c
@@ -272,6 +272,27 @@ static int parse_gate_list(struct nlattr *list_attr,
 	return err;
 }
 
+static void gate_setup_timer(struct tcf_gate *gact, u64 basetime,
+			     enum tk_offsets tko, s32 clockid,
+			     bool do_init)
+{
+	if (!do_init) {
+		if (basetime == gact->param.tcfg_basetime &&
+		    tko == gact->tk_offset &&
+		    clockid == gact->param.tcfg_clockid)
+			return;
+
+		spin_unlock_bh(&gact->tcf_lock);
+		hrtimer_cancel(&gact->hitimer);
+		spin_lock_bh(&gact->tcf_lock);
+	}
+	gact->param.tcfg_basetime = basetime;
+	gact->param.tcfg_clockid = clockid;
+	gact->tk_offset = tko;
+	hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS_SOFT);
+	gact->hitimer.function = gate_timer_func;
+}
+
 static int tcf_gate_init(struct net *net, struct nlattr *nla,
 			 struct nlattr *est, struct tc_action **a,
 			 int ovr, int bind, bool rtnl_held,
@@ -303,6 +324,27 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 	if (!tb[TCA_GATE_PARMS])
 		return -EINVAL;
 
+	if (tb[TCA_GATE_CLOCKID]) {
+		clockid = nla_get_s32(tb[TCA_GATE_CLOCKID]);
+		switch (clockid) {
+		case CLOCK_REALTIME:
+			tk_offset = TK_OFFS_REAL;
+			break;
+		case CLOCK_MONOTONIC:
+			tk_offset = TK_OFFS_MAX;
+			break;
+		case CLOCK_BOOTTIME:
+			tk_offset = TK_OFFS_BOOT;
+			break;
+		case CLOCK_TAI:
+			tk_offset = TK_OFFS_TAI;
+			break;
+		default:
+			NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
+			return -EINVAL;
+		}
+	}
+
 	parm = nla_data(tb[TCA_GATE_PARMS]);
 	index = parm->index;
 
@@ -326,10 +368,6 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 		tcf_idr_release(*a, bind);
 		return -EEXIST;
 	}
-	if (ret == ACT_P_CREATED) {
-		to_gate(*a)->param.tcfg_clockid = -1;
-		INIT_LIST_HEAD(&(to_gate(*a)->param.entries));
-	}
 
 	if (tb[TCA_GATE_PRIORITY])
 		prio = nla_get_s32(tb[TCA_GATE_PRIORITY]);
@@ -340,33 +378,14 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 	if (tb[TCA_GATE_FLAGS])
 		gflags = nla_get_u32(tb[TCA_GATE_FLAGS]);
 
-	if (tb[TCA_GATE_CLOCKID]) {
-		clockid = nla_get_s32(tb[TCA_GATE_CLOCKID]);
-		switch (clockid) {
-		case CLOCK_REALTIME:
-			tk_offset = TK_OFFS_REAL;
-			break;
-		case CLOCK_MONOTONIC:
-			tk_offset = TK_OFFS_MAX;
-			break;
-		case CLOCK_BOOTTIME:
-			tk_offset = TK_OFFS_BOOT;
-			break;
-		case CLOCK_TAI:
-			tk_offset = TK_OFFS_TAI;
-			break;
-		default:
-			NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
-			goto release_idr;
-		}
-	}
+	gact = to_gate(*a);
+	if (ret == ACT_P_CREATED)
+		INIT_LIST_HEAD(&gact->param.entries);
 
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
 
-	gact = to_gate(*a);
-
 	spin_lock_bh(&gact->tcf_lock);
 	p = &gact->param;
 
@@ -397,14 +416,10 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 		p->tcfg_cycletime_ext =
 			nla_get_u64(tb[TCA_GATE_CYCLE_TIME_EXT]);
 
+	gate_setup_timer(gact, basetime, tk_offset, clockid,
+			 ret == ACT_P_CREATED);
 	p->tcfg_priority = prio;
-	p->tcfg_basetime = basetime;
-	p->tcfg_clockid = clockid;
 	p->tcfg_flags = gflags;
-
-	gact->tk_offset = tk_offset;
-	hrtimer_init(&gact->hitimer, clockid, HRTIMER_MODE_ABS_SOFT);
-	gact->hitimer.function = gate_timer_func;
 	gate_get_start_time(gact, &start);
 
 	gact->current_close_time = start;
@@ -433,6 +448,11 @@ static int tcf_gate_init(struct net *net, struct nlattr *nla,
 	if (goto_ch)
 		tcf_chain_put_by_act(goto_ch);
 release_idr:
+	/* action is not in: hitimer can be inited without taking tcf_lock */
+	if (ret == ACT_P_CREATED)
+		gate_setup_timer(gact, gact->param.tcfg_basetime,
+				 gact->tk_offset, gact->param.tcfg_clockid,
+				 true);
 	tcf_idr_release(*a, bind);
 	return err;
 }
@@ -443,9 +463,7 @@ static void tcf_gate_cleanup(struct tc_action *a)
 	struct tcf_gate_params *p;
 
 	p = &gact->param;
-	if (p->tcfg_clockid != -1)
-		hrtimer_cancel(&gact->hitimer);
-
+	hrtimer_cancel(&gact->hitimer);
 	release_entry_list(&p->entries);
 }
 
-- 
2.26.2

