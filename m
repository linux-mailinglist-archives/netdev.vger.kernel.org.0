Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFB16C279B
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 02:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCUBu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 21:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbjCUBu1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 21:50:27 -0400
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D18A1B2C6;
        Mon, 20 Mar 2023 18:50:25 -0700 (PDT)
Received: by mail-qt1-f172.google.com with SMTP id x1so16323063qtr.7;
        Mon, 20 Mar 2023 18:50:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679363424;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tkDUehbZ8CJ16R96/Odi5kD4jkkJgB1ss6Vv7vcxDhA=;
        b=zeeHS/3jtM/2+FJvuE9p7CZr5q4meh2ERTHMHlcC7NFY4MramIDfDplwpqDByk6G1q
         Jf88YiDUbc+HFzyaovQEB5PANiznKAyIvrUvZT15TGvjYFxJ9NPpv3vX5VmyNltTh6/3
         Rw6jkHh3jtZTjB1sHR8gZcaiU8Ig6v4Kti5qw9vkioxFHNaZeT7BjUAZ6/LAf0zs4LcE
         W60sTir9sZvYiqA7qTe+8f49E1cCipXJNNJ93mTZNPG6Nyv0if87EuqH7FeAOtix3GTT
         HwnXBqIPowAyvSzKUM+oDLHIvnoJG4A2K/wJ+JHYFiqMDW6UL3XUb+zcrKb2vWHMNbA4
         7lwA==
X-Gm-Message-State: AO0yUKUUR58FM8YPCy3cODJqdl/RcgXenRK7vECzrEQHC/5cdLcHHpRd
        RXbJ6KSMyBOsUOROwov7qD8=
X-Google-Smtp-Source: AK7set+s5R1Hg6hFBgiRMY4hDDixRAPO2xWLXQHx1Qg3kUpTeNOQ262ozOCW01yOUpH3VklFpeRRWA==
X-Received: by 2002:a05:622a:55:b0:3b8:4adb:c604 with SMTP id y21-20020a05622a005500b003b84adbc604mr2000749qtw.14.1679363424002;
        Mon, 20 Mar 2023 18:50:24 -0700 (PDT)
Received: from tofu.cs.purdue.edu ([128.210.0.165])
        by smtp.gmail.com with ESMTPSA id j13-20020ac8550d000000b003b82489d8acsm7621219qtq.21.2023.03.20.18.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 18:50:23 -0700 (PDT)
From:   Sungwoo Kim <iam@sung-woo.kim>
Cc:     wuruoyu@me.com, benquike@gmail.com, daveti@purdue.edu,
        Sungwoo Kim <iam@sung-woo.kim>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Bluetooth: HCI: Fix global-out-of-bounds
Date:   Mon, 20 Mar 2023 21:50:18 -0400
Message-Id: <20230321015018.1759683-1-iam@sung-woo.kim>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_SBL_CSS,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To loop a variable-length array, hci_init_stage_sync(stage) considers
that stage[i] is valid as long as stage[i-1].func is valid.
Thus, the last element of stage[].func should be intentionally invalid
as hci_init0[], le_init2[], and others did.
However, amp_init1[] and amp_init2[] have no invalid element, letting
hci_init_stage_sync() keep accessing amp_init1[] over its valid range.
This patch fixes this by adding {} in the last of amp_init1[] and
amp_init2[].

==================================================================
BUG: KASAN: global-out-of-bounds in hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:3154 /v6.2-bzimage/net/bluetooth/hci_sync.c:3343 /v6.2-bzimage/net/bluetooth/hci_sync.c:4418 /v6.2-bzimage/net/bluetooth/hci_sync.c:4609 /v6.2-bzimage/net/bluetooth/hci_sync.c:4689)
Read of size 8 at addr ffffffffaed1ab70 by task kworker/u5:0/1032
CPU: 0 PID: 1032 Comm: kworker/u5:0 Not tainted 6.2.0 #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04
Workqueue: hci1 hci_power_on
Call Trace:
 <TASK>
dump_stack_lvl (/v6.2-bzimage/lib/dump_stack.c:107 (discriminator 1))
print_report (/v6.2-bzimage/mm/kasan/report.c:307 /v6.2-bzimage/mm/kasan/report.c:417)
? hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:3154 /v6.2-bzimage/net/bluetooth/hci_sync.c:3343 /v6.2-bzimage/net/bluetooth/hci_sync.c:4418 /v6.2-bzimage/net/bluetooth/hci_sync.c:4609 /v6.2-bzimage/net/bluetooth/hci_sync.c:4689)
kasan_report (/v6.2-bzimage/mm/kasan/report.c:184 /v6.2-bzimage/mm/kasan/report.c:519)
? hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:3154 /v6.2-bzimage/net/bluetooth/hci_sync.c:3343 /v6.2-bzimage/net/bluetooth/hci_sync.c:4418 /v6.2-bzimage/net/bluetooth/hci_sync.c:4609 /v6.2-bzimage/net/bluetooth/hci_sync.c:4689)
hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:3154 /v6.2-bzimage/net/bluetooth/hci_sync.c:3343 /v6.2-bzimage/net/bluetooth/hci_sync.c:4418 /v6.2-bzimage/net/bluetooth/hci_sync.c:4609 /v6.2-bzimage/net/bluetooth/hci_sync.c:4689)
? __pfx_hci_dev_open_sync (/v6.2-bzimage/net/bluetooth/hci_sync.c:4635)
? mutex_lock (/v6.2-bzimage/./arch/x86/include/asm/atomic64_64.h:190 /v6.2-bzimage/./include/linux/atomic/atomic-long.h:443 /v6.2-bzimage/./include/linux/atomic/atomic-instrumented.h:1781 /v6.2-bzimage/kernel/locking/mutex.c:171 /v6.2-bzimage/kernel/locking/mutex.c:285)
? __pfx_mutex_lock (/v6.2-bzimage/kernel/locking/mutex.c:282)
hci_power_on (/v6.2-bzimage/net/bluetooth/hci_core.c:485 /v6.2-bzimage/net/bluetooth/hci_core.c:984)
? __pfx_hci_power_on (/v6.2-bzimage/net/bluetooth/hci_core.c:969)
? read_word_at_a_time (/v6.2-bzimage/./include/asm-generic/rwonce.h:85)
? strscpy (/v6.2-bzimage/./arch/x86/include/asm/word-at-a-time.h:62 /v6.2-bzimage/lib/string.c:161)
process_one_work (/v6.2-bzimage/kernel/workqueue.c:2294)
worker_thread (/v6.2-bzimage/./include/linux/list.h:292 /v6.2-bzimage/kernel/workqueue.c:2437)
? __pfx_worker_thread (/v6.2-bzimage/kernel/workqueue.c:2379)
kthread (/v6.2-bzimage/kernel/kthread.c:376)
? __pfx_kthread (/v6.2-bzimage/kernel/kthread.c:331)
ret_from_fork (/v6.2-bzimage/arch/x86/entry/entry_64.S:314)
 </TASK>
The buggy address belongs to the variable:
amp_init1+0x30/0x60
The buggy address belongs to the physical page:
page:000000003a157ec6 refcount:1 mapcount:0 mapping:0000000000000000 ia
flags: 0x200000000001000(reserved|node=0|zone=2)
raw: 0200000000001000 ffffea0005054688 ffffea0005054688 000000000000000
raw: 0000000000000000 0000000000000000 00000001ffffffff 000000000000000
page dumped because: kasan: bad access detected
Memory state around the buggy address:
 ffffffffaed1aa00: f9 f9 f9 f9 00 00 00 00 f9 f9 f9 f9 00 00 00 00
 ffffffffaed1aa80: 00 00 00 00 f9 f9 f9 f9 00 00 00 00 00 00 00 00
>ffffffffaed1ab00: 00 f9 f9 f9 f9 f9 f9 f9 00 00 00 00 00 00 f9 f9
                                                             ^
 ffffffffaed1ab80: f9 f9 f9 f9 00 00 00 00 f9 f9 f9 f9 00 00 00 f9
 ffffffffaed1ac00: f9 f9 f9 f9 00 06 f9 f9 f9 f9 f9 f9 00 00 02 f9

This bug is found by FuzzBT, a modified version of Syzkaller.
Other contributors for this bug are Ruoyu Wu and Peng Hui.

Fixes: d0b137062b2d ("Bluetooth: hci_sync: Rework init stages")
Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
---
 net/bluetooth/hci_sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 117eedb6f..49e692d73 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -3319,6 +3319,7 @@ static const struct hci_init_stage amp_init1[] = {
 	HCI_INIT(hci_read_flow_control_mode_sync),
 	/* HCI_OP_READ_LOCATION_DATA */
 	HCI_INIT(hci_read_location_data_sync),
+	{}
 };
 
 static int hci_init1_sync(struct hci_dev *hdev)
@@ -3353,6 +3354,7 @@ static int hci_init1_sync(struct hci_dev *hdev)
 static const struct hci_init_stage amp_init2[] = {
 	/* HCI_OP_READ_LOCAL_FEATURES */
 	HCI_INIT(hci_read_local_features_sync),
+	{}
 };
 
 /* Read Buffer Size (ACL mtu, max pkt, etc.) */
-- 
2.34.1

