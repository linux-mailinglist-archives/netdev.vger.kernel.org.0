Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D439A48500
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 16:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727948AbfFQOON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 10:14:13 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44730 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfFQOOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 10:14:12 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hcsOe-0005vF-9s; Mon, 17 Jun 2019 16:14:09 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     tariqt@mellanox.com, ranro@mellanox.com, maorg@mellanox.com,
        edumazet@google.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH net-next 1/2] net: ipv4: remove erroneous advancement of list pointer
Date:   Mon, 17 Jun 2019 16:02:27 +0200
Message-Id: <20190617140228.12523-2-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617140228.12523-1-fw@strlen.de>
References: <20190617140228.12523-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Causes crash when lifetime expires on an adress as garbage is
dereferenced soon after.

This used to look like this:

 for (ifap = &ifa->ifa_dev->ifa_list;
      *ifap != NULL; ifap = &(*ifap)->ifa_next) {
          if (*ifap == ifa) ...

but this was changed to:

struct in_ifaddr *tmp;

ifap = &ifa->ifa_dev->ifa_list;
tmp = rtnl_dereference(*ifap);
while (tmp) {
   tmp = rtnl_dereference(tmp->ifa_next); // Bogus
   if (rtnl_dereference(*ifap) == ifa) {
     ...
   ifap = &tmp->ifa_next;		// Can be NULL
   tmp = rtnl_dereference(*ifap);	// Dereference
   }
}

Remove the bogus assigment/list entry skip.

Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/devinet.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 925dffa915cb..914ccc7f192a 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -745,8 +745,7 @@ static void check_lifetime(struct work_struct *work)
 				ifap = &ifa->ifa_dev->ifa_list;
 				tmp = rtnl_dereference(*ifap);
 				while (tmp) {
-					tmp = rtnl_dereference(tmp->ifa_next);
-					if (rtnl_dereference(*ifap) == ifa) {
+					if (tmp == ifa) {
 						inet_del_ifa(ifa->ifa_dev,
 							     ifap, 1);
 						break;
-- 
2.21.0

