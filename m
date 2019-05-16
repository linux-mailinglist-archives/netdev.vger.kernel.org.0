Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16FE520540
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 13:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727651AbfEPLmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 07:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbfEPLmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 07:42:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 329E52168B;
        Thu, 16 May 2019 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558006923;
        bh=5QHq0NPx/pf/I7hk4JXiWuDDQ4q1QHLuvyeWrpEjm/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UHU/rGnGW5LHkUhkSZeTTd/+T6pmM9/aXAUF4bFPFoeHniQ53QCM8iqFvu6btmYw3
         oZGVbtRrRt3bYSzLCkJVYX+jN/NhQ5ZvOVtzuhs5q/ke1h9Y6xIVcP3T1E1dqwcOGJ
         J56j0oajZ2wfwr6E+0aEbTG+TVNr7C02XSqPTnVs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Su Yanjun <suyj.fnst@cn.fujitsu.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 3.18 2/6] xfrm6_tunnel: Fix potential panic when unloading xfrm6_tunnel module
Date:   Thu, 16 May 2019 07:41:55 -0400
Message-Id: <20190516114159.9382-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190516114159.9382-1-sashal@kernel.org>
References: <20190516114159.9382-1-sashal@kernel.org>
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
index 56b72cada346f..f9d493c59d6c1 100644
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

