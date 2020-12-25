Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7662E29FB
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 07:26:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbgLYGYj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 01:24:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgLYGYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 01:24:38 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495B7C061573;
        Thu, 24 Dec 2020 22:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=OUyXenwUk1NdejfVecrnP4oMGsrPNabBoQsyGjxq9ac=; b=F6wc6t4pXvJNMQzfzns1lkXE8x
        HxQXYESa/5nfxtyacEzBezlwTFHo1dctO/gfygHHtFi06MRIHzZvHi/i8qp6PU/2WJUvvnKlKNdnw
        /wgc54GZi5fKHls83je8lfo6E2Aa+40NrvbXuzMjUHjWAeOCEpdJuVSkFTUCj//l66zdFiWUghj/l
        SXzQC1+GbcLV8n4/cJXKuDwCCTYuh7ZV/tpAmQO+VZ2r4qfty63FgNJp3QQVwScn8wjPzCp/DUKDo
        3BkoPa9pczG+0pH4ZZWN4NcFvQfpFWVhR7vCLuNfbGP0iVy4/IuRJw2/oX4TzREgcbQ/1A2vngrh2
        HPwQ32sg==;
Received: from [2601:1c0:6280:3f0::64ea] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ksgW0-0000tv-Qf; Fri, 25 Dec 2020 06:23:53 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        syzbot+97c5bd9cc81eca63d36e@syzkaller.appspotmail.com,
        Nogah Frankel <nogahf@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH -net] net: sched: prevent invalid Scell_log shift count
Date:   Thu, 24 Dec 2020 22:23:44 -0800
Message-Id: <20201225062344.32566-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 include/net/red.h     |    4 +++-
 net/sched/sch_choke.c |    2 +-
 net/sched/sch_gred.c  |    2 +-
 net/sched/sch_red.c   |    2 +-
 net/sched/sch_sfq.c   |    2 +-
 5 files changed, 7 insertions(+), 5 deletions(-)

--- lnx-510.orig/include/net/red.h
+++ lnx-510/include/net/red.h
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
--- lnx-510.orig/net/sched/sch_sfq.c
+++ lnx-510/net/sched/sch_sfq.c
@@ -647,7 +647,7 @@ static int sfq_change(struct Qdisc *sch,
 	}
 
 	if (ctl_v1 && !red_check_params(ctl_v1->qth_min, ctl_v1->qth_max,
-					ctl_v1->Wlog))
+					ctl_v1->Wlog, ctl_v1->Scell_log))
 		return -EINVAL;
 	if (ctl_v1 && ctl_v1->qth_min) {
 		p = kmalloc(sizeof(*p), GFP_KERNEL);
--- lnx-510.orig/net/sched/sch_choke.c
+++ lnx-510/net/sched/sch_choke.c
@@ -362,7 +362,7 @@ static int choke_change(struct Qdisc *sc
 
 	ctl = nla_data(tb[TCA_CHOKE_PARMS]);
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	if (ctl->limit > CHOKE_MAX_QUEUE)
--- lnx-510.orig/net/sched/sch_gred.c
+++ lnx-510/net/sched/sch_gred.c
@@ -480,7 +480,7 @@ static inline int gred_change_vq(struct
 	struct gred_sched *table = qdisc_priv(sch);
 	struct gred_sched_data *q = table->tab[dp];
 
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog)) {
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log)) {
 		NL_SET_ERR_MSG_MOD(extack, "invalid RED parameters");
 		return -EINVAL;
 	}
--- lnx-510.orig/net/sched/sch_red.c
+++ lnx-510/net/sched/sch_red.c
@@ -250,7 +250,7 @@ static int __red_change(struct Qdisc *sc
 	max_P = tb[TCA_RED_MAX_P] ? nla_get_u32(tb[TCA_RED_MAX_P]) : 0;
 
 	ctl = nla_data(tb[TCA_RED_PARMS]);
-	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog))
+	if (!red_check_params(ctl->qth_min, ctl->qth_max, ctl->Wlog, ctl->Scell_log))
 		return -EINVAL;
 
 	err = red_get_flags(ctl->flags, TC_RED_HISTORIC_FLAGS,
