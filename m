Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76897629574
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 11:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238386AbiKOKNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 05:13:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238438AbiKOKMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 05:12:39 -0500
Received: from xavier.telenet-ops.be (xavier.telenet-ops.be [IPv6:2a02:1800:120:4::f00:14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2239E25C56
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 02:12:22 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed10:8c33:62a1:bd29:7c58])
        by xavier.telenet-ops.be with bizsmtp
        id kaCJ280030JF8f801aCJRV; Tue, 15 Nov 2022 11:12:21 +0100
Received: from rox.of.borg ([192.168.97.57])
        by ramsan.of.borg with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ousvR-000Xyg-IX; Tue, 15 Nov 2022 11:12:17 +0100
Received: from geert by rox.of.borg with local (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1ousvQ-005B9T-VS; Tue, 15 Nov 2022 11:12:16 +0100
From:   Geert Uytterhoeven <geert+renesas@glider.be>
To:     Jamie Bainbridge <jamie.bainbridge@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chris Down <chris@chrisdown.name>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH net-next] tcp: Fix tcp_syn_flood_action() if CONFIG_IPV6=n
Date:   Tue, 15 Nov 2022 11:12:16 +0100
Message-Id: <d1ecf500f07e063d4e8e34f4045ddca55416c686.1668507036.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If CONFIG_IPV6=n:

    net/ipv4/tcp_input.c: In function ‘tcp_syn_flood_action’:
    include/net/sock.h:387:37: error: ‘const struct sock_common’ has no member named ‘skc_v6_rcv_saddr’; did you mean ‘skc_rcv_saddr’?
      387 | #define sk_v6_rcv_saddr __sk_common.skc_v6_rcv_saddr
	  |                                     ^~~~~~~~~~~~~~~~
    include/linux/printk.h:429:19: note: in definition of macro ‘printk_index_wrap’
      429 |   _p_func(_fmt, ##__VA_ARGS__);    \
	  |                   ^~~~~~~~~~~
    include/linux/printk.h:530:2: note: in expansion of macro ‘printk’
      530 |  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
	  |  ^~~~~~
    include/linux/net.h:272:3: note: in expansion of macro ‘pr_info’
      272 |   function(__VA_ARGS__);    \
	  |   ^~~~~~~~
    include/linux/net.h:288:2: note: in expansion of macro ‘net_ratelimited_function’
      288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
	  |  ^~~~~~~~~~~~~~~~~~~~~~~~
    include/linux/net.h:288:43: note: in expansion of macro ‘sk_v6_rcv_saddr’
      288 |  net_ratelimited_function(pr_info, fmt, ##__VA_ARGS__)
	  |                                           ^~~~~~~~~~~
    net/ipv4/tcp_input.c:6847:4: note: in expansion of macro ‘net_info_ratelimited’
     6847 |    net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
	  |    ^~~~~~~~~~~~~~~~~~~~

Fix this by using "#if" instead of "if", like is done for all other
checks for CONFIG_IPV6.

Fixes: d9282e48c6088105 ("tcp: Add listening address to SYN flood message")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 net/ipv4/tcp_input.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 94024fdc2da1b28a..e5d7a33fac6666bb 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6843,11 +6843,14 @@ static bool tcp_syn_flood_action(const struct sock *sk, const char *proto)
 
 	if (!queue->synflood_warned && syncookies != 2 &&
 	    xchg(&queue->synflood_warned, 1) == 0) {
-		if (IS_ENABLED(CONFIG_IPV6) && sk->sk_family == AF_INET6) {
+#if IS_ENABLED(CONFIG_IPV6)
+		if (sk->sk_family == AF_INET6) {
 			net_info_ratelimited("%s: Possible SYN flooding on port [%pI6c]:%u. %s.\n",
 					proto, &sk->sk_v6_rcv_saddr,
 					sk->sk_num, msg);
-		} else {
+		} else
+#endif
+		{
 			net_info_ratelimited("%s: Possible SYN flooding on port %pI4:%u. %s.\n",
 					proto, &sk->sk_rcv_saddr,
 					sk->sk_num, msg);
-- 
2.25.1

