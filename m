Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FE03AEC75
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 17:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhFUPfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 11:35:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22211 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230052AbhFUPfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 11:35:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624289576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oltzUUgSfes6rdxhCcSehOIrX0vxzgmoXi/a9KypyPU=;
        b=XfIPYc9mcsAtOOObwHg6mvG1673nIKNcCJ1Ia7DxkQhjn9VXTRiPrq69T4PyvTZt0EYXCj
        q5mvM3uG/8ZGY7mdUzd0zJLJFH7AeggU+vhUwN3xvgwhVggfsPqOaOkhvnTvNYvYqQ1ge4
        i6jOf26nTveemXgmmqcFhKDRZcgHBhA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-MN3Wuz4BOy6Fah9oJeyyZA-1; Mon, 21 Jun 2021 11:32:54 -0400
X-MC-Unique: MN3Wuz4BOy6Fah9oJeyyZA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 606C75721E;
        Mon, 21 Jun 2021 15:32:53 +0000 (UTC)
Received: from localhost.localdomain (ovpn-112-119.ams2.redhat.com [10.36.112.119])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7429419CBA;
        Mon, 21 Jun 2021 15:32:51 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ihuguet@redhat.com, ivecera@redhat.com
Subject: [PATCH 1/4] sfc: avoid double pci_remove of VFs
Date:   Mon, 21 Jun 2021 17:32:35 +0200
Message-Id: <20210621153238.13147-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If pci_remove was called for a PF with VFs, the removal of the VFs was
called twice from efx_ef10_sriov_fini: one directly with pci_driver->remove
and another implicit by calling pci_disable_sriov, which also perform
the VFs remove. This was leading to crashing the kernel on the second
attempt.

Given that pci_disable_sriov already calls to pci remove function, get
rid of the direct call to pci_driver->remove from the driver.

2 different ways to trigger the bug:
- Create one or more VFs, then attach the PF to a virtual machine (at
  least with qemu/KVM)
- Create one or more VFs, then remove the PF with:
  echo 1 > /sys/bus/pci/devices/PF_PCI_ID/remove

Removing sfc module does not trigger the error, at least for me, because
it removes the VF first, and then the PF.

Example of a log with the error:
    list_del corruption, ffff967fd20a8ad0->next is LIST_POISON1 (dead000000000100)
    ------------[ cut here ]------------
    kernel BUG at lib/list_debug.c:47!
    [...trimmed...]
    RIP: 0010:__list_del_entry_valid.cold.1+0x12/0x4c
    [...trimmed...]
    Call Trace:
    efx_dissociate+0x1f/0x140 [sfc]
    efx_pci_remove+0x27/0x150 [sfc]
    pci_device_remove+0x3b/0xc0
    device_release_driver_internal+0x103/0x1f0
    pci_stop_bus_device+0x69/0x90
    pci_stop_and_remove_bus_device+0xe/0x20
    pci_iov_remove_virtfn+0xba/0x120
    sriov_disable+0x2f/0xe0
    efx_ef10_pci_sriov_disable+0x52/0x80 [sfc]
    ? pcie_aer_is_native+0x12/0x40
    efx_ef10_sriov_fini+0x72/0x110 [sfc]
    efx_pci_remove+0x62/0x150 [sfc]
    pci_device_remove+0x3b/0xc0
    device_release_driver_internal+0x103/0x1f0
    unbind_store+0xf6/0x130
    kernfs_fop_write+0x116/0x190
    vfs_write+0xa5/0x1a0
    ksys_write+0x4f/0xb0
    do_syscall_64+0x5b/0x1a0
    entry_SYSCALL_64_after_hwframe+0x65/0xca

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ef10_sriov.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 21fa6c0e8873..a5d28b0f75ba 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -439,7 +439,6 @@ int efx_ef10_sriov_init(struct efx_nic *efx)
 void efx_ef10_sriov_fini(struct efx_nic *efx)
 {
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
-	unsigned int i;
 	int rc;
 
 	if (!nic_data->vf) {
@@ -449,14 +448,7 @@ void efx_ef10_sriov_fini(struct efx_nic *efx)
 		return;
 	}
 
-	/* Remove any VFs in the host */
-	for (i = 0; i < efx->vf_count; ++i) {
-		struct efx_nic *vf_efx = nic_data->vf[i].efx;
-
-		if (vf_efx)
-			vf_efx->pci_dev->driver->remove(vf_efx->pci_dev);
-	}
-
+	/* Disable SRIOV and remove any VFs in the host */
 	rc = efx_ef10_pci_sriov_disable(efx, true);
 	if (rc)
 		netif_dbg(efx, drv, efx->net_dev,
-- 
2.31.1

