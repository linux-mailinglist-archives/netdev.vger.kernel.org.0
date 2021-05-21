Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5423138C954
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 16:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233049AbhEUOkk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 10:40:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23345 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230239AbhEUOke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 10:40:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621607951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8K7daWrt8VNr1Oz6o4N9+sxjClYUafo1eOAMDmN8whU=;
        b=YbHp65Qh5XQ0lJQ7WZPre31Y/Oct9ffK79/jMpvCheeZRVEZAL8HVYYvOtDyb/uIe+sz26
        lXwRx/vYWvOlibp6oN7x174HSHZszC/nEzqxKFNzECX0/AMAhTsTNt0KjwOWPlPtGKk9Jo
        z4YhjBKUypjG3wlpzHjPxI/z1jjKFVE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-259-cgyshezWMZmdpdDoJlSzeA-1; Fri, 21 May 2021 10:39:09 -0400
X-MC-Unique: cgyshezWMZmdpdDoJlSzeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4ACF5102CB6D;
        Fri, 21 May 2021 14:39:08 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-253.ams2.redhat.com [10.36.113.253])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 50C375C1C4;
        Fri, 21 May 2021 14:39:06 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com, kuba@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ihuguet@redhat.com, ivecera@redhat.com
Subject: [PATCH] net:sfc: fix non-freed irq in legacy irq mode
Date:   Fri, 21 May 2021 16:38:35 +0200
Message-Id: <20210521143834.26561-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SFC driver can be configured via modparam to work using MSI-X, MSI or
legacy IRQ interrupts. In the last one, the interrupt was not properly
released on module remove.

It was not freed because the flag irqs_hooked was not set during
initialization in the case of using legacy IRQ.

Example of (trimmed) trace during module remove without this fix:

remove_proc_entry: removing non-empty directory 'irq/125', leaking at least '0000:3b:00.1'
WARNING: CPU: 39 PID: 3658 at fs/proc/generic.c:715 remove_proc_entry+0x15c/0x170
...trimmed...
Call Trace:
 unregister_irq_proc+0xe3/0x100
 free_desc+0x29/0x70
 irq_free_descs+0x47/0x70
 mp_unmap_irq+0x58/0x60
 acpi_unregister_gsi_ioapic+0x2a/0x40
 acpi_pci_irq_disable+0x78/0xb0
 pci_disable_device+0xd1/0x100
 efx_pci_remove+0xa1/0x1e0 [sfc]
 pci_device_remove+0x38/0xa0
 __device_release_driver+0x177/0x230
 driver_detach+0xcb/0x110
 bus_remove_driver+0x58/0xd0
 pci_unregister_driver+0x2a/0xb0
 efx_exit_module+0x24/0xf40 [sfc]
 __do_sys_delete_module.constprop.0+0x171/0x280
 ? exit_to_user_mode_prepare+0x83/0x1d0
 do_syscall_64+0x3d/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f9f9385800b
...trimmed...

Signed-off-by: Íñigo Huguet <ihuguet@redhat.com>
---
 drivers/net/ethernet/sfc/nic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index d1e908846f5d..22fbb0ae77fb 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -90,6 +90,7 @@ int efx_nic_init_interrupt(struct efx_nic *efx)
 				  efx->pci_dev->irq);
 			goto fail1;
 		}
+		efx->irqs_hooked = true;
 		return 0;
 	}
 
-- 
2.31.1

