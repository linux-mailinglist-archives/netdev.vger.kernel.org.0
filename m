Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0FD2F165E
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:52:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387795AbhAKNv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:51:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:56240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730682AbhAKNJM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 08:09:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 74D132225E;
        Mon, 11 Jan 2021 13:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370537;
        bh=vWJ89WgJ64urz1PsjPcMt6Y5ukGj9sNADlTrhhycSCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nkgVnuQB0ZSMDEUR7mYq4qJ4GY8GqIm9minBbHXq93OIbD4R9UOE+HcdQ5tIIjEHI
         ldpCJA0RKPgyNoIWnlODoZS31W+CQkHdF30zbLpaYS5jKJt2lNA8Tcp7t+deDU9G5+
         d7A2qg7qZl3uA0BqfwgFa6qk6Sy85yK9bZfoynQg=
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
Subject: [PATCH 4.19 35/77] net: sched: prevent invalid Scell_log shift count
Date:   Mon, 11 Jan 2021 14:01:44 +0100
Message-Id: <20210111130038.089248250@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130036.414620026@linuxfoundation.org>
References: <20210111130036.414620026@linuxfoundation.org>
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
@@ -168,12 +168,14 @@ static inline void red_set_vars(struct r
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
@@ -371,7 +371,7 @@ static int choke_change(struct Qdisc *sc
 
 	ctl = nla_data(tb[TCA_CHOKE_PARMS]);
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	if (ctl->limit > CHOKE_MAX_QUEUE)
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -357,7 +357,7 @@ static inline int gred_change_vq(struct
 	struct gred_sched *table = qdisc_priv(sch);
 	struct gred_sched_data *q = table->tab[dp];
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	if (!q) {
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -214,7 +214,7 @@ static int red_change(struct Qdisc *sch,
 	max_P = tb[TCA_RED_MAX_P] ? nla_get_u32(tb[TCA_RED_MAX_P]) : 0;
 
 	ctl = nla_data(tb[TCA_RED_PARMS]);
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	if (ctl->limit > 0) {
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -651,7 +651,7 @@ static int sfq_change(struct Qdisc *sch,
 	}
 
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
-					ctl_v1->Wlog))
+					ctl_v1->Wlog, ctl_v1->Scell_log))
 		return -EINVAL;
 	if (ctl_v1 && ctl_v1->qth_min) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);


