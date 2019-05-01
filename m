Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2013C1037D
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 02:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbfEAAaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 20:30:05 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:51997 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfEAAaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 20:30:05 -0400
Received: by mail-ua1-f73.google.com with SMTP id r36so903620uar.18
        for <netdev@vger.kernel.org>; Tue, 30 Apr 2019 17:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rvnnbDmsOgJ3xr/PffPc0gbHg8YSZc9QHWS8F5/zrz0=;
        b=ouhDZAWcHKtKyngvM68oiibCChzMbcqbVGPz4YuQdwYUPFM4ynjce1cPHtBKp+HrJh
         SHEg0bopCTTpmijYzKAlX8Hcvt4WTS9mmBRQwZ7OrOC4nW18Hc8PgqA88LbKdWg67BtN
         22pvwxMyiNDPQkTaWYwf3FnpZXnWVlDML2Inls7H2lUgAccqN5vm2Ya7DA8PVn9h21Ui
         zEvGZzs13JPe3YwreavZZvdN4kH5gkrMGNsTmYTqYOKpf1gFMDSlKxTfZvtf/bwAXEBG
         lGz9Vp/KNDxebfL8M2UvekoKUhgIq86pq8LiZF629VUUGzYosazpZdvAB0/NWRarQ9aI
         QFgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rvnnbDmsOgJ3xr/PffPc0gbHg8YSZc9QHWS8F5/zrz0=;
        b=JHF+Aew6CBxZH1bXDz48P1G5rLXjVoZwHrJdvZ8+cnus/TGukS9R9j2NH/sxRy6zrM
         CfvZoLQ14rgzTx+ivCE1TcC5uya1JpJYiba1AIQpYKyevWLUlUOHS6jthHslhyzkx0B6
         eOTPWWX+5qKzWDLnc+Gyw9/fo4NzY/Yx0f+EszoiGvNhuMtdYQGDETU09h7igPB8+ZaX
         VONGFcRdsSHLCRSusnzGFqA5lUXq3bi6oz/uyOoWGgxNxy0X+l5m+vAHiMK7n3HBPzzn
         mge/wOvbdti2IReYQJbwfwJ7bslWZYGYRxu7A3TLnASYOahWf9PQqPqBNTevfiASechZ
         MCaw==
X-Gm-Message-State: APjAAAVRk+axvsFpqD8fvQEC/xAYba9/Wlq9JhKHqOQXbvtS63/H0Pdk
        u2rJ6qWelvgEjsvfVfEXzvuJcdr9cO6H/mo=
X-Google-Smtp-Source: APXvYqxS/RD69FJkWFky/f1r4LGDC/KcN/ZgqbnWKDp6CV3L9ulYeepm2htYaXuH9V02y1lY6qy0VpnQ+LgxkHE=
X-Received: by 2002:a67:f695:: with SMTP id n21mr2835367vso.19.1556670604001;
 Tue, 30 Apr 2019 17:30:04 -0700 (PDT)
Date:   Tue, 30 Apr 2019 17:30:01 -0700
Message-Id: <20190501003001.186239-1-jemoreira@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.593.g511ec345e18-goog
Subject: [PATCH] vsock/virtio: Initialize core virtio vsock before registering
 the driver
From:   "Jorge E. Moreira" <jemoreira@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Avoid a race in which static variables in net/vmw_vsock/af_vsock.c are
accessed (while handling interrupts) before they are initialized.

[    4.201410] BUG: unable to handle kernel paging request at ffffffffffffffe8
[    4.207829] IP: vsock_addr_equals_addr+0x3/0x20
[    4.211379] PGD 28210067 P4D 28210067 PUD 28212067 PMD 0
[    4.211379] Oops: 0000 [#1] PREEMPT SMP PTI
[    4.211379] Modules linked in:
[    4.211379] CPU: 1 PID: 30 Comm: kworker/1:1 Not tainted 4.14.106-419297-gd7e28cc1f241 #1
[    4.211379] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.10.2-1 04/01/2014
[    4.211379] Workqueue: virtio_vsock virtio_transport_rx_work
[    4.211379] task: ffffa3273d175280 task.stack: ffffaea1800e8000
[    4.211379] RIP: 0010:vsock_addr_equals_addr+0x3/0x20
[    4.211379] RSP: 0000:ffffaea1800ebd28 EFLAGS: 00010286
[    4.211379] RAX: 0000000000000002 RBX: 0000000000000000 RCX: ffffffffb94e42f0
[    4.211379] RDX: 0000000000000400 RSI: ffffffffffffffe0 RDI: ffffaea1800ebdd0
[    4.211379] RBP: ffffaea1800ebd58 R08: 0000000000000001 R09: 0000000000000001
[    4.211379] R10: 0000000000000000 R11: ffffffffb89d5d60 R12: ffffaea1800ebdd0
[    4.211379] R13: 00000000828cbfbf R14: 0000000000000000 R15: ffffaea1800ebdc0
[    4.211379] FS:  0000000000000000(0000) GS:ffffa3273fd00000(0000) knlGS:0000000000000000
[    4.211379] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    4.211379] CR2: ffffffffffffffe8 CR3: 000000002820e001 CR4: 00000000001606e0
[    4.211379] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    4.211379] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    4.211379] Call Trace:
[    4.211379]  ? vsock_find_connected_socket+0x6c/0xe0
[    4.211379]  virtio_transport_recv_pkt+0x15f/0x740
[    4.211379]  ? detach_buf+0x1b5/0x210
[    4.211379]  virtio_transport_rx_work+0xb7/0x140
[    4.211379]  process_one_work+0x1ef/0x480
[    4.211379]  worker_thread+0x312/0x460
[    4.211379]  kthread+0x132/0x140
[    4.211379]  ? process_one_work+0x480/0x480
[    4.211379]  ? kthread_destroy_worker+0xd0/0xd0
[    4.211379]  ret_from_fork+0x35/0x40
[    4.211379] Code: c7 47 08 00 00 00 00 66 c7 07 28 00 c7 47 08 ff ff ff ff c7 47 04 ff ff ff ff c3 0f 1f 00 66 2e 0f 1f 84 00 00 00 00 00 8b 47 08 <3b> 46 08 75 0a 8b 47 04 3b 46 04 0f 94 c0 c3 31 c0 c3 90 66 2e
[    4.211379] RIP: vsock_addr_equals_addr+0x3/0x20 RSP: ffffaea1800ebd28
[    4.211379] CR2: ffffffffffffffe8
[    4.211379] ---[ end trace f31cc4a2e6df3689 ]---
[    4.211379] Kernel panic - not syncing: Fatal exception in interrupt
[    4.211379] Kernel Offset: 0x37000000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[    4.211379] Rebooting in 5 seconds..

Fixes: 22b5c0b63f32 ("vsock/virtio: fix kernel panic after device hot-unplug")
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: kernel-team@android.com
Cc: stable@vger.kernel.org [4.9+]
Signed-off-by: Jorge E. Moreira <jemoreira@google.com>
---
 net/vmw_vsock/virtio_transport.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index 15eb5d3d4750..96ab344f17bb 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -702,28 +702,27 @@ static int __init virtio_vsock_init(void)
 	if (!virtio_vsock_workqueue)
 		return -ENOMEM;
 
-	ret = register_virtio_driver(&virtio_vsock_driver);
+	ret = vsock_core_init(&virtio_transport.transport);
 	if (ret)
 		goto out_wq;
 
-	ret = vsock_core_init(&virtio_transport.transport);
+	ret = register_virtio_driver(&virtio_vsock_driver);
 	if (ret)
-		goto out_vdr;
+		goto out_vci;
 
 	return 0;
 
-out_vdr:
-	unregister_virtio_driver(&virtio_vsock_driver);
+out_vci:
+	vsock_core_exit();
 out_wq:
 	destroy_workqueue(virtio_vsock_workqueue);
 	return ret;
-
 }
 
 static void __exit virtio_vsock_exit(void)
 {
-	vsock_core_exit();
 	unregister_virtio_driver(&virtio_vsock_driver);
+	vsock_core_exit();
 	destroy_workqueue(virtio_vsock_workqueue);
 }
 
-- 
2.21.0.593.g511ec345e18-goog

