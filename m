Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5849A054F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 16:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbfH1OtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 10:49:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39083 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbfH1Os7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 10:48:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id t16so88115wra.6
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 07:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wwPrHD9B9Uk9SDW5IlYFLNIzKAIZd1sKRqDdkZvisP4=;
        b=HXcIOox55Mie1MfJsPpZB2Nq8lpmINcUW5ZLJ26tuuOu1A9aT18N2PRmUbY6elIJy7
         m1PhxroXo74qGnt/jxBCBbBRkmSXLxVT3E8LALgAa3oYL9iRte7a4cODj4v3KTfgbtua
         sX76LVQA4ooSV2nVqDoqP/GImMH1a7M5lb8N7YDDNZSO5lXYh4M35Mjfjc+wTbaVpo/d
         fqXMGP3uhnijhAO7qcNZ9v2goE5c/E88ZLFhjXx7/rx6qeSIk9FPF3TytGW6r4kPkg9j
         8sDeALvYsxyqFXlzVsZqhufmfxJoAjort4z+eWiecNh1GgEDhuIwljYoTqRc29w7G4dY
         kLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wwPrHD9B9Uk9SDW5IlYFLNIzKAIZd1sKRqDdkZvisP4=;
        b=gasNHFQuKNSYaFb+iwfbIv7DUyu+cNCnW40WK0pULTkthlMzQ+iB01mj6XJiez0a6x
         qK59zHOZVOu3m/iiSXE3TTyQE5HNEQcq2pK0OTjk7Xzm2zJ39jw+aDqLmRgNHwzrh+5W
         htmAQjBrHQKfDfZ494GDG77jNwByxDosmRy3g8PgQ92mH76v8AErumFwq0EWGA1wfrdu
         OBtSHycDmWrhZuWQ+mq8rTv4B4m1hdhan9QQP50xW+1as+NoBdNqVZUruBZq0IPPNkL6
         zXFcLGuF8Gv9cCpDZHytX3uCFIaPWFkvyY5+M4SZKpWdQENg50zzBqU/qf+6fpPJdu9O
         +O2A==
X-Gm-Message-State: APjAAAVZUa8aJE5HkWz0/oG/6ZOE+T3aCS5hf/gxqrB2KYM9NW2zIMiG
        Pb0gthJ8vlutsCKi/wL5ldc=
X-Google-Smtp-Source: APXvYqxUClV5svo8Doz9rMxTGJIup5si9l5hLanSB1Pa9CCGWl+RuhiZFNgkR0gUdMzJHEFnzkJDtA==
X-Received: by 2002:adf:dfc4:: with SMTP id q4mr5109691wrn.54.1567003737405;
        Wed, 28 Aug 2019 07:48:57 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id n8sm2973323wro.89.2019.08.28.07.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 07:48:57 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net 1/3] taprio: Fix kernel panic in taprio_destroy
Date:   Wed, 28 Aug 2019 17:48:27 +0300
Message-Id: <20190828144829.32570-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190828144829.32570-1-olteanv@gmail.com>
References: <20190828144829.32570-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

taprio_init may fail earlier than this line:

	list_add(&q->taprio_list, &taprio_list);

i.e. due to the net device not being multi queue.

Attempting to remove q from the global taprio_list when it is not part
of it will result in a kernel panic.

Fix it by iterating through the list and removing it only if found.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 net/sched/sch_taprio.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 540bde009ea5..f1eea8c68011 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1199,12 +1199,17 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 
 static void taprio_destroy(struct Qdisc *sch)
 {
-	struct taprio_sched *q = qdisc_priv(sch);
+	struct taprio_sched *p, *q = qdisc_priv(sch);
 	struct net_device *dev = qdisc_dev(sch);
+	struct list_head *pos, *tmp;
 	unsigned int i;
 
 	spin_lock(&taprio_list_lock);
-	list_del(&q->taprio_list);
+	list_for_each_safe(pos, tmp, &taprio_list) {
+		p = list_entry(pos, struct taprio_sched, taprio_list);
+		if (p == q)
+			list_del(&q->taprio_list);
+	}
 	spin_unlock(&taprio_list_lock);
 
 	hrtimer_cancel(&q->advance_timer);
-- 
2.17.1

