Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BB07834D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 04:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726432AbfG2CWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 22:22:05 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:37853 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfG2CWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 22:22:04 -0400
Received: by mail-pg1-f195.google.com with SMTP id i70so16664713pgd.4;
        Sun, 28 Jul 2019 19:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=7fp1YuLIkMp6V8LF5r3sZVLgOMYUpY55IUl5NCyG7hQ=;
        b=NDckJD4LK99YxCkG/Uove+eO+w0elZ6wg+NR79uzg5bvZfri5Opl3sEsl2Bkb2yBmV
         0N3VNYxCruJ8jiyuya3Hrb2dsklL5xlB2t84gVkQYLy9urKgwj2wDLgtMp/KeZWYbN6Q
         i2ZGiaAf7R7iklB3W8KDkeo+fhhteBW95MKj0Vl/CZAd0d/LLdRxv9gCKfEV8sObclw4
         3IQAVmsHDEHyGQlxWKvyGQ0TZkBmSVLNcYRDE40RGzdk3e2DTAHTzb0hUcRVEBdL3Br8
         VQxG0Y8YqoGEwCS8MAABUrGvWsWSR/In0XlEXA6tnCeG2rAioJ4uimRuX1xHBdRd4y9p
         +KOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=7fp1YuLIkMp6V8LF5r3sZVLgOMYUpY55IUl5NCyG7hQ=;
        b=LUsuLeaCz2wOOO5NnXlCGnw7q4ksK7vFVjNrSArcv+2d4u7lzYG5bwyn1SR1Wv7uNe
         s5NFqUEzPYTpn8Ec7ZnrxZyMeuyd45tMXJK36IzuG+wCJohUMP97dhdt73UB0+WRfwL4
         5XobdpnpOYZqR/N2n0oQBA3QRF+81CUyN5KYinDrWeQvjzp8J4qQC9ZRWqCE9rE0o7vS
         Wtif62Q92BcNYqNlrELTZ8lfbzChLqk1y97FTsOjrZBLiTEvqTj7tndg1T64stARMM0N
         0z/9S3o1v5b7hyREKIPswDtsR7vWxwsqn5sJObbrMZTv1isLLBwKW9lIH8pBTTFQMobJ
         vjHw==
X-Gm-Message-State: APjAAAXZmE5IWpzFs7HSUk+xk6hlaeb7UrljYwlVcPURsO+yMmzFRvzq
        1C/rzF+D9q0ffEEodUz6scE=
X-Google-Smtp-Source: APXvYqzRaqTartOBdQBYeocDw9EcrmOmZjGSJiZ5Hfc6SJQaHiSUImp3RF/PBFkzFSmfB7s0CczkgQ==
X-Received: by 2002:a63:d04e:: with SMTP id s14mr97287640pgi.189.1564366924059;
        Sun, 28 Jul 2019 19:22:04 -0700 (PDT)
Received: from oslab.tsinghua.edu.cn ([2402:f000:4:72:808::3ca])
        by smtp.gmail.com with ESMTPSA id j128sm56150318pfg.28.2019.07.28.19.22.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 19:22:03 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: sched: Fix a possible null-pointer dereference in dequeue_func()
Date:   Mon, 29 Jul 2019 10:21:57 +0800
Message-Id: <20190729022157.18090-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In dequeue_func(), there is an if statement on line 74 to check whether
skb is NULL:
    if (skb)

When skb is NULL, it is used on line 77:
    prefetch(&skb->end);

Thus, a possible null-pointer dereference may occur.

To fix this bug, skb->end is used when skb is not NULL.

This bug is found by a static analysis tool STCheck written by us.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 net/sched/sch_codel.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_codel.c b/net/sched/sch_codel.c
index 25ef172c23df..30169b3adbbb 100644
--- a/net/sched/sch_codel.c
+++ b/net/sched/sch_codel.c
@@ -71,10 +71,10 @@ static struct sk_buff *dequeue_func(struct codel_vars *vars, void *ctx)
 	struct Qdisc *sch = ctx;
 	struct sk_buff *skb = __qdisc_dequeue_head(&sch->q);
 
-	if (skb)
+	if (skb) {
 		sch->qstats.backlog -= qdisc_pkt_len(skb);
-
-	prefetch(&skb->end); /* we'll need skb_shinfo() */
+		prefetch(&skb->end); /* we'll need skb_shinfo() */
+	}
 	return skb;
 }
 
-- 
2.17.0

