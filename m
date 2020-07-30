Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA73232B77
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 07:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728657AbgG3Flv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 01:41:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56056 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728602AbgG3Fls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 01:41:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BA31B20573;
        Thu, 30 Jul 2020 07:41:46 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id o8ul5-Yvkh6m; Thu, 30 Jul 2020 07:41:46 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B9822205DB;
        Thu, 30 Jul 2020 07:41:45 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 07:41:45 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 30 Jul
 2020 07:41:44 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 51B3F3184667; Thu, 30 Jul 2020 07:41:44 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 09/19] ipcomp: assign if_id to child tunnel from parent tunnel
Date:   Thu, 30 Jul 2020 07:41:20 +0200
Message-ID: <20200730054130.16923-10-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730054130.16923-1-steffen.klassert@secunet.com>
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

The child tunnel if_id will be used for xfrm interface's lookup
when processing the IP(6)IP(6) packets in the next patches.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/ipcomp.c  | 1 +
 net/ipv6/ipcomp6.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 59bfa3825810..b42683212c65 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -72,6 +72,7 @@ static struct xfrm_state *ipcomp_tunnel_create(struct xfrm_state *x)
 	t->props.flags = x->props.flags;
 	t->props.extra_flags = x->props.extra_flags;
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
+	t->if_id = x->if_id;
 
 	if (xfrm_init_state(t))
 		goto error;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 99668bfebd85..daef890460b7 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -91,6 +91,7 @@ static struct xfrm_state *ipcomp6_tunnel_create(struct xfrm_state *x)
 	t->props.mode = x->props.mode;
 	memcpy(t->props.saddr.a6, x->props.saddr.a6, sizeof(struct in6_addr));
 	memcpy(&t->mark, &x->mark, sizeof(t->mark));
+	t->if_id = x->if_id;
 
 	if (xfrm_init_state(t))
 		goto error;
-- 
2.17.1

