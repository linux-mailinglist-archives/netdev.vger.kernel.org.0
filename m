Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 392FF506CCF
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348640AbiDSMzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 08:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234667AbiDSMzE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 08:55:04 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80EC43701B
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 05:52:21 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Brian Baboch <brian.baboch@wifirst.fr>,
        Florent Fourcot <florent.fourcot@wifirst.fr>
Subject: [PATCH net-next] Revert "rtnetlink: return EINVAL when request cannot succeed"
Date:   Tue, 19 Apr 2022 14:51:51 +0200
Message-Id: <20220419125151.15589-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <Yl6iFqPFrdvD1wam@zx2c4.com>
References: <Yl6iFqPFrdvD1wam@zx2c4.com>
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

This reverts commit b6177d3240a4

ip-link command is testing kernel capability by sending a RTM_NEWLINK
request, without any argument. It accepts everything in reply, except
EOPNOTSUPP and EINVAL (functions iplink_have_newlink / accept_msg)

So we must keep compatiblity here, invalid empty message should not
return EINVAL

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index b943336908a7..73f2cbc440c9 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3457,7 +3457,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 			return rtnl_group_changelink(skb, net,
 						nla_get_u32(tb[IFLA_GROUP]),
 						ifm, extack, tb);
-		return -EINVAL;
+		return -ENODEV;
 	}
 
 	if (tb[IFLA_MAP] || tb[IFLA_PROTINFO])
-- 
2.30.2

