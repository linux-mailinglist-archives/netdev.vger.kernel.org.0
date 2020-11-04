Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86A52A5FFE
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 10:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbgKDJA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 04:00:27 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:46560 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725812AbgKDJA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 04:00:26 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 409462027C;
        Wed,  4 Nov 2020 10:00:25 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 57CZHqo51ikU; Wed,  4 Nov 2020 10:00:21 +0100 (CET)
Received: from mail-essen-01.secunet.de (unknown [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id F34A82054D;
        Wed,  4 Nov 2020 10:00:15 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Wed, 4 Nov 2020 10:00:15 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 4 Nov 2020
 10:00:15 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0928531805CB;
 Wed,  4 Nov 2020 10:00:14 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/2] xfrm: interface: fix the priorities for ipip and ipv6 tunnels
Date:   Wed, 4 Nov 2020 10:00:09 +0100
Message-ID: <20201104090010.17558-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201104090010.17558-1-steffen.klassert@secunet.com>
References: <20201104090010.17558-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

As Nicolas noticed in his case, when xfrm_interface module is installed
the standard IP tunnels will break in receiving packets.

This is caused by the IP tunnel handlers with a higher priority in xfrm
interface processing incoming packets by xfrm_input(), which would drop
the packets and return 0 instead when anything wrong happens.

Rather than changing xfrm_input(), this patch is to adjust the priority
for the IP tunnel handlers in xfrm interface, so that the packets would
go to xfrmi's later than the others', as the others' would not drop the
packets when the handlers couldn't process them.

Note that IPCOMP also defines its own IPIP tunnel handler and it calls
xfrm_input() as well, so we must make its priority lower than xfrmi's,
which means having xfrmi loaded would still break IPCOMP. We may seek
another way to fix it in xfrm_input() in the future.

Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Fixes: da9bbf0598c9 ("xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler")
FIxes: d7b360c2869f ("xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/xfrm4_tunnel.c   | 4 ++--
 net/ipv6/xfrm6_tunnel.c   | 4 ++--
 net/xfrm/xfrm_interface.c | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index dc19aff7c2e0..fb0648e7fb32 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -64,14 +64,14 @@ static int xfrm_tunnel_err(struct sk_buff *skb, u32 info)
 static struct xfrm_tunnel xfrm_tunnel_handler __read_mostly = {
 	.handler	=	xfrm_tunnel_rcv,
 	.err_handler	=	xfrm_tunnel_err,
-	.priority	=	3,
+	.priority	=	4,
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct xfrm_tunnel xfrm64_tunnel_handler __read_mostly = {
 	.handler	=	xfrm_tunnel_rcv,
 	.err_handler	=	xfrm_tunnel_err,
-	.priority	=	2,
+	.priority	=	3,
 };
 #endif
 
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 25b7ebda2fab..f696d46e6910 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -303,13 +303,13 @@ static const struct xfrm_type xfrm6_tunnel_type = {
 static struct xfrm6_tunnel xfrm6_tunnel_handler __read_mostly = {
 	.handler	= xfrm6_tunnel_rcv,
 	.err_handler	= xfrm6_tunnel_err,
-	.priority	= 2,
+	.priority	= 3,
 };
 
 static struct xfrm6_tunnel xfrm46_tunnel_handler __read_mostly = {
 	.handler	= xfrm6_tunnel_rcv,
 	.err_handler	= xfrm6_tunnel_err,
-	.priority	= 2,
+	.priority	= 3,
 };
 
 static int __net_init xfrm6_tunnel_net_init(struct net *net)
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index a8f66112c52b..0bb7963b9f6b 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -830,14 +830,14 @@ static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly = {
 	.handler	=	xfrmi6_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 
 static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 	.handler	=	xfrmi6_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 #endif
 
@@ -875,14 +875,14 @@ static struct xfrm_tunnel xfrmi_ipip_handler __read_mostly = {
 	.handler	=	xfrmi4_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
-	.priority	=	-1,
+	.priority	=	3,
 };
 
 static struct xfrm_tunnel xfrmi_ipip6_handler __read_mostly = {
 	.handler	=	xfrmi4_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 #endif
 
-- 
2.17.1

