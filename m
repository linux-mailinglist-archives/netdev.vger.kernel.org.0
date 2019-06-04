Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910E534EFB
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 19:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfFDReh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 13:34:37 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:45796 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726179AbfFDReh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 13:34:37 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 39FBB14005C;
        Tue,  4 Jun 2019 17:34:36 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 4 Jun
 2019 10:34:31 -0700
From:   Edward Cree <ecree@solarflare.com>
Subject: [RFC PATCH v4 net-next 3/4] net/sched: add action block binding to
 other classifiers
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
CC:     netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Vishal Kulkarni <vishal@chelsio.com>,
        Or Gerlitz <gerlitz.or@gmail.com>
References: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Message-ID: <a87c5277-e106-1b05-cd24-9da2133b7710@solarflare.com>
Date:   Tue, 4 Jun 2019 18:34:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <a3f0a79a-7e2c-4cdc-8c97-dfebe959ab1f@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24656.005
X-TM-AS-Result: No-3.313400-4.000000-10
X-TMASE-MatchedRID: gzz3DonMjLoApIQ1X2G0S7W7+o2OTMRc6VTG9cZxEjIGmHr1eMxt2VMe
        5Blkpry7rdoLblq9S5ra/g/NGTW3MkEe/iGmjPnihL9NX2TqmkCNkCJU7Ne1c5GhAvBSa2i/224
        ueXqtKLtvPsB/9IzHGZ2oLZ8u2T3ETX7PJ/OU3vKDGx/OQ1GV8sOboPPWVSjL+gtHj7OwNO1Sa+
        jpKCDmEUW7aJ3AzAbCxOqJva8G/JWOFYexh8Ka6M9cp5qLSAhAb7o5ooaDem76pF5t0pofRr+75
        uB+m/K/ziSvt78VNnjPUgbXhkybFXzm6hivSaZZop2lf3StGhISt1bcvKF7ZNkrC8mOIB+LwL6S
        xPpr1/I=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.313400-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24656.005
X-MDID: 1559669676-o13bsXDYpauP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cls_matchall, cls_u32, and cls_bpf all have offloads as well, so they also
 need to bind actions to blocks for RTM_GETACTION stats collection.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 net/sched/cls_bpf.c      | 10 +++++++++-
 net/sched/cls_matchall.c |  7 +++++++
 net/sched/cls_u32.c      |  7 +++++++
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 27365ed3fe0b..c99e53cbf83d 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -165,8 +165,11 @@ static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 	cls_bpf.name = obj->bpf_name;
 	cls_bpf.exts_integrated = obj->exts_integrated;
 
-	if (oldprog)
+	if (oldprog) {
+		if (oldprog->in_hw_count)
+			tc_unbind_action_blocks(&oldprog->exts, block);
 		tcf_block_offload_dec(block, &oldprog->gen_flags);
+	}
 
 	err = tc_setup_cb_call(block, TC_SETUP_CLSBPF, &cls_bpf, skip_sw);
 	if (prog) {
@@ -175,6 +178,7 @@ static int cls_bpf_offload_cmd(struct tcf_proto *tp, struct cls_bpf_prog *prog,
 			return err;
 		} else if (err > 0) {
 			prog->in_hw_count = err;
+			tc_bind_action_blocks(&prog->exts, block);
 			tcf_block_offload_inc(block, &prog->gen_flags);
 		}
 	}
@@ -683,8 +687,12 @@ static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 			continue;
 		}
 
+		if (add && !prog->in_hw_count)
+			tc_bind_action_blocks(&prog->exts, block);
 		tc_cls_offload_cnt_update(block, &prog->in_hw_count,
 					  &prog->gen_flags, add);
+		if (!add && !prog->in_hw_count)
+			tc_unbind_action_blocks(&prog->exts, block);
 	}
 
 	return 0;
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index db42d97a2006..5cb4832d1b3b 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -79,6 +79,8 @@ static void mall_destroy_hw_filter(struct tcf_proto *tp,
 	cls_mall.cookie = cookie;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSMATCHALL, &cls_mall, false);
+	if (head->in_hw_count)
+		tc_unbind_action_blocks(&head->exts, block);
 	tcf_block_offload_dec(block, &head->flags);
 }
 
@@ -120,6 +122,7 @@ static int mall_replace_hw_filter(struct tcf_proto *tp,
 		return err;
 	} else if (err > 0) {
 		head->in_hw_count = err;
+		tc_bind_action_blocks(&head->exts, block);
 		tcf_block_offload_inc(block, &head->flags);
 	}
 
@@ -320,7 +323,11 @@ static int mall_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
 		return 0;
 	}
 
+	if (add && !head->in_hw_count)
+		tc_bind_action_blocks(&head->exts, block);
 	tc_cls_offload_cnt_update(block, &head->in_hw_count, &head->flags, add);
+	if (!add && !head->in_hw_count)
+		tc_unbind_action_blocks(&head->exts, block);
 
 	return 0;
 }
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 4b8710a266cc..84f067d9b4a4 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -534,6 +534,8 @@ static void u32_remove_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	cls_u32.knode.handle = n->handle;
 
 	tc_setup_cb_call(block, TC_SETUP_CLSU32, &cls_u32, false);
+	if (n->in_hw_count)
+		tc_unbind_action_blocks(&n->exts, block);
 	tcf_block_offload_dec(block, &n->flags);
 }
 
@@ -569,6 +571,7 @@ static int u32_replace_hw_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 		return err;
 	} else if (err > 0) {
 		n->in_hw_count = err;
+		tc_bind_action_blocks(&n->exts, block);
 		tcf_block_offload_inc(block, &n->flags);
 	}
 
@@ -1223,7 +1226,11 @@ static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 		return 0;
 	}
 
+	if (add && !n->in_hw_count)
+		tc_bind_action_blocks(&n->exts, block);
 	tc_cls_offload_cnt_update(block, &n->in_hw_count, &n->flags, add);
+	if (!add && !n->in_hw_count)
+		tc_unbind_action_blocks(&n->exts, block);
 
 	return 0;
 }

