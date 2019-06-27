Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5A15786D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 02:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727633AbfF0Ac4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 20:32:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:36736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbfF0Acz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 20:32:55 -0400
Received: from sasha-vm.mshome.net (unknown [107.242.116.147])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C48821726;
        Thu, 27 Jun 2019 00:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561595574;
        bh=Kli15JFcziyI2OzxQrQLY/gYdlkasivmcgoy9hHLnsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyBs2Qg0LECe1Sk6Pg0bLx0/ba9t6s6zQFRPly9eG+80q0Lj0OTz2ENCG0Jdo5KzQ
         giFixiA5QRHkm0OiiDByKmyW2+21szWcASUejGyywpdKUPQhaxOEkvPZ76VwZJ48KJ
         StpYp+dq+jU7cEfkb3dqrbFep8wyRs8wlLhu0UWY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.1 45/95] ibmvnic: Fix unchecked return codes of memory allocations
Date:   Wed, 26 Jun 2019 20:29:30 -0400
Message-Id: <20190627003021.19867-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627003021.19867-1-sashal@kernel.org>
References: <20190627003021.19867-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 7c940b1a5291e5069d561f5b8f0e51db6b7a259a ]

The return values for these memory allocations are unchecked,
which may cause an oops if the driver does not handle them after
a failure. Fix by checking the function's return code.

Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 664e52fa7919..0e4029c54241 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -438,9 +438,10 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
 		if (rx_pool->buff_size != be64_to_cpu(size_array[i])) {
 			free_long_term_buff(adapter, &rx_pool->long_term_buff);
 			rx_pool->buff_size = be64_to_cpu(size_array[i]);
-			alloc_long_term_buff(adapter, &rx_pool->long_term_buff,
-					     rx_pool->size *
-					     rx_pool->buff_size);
+			rc = alloc_long_term_buff(adapter,
+						  &rx_pool->long_term_buff,
+						  rx_pool->size *
+						  rx_pool->buff_size);
 		} else {
 			rc = reset_long_term_buff(adapter,
 						  &rx_pool->long_term_buff);
@@ -706,9 +707,9 @@ static int init_tx_pools(struct net_device *netdev)
 			return rc;
 		}
 
-		init_one_tx_pool(netdev, &adapter->tso_pool[i],
-				 IBMVNIC_TSO_BUFS,
-				 IBMVNIC_TSO_BUF_SZ);
+		rc = init_one_tx_pool(netdev, &adapter->tso_pool[i],
+				      IBMVNIC_TSO_BUFS,
+				      IBMVNIC_TSO_BUF_SZ);
 		if (rc) {
 			release_tx_pools(adapter);
 			return rc;
-- 
2.20.1

