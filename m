Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98DD968261F
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 09:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjAaIEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 03:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjAaIEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 03:04:44 -0500
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442BC55AA
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:04:43 -0800 (PST)
Received: by mail-io1-f72.google.com with SMTP id u1-20020a5d8181000000b006ee29a8c421so8119284ion.19
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 00:04:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p4MQa1yQG6X9/QC2Xjtit3PZhQKPbwEt6l5OBshwjLE=;
        b=6VBkNaOnHEio66S5N3E3iF1GIxOJwDCO9winvbuxLKFVYJZjRUncVNCLxksQAOy9n9
         Gn2a/FfVuVbvPDJOocTsFCI438a9J1a0ZvBQYvdhsFrAEw5vxIZl4XoYMNdtf5Yt1+Dr
         T0l+Q+aKyEbEk/NREVokqfQsFTr7ZFBz/m9miCvlVhLiF/ULcBTM+emgZCA0iy6+j4hA
         WL/xiprHSRagSp5ve19/tu7SbftxT3T5NQUjEL1rWt8QbKS4RG2EWej9o8dfFAAZGkx2
         jI3GzmozaxdCvaM2JI8c5jFv6ovgDO20B8aDLlKJklueKEXOLnSicIS5hHFW4vxjlsik
         hfgA==
X-Gm-Message-State: AO0yUKVecv2BxFwl/qYMx/DtU6UcWojVzV+LZVPcmmJ9YaTQfqmBP+x4
        4/az/MNjs4vBTKMWqtZr+jUqre0q1maK7DYQ2M7cK1Rplclx
X-Google-Smtp-Source: AK7set9emcv9i7GW6it6Xabrs4q3bhw9NAy/c62EkoJrHJztrnZLoND+Jo+/W8yXFH63nx+IuYgdQBbfY1Kn8GK16/uCCAiY0WXn
MIME-Version: 1.0
X-Received: by 2002:a02:b904:0:b0:3b1:92c0:ac28 with SMTP id
 v4-20020a02b904000000b003b192c0ac28mr1373084jan.74.1675152282617; Tue, 31 Jan
 2023 00:04:42 -0800 (PST)
Date:   Tue, 31 Jan 2023 00:04:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c0128805f38ac843@google.com>
Subject: [syzbot] KMSAN: uninit-value in kalmia_send_init_packet
From:   syzbot <syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    41c66f470616 kmsan: silence -Wmissing-prototypes warnings
git tree:       https://github.com/google/kmsan.git master
console+strace: https://syzkaller.appspot.com/x/log.txt?x=122f123e480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a9a22da1efde3af6
dashboard link: https://syzkaller.appspot.com/bug?extid=cd80c5ef5121bfe85b55
compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=148c93e1480000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=133524d1480000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/69d5eef879e6/disk-41c66f47.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/e91a447c44a2/vmlinux-41c66f47.xz
kernel image: https://storage.googleapis.com/syzbot-assets/c549edb9c410/bzImage-41c66f47.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cd80c5ef5121bfe85b55@syzkaller.appspotmail.com

usb 1-1: Product: syz
usb 1-1: Manufacturer: syz
usb 1-1: SerialNumber: syz
usb 1-1: config 0 descriptor??
=====================================================
BUG: KMSAN: uninit-value in kalmia_send_init_packet+0x56f/0x5f0 drivers/net/usb/kalmia.c:67
 kalmia_send_init_packet+0x56f/0x5f0 drivers/net/usb/kalmia.c:67
 kalmia_init_and_get_ethernet_addr drivers/net/usb/kalmia.c:113 [inline]
 kalmia_bind+0x2fd/0x5a0 drivers/net/usb/kalmia.c:148
 usbnet_probe+0xf8e/0x3de0 drivers/net/usb/usbnet.c:1745
 usb_probe_interface+0xc4b/0x11f0 drivers/usb/core/driver.c:396
 really_probe+0x506/0x1000 drivers/base/dd.c:639
 __driver_probe_device+0x2fa/0x3d0 drivers/base/dd.c:778
 driver_probe_device+0x72/0x7a0 drivers/base/dd.c:808
 __device_attach_driver+0x548/0x8e0 drivers/base/dd.c:936
 bus_for_each_drv+0x1fc/0x360 drivers/base/bus.c:427
 __device_attach+0x42a/0x720 drivers/base/dd.c:1008
 device_initial_probe+0x2e/0x40 drivers/base/dd.c:1057
 bus_probe_device+0x13c/0x3b0 drivers/base/bus.c:487
 device_add+0x1d4b/0x26c0 drivers/base/core.c:3479
 usb_set_configuration+0x3157/0x3860 drivers/usb/core/message.c:2171
 usb_generic_driver_probe+0x105/0x290 drivers/usb/core/generic.c:238
 usb_probe_device+0x288/0x490 drivers/usb/core/driver.c:293
 really_probe+0x506/0x1000 drivers/base/dd.c:639
 __driver_probe_device+0x2fa/0x3d0 drivers/base/dd.c:778
 driver_probe_device+0x72/0x7a0 drivers/base/dd.c:808
 __device_attach_driver+0x548/0x8e0 drivers/base/dd.c:936
 bus_for_each_drv+0x1fc/0x360 drivers/base/bus.c:427
 __device_attach+0x42a/0x720 drivers/base/dd.c:1008
 device_initial_probe+0x2e/0x40 drivers/base/dd.c:1057
 bus_probe_device+0x13c/0x3b0 drivers/base/bus.c:487
 device_add+0x1d4b/0x26c0 drivers/base/core.c:3479
 usb_new_device+0x17ac/0x2370 drivers/usb/core/hub.c:2576
 hub_port_connect drivers/usb/core/hub.c:5408 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5552 [inline]
 port_event drivers/usb/core/hub.c:5712 [inline]
 hub_event+0x56f3/0x7660 drivers/usb/core/hub.c:5794
 process_one_work+0xb27/0x13e0 kernel/workqueue.c:2289
 worker_thread+0x1076/0x1d60 kernel/workqueue.c:2436
 kthread+0x31b/0x430 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308

Local variable act_len created at:
 kalmia_send_init_packet+0x4e/0x5f0 drivers/net/usb/kalmia.c:64
 kalmia_init_and_get_ethernet_addr drivers/net/usb/kalmia.c:113 [inline]
 kalmia_bind+0x2fd/0x5a0 drivers/net/usb/kalmia.c:148

CPU: 1 PID: 4675 Comm: kworker/1:3 Not tainted 6.2.0-rc5-syzkaller-80200-g41c66f470616 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
Workqueue: usb_hub_wq hub_event
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
