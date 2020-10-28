Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ADC929D94A
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 23:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389600AbgJ1Wub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389556AbgJ1Wua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:50:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6AAC0613CF;
        Wed, 28 Oct 2020 15:50:30 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id h22so788283wmb.0;
        Wed, 28 Oct 2020 15:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1CEqaQjMv77SiJCZ+Ml1JB/3M4/OfgLP7wUO6uiGBUs=;
        b=bR1CCcPMmvIaitAJ/L84I7wG4ssUkX6QgTxmEp/5I9tT9LEQJAPNiwovP4N9tQTfh2
         Wr8TKpV/V8w+yJzzl2HmH5UmTZpbyF/nkkFvM7fDV5Ir1FKuR+biYo81+yI9z36wzJzy
         jH2b7uUSYFiQwgrxSq77T/GGugeBJjB03YXIH4tOf/lhiEW1M2rjuHsmE9QA9yUyzCIP
         5o+h00bEHO5+1ILSbxExqsnbv8HlTFJZnwfuOW9vG422xU3XpjGKA8uebqR6h6ysTGgL
         6dvfdF5qWz26EzBDfpaxavnTYl13oe4zKP7KFSGv/kH/Y7I2TrgF3SuzxKS/hUIbnIfR
         ITlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1CEqaQjMv77SiJCZ+Ml1JB/3M4/OfgLP7wUO6uiGBUs=;
        b=T7ZMnw65WO8+vKrv2XlcnlwOH9v5J049l+mNorO8f5BoFd7hfsPo1ZDQDxq9gS7Hi4
         x60TdE+wmzjbHxY3le6qbUdurm00zpbhG718sbXMz/N9AyuBxmrgU9jgvBItHyoE4EVR
         Rx4q3z1o68Bo/LtPXMwRXbKhCDBayEduaud71il/7GeuWvwNEDAYnFB8z12VijjyLmY/
         1eRX1L65S2OAxUB7vmQui1Zqrn7sJ6GhkkVi29AQz7yYGuSPaTIpmM704GY/MHz1BwAd
         0eYiVDKn7NVjXAxCp4I27Nd8nwWHWIJSuVZY+wPTsKoaZDOAms8D/LCYRizIlJnp8yQu
         OENQ==
X-Gm-Message-State: AOAM5323xd3v9hddGDpf5y0hEukWxY/1sCjeIjX0LvH7Nbl/x2OdPngX
        IvwEiItnOWANOMbz7oeGpRNMxwZS3LWlPQ==
X-Google-Smtp-Source: ABdhPJwgSnehTc5xNqyLCaar1RruRoIGZbX080UjPug3t5nj2z72U/3mB1I9KQxqePWsIqRhpk1atA==
X-Received: by 2002:a7b:c081:: with SMTP id r1mr425801wmh.158.1603904857092;
        Wed, 28 Oct 2020 10:07:37 -0700 (PDT)
Received: from nogikh.c.googlers.com.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id v6sm211757wrp.69.2020.10.28.10.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 10:07:36 -0700 (PDT)
From:   Aleksandr Nogikh <aleksandrnogikh@gmail.com>
To:     stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org
Cc:     andreyknvl@google.com, dvyukov@google.com, elver@google.com,
        rdunlap@infradead.org, dave.taht@gmail.com, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aleksandr Nogikh <nogikh@google.com>,
        syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com
Subject: [PATCH v2] netem: fix zero division in tabledist
Date:   Wed, 28 Oct 2020 17:07:31 +0000
Message-Id: <20201028170731.1383332-1-aleksandrnogikh@gmail.com>
X-Mailer: git-send-email 2.29.0.rc2.309.g374f81d7ae-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Nogikh <nogikh@google.com>

Currently it is possible to craft a special netlink RTM_NEWQDISC
command that can result in jitter being equal to 0x80000000. It is
enough to set the 32 bit jitter to 0x02000000 (it will later be
multiplied by 2^6) or just set the 64 bit jitter via
TCA_NETEM_JITTER64. This causes an overflow during the generation of
uniformly distributed numbers in tabledist(), which in turn leads to
division by zero (sigma != 0, but sigma * 2 is 0).

The related fragment of code needs 32-bit division - see commit
9b0ed89 ("netem: remove unnecessary 64 bit modulus"), so switching to
64 bit is not an option.

Fix the issue by keeping the value of jitter within the range that can
be adequately handled by tabledist() - [0;INT_MAX]. As negative std
deviation makes no sense, take the absolute value of the passed value
and cap it at INT_MAX. Inside tabledist(), switch to unsigned 32 bit
arithmetic in order to prevent overflows.

Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
Reported-by: syzbot+ec762a6342ad0d3c0d8f@syzkaller.appspotmail.com

---
v2:
* Capping the value when receiving it from the userspace instead of
  checking it each time when a new skb is enqueued.
v1:
http://lkml.kernel.org/r/20201016121007.2378114-1-a.nogikh@yandex.ru
---
 net/sched/sch_netem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 84f82771cdf5..0c345e43a09a 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -330,7 +330,7 @@ static s64 tabledist(s64 mu, s32 sigma,
 
 	/* default uniform distribution */
 	if (dist == NULL)
-		return ((rnd % (2 * sigma)) + mu) - sigma;
+		return ((rnd % (2 * (u32)sigma)) + mu) - sigma;
 
 	t = dist->table[rnd % dist->size];
 	x = (sigma % NETEM_DIST_SCALE) * t;
@@ -812,6 +812,10 @@ static void get_slot(struct netem_sched_data *q, const struct nlattr *attr)
 		q->slot_config.max_packets = INT_MAX;
 	if (q->slot_config.max_bytes == 0)
 		q->slot_config.max_bytes = INT_MAX;
+
+	/* capping dist_jitter to the range acceptable by tabledist() */
+	q->slot_config.dist_jitter = min_t(__s64, INT_MAX, abs(q->slot_config.dist_jitter));
+
 	q->slot.packets_left = q->slot_config.max_packets;
 	q->slot.bytes_left = q->slot_config.max_bytes;
 	if (q->slot_config.min_delay | q->slot_config.max_delay |
@@ -1037,6 +1041,9 @@ static int netem_change(struct Qdisc *sch, struct nlattr *opt,
 	if (tb[TCA_NETEM_SLOT])
 		get_slot(q, tb[TCA_NETEM_SLOT]);
 
+	/* capping jitter to the range acceptable by tabledist() */
+	q->jitter = min_t(s64, abs(q->jitter), INT_MAX);
+
 	return ret;
 
 get_table_failure:

base-commit: 1c86f90a16d413621918ae1403842b43632f0b3d
-- 
2.29.0.rc2.309.g374f81d7ae-goog

