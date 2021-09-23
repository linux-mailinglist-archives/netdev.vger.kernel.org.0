Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70E641562E
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239035AbhIWDkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:40:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239105AbhIWDj4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:39:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 494B761038;
        Thu, 23 Sep 2021 03:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368305;
        bh=E2JAuSAIaKy4YT1GeUow5Cmp1C1lLNmmgZ1L6/yk0xA=;
        h=From:To:Cc:Subject:Date:From;
        b=Pi/OEjz36fmBRMyziA1wfReGHwdm882jDpb23akbkiu2tYX94Wy9VtRc0qjB5iU1V
         DRsbbqP5hXOerbpM5Vj73g+GhsCX3DGbYQIa5a7AzwklHWOlwNuS3hsunblJ9ER3SN
         Iw/RW1+1jf0+DTbRC5VtTYG4RGXWLjIATccbrSgydL0uwsIop0m4Cjm8/d6wmtizvP
         gFKCwEyRxLPt/pqjYg16rowVf83xoki0WxbIppx5kSzpo0j0lSVx3WEPGmZxAYWyZz
         kzk9aYmgdbIDpDjpXrBj86m0bPJD6W0cXS2j86T/bJlOSV08FkRdpSkiBEY/FIHUou
         wcy0xGVZnmhkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, drt@linux.ibm.com,
        mpe@ellerman.id.au, kuba@kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.14 01/34] ibmvnic: check failover_pending in login response
Date:   Wed, 22 Sep 2021 23:37:49 -0400
Message-Id: <20210923033823.1420814-1-sashal@kernel.org>
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
index a775c69e4fd7..6aa6ff89a765 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4700,6 +4700,14 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
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

