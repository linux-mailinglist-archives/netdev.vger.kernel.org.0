Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8E722585F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 09:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbgGTHWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 03:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTHWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 03:22:52 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B360C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 00:22:52 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id w3so24043570wmi.4
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 00:22:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uaa56VYlto7LGl6KsuvxoQ2JUEPsf/KVQDkhD+6cdeE=;
        b=Xx7l0FdLGLpxXUayW8rsp998bLt0ErxCT9A7SUnaIDNMuEhK1ZnRvR1vCp03z+S4Yb
         cUkXeLPafoZXYVHia/+Vp8rS6RSoPbRj5JROR4T4p1OPv1GQ85qX6UJvkPY6350rRoVm
         jMnB1szSuddLaP70hVr9ZLrl9Ij5oyjfLGLIWo00Jo0Od1Io5X/nF/JvXRdw1u0BB32M
         dyzqmXFcIhnnRaNW5/a4qjJlMliaZeG6CyKQg3pQ0wtNspmq5z5PEsgX6kVaCHTWXjPa
         xWawqtkjqSkyPjiRf9DOibZJWUxHZlQ01Fc8Rvy6oK3nhP/NFl49eeD/1r5xSqPzHIZi
         Jdbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uaa56VYlto7LGl6KsuvxoQ2JUEPsf/KVQDkhD+6cdeE=;
        b=icjqan0FYkMGpt63QnvN6PfOPPb+qmZvPEOk5PFawlnLxdW2jkjvMlFgmBA9D55X7a
         EJgiI8pMblRgjzh4yg2e3wvAUXCGWktKmgURkzR589bN176DEtV55JJdaxuJAKI2psTQ
         DZjsCq20ZzW1v5KlGZcni8c1jmgxEUBzgbF4EVbaXMK8jqzd345TEWkeCaVLiN8MYG1s
         950hSnyeeRPiPvDa2ZBpmPveMT5eUR1y8+aF48lpmLcr2Vm0dMQVpKMVeqKifwxqnAlJ
         +zBItudTRoAOwa7kkrOLskIyr6XfEQNeUztUQ8sl2mkRk3BEQNc1VMUgUuZPikhctYLt
         hqIw==
X-Gm-Message-State: AOAM533n+rpj6mgvaPqlW4yyhzeT0ST4v5yYAByOTU8o5DTzXCfDJluD
        WbnntMhuVLq+yvynjCaTXx7kQ/h+PPM=
X-Google-Smtp-Source: ABdhPJwqvHCVKLchwOh7dTbmj/qGsmyB5VLNUIOzRNCjzbgttey+f+AFrdLL9ppdkgtEib2qJgtfWQ==
X-Received: by 2002:a05:600c:2253:: with SMTP id a19mr19308860wmm.136.1595229770393;
        Mon, 20 Jul 2020 00:22:50 -0700 (PDT)
Received: from localhost (ip-89-103-111-149.net.upcbroadband.cz. [89.103.111.149])
        by smtp.gmail.com with ESMTPSA id x1sm31440441wrp.10.2020.07.20.00.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 00:22:49 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, idosch@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next] sched: sch_api: add missing rcu read lock to silence the warning
Date:   Mon, 20 Jul 2020 09:22:48 +0200
Message-Id: <20200720072248.6184-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In case the qdisc_match_from_root function() is called from non-rcu path
with rtnl mutex held, a suspiciout rcu usage warning appears:

[  241.504354] =============================
[  241.504358] WARNING: suspicious RCU usage
[  241.504366] 5.8.0-rc4-custom-01521-g72a7c7d549c3 #32 Not tainted
[  241.504370] -----------------------------
[  241.504378] net/sched/sch_api.c:270 RCU-list traversed in non-reader section!!
[  241.504382]
               other info that might help us debug this:
[  241.504388]
               rcu_scheduler_active = 2, debug_locks = 1
[  241.504394] 1 lock held by tc/1391:
[  241.504398]  #0: ffffffff85a27850 (rtnl_mutex){+.+.}-{3:3}, at: rtnetlink_rcv_msg+0x49a/0xbd0
[  241.504431]
               stack backtrace:
[  241.504440] CPU: 0 PID: 1391 Comm: tc Not tainted 5.8.0-rc4-custom-01521-g72a7c7d549c3 #32
[  241.504446] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
[  241.504453] Call Trace:
[  241.504465]  dump_stack+0x100/0x184
[  241.504482]  lockdep_rcu_suspicious+0x153/0x15d
[  241.504499]  qdisc_match_from_root+0x293/0x350

Fix this by taking the rcu_lock for qdisc_hash iteration.

Reported-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 net/sched/sch_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 11ebba60da3b..c7cfd8dc6a77 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -267,10 +267,12 @@ static struct Qdisc *qdisc_match_from_root(struct Qdisc *root, u32 handle)
 	    root->handle == handle)
 		return root;
 
+	rcu_read_lock();
 	hash_for_each_possible_rcu(qdisc_dev(root)->qdisc_hash, q, hash, handle) {
 		if (q->handle == handle)
 			return q;
 	}
+	rcu_read_unlock();
 	return NULL;
 }
 
-- 
2.21.3

