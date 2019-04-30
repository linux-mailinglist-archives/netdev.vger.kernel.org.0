Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6F64F094
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbfD3GiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:38:02 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48808 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726385AbfD3Ghh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 02:37:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 00BC12026C;
        Tue, 30 Apr 2019 08:37:37 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wPSTmd0D0B0Z; Tue, 30 Apr 2019 08:37:35 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3F4172027B;
        Tue, 30 Apr 2019 08:37:32 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 30 Apr 2019
 08:37:31 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 40D0B3180669;
 Tue, 30 Apr 2019 08:37:31 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 14/18] xfrm: kconfig: make xfrm depend on inet
Date:   Tue, 30 Apr 2019 08:37:23 +0200
Message-ID: <20190430063727.10908-15-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190430063727.10908-1-steffen.klassert@secunet.com>
References: <20190430063727.10908-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-G-Data-MailSecurity-for-Exchange-State: 0
X-G-Data-MailSecurity-for-Exchange-Error: 0
X-G-Data-MailSecurity-for-Exchange-Sender: 23
X-G-Data-MailSecurity-for-Exchange-Server: d65e63f7-5c15-413f-8f63-c0d707471c93
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-G-Data-MailSecurity-for-Exchange-Guid: 21086E64-D8CB-4912-874A-0BE9BDB8D594
X-G-Data-MailSecurity-for-Exchange-ProcessedOnRouted: True
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

when CONFIG_INET is not enabled:
net/xfrm/xfrm_output.c: In function ‘xfrm4_tunnel_encap_add’:
net/xfrm/xfrm_output.c:234:2: error: implicit declaration of function ‘ip_select_ident’ [-Werror=implicit-function-declaration]
ip_select_ident(dev_net(dst->dev), skb, NULL);

XFRM only supports ipv4 and ipv6 so change dependency to INET and place
user-visible options (pfkey sockets, migrate support and the like)
under 'if INET' guard as well.

Fixes: 1de70830066b7 ("xfrm: remove output2 indirection from xfrm_mode")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/Kconfig | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 5d43aaa17027..1ec8071226b2 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -3,7 +3,7 @@
 #
 config XFRM
        bool
-       depends on NET
+       depends on INET
        select GRO_CELLS
        select SKB_EXTENSIONS
 
@@ -15,9 +15,9 @@ config XFRM_ALGO
 	select XFRM
 	select CRYPTO
 
+if INET
 config XFRM_USER
 	tristate "Transformation user configuration interface"
-	depends on INET
 	select XFRM_ALGO
 	---help---
 	  Support for Transformation(XFRM) user configuration interface
@@ -56,7 +56,7 @@ config XFRM_MIGRATE
 
 config XFRM_STATISTICS
 	bool "Transformation statistics"
-	depends on INET && XFRM && PROC_FS
+	depends on XFRM && PROC_FS
 	---help---
 	  This statistics is not a SNMP/MIB specification but shows
 	  statistics about transformation error (or almost error) factor
@@ -95,3 +95,5 @@ config NET_KEY_MIGRATE
 	  <draft-sugimoto-mip6-pfkey-migrate>.
 
 	  If unsure, say N.
+
+endif # INET
-- 
2.17.1

