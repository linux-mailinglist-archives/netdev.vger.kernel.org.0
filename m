Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C46714ED9CA
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 14:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiCaMqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 08:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236261AbiCaMqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 08:46:31 -0400
Received: from olfflo.fourcot.fr (fourcot.fr [217.70.191.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DAE6210471
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 05:44:43 -0700 (PDT)
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
To:     netdev@vger.kernel.org
Cc:     Florent Fourcot <florent.fourcot@wifirst.fr>,
        Brian Baboch <brian.baboch@wifirst.fr>
Subject: [PATCH net-next] rtnetlink: enable alt_ifname for setlink/newlink
Date:   Thu, 31 Mar 2022 14:37:28 +0200
Message-Id: <20220331123728.7267-1-florent.fourcot@wifirst.fr>
X-Mailer: git-send-email 2.20.1
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

buffer is always valid when called by setlink/newlink,
but contains only empty string when IFLA_IFNAME is not given. So
IFLA_ALT_IFNAME is always ignored

Fixes: 76c9ac0ee878 ("net: rtnetlink: add possibility to use alternative names as message handle")
Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Brian Baboch <brian.baboch@wifirst.fr>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 3313419bbcba..613065a53b34 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2979,7 +2979,7 @@ static struct net_device *rtnl_dev_get(struct net *net,
 {
 	char buffer[ALTIFNAMSIZ];
 
-	if (!ifname) {
+	if (!ifname || !ifname[0]) {
 		ifname = buffer;
 		if (ifname_attr)
 			nla_strscpy(ifname, ifname_attr, IFNAMSIZ);
-- 
2.30.2

