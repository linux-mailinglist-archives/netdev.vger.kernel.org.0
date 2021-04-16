Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4218B362920
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 22:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244843AbhDPUPy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 16:15:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235769AbhDPUPx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 16:15:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E6A4F613CD;
        Fri, 16 Apr 2021 20:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618604128;
        bh=tP9b6iJ1JpH4vs7bJWhEYStqEIRGGBbyJmBHWGu7Qpw=;
        h=Date:From:To:Cc:Subject:From;
        b=Jh2zRsPLwXzeBxS2b6vlrjjcPT4MVQDsuJp8EwiUnGQnf9DS/UQWDCiMJPqmYSyZB
         wVnd+EMStsDyWlPVx+XcqGQWESrPvrfThM0QTrAd29RVLaTbZxJrPDU3BqkMfB0oNn
         QrJi2GQrtI0a7fD82Tdon5gYfOSPW3ekfnh5bIPvM1jnNWZcMh0Eqn1UF9OBbSHQOd
         DBXuLM0UAhw3k41t1VT8fKvezboIloODGAyiOJGFHTkIZlueejLHc4kePsVqOP4FfS
         mKOZQTm5hQbnUqD521qZihl0+1G6QvRxcyVEUjTqUH43fluXMhF5ivlwGyPbhLXxt/
         CRXyjWRA40xyA==
Date:   Fri, 16 Apr 2021 15:15:40 -0500
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH][next] ethtool: ioctl: Fix out-of-bounds warning in
 store_link_ksettings_for_user()
Message-ID: <20210416201540.GA593906@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following out-of-bounds warning:

net/ethtool/ioctl.c:492:2: warning: 'memcpy' offset [49, 84] from the object at 'link_usettings' is out of the bounds of referenced subobject 'base' with type 'struct ethtool_link_settings' at offset 0 [-Warray-bounds]

The problem is that the original code is trying to copy data into a
some struct members adjacent to each other in a single call to
memcpy(). This causes a legitimate compiler warning because memcpy()
overruns the length of &link_usettings.base. Fix this by directly
using &link_usettings and _from_ as destination and source addresses,
instead.

This helps with the ongoing efforts to globally enable -Warray-bounds
and get us closer to being able to tighten the FORTIFY_SOURCE routines
on memcpy().

Link: https://github.com/KSPP/linux/issues/109
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 27f1c5224acb..3fa7a394eabf 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -489,7 +489,7 @@ store_link_ksettings_for_user(void __user *to,
 {
 	struct ethtool_link_usettings link_usettings;
 
-	memcpy(&link_usettings.base, &from->base, sizeof(link_usettings));
+	memcpy(&link_usettings, from, sizeof(link_usettings));
 	bitmap_to_arr32(link_usettings.link_modes.supported,
 			from->link_modes.supported,
 			__ETHTOOL_LINK_MODE_MASK_NBITS);
-- 
2.27.0

