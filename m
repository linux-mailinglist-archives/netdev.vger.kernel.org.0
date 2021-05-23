Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94D2B38DB71
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 16:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231818AbhEWOky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 10:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231769AbhEWOkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 10:40:53 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A96C061574
        for <netdev@vger.kernel.org>; Sun, 23 May 2021 07:39:24 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 27so16869446pgy.3
        for <netdev@vger.kernel.org>; Sun, 23 May 2021 07:39:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=x+CviE/BBbl4fIESjn+adlc/HRQ1tJOvqd9ooTNlB/8=;
        b=HO92aHpY2OQZy3/x9n0a+t6ExhiY7xQAUFk9SJ7XBTv1pnpOPt8EAqeWZAOGHnGv0y
         fDSFoXhB1w774UDzIkjy3TGbMNSBFM6zUkjWPx1Kkp8GetZO/nepUig7FkUmvceyV5pO
         VjKeETkozmlp/QbwFOkZFk21yWYJRnWJlH98nPmGXP0fhCk36wBo6WMY6rsw7sEMRai2
         QKut4o0XnX2963bT3HbN9xfEaaOKlgJeDJq9nvNuXHxwA5jRehAAfyU3PBUBWQWCtr4i
         +l1dFsZI7oxg+g0mUpziR+VgXX8tmMp9zGIZweki6jCn5Wl38uF+I69N5frfcDcYzHW4
         EkPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=x+CviE/BBbl4fIESjn+adlc/HRQ1tJOvqd9ooTNlB/8=;
        b=cgEeRzQnyAItjZdPTIUi7advtkpaBb+0311JKdjJaKFeVrxwipASbgbki2KcuCoikx
         pZ/n9YcQsc0pT3VoJLG+7+n8PIZm9e0xAKQmFYHquBexj6G3bWxKnqnV/kfU0PHi7+RS
         o+o2IBsepUo6KMMfBRlZ4C6kCvqQ04O0O8TOALUL7winOwvQQhL1TXAlLzYTCXwQJnUC
         k5L+DCgrefnBr3/FSKJNJIGsPthnNd2atzfOHCi57lSS9rLceIqnavXcuYvdX/2N4WCx
         9LkAfuj5tKAi/Tho05xujy9Ul3YtoroZSFfeWlXcW9R0gPZ+k27b0TVBd+V8Qxn/Ctpw
         Ky4Q==
X-Gm-Message-State: AOAM533l4tgUSK76aosTDOGRSYXVd6xmkngJ6CYd5k1twxiBdEm9WNER
        uuK4/A1LBUQVt60c+15+tlY=
X-Google-Smtp-Source: ABdhPJzVLXXzhMC89CGPpx0q8pWABJvAjYLuxFDgoHHb53WelZz/4i/5QnbA1HvRwot19ZoazcYpYw==
X-Received: by 2002:a63:d710:: with SMTP id d16mr8784926pgg.214.1621780762696;
        Sun, 23 May 2021 07:39:22 -0700 (PDT)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id 136sm8757046pfu.195.2021.05.23.07.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 07:39:22 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] sch_dsmark: fix a NULL deref in qdisc_reset()
Date:   Sun, 23 May 2021 14:38:53 +0000
Message-Id: <20210523143853.8227-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If Qdisc_ops->init() is failed, Qdisc_ops->reset() would be called.
When dsmark_init(Qdisc_ops->init()) is failed, it possibly doesn't
initialize dsmark_qdisc_data->q. But dsmark_reset(Qdisc_ops->reset())
uses dsmark_qdisc_data->q pointer wihtout any null checking.
So, panic would occur.

Test commands:
    sysctl net.core.default_qdisc=dsmark -w
    ip link add dummy0 type dummy
    ip link add vw0 link dummy0 type virt_wifi
    ip link set vw0 up

Splat looks like:
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 3 PID: 684 Comm: ip Not tainted 5.12.0+ #910
RIP: 0010:qdisc_reset+0x2b/0x680
Code: 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 41 57 41 56 41 55 41 54
55 48 89 fd 48 83 c7 18 53 48 89 fa 48 c1 ea 03 48 83 ec 20 <80> 3c 02
00 0f 85 09 06 00 00 4c 8b 65 18 0f 1f 44 00 00 65 8b 1d
RSP: 0018:ffff88800fda6bf8 EFLAGS: 00010282
RAX: dffffc0000000000 RBX: ffff8880050ed800 RCX: 0000000000000000
RDX: 0000000000000003 RSI: ffffffff99e34100 RDI: 0000000000000018
RBP: 0000000000000000 R08: fffffbfff346b553 R09: fffffbfff346b553
R10: 0000000000000001 R11: fffffbfff346b552 R12: ffffffffc0824940
R13: ffff888109e83800 R14: 00000000ffffffff R15: ffffffffc08249e0
FS:  00007f5042287680(0000) GS:ffff888119800000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055ae1f4dbd90 CR3: 0000000006760002 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ? rcu_read_lock_bh_held+0xa0/0xa0
 dsmark_reset+0x3d/0xf0 [sch_dsmark]
 qdisc_reset+0xa9/0x680
 qdisc_destroy+0x84/0x370
 qdisc_create_dflt+0x1fe/0x380
 attach_one_default_qdisc.constprop.41+0xa4/0x180
 dev_activate+0x4d5/0x8c0
 ? __dev_open+0x268/0x390
 __dev_open+0x270/0x390

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/sched/sch_dsmark.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_dsmark.c b/net/sched/sch_dsmark.c
index cd2748e2d4a2..d320bcfb2da2 100644
--- a/net/sched/sch_dsmark.c
+++ b/net/sched/sch_dsmark.c
@@ -407,7 +407,8 @@ static void dsmark_reset(struct Qdisc *sch)
 	struct dsmark_qdisc_data *p = qdisc_priv(sch);
 
 	pr_debug("%s(sch %p,[qdisc %p])\n", __func__, sch, p);
-	qdisc_reset(p->q);
+	if (p->q)
+		qdisc_reset(p->q);
 	sch->qstats.backlog = 0;
 	sch->q.qlen = 0;
 }
-- 
2.17.1

