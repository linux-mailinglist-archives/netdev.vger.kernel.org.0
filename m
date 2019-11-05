Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64043EF3D7
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 04:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387426AbfKEDNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 22:13:33 -0500
Received: from mail-pl1-f201.google.com ([209.85.214.201]:44787 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbfKEDNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 22:13:33 -0500
Received: by mail-pl1-f201.google.com with SMTP id h11so11957534plt.11
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 19:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oLOuZr1ITwEcsyf6wDQUoTJkdiUwh5sO1HmPpFCKNlM=;
        b=CwOGDFtji+LptR1uFgQmlO19rlLt6UX5LC7PT7kFb7W8Mhitup2T7thRoJ1ehA79bT
         CiqZ0Uyfd6ng4N/x7LVYB3SsZeJyrd79Sz5aPlXPqCPUSlwb6We/AaRAyq6dUhdaFrVV
         c/2DJ5BCTBqdEXPn1rzfev8wx3Cah1t+Xy1rtZ8aP0K/INwHyTRhSuNl85xFaCA7bJiX
         JoSawr7tiNnqFrGNm1ZrUYFzOjlMY0whZa/DY1tqXyGaYATLS96LDdkJpA3inCK/wmgj
         FuD9eF6J/88BYrbgpsaGG6IEPcgsGKhZemoaCulwzNB41uW2hrQRwd7+sMSScrBbylyB
         7LRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oLOuZr1ITwEcsyf6wDQUoTJkdiUwh5sO1HmPpFCKNlM=;
        b=Dysj9ftw5+2vk9N2DA69R2Bqw/bAV+HtPcCcMgu1fu1nVTQrZIgXMvgCy3MLiCLkZu
         lXTcEBDVFu5eDl+KoqXo1Viu7NZPuRt4u4CV3P5BoN1BjQ/3cKfFOfZZat6shVDrjnPC
         kiFgO9MYQP4uXEnEYKwAD/egw91ScdpiVrCsjsDHrusapVaq1WgTidu80hkow3MybZHZ
         qVMB9vSD9vi9F0++uQ3bABqBENS6PLJ7vs+rMWeHm0jQeY438y9topKkoyrmnDkIsHBp
         QHeSM87EzGpifJLCyPediles5cS+It8DfV9FpJJHuazYx2GQAvvMyZN5enr8Q4N7BV42
         QjaA==
X-Gm-Message-State: APjAAAWqnyo3Iq4qCrofTlYuLEpXzz/tx4e9RhNPoz3WDi8uRu1p2KQR
        LJUGMn60lNrqyX1qVm5lu3o3qJqoxbeCKQ==
X-Google-Smtp-Source: APXvYqzMkSlPb/JPloJot3w61D1Xc9p787t5yYzt9EKYdkPSjUPIIfH2R3PHO3llB9KMnTamDYUiyDOtNFNHVA==
X-Received: by 2002:a63:f48:: with SMTP id 8mr34184718pgp.329.1572923612141;
 Mon, 04 Nov 2019 19:13:32 -0800 (PST)
Date:   Mon,  4 Nov 2019 19:13:15 -0800
In-Reply-To: <20191105031315.90137-1-edumazet@google.com>
Message-Id: <20191105031315.90137-4-edumazet@google.com>
Mime-Version: 1.0
References: <20191105031315.90137-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 3/3] net_sched: add TCA_STATS_PKT64 attribute
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now the kernel uses 64bit packet counters in scheduler layer,
we want to export these counters to user space.

Instead risking breaking user space by adding fields
to struct gnet_stats_basic, add a new TCA_STATS_PKT64.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/uapi/linux/gen_stats.h | 1 +
 net/core/gen_stats.c           | 9 +++++++--
 net/sched/act_api.c            | 2 ++
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/gen_stats.h b/include/uapi/linux/gen_stats.h
index 4eaacdf452e3b34f8f813046b801bfc1e6bdd2d4..852f234f1fd634b5d4d5444fc8e2f2e45c4f0839 100644
--- a/include/uapi/linux/gen_stats.h
+++ b/include/uapi/linux/gen_stats.h
@@ -13,6 +13,7 @@ enum {
 	TCA_STATS_RATE_EST64,
 	TCA_STATS_PAD,
 	TCA_STATS_BASIC_HW,
+	TCA_STATS_PKT64,
 	__TCA_STATS_MAX,
 };
 #define TCA_STATS_MAX (__TCA_STATS_MAX - 1)
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index fe33e2a9841e698dc1a0ac086086fa9832c0b514..1d653fbfcf52a95f0c8acdeb1ce1b0b418177351 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -175,12 +175,17 @@ ___gnet_stats_copy_basic(const seqcount_t *running,
 
 	if (d->tail) {
 		struct gnet_stats_basic sb;
+		int res;
 
 		memset(&sb, 0, sizeof(sb));
 		sb.bytes = bstats.bytes;
 		sb.packets = bstats.packets;
-		return gnet_stats_copy(d, type, &sb, sizeof(sb),
-				       TCA_STATS_PAD);
+		res = gnet_stats_copy(d, type, &sb, sizeof(sb), TCA_STATS_PAD);
+		if (res < 0 || sb.packets == bstats.packets)
+			return res;
+		/* emit 64bit stats only if needed */
+		return gnet_stats_copy(d, TCA_STATS_PKT64, &bstats.packets,
+				       sizeof(bstats.packets), TCA_STATS_PAD);
 	}
 	return 0;
 }
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 6284c552e943d1ffa45d59a28eac2c37152e4875..bda1ba25c59e973709998b7e6279eee30589cbb8 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -188,6 +188,8 @@ static size_t tcf_action_shared_attrs_size(const struct tc_action *act)
 		+ nla_total_size(0) /* TCA_ACT_STATS nested */
 		/* TCA_STATS_BASIC */
 		+ nla_total_size_64bit(sizeof(struct gnet_stats_basic))
+		/* TCA_STATS_PKT64 */
+		+ nla_total_size_64bit(sizeof(u64))
 		/* TCA_STATS_QUEUE */
 		+ nla_total_size_64bit(sizeof(struct gnet_stats_queue))
 		+ nla_total_size(0) /* TCA_OPTIONS nested */
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

