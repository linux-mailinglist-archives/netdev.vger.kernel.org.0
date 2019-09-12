Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18ABBB136A
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 19:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbfILRW5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 13:22:57 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40852 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731207AbfILRW5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 13:22:57 -0400
Received: by mail-pf1-f194.google.com with SMTP id x127so16405198pfb.7
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 10:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WejKE5rgIYd2juLQ5yLBMOZc5NS4+eiKNj8SAqG4Eh0=;
        b=NJehRbAsjlqxkZjNWJI54nDELoMSZtHdq/be3FBVj1sTVDp0UqHgPPCOMSai7LkGfN
         L6+Ve3bPtzWNBeaJ3qjfb09HJpbSmS+OFJ2lYxqc2wZva4SejSqMug/GmGxatEa7BbuX
         GOpvA2x5sY5E4QUCSOeP7jUjCT3m9Lw5RryhgVD9FLTxla/jPc6j1/bMgYOZPIY+GDBd
         qJrInWja9KJKGGO0T35SA5wGFE83J14q3VLgHF7qiKWmjKcgWHOcweH7MNrFLeftWfO3
         Pr9O1KL0BwblhWDd1WtD16Kntxw3t2rMVlaRW97fggyx8ZsY49lnIxzarUJQdrKJ524S
         tPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WejKE5rgIYd2juLQ5yLBMOZc5NS4+eiKNj8SAqG4Eh0=;
        b=rs10jwEYV7MwGfyH0bInlC7cqJpzjUd/czbuwszcy11hptnYNcLQ2OipFDtFpbGFZJ
         ZK9fjSKPfio5+f2QzdfL6eO1nktICWvMlPiznJTP5UMz5gn8ZuDhkPZxVJKCbEM4+L3B
         qsEuD/lB/S65sKYg76AR8eVgLKL2TlGzq2ng7W6AWi26WxrSrvmUOCkpB+VbHO/+Q2Un
         ywVN8aabcrMzoPyn6kE2sVY+MebYE2O8xlh9kUupwq7pHlZpDgIaXnIktjqTsJQ3Mdke
         k/GYOgyxwqxFg6UbR2glqiJ/OfodaFDxwHON97jlPBUG6dzUg88JrZZs1jDGArczNMIL
         Tlhg==
X-Gm-Message-State: APjAAAXhmpj2tb2JdxOI2KKR6HQ0ldZV2FHMouSZQ5KLyvqOqLJoFN6l
        CmGLEPSF1f33jlPNgo9sXTMFQ2cN
X-Google-Smtp-Source: APXvYqyQD1JZXZNpzrrvnS+dfDzpQNp8QEfHDRuWBk3bLm+CaBjhrAw2oEOjXwGU5GuREm4a77+jkw==
X-Received: by 2002:a63:e5a:: with SMTP id 26mr37750681pgo.3.1568308975859;
        Thu, 12 Sep 2019 10:22:55 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id r185sm33384308pfr.68.2019.09.12.10.22.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2019 10:22:55 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net v2] net_sched: let qdisc_put() accept NULL pointer
Date:   Thu, 12 Sep 2019 10:22:30 -0700
Message-Id: <20190912172230.9635-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tcf_block_get() fails in sfb_init(), q->qdisc is still a NULL
pointer which leads to a crash in sfb_destroy(). Similar for
sch_dsmark.

Instead of fixing each separately, Linus suggested to just accept
NULL pointer in qdisc_put(), which would make callers easier.

(For sch_dsmark, the bug probably exists long before commit
6529eaba33f0.)

Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
Reported-by: syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_generic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index ac28f6a5d70e..17bd8f539bc7 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -985,6 +985,9 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 
 void qdisc_put(struct Qdisc *qdisc)
 {
+	if (!qdisc)
+		return;
+
 	if (qdisc->flags & TCQ_F_BUILTIN ||
 	    !refcount_dec_and_test(&qdisc->refcnt))
 		return;
-- 
2.21.0

