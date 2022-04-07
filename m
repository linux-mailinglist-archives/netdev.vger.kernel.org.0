Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6BF4F7EFD
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 14:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243303AbiDGMbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 08:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243088AbiDGMbF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 08:31:05 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB84D9EBA
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 05:29:04 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, edumazet@google.com,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Jiri Pirko <jiri@mellanox.com>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: [PATCH v3 net-next 2/4] rtnetlink: return ENODEV when IFLA_ALT_IFNAME is used in dellink
Date:   Thu,  7 Apr 2022 14:25:57 +0200
Message-Id: <20220407122559.27515-3-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220407122559.27515-1-florent.fourcot@wifirst.fr>
References: <20220407122559.27515-1-florent.fourcot@wifirst.fr>
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
index 6a5764745288..33dbeed7e531 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3121,7 +3121,7 @@ static int rtnl_dellink(struct sk_buff *skb, struct nlmsghdr *nlh,
 		goto out;
 
 	if (!dev) {
-		if (tb[IFLA_IFNAME] || ifm->ifi_index > 0)
+		if (tb[IFLA_IFNAME] || tb[IFLA_ALT_IFNAME] || ifm->ifi_index > 0)
 			err = -ENODEV;
 
 		goto out;
-- 
2.30.2

