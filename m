Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A11254C54
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 19:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgH0Rkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 13:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgH0Rkq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 13:40:46 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4166FC061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 10:40:46 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id x143so4068120pfc.4
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 10:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QniIEpzo6LYMgb6q6oFmsGlgSAMfonzpODAPlmQ5PA=;
        b=ACIAg1Bn/NEWUFBj2E+PH8QrXDBmoSTDW6feeHNJbdjrd0JHF6k/vuxaFhoZSdpj5k
         N6aPxcsgNeLn/TJyBCHRJq3TgugzxWYw/YaG+vQbQdq+Rl1MItCSjLh1kbh4ja8vRo22
         icZNGekiQxT+uILVyZM8G84nAtpejgO1ZLMFgXhhVirbqqPou0mD6bHkStsJRQr/2ikn
         foS5S37F5gQBZQHPPCB9Dr/MtKHGEg5Me/bUGpBLtMi2BQaAvrQIfOsQHC5tjvhbqHSy
         RRvPgU09IhpWWGosLxpE8rmEq1+W4n1U3voq/oiVosSUwF1DxKRrWoawDOokD/2eO/32
         px8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4QniIEpzo6LYMgb6q6oFmsGlgSAMfonzpODAPlmQ5PA=;
        b=Is6TWuOF10qybIvkwA1Y3X7N69uRAQhzarPN5WktdXXbw4Zu5QnRYnZ74KjiMFroSr
         XOAPMhSnZODPXE2dmwjfJrqZLjmkMMcKumZ4JrGdiNxzWKmvlKjOqs6Xn8mAn5X5yibO
         X2+LSx8iF3p+/bVLVaMBnwVDB0REE/6KVhH74AiHYOSGt7WbchiKYOTmqUXM9/1AcIwp
         zAExYoOw2b+0Qsqo92iOWiZ1tdLK121whAAd6SYxDH1llt8FTZcadqk3abXVKmLGccZD
         f919I7RhW8+FhXM8Q2wp76SjGZ7iCGVTxQPTI/uMSpgig6e95XV1BWHEvPQK7eLGKZBD
         XKAQ==
X-Gm-Message-State: AOAM533O6PDA0VZQiYec4oP24hyDLyLO1cZU251lIOuvvxAoKEOFUzl0
        jmOKf6ji7fi1NULYIVj6QZE1LpevxJE9fg==
X-Google-Smtp-Source: ABdhPJw6KbBtykVd2J8/Xvx0h1UNVL6jOVkCBDkIscKRFKfKhsroge3H6jUDMNze7BhqBeE0Inrsbg==
X-Received: by 2002:a63:8c0c:: with SMTP id m12mr15087645pgd.73.1598550045570;
        Thu, 27 Aug 2020 10:40:45 -0700 (PDT)
Received: from unknown.linux-6brj.site ([2600:1700:727f:0:b07e:9fff:fe0a:b527])
        by smtp.gmail.com with ESMTPSA id w10sm2762495pjq.46.2020.08.27.10.40.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 10:40:44 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+b33c1cb0a30ebdc8a5f9@syzkaller.appspotmail.com,
        syzbot+e5ea5f8a3ecfd4427a1c@syzkaller.appspotmail.com,
        Petr Machata <petrm@mellanox.com>
Subject: [Patch net] net_sched: fix error path in red_init()
Date:   Thu, 27 Aug 2020 10:40:41 -0700
Message-Id: <20200827174041.13300-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When ->init() fails, ->destroy() is called to clean up.
So it is unnecessary to clean up in red_init(), and it
would cause some refcount underflow.

Fixes: aee9caa03fc3 ("net: sched: sch_red: Add qevents "early_drop" and "mark"")
Reported-and-tested-by: syzbot+b33c1cb0a30ebdc8a5f9@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+e5ea5f8a3ecfd4427a1c@syzkaller.appspotmail.com
Cc: Petr Machata <petrm@mellanox.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_red.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/net/sched/sch_red.c b/net/sched/sch_red.c
index deac82f3ad7b..e89fab6ccb34 100644
--- a/net/sched/sch_red.c
+++ b/net/sched/sch_red.c
@@ -353,23 +353,11 @@ static int red_init(struct Qdisc *sch, struct nlattr *opt,
 			      FLOW_BLOCK_BINDER_TYPE_RED_EARLY_DROP,
 			      tb[TCA_RED_EARLY_DROP_BLOCK], extack);
 	if (err)
-		goto err_early_drop_init;
-
-	err = tcf_qevent_init(&q->qe_mark, sch,
-			      FLOW_BLOCK_BINDER_TYPE_RED_MARK,
-			      tb[TCA_RED_MARK_BLOCK], extack);
-	if (err)
-		goto err_mark_init;
-
-	return 0;
+		return err;
 
-err_mark_init:
-	tcf_qevent_destroy(&q->qe_early_drop, sch);
-err_early_drop_init:
-	del_timer_sync(&q->adapt_timer);
-	red_offload(sch, false);
-	qdisc_put(q->qdisc);
-	return err;
+	return tcf_qevent_init(&q->qe_mark, sch,
+			       FLOW_BLOCK_BINDER_TYPE_RED_MARK,
+			       tb[TCA_RED_MARK_BLOCK], extack);
 }
 
 static int red_change(struct Qdisc *sch, struct nlattr *opt,
-- 
2.28.0

