Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333AAEF3D6
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 04:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387408AbfKEDNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 22:13:30 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:39674 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729543AbfKEDNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 22:13:30 -0500
Received: by mail-pf1-f201.google.com with SMTP id l20so15098774pff.6
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 19:13:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=yrpyTojFfstzQK5zPgu8ozwvDS6pnfGr3S5RJ0qmUJQ=;
        b=i+6RuR+gC8mmsKnDfKGcNougeeRUdLe7ohmbS/xw9cYUdiUvVa9BcyUYYXdg9QpMgM
         fpowTRs6vREQ7oNDu2YZY2Us7/M1/5pU+WXB6gVvDf1HWbIYMerna7SfXy082jJAkjL6
         oMFvbHKKiFm4Q3bwQg43ZDg9AUhG7NUgWH+KV1P9fLWNFvIOHY/Qp94pJCblEm79nMoj
         jYrm4+bruuSNsEl9Ne1PT3UIP6n1bTU0+w1I06Y1L3arLy8vZu7LeZDwsDenIrOE/QJU
         a9qMUFBQu6TsCSQEy0r9E0Exd3sD7cDEPV/vQ6bqwZ/NGk9kop0lueWw+8UdFQMCmmDN
         /W0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=yrpyTojFfstzQK5zPgu8ozwvDS6pnfGr3S5RJ0qmUJQ=;
        b=URUBU3+/ZhNwfV0WPIl/m62TjmR9aS2KU0rlY72b2T8E2KvAqV9zEEcub/tln4+SpP
         nxrgPAhhhnnruc0BE5/NatYVkKbOeiW7saokDIcssXKdddHRYCq9wmz1Ln40HSlQYLH0
         T8JGW2EcO+b9YM9IYNihf1nMGqhFkHuBS84dMbHtj1h9GUp2+DEOfqOP0vCPG1e/10gz
         pAojBnObSnDLKHchNAM1ayoCmbHSWNkVS+jl7kbJXUE2H+ot+sg+lvAfvrehtqjWBi+v
         MBxkZTgVsu4AT25DpLBug+h8nE946emJO4Iy2s51Zph4jlTftbWLzYQiBap3gHCe06hV
         jAMg==
X-Gm-Message-State: APjAAAVJ5asU4/qIldryy6GQOIjA0j61JCDdBHFFQKt4NiFq0LZryrNS
        r0WmOaij/Dj8q16pm0KIDpMRNqeMTodX1g==
X-Google-Smtp-Source: APXvYqwT91T2hovNa+YQU5Cogz4+ScirFnPmdf3HVyu2BECaQws6ICWYQQmigc1iM1EIaherVcaIVvPlfWcQJA==
X-Received: by 2002:a63:1743:: with SMTP id 3mr35120020pgx.161.1572923608746;
 Mon, 04 Nov 2019 19:13:28 -0800 (PST)
Date:   Mon,  4 Nov 2019 19:13:14 -0800
In-Reply-To: <20191105031315.90137-1-edumazet@google.com>
Message-Id: <20191105031315.90137-3-edumazet@google.com>
Mime-Version: 1.0
References: <20191105031315.90137-1-edumazet@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH net-next 2/3] net_sched: extend packet counter to 64bit
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

After this change, qdisc packet counter is no longer
a 32bit quantity. We still export 32bit values to user.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/gen_stats.h | 4 ++--
 net/core/gen_stats.c    | 3 +--
 net/sched/act_simple.c  | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/net/gen_stats.h b/include/net/gen_stats.h
index 5f3889e7ec1bb8b5148e9c552dd222b7f1c077d8..1424e02cef90c0139a175933577f1b8537bce51a 100644
--- a/include/net/gen_stats.h
+++ b/include/net/gen_stats.h
@@ -10,8 +10,8 @@
 /* Note: this used to be in include/uapi/linux/gen_stats.h */
 struct gnet_stats_basic_packed {
 	__u64	bytes;
-	__u32	packets;
-} __attribute__ ((packed));
+	__u64	packets;
+};
 
 struct gnet_stats_basic_cpu {
 	struct gnet_stats_basic_packed bstats;
diff --git a/net/core/gen_stats.c b/net/core/gen_stats.c
index 36888f5e09eb9292eac289d80ced264d73040c50..fe33e2a9841e698dc1a0ac086086fa9832c0b514 100644
--- a/net/core/gen_stats.c
+++ b/net/core/gen_stats.c
@@ -123,8 +123,7 @@ __gnet_stats_copy_basic_cpu(struct gnet_stats_basic_packed *bstats,
 	for_each_possible_cpu(i) {
 		struct gnet_stats_basic_cpu *bcpu = per_cpu_ptr(cpu, i);
 		unsigned int start;
-		u64 bytes;
-		u32 packets;
+		u64 bytes, packets;
 
 		do {
 			start = u64_stats_fetch_begin_irq(&bcpu->syncp);
diff --git a/net/sched/act_simple.c b/net/sched/act_simple.c
index 97639b259cd7d1995727385bf8c69a4ee4737fca..9813ca4006dd1de145a1ccdde5eb0a4217cf487e 100644
--- a/net/sched/act_simple.c
+++ b/net/sched/act_simple.c
@@ -35,7 +35,7 @@ static int tcf_simp_act(struct sk_buff *skb, const struct tc_action *a,
 	 * Example if this was the 3rd packet and the string was "hello"
 	 * then it would look like "hello_3" (without quotes)
 	 */
-	pr_info("simple: %s_%d\n",
+	pr_info("simple: %s_%llu\n",
 	       (char *)d->tcfd_defdata, d->tcf_bstats.packets);
 	spin_unlock(&d->tcf_lock);
 	return d->tcf_action;
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

