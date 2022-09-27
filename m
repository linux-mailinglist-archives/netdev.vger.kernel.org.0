Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437B65ED023
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 00:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiI0WTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 18:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbiI0WTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 18:19:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11411E45BB
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 15:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664317160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sPkv0tXRBGRFHsPE4skY8laZ5MwDJA/XEqh88B2Acpo=;
        b=BNDuUZWoR0kkzRvHy7Ng0+oo+mnjYSRg7nzc2qQml4khxzOBULpUOK3M37NX1JIr+j2zTD
        xENv7ygyKR131xi1803M2B+VKmNW1vMnt5G6UEOk/ni27E4zPQIUrwOX5boor9g+PjGsX7
        Pr33SCGRL0k5GTkKAMPbmffuR8qwleA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-477-VTBRsBNnNmGSh1hKgYVZUQ-1; Tue, 27 Sep 2022 18:19:13 -0400
X-MC-Unique: VTBRsBNnNmGSh1hKgYVZUQ-1
Received: by mail-wm1-f69.google.com with SMTP id n32-20020a05600c3ba000b003b5054c71faso25254wms.9
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 15:19:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=sPkv0tXRBGRFHsPE4skY8laZ5MwDJA/XEqh88B2Acpo=;
        b=0rfqLIj1udeqIMFX+26PlEHlP1QMyCrXJkeO4kHhzifO19232xejyvgKl96coGu5eK
         ZxjPhv+NWQW+eOzv2vlQJh36WjiHumRJTGvfYq5m8NWRX8cio6Vh+cjYEJfCAXqdIAT2
         U7tyQssFxuhVhodGLFNnYudR6mjaMQj/OHkS1/G85wN+tC+4kXjUSMMftGQC02ayCXmI
         n0Tn+xdOKCT9bt3QuNLGC7g4gLx/HWg8MsPbJURoZyu5R244P4RZLIK7SfE4JkZD7cws
         KOiLSklpmAv8CbyTcfoE2tWPHaaAXM5QRo8OQawnGp+x6jJN7cpHKTuRFP9yraQlaQ1m
         JiSQ==
X-Gm-Message-State: ACrzQf2j4WX2ckt+O6276B5Io77WSAP4wZLxOTUeTVgUIR94AqeTRw8W
        zDejCZ6KK3XyD0JhnLtBi7qkpq8Yj40spn9ZJDRibkvBl0/+ezKa6mwT1RlAGF13a7ZRP/kbFJ0
        gFmNKlXJ4SMH4D5lC
X-Received: by 2002:a7b:cb49:0:b0:3b4:b08a:89b with SMTP id v9-20020a7bcb49000000b003b4b08a089bmr4264630wmj.173.1664317152725;
        Tue, 27 Sep 2022 15:19:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4yVAuON4IWBfCSPhgaypPYe4TWmLMMFvQJVnsSDJhPqJfgdzcdmJoPl9f9OuBfTy70adiwkA==
X-Received: by 2002:a7b:cb49:0:b0:3b4:b08a:89b with SMTP id v9-20020a7bcb49000000b003b4b08a089bmr4264604wmj.173.1664317152467;
        Tue, 27 Sep 2022 15:19:12 -0700 (PDT)
Received: from redhat.com ([2.55.47.213])
        by smtp.gmail.com with ESMTPSA id d37-20020a05600c4c2500b003b332a7b898sm2561817wmp.45.2022.09.27.15.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 15:19:11 -0700 (PDT)
Date:   Tue, 27 Sep 2022 18:19:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     syzbot <syzbot+21da700f3c9f0bc40150@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, edumazet@google.com, hawk@kernel.org,
        jasowang@redhat.com, john.fastabend@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org, hch@lst.de
Subject: Re: [syzbot] linux-next boot error: WARNING in cpumask_next_wrap
Message-ID: <20220927181728-mutt-send-email-mst@kernel.org>
References: <000000000000dfa4f105e9af8c54@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000dfa4f105e9af8c54@google.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 27, 2022 at 02:44:35PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    1bd8b75fe6ad Add linux-next specific files for 20220927
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=109d3404880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fab8618a7c989c9d
> dashboard link: https://syzkaller.appspot.com/bug?extid=21da700f3c9f0bc40150
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/b150a04debdc/disk-1bd8b75f.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2bf7d4b812bc/vmlinux-1bd8b75f.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+21da700f3c9f0bc40150@syzkaller.appspotmail.com
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
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.0.0-rc7-next-20220927-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
> RIP: 0010:cpu_max_bits_warn include/linux/cpumask.h:110 [inline]
> RIP: 0010:cpumask_check include/linux/cpumask.h:117 [inline]
> RIP: 0010:cpumask_next include/linux/cpumask.h:178 [inline]
> RIP: 0010:cpumask_next_wrap+0x139/0x1d0 lib/cpumask.c:27
> Code: df e8 1b 07 3e f8 39 eb 77 64 e8 c2 0a 3e f8 41 8d 6c 24 01 89 de 89 ef e8 04 07 3e f8 39 dd 0f 82 54 ff ff ff e8 a7 0a 3e f8 <0f> 0b e9 48 ff ff ff e8 9b 0a 3e f8 48 c7 c2 00 ae e1 8d 48 b8 00
> RSP: 0000:ffffc90000067920 EFLAGS: 00010293
> RAX: 0000000000000000 RBX: 0000000000000002 RCX: 0000000000000000
> RDX: ffff88813fe50000 RSI: ffffffff893e3c59 RDI: 0000000000000004
> RBP: 0000000000000002 R08: 0000000000000004 R09: 0000000000000002
> R10: 0000000000000002 R11: 0000000000000000 R12: 0000000000000001
> R13: 0000000000000000 R14: 0000000000000002 R15: ffffffff8de1ac10
> FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000bc8e000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  virtnet_set_affinity+0x35a/0x750 drivers/net/virtio_net.c:2300



Also related to affinity things?
I wonder what does virtio do wrong?


>  init_vqs drivers/net/virtio_net.c:3578 [inline]
>  init_vqs drivers/net/virtio_net.c:3564 [inline]
>  virtnet_probe+0x110f/0x2ea0 drivers/net/virtio_net.c:3868
>  virtio_dev_probe+0x577/0x870 drivers/virtio/virtio.c:305
>  call_driver_probe drivers/base/dd.c:560 [inline]
>  really_probe+0x249/0xb90 drivers/base/dd.c:639
>  __driver_probe_device+0x1df/0x4d0 drivers/base/dd.c:778
>  driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:808
>  __driver_attach+0x1d0/0x550 drivers/base/dd.c:1190
>  bus_for_each_dev+0x147/0x1d0 drivers/base/bus.c:301
>  bus_add_driver+0x4c9/0x640 drivers/base/bus.c:618
>  driver_register+0x220/0x3a0 drivers/base/driver.c:246
>  virtio_net_driver_init+0x93/0xd2 drivers/net/virtio_net.c:4074
>  do_one_initcall+0x13d/0x780 init/main.c:1306
>  do_initcall_level init/main.c:1381 [inline]
>  do_initcalls init/main.c:1397 [inline]
>  do_basic_setup init/main.c:1416 [inline]
>  kernel_init_freeable+0x6ff/0x788 init/main.c:1636
>  kernel_init+0x1a/0x1d0 init/main.c:1524
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
>  </TASK>
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

