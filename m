Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1D92F14D5
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 14:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733000AbhAKNbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 08:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:33156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732249AbhAKNPo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 08:15:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED9EC229C4;
        Mon, 11 Jan 2021 13:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370928;
        bh=+VER6GljDM6S+ZkfTckZqoKUVdbwbbIkt3errPybeuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RBvE0umn/56FQlvkn6x7gGbvCAlsMhdJuGixdBleX/gvDu6vVY9DT0XknlHHJYtUl
         pSd0QYq+fxOZMZVJmXEnzaf+dA0/5M1eSApAKG/M3a46W0hIast+XQW72crQ+HiYq+
         BvjSmhPXXKrzNOmM6O3zCV5ZCQvAm6PD88gKZYck=
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
Subject: [PATCH 5.10 035/145] net: sched: prevent invalid Scell_log shift count
Date:   Mon, 11 Jan 2021 14:00:59 +0100
Message-Id: <20210111130050.206435817@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130048.499958175@linuxfoundation.org>
References: <20210111130048.499958175@linuxfoundation.org>
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
@@ -362,7 +362,7 @@ static int choke_change(struct Qdisc *sc
 
 	ctl = nla_data(tb[TCA_CHOKE_PARMS]);
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	if (ctl->limit > CHOKE_MAX_QUEUE)
--- a/net/sched/sch_gred.c
+++ b/net/sched/sch_gred.c
@@ -480,7 +480,7 @@ static inline int gred_change_vq(struct
 	struct gred_sched *table = qdisc_priv(sch);
 	struct gred_sched_data *q = table->tab[dp];
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog)) {
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log)) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid RED parameters");
 		return -EINVAL;
 	}
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -250,7 +250,7 @@ static int __red_change(struct Qdisc *sc
 	max_P = tb[TCA_RED_MAX_P] ? nla_get_u32(tb[TCA_RED_MAX_P]) : 0;
 
 	ctl = nla_data(tb[TCA_RED_PARMS]);
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	err = red_get_flags(ctl->flags, TC_RED_HISTORIC_FLAGS,
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -647,7 +647,7 @@ static int sfq_change(struct Qdisc *sch,
 	}
 
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
-					ctl_v1->Wlog))
+					ctl_v1->Wlog, ctl_v1->Scell_log))
 		return -EINVAL;
 	if (ctl_v1 && ctl_v1->qth_min) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);


