Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA381B88DC
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 21:23:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgDYTXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 15:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgDYTXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 15:23:04 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CDFDC09B04D
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 12:23:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g89so12390541ybi.23
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 12:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IvcauQQxp0XJ6aKmkJ2lWe937bcW7vgqd9tAaZYX4Mo=;
        b=eCrO6XSJDhyhdZm3rBhHQc+SWqS/XGXmKm3BXYDUZev26GQrySP1zsHMWG7f1ia65H
         CP5H3v2okuxn+Q3Z7hM/l8zX8aRUTUZCu1vTUsbi36hbal0u9GwdKRQLu+xQbh4qwuwd
         HmrvY6bsRcq9wVVRsSFVtUs91M/2iRUWLE6f0pIgDLSh/bJH+YJGM3XtYe0xv8n+5Vq6
         cvkdEZSNletViFmg8GHzMaSnkwrQHi6FK9ZDMnnqW7VqWYZKwt26p4fgEans9zzzAaZs
         ak3eEAWRPUOceQO0zqPql7ATV2OlCbuzOrKM5S82000lQmd7nAA6VFUc2g3Tud4mAWVH
         Ly0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IvcauQQxp0XJ6aKmkJ2lWe937bcW7vgqd9tAaZYX4Mo=;
        b=klDpQFbhI9ZaYXGxS9PMIMJAnQdStvhR4eLQ/b5tqZRB5eHSSMZc88t8TIt0xrkXD2
         iXtiv1O0XG6o3f7ifqV9k39W0NSMDxVl9b+UPFN3T3U0OGgTAjNSe933U8nHHIBpo2PZ
         M5WdghATEAQ1dk/e9itWs0e1E+Q8zCi31T7wu4jzt5hO/YZPfw4locri/XzOaR+eb0VI
         8Ap/35DGaCp+7BX85Hymxr67C6CyuM4vRyEJWrY3hVJ5q4nh8EnUxJcupFa2BeGEpSYC
         i/gciTCgmABavMh7AG/rzjrSl0CdAQDMzVJsaTlAy+Mu8ZyErbKN1aiFXGW/Iz9288D7
         JGeQ==
X-Gm-Message-State: AGi0Pua4vQWIR5OHJR1b9cajmZQJ/+4LTl2GCqYh3xDM0dw7hiMEvNzF
        c8QjrYx4CweEBI9zhxmvMSqZ1NcSmWrnbQ==
X-Google-Smtp-Source: APiQypJ+NjR9L5HCdvPlU+aAZWZwdxuL9FeZdyUNCD35jpZjqjwtx7eGK1WYNf8DaGLJpR/Q12mKFmLDXnPo6w==
X-Received: by 2002:a25:6b0a:: with SMTP id g10mr19680794ybc.437.1587842583263;
 Sat, 25 Apr 2020 12:23:03 -0700 (PDT)
Date:   Sat, 25 Apr 2020 12:23:00 -0700
Message-Id: <20200425192300.46071-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH net] fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My intent was to not let users set a zero drop_batch_size,
it seems I once again messed with min()/max().

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq_codel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 968519ff36e97734e495d90331d3e3197660b8f6..436160be9c180ceedaeb74126e40c7e24bf7ccba 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -416,7 +416,7 @@ static int fq_codel_change(struct Qdisc *sch, struct nlattr *opt,
 		q->quantum = max(256U, nla_get_u32(tb[TCA_FQ_CODEL_QUANTUM]));
 
 	if (tb[TCA_FQ_CODEL_DROP_BATCH_SIZE])
-		q->drop_batch_size = min(1U, nla_get_u32(tb[TCA_FQ_CODEL_DROP_BATCH_SIZE]));
+		q->drop_batch_size = max(1U, nla_get_u32(tb[TCA_FQ_CODEL_DROP_BATCH_SIZE]));
 
 	if (tb[TCA_FQ_CODEL_MEMORY_LIMIT])
 		q->memory_limit = min(1U << 31, nla_get_u32(tb[TCA_FQ_CODEL_MEMORY_LIMIT]));
-- 
2.26.2.303.gf8c07b1a785-goog

