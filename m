Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5FA32F1786
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 15:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730029AbhAKNDs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:03:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:50192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729959AbhAKNDo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 08:03:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD358225AC;
        Mon, 11 Jan 2021 13:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370203;
        bh=34Aj2L0RvDFMS4ZKzTodq8xu8rAEnK9IVYiI0+RiQsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jwibylOPm9OBNZWsa/H0b+pQGwxY4LnOd6vLBku69yH7CiT1ihESQ5NXLHNIdxOiA
         vHyqDS2j7jg0x+FyLu9atE9Ij39G81/QxJk6MZonqv1T1pOJpTngjgo3nGttFBqjaE
         YyVP5toEl2ln4Cy/rD+gcDhABvb7vA4zyi9R+xp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        syzbot+97c5bd9cc81eca63d36e@syzkaller.appspotmail.com,
        Nogah Frankel <nogahf@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 15/45] net: sched: prevent invalid Scell_log shift count
Date:   Mon, 11 Jan 2021 14:00:53 +0100
Message-Id: <20210111130034.390190141@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130033.676306636@linuxfoundation.org>
References: <20210111130033.676306636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit bd1248f1ddbc48b0c30565fce897a3b6423313b8 ]

Check Scell_log shift size in red_check_params() and modify all callers
of red_check_params() to pass Scell_log.

This prevents a shift out-of-bounds as detected by UBSAN:
  UBSAN: shift-out-of-bounds in ./include/net/red.h:252:22
  shift exponent 72 is too large for 32-bit type 'int'

Fixes: 8afa10cbe281 ("net_sched: red: Avoid illegal values")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: syzbot+97c5bd9cc81eca63d36e@syzkaller.appspotmail.com
Cc: Nogah Frankel <nogahf@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/red.h     |    4 +++-
 net/sched/sch_choke.c |    2 +-
 net/sched/sch_gred.c  |    2 +-
 net/sched/sch_red.c   |    2 +-
 net/sched/sch_sfq.c   |    2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

--- a/include/net/red.h
+++ b/include/net/red.h
@@ -167,12 +167,14 @@ static inline void red_set_vars(struct r
 	v->qcount	= -1;
 }
 
-static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog)
+static inline bool red_check_params(u32 qth_min, u32 qth_max, u8 Wlog, u8 Scell_log)
 {
 	if (fls(qth_min) + Wlog > 32)
 		return false;
 	if (fls(qth_max) + Wlog > 32)
 		return false;
+	if (Scell_log >= 32)
+		return false;
 	if (qth_max < qth_min)
 		return false;
 	return true;
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -425,7 +425,7 @@ static int choke_change(struct Qdisc *sc
 
 	ctl = nla_data(tb[TCA_CHOKE_PARMS]);
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	if (ctl->limit > CHOKE_MAX_QUEUE)
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -356,7 +356,7 @@ static inline int gred_change_vq(struct
 	struct gred_sched *table = qdisc_priv(sch);
 	struct gred_sched_data *q = table->tab[dp];
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	if (!q) {
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -184,7 +184,7 @@ static int red_change(struct Qdisc *sch,
 	max_P = tb[TCA_RED_MAX_P] ? nla_get_u32(tb[TCA_RED_MAX_P]) : 0;
 
 	ctl = nla_data(tb[TCA_RED_PARMS]);
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	if (ctl->limit > 0) {
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -645,7 +645,7 @@ static int sfq_change(struct Qdisc *sch,
 	}
 
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
-					ctl_v1->Wlog))
+					ctl_v1->Wlog, ctl_v1->Scell_log))
 		return -EINVAL;
 	if (ctl_v1 && ctl_v1->qth_min) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);


