Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38E8A209A34
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 09:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389973AbgFYHCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 03:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgFYHCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 03:02:30 -0400
X-Greylist: delayed 422 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 25 Jun 2020 00:02:29 PDT
Received: from mx2.mailbox.org (mx2a.mailbox.org [IPv6:2001:67c:2050:104:0:2:25:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FC9C061573;
        Thu, 25 Jun 2020 00:02:29 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mx2.mailbox.org (Postfix) with ESMTPS id 680DFA1748;
        Thu, 25 Jun 2020 08:55:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter03.heinlein-hosting.de (spamfilter03.heinlein-hosting.de [80.241.56.117]) (amavisd-new, port 10030)
        with ESMTP id RXc4sIHA9DJp; Thu, 25 Jun 2020 08:55:20 +0200 (CEST)
From:   Thomas Martitz <t.martitz@avm.de>
To:     netdev@vger.kernel.org
Cc:     Thomas Martitz <t.martitz@avm.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        stable@vger.kernel.org
Subject: [PATCH] net: bridge: enfore alignment for ethernet address
Date:   Thu, 25 Jun 2020 08:54:07 +0200
Message-Id: <20200625065407.1196147-1-t.martitz@avm.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 0
X-Rspamd-Score: -6.56 / 15.00 / 15.00
X-Rspamd-Queue-Id: 95D1617FE
X-Rspamd-UID: 1e8f0f
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The eth_addr member is passed to ether_addr functions that require
2-byte alignment, therefore the member must be properly aligned
to avoid unaligned accesses.

The problem is in place since the initial merge of multicast to unicast:
commit 6db6f0eae6052b70885562e1733896647ec1d807 bridge: multicast to unicast

Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Martitz <t.martitz@avm.de>
---
 net/bridge/br_private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 7501be4eeba0..22cb2f1993ef 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -217,8 +217,8 @@ struct net_bridge_port_group {
 	struct rcu_head			rcu;
 	struct timer_list		timer;
 	struct br_ip			addr;
+	unsigned char			eth_addr[ETH_ALEN]; /* 2-byte aligned */
 	unsigned char			flags;
-	unsigned char			eth_addr[ETH_ALEN];
 };
 
 struct net_bridge_mdb_entry {
-- 
2.27.0

