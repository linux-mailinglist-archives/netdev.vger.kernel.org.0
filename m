Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998BAECBEF
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 00:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfKAX2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 19:28:49 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34649 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726023AbfKAX2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 19:28:49 -0400
Received: by mail-lf1-f68.google.com with SMTP id f5so8347282lfp.1
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 16:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+M1K01EEp04eNFe1/UKBDW3ZMjQPHzjlhyOmR/QFjcs=;
        b=aFEY4zmpK64LpsuQxvdQEnFnTIeGCwrg3i2xNAwXEL2GVHLzO6dfGjoI8LFTB4x6jN
         kwTCNk0RMOhjlR/vV9kB96xiZcg7bdoN8hXcWciHgZT7BWgukZcWmnjyqCpB1rWgQpGQ
         cKcY9faYSHJEBmhlmu+HGRVKIabtDyx7R+XzG+7eQSB7XgOot37CYno7FVfwU04t3AXy
         llXGksOdEhsrExQMmPnxw0qYO5hmWCxyboZYISvzWsMWn7tkagKu7HvmvebsD7TpGBot
         Dvdh65Q4K4WitAOdFUTXgXT/HXZZmGoAsfnqEdRvxpkxK1KRAq6nj4QdU9F3S1vfyRIg
         +slw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+M1K01EEp04eNFe1/UKBDW3ZMjQPHzjlhyOmR/QFjcs=;
        b=gysm9nA6ZTLwk+O8KEipnjV/ML8Z9gfDPNv1s4GHVkOvE27HAo+rqT6mUSBbzteyhP
         5abktruUCExmaFOMoFsTan74MBqfaML5EEAXISNr6w1oFCM4iWFW44DogY4JP9h6ndDX
         uIT3fj3+Wy33aD8MazSXoUhsHZv4lmkNpDuG+PYci6RuimVzYg2dn+QXDNjOTGXxCb7e
         iGW5pHZz9gvNxfawqTxeNDIZlCiC6vAbrOzfbRLDN2olybpGbWQVLhMy/Qj9mNHELCfR
         L7jH2uhAt73m7SCcSSRm7Uil1SvrXxCarQCYEPxXTKXaBffdAnDoV4e/XmWtHUvKsqb0
         8smA==
X-Gm-Message-State: APjAAAUZqtpBszaw9t5JZ+1mcoL/uBU1YO2JpDq13C1Ei8b9x1ru6yRr
        /K61wMVWjCjcxqAB47HM98Wxxw==
X-Google-Smtp-Source: APXvYqwRE1U/ONxOU6MEnVoZ8KUkGgJnYB6PDtOKwHQwugNUTXzuG0oTlf6M9xZpUUCBeJhoXlCXlQ==
X-Received: by 2002:a19:7d85:: with SMTP id y127mr8527754lfc.160.1572650926729;
        Fri, 01 Nov 2019 16:28:46 -0700 (PDT)
Received: from localhost.localdomain (88-201-94-178.pool.ukrtel.net. [178.94.201.88])
        by smtp.gmail.com with ESMTPSA id l21sm3355673lje.0.2019.11.01.16.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 16:28:46 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     davem@davemloft.net, vinicius.gomes@intel.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH net] taprio: fix panic while hw offload sched list swap
Date:   Sat,  2 Nov 2019 01:28:28 +0200
Message-Id: <20191101232828.17023-1-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't swap oper and admin schedules too early, it's not correct and
causes crash.

Steps to reproduce:

1)
tc qdisc replace dev eth0 parent root handle 100 taprio \
    num_tc 3 \
    map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
    queues 1@0 1@1 1@2 \
    base-time $SOME_BASE_TIME \
    sched-entry S 01 80000 \
    sched-entry S 02 15000 \
    sched-entry S 04 40000 \
    flags 2

2)
tc qdisc replace dev eth0 parent root handle 100 taprio \
    base-time $SOME_BASE_TIME \
    sched-entry S 01 90000 \
    sched-entry S 02 20000 \
    sched-entry S 04 40000 \
    flags 2

3)
tc qdisc replace dev eth0 parent root handle 100 taprio \
    base-time $SOME_BASE_TIME \
    sched-entry S 01 150000 \
    sched-entry S 02 200000 \
    sched-entry S 04 40000 \
    flags 2

Do 2 3 2 .. steps  more times if not happens and observe:

[  305.832319] Unable to handle kernel write to read-only memory at
virtual address ffff0000087ce7f0
[  305.910887] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
[  305.919306] Hardware name: Texas Instruments AM654 Base Board (DT)

[...]

[  306.017119] x1 : ffff800848031d88 x0 : ffff800848031d80
[  306.022422] Call trace:
[  306.024866]  taprio_free_sched_cb+0x4c/0x98
[  306.029040]  rcu_process_callbacks+0x25c/0x410
[  306.033476]  __do_softirq+0x10c/0x208
[  306.037132]  irq_exit+0xb8/0xc8
[  306.040267]  __handle_domain_irq+0x64/0xb8
[  306.044352]  gic_handle_irq+0x7c/0x178
[  306.048092]  el1_irq+0xb0/0x128
[  306.051227]  arch_cpu_idle+0x10/0x18
[  306.054795]  do_idle+0x120/0x138
[  306.058015]  cpu_startup_entry+0x20/0x28
[  306.061931]  rest_init+0xcc/0xd8
[  306.065154]  start_kernel+0x3bc/0x3e4
[  306.068810] Code: f2fbd5b7 f2fbd5b6 d503201f f9400422 (f9000662)
[  306.074900] ---[ end trace 96c8e2284a9d9d6e ]---
[  306.079507] Kernel panic - not syncing: Fatal exception in interrupt
[  306.085847] SMP: stopping secondary CPUs
[  306.089765] Kernel Offset: disabled

Try to explain one of the possible crash cases:

The "real" admin list is assigned when admin_sched is set to
new_admin, it happens after "swap", that assigns to oper_sched NULL.
Thus if call qdisc show it can crash.

Farther, next second time, when sched list is updated, the admin_sched
is not NULL and becomes the oper_sched, previous oper_sched was NULL so
just skipped. But then admin_sched is assigned new_admin, but schedules
to free previous assigned admin_sched (that already became oper_sched).

Farther, next third time, when sched list is updated,
while one more swap, oper_sched is not null, but it was happy to be
freed already (while prev. admin update), so while try to free
oper_sched the kernel panic happens at taprio_free_sched_cb().

So, move the "swap emulation" where it should be according to function
comment from code.

Fixes: 9c66d15646760e ("taprio: Add support for hardware offloading")
Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---

Based on net/master

 net/sched/sch_taprio.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6719a65169d4..286ad4bb50f1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -1224,8 +1224,6 @@ static int taprio_enable_offload(struct net_device *dev,
 		goto done;
 	}
 
-	taprio_offload_config_changed(q);
-
 done:
 	taprio_offload_free(offload);
 
@@ -1505,6 +1503,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
 			call_rcu(&admin->rcu, taprio_free_sched_cb);
 
 		spin_unlock_irqrestore(&q->current_entry_lock, flags);
+
+		if (FULL_OFFLOAD_IS_ENABLED(taprio_flags))
+			taprio_offload_config_changed(q);
 	}
 
 	new_admin = NULL;
-- 
2.20.1

