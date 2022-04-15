Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B127502E04
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 18:54:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355988AbiDOQ4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 12:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355982AbiDOQ4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 12:56:21 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78BB972A2
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 09:53:52 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, edumazet@google.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: [PATCH v5 net-next 3/4] rtnetlink: return ENODEV when IFLA_ALT_IFNAME is used in dellink
Date:   Fri, 15 Apr 2022 18:53:29 +0200
Message-Id: <20220415165330.10497-4-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
References: <20220415165330.10497-1-florent.fourcot@wifirst.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If IFLA_ALT_IFNAME is set and given interface is not found,
we should return ENODEV and be consistent with IFLA_IFNAME
behaviour
This commit extends feature of commit 76c9ac0ee878,
"net: rtnetlink: add possibility to use alternative names as message handle"

CC: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 5899b1d2de14..73f2cbc440c9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3158,7 +3158,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 
 	if (!dev) {
-		if (tb[IFLA_IFNAME] || ifm->ifi_index > 0)
+		if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME] || ifm->ifi_index > 0)
 			err = -ENODEV;
 
 		goto out;
-- 
2.30.2

