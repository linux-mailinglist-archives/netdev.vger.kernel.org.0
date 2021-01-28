Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230FF3078A6
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232234AbhA1OvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:51:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232244AbhA1OqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:46:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7493E64DE9;
        Thu, 28 Jan 2021 14:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845072;
        bh=DsA1S6viX+MkR70qVehutTDiq1qcSOgjTCBHV3VbLJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLhxjunM6FWszOhTRftQp6LC4nn6uMcFkAWD4Ij+eHE+ulYYWTr4zHHKgfBYf5pRy
         zgzCIH5gcfP7zdDrDqyicJhhzufX+1/kHTfVQiPGuRIjeVsXIriWGuKAqoqk2S0+zi
         XAufajV8FUa/Z2751ZqmicGJA4e87rBI7hj2m1VNXBhGQB5ysbp4qAtoU2M8p5/g1v
         4VyesWUjv8l/Oe6JALlPJoPnkh3F4WGUz4D/6Da5SN5N9YRhU2/xArF2rVPhUzP/0r
         cWmZe9gy7KkJUfEkEi5y2CeH5Zy3Se7d8meIlM8iy1syl1rjVZYDjuqugHWxTwmIMy
         OL3JoMsiDZsnA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 08/11] net: assert the rtnl lock is held when calling __netif_set_xps_queue
Date:   Thu, 28 Jan 2021 15:44:02 +0100
Message-Id: <20210128144405.4157244-9-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ASSERT_RTNL at the top of __netif_set_xps_queue and add a comment
about holding the rtnl lock before the function.

Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 2a0a777390c6..c639761ddb5e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2623,7 +2623,7 @@ static void xps_copy_dev_maps(struct xps_dev_maps *dev_maps,
 	}
 }
 
-/* Must be called under cpus_read_lock */
+/* Must be called under rtnl_lock and cpus_read_lock */
 int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 			  u16 index, bool is_rxqs_map)
 {
@@ -2635,6 +2635,8 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	struct xps_map *map, *new_map;
 	unsigned int nr_ids;
 
+	ASSERT_RTNL();
+
 	if (dev->num_tc) {
 		/* Do not allow XPS on subordinate device directly */
 		num_tc = dev->num_tc;
-- 
2.29.2

