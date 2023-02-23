Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3627D6A02FA
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 07:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233439AbjBWGzl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 01:55:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232627AbjBWGzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 01:55:40 -0500
Received: from mail.nfschina.com (unknown [42.101.60.237])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64D83497D4;
        Wed, 22 Feb 2023 22:55:39 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id B27C31A00A90;
        Thu, 23 Feb 2023 14:56:18 +0800 (CST)
X-Virus-Scanned: amavisd-new at nfschina.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id rRBRkp_nGXo5; Thu, 23 Feb 2023 14:56:18 +0800 (CST)
Received: from localhost.localdomain (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 4A1A11A00A79;
        Thu, 23 Feb 2023 14:56:17 +0800 (CST)
From:   Li Qiong <liqiong@nfschina.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Yu Zhe <yuzhe@nfschina.com>,
        Li Qiong <liqiong@nfschina.com>
Subject: [PATCH] net/atm/mpc: Fix dereference NULL pointer in mpc_send_packet()
Date:   Thu, 23 Feb 2023 14:54:46 +0800
Message-Id: <20230223065446.24173-1-liqiong@nfschina.com>
X-Mailer: git-send-email 2.11.0
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 'non_ip' statement need do 'mpc' pointer dereference,
so return '-ENODEV' if 'mpc' is NULL.

Signed-off-by: Li Qiong <liqiong@nfschina.com>
---
 net/atm/mpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/atm/mpc.c b/net/atm/mpc.c
index 033871e718a3..1cd6610b8a12 100644
--- a/net/atm/mpc.c
+++ b/net/atm/mpc.c
@@ -577,7 +577,7 @@ static netdev_tx_t mpc_send_packet(struct sk_buff *skb,
 	mpc = find_mpc_by_lec(dev); /* this should NEVER fail */
 	if (mpc == NULL) {
 		pr_info("(%s) no MPC found\n", dev->name);
-		goto non_ip;
+		return -ENODEV;
 	}
 
 	eth = (struct ethhdr *)skb->data;
-- 
2.11.0

