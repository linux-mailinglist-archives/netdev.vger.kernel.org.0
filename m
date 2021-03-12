Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046483390AF
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhCLPFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231968AbhCLPFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3333764F78;
        Fri, 12 Mar 2021 15:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561503;
        bh=5LCORNHhuwZS2ICNdojquekNf91WE/wxlob3/jaJgt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nbJfG/cUnykzzJF9MsvLWu3AwBE5WVBkdkZvymhsvQGV0kUBm53bC/3+BkTZjwB54
         v+VX/vsD6D4dZBnEspoBml0qjUloHQleypmlG18EBVZhnTjsBf2Fk6EfvxtNgLRQdC
         HEi3dgdXzhzrCX2kPd9gsiqv3W2vrQFIqEYNajeTkWOHQfYlY3CAavuK8kRAilyE/w
         2MCZFfwORM7yTFnSgY+lSzEftzXVThufGRRRW+3FiU5ZlIEF7YMfrC+Vm9I2t82zG2
         pui15lZvcm2dSV+NcQWcqtHDGhAO0e5DLzHeyC3njkiJd8kuAwgIE104yRhoCZpd9W
         MhluzF35cSNyg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 06/16] net: assert the rtnl lock is held when calling __netif_set_xps_queue
Date:   Fri, 12 Mar 2021 16:04:34 +0100
Message-Id: <20210312150444.355207-7-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
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
index 98a9c620f05a..24d8f059e2a6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2623,7 +2623,7 @@ static struct xps_map *expand_xps_map(struct xps_map *map, int attr_index,
 	return new_map;
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

