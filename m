Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F096A3056
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 15:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbjBZOsZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 09:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjBZOsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 09:48:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00177126CF;
        Sun, 26 Feb 2023 06:47:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AF81B80BFF;
        Sun, 26 Feb 2023 14:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6EEC433AF;
        Sun, 26 Feb 2023 14:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677422813;
        bh=Q3vF9Ai2gvQnymAbxhhD7PWJAfPQldv0RJ8iD8V7PSQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Sa8Vz+nB1e1IW0Tg/aywA0QFrQEcHDRm1y9Ik1fWdRpYuEJ6ANtaT1uCm6wJnhQUT
         sgtextrE0610PKNYL4gTjPJWQx8rfGUZqrlArHVQ/+OCsjJ5tjyjNS48qei/lWexOC
         9IsA6DS1l+ECONJdvbv1GDGwrY2yIlpJKd67oz9ON6XqEwE0DzHSoP6sXh9qP9isu/
         6r0rqAe52UtnQbGlydCwRvwFMQp1OaLGmar0SQOn1FVAigYPfhKWhim5BFQZlnYnsi
         4rNvKS3kM7NUi/BW55GE4fIaxRtwVGr/UiWdKRtRg6WFYlVzlepNTUyXvepwpmgpgO
         o2esFDNVDaIUA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>,
        Dokyung Song <dokyungs@yonsei.ac.kr>,
        Jisoo Jang <jisoo.jang@yonsei.ac.kr>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 01/49] wifi: ath9k: Fix use-after-free in ath9k_hif_usb_disconnect()
Date:   Sun, 26 Feb 2023 09:46:01 -0500
Message-Id: <20230226144650.826470-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minsuk Kang <linuxlovemin@yonsei.ac.kr>

[ Upstream commit f099c5c9e2ba08a379bd354a82e05ef839ae29ac ]

This patch fixes a use-after-free in ath9k that occurs in
ath9k_hif_usb_disconnect() when ath9k_destroy_wmi() is trying to access
'drv_priv' that has already been freed by ieee80211_free_hw(), called by
ath9k_htc_hw_deinit(). The patch moves ath9k_destroy_wmi() before
ieee80211_free_hw(). Note that urbs from the driver should be killed
before freeing 'wmi' with ath9k_destroy_wmi() as their callbacks will
access 'wmi'.

Found by a modified version of syzkaller.

==================================================================
BUG: KASAN: use-after-free in ath9k_destroy_wmi+0x38/0x40
Read of size 8 at addr ffff8881069132a0 by task kworker/0:1/7

CPU: 0 PID: 7 Comm: kworker/0:1 Tainted: G O 5.14.0+ #131
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.12.1-0-ga5cab58e9a3f-prebuilt.qemu.org 04/01/2014
Workqueue: usb_hub_wq hub_event
Call Trace:
 dump_stack_lvl+0x8e/0xd1
 print_address_description.constprop.0.cold+0x93/0x334
 ? ath9k_destroy_wmi+0x38/0x40
 ? ath9k_destroy_wmi+0x38/0x40
 kasan_report.cold+0x83/0xdf
 ? ath9k_destroy_wmi+0x38/0x40
 ath9k_destroy_wmi+0x38/0x40
 ath9k_hif_usb_disconnect+0x329/0x3f0
 ? ath9k_hif_usb_suspend+0x120/0x120
 ? usb_disable_interface+0xfc/0x180
 usb_unbind_interface+0x19b/0x7e0
 ? usb_autoresume_device+0x50/0x50
 device_release_driver_internal+0x44d/0x520
 bus_remove_device+0x2e5/0x5a0
 device_del+0x5b2/0xe30
 ? __device_link_del+0x370/0x370
 ? usb_remove_ep_devs+0x43/0x80
 ? remove_intf_ep_devs+0x112/0x1a0
 usb_disable_device+0x1e3/0x5a0
 usb_disconnect+0x267/0x870
 hub_event+0x168d/0x3950
 ? rcu_read_lock_sched_held+0xa1/0xd0
 ? hub_port_debounce+0x2e0/0x2e0
 ? check_irq_usage+0x860/0xf20
 ? drain_workqueue+0x281/0x360
 ? lock_release+0x640/0x640
 ? rcu_read_lock_sched_held+0xa1/0xd0
 ? rcu_read_lock_bh_held+0xb0/0xb0
 ? lockdep_hardirqs_on_prepare+0x273/0x3e0
 process_one_work+0x92b/0x1460
 ? pwq_dec_nr_in_flight+0x330/0x330
 ? rwlock_bug.part.0+0x90/0x90
 worker_thread+0x95/0xe00
 ? __kthread_parkme+0x115/0x1e0
 ? process_one_work+0x1460/0x1460
 kthread+0x3a1/0x480
 ? set_kthread_struct+0x120/0x120
 ret_from_fork+0x1f/0x30

The buggy address belongs to the page:
page:ffffea00041a44c0 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x106913
flags: 0x200000000000000(node=0|zone=2)
raw: 0200000000000000 0000000000000000 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 3, migratetype Unmovable, gfp_mask 0x40dc0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO), pid 7, ts 38347963444, free_ts 41399957635
 prep_new_page+0x1aa/0x240
 get_page_from_freelist+0x159a/0x27c0
 __alloc_pages+0x2da/0x6a0
 alloc_pages+0xec/0x1e0
 kmalloc_order+0x39/0xf0
 kmalloc_order_trace+0x19/0x120
 __kmalloc+0x308/0x390
 wiphy_new_nm+0x6f5/0x1dd0
 ieee80211_alloc_hw_nm+0x36d/0x2230
 ath9k_htc_probe_device+0x9d/0x1e10
 ath9k_htc_hw_init+0x34/0x50
 ath9k_hif_usb_firmware_cb+0x25f/0x4e0
 request_firmware_work_func+0x131/0x240
 process_one_work+0x92b/0x1460
 worker_thread+0x95/0xe00
 kthread+0x3a1/0x480
page last free stack trace:
 free_pcp_prepare+0x3d3/0x7f0
 free_unref_page+0x1e/0x3d0
 device_release+0xa4/0x240
 kobject_put+0x186/0x4c0
 put_device+0x20/0x30
 ath9k_htc_disconnect_device+0x1cf/0x2c0
 ath9k_htc_hw_deinit+0x26/0x30
 ath9k_hif_usb_disconnect+0x2d9/0x3f0
 usb_unbind_interface+0x19b/0x7e0
 device_release_driver_internal+0x44d/0x520
 bus_remove_device+0x2e5/0x5a0
 device_del+0x5b2/0xe30
 usb_disable_device+0x1e3/0x5a0
 usb_disconnect+0x267/0x870
 hub_event+0x168d/0x3950
 process_one_work+0x92b/0x1460

Memory state around the buggy address:
 ffff888106913180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888106913200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888106913280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                               ^
 ffff888106913300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888106913380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================

Reported-by: Dokyung Song <dokyungs@yonsei.ac.kr>
Reported-by: Jisoo Jang <jisoo.jang@yonsei.ac.kr>
Reported-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20221205014308.1617597-1-linuxlovemin@yonsei.ac.kr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c      | 2 --
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 1a2e0c7eeb023..86ede591dafaf 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -1411,8 +1411,6 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 
 	if (hif_dev->flags & HIF_USB_READY) {
 		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
-		ath9k_hif_usb_dev_deinit(hif_dev);
-		ath9k_destroy_wmi(hif_dev->htc_handle->drv_priv);
 		ath9k_htc_hw_free(hif_dev->htc_handle);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 07ac88fb1c577..96a3185a96d75 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -988,6 +988,8 @@ void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug)
 
 		ath9k_deinit_device(htc_handle->drv_priv);
 		ath9k_stop_wmi(htc_handle->drv_priv);
+		ath9k_hif_usb_dealloc_urbs((struct hif_device_usb *)htc_handle->hif_dev);
+		ath9k_destroy_wmi(htc_handle->drv_priv);
 		ieee80211_free_hw(htc_handle->drv_priv->hw);
 	}
 }
-- 
2.39.0

