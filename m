Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14F781296D7
	for <lists+netdev@lfdr.de>; Mon, 23 Dec 2019 15:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfLWOJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Dec 2019 09:09:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50914 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726682AbfLWOJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Dec 2019 09:09:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577110181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=8wSK42OvcMSYxzTS5duA9YklNAevUjxL3z2LLorLBbc=;
        b=hZYzE9EIz8inPRLZQ2aTR5kVWqEGj2IE1eG3AAgctoc1PtFvQuOFTz0vYQyH2H6rCmXkrz
        PFEuDRm+/hNeBeLw9rqTap2f99yUPNSLQE3OMubK9th4YAwWlh2j2HhzYlAOlx/eixK2yH
        q6QzoKfgJGGDXwRk/e+Ua5QbWtWzV4Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-396-fdbSeSW-OCmTulhr2y-yGw-1; Mon, 23 Dec 2019 09:09:39 -0500
X-MC-Unique: fdbSeSW-OCmTulhr2y-yGw-1
Received: by mail-wm1-f70.google.com with SMTP id p2so339263wma.3
        for <netdev@vger.kernel.org>; Mon, 23 Dec 2019 06:09:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=8wSK42OvcMSYxzTS5duA9YklNAevUjxL3z2LLorLBbc=;
        b=CwJPRKq1/SZrjpoi3CHLzCc1mXWmYW3SWOiCbvaxUn7KPznZ6cFHNpDR7lMQH8sMdR
         wlUiHDHItQysoT8ylCBKCs9suOnb8j494Z7dC0BYUpnGXaQvAYfKtP9gw7PFiaceSViH
         i0wCMRxprhx8Qqns20jMEL11YpYNCynqLuINr6QTFsDPJSv65FlgVEGSFmGkjhKoHYES
         9a1bMM8QASRWOdz7F3QHohXVmkWs8gGqNmo/NBUiH1Qo3mLZpNfyrCGDidbRM1sBztjz
         u8BWhkLIiBqqQJBwVOFEfF+boznoMegCPGKuJ/HSbK1vYNsLW3r57EH5JY5HzDB4oy+c
         QS1Q==
X-Gm-Message-State: APjAAAWjs1bfxTd9qMNQkkfErAIeBGFofXbzjWNPLZWdUMk5LRdM7kE+
        p7+N8APH1GfLppbHcFbngeSKf3kxoSLPqKF8hSZrz/Levnf15MWfHX8Qw+tBZgFhTiEP2ocrGFp
        eBhWfTt0/DeOw96XD
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr30639412wrw.289.1577110178507;
        Mon, 23 Dec 2019 06:09:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqyXPlHQPWOIs3ZB1650CiD1GjAVkKpoGAxT4H78hPBH+Xf/qPuoSksNwmAZoix5LwHVpqbXpA==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr30639395wrw.289.1577110178271;
        Mon, 23 Dec 2019 06:09:38 -0800 (PST)
Received: from redhat.com (bzq-109-64-31-13.red.bezeqint.net. [109.64.31.13])
        by smtp.gmail.com with ESMTPSA id u14sm20878457wrm.51.2019.12.23.06.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 06:09:37 -0800 (PST)
Date:   Mon, 23 Dec 2019 09:09:35 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Alistair Delva <adelva@google.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH net] virtio_net: CTRL_GUEST_OFFLOADS depends on CTRL_VQ
Message-ID: <20191223140322.20013-1-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email 2.24.1.751.gd10ce2899c
X-Mutt-Fcc: =sent
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The only way for guest to control offloads (as enabled by
VIRTIO_NET_F_CTRL_GUEST_OFFLOADS) is by sending commands
through CTRL_VQ. So it does not make sense to
acknowledge VIRTIO_NET_F_CTRL_GUEST_OFFLOADS without
VIRTIO_NET_F_CTRL_VQ.

The spec does not outlaw devices with such a configuration,
but Linux assumed that with VIRTIO_NET_F_CTRL_GUEST_OFFLOADS
control vq is always there, resulting in the following crash
when configuring LRO:

kernel BUG at drivers/net/virtio_net.c:1591!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
CPU: 1 PID: 483 Comm: Binder:330_1 Not tainted 5.4.5-01326-g19463e9acaac #1
Hardware name: ChromiumOS crosvm, BIOS 0
RIP: 0010:virtnet_send_command+0x15d/0x170 [virtio_net]
Code: d8 00 00 00 80 78 02 00 0f 94 c0 65 48 8b 0c 25 28 00 00 00 48 3b 4c 24 70 75 11 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d
+c3 <0f> 0b e8 ec a4 12 c8 66 90 66 2e 0f 1f 84 00 00 00 00 00 55 48 89
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

A similar crash will likely trigger when enabling XDP.

Reported-by: Alistair Delva <adelva@google.com>
Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Fixes: 3f93522ffab2 ("virtio-net: switch off offloads on demand if possible on XDP set")
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Lightly tested.

Alistair, could you please test and confirm that this resolves the
crash for you?

Dave, after testing confirms the fix, pls queue up for stable.


 drivers/net/virtio_net.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434cc5d..7b8805b47f0d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2971,6 +2971,15 @@ static int virtnet_validate(struct virtio_device *vdev)
 	if (!virtnet_validate_features(vdev))
 		return -EINVAL;
 
+	/* VIRTIO_NET_F_CTRL_GUEST_OFFLOADS does not work without
+	 * VIRTIO_NET_F_CTRL_VQ. However the virtio spec does not
+	 * specify that VIRTIO_NET_F_CTRL_GUEST_OFFLOADS depends
+	 * on VIRTIO_NET_F_CTRL_VQ so devices can set the later but
+	 * not the former.
+	 */
+	if (!virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_VQ))
+			__virtio_clear_bit(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS);
+
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MTU)) {
 		int mtu = virtio_cread16(vdev,
 					 offsetof(struct virtio_net_config,
-- 
MST

