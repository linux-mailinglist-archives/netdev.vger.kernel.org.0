Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5912B652141
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 14:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiLTNIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 08:08:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbiLTNIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 08:08:34 -0500
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F208EE0E
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:08:33 -0800 (PST)
Received: by mail-qk1-x749.google.com with SMTP id bs13-20020a05620a470d00b007024c37f800so4398726qkb.10
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 05:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=saza6E2vz8eRndK+00UyLwXDZPg7d17YZq8TkmybwTc=;
        b=ijfTAyfijzGLDjOnQojgY2uximMTYnuAQ1MjvSATpyZyTiDfTyvymf4Cvfax/IFKtu
         RV8VZLLHr/7Xyu1PECNIrMi2CzMSG1aV9c9hQKqlgXfTicrwjKlFbn6GFxye3FVdHb5D
         QuII563Kewysbh+BdlpWBDZuqfnvsBB5pRw9eEzNGYaS6J0qmP3GmXzpqO56XPhXEsMo
         GCvednCxFGzpHg4lDiIgr9arpdSCZ916Js4Grm0YLCzYG/iMrD6ZAZLzpWM696CdduhH
         aBmfRmapGZKPWc50yBjeojMkZHi+M3nyJq4V7sEUXWCLJTpgQA5s8lwtK5liTynLqyBr
         iKfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=saza6E2vz8eRndK+00UyLwXDZPg7d17YZq8TkmybwTc=;
        b=vWPPW6shYNFq7uPXgEzzt3BpUf8YygBgxFVdfT1zOJo2sGg0v40xC2UwQ2CKv7htn6
         ibo8b5p4gdSEwj32t9NhwwA86WdvLKS2VSFpybpWLt1EHPl8JuMeen2xtuzZzYVYoKuh
         lknQ6zcqWS7jDr8wmLvBq3Q74eyjTf+wIFZYlMTVJvQPtYmpugxqmTVRz4P8LOFufz5j
         evTJxR9nlBpLrLZu5Jv6qOzJNMkKQ2e4a1+yPdcdJLgU53zjcDlAMt6fFjvD53EhHiBE
         3KkPdUtBvC7TDpc+9aPkwZdtSDXLtdNe5ZJxXRGvZTfUzFjLBf5dZSrY56OcZ07CjoI5
         J2pA==
X-Gm-Message-State: AFqh2kqDQRD/jRnC6m2LHyjvjgZ4APvCUW8EazEV2yhJTSOXdcmk/uFS
        3nMqHZJQxFyycXxOrB320qPc2NAsrgdKSQ==
X-Google-Smtp-Source: AMrXdXthXil2tDOw/5STxUYdzECibZBAsGoJFLXAFiO9dWG8k1d/bGbKA1JE+09J/Bx90VJYfLkB/yy57ZSVUQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:ac8:47c8:0:b0:3a9:68aa:a216 with SMTP id
 d8-20020ac847c8000000b003a968aaa216mr841820qtr.300.1671541712791; Tue, 20 Dec
 2022 05:08:32 -0800 (PST)
Date:   Tue, 20 Dec 2022 13:08:31 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220130831.1480888-1-edumazet@google.com>
Subject: [PATCH net] bonding: fix lockdep splat in bond_miimon_commit()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bond_miimon_commit() is run while RTNL is held, not RCU.

WARNING: suspicious RCU usage
6.1.0-syzkaller-09671-g89529367293c #0 Not tainted
-----------------------------
drivers/net/bonding/bond_main.c:2704 suspicious rcu_dereference_check() usage!

Fixes: e95cc44763a4 ("bonding: do failover when high prio link up")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: Jay Vosburgh <j.vosburgh@gmail.com>
Cc: Veaceslav Falico <vfalico@gmail.com>
Cc: Andy Gospodarek <andy@greyhouse.net>
---
 drivers/net/bonding/bond_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b4c65783960a5aa14de5d64aeea190f02a04be44..0363ce597661422b82a7d33ef001151b275f9ada 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -2654,10 +2654,12 @@ static void bond_miimon_link_change(struct bonding *bond,
 
 static void bond_miimon_commit(struct bonding *bond)
 {
-	struct slave *slave, *primary;
+	struct slave *slave, *primary, *active;
 	bool do_failover = false;
 	struct list_head *iter;
 
+	ASSERT_RTNL();
+
 	bond_for_each_slave(bond, slave, iter) {
 		switch (slave->link_new_state) {
 		case BOND_LINK_NOCHANGE:
@@ -2700,8 +2702,8 @@ static void bond_miimon_commit(struct bonding *bond)
 
 			bond_miimon_link_change(bond, slave, BOND_LINK_UP);
 
-			if (!rcu_access_pointer(bond->curr_active_slave) || slave == primary ||
-			    slave->prio > rcu_dereference(bond->curr_active_slave)->prio)
+			active = rtnl_dereference(bond->curr_active_slave);
+			if (!active || slave == primary || slave->prio > active->prio)
 				do_failover = true;
 
 			continue;
-- 
2.39.0.314.g84b9a713c41-goog

