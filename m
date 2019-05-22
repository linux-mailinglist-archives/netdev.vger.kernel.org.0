Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D412526307
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 13:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbfEVLde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 07:33:34 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:36687 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728335AbfEVLde (ORCPT
        <rfc822;groupwise-netdev@vger.kernel.org:0:0>);
        Wed, 22 May 2019 07:33:34 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Wed, 22 May 2019 13:33:32 +0200
Received: from linux-6qg8.suse.asia (nwb-a10-snat.microfocus.com [10.120.13.201])
        by emea4-mta.ukb.novell.com with ESMTP (NOT encrypted); Wed, 22 May 2019 12:33:09 +0100
From:   Firo Yang <fyang@suse.com>
To:     benve@cisco.com, ssujith@cisco.com, _govind@gmx.com,
        neepatel@cisco.com, netdev@vger.kernel.org
Cc:     firogm@gmail.com, Firo Yang <fyang@suse.com>
Subject: [RFC PATCH 1/1] enic: prvent waking up stopped tx queues during watchdog reset process
Date:   Wed, 22 May 2019 19:33:03 +0800
Message-Id: <20190522113303.18533-1-fyang@suse.com>
X-Mailer: git-send-email 2.16.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Our customer reports several kernel crashes all preceding with message
of tx queue timed out:
NETDEV WATCHDOG: eth2 (enic): transmit queue 0 timed out
Error message of one of those crashes:
BUG: unable to handle kernel paging request at ffffffffa007e090
...
Call Trace:
 [<ffffffff814ee240>] skb_release_head_state+0x90/0xb0
 [<ffffffff814ee26e>] skb_release_all+0xe/0x30
 [<ffffffff814ee597>] consume_skb+0x27/0x80
 [<ffffffffa02b838c>] vnic_wq_clean+0x2c/0xa0 [enic]
 [<ffffffffa02b3392>] enic_stop+0x302/0x3c0 [enic]
 [<ffffffffa02b6cdb>] enic_tx_hang_reset+0x3b/0xc0 [enic]
 [<ffffffff81097a24>] process_one_work+0x154/0x410
 [<ffffffff81098606>] worker_thread+0x116/0x4a0

In enic_stop(), the tx queues stopped by netif_tx_disable() could be
woken up during the small time period between netif_tx_disable() and
the napi_disable() in the following way:
napi_poll->
  enic_poll_msix_wq->
     vnic_cq_service->
        enic_wq_service->
           netif_wake_subqueue(enic->netdev, q_number)->
              test_and_clear_bit(__QUEUE_STATE_DRV_XOFF, &txq->state)
In turn, upper netowrk stack could queue skb to ENIC NIC though
enic_hard_start_xmit(). I don't have a clear idea on how above problem
was triggered so this is a RFC patch.

Signed-off-by: Firo Yang <fyang@suse.com>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 46dd75959e07..e878f3cbfeec 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -1809,10 +1809,10 @@ static int enic_stop(struct net_device *netdev)
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
2.16.4

