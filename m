Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C580F14D007
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 19:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgA2SBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 13:01:23 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:58638 "EHLO
        baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726171AbgA2SBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 13:01:22 -0500
Received: from ramsan ([84.195.182.253])
        by baptiste.telenet-ops.be with bizsmtp
        id wJ1J2100R5USYZQ01J1JeL; Wed, 29 Jan 2020 19:01:20 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iwreQ-0005lk-Ft; Wed, 29 Jan 2020 19:01:18 +0100
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1iwreQ-00009c-D9; Wed, 29 Jan 2020 19:01:18 +0100
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Paolo Abeni <pabeni@redhat.com>, Florian Westphal <fw@strlen.de>,
        Christoph Paasch <cpaasch@apple.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mptcp: Fix incorrect IPV6 dependency check
Date:   Wed, 29 Jan 2020 19:01:17 +0100
Message-Id: <20200129180117.545-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_MPTCP=y, CONFIG_MPTCP_IPV6=n, and CONFIG_IPV6=m:

    net/mptcp/protocol.o: In function `__mptcp_tcp_fallback':
    protocol.c:(.text+0x786): undefined reference to `inet6_stream_ops'

Fix this by checking for CONFIG_MPTCP_IPV6 instead of CONFIG_IPV6, like
is done in all other places in the mptcp code.

Fixes: 8ab183deb26a3b79 ("mptcp: cope with later TCP fallback")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 net/mptcp/protocol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 39fdca79ce90137e..096dfd1074540c8a 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -28,7 +28,7 @@ static void __mptcp_close(struct sock *sk, long timeout);
 
 static const struct proto_ops *tcp_proto_ops(struct sock *sk)
 {
-#if IS_ENABLED(CONFIG_IPV6)
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
 	if (sk->sk_family == AF_INET6)
 		return &inet6_stream_ops;
 #endif
-- 
2.17.1

