Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E09BE41563C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:39:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239199AbhIWDkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239168AbhIWDkM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5D8C61038;
        Thu, 23 Sep 2021 03:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368322;
        bh=hZHaMiu+gLDldTVC+urs5OsK7YZeba4lgFn3zicp2To=;
        h=From:To:Cc:Subject:Date:From;
        b=niJYwXwydP12FJODAq5nJ0YtAeZMMmj+lz9k7HBWpcTqPUn5gwQW3Rp9C3/Ll7FLs
         /chBEBCVWbcDguh80OYLWGVngxWvAnskqZGg3+epM6kNazbTBMEDcQxRZQoRmcu7by
         oYxDJ5zGjT/3M5tH7DrCPLODvDIbwRn8k9a4mJCPu9fvP+2b3pTZcUUI19cGYspVum
         59wqxUwMEHYOMQR9JI1esWZZMucR9Mq25MOsGNtumzDps8a3kElWs03qll5oKqNa2a
         H/c9PXoRN+83adqCtXXe6kSFOK9+8E8cWBUmGVfXEb36k1goRzdKPO8X+zH8SZyAdv
         9GNk3srotH1VQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, drt@linux.ibm.com,
        mpe@ellerman.id.au, kuba@kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 01/26] ibmvnic: check failover_pending in login response
Date:   Wed, 22 Sep 2021 23:38:14 -0400
Message-Id: <20210923033839.1421034-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

[ Upstream commit d437f5aa23aa2b7bd07cd44b839d7546cc17166f ]

If a failover occurs before a login response is received, the login
response buffer maybe undefined. Check that there was no failover
before accessing the login response buffer.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3134c1988db3..bb8d0a0f48ee 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4478,6 +4478,14 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
 		return 0;
 	}
 
+	if (adapter->failover_pending) {
+		adapter->init_done_rc = -EAGAIN;
+		netdev_dbg(netdev, "Failover pending, ignoring login response\n");
+		complete(&adapter->init_done);
+		/* login response buffer will be released on reset */
+		return 0;
+	}
+
 	netdev->mtu = adapter->req_mtu - ETH_HLEN;
 
 	netdev_dbg(adapter->netdev, "Login Response Buffer:\n");
-- 
2.30.2

