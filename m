Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA29205E9
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbfEPLlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:41:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbfEPLlL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:41:11 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0ED720833;
        Thu, 16 May 2019 11:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006870;
        bh=WZqns/vmD52csxksCTSJKOst800Pa8BQAwy8k1CCExQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHKEpEPqrfXJPFfeBekXXx45UHl0zgypmX8LBKXVJH5uxSSo+D5qikSTN66w+8PWt
         DHBV5zoB1sniny9aDJOzplTxuVQuYFitnXu0PmIMDhEEoU76BBdG79QdTyF+7uM6/R
         0lIYY/7CY435W8z/KjsE6IPHuvT7DHQoCyiEwKpQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/16] xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module
Date:   Thu, 16 May 2019 07:40:53 -0400
Message-Id: <20190516114107.8963-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114107.8963-1-sashal@kernel.org>
References: <20190516114107.8963-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Su Yanjun <suyj.fnst@cn.fujitsu.com>

[ Upstream commit 6ee02a54ef990a71bf542b6f0a4e3321de9d9c66 ]

When unloading xfrm6_tunnel module, xfrm6_tunnel_fini directly
frees the xfrm6_tunnel_spi_kmem. Maybe someone has gotten the
xfrm6_tunnel_spi, so need to wait it.

Fixes: 91cc3bb0b04ff("xfrm6_tunnel: RCU conversion")
Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_tunnel.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index c28e3eaad7c26..b51368ebd1e67 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -391,6 +391,10 @@ static void __exit xfrm6_tunnel_fini(void)
 	xfrm6_tunnel_deregister(&xfrm6_tunnel_handler, AF_INET6);
 	xfrm_unregister_type(&xfrm6_tunnel_type, AF_INET6);
 	unregister_pernet_subsys(&xfrm6_tunnel_net_ops);
+	/* Someone maybe has gotten the xfrm6_tunnel_spi.
+	 * So need to wait it.
+	 */
+	rcu_barrier();
 	kmem_cache_destroy(xfrm6_tunnel_spi_kmem);
 }
 
-- 
2.20.1

