Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94ED11AF8D1
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 10:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725950AbgDSIoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 04:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725910AbgDSIoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 04:44:08 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E89BC061A0C;
        Sun, 19 Apr 2020 01:44:06 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o185so2964605pgo.3;
        Sun, 19 Apr 2020 01:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=HDuwLvARoJkJSZwVdQdf+z8zoIZqWqA2KSZFSJiI1jU=;
        b=comv+33cklPlMXpi4bCNur7Oo3aADIMts7dmwACmm3ub+sdNLPXwxZDyNAhfSitd/F
         bKAhwHPvtlZegevxRat3R0koR84Ihtz6tYRBbvA+Sg62uKlmIOK66q+20w0E7Oyr1lv8
         LdBkELb7B1nxAWDz+dCvXmy3CMLGXZj+lx+80Dx4w3VJBjt1ZH8prbw459J7LQnIxrM5
         E5ipyumMQjbAgWTPbLUkN/foJuGo7pOK2Hynz5aazW6SnVtMdmf3JY6Wc2NwSPiU5xfS
         2842X8uPrBGcJpK2rF+Gzj5I+ZwGUBgxlXOFwfSh1cuonSwdvHlzXDO2QPA2SKc+ZAy0
         tHbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=HDuwLvARoJkJSZwVdQdf+z8zoIZqWqA2KSZFSJiI1jU=;
        b=D5P6GJs2CQeYqa/QK1evzWq0AGU/WDGHrdil/43R/fr/PU/z47VW9IayZCnFFdBK5a
         l9pORMbHdnsOtF/vLeb1odm8W2p5IXDI94cv5YyC6juN8pVm+vxpt+MruHsS9kvit/yW
         XHGQElWP5MxIuNPrq2Ohpjnm3vfNykt8SyRTvAcP5693BVDdGzETofNLp/nD1H8Oxh9+
         xmbcUxwb2+hJRyaH+3RwCj6SHFY5KApDy6URaeWDW5o/9hPwMqY3Ii2/vIx8cBo835YL
         OWEofo5RvAwK7jbAmy0TAhsE+/t2glUsFjPy8pIxnQe05Y3Eu4e4D4GESWlf32G4TG/W
         KzGQ==
X-Gm-Message-State: AGi0PuaeTaF5OTPqeWhzopGMEwCOFUKPw1u4jf0AAhsgUnpsxkVVeyoX
        qCFO2Ue1hT8hb0yF1ViQtC4=
X-Google-Smtp-Source: APiQypLTNkL0FlLdpu8plOA88EM9HEHBSDUeucwsX5RV0Meaau9rUDuMqf3YVXorjSpV58yyasilow==
X-Received: by 2002:a63:5d5c:: with SMTP id o28mr11522235pgm.322.1587285845663;
        Sun, 19 Apr 2020 01:44:05 -0700 (PDT)
Received: from local.opencloud.tech.localdomain ([219.143.130.26])
        by smtp.gmail.com with ESMTPSA id t5sm6846533pjo.19.2020.04.19.01.44.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Apr 2020 01:44:05 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com
Cc:     davem@davemloft.net, dev@openvswitch.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pshelar@ovn.org, syzkaller-bugs@googlegroups.com,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH] net: openvswitch: ovs_ct_exit to be done under ovs_lock
Date:   Fri, 17 Apr 2020 02:57:31 +0800
Message-Id: <1587063451-54027-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <000000000000e642a905a0cbee6e@google.com>
References: <000000000000e642a905a0cbee6e@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

syzbot wrote:
| =============================
| WARNING: suspicious RCU usage
| 5.7.0-rc1+ #45 Not tainted
| -----------------------------
| net/openvswitch/conntrack.c:1898 RCU-list traversed in non-reader section!!
|
| other info that might help us debug this:
| rcu_scheduler_active = 2, debug_locks = 1
| ...
|
| stack backtrace:
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.0-0-ga698c8995f-prebuilt.qemu.org 04/01/2014
| Workqueue: netns cleanup_net
| Call Trace:
| ...
| ovs_ct_exit
| ovs_exit_net
| ops_exit_list.isra.7
| cleanup_net
| process_one_work
| worker_thread

To avoid that warning, invoke the ovs_ct_exit under ovs_lock and add
lockdep_ovsl_is_held as optional lockdep expression.

Link: https://lore.kernel.org/lkml/000000000000e642a905a0cbee6e@google.com
Fixes: 11efd5cb04a1 ("openvswitch: Support conntrack zone limit")
Cc: Pravin B Shelar <pshelar@ovn.org> 
Cc: Yi-Hung Wei <yihung.wei@gmail.com>
Reported-by: syzbot+7ef50afd3a211f879112@syzkaller.appspotmail.com
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 net/openvswitch/conntrack.c | 3 ++-
 net/openvswitch/datapath.c  | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index e726159cfcfa..4340f25fe390 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1895,7 +1895,8 @@ static void ovs_ct_limit_exit(struct net *net, struct ovs_net *ovs_net)
 		struct hlist_head *head = &info->limits[i];
 		struct ovs_ct_limit *ct_limit;
 
-		hlist_for_each_entry_rcu(ct_limit, head, hlist_node)
+		hlist_for_each_entry_rcu(ct_limit, head, hlist_node,
+					 lockdep_ovsl_is_held())
 			kfree_rcu(ct_limit, rcu);
 	}
 	kfree(ovs_net->ct_limit_info->limits);
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index d8ae541d22a8..94b024534987 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -2466,8 +2466,10 @@ static void __net_exit ovs_exit_net(struct net *dnet)
 	struct net *net;
 	LIST_HEAD(head);
 
-	ovs_ct_exit(dnet);
 	ovs_lock();
+
+	ovs_ct_exit(dnet);
+
 	list_for_each_entry_safe(dp, dp_next, &ovs_net->dps, list_node)
 		__dp_destroy(dp);
 
-- 
2.23.0

