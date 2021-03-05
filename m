Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B766832EAAF
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 13:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbhCEMju convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 5 Mar 2021 07:39:50 -0500
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:42508 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232983AbhCEMj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 07:39:27 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-3gWCCtCyN3CXF2ZOze5HQg-1; Fri, 05 Mar 2021 07:39:10 -0500
X-MC-Unique: 3gWCCtCyN3CXF2ZOze5HQg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75ED7814339;
        Fri,  5 Mar 2021 12:39:09 +0000 (UTC)
Received: from p50.redhat.com (unknown [10.40.194.61])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DCC175D6B1;
        Fri,  5 Mar 2021 12:39:07 +0000 (UTC)
From:   Stefan Assmann <sassmann@kpanic.de>
To:     intel-wired-lan@lists.osuosl.org
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com,
        lihong.yang@intel.com, sassmann@kpanic.de
Subject: [PATCH] iavf: do not override the adapter state in the watchdog task
Date:   Fri,  5 Mar 2021 13:38:56 +0100
Message-Id: <20210305123856.14302-1-sassmann@kpanic.de>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kpanic.de
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The iavf watchdog task overrides adapter->state to __IAVF_RESETTING
when it detects a pending reset. Then schedules iavf_reset_task() which
takes care of the reset.

The reset task is capable of handling the reset without changing
adapter->state. In fact we lose the state information when the watchdog
task prematurely changes the adapter state. This may lead to a crash if
instead of the reset task the iavf_remove() function gets called before
the reset task.
In that case (if we were in state __IAVF_RUNNING previously) the
iavf_remove() function triggers iavf_close() which fails to close the
device because of the incorrect state information.

This may result in a crash due to pending interrupts.
kernel BUG at drivers/pci/msi.c:357!
[...]
Call Trace:
 [<ffffffffbddf24dd>] pci_disable_msix+0x3d/0x50
 [<ffffffffc08d2a63>] iavf_reset_interrupt_capability+0x23/0x40 [iavf]
 [<ffffffffc08d312a>] iavf_remove+0x10a/0x350 [iavf]
 [<ffffffffbddd3359>] pci_device_remove+0x39/0xc0
 [<ffffffffbdeb492f>] __device_release_driver+0x7f/0xf0
 [<ffffffffbdeb49c3>] device_release_driver+0x23/0x30
 [<ffffffffbddcabb4>] pci_stop_bus_device+0x84/0xa0
 [<ffffffffbddcacc2>] pci_stop_and_remove_bus_device+0x12/0x20
 [<ffffffffbddf361f>] pci_iov_remove_virtfn+0xaf/0x160
 [<ffffffffbddf3bcc>] sriov_disable+0x3c/0xf0
 [<ffffffffbddf3ca3>] pci_disable_sriov+0x23/0x30
 [<ffffffffc0667365>] i40e_free_vfs+0x265/0x2d0 [i40e]
 [<ffffffffc0667624>] i40e_pci_sriov_configure+0x144/0x1f0 [i40e]
 [<ffffffffbddd5307>] sriov_numvfs_store+0x177/0x1d0
Code: 00 00 e8 3c 25 e3 ff 49 c7 86 88 08 00 00 00 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 48 8b 7b 28 e8 0d 44
RIP  [<ffffffffbbbf1068>] free_msi_irqs+0x188/0x190

The solution is to not touch the adapter->state in iavf_watchdog_task()
and let the reset task handle the state transition.

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 0a867d64d467..d9e3a70abb47 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1954,7 +1954,6 @@ static void iavf_watchdog_task(struct work_struct *work)
 		/* check for hw reset */
 	reg_val = rd32(hw, IAVF_VF_ARQLEN1) & IAVF_VF_ARQLEN1_ARQENABLE_MASK;
 	if (!reg_val) {
-		adapter->state = __IAVF_RESETTING;
 		adapter->flags |= IAVF_FLAG_RESET_PENDING;
 		adapter->aq_required = 0;
 		adapter->current_op = VIRTCHNL_OP_UNKNOWN;
-- 
2.29.2

