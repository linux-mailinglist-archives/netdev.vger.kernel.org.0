Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06201334300
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 17:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbhCJQ1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Mar 2021 11:27:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhCJQ0q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Mar 2021 11:26:46 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA195C061760
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 08:26:46 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so7771199pjb.2
        for <netdev@vger.kernel.org>; Wed, 10 Mar 2021 08:26:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vqh3iswc2/DhXiCMeq0+jsgfi9/W1GyAnlDULbpUo1w=;
        b=Tu+jqWeAAngCXCZSq001rM3x6Nxt1PfHbmADLUg+22w3W1lJ5bdvdeUg235xJmEb17
         5lCEKKReRrSHs1oLjM89LQtxDzYNx/l4huK3lDNo4ljpRduzigAIcvkQpMIjTcV7UKQu
         j+BjDqwGMEGUBH9hMRA7ndE4viNQs/aKTZva2EamoaqIrj4BIKYz+MRl0Qf1ekjfbqnL
         usdQvUxClVLGgYdyiY/ndAbrkmEmmONyXS2ugQHkyMqqQNq8ONS4RIhgqOnwS+CcKfzl
         5++puQ4fwYzPi3KngymzBMk/1cU+Bu/FcgaA9ww2xyYDbuXCSXieJl3QlwMlAamIaRnh
         PBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vqh3iswc2/DhXiCMeq0+jsgfi9/W1GyAnlDULbpUo1w=;
        b=HYsc6W0ZCpB8EeVsJgUU0ByWevama1Rjnd3teZuiwoC4v85qa6XC875E5WN7RwLWgu
         HM2EH8GJlsnHxL6HvVFuOOcVDO+Aotkr1uc8+H9p0L9suJVbM4+ee8kXhCsV5n47F29G
         6Jazev5ZJJpRa2udBoaL/q3gBXZifp1wQt+1Kx4z4JbOBXn6WoDzAEJoPKHRGVfOlsip
         J+H+6f4eYANKkxt3ZEg63ZIf/L3PfLhqglPWKredRKHdD68uHtWlIKSlQBWF3XgMTVXj
         PIScUqmNzZ8Umtg28cWaH4fgnftrySD66BJq4v6y1zp5p+dcVCu23r8f5QhiAeLJYkQb
         y9Ig==
X-Gm-Message-State: AOAM531s+kE8QKajdja5RuXrSHBck1WoIWJ1hNTNXt3F4bJtHoOagFpr
        JZKdHZxdL73bjE0uUnoYKPI=
X-Google-Smtp-Source: ABdhPJxxCrvFhX7C5VbXMWo7uusRrupqjnL3WjFBzP9apFE3oM8jjwN4pyIaUiPQQ4DPcw9eIYCu6g==
X-Received: by 2002:a17:90a:fd0a:: with SMTP id cv10mr4207243pjb.167.1615393606364;
        Wed, 10 Mar 2021 08:26:46 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e4bc:1137:a87:e7e5])
        by smtp.gmail.com with ESMTPSA id d7sm25278pfh.73.2021.03.10.08.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 08:26:45 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net: sched: validate stab values
Date:   Wed, 10 Mar 2021 08:26:41 -0800
Message-Id: <20210310162641.264570-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

iproute2 package is well behaved, but malicious user space can
provide illegal shift values and trigger UBSAN reports.

Add stab parameter to red_check_params() to validate user input.

syzbot reported:

UBSAN: shift-out-of-bounds in ./include/net/red.h:312:18
shift exponent 111 is too large for 64-bit type 'long unsigned int'
CPU: 1 PID: 14662 Comm: syz-executor.3 Not tainted 5.12.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:79 [inline]
 dump_stack+0x141/0x1d7 lib/dump_stack.c:120
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:148
 __ubsan_handle_shift_out_of_bounds.cold+0xb1/0x181 lib/ubsan.c:327
 red_calc_qavg_from_idle_time include/net/red.h:312 [inline]
 red_calc_qavg include/net/red.h:353 [inline]
 choke_enqueue.cold+0x18/0x3dd net/sched/sch_choke.c:221
 __dev_xmit_skb net/core/dev.c:3837 [inline]
 __dev_queue_xmit+0x1943/0x2e00 net/core/dev.c:4150
 neigh_hh_output include/net/neighbour.h:499 [inline]
 neigh_output include/net/neighbour.h:508 [inline]
 ip6_finish_output2+0x911/0x1700 net/ipv6/ip6_output.c:117
 __ip6_finish_output net/ipv6/ip6_output.c:182 [inline]
 __ip6_finish_output+0x4c1/0xe10 net/ipv6/ip6_output.c:161
 ip6_finish_output+0x35/0x200 net/ipv6/ip6_output.c:192
 NF_HOOK_COND include/linux/netfilter.h:290 [inline]
 ip6_output+0x1e4/0x530 net/ipv6/ip6_output.c:215
 dst_output include/net/dst.h:448 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 NF_HOOK include/linux/netfilter.h:295 [inline]
 ip6_xmit+0x127e/0x1eb0 net/ipv6/ip6_output.c:320
 inet6_csk_xmit+0x358/0x630 net/ipv6/inet6_connection_sock.c:135
 dccp_transmit_skb+0x973/0x12c0 net/dccp/output.c:138
 dccp_send_reset+0x21b/0x2b0 net/dccp/output.c:535
 dccp_finish_passive_close net/dccp/proto.c:123 [inline]
 dccp_finish_passive_close+0xed/0x140 net/dccp/proto.c:118
 dccp_terminate_connection net/dccp/proto.c:958 [inline]
 dccp_close+0xb3c/0xe60 net/dccp/proto.c:1028
 inet_release+0x12e/0x280 net/ipv4/af_inet.c:431
 inet6_release+0x4c/0x70 net/ipv6/af_inet6.c:478
 __sock_release+0xcd/0x280 net/socket.c:599
 sock_close+0x18/0x20 net/socket.c:1258
 __fput+0x288/0x920 fs/file_table.c:280
 task_work_run+0xdd/0x1a0 kernel/task_work.c:140
 tracehook_notify_resume include/linux/tracehook.h:189 [inline]

Fixes: 8afa10cbe281 ("net_sched: red: Avoid illegal values")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 include/net/red.h     | 10 +++++++++-
 net/sched/sch_choke.c |  7 ++++---
 net/sched/sch_gred.c  |  2 +-
 net/sched/sch_red.c   |  7 +++++--
 net/sched/sch_sfq.c   |  2 +-
 5 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/include/net/red.h b/include/net/red.h
index 932f0d79d60cbbab60db73baddc8b650935b3bf6..9e6647c4ccd1fae85aedc5c214bde7b6769b4665 100644
--- a/include/net/red.h
+++ b/include/net/red.h
@@ -168,7 +168,8 @@ static inline void red_set_vars(struct red_vars *v)
 	v->qcount	= -1;
 }
 
-static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog, u8 Scell_log)
+static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog,
+				    u8 Scell_log, u8 *stab)
 {
 	if (fls(qth_min) + Wlog > 32)
 		return false;
@@ -178,6 +179,13 @@ static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog, u8 Scell_
 		return false;
 	if (qth_max < qth_min)
 		return false;
+	if (stab) {
+		int i;
+
+		for (i = 0; i < RED_STAB_SIZE; i++)
+			if (stab[i] >= 32)
+				return false;
+	}
 	return true;
 }
 
diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index 50f680f03a547ebe952eae9657b40d4de0fc5c9f..2adbd945bf15aee182bc1505ec54b9695d104d52 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -345,6 +345,7 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 	struct sk_buff **old = NULL;
 	unsigned int mask;
 	u32 max_P;
+	u8 *stab;
 
 	if (opt == NULL)
 		return -EINVAL;
@@ -361,8 +362,8 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 	max_P = tb[TCA_CHOKE_MAX_P] ? nla_get_u32(tb[TCA_CHOKE_MAX_P]) : 0;
 
 	ctl = nla_data(tb[TCA_CHOKE_PARMS]);
-
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
+	stab = nla_data(tb[TCA_CHOKE_STAB]);
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log, stab))
 		return -EINVAL;
 
 	if (ctl->limit > CHOKE_MAX_QUEUE)
@@ -412,7 +413,7 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 
 	red_set_parms(&q->parms, ctl->qth_min, ctl->qth_max, ctl->Wlog,
 		      ctl->Plog, ctl->Scell_log,
-		      nla_data(tb[TCA_CHOKE_STAB]),
+		      stab,
 		      max_P);
 	red_set_vars(&q->vars);
 
diff --git a/net/sched/sch_gred.c b/net/sched/sch_gred.c
index e0bc77533acc39d90dbbffc88241ea3063e27d3f..f4132dc25ac05bf276c22e8ab967541fbf898463 100644
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -480,7 +480,7 @@ static inline int gred_change_vq(struct Qdisc *sch, int dp,
 	struct gred_sched *table = qdisc_priv(sch);
 	struct gred_sched_data *q = table->tab[dp];
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log)) {
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log, stab)) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid RED parameters");
 		return -EINVAL;
 	}
diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index b4ae34d7aa965decf541660ee195df92f646f799..40adf1f07a82dfdb8f704eecfa9a14f000213a91 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -242,6 +242,7 @@ static int __red_change(struct Qdisc *sch, struct nlattr **tb,
 	unsigned char flags;
 	int err;
 	u32 max_P;
+	u8 *stab;
 
 	if (tb[TCA_RED_PARMS] == NULL ||
 	    tb[TCA_RED_STAB] == NULL)
@@ -250,7 +251,9 @@ static int __red_change(struct Qdisc *sch, struct nlattr **tb,
 	max_P = tb[TCA_RED_MAX_P] ? nla_get_u32(tb[TCA_RED_MAX_P]) : 0;
 
 	ctl = nla_data(tb[TCA_RED_PARMS]);
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
+	stab = nla_data(tb[TCA_RED_STAB]);
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog,
+			      ctl->Scell_log, stab))
 		return -EINVAL;
 
 	err = red_get_flags(ctl->flags, TC_RED_HISTORIC_FLAGS,
@@ -288,7 +291,7 @@ static int __red_change(struct Qdisc *sch, struct nlattr **tb,
 	red_set_parms(&q->parms,
 		      ctl->qth_min, ctl->qth_max, ctl->Wlog,
 		      ctl->Plog, ctl->Scell_log,
-		      nla_data(tb[TCA_RED_STAB]),
+		      stab,
 		      max_P);
 	red_set_vars(&q->vars);
 
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index b25e51440623bce56628ff33142c63739c4ac239..066754a18569ba8f8a295f14049b06dfbeb4c7c6 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -647,7 +647,7 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt)
 	}
 
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
-					ctl_v1->Wlog, ctl_v1->Scell_log))
+					ctl_v1->Wlog, ctl_v1->Scell_log, NULL))
 		return -EINVAL;
 	if (ctl_v1 && ctl_v1->qth_min) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);
-- 
2.30.1.766.gb4fecdf3b7-goog

