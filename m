Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 909731E703E
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437497AbgE1XVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:21:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:49124 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437475AbgE1XVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 86EC2AFDF;
        Thu, 28 May 2020 23:21:17 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id AAA5DE32D2; Fri, 29 May 2020 01:21:17 +0200 (CEST)
Message-Id: <66427ed9d01547b06bc7eb2b853a18108274f3eb.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 02/21] netlink: fix nest type grouping in parser
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:17 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Even if we are only interested in one nested attribute when using
PARSER_GROUP_NEST group type, the temporary buffer must contain proper
netlink header and have pointer to it and payload set up correctly for
libmnl composition functions to be able to track current message size.

Fixes: 9ee9d9517542 ("netlink: add basic command line parsing helpers")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/parser.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/netlink/parser.c b/netlink/parser.c
index d790abedd482..bd3526f31113 100644
--- a/netlink/parser.c
+++ b/netlink/parser.c
@@ -957,6 +957,10 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 		if (!buff)
 			goto out_free_buffs;
 		msgbuff = &buff->msgbuff;
+		ret = msg_init(nlctx, msgbuff, parser->group,
+			       NLM_F_REQUEST | NLM_F_ACK);
+		if (ret < 0)
+			goto out_free_buffs;
 
 		switch (group_style) {
 		case PARSER_GROUP_NEST:
@@ -966,10 +970,6 @@ int nl_parser(struct nl_context *nlctx, const struct param_parser *params,
 				goto out_free_buffs;
 			break;
 		case PARSER_GROUP_MSG:
-			ret = msg_init(nlctx, msgbuff, parser->group,
-				       NLM_F_REQUEST | NLM_F_ACK);
-			if (ret < 0)
-				goto out_free_buffs;
 			if (ethnla_fill_header(msgbuff,
 					       ETHTOOL_A_LINKINFO_HEADER,
 					       nlctx->devname, 0))
-- 
2.26.2

