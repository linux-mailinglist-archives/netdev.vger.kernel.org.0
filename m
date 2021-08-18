Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094013F0D56
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 23:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233935AbhHRVa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 17:30:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:41434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229519AbhHRVa1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 17:30:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36565610CD;
        Wed, 18 Aug 2021 21:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629322192;
        bh=TZvG9mZ3Qw4x+VOxfYQb0IKrjD1KBX5zHwq8Wv8LcpI=;
        h=From:To:Cc:Subject:Date:From;
        b=rBeZ83fvsMrxiqSFAqBe+AyBPTJUurI2TczSDcSpgVuUZkkReImQa4xtoIU0065NI
         CUsR0lo+LTI3igWY3cv9lhWkok3RaDaibDGS4M5r6pCx1jzRyBr3GN7ggTkVDXPBsQ
         cYdF1GD4r97tTFUoCP/i/QSJklLNjzL0GbH7agFaR0xu2kdz4/vLwWxWVr/XGNXAyi
         +xU6/wVg5JXDF5D5TLINTNRSHdwC6/wg3pr+lWb5+lYDBRriBTHwpWueCqfm5ViurP
         YcGtdZb7YnZwLm3MST8J7EgNMiUrXKE2Y3X6aH/NFvUOVeIlw38NreIpzUbalse9+o
         CWuZGREWkMyHg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     stephen@networkplumber.org, dsahern@gmail.com
Cc:     post@jbechtel.de, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH iproute2] ss: fix fallback to procfs for raw sockets
Date:   Wed, 18 Aug 2021 14:29:46 -0700
Message-Id: <20210818212946.996366-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jonas reports that ss -awp does not display any RAW sockets
on a Knoppix 4.4 kernel.

sockdiag_send() diverts to tcpdiag_send() to try the older
netlink interface. tcpdiag_send() works for TCP and DCCP
but not other protocols. Instead of rejecting unsupported
protocols (and missing RAW and SCTP) match on supported ones.

Link: https://lore.kernel.org/netdev/20210815231738.7b42bad4@mmluhan/
Reported-and-tested-by: Jonas Bechtel <post@jbechtel.de>
Fixes: 41fe6c34de50 ("ss: Add inet raw sockets information gathering via netlink diag interface")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 misc/ss.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 894ad40574f1..b39f63fe3b17 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -3404,13 +3404,13 @@ static int tcpdiag_send(int fd, int protocol, struct filter *f)
 	struct iovec iov[3];
 	int iovlen = 1;
 
-	if (protocol == IPPROTO_UDP || protocol == IPPROTO_MPTCP)
-		return -1;
-
 	if (protocol == IPPROTO_TCP)
 		req.nlh.nlmsg_type = TCPDIAG_GETSOCK;
-	else
+	else if (protocol == IPPROTO_DCCP)
 		req.nlh.nlmsg_type = DCCPDIAG_GETSOCK;
+	else
+		return -1;
+
 	if (show_mem) {
 		req.r.idiag_ext |= (1<<(INET_DIAG_MEMINFO-1));
 		req.r.idiag_ext |= (1<<(INET_DIAG_SKMEMINFO-1));
-- 
2.31.1

