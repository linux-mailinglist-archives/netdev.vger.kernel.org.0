Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF0456AAA45
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 14:50:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjCDNur (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Mar 2023 08:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCDNuq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Mar 2023 08:50:46 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F03EB58;
        Sat,  4 Mar 2023 05:50:45 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id a2so5595653plm.4;
        Sat, 04 Mar 2023 05:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677937845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=55fX7XmVrjOhmxNsuhTqY9HmQVxMxyykjJcmJvuidsU=;
        b=OmtbjRr+nsnQBjrXWIYmJvZQS+3fz+Cg/MG8pJ83B4OHnWKzOj49OfozXhhgIqvWGu
         bqQFq1Y1JZ53ctY0IIijMjIVjftHzltd5FTjFkJ88gkzsqxSr/AJ7gfZO0TjskluRInJ
         piNSHLhNv4Tv23j1SXyeG5hc+GxZNFU++vaCtzbaDi6NPEEU8t0VlURNzeusZF4HoHWt
         q1+qr8ZmHK54pJUPXIlabiJ1Bm08qyizU7BH6p6ihRCOLDChzBnlsxxKmGuGIz8Rjce2
         5QIa8bm8nmucxZ9AUjY0OWr9vVU5ve87Ab11Khce9jcMGmmmVbxEPeWWdA+oPhuYNVUM
         pxaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677937845;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=55fX7XmVrjOhmxNsuhTqY9HmQVxMxyykjJcmJvuidsU=;
        b=6WefFp6eItilQ9S/TSkSkX9pEvMI1+dFkltgPTukZB2MBou7TdBG7UCpcmugVx+E1X
         U67GlaNmBvMfomSxTJ2eVLu3DmDHhAHMG0m2RuH5IGTRmnsBLJgwZm8kadZrd0wDPY0X
         hXTqffqqtBjlRYLlRXD0SCVwOcEQ1OQEi7f/2ykXUPtsmx6xX33WbaGkUG4hXEsi4WnM
         2DJRo2Y7+hKiMiMkyGCCHY4r+imi+uNf6gxOUYApNBVbvikICfm77DLEujUfXVPUsJiL
         T8+ai+JPpXlfX+j1K61EVFJFM3IPAF1CYE6d3C2flubOBqOi0/6ZV+35xN0r7QHShTNz
         Dy6Q==
X-Gm-Message-State: AO0yUKXgYMIUa3IO7vCe5qAH33dIldb08afiz6BL3S1qQzu/Wc2rp0eQ
        oI8zKaGYQ1Q8lpF95EDq4GE=
X-Google-Smtp-Source: AK7set9L78JEUAdTmlSpluFThbWCI/GGjtWZpfaHfq7WEBm11psjgDhJ4tgHe5P7kNGDjW80IhW+wg==
X-Received: by 2002:a17:903:234a:b0:19a:b1ac:45d4 with SMTP id c10-20020a170903234a00b0019ab1ac45d4mr6025132plh.3.1677937844732;
        Sat, 04 Mar 2023 05:50:44 -0800 (PST)
Received: from ubuntu.localdomain ([112.10.230.37])
        by smtp.gmail.com with ESMTPSA id 4-20020a170902e9c400b0019c61616f82sm3362161plk.230.2023.03.04.05.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 05:50:44 -0800 (PST)
From:   Min Li <lm0963hack@gmail.com>
To:     luiz.dentz@gmail.com
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        jkosina@suse.cz, hdegoede@redhat.com, david.rheinsberg@gmail.com,
        wsa+renesas@sang-engineering.com, linux@weissschuh.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/1] Bluetooth: fix race condition in hci_cmd_sync_clear
Date:   Sat,  4 Mar 2023 21:50:35 +0800
Message-Id: <20230304135035.6232-1-lm0963hack@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a potential race condition in hci_cmd_sync_work and
hci_cmd_sync_clear, and could lead to use-after-free. For instance,
hci_cmd_sync_work is added to the 'req_workqueue' after cancel_work_sync
The entry of 'cmd_sync_work_list' may be freed in hci_cmd_sync_clear, and
causing kernel panic when it is used in 'hci_cmd_sync_work'.

Here's the call trace:

dump_stack_lvl+0x49/0x63
print_report.cold+0x5e/0x5d3
? hci_cmd_sync_work+0x282/0x320
kasan_report+0xaa/0x120
? hci_cmd_sync_work+0x282/0x320
__asan_report_load8_noabort+0x14/0x20
hci_cmd_sync_work+0x282/0x320
process_one_work+0x77b/0x11c0
? _raw_spin_lock_irq+0x8e/0xf0
worker_thread+0x544/0x1180
? poll_idle+0x1e0/0x1e0
kthread+0x285/0x320
? process_one_work+0x11c0/0x11c0
? kthread_complete_and_exit+0x30/0x30
ret_from_fork+0x22/0x30
</TASK>

Allocated by task 266:
kasan_save_stack+0x26/0x50
__kasan_kmalloc+0xae/0xe0
kmem_cache_alloc_trace+0x191/0x350
hci_cmd_sync_queue+0x97/0x2b0
hci_update_passive_scan+0x176/0x1d0
le_conn_complete_evt+0x1b5/0x1a00
hci_le_conn_complete_evt+0x234/0x340
hci_le_meta_evt+0x231/0x4e0
hci_event_packet+0x4c5/0xf00
hci_rx_work+0x37d/0x880
process_one_work+0x77b/0x11c0
worker_thread+0x544/0x1180
kthread+0x285/0x320
ret_from_fork+0x22/0x30

Freed by task 269:
kasan_save_stack+0x26/0x50
kasan_set_track+0x25/0x40
kasan_set_free_info+0x24/0x40
____kasan_slab_free+0x176/0x1c0
__kasan_slab_free+0x12/0x20
slab_free_freelist_hook+0x95/0x1a0
kfree+0xba/0x2f0
hci_cmd_sync_clear+0x14c/0x210
hci_unregister_dev+0xff/0x440
vhci_release+0x7b/0xf0
__fput+0x1f3/0x970
____fput+0xe/0x20
task_work_run+0xd4/0x160
do_exit+0x8b0/0x22a0
do_group_exit+0xba/0x2a0
get_signal+0x1e4a/0x25b0
arch_do_signal_or_restart+0x93/0x1f80
exit_to_user_mode_prepare+0xf5/0x1a0
syscall_exit_to_user_mode+0x26/0x50
ret_from_fork+0x15/0x30

v2:
  - Fixed code style issues

Signed-off-by: Min Li <lm0963hack@gmail.com>
---
 net/bluetooth/hci_sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 117eedb6f709..3103daf49d63 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -643,6 +643,7 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
 	cancel_work_sync(&hdev->cmd_sync_work);
 	cancel_work_sync(&hdev->reenable_adv_work);
 
+	mutex_lock(&hdev->cmd_sync_work_lock);
 	list_for_each_entry_safe(entry, tmp, &hdev->cmd_sync_work_list, list) {
 		if (entry->destroy)
 			entry->destroy(hdev, entry->data, -ECANCELED);
@@ -650,6 +651,7 @@ void hci_cmd_sync_clear(struct hci_dev *hdev)
 		list_del(&entry->list);
 		kfree(entry);
 	}
+	mutex_unlock(&hdev->cmd_sync_work_lock);
 }
 
 void __hci_cmd_sync_cancel(struct hci_dev *hdev, int err)
-- 
2.25.1

