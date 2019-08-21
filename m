Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0FC897C25
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 16:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728943AbfHUOJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 10:09:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728567AbfHUOJs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 10:09:48 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4622E3083391;
        Wed, 21 Aug 2019 14:09:48 +0000 (UTC)
Received: from p50.redhat.com (ovpn-117-124.ams2.redhat.com [10.36.117.124])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C83F810013A1;
        Wed, 21 Aug 2019 14:09:46 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jeffrey.t.kirsher@intel.com, lihong.yang@intel.com,
        sassmann@kpanic.de
Subject: [PATCH] i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask
Date:   Wed, 21 Aug 2019 16:09:29 +0200
Message-Id: <20190821140929.26985-1-sassmann@kpanic.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 21 Aug 2019 14:09:48 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While testing VF spawn/destroy the following panic occured.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000029
[...]
Workqueue: i40e i40e_service_task [i40e]
RIP: 0010:i40e_sync_vsi_filters+0x6fd/0xc60 [i40e]
[...]
Call Trace:
 ? __switch_to_asm+0x35/0x70
 ? __switch_to_asm+0x41/0x70
 ? __switch_to_asm+0x35/0x70
 ? _cond_resched+0x15/0x30
 i40e_sync_filters_subtask+0x56/0x70 [i40e]
 i40e_service_task+0x382/0x11b0 [i40e]
 ? __switch_to_asm+0x41/0x70
 ? __switch_to_asm+0x41/0x70
 process_one_work+0x1a7/0x3b0
 worker_thread+0x30/0x390
 ? create_worker+0x1a0/0x1a0
 kthread+0x112/0x130
 ? kthread_bind+0x30/0x30
 ret_from_fork+0x35/0x40

Investigation revealed a race where pf->vf[vsi->vf_id].trusted may get
accessed by the watchdog via i40e_sync_filters_subtask() although
i40e_free_vfs() already free'd pf->vf.
To avoid this the call to i40e_sync_vsi_filters() in
i40e_sync_filters_subtask() needs to be guarded by __I40E_VF_DISABLE,
which is also used by i40e_free_vfs().

Note: put the __I40E_VF_DISABLE check after the
__I40E_MACVLAN_SYNC_PENDING check as the latter is more likely to
trigger.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 6d456e579314..f25c7da59b2b 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2587,6 +2587,10 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 		return;
 	if (!test_and_clear_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state))
 		return;
+	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state)) {
+		set_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state);
+		return;
+	}
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
 		if (pf->vsi[v] &&
@@ -2601,6 +2605,7 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 			}
 		}
 	}
+	clear_bit(__I40E_VF_DISABLE, pf->state);
 }
 
 /**
-- 
2.21.0

