Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073923D1237
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 17:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239797AbhGUOmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 10:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhGUOmO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 10:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61E8260E0C;
        Wed, 21 Jul 2021 15:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626880970;
        bh=aoqDbVP+cfiPfy+Iu+/m5AKWZ/c2lRCRQKAI31Td0ro=;
        h=From:To:Cc:Subject:Date:From;
        b=TlPjuiG8q9lc0tPL8lMjFYuCjsGc4OrJ1Ou9Sd9C77K2T0yyM9c1MDtFlWBeqhRrr
         D0QMZkP5ia9nIJjzrdt6+sKxRQ3SbodEFoC0+0BFV6/FvLBDSxXx6EZjkjdUdUewQQ
         5GBHDh3W9CehL2R2lAJpBF7wywQBaLO7Po3sc182r6D3JqqmEDMDLy2Np7GsYKr1X6
         lYUj3s2Yo3Barho8yPJhMO7bpQXrOLvGy2Teghr2MnTgNGBHpThh6jGtLLernHxNbT
         I/VmX6beM6+FwoggA5d1HgRpPpuz7a4rB0ZgB3u+B++gWKpoe8XyBcRGg033CMgcqU
         p/7YonQjckl+w==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Colin Ian King <colin.king@canonical.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] netfilter: nfnl_hook: fix unused variable warning
Date:   Wed, 21 Jul 2021 17:22:32 +0200
Message-Id: <20210721152245.2751702-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The only user of this variable is in an #ifdef:

net/netfilter/nfnetlink_hook.c: In function 'nfnl_hook_entries_head':
net/netfilter/nfnetlink_hook.c:177:28: error: unused variable 'netdev' [-Werror=unused-variable]

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/netfilter/nfnetlink_hook.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 50b4e3c9347a..202f57d17bab 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -174,7 +174,9 @@ static const struct nf_hook_entries *
 nfnl_hook_entries_head(u8 pf, unsigned int hook, struct net *net, const char *dev)
 {
 	const struct nf_hook_entries *hook_head = NULL;
+#ifdef CONFIG_NETFILTER_INGRESS
 	struct net_device *netdev;
+#endif
 
 	switch (pf) {
 	case NFPROTO_IPV4:
-- 
2.29.2

