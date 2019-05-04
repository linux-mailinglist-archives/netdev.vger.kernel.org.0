Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73E371398E
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 13:47:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfEDLrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 07:47:24 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41334 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727568AbfEDLrT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 07:47:19 -0400
Received: by mail-qk1-f194.google.com with SMTP id g190so1221082qkf.8
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 04:47:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5gNdIXsVKisfXF/oNRizV0leLtTJqI0y8EOYrPjhvxo=;
        b=wp3BRx3Nj/+dgRIVUK+GSnAYY9JemQC1IUFpnCQHinwIpHkBOCX4cQFsqYb1pYYSCN
         EZaG6ZcyQ84Wbc0yyhowR9VaVmyO0RmwL58XXxqSXfCny7YDtM4rZna0a1APoPOoFJPW
         KzlYDbHhRMT1//ldknMSvXSlPfMffke2Ituio58S5dhvyh5V1wg0LYsiYrpUjs/UTMvT
         qUpShOfT9qIr+AGWCzfdYgor918hfMFvvNs3AXcXzgqSw2NFWdaNAmwW6JPW5mSzeCtR
         yziI2g03a7NTQyX2MR9hUDUamWa+j9zg4ghftdAqeRvidix6YAmYYWDWlA+Hy4YKzfaZ
         oPjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5gNdIXsVKisfXF/oNRizV0leLtTJqI0y8EOYrPjhvxo=;
        b=kYudQXY71EXGeqi4kdBtsc2T7x9LzABAj2z7KS35/ECj4S//s88tkGHgqBuOlY8s5N
         3wR1Da+bc281GfgKyz1QpgLiF/cZva4mzWhDmKLX1+WyfuszdwfFCY7FHpJjQTgNRv6R
         IdkS4A0oeMbiKnvA1Z9ZHn87QDBH1jZ5Pz6PVWnXeRGpDkdCsTSj3GcgeA8MCeAf34GN
         MjIBZrrOUzg3zwOlNqQxsmWSVaPEwOMDrbf49BZUP90d//DwixmfevfW4FhWST+N4XA6
         LoNDFZNCs46Glfj3+zXnyB86bYPsz/b1A7twN2C1g0F8sZT7tXIwxaI/Hq5pRkDEfqcZ
         F4YA==
X-Gm-Message-State: APjAAAUzQuRwPP0OhW05A1Ib6dKGI2BEol9/g00yvMhCEoc7+L1JT4vS
        IctiSaYsFDA69IBmc8epQd248g==
X-Google-Smtp-Source: APXvYqxJhuxszlrubukH5EpIT4uc2CoP48tHlgBQ4p5+9Be0B9WrLRG5xOq4tavkuLVIXmAMS5wv9g==
X-Received: by 2002:a37:589:: with SMTP id 131mr11689258qkf.152.1556970438724;
        Sat, 04 May 2019 04:47:18 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g19sm2847276qkk.17.2019.05.04.04.47.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 04:47:18 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com,
        Pieter Jansen van Vuuren 
        <pieter.jansenvanvuuren@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 09/13] net/sched: allow stats updates from offloaded police actions
Date:   Sat,  4 May 2019 04:46:24 -0700
Message-Id: <20190504114628.14755-10-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>

Implement the stats_update callback for the police action that
will be used by drivers for hardware offload.

Signed-off-by: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
---
 net/sched/act_police.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index e33bcab75d1f..61731944742a 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -282,6 +282,20 @@ static void tcf_police_cleanup(struct tc_action *a)
 		kfree_rcu(p, rcu);
 }
 
+static void tcf_police_stats_update(struct tc_action *a,
+				    u64 bytes, u32 packets,
+				    u64 lastuse, bool hw)
+{
+	struct tcf_police *police = to_police(a);
+	struct tcf_t *tm = &police->tcf_tm;
+
+	_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats), bytes, packets);
+	if (hw)
+		_bstats_cpu_update(this_cpu_ptr(a->cpu_bstats_hw),
+				   bytes, packets);
+	tm->lastuse = max_t(u64, tm->lastuse, lastuse);
+}
+
 static int tcf_police_dump(struct sk_buff *skb, struct tc_action *a,
 			       int bind, int ref)
 {
@@ -345,6 +359,7 @@ static struct tc_action_ops act_police_ops = {
 	.kind		=	"police",
 	.id		=	TCA_ID_POLICE,
 	.owner		=	THIS_MODULE,
+	.stats_update	=	tcf_police_stats_update,
 	.act		=	tcf_police_act,
 	.dump		=	tcf_police_dump,
 	.init		=	tcf_police_init,
-- 
2.21.0

