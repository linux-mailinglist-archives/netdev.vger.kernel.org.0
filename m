Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6168A29DBD2
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 01:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390863AbgJ2AOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 20:14:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50800 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390855AbgJ2AN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Oct 2020 20:13:57 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kXZZ5-003ttp-70; Wed, 28 Oct 2020 01:43:47 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [=PATCH net-next] net: tipc: Fix parameter types passed to %s formater
Date:   Wed, 28 Oct 2020 01:43:33 +0100
Message-Id: <20201028004333.929816-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the compiler is performing printf checking, we get the warning:

net/tipc/netlink_compat.c: In function ‘tipc_nl_compat_link_stat_dump’:
net/tipc/netlink_compat.c:591:39: warning: format ‘%s’ expects argument of type ‘char *’, but argument 3 has type ‘void *’ [-Wformat=]
  591 |  tipc_tlv_sprintf(msg->rep, "\nLink <%s>\n",
      |                                      ~^
      |                                       |
      |                                       char *
      |                                      %p
  592 |     nla_data(link[TIPC_NLA_LINK_NAME]));
      |     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |     |
      |     void *

There is no nla_string(), so cast to a char *.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/tipc/netlink_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 17a90a2fe753..5c6206c9d6a8 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -589,7 +589,7 @@ static int tipc_nl_compat_link_stat_dump(struct tipc_nl_compat_msg *msg,
 		return 0;
 
 	tipc_tlv_sprintf(msg->rep, "\nLink <%s>\n",
-			 nla_data(link[TIPC_NLA_LINK_NAME]));
+			 (char *)nla_data(link[TIPC_NLA_LINK_NAME]));
 
 	if (link[TIPC_NLA_LINK_BROADCAST]) {
 		__fill_bc_link_stat(msg, prop, stats);
-- 
2.28.0

