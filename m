Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0973F3CDE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 01:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfKHA2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 19:28:00 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:43542 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727544AbfKHA2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 19:28:00 -0500
Received: by mail-pg1-f202.google.com with SMTP id k7so3256859pgq.10
        for <netdev@vger.kernel.org>; Thu, 07 Nov 2019 16:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M6knRbzktmSHATsJ61EeEflcrrPQ12voeIcOjCcipLE=;
        b=Bc1KHOG8uCKBbV8HeKPICmiQqfn3zwVgw0n7gQHJ5PIFamvYRALLpjfCZ1Re27gqPQ
         0vjmDAmW640qWivw9E1sLq/TAMTWrFWB426WEY6Cxfmtc1WtFksa2a3UnCF3IZz8tCTr
         I5ZBZqpdT29+90AkXMV1v+zIg1l31ajzxQ3tUYyskzFq1Uh524YBvpXkB0BsgqsQ3PDn
         tmOySIGpVpLERNTMt1wjyNGZhoxgvTjo43v2A2VvlewZrykW5AS0d8AAni5C7lcC3Wvv
         55TETgmA/KJtIgVdkjE1uayKwfEI34OT+yGVFWQ5V3blmuCOGWi3/XqJrSCxRhQYNuy/
         dOvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M6knRbzktmSHATsJ61EeEflcrrPQ12voeIcOjCcipLE=;
        b=MFNlZUsStct/ecVtmSskzv/G3+cqtFjNLqSTCXbWGoojgPnSFqQqfnqcLzhjVqTlHO
         SMpBt8XSEvJfxzDvLUHg3AV69zixyGxj5eUJZlFlmIV54l9KBCp63mk/Stf6zwhKoCpA
         w+rwlWflShY64qJf/zTnZvagIcnQww7cYxCETghPv48iJLeU0hQhliIKI3E/bSh06YZk
         J9EGi3HE0VuEvk1wQ7gGKq5jZVl9vAIrTHrjeT8RQfkVdH5u26pab69wjR4ykL6Ml5iS
         e7xwDJHwC0WTn/sRxkk3m0rZO+Nb95JLYHhFFU2WLjReJ6060csbPv+ejlNvNqjKZvKU
         oH3w==
X-Gm-Message-State: APjAAAV+YMaCCsJumjofrvfDPQXu1GV3JC6YuFaE1pxB50SRmxKfxPTm
        u05kkrbxEpMdEtifHrdgBuCtkU9mxirdWg==
X-Google-Smtp-Source: APXvYqzSmV4aGmBiXRiBFdanY2mEDvrL3AqRPnM1mH3Vb1wdz8zA7D6p4Y1J+7WccmodEMb1rg++xZZepdr8Nw==
X-Received: by 2002:a63:5210:: with SMTP id g16mr8078364pgb.72.1573172879321;
 Thu, 07 Nov 2019 16:27:59 -0800 (PST)
Date:   Thu,  7 Nov 2019 16:27:22 -0800
In-Reply-To: <20191108002722.129055-1-edumazet@google.com>
Message-Id: <20191108002722.129055-10-edumazet@google.com>
Mime-Version: 1.0
References: <20191108002722.129055-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
Subject: [PATCH net-next 9/9] net: use u64_stats_t in struct pcpu_lstats
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

In order to fix the data-race found by KCSAN, we
can use the new u64_stats_t type and its accessors instead
of plain u64 fields. This will still generate optimal code
for both 32 and 64 bit platforms.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/loopback.c    | 4 ++--
 include/linux/netdevice.h | 8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index 47ad2478b9f350f8bf3b103bd2a9a956379c75fa..a1c77cc0041657de79b562c84408acabf9e8b99b 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -106,8 +106,8 @@ void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes)
 		lb_stats = per_cpu_ptr(dev->lstats, i);
 		do {
 			start = u64_stats_fetch_begin_irq(&lb_stats->syncp);
-			tpackets = lb_stats->packets;
-			tbytes = lb_stats->bytes;
+			tpackets = u64_stats_read(&lb_stats->packets);
+			tbytes = u64_stats_read(&lb_stats->bytes);
 		} while (u64_stats_fetch_retry_irq(&lb_stats->syncp, start));
 		*bytes   += tbytes;
 		*packets += tpackets;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 461a36220cf46d62114efac0c4fb2b7b9a2ee386..f857f01234f774d70d8c2425498e1fbc9909d88e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2396,8 +2396,8 @@ struct pcpu_sw_netstats {
 } __aligned(4 * sizeof(u64));
 
 struct pcpu_lstats {
-	u64 packets;
-	u64 bytes;
+	u64_stats_t packets;
+	u64_stats_t bytes;
 	struct u64_stats_sync syncp;
 } __aligned(2 * sizeof(u64));
 
@@ -2408,8 +2408,8 @@ static inline void dev_lstats_add(struct net_device *dev, unsigned int len)
 	struct pcpu_lstats *lstats = this_cpu_ptr(dev->lstats);
 
 	u64_stats_update_begin(&lstats->syncp);
-	lstats->bytes += len;
-	lstats->packets++;
+	u64_stats_add(&lstats->bytes, len);
+	u64_stats_inc(&lstats->packets);
 	u64_stats_update_end(&lstats->syncp);
 }
 
-- 
2.24.0.432.g9d3f5f5b63-goog

