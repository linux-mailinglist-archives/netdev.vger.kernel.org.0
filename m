Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754812259B0
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 10:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgGTIKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 04:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbgGTIKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 04:10:44 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4BF7C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 01:10:43 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id z15so16830228wrl.8
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 01:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NxASqmeHCXDsMNwFldVISspu9SIn586lTOWY9Womkpk=;
        b=T8uBIgal73z5qSf1DVsIqdDIeFKd+F+9eDTTaZEFKB82BvajGJZ7JvQgYuHN/WQPhJ
         e1QcdhsyCSnonw9T7pCEvzjx3h9kujs4sQN3TkHeQkii7xeGMCafzJvbsfUXuaUiS8Dk
         I1hfn00McDHpeC6d5pvJH9RGDHpRjxItBKjIMgAKxyLSGR2J1fmC9Z3kpnPfYOodTCh2
         xwXHC+QHcUVViTgwWMTX2WbcaL76LtwGobHk10+ryF1IlC0agXWDivbATB/idYt2HEaA
         JGabJoZva0cRssrjmbl7yGhgoJIjJSXlekwgCihR6qyM9gaxjg+bbzlFKP2F/CFMm1w9
         fx3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NxASqmeHCXDsMNwFldVISspu9SIn586lTOWY9Womkpk=;
        b=MqwDa01SQWLFXrSdcfo//SKBs16+2cW7N/qfwGl1zJ0lh8+hhy67IMs6khobl6LPx9
         FfIh0kEH7TO8C+ukEJk3RlVBALdEkN9mvMuW+/LgXBKY+Su+DjOns0tIC7+WJIRDO02V
         TYqfyGbm23tkuyCVtsGcukIT19UINaLuFFo9b4GbU6OF28HzMlHmtMXvxqp8KUxYFa6u
         kpPx+Ny2CNW1UPnnvKoR/p39taEgIMOk9iCAyNeQVZl3BzQsmT8tJnW5WyXzHrju+71E
         wCC4CKmp3Yp3ddq4JSGgguMyS+0tXvR2+aH2z8ob7pMacxxJ5+kaE1KzDGpeBDt0pdlZ
         IfAg==
X-Gm-Message-State: AOAM532dBp9YVqtlOF1U3wGbeOQsJLFqSaN4jy8hmJxC9P2Fqw1k4egb
        yqqplFfTMV64p2TH7pBp1j4rGDwZ95U=
X-Google-Smtp-Source: ABdhPJx0+WSjhVOO01ojlgM5He1FlK7giy5BzgScAN0gZyqvxB8j7WDRafOBE9zHlczrYmchSUEYmw==
X-Received: by 2002:adf:ce0e:: with SMTP id p14mr12596647wrn.156.1595232642331;
        Mon, 20 Jul 2020 01:10:42 -0700 (PDT)
Received: from localhost (ip-89-103-111-149.net.upcbroadband.cz. [89.103.111.149])
        by smtp.gmail.com with ESMTPSA id 133sm32418070wme.5.2020.07.20.01.10.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 01:10:41 -0700 (PDT)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, idosch@mellanox.com, mlxsw@mellanox.com
Subject: [patch net-next v2] sched: sch_api: add missing rcu read lock to silence the warning
Date:   Mon, 20 Jul 2020 10:10:41 +0200
Message-Id: <20200720081041.8711-1-jiri@resnulli.us>
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

Fix this by passing the rtnl held lockdep condition down to
hlist_for_each_entry_rcu()

Reported-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
v1->v2:
- reworked to use the lockdep condition passing suggested by Ido.
---
 include/linux/hashtable.h | 4 ++--
 net/sched/sch_api.c       | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/hashtable.h b/include/linux/hashtable.h
index 78b6ea5fa8ba..f6c666730b8c 100644
--- a/include/linux/hashtable.h
+++ b/include/linux/hashtable.h
@@ -173,9 +173,9 @@ static inline void hash_del_rcu(struct hlist_node *node)
  * @member: the name of the hlist_node within the struct
  * @key: the key of the objects to iterate over
  */
-#define hash_for_each_possible_rcu(name, obj, member, key)		\
+#define hash_for_each_possible_rcu(name, obj, member, key, cond...)	\
 	hlist_for_each_entry_rcu(obj, &name[hash_min(key, HASH_BITS(name))],\
-		member)
+		member, ## cond)
 
 /**
  * hash_for_each_possible_rcu_notrace - iterate over all possible objects hashing
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 11ebba60da3b..2a76a2f5ed88 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -267,7 +267,8 @@ static struct Qdisc *qdisc_match_from_root(struct Qdisc *root, u32 handle)
 	    root->handle == handle)
 		return root;
 
-	hash_for_each_possible_rcu(qdisc_dev(root)->qdisc_hash, q, hash, handle) {
+	hash_for_each_possible_rcu(qdisc_dev(root)->qdisc_hash, q, hash, handle,
+				   lockdep_rtnl_is_held()) {
 		if (q->handle == handle)
 			return q;
 	}
-- 
2.21.3

