Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA777EFF4
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 07:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfD3Faw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 01:30:52 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:46856 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726255AbfD3Fav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 01:30:51 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5371A20273;
        Tue, 30 Apr 2019 07:30:49 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hH01TWaOv9i6; Tue, 30 Apr 2019 07:30:48 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D327E2026F;
        Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 07:30:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 0463E3180604;
 Tue, 30 Apr 2019 07:30:47 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 06/12] vti4: ipip tunnel deregistration fixes.
Date:   Tue, 30 Apr 2019 07:30:24 +0200
Message-ID: <20190430053030.27009-7-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430053030.27009-1-steffen.klassert@secunet.com>
References: <20190430053030.27009-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 4A53BD1B-47A4-4995-80A1-2B270AE83A81
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

If tunnel registration failed during module initialization, the module
would fail to deregister the IPPROTO_COMP protocol and would attempt to
deregister the tunnel.

The tunnel was not deregistered during module-exit.

Fixes: dd9ee3444014e ("vti4: Fix a ipip packet processing bug in 'IPCOMP' virtual tunnel")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ip_vti.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 68a21bf75dd0..b6235ca09fa5 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -659,9 +659,9 @@ static int __init vti_init(void)
 	return err;
 
 rtnl_link_failed:
-	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
-xfrm_tunnel_failed:
 	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
+xfrm_tunnel_failed:
+	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 xfrm_proto_comp_failed:
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 xfrm_proto_ah_failed:
@@ -676,6 +676,7 @@ static int __init vti_init(void)
 static void __exit vti_fini(void)
 {
 	rtnl_link_unregister(&vti_link_ops);
+	xfrm4_tunnel_deregister(&ipip_handler, AF_INET);
 	xfrm4_protocol_deregister(&vti_ipcomp4_protocol, IPPROTO_COMP);
 	xfrm4_protocol_deregister(&vti_ah4_protocol, IPPROTO_AH);
 	xfrm4_protocol_deregister(&vti_esp4_protocol, IPPROTO_ESP);
-- 
2.17.1

