Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECFA1B8917
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 21:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgDYTk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 15:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgDYTk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 15:40:29 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9FCC09B04D
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 12:40:28 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id i13so4569297ybl.13
        for <netdev@vger.kernel.org>; Sat, 25 Apr 2020 12:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QgqdoTX1q9FiyDtvZ8kmw0m0jsyKN3E1rjb/fZBzd1A=;
        b=GYqsepRgHIN4pYKZhD3ayQCJQvPHjEursR/OwT55wu5f8yS5NfmprIJfS4Ucb5G2pS
         M58rQZGMsdrolZOvv8bZheaRkvpWMG91IbWpzRVoXipCPNcTSkp1Ah3XjqWTGXXCr70n
         SAqMmdxhLxqCZpoZ+0iwCRW3Re1DcsqZj9JTBBhoupcM/W2PRKaHnsgKYlLOQCkZ9Cte
         Jsie1q6SoZXyjhQffhDHFPspnKoV0LY52iZotnaoE6qdVKPEjv+eZPaTfTNLAE6dsz/s
         1UXZaTyLZhvqF5MB0PqArW4TCOt+9DqYvOD0t2KdN5sjUWB1Qnfvmv/bbQBkOVLfI5Kw
         CDIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QgqdoTX1q9FiyDtvZ8kmw0m0jsyKN3E1rjb/fZBzd1A=;
        b=bPr/0BRrNu3f4bkwJC7zOzJ9tpsS/SlZsRsxBZexbDMkA6wEPiZVJlORJIPidQ4Xso
         jab7VLoDov8BG12iJchsp/9jBRmwlG3Zcsz23xbkdYxfo88ewAltBad4cRrucqRVXn2d
         aV2wBFEENUrZ2XEkb3IF92AHKJLZW6kSrRH0I2wtmYy5eMNPUv0gGu5sgHQAySY/kRzr
         m3iKmySCU1sLlT13nSgmwU6jNbnqYFWftN85y0qBCCbSy+4w5T2zFsy8X8LK3Fod6ywZ
         +fdtpzfV5SfMeGiIYdIwdsQm+1YC3RGeGe8/AXxtwLVuawdiUi5Pa6C2TQLsZHZrb9JY
         v7fw==
X-Gm-Message-State: AGi0PuaZeZ7f0UbLWO3kUwVVZelVRYMdL0Janqe500MQCZ4uOCaZ/Rc1
        imn2i8GwtbvXSzB/boqCq4GFawTe5MDA5w==
X-Google-Smtp-Source: APiQypJ1waA/49ECTyt+1018/gzQ0zVqDYl3wf/pejRiC1XqnyrcPLoLi4+OERo1scsBb3IxfW6cd0HkIj9tCQ==
X-Received: by 2002:a25:3ac1:: with SMTP id h184mr24117383yba.345.1587843628139;
 Sat, 25 Apr 2020 12:40:28 -0700 (PDT)
Date:   Sat, 25 Apr 2020 12:40:25 -0700
Message-Id: <20200425194025.70351-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v2 net] fq_codel: fix TCA_FQ_CODEL_DROP_BATCH_SIZE sanity checks
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

Fixes: 9d18562a2278 ("fq_codel: add batch ability to fq_codel_drop()")
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

