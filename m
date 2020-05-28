Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9133D1E7040
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 01:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437505AbgE1XVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 19:21:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:49198 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437492AbgE1XVY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 19:21:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 90100AFE5;
        Thu, 28 May 2020 23:21:22 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id B1E40E32D2; Fri, 29 May 2020 01:21:22 +0200 (CEST)
Message-Id: <065379b5682ce800f8631bc97bc69b2421d143b7.1590707335.git.mkubecek@suse.cz>
In-Reply-To: <cover.1590707335.git.mkubecek@suse.cz>
References: <cover.1590707335.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 03/21] netlink: fix msgbuff_append() helper
To:     John Linville <linville@tuxdriver.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Date:   Fri, 29 May 2020 01:21:22 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As msgbuff_append() only copies protocol payload, i.e. part of the buffer
without netlink and genetlink header, and mnl_nlmsg_get_payload_len() only
subtracts netlink header length, we need to subtract genetlink header
length manually to get correct length of appended data block.

Fixes: 5050607946b6 ("netlink: message buffer and composition helpers")
Reported-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/msgbuff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/netlink/msgbuff.c b/netlink/msgbuff.c
index 74065709ef7d..216f5b946236 100644
--- a/netlink/msgbuff.c
+++ b/netlink/msgbuff.c
@@ -79,6 +79,7 @@ int msgbuff_append(struct nl_msg_buff *dest, struct nl_msg_buff *src)
 	unsigned int dest_len = MNL_ALIGN(msgbuff_len(dest));
 	int ret;
 
+	src_len -= GENL_HDRLEN;
 	ret = msgbuff_realloc(dest, dest_len + src_len);
 	if (ret < 0)
 		return ret;
-- 
2.26.2

