Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9D239A70E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhFCRKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:10:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:41014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231359AbhFCRJw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51F35613FE;
        Thu,  3 Jun 2021 17:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740087;
        bh=snku4en0Eu155KqUZ2dmB9MsramNl5r2KoFv8VKWZxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MhmqCEFUMMMPQ+1jAx9nQbzD1HRMGUfkYZJp7nOUTwnaD7r9JIuAzqR29gCnlAmMB
         +0jsYQBlaPABFDZOenbtSK86WXtLEyscWboTkkzqD+agOrjKc9TqsxQmnhhF0oBl/1
         9L+5anue8aM7sy7FQFb9mRZJcjDoXIgtbKvZucfitlTqrh/yd4L0PXDbbkh3AlTRJs
         eSy2YICikL3N2LEJpfwNOKjVo4kcSv/kuiCG24QudRlVSmml7DuCGldB9FKCssz+5Y
         oDlMHNquCnUqz1cZNVj+2eK5wM7JAahq9whyhVPYY7QaUnqDWVDft9sTlIo6Y0bYuy
         xuQeejd1lC2Gg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 26/43] net:sfc: fix non-freed irq in legacy irq mode
Date:   Thu,  3 Jun 2021 13:07:16 -0400
Message-Id: <20210603170734.3168284-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Íñigo Huguet <ihuguet@redhat.com>

[ Upstream commit 8f03eeb6e0a0a0b8d617ee0a4bce729e47130036 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
2.30.2

