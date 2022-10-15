Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDE05FFBCF
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 21:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiJOTvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 15:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiJOTvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 15:51:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFAA3340C
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 12:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665863461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3dmRoCAbvHyB4s1yUnRmBVS7aeUXJ2qzFIadydzCF9Q=;
        b=dD272vkcItYg8Taf2bEh6Z9yNocpAg3jg5eZdyf//Z273buCFPsX6eiK1PMzfE7nBuEYyB
        XG+8fonOfMsk61hfryQQe/+Cs3jX3vWD8Z4MXZS4ytZcX5yHbYAkfS1JbFNwQhf5RTMx3b
        P9glHOByb4VH0u9k8P82ABA6t1hZcrI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-83-imvX-eOLNxKC3tMm7jC9Xw-1; Sat, 15 Oct 2022 15:50:59 -0400
X-MC-Unique: imvX-eOLNxKC3tMm7jC9Xw-1
Received: by mail-ed1-f71.google.com with SMTP id y10-20020a056402358a00b0045d5cf18d4cso1042499edc.17
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 12:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3dmRoCAbvHyB4s1yUnRmBVS7aeUXJ2qzFIadydzCF9Q=;
        b=EjUj7PC0rQg9E7zqCwUQb7LueX2HNkVlFxmxZicrkP5LMDFsypxvOSYfWoQPZdM+RA
         5gXrrMJjeMdiQHzZIAU8MjSb35s3lX6tuhTrbgWhJa1FvovNLEwwb4IO+NHz80AcJXNi
         8p3VCIlZ2XhVbDhpLLWHq4kefINRZte1pWWfSg+62nfGk8lOdP2rUqtWD1r8QaACbbj1
         Bu35VzHqB1TsGfq7QACPZy1XSZkyvK1O0Jn1gKI9US535PgotpFhfFAmx0sY5YoSWmog
         NrKolvfKEx9AHVusuR55Ko8+B+36SNWc1iL7+w6YcSf3+TR1MUuHVSJ47130fEQTaimB
         MBMA==
X-Gm-Message-State: ACrzQf2aP3FFHOgjC9Zu8WUi3BzwOyPd7HKlOkkP5TVReo5abxhkuVZo
        oFRwpT7PVeZJ0O2tsHETZa8EIoYe3xQpLrzT85SsWDqC97/kOsgR1ew0ZVHhC5bi9e9YIdS2pqd
        D05iWxxtUGXLTxcz/
X-Received: by 2002:a17:907:a073:b0:78d:51c4:5b8c with SMTP id ia19-20020a170907a07300b0078d51c45b8cmr2977993ejc.355.1665863458192;
        Sat, 15 Oct 2022 12:50:58 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4zlYvw9Wjs/reSHlqd3kKSBJ/ieaWY3Yf6XVCWg5t5vNB1U7SZKx76+1tHWkWJzFWg+DDkuQ==
X-Received: by 2002:a17:907:a073:b0:78d:51c4:5b8c with SMTP id ia19-20020a170907a07300b0078d51c45b8cmr2977972ejc.355.1665863457880;
        Sat, 15 Oct 2022 12:50:57 -0700 (PDT)
Received: from redhat.com ([2.54.171.110])
        by smtp.gmail.com with ESMTPSA id m3-20020a17090679c300b0077909095acasm3564039ejo.143.2022.10.15.12.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Oct 2022 12:50:57 -0700 (PDT)
Date:   Sat, 15 Oct 2022 15:50:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     syzbot <syzbot+4d0c5794bff07852726c@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [syzbot] net boot error: WARNING in cpumask_next_wrap
Message-ID: <20221015154817-mutt-send-email-mst@kernel.org>
References: <000000000000f4b06105eb17a6c8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000f4b06105eb17a6c8@google.com>
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 15, 2022 at 12:21:41PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    a1b6b102df03 Merge branch 'phylink_set_mac_pm'
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=179af0c2880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=85495c44a2c25446
> dashboard link: https://syzkaller.appspot.com/bug?extid=4d0c5794bff07852726c
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/d67c9cef7c77/disk-a1b6b102.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/708d1f638584/vmlinux-a1b6b102.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4d0c5794bff07852726c@syzkaller.appspotmail.com
> 
> ACPI: button: Sleep Button [SLPF]
> ACPI: \_SB_.LNKC: Enabled at IRQ 11
> virtio-pci 0000:00:03.0: virtio_pci: leaving for legacy driver
> ACPI: \_SB_.LNKD: Enabled at IRQ 10
> virtio-pci 0000:00:04.0: virtio_pci: leaving for legacy driver
> ACPI: \_SB_.LNKB: Enabled at IRQ 10
> virtio-pci 0000:00:06.0: virtio_pci: leaving for legacy driver
> virtio-pci 0000:00:07.0: virtio_pci: leaving for legacy driver
> N_HDLC line discipline registered with maxframe=4096
> Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> 00:03: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
> 00:04: ttyS1 at I/O 0x2f8 (irq = 3, base_baud = 115200) is a 16550A
> 00:05: ttyS2 at I/O 0x3e8 (irq = 6, base_baud = 115200) is a 16550A
> 00:06: ttyS3 at I/O 0x2e8 (irq = 7, base_baud = 115200) is a 16550A
> Non-volatile memory driver v1.3
> Linux agpgart interface v0.103
> ACPI: bus type drm_connector registered
> [drm] Initialized vgem 1.0.0 20120112 for vgem on minor 0
> [drm] Initialized vkms 1.0.0 20180514 for vkms on minor 1
> Console: switching to colour frame buffer device 128x48
> platform vkms: [drm] fb0: vkmsdrmfb frame buffer device
> usbcore: registered new interface driver udl
> brd: module loaded
> loop: module loaded
> zram: Added device: zram0
> null_blk: disk nullb0 created
> null_blk: module loaded
> Guest personality initialized and is inactive
> VMCI host device registered (name=vmci, major=10, minor=119)
> Initialized host personality
> usbcore: registered new interface driver rtsx_usb
> usbcore: registered new interface driver viperboard
> usbcore: registered new interface driver dln2
> usbcore: registered new interface driver pn533_usb
> nfcsim 0.2 initialized
> usbcore: registered new interface driver port100
> usbcore: registered new interface driver nfcmrvl
> Loading iSCSI transport class v2.0-870.
> scsi host0: Virtio SCSI HBA
> st: Version 20160209, fixed bufsize 32768, s/g segs 256
> Rounding down aligned max_sectors from 4294967295 to 4294967288
> db_root: cannot open: /etc/target
> slram: not enough parameters.
> ftl_cs: FTL header not found.
> wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
> wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
> eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
> MACsec IEEE 802.1AE
> tun: Universal TUN/TAP device driver, 1.6
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_check include/linux/cpumask.h:117 [inline]
> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next include/linux/cpumask.h:178 [inline]
> WARNING: CPU: 0 PID: 1 at include/linux/cpumask.h:110 cpumask_next_wrap+0x139/0x1d0 lib/cpumask.c:27
> Modules linked in:
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-syzkaller-11847-ga1b6b102df03 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/22/2022
> RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
> RIP: 0010:cpumask_check include/linux/cpumask.h:117 [inline]
> RIP: 0010:cpumask_next include/linux/cpumask.h:178 [inline]
> RIP: 0010:cpumask_next_wrap+0x139/0x1d0 lib/cpumask.c:27
> Code: df e8 8b 4a 3d f8 39 eb 77 64 e8 32 4e 3d f8 41 8d 6c 24 01 89 de 89 ef e8 74 4a 3d f8 39 dd 0f 82 54 ff ff ff e8 17 4e 3d f8 <0f> 0b e9 48 ff ff ff e8 0b 4e 3d f8 48 c7 c2 00 02 e2 8d 48 b8 00
> RSP: 0000:ffffc90000067920 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
> RDX: ffff88813fe50000 RSI: ffffffff893f1c59 RDI: 0000000000000004
> RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
> R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff8de20010
> FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000bc8e000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  virtnet_set_affinity+0x35a/0x750 drivers/net/virtio_net.c:2303
>  init_vqs drivers/net/virtio_net.c:3581 [inline]
>  init_vqs drivers/net/virtio_net.c:3567 [inline]
>  virtnet_probe+0x12ae/0x31e0 drivers/net/virtio_net.c:3884
>  virtio_dev_probe+0x577/0x870 drivers/virtio/virtio.c:305
>  call_driver_probe drivers/base/dd.c:560 [inline]
>  really_probe+0x249/0xb90 drivers/base/dd.c:639
>  __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
>  driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
>  __driver_attach+0x1d0/0x550 drivers/base/dd.c:1190
>  bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
>  bus_add_driver+0x4c9/0x640 drivers/base/bus.c:618
>  driver_register+0x220/0x3a0 drivers/base/driver.c:246
>  virtio_net_driver_init+0x93/0xd2 drivers/net/virtio_net.c:4090
>  do_one_initcall+0x13d/0x780 init/main.c:1303
>  do_initcall_level init/main.c:1376 [inline]
>  do_initcalls init/main.c:1392 [inline]
>  do_basic_setup init/main.c:1411 [inline]
>  kernel_init_freeable+0x6ff/0x788 init/main.c:1631
>  kernel_init+0x1a/0x1d0 init/main.c:1519
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>  </TASK>


#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git net


figure out why is syzbot triggering warnings

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7106932c6f88..3c1c16b43bbd 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2295,13 +2295,20 @@ static void virtnet_set_affinity(struct virtnet_info *vi)
 			0;
 	cpu = cpumask_first(cpu_online_mask);
 
+	printk(KERN_ERR "%s +%d : %s cpu %d num %d stride %d stragglers %d\n",
+	       __FILE__, __LINE__, __func__, cpu, num_cpu, stride, stragglers);
+
 	for (i = 0; i < vi->curr_queue_pairs; i++) {
 		group_size = stride + (i < stragglers ? 1 : 0);
+		printk(KERN_ERR "%s +%d : %s vq %d group_size %d",
+		       __FILE__, __LINE__, __func__, i, group_size);
 
 		for (j = 0; j < group_size; j++) {
 			cpumask_set_cpu(cpu, mask);
 			cpu = cpumask_next_wrap(cpu, cpu_online_mask,
 						nr_cpu_ids, false);
+			printk(KERN_ERR "%s +%d : %s groupindex %d cpu %d",
+			       __FILE__, __LINE__, __func__, j, group_size);
 		}
 		virtqueue_set_affinity(vi->rq[i].vq, mask);
 		virtqueue_set_affinity(vi->sq[i].vq, mask);
-- 
MST

