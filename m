Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24AA1F53C7
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 13:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgFJLrg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 07:47:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:34490 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728468AbgFJLrf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jun 2020 07:47:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 629AAAEBF;
        Wed, 10 Jun 2020 11:47:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 5128D60739; Wed, 10 Jun 2020 13:47:34 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] netlink: fix error message suppression
To:     netdev@vger.kernel.org
Cc:     Heiner Kallweit <hkallweit1@gmail.com>
Message-Id: <20200610114734.5128D60739@lion.mk-sys.cz>
Date:   Wed, 10 Jun 2020 13:47:34 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rewrite of nlsock_process_reply() used a bool variable to store the value
of nlctx->suppress_nlerr before passing to nlsock_process_ack(). This
causes the value of 2 (suppress all error/warning messages) to be converted
to 1 (suppress only -EOPNOTSUPP). As a result, -ENOENT returned by failed
genetlink family lookup when running on kernel without ethtool netlink
support is not ignored and misleading "netlink error: No such file or
directory" message is issued even if the ioctl fallback works as expected.

Fixes: 76bdf9372824 ("netlink: use pretty printing for ethtool netlink messages")
Reported-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 netlink/nlsock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/netlink/nlsock.c b/netlink/nlsock.c
index 2c760b770ec5..c3f09b6ee9ab 100644
--- a/netlink/nlsock.c
+++ b/netlink/nlsock.c
@@ -255,12 +255,12 @@ int nlsock_process_reply(struct nl_socket *nlsk, mnl_cb_t reply_cb, void *data)
 
 		nlhdr = (struct nlmsghdr *)buff;
 		if (nlhdr->nlmsg_type == NLMSG_ERROR) {
-			bool silent = nlsk->nlctx->suppress_nlerr;
+			unsigned int suppress = nlsk->nlctx->suppress_nlerr;
 			bool pretty;
 
 			pretty = debug_on(nlsk->nlctx->ctx->debug,
 					  DEBUG_NL_PRETTY_MSG);
-			return nlsock_process_ack(nlhdr, len, silent, pretty);
+			return nlsock_process_ack(nlhdr, len, suppress, pretty);
 		}
 
 		msgbuff->nlhdr = nlhdr;
-- 
2.27.0

