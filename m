Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7148D1D5F74
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 09:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgEPHp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 03:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725934AbgEPHp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 03:45:26 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D65FC061A0C;
        Sat, 16 May 2020 00:45:26 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so2126222pgl.9;
        Sat, 16 May 2020 00:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QVZpMvi6NwiXQViyAfKl/G+QbYOlYNWFmXEZ+j2oOkw=;
        b=mP01c83aDSBG6fX2Tqtxc3xSgcasY22lcRN9/wM3nG4n0vYnFF9sGtt8ViCAzY+TTi
         RmyV0YsOVeDXxPa0jqBl1C5OdWO6UzdT1RTcfx7r4V68UD8k+UfUXOFtR7kwmvfh1Qmh
         IH8aCJzjQU+/oJdp5MMo4kbRLOzmAUs/UjlIFPo1OD4ewCuIjv8Ze2pzKOgLAIEOOTWh
         dqEreBtyNkjGBHx4yIqdKgwKyGR3CjjhOpmrudkLUZYLuRIIDGB63fMyOQp2sqfIdmQG
         Gr+UGhDvSNU2pMhKFvbpfN5ThKxeNJXVC388UeSXC0HPummmGmVZeuHpF9jBzMNx85TO
         ppTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QVZpMvi6NwiXQViyAfKl/G+QbYOlYNWFmXEZ+j2oOkw=;
        b=Qu+TjgBqXqMdLNs0igjo0c29d6QuDF1cIkgbTqYGqdfSfNi7YbRHW9b41ydJYV/y/i
         bQty/YaX4TQvi8lAHsginrUV6n64jxQLZolZWjWtCq1oBIbYa3vQZWgXizsW86Q2FUdc
         J3zgyWNHhfJguGNR65oeh0SLyUj5Zpxmvc6jX5Giii5mWoMcUZtruXDX1POmrjJOTHKn
         X/8pU3mkKdLDw2PlwC83Pvh/9bfOD6nMuseWRVQ97clkigFWar2Z5nnxEY9b9nOp6UG2
         0aP4thHXhTpj0AfUgFIwXQEsMNs5HsMKWGIwek+5/uJsODkZsTvqPvw2hc5PBwXrTBp1
         dGkA==
X-Gm-Message-State: AOAM532FkVdDzoYvaEVvGxnUqKozP5EYEnEqZ2Na/G6EHGV1Weo2wE7d
        hEH8DhrYEAhTMP6fFJwmuw==
X-Google-Smtp-Source: ABdhPJzGf98P2GYAj4or19dQafaRzvKhEyaYKg7bVelbBsUaJ8BI7Vzom8AM2cUFiYSRdPA7rijXhw==
X-Received: by 2002:a65:518c:: with SMTP id h12mr4298392pgq.17.1589615125937;
        Sat, 16 May 2020 00:45:25 -0700 (PDT)
Received: from localhost.localdomain ([2402:3a80:13a5:a61b:b5d4:b438:1bc1:57f3])
        by smtp.gmail.com with ESMTPSA id l4sm3335677pgo.92.2020.05.16.00.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2020 00:45:24 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, kaber@trash.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        frextrite@gmail.com, joel@joelfernandes.org, paulmck@kernel.org,
        cai@lca.pw, linux-kernel-mentees@lists.linuxfoundation.org,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH net v2] ipv6: Fix suspicious RCU usage warning in ip6mr
Date:   Sat, 16 May 2020 13:15:15 +0530
Message-Id: <20200516074515.13745-1-madhuparnabhowmik10@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

This patch fixes the following warning:

=============================
WARNING: suspicious RCU usage
5.7.0-rc4-next-20200507-syzkaller #0 Not tainted
-----------------------------
net/ipv6/ip6mr.c:124 RCU-list traversed in non-reader section!!

ipmr_new_table() returns an existing table, but there is no table at
init. Therefore the condition: either holding rtnl or the list is empty
is used.

Fixes: d1db275dd3f6e ("ipv6: ip6mr: support multiple tables")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
v2:
- Add correct fixes tag
- Fix line over 80 chars

 net/ipv6/ip6mr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 65a54d74acc1..1e223e26f079 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -98,7 +98,8 @@ static void ipmr_expire_process(struct timer_list *t);
 #ifdef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
 #define ip6mr_for_each_table(mrt, net) \
 	list_for_each_entry_rcu(mrt, &net->ipv6.mr6_tables, list, \
-				lockdep_rtnl_is_held())
+				lockdep_rtnl_is_held() || \
+				list_empty(&net->ipv6.mr6_tables))
 
 static struct mr_table *ip6mr_mr_table_iter(struct net *net,
 					    struct mr_table *mrt)
-- 
2.17.1

