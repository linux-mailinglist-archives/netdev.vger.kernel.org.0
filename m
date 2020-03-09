Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2021C17E81A
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727506AbgCITKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:10:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33127 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727431AbgCITKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 15:10:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id n7so5272868pfn.0
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 12:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kRuxHUsSRurXkxPQExLKhYHQGjE4nNAaLunugsH0t+I=;
        b=t1cDD5NZT4euzIWR1Q76Nhgx1LyBSvteqb7dmKxxW5JaRA3iFLUCYMrlo/jaDr+Z76
         u1UV19k5DJjW6xGACKZFAUkuQ/CyO/oxRDt5gAiv8GgpkukrGDGPsaiZpiLHqyKKUJ/Q
         hrLhUIvH87ThzCt2Z6CPORq4g5AyzSERkvZO/YU6k8pwUFsiEz5yXXxYq0iuinUIkKQ7
         Si+7QQJ2oe2rm00sT2PyljCAZsuuncL7d+vOQa2C3vcfieLR2tdTa5h+X1UjMGbgkb5n
         9QwS0Bc8ZoIjf3QXqFuDClB/C1CAOiGn0PNTvakBrZJAxER/2T8pyXov6BLfZZDQKVHH
         0rPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kRuxHUsSRurXkxPQExLKhYHQGjE4nNAaLunugsH0t+I=;
        b=eliixDlDKIabM0Gwwp+TtF11X7YfatgQwfge8W0S57Nxp116goAQQzfXR2LlloELRf
         h/b2EScRZV0lrp42mReUpdbgza9EoW1QHBb1kV9HnQO5gBGrKPtrS87iTWbYi1s6Mukr
         2fAf8HzStIlvCp11Id9qPpgmOtRkLwYPQcSOq2mKat4nDLhIY/jEU60Hf9PUeBQpRZnp
         WBFe6zpcAUllDQUQbM5YQPvywCNUHF0zGd8XMJzTLZP4xjUtK87LmhhCxRdJLkCClgKa
         rP6lfgtJyeO5+gN2kSG5JNtQYodox6MXSX/re+y5yCeNRJqwq3wzSLp7yhUxBU31IaSD
         tztQ==
X-Gm-Message-State: ANhLgQ2CaaZO/qsaBHRKev1KEqeDaWfHMxKhLJdLgfMhMskPBNxMB/ab
        Aip1L7Vg0tkMRlvqCx1sR3m6oM8TDPY=
X-Google-Smtp-Source: ADFU+vuweQmVD3u4ZlxVnOjtm3Y0uqZ/bTEK+kaDjGS/ekkZCP0opwWi9JSUIkMLOMuECnxJt+UCUA==
X-Received: by 2002:a63:a351:: with SMTP id v17mr17234652pgn.319.1583781040669;
        Mon, 09 Mar 2020 12:10:40 -0700 (PDT)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id u23sm45192944pfm.29.2020.03.09.12.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 12:10:40 -0700 (PDT)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next] net: sched: pie: change tc_pie_xstats->prob
Date:   Tue, 10 Mar 2020 00:40:33 +0530
Message-Id: <20200309191033.2975-1-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows")
changes the scale of probability values in PIE from (2^64 - 1) to
(2^56 - 1). This affects the precision of tc_pie_xstats->prob in
user space.

This patch ensures user space is unaffected.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 net/sched/sch_pie.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index f52442d39bf5..c65077f0c0f3 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -493,7 +493,7 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 {
 	struct pie_sched_data *q = qdisc_priv(sch);
 	struct tc_pie_xstats st = {
-		.prob		= q->vars.prob,
+		.prob		= q->vars.prob << BITS_PER_BYTE,
 		.delay		= ((u32)PSCHED_TICKS2NS(q->vars.qdelay)) /
 				   NSEC_PER_USEC,
 		.packets_in	= q->stats.packets_in,
-- 
2.17.1

