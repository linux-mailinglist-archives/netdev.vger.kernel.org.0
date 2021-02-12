Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092CC319CD7
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 11:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbhBLKtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 05:49:10 -0500
Received: from novek.ru ([213.148.174.62]:53156 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhBLKtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 05:49:09 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id F084850347E;
        Fri, 12 Feb 2021 13:48:32 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru F084850347E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1613126914; bh=UmooAoTLFq/e1rDfyAY0Whvf6lra9MMk5KbqArNk1Ew=;
        h=From:To:Cc:Subject:Date:From;
        b=ZNKMyoLuawM3ccK8cDvjN78O9hDK1cphjqE0F/Ei2OqBySlBgTmKnttMABaS7QQeI
         3qLjinZz0mZeV+p7sSMYfai1KD3f1Mz0N4CE6z+1wZ6VnrV85KfA82kgigM4he3mgo
         VoGW4TFXAA4lSC6q2mP23WJW7dL9xVIfZzzExP2A=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [RESEND net-next] rxrpc: Fix dependency on IPv6 in udp tunnel config
Date:   Fri, 12 Feb 2021 13:48:14 +0300
Message-Id: <20210212104814.21452-1-vfedorenko@novek.ru>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As udp_port_cfg struct changes its members with dependency on IPv6
configuration, the code in rxrpc should also check for IPv6.

Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
---
 net/rxrpc/local_object.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index 546fd237a649..a4111408ffd0 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -120,9 +120,11 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
 	if (udp_conf.family == AF_INET) {
 		udp_conf.local_ip = srx->transport.sin.sin_addr;
 		udp_conf.local_udp_port = srx->transport.sin.sin_port;
+#if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
 	} else {
 		udp_conf.local_ip6 = srx->transport.sin6.sin6_addr;
 		udp_conf.local_udp_port = srx->transport.sin6.sin6_port;
+#endif
 	}
 	ret = udp_sock_create(net, &udp_conf, &local->socket);
 	if (ret < 0) {
-- 
2.18.4

