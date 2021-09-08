Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEA040332C
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 06:13:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhIHEOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 00:14:33 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:55194 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhIHEOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 00:14:32 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 83EFB20165; Wed,  8 Sep 2021 12:13:22 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, lkp@lists.01.org, lkp@intel.com,
        Jakub Kicinski <kuba@kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH net] mctp: perform route destruction under RCU read lock
Date:   Wed,  8 Sep 2021 12:13:10 +0800
Message-Id: <20210908041310.4014458-1-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210908030319.GA839@xsang-OptiPlex-9020>
References: <20210908030319.GA839@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The kernel test robot reports:

  [  843.509974][  T345] =============================
  [  843.524220][  T345] WARNING: suspicious RCU usage
  [  843.538791][  T345] 5.14.0-rc2-00606-g889b7da23abf #1 Not tainted
  [  843.553617][  T345] -----------------------------
  [  843.567412][  T345] net/mctp/route.c:310 RCU-list traversed in non-reader section!!

- we're missing the rcu read lock acquire around the destruction path.

This change adds the acquire/release - the path is already atomic, and
we're using the _rcu list iterators.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
---
 net/mctp/route.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 5265525011ad..5ca186d53cb0 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -1083,8 +1083,10 @@ static void __net_exit mctp_routes_net_exit(struct net *net)
 {
 	struct mctp_route *rt;
 
+	rcu_read_lock();
 	list_for_each_entry_rcu(rt, &net->mctp.routes, list)
 		mctp_route_release(rt);
+	rcu_read_unlock();
 }
 
 static struct pernet_operations mctp_net_ops = {
-- 
2.30.2

