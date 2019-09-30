Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F10B0C204A
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 14:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729503AbfI3MCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 08:02:32 -0400
Received: from host.76.145.23.62.rev.coltfrance.com ([62.23.145.76]:57379 "EHLO
        proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728573AbfI3MCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Sep 2019 08:02:32 -0400
Received: from bretzel.dev.6wind.com (unknown [10.16.0.19])
        by proxy.6wind.com (Postfix) with ESMTP id E1DC13248CB;
        Mon, 30 Sep 2019 14:02:27 +0200 (CEST)
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [PATCH net-next] ipv6: minor code reorg in inet6_fill_ifla6_attrs()
Date:   Mon, 30 Sep 2019 14:02:16 +0200
Message-Id: <20190930120216.22404-1-nicolas.dichtel@6wind.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just put related code together to ease code reading: the memcpy() is
related to the nla_reserve().

Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
---
 net/ipv6/addrconf.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 6a576ff92c39..413b00cf9c2b 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5552,14 +5552,13 @@ static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
 	nla = nla_reserve(skb, IFLA_INET6_TOKEN, sizeof(struct in6_addr));
 	if (!nla)
 		goto nla_put_failure;
-
-	if (nla_put_u8(skb, IFLA_INET6_ADDR_GEN_MODE, idev->cnf.addr_gen_mode))
-		goto nla_put_failure;
-
 	read_lock_bh(&idev->lock);
 	memcpy(nla_data(nla), idev->token.s6_addr, nla_len(nla));
 	read_unlock_bh(&idev->lock);
 
+	if (nla_put_u8(skb, IFLA_INET6_ADDR_GEN_MODE, idev->cnf.addr_gen_mode))
+		goto nla_put_failure;
+
 	return 0;
 
 nla_put_failure:
-- 
2.23.0

