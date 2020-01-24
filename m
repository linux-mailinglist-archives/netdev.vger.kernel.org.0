Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3BF0147B40
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 10:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733108AbgAXJmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 04:42:04 -0500
Received: from ozlabs.org ([203.11.71.1]:60269 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731535AbgAXJmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jan 2020 04:42:04 -0500
Received: by ozlabs.org (Postfix, from userid 1034)
        id 483vLK1YJvz9sSb; Fri, 24 Jan 2020 20:42:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1579858921;
        bh=ijs9DWaapmhyMwt/s0m86iyYYE/6ER+Falkp2AK4k1M=;
        h=From:To:Cc:Subject:Date:From;
        b=FcoKRz6iPslqhHKVdIsWR9rVztpcKIw7307asdvbyt1cd+nHvGdl/5gZ4Lri8dggx
         CduFeUNsxqe0zinUssxanLSIfnJNYR5XM6iYK/rDVw2nSvfqj+kWa2TraA1PCCG3wl
         xKZF8lPMlLsVJFAm8Ray3YvN+tc4wCToBJvIc31VhcYtflMhwBrKY4yn3+FhAefGw8
         wgOpGb6+hXa9wNWhjdf9EVUbFrakNYGISydm2MgyZ5L9iPHp0j/JaYvmbiTtThCJEn
         aN8u/8s1Tl82bjlGsaFFHGSMT2L2CGbrXu210NraO5C2P45zm+5SdD0KLwVXplkFn8
         oqsD3HCOtq67g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        security@kernel.org, ivansprundel@ioactive.com, vishal@chelsio.com
Subject: [PATCH] net: cxgb3_main: Add CAP_NET_ADMIN check to CHELSIO_GET_MEM
Date:   Fri, 24 Jan 2020 20:41:44 +1100
Message-Id: <20200124094144.15831-1-mpe@ellerman.id.au>
X-Mailer: git-send-email 2.21.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The cxgb3 driver for "Chelsio T3-based gigabit and 10Gb Ethernet
adapters" implements a custom ioctl as SIOCCHIOCTL/SIOCDEVPRIVATE in
cxgb_extension_ioctl().

One of the subcommands of the ioctl is CHELSIO_GET_MEM, which appears
to read memory directly out of the adapter and return it to userspace.
It's not entirely clear what the contents of the adapter memory
contains, but the assumption is that it shouldn't be accessible to all
users.

So add a CAP_NET_ADMIN check to the CHELSIO_GET_MEM case. Put it after
the is_offload() check, which matches two of the other subcommands in
the same function which also check for is_offload() and CAP_NET_ADMIN.

Found by Ilja by code inspection, not tested as I don't have the
required hardware.

Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
---
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 58f89f6a040f..97ff8608f0ab 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -2448,6 +2448,8 @@ static int cxgb_extension_ioctl(struct net_device *dev, void __user *useraddr)
 
 		if (!is_offload(adapter))
 			return -EOPNOTSUPP;
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
 		if (!(adapter->flags & FULL_INIT_DONE))
 			return -EIO;	/* need the memory controllers */
 		if (copy_from_user(&t, useraddr, sizeof(t)))
-- 
2.21.1

