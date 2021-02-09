Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72820315100
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 14:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhBIN4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 08:56:37 -0500
Received: from novek.ru ([213.148.174.62]:56044 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232031AbhBINzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 08:55:18 -0500
Received: from nat1.ooonet.ru (gw.zelenaya.net [91.207.137.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id 030B550192C;
        Tue,  9 Feb 2021 16:54:39 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru 030B550192C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1612878881; bh=UmooAoTLFq/e1rDfyAY0Whvf6lra9MMk5KbqArNk1Ew=;
        h=From:To:Cc:Subject:Date:From;
        b=qVvd16AnJutAYTYm0iyfOn1JEb92ExT+XZwbCUqWgsJBSgT6K0B7YSwcWRjO/gS8x
         2+Qx6Uk3WAWPXLqG8DJLep5QjNqlrA+jmhfwm5tJ7NW9c09C+YW1ZqUhGa/Ct7+e/E
         GvpS/D7YSGHws3rpR7VSop6Rp6kwjDIv8iHcxy3s=
From:   Vadim Fedorenko <vfedorenko@novek.ru>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>, netdev@vger.kernel.org
Subject: [net-next] rxrpc: Fix dependency on IPv6 in udp tunnel config
Date:   Tue,  9 Feb 2021 16:54:29 +0300
Message-Id: <20210209135429.2016-1-vfedorenko@novek.ru>
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

