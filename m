Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C66261D0700
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 08:16:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729418AbgEMGQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 02:16:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729339AbgEMGQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 02:16:33 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C662CC061A0C;
        Tue, 12 May 2020 23:16:33 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so6418368plt.5;
        Tue, 12 May 2020 23:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4P7Jmu1wB5Ll0AGHsZRpAyAy8TKotTUse5s5Zg+TmsY=;
        b=ntcO3ZNRqNCj3v306aTURqjC4SXZM/QXdc2XY2xkEZc8bGy2d48bEYCC4VJU2IuPam
         4vLUgbLQogoqUNP3I8cKjsePXH5zCLgDqN4pEYZSDBCAAID03QYsNadYKCYvY/wZFCaL
         wb5TKHO5oJr8DPTkj/4J4UvzVw2J0GF2PUMb2jtON5b4KNl8p1P0vEAo5V+eUC/fqrJ8
         kFLF9qhBOqGEHDx6ZS5mOVHGnfWGYeLUltI7BJ02RGJ7FCBM8J953IhuWjHRadAY1c4x
         1p0L0thKV+Vz12jMAj5ZzlvIaYZZeR5vQs3E5eQZyMZtxF1cPV2meoMo5Wumhlze0pO/
         Mmhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4P7Jmu1wB5Ll0AGHsZRpAyAy8TKotTUse5s5Zg+TmsY=;
        b=FUAUbQTITr1ZurJJg5NIrunl95SCDl1kEQioootALAQZGmO3IqyrIqtxMvsJhMQv9i
         D4buwi4jCP1ZtEYxR+Uu/dh7Q2qquCml1PpHtvIbQ24SNWaAzRGCW/0ysHpyeKOd7tgG
         uHaFmG7QFunt9EzrVQVgJw4Y9weTRI25SqTiBEXlwTsELzfjaIupIdTpfN0f+09wPkte
         SgM80Tw1X1XUXGoupaPDrzAeKRcfB25WjUnErncih4Bz3BmheqtM47WZ6864TbF1Gfof
         K+Mf27XLcKtm8yZS3GZ9GY5D0Yqv8bY3Tw0jrQjMxAjeF9zjitwVQTEaQ8xJMyOmWiVU
         Bh/A==
X-Gm-Message-State: AGi0Puas3xmQUT/iUtfep0z+35jm96YxWa1TuE0URparRlITqBh3Sh36
        W3lv9R5bmuEOQFsT0uP8dg==
X-Google-Smtp-Source: APiQypIVAe3Y2IFLqVPDfvqPdcx84q6cDZvd4VEecsP+LhfY0VOyh1Zpz2J7wC8zOHvT+2TS1TSRrg==
X-Received: by 2002:a17:902:ee15:: with SMTP id z21mr22649386plb.71.1589350593171;
        Tue, 12 May 2020 23:16:33 -0700 (PDT)
Received: from localhost.localdomain ([2409:4071:5b5:d53:89fb:f860:f992:54ab])
        by smtp.gmail.com with ESMTPSA id b8sm13262212pft.11.2020.05.12.23.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2020 23:16:32 -0700 (PDT)
From:   madhuparnabhowmik10@gmail.com
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, frextrite@gmail.com, joel@joelfernandes.org,
        paulmck@kernel.org, cai@lca.pw,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
Subject: [PATCH] Fix suspicious RCU usage warning
Date:   Wed, 13 May 2020 11:46:10 +0530
Message-Id: <20200513061610.22313-1-madhuparnabhowmik10@gmail.com>
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

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>
---
 net/ipv6/ip6mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 65a54d74acc1..fbe282bb8036 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -98,7 +98,7 @@ static void ipmr_expire_process(struct timer_list *t);
 #ifdef CONFIG_IPV6_MROUTE_MULTIPLE_TABLES
 #define ip6mr_for_each_table(mrt, net) \
 	list_for_each_entry_rcu(mrt, &net->ipv6.mr6_tables, list, \
-				lockdep_rtnl_is_held())
+				lockdep_rtnl_is_held() ||  list_empty(&net->ipv6.mr6_tables))
 
 static struct mr_table *ip6mr_mr_table_iter(struct net *net,
 					    struct mr_table *mrt)
-- 
2.17.1

