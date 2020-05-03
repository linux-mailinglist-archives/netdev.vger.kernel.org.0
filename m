Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770A01C2970
	for <lists+netdev@lfdr.de>; Sun,  3 May 2020 04:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbgECCyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 22:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726737AbgECCyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 22:54:40 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2365C061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 19:54:39 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id x26so14516903qvd.20
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 19:54:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=KZxU7fhcXs7NKSC1K/Ymo11K3GPQvbR81eqkF9drnPg=;
        b=IJ1JBmqkZB1oHiaZkSUnzVmHTq3/5A3N9cH/h53bmM+uJXXe2he54rQSjDDv0XUNok
         BL+AeakbWDgjWZLBs6yLCFPy0xwpbn6Ryoz7VPktsrCE/nZhtO1gNituony0ElQ0rPdR
         whNdgc4/khMxNUJfc6vpqDftyXbz3ibYcVEVHHKPay8P7geYRFA30rVZn2gy28mq1N8v
         UF+S68Ctdy8fUxW4IRCzZw8ZRt4YUthgZpOlBGepZr4OXjHwnxsjT3hZogDy0+lL5FVV
         RtdpRO28+yzAE4AOdyjgAVD925H8sokj1y7r6zOBmvu+XhkjNicDXbR67VtQ8Dfw41xW
         Yl0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=KZxU7fhcXs7NKSC1K/Ymo11K3GPQvbR81eqkF9drnPg=;
        b=DZ0VpRkOYctNne23mexkCoEWTBPcYTSB8PFTY5fmeFeFbVPCNgYnyMa4Zp72MsU0x4
         rdE/f3wmPjlLC/u1cmF/GulJZrQ1993VMs9hltq3Q+mIjI+99/befx9IeQBuDT/pXJU5
         yLiBbPqnCt3sXKZBz9kAdshjOwmcwXCm1ZgSODuR/3MJrraz36qbGNPN/HJO1YPVmgKC
         SS3GKYQw+Z6uCOqG6Fe8BKjGE0hEsCMVrooyWgXVHYalg4EPhZNdB7YDRG3Cxpw0sAsC
         ClVAY9t/cA9b6FF/aKjlc6ibHMPNOULZStu/TNWSgqOBKJXnvo2yK+buPe5sOEd6hqE+
         nQXA==
X-Gm-Message-State: AGi0PuadMlakLF/ojfo6sGY9Kq70OlG1RTSvtL5OGB8iJlIPLUkj8YJQ
        dfqzwKu/uZ6ag11vMOkB3Y6cPtNI3BiW4w==
X-Google-Smtp-Source: APiQypLLI7nT7XUd4a8GJDTgAb6cFI5bx4a3FnxCngaQ0WN814XMIcsL+Z1rcTkFeUS7qnXI5+3ez5eqc/SdNw==
X-Received: by 2002:a05:6214:32d:: with SMTP id j13mr10428963qvu.96.1588474478945;
 Sat, 02 May 2020 19:54:38 -0700 (PDT)
Date:   Sat,  2 May 2020 19:54:22 -0700
In-Reply-To: <20200503025422.219257-1-edumazet@google.com>
Message-Id: <20200503025422.219257-6-edumazet@google.com>
Mime-Version: 1.0
References: <20200503025422.219257-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.2.526.g744177e7f7-goog
Subject: [PATCH net-next 5/5] net_sched: sch_fq: perform a prefetch() earlier
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

The prefetch() done in fq_dequeue() can be done a bit earlier
after the refactoring of the code done in the prior patch.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 4a28f611edf0cd4ac7fb53fc1c2a4ba12060bf59..8f06a808c59abec0e8343a00250055df7cab6f10 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -576,6 +576,7 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 			fq_flow_set_throttled(q, f);
 			goto begin;
 		}
+		prefetch(&skb->end);
 		if ((s64)(now - time_next_packet - q->ce_threshold) > 0) {
 			INET_ECN_set_ce(skb);
 			q->stat_ce_mark++;
@@ -592,7 +593,6 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 		}
 		goto begin;
 	}
-	prefetch(&skb->end);
 	plen = qdisc_pkt_len(skb);
 	f->credit -= plen;
 
-- 
2.26.2.526.g744177e7f7-goog

