Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6ACAAB03B5
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 20:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730068AbfIKSfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 14:35:00 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45595 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbfIKSfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 14:35:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so14205790pfb.12
        for <netdev@vger.kernel.org>; Wed, 11 Sep 2019 11:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PQBScNVaDEVcrEbBJf4Va3s+6GnqiQP0q+sffwy2NeY=;
        b=J12owAOx91OwJ6dOseUAjaMaGEHi2PgQyBt7xuNkbGR4dvUSHeBkMf9rttSuurILoc
         VPFU3v7pTio8jLFmLehb2UvRdmKTSmMfvAjmWxOOd97Kldv5IVOk6wqoa34+uQ0jNtQm
         NXuIAGNGh3e6iUx1PTdQN1+RqQ6XCu7Lv1tnlHwBhhvIoOlgsm+x9eo0tWU4craoRY4O
         RkjBmQPgGw5+lmDU90s9PSwpNUOvphpU4TLF0JJlGgD8iBgd17B6f34u/Rm0msxCsNBf
         f78C+fuIm+Qun6Lg0HLfE6Kqtz4U0AV8sePpBWYHEuq9z2TJZfnEgPZ2GYOerigqtm59
         YtTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PQBScNVaDEVcrEbBJf4Va3s+6GnqiQP0q+sffwy2NeY=;
        b=OXxW4pca4ekpF75MpgGNe6f7MasuZG5FoHpnPFPyJ+fRU4jUGsWcX5FTzxFD0UfWE7
         cUhwMRQoOo27LxdQnrf6Ku1vxc8bP3MIXMm5eH4SHB3VqKr7BBu2+qbrigLnSuIOUYLS
         B+cvNHpzjHrryokdIhENHtNp9k0JqIYxyrDfi5eyBgmzQaKXfq/1MT3xJcNR39Vqoi9Q
         jMa4koHLC8e5CaDs3l7rNXB3OWfM+nhH52AUJE49XUidOtlTFdQ8I3f639L10hXfkN62
         wL+X3UF+AtJBiBKmc4LUNHxFPBXfOr8GNwFvD5yeVWYhH6/ySo3BsOlHaXoLr7LrgbiB
         3+Iw==
X-Gm-Message-State: APjAAAVhaGUz69hAy0aKfr+noJo/jEJOvmFq4R9uHr/1OYedgKkiwdgl
        4BS50R+iItEFnvQFKTI6MuyXufp+
X-Google-Smtp-Source: APXvYqwJpnT9J+gOZPQ2hmTVhJ6Xo2Ym8s4Kxpb3bnqJ0Pxokj8i8hPZlC3c+SmceaEFvGqz+R5a4Q==
X-Received: by 2002:a65:6546:: with SMTP id a6mr35257412pgw.220.1568226899742;
        Wed, 11 Sep 2019 11:34:59 -0700 (PDT)
Received: from tw-172-25-31-76.office.twttr.net ([8.25.197.24])
        by smtp.gmail.com with ESMTPSA id 69sm29760529pfb.145.2019.09.11.11.34.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 11:34:59 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net] sch_sfb: fix a crash in sfb_destroy()
Date:   Wed, 11 Sep 2019 11:34:45 -0700
Message-Id: <20190911183445.32547-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When tcf_block_get() fails in sfb_init(), q->qdisc is still a NULL
pointer which leads to a crash in sfb_destroy().

Linus suggested three solutions for this problem, the simplest fix
is just moving the noop_qdisc assignment before tcf_block_get()
so that qdisc_put() would become a nop.

Fixes: 6529eaba33f0 ("net: sched: introduce tcf block infractructure")
Reported-by: syzbot+d5870a903591faaca4ae@syzkaller.appspotmail.com
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_sfb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_sfb.c b/net/sched/sch_sfb.c
index 1dff8506a715..db1c8eb521a2 100644
--- a/net/sched/sch_sfb.c
+++ b/net/sched/sch_sfb.c
@@ -552,11 +552,11 @@ static int sfb_init(struct Qdisc *sch, struct nlattr *opt,
 	struct sfb_sched_data *q = qdisc_priv(sch);
 	int err;
 
+	q->qdisc = &noop_qdisc;
+
 	err = tcf_block_get(&q->block, &q->filter_list, sch, extack);
 	if (err)
 		return err;
-
-	q->qdisc = &noop_qdisc;
 	return sfb_change(sch, opt, extack);
 }
 
-- 
2.21.0

