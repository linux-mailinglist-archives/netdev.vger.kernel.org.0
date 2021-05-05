Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AD1374467
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhEEQ5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:57:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236266AbhEEQxn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 302F861983;
        Wed,  5 May 2021 16:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232700;
        bh=wBKGQvhOFLx/aUEm4gphTWfV0/BVKoLM3+dk/doFmTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwyM5kNVZlJmEI+mAl2/L8hD8yDMlmOX1+WUEncga7d5dAtCovxEmo+BCepgTBP7O
         KABcYVpk0Nf42cjMCV+N4b+guqh7sjl5aLmc34/VKsLKtGueez9V5nKL6CDS7pB0bD
         psPk+D5Yj3cRBUr1/0lI/rwV8urIP5tIO14Hc/6Wavw4ilh4Yl9yf+nO6E1QlHNTJB
         Vf4T0oWBFLUbeVTTjI45misb7H9UHBcNJZclxWJUXDhOopcLSX5rV+rN551g2Wq61G
         gWLNVVw68NG8RkV4aVmsQIH9qI3flaBxH5CCfwwBVky6N342eQOALZka0ir0rgXlGN
         on/0Xsb3YfYGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        kernel test robot <lkp@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 62/85] ethtool: ioctl: Fix out-of-bounds warning in store_link_ksettings_for_user()
Date:   Wed,  5 May 2021 12:36:25 -0400
Message-Id: <20210505163648.3462507-62-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

[ Upstream commit c1d9e34e11281a8ba1a1c54e4db554232a461488 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index ec2cd7aab5ad..2917af3f5ac1 100644
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
2.30.2

