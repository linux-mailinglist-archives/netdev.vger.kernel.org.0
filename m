Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6CA58BAB0
	for <lists+netdev@lfdr.de>; Sun,  7 Aug 2022 13:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbiHGLxV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Aug 2022 07:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230219AbiHGLxU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Aug 2022 07:53:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A298BCB1
        for <netdev@vger.kernel.org>; Sun,  7 Aug 2022 04:53:19 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oKeqG-0002iE-MO; Sun, 07 Aug 2022 13:53:12 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netdev@vger.kernel.org
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, Florian Westphal <fw@strlen.de>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH net] plip: avoid rcu debug splat
Date:   Sun,  7 Aug 2022 13:53:04 +0200
Message-Id: <20220807115304.13257-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

WARNING: suspicious RCU usage
5.2.0-rc2-00605-g2638eb8b50cfc #1 Not tainted
drivers/net/plip/plip.c:1110 suspicious rcu_dereference_check() usage!

plip_open is called with RTNL held, switch to the correct helper.

Fixes: 2638eb8b50cf ("net: ipv4: provide __rcu annotation for ifa_list")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 drivers/net/plip/plip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index dafd3e9ebbf8..c8791e9b451d 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -1111,7 +1111,7 @@ plip_open(struct net_device *dev)
 		/* Any address will do - we take the first. We already
 		   have the first two bytes filled with 0xfc, from
 		   plip_init_dev(). */
-		const struct in_ifaddr *ifa = rcu_dereference(in_dev->ifa_list);
+		const struct in_ifaddr *ifa = rtnl_dereference(in_dev->ifa_list);
 		if (ifa != NULL) {
 			dev_addr_mod(dev, 2, &ifa->ifa_local, 4);
 		}
-- 
2.37.1

