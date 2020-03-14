Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61B9818599A
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 04:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgCODOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 23:14:30 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:34756 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726596AbgCODO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 23:14:29 -0400
Received: by mail-io1-f68.google.com with SMTP id h131so13747860iof.1
        for <netdev@vger.kernel.org>; Sat, 14 Mar 2020 20:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XZY2E8NvJNRvuGgOczAKWNt0CfRe4EnCL+nHnshq92Y=;
        b=mtFN5ouGC3mCqglYdPtn+KWckoUHyKpm13diSI6hxk1Gb3EUidgy1Zely1/xrZqK0r
         vojgzLH9c0/iHegcE8eBT/XHQE3zBgP4yUUYuOpT+aT2qETIN+s7iDqgb27vVf+087J6
         SI3NmfNEhOf0bqboR57I7sQxNPYeY1xVVsZC1kgT6AIHnqioCOOFAcbbpTtZq0lIWlsM
         RiR7K+RGrfG+niWw3EhggkHXAcM+kWdar4LN4HhgeJ0UT6jAY1qBjx8lp5mbCtGEMHTL
         S9GwEBK4x3PW+OSvXmoGTbs5OzAwWb4NOZKYRy1QL+94sWk85NHq6hpQ4gPglU1EdBnZ
         CRPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XZY2E8NvJNRvuGgOczAKWNt0CfRe4EnCL+nHnshq92Y=;
        b=cF0Rvo4Bji+AFVUduwSRHiXQkKzzCMnSb9DJvp86DmgvzJ8lSDfzx6YVcuoXWjTo5+
         xNbGKa2zKF5RWNqu02I2AhNycrPQIKg9EsSgaz5MD0n9WD6Yklr8QBAVNZjPVqtObN9O
         L6eVyW0DkIRQMlkc0fmIOIh0svdOeAwoypDhV+6+OnfeBKOFuGBySD4ZrVIkzwPijLcB
         aIneCya4Lbx1GkJvI6PbF4lZwJA368G8axrP6CctDsYQNiS0jVKwPmOXssLHqWzGdZ+w
         8bDUkXMCnPLTMe5kT2ppTE5P8jc5avVqhrlpdxQ/8HvzekcSffqUAox0P1aqxm4Uhhde
         Kd4Q==
X-Gm-Message-State: ANhLgQ3GO44y02K5mHW4Oho03IxcuGF7BF0KNbguQ/8VjdndofkVUk6d
        MfLN/zULNQKGlCG4q3x3aot2HJJkPKE=
X-Google-Smtp-Source: ADFU+vvrHiw8R6kOLYwonCdLylCcbbRoXi88McXYhaMddK25jum6SU1jLqQ02rzJKndOsJLCwl2Kkg==
X-Received: by 2002:a63:a47:: with SMTP id z7mr16734899pgk.117.1584163818832;
        Fri, 13 Mar 2020 22:30:18 -0700 (PDT)
Received: from tw-172-25-31-169.office.twttr.net ([8.25.197.25])
        by smtp.gmail.com with ESMTPSA id b2sm5796540pjc.6.2020.03.13.22.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 22:30:17 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com,
        syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com,
        syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        John Fastabend <john.fastabend@gmail.com>
Subject: [Patch net] net_sched: cls_route: remove the right filter from hashtable
Date:   Fri, 13 Mar 2020 22:29:54 -0700
Message-Id: <20200314052954.26885-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

route4_change() allocates a new filter and copies values from
the old one. After the new filter is inserted into the hash
table, the old filter should be removed and freed, as the final
step of the update.

However, the current code mistakenly removes the new one. This
looks apparently wrong to me, and it causes double "free" and
use-after-free too, as reported by syzbot.

Reported-and-tested-by: syzbot+f9b32aaacd60305d9687@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+2f8c233f131943d6056d@syzkaller.appspotmail.com
Reported-and-tested-by: syzbot+9c2df9fd5e9445b74e01@syzkaller.appspotmail.com
Fixes: 1109c00547fc ("net: sched: RCU cls_route")
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_route.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 6f8786b06bde..5efa3e7ace15 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -534,8 +534,8 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 			fp = &b->ht[h];
 			for (pfp = rtnl_dereference(*fp); pfp;
 			     fp = &pfp->next, pfp = rtnl_dereference(*fp)) {
-				if (pfp == f) {
-					*fp = f->next;
+				if (pfp == fold) {
+					rcu_assign_pointer(*fp, fold->next);
 					break;
 				}
 			}
-- 
2.21.1

