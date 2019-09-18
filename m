Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA8BB6FA4
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 01:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729578AbfIRXYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 19:24:32 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:43291 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfIRXYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 19:24:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id u72so722180pgb.10
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 16:24:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=plCfruwrsIX/SwmbrNBo9Z2Sk9DdAD277GtWIAkVsE4=;
        b=bkIQxoevGYcaNk4FSTxC3K+LZOqwCduKwX7r5l3847xp+qrAnvwjcHQ2O3et/HMK3K
         YCFt8Z7EpWSA8bLGWTQ3u86T788sKIlyh/t+2WHUKKo5XuuRUYtPMeHCMrqwIh0FUMpf
         IruEIjPG5fpEEeGjNp++bsKrhnzfWdRxEjBLe9rTSyJBWYrrscEl2Di0aeVKxRplSIRD
         InCBBVW92k3oOYbV2AYbjTsGNEbiUf/+FOHy20KOcSKwza3gwu8YsjBz9JV3G1RjPMZL
         13XDKhdcfetyqctTBYto8lnltIhEzhmlJd/bRtNTf+pk6/vxYiftK/3EKDlsqgvtDlC5
         2npQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=plCfruwrsIX/SwmbrNBo9Z2Sk9DdAD277GtWIAkVsE4=;
        b=tfHH4pPd8x9zQIfme3bvLwPqU9qmBE8Wr0o/0pAVSX9X1FHJdmHnTuQ7xoCf5FxG6e
         TUlebsg/snBmq3KQRuhCXqllL7dP43K6D5NsusIwwrbiFEwSvzTCift+4Ia0DdP66s1e
         Z1dNNcDEbh6WyITSCsBrbKwyTJY9ntkSMQVuTUqupDg5cbzseAcSMFSe6x0tIBaLjDGB
         pJEgWLvoyrE4YrMEcVZpxOU0SkI9oSG8lWhMayfod7mL1gVJxzgmhX1LN+mwY8a4zg90
         X7faRZjqilg5Jpod2pAN5eUre8Giy1NoolTeShb2s5YSZxVtTYnYs+cTjcED4PAxoEUP
         iCWw==
X-Gm-Message-State: APjAAAUd+Lw1JqnOrIZtZvmyW7BJ6fn9KptmmJbH+gwi9H0in4IN+jcL
        5+iCzOcElSRHYuBj1xHdzLnwrSpt
X-Google-Smtp-Source: APXvYqzLpThKR5lg8Gd6hgwn8cl9THvMbuuZZwm3FRBY4a/aVTXpkdnDcNrmNoknvSG5Qh1BY+BFKg==
X-Received: by 2002:a62:1c97:: with SMTP id c145mr4754787pfc.168.1568849070967;
        Wed, 18 Sep 2019 16:24:30 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id x9sm10746119pje.27.2019.09.18.16.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 16:24:30 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com,
        David Ahern <dsahern@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] net_sched: add max len check for TCA_KIND
Date:   Wed, 18 Sep 2019 16:24:12 -0700
Message-Id: <20190918232412.16718-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCA_KIND attribute is of NLA_STRING which does not check
the NUL char. KMSAN reported an uninit-value of TCA_KIND which
is likely caused by the lack of NUL.

Change it to NLA_NUL_STRING and add a max len too.

Fixes: 8b4c3cdd9dd8 ("net: sched: Add policy validation for tc attributes")
Reported-and-tested-by: syzbot+618aacd49e8c8b8486bd@syzkaller.appspotmail.com
Cc: David Ahern <dsahern@gmail.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 1047825d9f48..81d58b280612 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1390,7 +1390,8 @@ check_loop_fn(struct Qdisc *q, unsigned long cl, struct qdisc_walker *w)
 }
 
 const struct nla_policy rtm_tca_policy[TCA_MAX + 1] = {
-	[TCA_KIND]		= { .type = NLA_STRING },
+	[TCA_KIND]		= { .type = NLA_NUL_STRING,
+				    .len = IFNAMSIZ - 1 },
 	[TCA_RATE]		= { .type = NLA_BINARY,
 				    .len = sizeof(struct tc_estimator) },
 	[TCA_STAB]		= { .type = NLA_NESTED },
-- 
2.21.0

