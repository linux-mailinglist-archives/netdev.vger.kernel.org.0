Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551F3255B44
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 15:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgH1NdV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 09:33:21 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:34534 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729416AbgH1Nb2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 09:31:28 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTPS id 7A2A144A9B5;
        Fri, 28 Aug 2020 15:31:07 +0200 (CEST)
Received: from dichtel by bretzel.dev.6wind.com with local (Exim 4.92)
        (envelope-from <dichtel@bretzel.dev.6wind.com>)
        id 1kBeTD-0005x7-DC; Fri, 28 Aug 2020 15:31:07 +0200
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        laforge@gnumonks.org, osmocom-net-gprs@lists.osmocom.org
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next 1/2] gtp: remove useless rcu_read_lock()
Date:   Fri, 28 Aug 2020 15:30:55 +0200
Message-Id: <20200828133056.22751-2-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200828133056.22751-1-nicolas.dichtel@6wind.com>
References: <20200828133056.22751-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The rtnl lock is taken just the line above, no need to take the rcu also.

Fixes: 1788b8569f5d ("gtp: fix use-after-free in gtp_encap_destroy()")
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 drivers/net/gtp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index c84a10569388..6f871ec31393 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1071,7 +1071,6 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	rtnl_lock();
-	rcu_read_lock();
 
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
 	if (!gtp) {
@@ -1100,7 +1099,6 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 	}
 
 out_unlock:
-	rcu_read_unlock();
 	rtnl_unlock();
 	return err;
 }
-- 
2.26.2

