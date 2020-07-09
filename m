Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D057219684
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 05:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgGIDOG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 23:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgGIDOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 23:14:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371B5C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 20:14:06 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 207so391664pfu.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 20:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5KH6XYznKGCYv8UPPyiRobi0Jchj48PdngxMhlgJRHY=;
        b=kK2juvB6mhJdcpxUzxoJufNrZ4UptTzbFrJEiWjnquB9tiAp0g+SwrEe2j0zOl6liR
         OaFvinK5/3+Fhwgz2gEVTpWu0Z8NG156cb2fo5vQQjvxoYJhQ57J0o1cdbnR+evtoIS5
         AYUQE/yr/qelZp7AUPvSSA3aMbEFs1itaOSKNz3Osi8f+CnjKBztEKyrI9N0/wKFtaZU
         8Jex4ufFplsMLsE+NmQnyv0SfXZhhLd2c3SYGK5fk5M1aTivfx9h+PrAetWG2fTctkBy
         cwH8hmrzCw8JIcq/88hz2M1OA4Imt2vxsiOh3V3Fprc4qb9gnuj1HKYMUbDO6zrf3zjg
         TOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5KH6XYznKGCYv8UPPyiRobi0Jchj48PdngxMhlgJRHY=;
        b=KiVRoybz58ki16kBTI9rubpot/qNECmm4/m0V05+0NUUHWyb6HOzc+n6o5wWpVqpW4
         4RiTg7ifoazerihICYvAsyAajcf8cJxoHy/+XyYrrYtXzXbTtbj6yXkMwA9PiZJyZ+Yo
         7G9Pdf8U5xTjRBeS4+5x+q43YKtn3yjYoUSIEDowtqwnqUsachkkQbEp0756knu6m6om
         BjLBgQiTHMxwqPgW8la7BQ5GDAezbe/HEvMPhqNbbwVnh5vCAjP4SawYMQHLt+cJc3N5
         9vcsHQDF/YyRotb7CCq1h1br8u1fjmXQjyenj6SaFBaogGHCGf5HtL5EQQceM3m7fA0b
         909Q==
X-Gm-Message-State: AOAM530Ge1a5wHBzJPkxzBNmsm0Qly8mVNxZ/BwGdYGILylZIDenzZZR
        bOUG8DLGQygc8gyaAG6bHtA9FEljlOo=
X-Google-Smtp-Source: ABdhPJz6V9M5nm0lqB7MXDWGuZMusCw5P3n1eMHTkBTQU6klhYZeeBIay4NNMQvMe4TSlsztd/1mdQ==
X-Received: by 2002:a63:7a56:: with SMTP id j22mr50196716pgn.194.1594264445368;
        Wed, 08 Jul 2020 20:14:05 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site ([2600:1700:727f::46])
        by smtp.gmail.com with ESMTPSA id z6sm991610pfn.173.2020.07.08.20.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 20:14:04 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+d411cff6ab29cc2c311b@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: fix a memory leak in atm_tc_init()
Date:   Wed,  8 Jul 2020 20:13:59 -0700
Message-Id: <20200709031359.11063-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tcf_block_get() fails inside atm_tc_init(),
atm_tc_put() is called to release the qdisc p->link.q.
But the flow->ref prevents it to do so, as the flow->ref
is still zero.

Fix this by moving the p->link.ref initialization before
tcf_block_get().

Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
Reported-and-tested-by: syzbot+d411cff6ab29cc2c311b@syzkaller.appspotmail.com
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_atm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_atm.c b/net/sched/sch_atm.c
index ee12ca9f55b4..1c281cc81f57 100644
--- a/net/sched/sch_atm.c
+++ b/net/sched/sch_atm.c
@@ -553,16 +553,16 @@ static int atm_tc_init(struct Qdisc *sch, struct nlattr *opt,
 	if (!p->link.q)
 		p->link.q = &noop_qdisc;
 	pr_debug("atm_tc_init: link (%p) qdisc %p\n", &p->link, p->link.q);
+	p->link.vcc = NULL;
+	p->link.sock = NULL;
+	p->link.common.classid = sch->handle;
+	p->link.ref = 1;
 
 	err = tcf_block_get(&p->link.block, &p->link.filter_list, sch,
 			    extack);
 	if (err)
 		return err;
 
-	p->link.vcc = NULL;
-	p->link.sock = NULL;
-	p->link.common.classid = sch->handle;
-	p->link.ref = 1;
 	tasklet_init(&p->task, sch_atm_dequeue, (unsigned long)sch);
 	return 0;
 }
-- 
2.27.0

