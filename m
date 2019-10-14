Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5370D68B5
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 19:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388676AbfJNRkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 13:40:37 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:51301 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388671AbfJNRkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 13:40:36 -0400
Received: by mail-pg1-f202.google.com with SMTP id e23so4634188pgt.18
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 10:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=k44RFWgW2NGqYxyf6e71UsNxM7R6xoVZuq+kWkqcLAs=;
        b=EIf2XyY82eZpxI4+IvzwOxffmgp/ZdV63DHCbacvwBZ0Fflbm8JhEcHOiER4xGvfcL
         Ua1mxNljfdSw8duyPG2rSqJZZKanNIzK8MyMRivhHZt9gwZ/2KxfCuY1Mbh5iHNV748x
         njTy5MrVEAzkTrD3CUxn50A31lAipvH2fzi4GYZXrDFIOFOJ6iqF3ZVzWWbhjdDwao3F
         aJXseM87czt4KMDL6mtmRmxBroP0n2m2ZRdTmp+FgDYfHiIWgexR240Bnm+H8SNh/LLM
         U4Da1fLLDO1kmKiam/ChkgI1O2VNfuTLtsVOQBafQtnyH0n/GF5CVZoexypJfCd9+/l4
         Aw/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=k44RFWgW2NGqYxyf6e71UsNxM7R6xoVZuq+kWkqcLAs=;
        b=lINQouVY5eDFmlbYKw3I8FYBNFku60tAWUsu5yTj/NbSQvqT8tpxIvaC+/SYrezHBA
         5wvqoGJr6haN0Z07iRiy914LqbLFiSBhAeBpwHQntQS+HvRAol0+yLbJfkgG+roN5dYu
         XHORanTCHsL6xGBF/oJ+xKa0W+tapMO5zgpr56ptkY6vny8Zp3Xi4eglf5GiUFP7Q9l3
         IfrugF6Em19LMYZDT7P91y3UWO1XYuzCbOBZnwVkKJbr9ntRv90xXWcurAOTome4kEgO
         aasCg0BbZmZUuUHUnmJEeIvKmHE0jiZFdTr75Qq6ZvH8GP41JdVXVUkerLi56hfW9m7i
         vTmA==
X-Gm-Message-State: APjAAAXqTEj+7qtwBQQYwZt5yak1vv3lxU0kqW1BaP6vNhVGmYPzZJzR
        OuDHjN/4RmDN0/xDy/ATlZ0xLEy+xcmYaA==
X-Google-Smtp-Source: APXvYqzDz9vuybzV+qi86/V9XihnxINTRE/Ynh4lgj1vrAAFKUiItzcXsv6HRocUFTMNDEbjfvS6SzbY2ZF7pA==
X-Received: by 2002:a63:1053:: with SMTP id 19mr33152972pgq.229.1571074835645;
 Mon, 14 Oct 2019 10:40:35 -0700 (PDT)
Date:   Mon, 14 Oct 2019 10:40:32 -0700
Message-Id: <20191014174032.138670-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
Subject: [PATCH net-next] net_sched: sch_fq: remove one obsolete check in fq_dequeue()
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

After commit eeb84aa0d0aff ("net_sched: sch_fq: do not assume EDT
packets are ordered"), all skbs get a non zero time_to_send
in flow_queue_add()

This means @time_next_packet variable in fq_dequeue()
can no longer be zero.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_fq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 98dd87ce15108cfe1c011da44ba32f97763776c8..b1c7e726ce5d1ae139f765c5b92dfdaea9bee258 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -530,8 +530,7 @@ static struct sk_buff *fq_dequeue(struct Qdisc *sch)
 			fq_flow_set_throttled(q, f);
 			goto begin;
 		}
-		if (time_next_packet &&
-		    (s64)(now - time_next_packet - q->ce_threshold) > 0) {
+		if ((s64)(now - time_next_packet - q->ce_threshold) > 0) {
 			INET_ECN_set_ce(skb);
 			q->stat_ce_mark++;
 		}
-- 
2.23.0.700.g56cf767bdb-goog

