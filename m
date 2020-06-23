Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D7A205FAE
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 22:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390805AbgFWUe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:34:57 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:33704 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391113AbgFWUew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:34:52 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05NKYnIi019537;
        Tue, 23 Jun 2020 13:34:50 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net 06/12] cxgb4: use correct type for all-mask IP address comparison
Date:   Wed, 24 Jun 2020 01:51:36 +0530
Message-Id: <43b438233ce4351a9afdcde06f90806775cc9ac3.1592942138.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
In-Reply-To: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
References: <cover.1592942138.git.rahul.lakkireddy@chelsio.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use correct type to check for all-mask exact match IP addresses.

Fixes following sparse warnings due to big endian value checks
against 0xffffffff in is_addr_all_mask():
cxgb4_filter.c:977:25: warning: restricted __be32 degrades to integer
cxgb4_filter.c:983:37: warning: restricted __be32 degrades to integer
cxgb4_filter.c:984:37: warning: restricted __be32 degrades to integer
cxgb4_filter.c:985:37: warning: restricted __be32 degrades to integer
cxgb4_filter.c:986:37: warning: restricted __be32 degrades to integer

Fixes: 3eb8b62d5a26 ("cxgb4: add support to create hash-filters via tc-flower offload")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
index c6bf2648fe42..7a7f61a8cdf4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
@@ -1112,16 +1112,16 @@ static bool is_addr_all_mask(u8 *ipmask, int family)
 		struct in_addr *addr;
 
 		addr = (struct in_addr *)ipmask;
-		if (addr->s_addr == 0xffffffff)
+		if (ntohl(addr->s_addr) == 0xffffffff)
 			return true;
 	} else if (family == AF_INET6) {
 		struct in6_addr *addr6;
 
 		addr6 = (struct in6_addr *)ipmask;
-		if (addr6->s6_addr32[0] == 0xffffffff &&
-		    addr6->s6_addr32[1] == 0xffffffff &&
-		    addr6->s6_addr32[2] == 0xffffffff &&
-		    addr6->s6_addr32[3] == 0xffffffff)
+		if (ntohl(addr6->s6_addr32[0]) == 0xffffffff &&
+		    ntohl(addr6->s6_addr32[1]) == 0xffffffff &&
+		    ntohl(addr6->s6_addr32[2]) == 0xffffffff &&
+		    ntohl(addr6->s6_addr32[3]) == 0xffffffff)
 			return true;
 	}
 	return false;
-- 
2.24.0

