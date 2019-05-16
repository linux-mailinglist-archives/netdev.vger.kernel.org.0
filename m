Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F90420FC3
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 22:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727509AbfEPUvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 16:51:11 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:44969 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfEPUvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 16:51:11 -0400
Received: by mail-pg1-f201.google.com with SMTP id b24so2857973pgh.11
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 13:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=O0A3Y6O8QZ1jZo/IAcyQwbrOJctQs0ZeB/K1vYWmuBI=;
        b=V3SH9UWTXhecnBvY9y5BQamRei5+qE2Sfjc4eidha3qPpIUKiFC2Za/3ErpPsnlN8W
         2+YfB6DRHUxK86SVsJQ6HjeCgq/V+ywqPMuLW2kErg8FmTPzKnWZu3K3jboTADUzrV+/
         zJHSv1CG9E1NrqB6ZtXofWvgyI/BMJDpbHgRgfXupGEBoOI6rca9n+8JFme6U3Z9NyOf
         sil6q/xnC5ZppxoSW1dAZmXM51G91MNKXOu/ApqMaUGTEpL7g+Qw9gm8nm9uYsS0SrzG
         WOp24BXJeHc9i1WyrUKHdAnHDB8xbzO44RPj+JlDVuyfvKCTZDppOjyT6w8dy5JqtqQe
         uo/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=O0A3Y6O8QZ1jZo/IAcyQwbrOJctQs0ZeB/K1vYWmuBI=;
        b=WiZ/iZ6/szt59/VCOJFNXyNznM7TFqlpSrF6mG1fTKDe9fcu0WD2sosbFL4hWTE5nM
         FhNZDKu2Bfr935CUr6/adCb8S/YfjFebmlxmPzp06baff8/RnzTUPcT5QfWmXCxpSW2h
         ZBXtICCiKonpGbgkv+xTYf5ymyoKTaI5meOC0TNjEZdmTwPHQF/VaoMY9yiPotXJKp9i
         XpGzG/S1eTnOdwIOdwEIkp3G/trKX+WgG6JCBjQN9/oPTQK8oB8bTVRoaCDMx0mSJYQr
         MamVCIgmiBMKBzFF4phObWovLcp0p0V1SKQAyoW+SbNRRq5Ov/RnZ4VScFtElGUA9B6m
         dBoA==
X-Gm-Message-State: APjAAAUd1Vs0Z5gID4xT5l9KaKMhLHtVjRKV9AH3PC+NkGgJZAV+AkZe
        /WwSPeBxHZRZTWeBo5XRiK5i7hHLHN79Tcg=
X-Google-Smtp-Source: APXvYqwf41flQIat3KOIsyjjpw5N63ZvcHDik9EhfhYXCkBPgjXrtlDQs2OKDmjNAjHU9uyT/bCBM5OoUqnw6s4=
X-Received: by 2002:a63:7552:: with SMTP id f18mr49259106pgn.234.1558039869914;
 Thu, 16 May 2019 13:51:09 -0700 (PDT)
Date:   Thu, 16 May 2019 13:51:07 -0700
Message-Id: <20190516205107.222003-1-jemoreira@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH RESEND] vsock/virtio: Initialize core virtio vsock before
 registering the driver
From:   "Jorge E. Moreira" <jemoreira@google.com>
To:     linux-kernel@vger.kernel.org
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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
Cc: Stefano Garzarella <sgarzare@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Cc: netdev@vger.kernel.org
Cc: kernel-team@android.com
Cc: stable@vger.kernel.org [4.9+]
Signed-off-by: Jorge E. Moreira <jemoreira@google.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
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
2.21.0.1020.gf2820cf01a-goog

