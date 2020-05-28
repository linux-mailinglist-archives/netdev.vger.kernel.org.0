Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1001E703C
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437464AbgE1XVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:21:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:49054 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437489AbgE1XVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8317BAFDB;
        Thu, 28 May 2020 23:21:12 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id A3B7BE32D2; Fri, 29 May 2020 01:21:12 +0200 (CEST)
Message-Id: <bb60cbfe99071fca4b0ea9e62d67a2341d8dd652.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 01/21] netlink: fix build warnings
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:12 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Depending on compiler version and options, some of these warnings may
result in build failure.

- gcc 4.8 wants __KERNEL_DIV_ROUND_UP defined before including ethtool.h
- avoid pointer arithmetic on void *

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/desc-ethtool.c | 2 +-
 netlink/parser.c       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/netlink/desc-ethtool.c b/netlink/desc-ethtool.c
index 76c6f13e4648..423479dfc6a9 100644
--- a/netlink/desc-ethtool.c
+++ b/netlink/desc-ethtool.c
@@ -4,9 +4,9 @@
  * Descriptions of ethtool netlink messages and attributes for pretty print.
  */
 
+#include "../internal.h"
 #include <linux/ethtool_netlink.h>
 
-#include "../internal.h"
 #include "prettymsg.h"
 
 static const struct pretty_nla_desc __header_desc[] = {
diff --git a/netlink/parser.c b/netlink/parser.c
index fff23f2425e9..d790abedd482 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -1016,7 +1016,7 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 			buff = tmp_buff_find(buffs, parser->group);
 		msgbuff = buff ? &buff->msgbuff : &nlsk->msgbuff;
 
-		param_dest = dest ? (dest + parser->dest_offset) : NULL;
+		param_dest = dest ? ((char *)dest + parser->dest_offset) : NULL;
 		ret = parser->handler(nlctx, parser->type, parser->handler_data,
 				      msgbuff, param_dest);
 		if (ret < 0)
-- 
2.26.2

