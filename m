Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14885820C
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 14:03:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbfF0MDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 08:03:41 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47460 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726754AbfF0MDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 08:03:40 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hgT7q-0002lG-M5; Thu, 27 Jun 2019 14:03:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     ranro@mellanox.com, tariqt@mellanox.com,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/2] net: ipv4: fix infinite loop on secondary addr promotion
Date:   Thu, 27 Jun 2019 14:03:32 +0200
Message-Id: <20190627120333.12469-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190627120333.12469-1-fw@strlen.de>
References: <20190627120333.12469-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

secondary address promotion causes infinite loop -- it arranges
for ifa->ifa_next to point back to itself.

Problem is that 'prev_prom' and 'last_prim' might point at the same entry,
so 'last_sec' pointer must be obtained after prev_prom->next update.

Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")
Reported-by: Ran Rozenstein <ranro@mellanox.com>
Reported-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/devinet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 7874303220c5..137d1892395d 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -428,8 +428,9 @@ static void __inet_del_ifa(struct in_device *in_dev,
 		if (prev_prom) {
 			struct in_ifaddr *last_sec;
 
-			last_sec = rtnl_dereference(last_prim->ifa_next);
 			rcu_assign_pointer(prev_prom->ifa_next, next_sec);
+
+			last_sec = rtnl_dereference(last_prim->ifa_next);
 			rcu_assign_pointer(promote->ifa_next, last_sec);
 			rcu_assign_pointer(last_prim->ifa_next, promote);
 		}
-- 
2.21.0

