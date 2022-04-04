Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86BF24F17F7
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 17:09:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378184AbiDDPLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Apr 2022 11:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377985AbiDDPLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Apr 2022 11:11:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4211C13D3A
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 08:09:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1562615BE
        for <netdev@vger.kernel.org>; Mon,  4 Apr 2022 15:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3CBC340EE;
        Mon,  4 Apr 2022 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649084952;
        bh=4MD4RKOkcZXCDxme5MpGD9pTFwCi1YFfE4z1oJFE1VI=;
        h=From:To:Cc:Subject:Date:From;
        b=Ep6+mEi2jnfKUQ0apY6BSQgPhltC7axQPDmNzfA34hJ/Zuym4hN/Z3KoJOiggeHYt
         pTXYKKTIYbJPCBsRTz5HNp6azqLXLsdnJDH7JqQLNawai0+sO5IvhWfnPKmzsVqkqm
         F42IXGJzaNLxDTBEH/bfI7gJAtimQtuph/3jJuG/SjDMcUjEn/1Lq9kIOfRuBkVdMQ
         8tv56CreTVopTEEGPed4YeHnTWKTg+WRfgZN9clOiRqjUxutBRn0lOHGbZWImVhsrm
         PnNOs1TFclV3CviJjqa0kOlLOqoi0OK9d5zzFt41n+xB7I0SAFbAv9rgvgdGyXOCKb
         CuCHFUC2ACDQQ==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
Cc:     Filip.Pudak@windriver.com, Jiguang.Xiao@windriver.com,
        ssuryaextr@gmail.com, David Ahern <dsahern@kernel.org>,
        Pudak@vger.kernel.org, Xiao@vger.kernel.org
Subject: [PATCH net] ipv6: Fix stats accounting in ip6_pkt_drop
Date:   Mon,  4 Apr 2022 09:09:08 -0600
Message-Id: <20220404150908.2937-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VRF devices are the loopbacks for VRFs, and a loopback can not be
assigned to a VRF. Accordingly, the condition in ip6_pkt_drop should
be '||' not '&&'.

Fixes: 1d3fd8a10bed ("vrf: Use orig netdev to count Ip6InNoRoutes and a fresh route lookup when sending dest unreach")
Reported-by: Pudak, Filip <Filip.Pudak@windriver.com>
Reported-by: Xiao, Jiguang <Jiguang.Xiao@windriver.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/ipv6/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 2fa10e60cccd..169e9df6d172 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4484,7 +4484,7 @@ static int ip6_pkt_drop(struct sk_buff *skb, u8 code, int ipstats_mib_noroutes)
 	struct inet6_dev *idev;
 	int type;
 
-	if (netif_is_l3_master(skb->dev) &&
+	if (netif_is_l3_master(skb->dev) ||
 	    dst->dev == net->loopback_dev)
 		idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
 	else
-- 
2.24.3 (Apple Git-128)

