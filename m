Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCDFA1283D1
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 22:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfLTVWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 16:22:10 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:55395 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727473AbfLTVWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 16:22:10 -0500
Received: by mail-pg1-f202.google.com with SMTP id v30so5840552pga.22
        for <netdev@vger.kernel.org>; Fri, 20 Dec 2019 13:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=r9lHUhVFmnwnvOI5+OYOqNbrR4sRrsu0Lvjkysu9m60=;
        b=VccLePC7IXuSG66sx0PbhNexga6fWcYCg7SXxnBD8scdmE77qzrp8kF5tiLoxIvGyZ
         cgK70KJ/9brCj7xNGnxcD5GmiI3v95REtyIFZKcDUNcjClkCij1om62AJlI1ZIJSwm4r
         VyLinh19pG1DNbeVj+CrqjyWjdPG57HVKg/ApLWg8GY1NIEIlrb7IwGrAWzZw4AI/CU0
         5RMbSPsGxtHhlNDlvmajf1daaT8ueDprlX322nqjNm/3N3yqswVvHXR338cTdHW8DZbe
         77MdGvRoDccK14cs3eCsPZcP1Q1GcXGUFCrwA0WrabkD+Xv9iQ1zQ2h96D2vbpGsc6Os
         Id/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=r9lHUhVFmnwnvOI5+OYOqNbrR4sRrsu0Lvjkysu9m60=;
        b=h/iSIJTvtl5agDswc9PYg3zBHDKa3D2W7UP6+OMCjRlOYjFtRuaC0VB40+U0S5JjZC
         KBt2aVGx9ukQa4KYDQojMBOZhqrSTkowtZAgqRxBUbGxkIEy7iOEkHIoUUPZeCq385P1
         U8Jv258JKa5Z7ImmL+yZMwQipJ6E0NNZ5IA1Osp78qqKt5qSwpBGKr5qJYf0f2BiDcBb
         qUDreqJ5lqdXXvPIT3aw+YNdsosOXt0rIXIUbD7qjlK51lr74qYRLAr7TlrdoUrKwrdO
         ByrbdQ0Yj9jeQ/MsYisr87d9xUWignj3uVyff1rxMipHs2Mx+fmXGRqXQYbTXt3eZzh6
         3iqg==
X-Gm-Message-State: APjAAAW1IYsUtyAVV8RxAiJlMX7tGTdVo4t9t/mraw1R4UI6iR+pZlfu
        92TaV2lj6Rr7TGYdC0oauu8fAj83ctrOJMyWxxH7Sjh6fmGdZVWos9csal3Yf9UqwoLYE/GWUXu
        fqOAFl6egab7i2Iv8Tl0iy/ePQK7vlryXMAHWfIWmk8nd/geCx/reSZz7dvhLfw==
X-Google-Smtp-Source: APXvYqzAyuXgHTXrORNS6szcAloXE1fh1IDUxk+eoYefkB4yiERkk+yPhmXzgc5nXJYrKSjHf0NpTIjsDAA=
X-Received: by 2002:a63:bc01:: with SMTP id q1mr18010589pge.442.1576876929534;
 Fri, 20 Dec 2019 13:22:09 -0800 (PST)
Date:   Fri, 20 Dec 2019 13:22:07 -0800
Message-Id: <20191220212207.76726-1-adelva@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH net] virtio-net: Skip set_features on non-cvq devices
From:   Alistair Delva <adelva@google.com>
To:     netdev@vger.kernel.org
Cc:     stable@vger.kernel.org, "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S . Miller" <davem@davemloft.net>, kernel-team@android.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On devices without control virtqueue support, such as the virtio_net
implementation in crosvm[1], attempting to configure LRO will panic the
kernel:

kernel BUG at drivers/net/virtio_net.c:1591!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
CPU: 1 PID: 483 Comm: Binder:330_1 Not tainted 5.4.5-01326-g19463e9acaac #1
Hardware name: ChromiumOS crosvm, BIOS 0
RIP: 0010:virtnet_send_command+0x15d/0x170 [virtio_net]
Code: d8 00 00 00 80 78 02 00 0f 94 c0 65 48 8b 0c 25 28 00 00 00 48 3b 4c 24 70 75 11 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 <0f> 0b e8 ec a4 12 c8 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
RSP: 0018:ffffb97940e7bb50 EFLAGS: 00010246
RAX: ffffffffc0596020 RBX: ffffa0e1fc8ea840 RCX: 0000000000000017
RDX: ffffffffc0596110 RSI: 0000000000000011 RDI: 000000000000000d
RBP: ffffb97940e7bbf8 R08: ffffa0e1fc8ea0b0 R09: ffffa0e1fc8ea0b0
R10: ffffffffffffffff R11: ffffffffc0590940 R12: 0000000000000005
R13: ffffa0e1ffad2c00 R14: ffffb97940e7bc08 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffffa0e1fd100000(006b) knlGS:00000000e5ef7494
CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
CR2: 00000000e5eeb82c CR3: 0000000079b06001 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ? preempt_count_add+0x58/0xb0
 ? _raw_spin_lock_irqsave+0x36/0x70
 ? _raw_spin_unlock_irqrestore+0x1a/0x40
 ? __wake_up+0x70/0x190
 virtnet_set_features+0x90/0xf0 [virtio_net]
 __netdev_update_features+0x271/0x980
 ? nlmsg_notify+0x5b/0xa0
 dev_disable_lro+0x2b/0x190
 ? inet_netconf_notify_devconf+0xe2/0x120
 devinet_sysctl_forward+0x176/0x1e0
 proc_sys_call_handler+0x1f0/0x250
 proc_sys_write+0xf/0x20
 __vfs_write+0x3e/0x190
 ? __sb_start_write+0x6d/0xd0
 vfs_write+0xd3/0x190
 ksys_write+0x68/0xd0
 __ia32_sys_write+0x14/0x20
 do_fast_syscall_32+0x86/0xe0
 entry_SYSENTER_compat+0x7c/0x8e

This happens because virtio_set_features() does not check the presence
of the control virtqueue feature, which is sanity checked by a BUG_ON
in virtnet_send_command().

Fix this by skipping any feature processing if the control virtqueue is
missing. This should be OK for any future feature that is added, as
presumably all of them would require control virtqueue support to notify
the endpoint that offload etc. should begin.

[1] https://chromium.googlesource.com/chromiumos/platform/crosvm/

Fixes: a02e8964eaf9 ("virtio-net: ethtool configurable LRO")
Cc: stable@vger.kernel.org [4.20+]
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: kernel-team@android.com
Cc: virtualization@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Alistair Delva <adelva@google.com>
---
 drivers/net/virtio_net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434cc5d..709bcd34e485 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2560,6 +2560,9 @@ static int virtnet_set_features(struct net_device *dev,
 	u64 offloads;
 	int err;
 
+	if (!vi->has_cvq)
+		return 0;
+
 	if ((dev->features ^ features) & NETIF_F_LRO) {
 		if (vi->xdp_queue_pairs)
 			return -EBUSY;
-- 
2.24.1.735.g03f4e72817-goog

