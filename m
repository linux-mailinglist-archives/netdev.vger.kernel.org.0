Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814A36B0AD
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 22:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388588AbfGPU5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 16:57:53 -0400
Received: from mail-pl1-f175.google.com ([209.85.214.175]:38493 "EHLO
        mail-pl1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728575AbfGPU5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 16:57:52 -0400
Received: by mail-pl1-f175.google.com with SMTP id az7so10725093plb.5
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 13:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3GLI+fm34YP2cU/EVZ/4XMeJusEXnS4qIZw8p2CywWI=;
        b=Hg1NmNsd/iHUCpe5txmjoK3/SqkgWk/BXX/utOruNXy9b3/1wxTsxYUgIUI4MFDmWP
         HE/FvGJwX/hvyoTGtcAXtcGGWwrCAECDtiQqSLaKEOE9KEJVTLDwSPM68N04r+E31UcD
         yP+cwscjs+QVLg+dtxIOxwuO6e2BG2RXbg+q8Na5BuYeK9EhqQ2Q+4MbzWoHilCDFxiy
         wwxEC8pGeYCEtAcfIzyH7G0wRZinH4TYW/hJsRNWH5RqD28o/cECl0b0B7g+qXVaZIUc
         yQNK2CKOiYDScRkobSWN2OWXc82nhB0f1RTs31cvIWkDtIPjdwO7ZB/TYtZ8UFmNj7ld
         6j7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3GLI+fm34YP2cU/EVZ/4XMeJusEXnS4qIZw8p2CywWI=;
        b=DgfhPMhYoR5yL+RldFCDN27fnwC9oKOZVhQaSL+Ny1ZT/aArkWqZDnasN7khYkcIJO
         QyAM1eqjtYxu4/wf/oyqvAl5vspo03uXTgb9pqHhyBSrhQ/2viqZDXh2TkRoofvTT2f/
         oVlWWxAUa9AI+6s8PMAIKf1UuGW92nr6uI+UVEgJ42pCircHaz5/qBt1rp7YKe0nLyRK
         368X4a83PQrv1Vpj1dRFCWDambetu5jiBCQAOVTNjaDY4q/EyWRO+NUpYBUZaxhq9kGt
         e9aRqaASVgfDZdm+kzlzQswtwJH5xWIaFaV/ziRLoayHa/eKVvQcC597qnQ4eAN1XGwe
         dnFA==
X-Gm-Message-State: APjAAAU8ctfwmqBhZJrGlxx6TEsc7xNAw+gLb2m+TMhynqMFITs2ztt6
        ky+jc40rC7cIAAOJ5wMSNmJ2aRunlOo=
X-Google-Smtp-Source: APXvYqxyocC8Y79RggIbm0IS48ra47kakIOx5rP0juuDXCRH/QtTgGIfxDBOYeZCJ47le9SFfGoQPA==
X-Received: by 2002:a17:902:27a8:: with SMTP id d37mr38315099plb.150.1563310672049;
        Tue, 16 Jul 2019 13:57:52 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id z4sm36016562pfg.166.2019.07.16.13.57.51
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 16 Jul 2019 13:57:51 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [Patch net v2] net_sched: unset TCQ_F_CAN_BYPASS when adding filters
Date:   Tue, 16 Jul 2019 13:57:30 -0700
Message-Id: <20190716205730.19675-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For qdisc's that support TC filters and set TCQ_F_CAN_BYPASS,
notably fq_codel, it makes no sense to let packets bypass the TC
filters we setup in any scenario, otherwise our packets steering
policy could not be enforced.

This can be reproduced easily with the following script:

 ip li add dev dummy0 type dummy
 ifconfig dummy0 up
 tc qd add dev dummy0 root fq_codel
 tc filter add dev dummy0 parent 8001: protocol arp basic action mirred egress redirect dev lo
 tc filter add dev dummy0 parent 8001: protocol ip basic action mirred egress redirect dev lo
 ping -I dummy0 192.168.112.1

Without this patch, packets are sent directly to dummy0 without
hitting any of the filters. With this patch, packets are redirected
to loopback as expected.

This fix is not perfect, it only unsets the flag but does not set it back
because we have to save the information somewhere in the qdisc if we
really want that. Note, both fq_codel and sfq clear this flag in their
->bind_tcf() but this is clearly not sufficient when we don't use any
class ID.

Fixes: 23624935e0c4 ("net_sched: TCQ_F_CAN_BYPASS generalization")
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/cls_api.c      | 1 +
 net/sched/sch_fq_codel.c | 2 --
 net/sched/sch_sfq.c      | 2 --
 3 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 278014e26aec..d144233423c5 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -2152,6 +2152,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 		tfilter_notify(net, skb, n, tp, block, q, parent, fh,
 			       RTM_NEWTFILTER, false, rtnl_held);
 		tfilter_put(tp, fh);
+		q->flags &= ~TCQ_F_CAN_BYPASS;
 	}
 
 errout:
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index e2faf33d282b..d59fbcc745d1 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -596,8 +596,6 @@ static unsigned long fq_codel_find(struct Qdisc *sch, u32 classid)
 static unsigned long fq_codel_bind(struct Qdisc *sch, unsigned long parent,
 			      u32 classid)
 {
-	/* we cannot bypass queue discipline anymore */
-	sch->flags &= ~TCQ_F_CAN_BYPASS;
 	return 0;
 }
 
diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 420bd8411677..68404a9d2ce4 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -824,8 +824,6 @@ static unsigned long sfq_find(struct Qdisc *sch, u32 classid)
 static unsigned long sfq_bind(struct Qdisc *sch, unsigned long parent,
 			      u32 classid)
 {
-	/* we cannot bypass queue discipline anymore */
-	sch->flags &= ~TCQ_F_CAN_BYPASS;
 	return 0;
 }
 
-- 
2.21.0

