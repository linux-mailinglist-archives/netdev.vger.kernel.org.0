Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07A9E4D208D
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 19:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349718AbiCHSvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 13:51:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236818AbiCHSvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 13:51:11 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD791532DF;
        Tue,  8 Mar 2022 10:50:12 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id v28so26295389ljv.9;
        Tue, 08 Mar 2022 10:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SneY3C6k+i+tAE4bYIFeBltj30CFVUtlAJP0X76PGMs=;
        b=Oc+ybH2iM/E3szjxRpDlqRZ0RPJdg3vLArbdJ/1f4zhzT3NCMM+VC5A0zFBeemg1Uk
         8qIaVi4b7hbjFK2qGGZeHmNnGFc/2LGQ0eOvfWyTle9Z+eRm85Nb7IAAQaiESHv7pSAY
         LX0jLwEBJnYJb02I7hdQLtGaNPA8o1BCxnkBuBFVvvdlF6vnQbOwZN+yWxKKjcYoTKu8
         q+PoQ2V+ieK5MX/LUeiNl3EM1ABm5TIsd9gKGMc0gI1s0wJTHEEd/F0jLp+37RFU9bnt
         jHoxA9nTXQcQ06H5kaPIW/G73EMTe0NytBdTobh2+hUQl7qOMAEW1BnImdZXMEaYh2/T
         Us5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SneY3C6k+i+tAE4bYIFeBltj30CFVUtlAJP0X76PGMs=;
        b=ylOJc+MdSJV5eqDaH+zSo9gWurmZLYuIcTm0FFe4bN2osYoIHKhx1ewS7F0MwjqcNC
         woQ9KW7PeSKnSXRmmRiY5E4U6jkR9y10R5YtA8K927CyJUMZsNiG3yx6BV3Xo42FNoBo
         B8rxEc4hXR0A1JHtCcbYy5AUh8bqSdN4Pp1MjTodennB0eXplUfOfQdwrtpKea1/QzUk
         0lLhCEgdvlfSFGx+PXzxW1r8NqRjLvxTjZn8Lo/sH/nMnV0cAVZaqvZMiTIFcq41KCcu
         vB+r3a+p9id0qK3yLmKAMlNoqwwlViY+8AS7pvjADijCdCW2+HjrhuJa174GO/uJddFM
         h8kQ==
X-Gm-Message-State: AOAM530dbTky20w604u6L/RUEmLvDpctJhicN1Sym+C1QfaID+vkwOvZ
        N96Fner1CLLbMuPG8Fw8UOk=
X-Google-Smtp-Source: ABdhPJzejHvJpGQCNBwniqX1Z39Y4q5p6WkqwgCGxBRMBRGJAxa4N+frGPGB8cEIRvt4div2ZILMeg==
X-Received: by 2002:a05:651c:11ca:b0:247:f32e:10ba with SMTP id z10-20020a05651c11ca00b00247f32e10bamr2552225ljo.208.1646765410593;
        Tue, 08 Mar 2022 10:50:10 -0800 (PST)
Received: from localhost.localdomain ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id w10-20020ac2442a000000b0044835a52a08sm1066631lfl.163.2022.03.08.10.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 10:50:10 -0800 (PST)
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     krzysztof.kozlowski@canonical.com, sameo@linux.intel.com,
        thierry.escande@linux.intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
Subject: [PATCH] NFC: port100: fix use-after-free in port100_send_complete
Date:   Tue,  8 Mar 2022 21:50:07 +0300
Message-Id: <20220308185007.6987-1-paskripkin@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Syzbot reported UAF in port100_send_complete(). The root case is in
missing usb_kill_urb() calls on error handling path of ->probe function.

port100_send_complete() accesses devm allocated memory which will be
freed on probe failure. We should kill this urbs before returning an
error from probe function to prevent reported use-after-free

Fail log:

BUG: KASAN: use-after-free in port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
Read of size 1 at addr ffff88801bb59540 by task ksoftirqd/2/26
...
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 port100_send_complete+0x16e/0x1a0 drivers/nfc/port100.c:935
 __usb_hcd_giveback_urb+0x2b0/0x5c0 drivers/usb/core/hcd.c:1670

...

Allocated by task 1255:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
 alloc_dr drivers/base/devres.c:116 [inline]
 devm_kmalloc+0x96/0x1d0 drivers/base/devres.c:823
 devm_kzalloc include/linux/device.h:209 [inline]
 port100_probe+0x8a/0x1320 drivers/nfc/port100.c:1502

Freed by task 1255:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0xff/0x140 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:236 [inline]
 __cache_free mm/slab.c:3437 [inline]
 kfree+0xf8/0x2b0 mm/slab.c:3794
 release_nodes+0x112/0x1a0 drivers/base/devres.c:501
 devres_release_all+0x114/0x190 drivers/base/devres.c:530
 really_probe+0x626/0xcc0 drivers/base/dd.c:670

Reported-and-tested-by: syzbot+16bcb127fb73baeecb14@syzkaller.appspotmail.com
Fixes: 0347a6ab300a ("NFC: port100: Commands mechanism implementation")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 drivers/nfc/port100.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nfc/port100.c b/drivers/nfc/port100.c
index d7db1a0e6be1..00d8ea6dcb5d 100644
--- a/drivers/nfc/port100.c
+++ b/drivers/nfc/port100.c
@@ -1612,7 +1612,9 @@ static int port100_probe(struct usb_interface *interface,
 	nfc_digital_free_device(dev->nfc_digital_dev);
 
 error:
+	usb_kill_urb(dev->in_urb);
 	usb_free_urb(dev->in_urb);
+	usb_kill_urb(dev->out_urb);
 	usb_free_urb(dev->out_urb);
 	usb_put_dev(dev->udev);
 
-- 
2.35.1

