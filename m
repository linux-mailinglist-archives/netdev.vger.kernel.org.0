Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 465D3E210E
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 18:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfJWQxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 12:53:08 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:33326 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfJWQxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 12:53:08 -0400
Received: by mail-pf1-f202.google.com with SMTP id z4so16609733pfn.0
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 09:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=eBp4auiKb+3cCk/JzdXFU3SmL9EqQyMiPZjwVsN5SzA=;
        b=Q4lcfovFP00OUJzJqC80mD0hg4dQgpvI6sZj6lw3gRUs/6Na3JR2Kj8naQaX3m9591
         yaznHqb8xRr+A8ucKL3rJhxci3Z75tUEFe7ZrOV9ANMgmI3dJtTHS1iBQX1Jli/nhRq8
         AiFUG0SURW4perXIYNVuTCmaDuuTV5jdb6ez98kHFdHx5V/ZgYPkNCzR4YLu+f9sRu/+
         ylA4viKiNZAk7wzzdp4lMvpJdj+DUW4wHG+E8VUypFBXrZlRkaREtENPqPBkcG39Igjn
         WOracrKSL8MuHV0pKeNMPAXZGTdf23z8SKwJdPnslyyd4/Ah6NCvGy0mRUiWbRnd0PVk
         0KtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=eBp4auiKb+3cCk/JzdXFU3SmL9EqQyMiPZjwVsN5SzA=;
        b=BlKBv+3E/tjyiCvHxn8SM+ZSNaxX2RvPpQaRbq7xALfRUGLhZruDt8D3IsU5I9wR/D
         HRMxG6Xhqk1km5eWc+NZysaPwgUS0ZGmQQlt966LihjzdnzbAiGuh3+z/mDJX1ba3B5C
         LEP9gFVwFFiWo2pY96B41584pBZvOmErJIB9DX5SlMQAY72e2Zu7Z1Y7bLq5J1udS3+6
         mX6I192kxcm/vpN7BAUIdXqdLBLjYcysa0Z3EDAAilIFhGEiIY43VTfn2nvGhWekvH4S
         3oT1PC6PhhkOzj+kLqybGn1nVO51px8UvRUVFYTv59Mak3hiJaAZDFIXHCvcEoN7JqJc
         kljw==
X-Gm-Message-State: APjAAAWw/M6xF4RUjOgySnJLWQ7UGLQmBh7bv7YetLCOXvlXz2yDFonG
        fedCiwCLWLtDsDmOKF1e4Lm+NFG6UhuZxg==
X-Google-Smtp-Source: APXvYqzrfGZVGBU54DGw/yVc3ZKYGUBcS1cb2B+WIAtMOVSHAcqgRz81G2mk0n+OqiQxetoaPQHAEw4GPndGCA==
X-Received: by 2002:a63:fe56:: with SMTP id x22mr11325100pgj.282.1571849587006;
 Wed, 23 Oct 2019 09:53:07 -0700 (PDT)
Date:   Wed, 23 Oct 2019 09:53:03 -0700
Message-Id: <20191023165303.259361-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH net] ipvs: move old_secure_tcp into struct netns_ipvs
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot reported the following issue :

BUG: KCSAN: data-race in update_defense_level / update_defense_level

read to 0xffffffff861a6260 of 4 bytes by task 3006 on cpu 1:
 update_defense_level+0x621/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:177
 defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

write to 0xffffffff861a6260 of 4 bytes by task 7333 on cpu 0:
 update_defense_level+0xa62/0xb30 net/netfilter/ipvs/ip_vs_ctl.c:205
 defense_work_handler+0x3d/0xd0 net/netfilter/ipvs/ip_vs_ctl.c:225
 process_one_work+0x3d4/0x890 kernel/workqueue.c:2269
 worker_thread+0xa0/0x800 kernel/workqueue.c:2415
 kthread+0x1d4/0x200 drivers/block/aoe/aoecmd.c:1253
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:352

Reported by Kernel Concurrency Sanitizer on:
CPU: 0 PID: 7333 Comm: kworker/0:5 Not tainted 5.4.0-rc3+ #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: events defense_work_handler

Indeed, old_secure_tcp is currently a static variable, while it
needs to be a per netns variable.

Fixes: a0840e2e165a ("IPVS: netns, ip_vs_ctl local vars moved to ipvs struct.")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Wensong Zhang <wensong@linux-vs.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Julian Anastasov <ja@ssi.bg>
---
 include/net/ip_vs.h            |  1 +
 net/netfilter/ipvs/ip_vs_ctl.c | 15 +++++++--------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 3759167f91f5643ea5a192eb7e82ce3a34e9e91b..078887c8c586ad3fba436261462118ad9c47cc81 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -889,6 +889,7 @@ struct netns_ipvs {
 	struct delayed_work	defense_work;   /* Work handler */
 	int			drop_rate;
 	int			drop_counter;
+	int			old_secure_tcp;
 	atomic_t		dropentry;
 	/* locks in ctl.c */
 	spinlock_t		dropentry_lock;  /* drop entry handling */
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 8b48e7ce1c2c2243bbdc8c4e43e4e484f3e52df6..9d58d830ef3d83c01c50ac8e3f0a7e57f2f4bfb7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -93,7 +93,6 @@ static bool __ip_vs_addr_is_local_v6(struct net *net,
 static void update_defense_level(struct netns_ipvs *ipvs)
 {
 	struct sysinfo i;
-	static int old_secure_tcp = 0;
 	int availmem;
 	int nomem;
 	int to_change = -1;
@@ -174,35 +173,35 @@ static void update_defense_level(struct netns_ipvs *ipvs)
 	spin_lock(&ipvs->securetcp_lock);
 	switch (ipvs->sysctl_secure_tcp) {
 	case 0:
-		if (old_secure_tcp >= 2)
+		if (ipvs->old_secure_tcp >= 2)
 			to_change = 0;
 		break;
 	case 1:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change = 1;
 			ipvs->sysctl_secure_tcp = 2;
 		} else {
-			if (old_secure_tcp >= 2)
+			if (ipvs->old_secure_tcp >= 2)
 				to_change = 0;
 		}
 		break;
 	case 2:
 		if (nomem) {
-			if (old_secure_tcp < 2)
+			if (ipvs->old_secure_tcp < 2)
 				to_change = 1;
 		} else {
-			if (old_secure_tcp >= 2)
+			if (ipvs->old_secure_tcp >= 2)
 				to_change = 0;
 			ipvs->sysctl_secure_tcp = 1;
 		}
 		break;
 	case 3:
-		if (old_secure_tcp < 2)
+		if (ipvs->old_secure_tcp < 2)
 			to_change = 1;
 		break;
 	}
-	old_secure_tcp = ipvs->sysctl_secure_tcp;
+	ipvs->old_secure_tcp = ipvs->sysctl_secure_tcp;
 	if (to_change >= 0)
 		ip_vs_protocol_timeout_change(ipvs,
 					      ipvs->sysctl_secure_tcp > 1);
-- 
2.23.0.866.gb869b98d4c-goog

