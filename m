Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645C4449B6F
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 19:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhKHSLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 13:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234936AbhKHSLE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 13:11:04 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB4DC061570
        for <netdev@vger.kernel.org>; Mon,  8 Nov 2021 10:08:19 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 188so3498037pgb.7
        for <netdev@vger.kernel.org>; Mon, 08 Nov 2021 10:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H1J4NU0lce6uUCFnPuSlPKeuUp7tV+vKkLV63CjFU8g=;
        b=OWyzUNQvmkiT+MxC4Q6obdyf0NaciWD4QtZ0HeNeV8cU/mbc/jIztTR7wo/tSHK5BC
         Tt5fdUTFOke2UIGPjXsB0ayHnpP+1UM+YbThEtoZ0T80Pz2LNq/iqf0GHp1vRVmhj0Yk
         TV1YdV1ZMKvIr+PVSF57SxPrSVGSID58KjaHOI0wufIWqlqblZy43V+M6fpD5T/CeDvu
         jNC0eJE0gXx3BBfTFCBJIJCGQLESucvzKrCDMVelpfpT1TRmvNlIm53BeB1K+CSkqwYm
         Mf+a9svQWondFiRDA2dyFfNpHD2Tm8TfW25OuwJK+RpacuQ3N2ysDomuOweSEiMPcILE
         8FxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H1J4NU0lce6uUCFnPuSlPKeuUp7tV+vKkLV63CjFU8g=;
        b=DT6T/OBCEW7A3OJPNCN/POnUQ3MDs6Q20gQKMLyGfYJx/S1FEfOAWjbouT0gPzZfrS
         wFe2BazPOI5vgU5X3tRhUpFiT/3BGoukbxnFcC7eYyIaz3v4m5n3yNaT3yj4Sd5YUHQH
         DuM8YRThHDbliNNuwdZ1pgxe82ILB/9+gmyCDAjaD+PPpIfsZPPJn5xLjVETOAZUFvx1
         6PzDmX+QPUwVWI4De5QmFP/0I+nrc953/v9y8bl9EGiSaBl7DFbGG96c61H7l/beOkcI
         36hjGRt8ubhtVq7W1kGZpTd9mlAUOacXEmHm85+ViFn0EsnMBy1apVKA4deYTVPnd5iy
         7/zA==
X-Gm-Message-State: AOAM533IQc1izkgrsAoZI6wh/5QdE6b6ssK+dknk97OpNMVLI+NIr3Hm
        YlD2CG7RTonJOJmK3OAX+nA=
X-Google-Smtp-Source: ABdhPJxi5QTKXld5GAaqF3G1rZIoAXSkIYf4y9V3sKqTvwYyktugvRCyZTPW3FmOyhOneynaxzo9og==
X-Received: by 2002:a63:7d58:: with SMTP id m24mr1002172pgn.130.1636394899089;
        Mon, 08 Nov 2021 10:08:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:d2e1:4ea4:3f63:67b1])
        by smtp.gmail.com with ESMTPSA id c8sm43118pjr.38.2021.11.08.10.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 10:08:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] net/sched: sch_taprio: fix undefined behavior in ktime_mono_to_any
Date:   Mon,  8 Nov 2021 10:08:15 -0800
Message-Id: <20211108180815.1822479-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

1) if q->tk_offset == TK_OFFS_MAX, then get_tcp_tstamp() calls
   ktime_mono_to_any() with out-of-bound value.

2) if q->tk_offset is changed in taprio_parse_clockid(),
   taprio_get_time() might also call ktime_mono_to_any()
   with out-of-bound value as sysbot found:

UBSAN: array-index-out-of-bounds in kernel/time/timekeeping.c:908:27
index 3 is out of range for type 'ktime_t *[3]'
CPU: 1 PID: 25668 Comm: kworker/u4:0 Not tainted 5.15.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: bat_events batadv_iv_send_outstanding_bat_ogm_packet
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 ubsan_epilogue+0xb/0x5a lib/ubsan.c:151
 __ubsan_handle_out_of_bounds.cold+0x62/0x6c lib/ubsan.c:291
 ktime_mono_to_any+0x1d4/0x1e0 kernel/time/timekeeping.c:908
 get_tcp_tstamp net/sched/sch_taprio.c:322 [inline]
 get_packet_txtime net/sched/sch_taprio.c:353 [inline]
 taprio_enqueue_one+0x5b0/0x1460 net/sched/sch_taprio.c:420
 taprio_enqueue+0x3b1/0x730 net/sched/sch_taprio.c:485
 dev_qdisc_enqueue+0x40/0x300 net/core/dev.c:3785
 __dev_xmit_skb net/core/dev.c:3869 [inline]
 __dev_queue_xmit+0x1f6e/0x3630 net/core/dev.c:4194
 batadv_send_skb_packet+0x4a9/0x5f0 net/batman-adv/send.c:108
 batadv_iv_ogm_send_to_if net/batman-adv/bat_iv_ogm.c:393 [inline]
 batadv_iv_ogm_emit net/batman-adv/bat_iv_ogm.c:421 [inline]
 batadv_iv_send_outstanding_bat_ogm_packet+0x6d7/0x8e0 net/batman-adv/bat_iv_ogm.c:1701
 process_one_work+0x9b2/0x1690 kernel/workqueue.c:2298
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2445
 kthread+0x405/0x4f0 kernel/kthread.c:327
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Fixes: 7ede7b03484b ("taprio: make clock reference conversions easier")
Fixes: 54002066100b ("taprio: Adjust timestamps for TCP packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vedang Patel <vedang.patel@intel.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_taprio.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 9ab068fa2672be8febd227b96cbcf646bf51f661..377f896bdedc4575316c3bab1d661d9c88142ec0 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -95,18 +95,22 @@ static ktime_t sched_base_time(const struct sched_gate_list *sched)
 	return ns_to_ktime(sched->base_time);
 }
 
-static ktime_t taprio_get_time(struct taprio_sched *q)
+static ktime_t taprio_mono_to_any(const struct taprio_sched *q, ktime_t mono)
 {
-	ktime_t mono = ktime_get();
+	/* This pairs with WRITE_ONCE() in taprio_parse_clockid() */
+	enum tk_offsets tk_offset = READ_ONCE(q->tk_offset);
 
-	switch (q->tk_offset) {
+	switch (tk_offset) {
 	case TK_OFFS_MAX:
 		return mono;
 	default:
-		return ktime_mono_to_any(mono, q->tk_offset);
+		return ktime_mono_to_any(mono, tk_offset);
 	}
+}
 
-	return KTIME_MAX;
+static ktime_t taprio_get_time(const struct taprio_sched *q)
+{
+	return taprio_mono_to_any(q, ktime_get());
 }
 
 static void taprio_free_sched_cb(struct rcu_head *head)
@@ -319,7 +323,7 @@ static ktime_t get_tcp_tstamp(struct taprio_sched *q, struct sk_buff *skb)
 		return 0;
 	}
 
-	return ktime_mono_to_any(skb->skb_mstamp_ns, q->tk_offset);
+	return taprio_mono_to_any(q, skb->skb_mstamp_ns);
 }
 
 /* There are a few scenarios where we will have to modify the txtime from
@@ -1352,6 +1356,7 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 		}
 	} else if (tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]) {
 		int clockid = nla_get_s32(tb[TCA_TAPRIO_ATTR_SCHED_CLOCKID]);
+		enum tk_offsets tk_offset;
 
 		/* We only support static clockids and we don't allow
 		 * for it to be modified after the first init.
@@ -1366,22 +1371,24 @@ static int taprio_parse_clockid(struct Qdisc *sch, struct nlattr **tb,
 
 		switch (clockid) {
 		case CLOCK_REALTIME:
-			q->tk_offset = TK_OFFS_REAL;
+			tk_offset = TK_OFFS_REAL;
 			break;
 		case CLOCK_MONOTONIC:
-			q->tk_offset = TK_OFFS_MAX;
+			tk_offset = TK_OFFS_MAX;
 			break;
 		case CLOCK_BOOTTIME:
-			q->tk_offset = TK_OFFS_BOOT;
+			tk_offset = TK_OFFS_BOOT;
 			break;
 		case CLOCK_TAI:
-			q->tk_offset = TK_OFFS_TAI;
+			tk_offset = TK_OFFS_TAI;
 			break;
 		default:
 			NL_SET_ERR_MSG(extack, "Invalid 'clockid'");
 			err = -EINVAL;
 			goto out;
 		}
+		/* This pairs with READ_ONCE() in taprio_mono_to_any */
+		WRITE_ONCE(q->tk_offset, tk_offset);
 
 		q->clockid = clockid;
 	} else {
-- 
2.34.0.rc0.344.g81b53c2807-goog

