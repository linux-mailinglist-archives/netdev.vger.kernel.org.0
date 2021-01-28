Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2903078A5
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 15:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhA1OvO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 09:51:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:49948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232240AbhA1OqF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 09:46:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 845E864DDE;
        Thu, 28 Jan 2021 14:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611845066;
        bh=mNXZyQYKYjQhJsHDYG8cSo3dbMx0jEQhqLiErGBf0V0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZNbnkwKnIUaXgXQeGYMR1oUtithhJIApHaQBAtbR9U0IacIZvTtvC4n5CdZ+tD9D5
         /dgPL13rQ6uC8wN8VeYBD29t7Kw3xbGp+bvEoAruOhH7wfdxk444IvJ2GHbLIUtZZ+
         qYayM15T3y8D5DsfFZN8XQb+uwtyKL7pBDDuiPTAhfFmlXm0l9BEMh9V20k3GlYPjH
         4VxxEgm+Pim1i+9/76aemFNIfb3xdveiiKnD2KlI+Xt4/b3YYAK8z1035aYtgT3Ulu
         kY9Id6P3duy4KdN6y7A6d+SH6Cp2ZK7zwHXtlJXIBYps/IEXIp8KfAHCrd1BxO8rup
         kKVfE8jiW9gHg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next 06/11] net: improve queue removal readability in __netif_set_xps_queue
Date:   Thu, 28 Jan 2021 15:44:00 +0100
Message-Id: <20210128144405.4157244-7-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128144405.4157244-1-atenart@kernel.org>
References: <20210128144405.4157244-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the readability of the loop removing tx-queue from unused
CPUs/rx-queues in __netif_set_xps_queue. The change should only be
cosmetic.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 7e5b1a4ae4a5..118cc0985ff1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2792,13 +2792,16 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 	/* removes tx-queue from unused CPUs/rx-queues */
 	for (j = -1; j = netif_attrmask_next(j, possible_mask, nr_ids),
 	     j < nr_ids;) {
-		for (i = tc, tci = j * dev_maps->num_tc; i--; tci++)
-			active |= remove_xps_queue(dev_maps, tci, index);
-		if (!netif_attr_test_mask(j, mask, nr_ids) ||
-		    !netif_attr_test_online(j, online_mask, nr_ids))
-			active |= remove_xps_queue(dev_maps, tci, index);
-		for (i = dev_maps->num_tc - tc, tci++; --i; tci++)
+		tci = j * dev_maps->num_tc;
+
+		for (i = 0; i < dev_maps->num_tc; i++, tci++) {
+			if (i == tc &&
+			    netif_attr_test_mask(j, mask, nr_ids) &&
+			    netif_attr_test_online(j, online_mask, nr_ids))
+				continue;
+
 			active |= remove_xps_queue(dev_maps, tci, index);
+		}
 	}
 
 	/* free map if not active */
-- 
2.29.2

