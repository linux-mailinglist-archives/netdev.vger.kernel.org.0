Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C5F570498
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 15:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiGKNpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 09:45:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiGKNpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 09:45:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EF0C652E57
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 06:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657547139;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hNgpwT+a7Ngas4330yfPf0G8ZHwlYPTzJSH2ndb9qeE=;
        b=h6D0fkKVuVsP8/1Jk+KhQTd2JkcPznmhvkfmoj+W0NhbZlSYeHkzZzsApsGIgO9NXLzg15
        fOVT43FxC+Ou3qjgtwSnzYKfCidJNG/Ibepm2sjd9IrKncskJspXN+b6SV36jskNBEiQJb
        foFLWlz0E1IqFm+DiZHt9aPC3c8ClOI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-64Zouol9OIihs8vAliT1QA-1; Mon, 11 Jul 2022 09:45:30 -0400
X-MC-Unique: 64Zouol9OIihs8vAliT1QA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9CB52811E7A;
        Mon, 11 Jul 2022 13:45:29 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.194.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0236E906B6;
        Mon, 11 Jul 2022 13:45:27 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        Yanghang Liu <yanghliu@redhat.com>
Subject: [PATCH net] sfc: fix use after free when disabling sriov
Date:   Mon, 11 Jul 2022 15:45:20 +0200
Message-Id: <20220711134520.10466-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use after free is detected by kfence when disabling sriov. What was read
after being freed was vf->pci_dev: it was freed from pci_disable_sriov
and later read in efx_ef10_sriov_free_vf_vports, called from
efx_ef10_sriov_free_vf_vswitching.

Set the pointer to NULL at release time to not trying to read it later.

Reproducer and dmesg log (note that kfence doesn't detect it every time):
$ echo 1 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs
$ echo 0 > /sys/class/net/enp65s0f0np0/device/sriov_numvfs

 BUG: KFENCE: use-after-free read in efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]

 Use-after-free read at 0x00000000ff3c1ba5 (in kfence-#224):
  efx_ef10_sriov_free_vf_vswitching+0x82/0x170 [sfc]
  efx_ef10_pci_sriov_disable+0x38/0x70 [sfc]
  efx_pci_sriov_configure+0x24/0x40 [sfc]
  sriov_numvfs_store+0xfe/0x140
  kernfs_fop_write_iter+0x11c/0x1b0
  new_sync_write+0x11f/0x1b0
  vfs_write+0x1eb/0x280
  ksys_write+0x5f/0xe0
  do_syscall_64+0x5c/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 kfence-#224: 0x00000000edb8ef95-0x00000000671f5ce1, size=2792, cache=kmalloc-4k

 allocated by task 6771 on cpu 10 at 3137.860196s:
  pci_alloc_dev+0x21/0x60
  pci_iov_add_virtfn+0x2a2/0x320
  sriov_enable+0x212/0x3e0
  efx_ef10_sriov_configure+0x67/0x80 [sfc]
  efx_pci_sriov_configure+0x24/0x40 [sfc]
  sriov_numvfs_store+0xba/0x140
  kernfs_fop_write_iter+0x11c/0x1b0
  new_sync_write+0x11f/0x1b0
  vfs_write+0x1eb/0x280
  ksys_write+0x5f/0xe0
  do_syscall_64+0x5c/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

 freed by task 6771 on cpu 12 at 3170.991309s:
  device_release+0x34/0x90
  kobject_cleanup+0x3a/0x130
  pci_iov_remove_virtfn+0xd9/0x120
  sriov_disable+0x30/0xe0
  efx_ef10_pci_sriov_disable+0x57/0x70 [sfc]
  efx_pci_sriov_configure+0x24/0x40 [sfc]
  sriov_numvfs_store+0xfe/0x140
  kernfs_fop_write_iter+0x11c/0x1b0
  new_sync_write+0x11f/0x1b0
  vfs_write+0x1eb/0x280
  ksys_write+0x5f/0xe0
  do_syscall_64+0x5c/0x80
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: Yanghang Liu <yanghliu@redhat.com>
Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/ef10_sriov.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10_sriov.c b/drivers/net/ethernet/sfc/ef10_sriov.c
index 7f5aa4a8c451..92550c7e85ce 100644
--- a/drivers/net/ethernet/sfc/ef10_sriov.c
+++ b/drivers/net/ethernet/sfc/ef10_sriov.c
@@ -408,8 +408,9 @@ static int efx_ef10_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
 static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 {
 	struct pci_dev *dev = efx->pci_dev;
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	unsigned int vfs_assigned = pci_vfs_assigned(dev);
-	int rc = 0;
+	int i, rc = 0;
 
 	if (vfs_assigned && !force) {
 		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
@@ -417,10 +418,13 @@ static int efx_ef10_pci_sriov_disable(struct efx_nic *efx, bool force)
 		return -EBUSY;
 	}
 
-	if (!vfs_assigned)
+	if (!vfs_assigned) {
+		for (i = 0; i < efx->vf_count; i++)
+			nic_data->vf[i].pci_dev = NULL;
 		pci_disable_sriov(dev);
-	else
+	} else {
 		rc = -EBUSY;
+	}
 
 	efx_ef10_sriov_free_vf_vswitching(efx);
 	efx->vf_count = 0;
-- 
2.34.1

