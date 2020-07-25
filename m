Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3C6822D9D0
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 22:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgGYURM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 16:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgGYURL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 16:17:11 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E40C08C5C0
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 13:17:11 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 1so7025368pfn.9
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 13:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uqRoqgqw9ITsbO+X2B3Qwe9+5+3hlGU3V3nlk+nOPyM=;
        b=cNwWPGwCZNuE1TWbDIJ+TOhRZLb6aXLRh7k90JvOOVrJcohwQ5buh/e9WzZ1ZPV17S
         iaFrvBnOq81NGfjDdh2MXvzd/ZO9653SuYz1Oj/pcqwcmtxq1dl/XN2Ypjx9XfqebXDi
         r2w5gHJWlO5NTdqIvmQR1LspCX5ZlWpydgQ8knNbBL2y89aNM+qJHsqoEeXwb++CMyBS
         TRdaYTYHHwJIGFdS+jL1bf/XCYNZ1mDL9SLdnsl5wiJKzD/I5EKG4pxUHDzYtcpyWPVZ
         2A7/hQTpyaoiH0F8s9ivf0H6yW1DFBFi3ky8zBBzkiWcVSiYjXkJiaiZcV1jzYk2v7eU
         BReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uqRoqgqw9ITsbO+X2B3Qwe9+5+3hlGU3V3nlk+nOPyM=;
        b=H4b7tu5uhhwx6NoSCzIKd6L55kLxY2+wH0VfOBls3dDWQMWQPH4oCOhhzAn08v1qL7
         xwQUi3aAe9EDxLvr8Zh7RYahHs1raAgZQOiFob2k0ydpRpIploM9I19dOpFVr9K02MOH
         pT0YFaBjlfsST8GKpngnISnMWyYZZ56XB1NrQkY+yGM8m2PJVa35wxR3LLvi8pThi2Z3
         JMJClYzqyRlBn3oWEw8qaEgty9j2SWCxHQdIQdRmmNvtLE5GIKNFCo4qAp1/0qTYvMOa
         c90VzqXorgxLjWXRuoFDeZG0N/p8078fb/ar7ioZvWhj0/L2omr5ITIMumbXElBkZDRs
         rNhA==
X-Gm-Message-State: AOAM530jRmpIYB6/WOGvGyy3sn+pQ5nbGhK4uLPzwub6A29dTN4UwV4Z
        B+Y2PRVHF54ujpy+mmb/QfroWXt3MEg=
X-Google-Smtp-Source: ABdhPJxfYHnSDeQ4wYnslPwJL/pbINWDRwLGPYh5dHtjUINfF9LNFd7FpVpXPww5XQTjjOKMwCEUjA==
X-Received: by 2002:aa7:84ce:: with SMTP id x14mr14896873pfn.220.1595708231219;
        Sat, 25 Jul 2020 13:17:11 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::1e])
        by smtp.gmail.com with ESMTPSA id o129sm10421987pfg.14.2020.07.25.13.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 13:17:10 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+6e95a4fabf88dc217145@syzkaller.appspotmail.com,
        Petr Machata <petrm@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net-next] net_sched: initialize timer earlier in red_init()
Date:   Sat, 25 Jul 2020 13:17:07 -0700
Message-Id: <20200725201707.16909-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When red_init() fails, red_destroy() is called to clean up.
If the timer is not initialized yet, del_timer_sync() will
complain. So we have to move timer_setup() before any failure.

Reported-and-tested-by: syzbot+6e95a4fabf88dc217145@syzkaller.appspotmail.com
Fixes: aee9caa03fc3 ("net: sched: sch_red: Add qevents "early_drop" and "mark"")
Cc: Petr Machata <petrm@mellanox.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_red.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index 4cc0ad0b1189..deac82f3ad7b 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -333,6 +333,10 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
 	struct nlattr *tb[TCA_RED_MAX + 1];
 	int err;
 
+	q->qdisc = &noop_qdisc;
+	q->sch = sch;
+	timer_setup(&q->adapt_timer, red_adaptative_timer, 0);
+
 	if (!opt)
 		return -EINVAL;
 
@@ -341,10 +345,6 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
-	q->qdisc = &noop_qdisc;
-	q->sch = sch;
-	timer_setup(&q->adapt_timer, red_adaptative_timer, 0);
-
 	err = __red_change(sch, tb, extack);
 	if (err)
 		return err;
-- 
2.27.0

