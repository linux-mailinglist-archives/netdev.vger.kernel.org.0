Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7832B3A74
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 23:53:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgKOWwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 17:52:18 -0500
Received: from mail.zeus.flokli.de ([88.198.15.28]:39116 "EHLO zeus.flokli.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727302AbgKOWwR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Nov 2020 17:52:17 -0500
X-Greylist: delayed 412 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Nov 2020 17:52:17 EST
Received: from localhost (ip-178-200-107-224.hsi07.unitymediagroup.de [178.200.107.224])
        (using TLSv1.2 with cipher AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: flokli@flokli.de)
        by zeus.flokli.de (Postfix) with ESMTPSA id 2597AF354E9;
        Sun, 15 Nov 2020 22:45:24 +0000 (UTC)
From:   Florian Klink <flokli@flokli.de>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Klink <flokli@flokli.de>,
        Kim Phillips <kim.phillips@arm.com>
Subject: [PATCH] ipv4: use IS_ENABLED instead of ifdef
Date:   Sun, 15 Nov 2020 23:45:09 +0100
Message-Id: <20201115224509.2020651-1-flokli@flokli.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checking for ifdef CONFIG_x fails if CONFIG_x=m.

Use IS_ENABLED instead, which is true for both built-ins and modules.

Otherwise, a
> ip -4 route add 1.2.3.4/32 via inet6 fe80::2 dev eth1
fails with the message "Error: IPv6 support not enabled in kernel." if
CONFIG_IPV6 is `m`.

In the spirit of b8127113d01e53adba15b41aefd37b90ed83d631.

Cc: Kim Phillips <kim.phillips@arm.com>
Signed-off-by: Florian Klink <flokli@flokli.de>
---
 net/ipv4/fib_frontend.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 86a23e4a6a50..b87140a1fa28 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -696,7 +696,7 @@ int fib_gw_from_via(struct fib_config *cfg, struct nlattr *nla,
 		cfg->fc_gw4 = *((__be32 *)via->rtvia_addr);
 		break;
 	case AF_INET6:
-#ifdef CONFIG_IPV6
+#if IS_ENABLED(CONFIG_IPV6)
 		if (alen != sizeof(struct in6_addr)) {
 			NL_SET_ERR_MSG(extack, "Invalid IPv6 address in RTA_VIA");
 			return -EINVAL;
-- 
2.29.2

