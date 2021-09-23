Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 606EE415675
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 05:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239280AbhIWDlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 23:41:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:41350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239264AbhIWDk0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 23:40:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF54561159;
        Thu, 23 Sep 2021 03:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632368335;
        bh=ovPK0b0UGAUB/ATjR7HCDiwgVXL/SYWi1hP/Q0Bqdg4=;
        h=From:To:Cc:Subject:Date:From;
        b=pamJq0b7ZcQdBhK2TjqEbtoGI9e4DJ0DGT4OcspakdjYjiV8wUrDWyCJ8/b1jNYT4
         vYLjGsOe/k+ggL9nL/nv431Nx0037XnAo23XphetKxrllJysp8/55RZx6dWuW0TwMG
         8syu18f4mqp9Zb6W49cxDchMJTFJXBICz5iDZ2MbQ4v+Abj06g+7ncfqNEElEgVxfw
         nx7yKpJTKinv5y5izmBsVr/tztn20/AkFGmRPAZTCdiSJ4OGVFYhzcadQgYajUBoIM
         aCFQpuRu3J2GptjHCoNOMg/ekmJ5lub7dorAYFbQ3soIZYLSVVBoQ3ZS/L6Mi+p9K3
         xCdHk264uZrYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, mpe@ellerman.id.au,
        drt@linux.ibm.com, kuba@kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/19] ibmvnic: check failover_pending in login response
Date:   Wed, 22 Sep 2021 23:38:35 -0400
Message-Id: <20210923033853.1421193-1-sashal@kernel.org>
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
index ecfe588f330e..cfe7229593ea 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4277,6 +4277,14 @@ static int handle_login_rsp(union ibmvnic_crq *login_rsp_crq,
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

