Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4D91693C7
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 03:25:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728745AbgBWCZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 21:25:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbgBWCZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Feb 2020 21:25:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CFB120707;
        Sun, 23 Feb 2020 02:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424705;
        bh=4BrJ9EXZcJa6znthVl0F5PfVP+9GqPmq6sX3Q6IIDOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fd2mDTtZgU3jgSQPGK9wl1KxUmfnuFGC+Rhp+M/pMdSRbJFcSPltA5bnpjiXryk+2
         LDfunowOjMeLP7fUcBA2ZHljUgqxf9bNcmCF89MYUXVHopwFO1Pi3XyLdsQq2TH/Wu
         hDvHAt0vKPV0dwi/kUimTXQ5qLiaO+ym7om4/ZFs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Firo Yang <firo.yang@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 5/7] enic: prevent waking up stopped tx queues over watchdog reset
Date:   Sat, 22 Feb 2020 21:24:57 -0500
Message-Id: <20200223022459.2594-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022459.2594-1-sashal@kernel.org>
References: <20200223022459.2594-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Firo Yang <firo.yang@suse.com>

[ Upstream commit 0f90522591fd09dd201065c53ebefdfe3c6b55cb ]

Recent months, our customer reported several kernel crashes all
preceding with following message:
NETDEV WATCHDOG: eth2 (enic): transmit queue 0 timed out
Error message of one of those crashes:
BUG: unable to handle kernel paging request at ffffffffa007e090

After analyzing severl vmcores, I found that most of crashes are
caused by memory corruption. And all the corrupted memory areas
are overwritten by data of network packets. Moreover, I also found
that the tx queues were enabled over watchdog reset.

After going through the source code, I found that in enic_stop(),
the tx queues stopped by netif_tx_disable() could be woken up over
a small time window between netif_tx_disable() and the
napi_disable() by the following code path:
napi_poll->
  enic_poll_msix_wq->
     vnic_cq_service->
        enic_wq_service->
           netif_wake_subqueue(enic->netdev, q_number)->
              test_and_clear_bit(__QUEUE_STATE_DRV_XOFF, &txq->state)
In turn, upper netowrk stack could queue skb to ENIC NIC though
enic_hard_start_xmit(). And this might introduce some race condition.

Our customer comfirmed that this kind of kernel crash doesn't occur over
90 days since they applied this patch.

Signed-off-by: Firo Yang <firo.yang@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 3c20d0dc92568..9b97933338163 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1807,10 +1807,10 @@ static int enic_stop(struct net_device *netdev)
 	}
 
 	netif_carrier_off(netdev);
-	netif_tx_disable(netdev);
 	if (vnic_dev_get_intr_mode(enic->vdev) == VNIC_DEV_INTR_MODE_MSIX)
 		for (i = 0; i < enic->wq_count; i++)
 			napi_disable(&enic->napi[enic_cq_wq(enic, i)]);
+	netif_tx_disable(netdev);
 
 	if (!enic_is_dynamic(enic) && !enic_is_sriov_vf(enic))
 		enic_dev_del_station_addr(enic);
-- 
2.20.1

