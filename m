Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66CC42219A3
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:54:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgGPBxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:53:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgGPBxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 21:53:02 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF957C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 18:53:01 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so5140993ljj.10
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 18:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=6IRHDfYQeZ6b+25xrC/iB5LoB2soJJ0nVicjlrL/kGQ=;
        b=U66N5ORpBzl7q6da1cO0pL1zUUfg6JA/Y8ie6uRyP5dZMtSQ2C+GjvJXGXWF0EWIKn
         4DmAQC4Snl5BUnowxiU647w/Ndx1zkui9uCnj9hEK3Esvx70L5T/U+miejYrNfAr+57V
         irIt2uJsdBD6deqIASJGmzHUIggOVT4Wlb1TqdZ2vqFf0zX1czy0dJW4sFH0CErJ+Jvp
         ASqZzkoFTV72m0losX6WLIC7yO3CY3wRiL/wvoRXe1Guc5pqUnYOFxtNOw/gp5idjqPD
         Z4EEkymML22x31sJJIRLevCdwY2KAEhswNlYfqIjpYZm551jQjbGLbj+ERuvLFbvX2iP
         g5hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=6IRHDfYQeZ6b+25xrC/iB5LoB2soJJ0nVicjlrL/kGQ=;
        b=l+e+YVjGJq2gws4parEcMN39Cu4KtsytWyl4HaK4iQCKCOCACE1yHe8OZW8DfUPUZm
         rtZZfdUtE4w+OvO/QP5uv6XRYpCA0xy5fpAsRJ2eJQ3mTci5aoIu6IaF8pEp/JOAsOdx
         e+YEYwOtomBL8ycL/CIZHUv2Dy7Xd24HTE2Y9lQK64goRNTC/03Me7Y2ULIJHMdOs3e9
         9kyhIOkb9vlaYyQC92G7wNCA1JzQJ4LicmZcOuHfNDwsVA9ER+326S6j+oS1+W/oac0u
         fe2UDde08pQAWjMmgbNRjP0WIzdBwD4zUOmvie0jfBg4jUcC2Ngzve+wcatwHxKbsAFO
         JBgQ==
X-Gm-Message-State: AOAM531du4uh491LLx2sZv8gX2okc1F/KYOArwAUaGeMteNDKCTVQYW9
        rp3RkuU0wdaAdjIrceGN4bwUk41PawEq500mbR2o5NQhGOM=
X-Google-Smtp-Source: ABdhPJwLh2D2aNFmMkcuj2o3311qpwdjAZpUoaejoS+rLs2W8U/SkRTnFbd42fl7lOxrBWR8V6X0SIZt+6R71H/w2Fk=
X-Received: by 2002:a2e:9dd6:: with SMTP id x22mr856869ljj.199.1594864379719;
 Wed, 15 Jul 2020 18:52:59 -0700 (PDT)
MIME-Version: 1.0
From:   Rajendra Dendukuri <rajen83@gmail.com>
Date:   Wed, 15 Jul 2020 21:52:48 -0400
Message-ID: <CAN1eFqhXQzJ2LAjhhAUoMccf1tLtrZ0QTFgHhkeuSg+0LfQiMQ@mail.gmail.com>
Subject: BUG_ON observed in kmalloc during alloc_skb()
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Observed below kernel BUG_ON in slab.c while using "Debian
4.9.189-3+deb9u2" on an x86 platform.

This was observed when the device was being rebooted while a packet
storm was in progress and the packets were still in-flight in the
network device driver. netdev_alloc_skb() was being done to send the
packet to the kernel IP stack. I also have a vmcore available but I am
not able to find anything useful. I observed this only once, but
wanted to put it out there for wider consumption. Any feedback would
be greatly appreciated.

[121568.845041] kernel BUG at
/sonic/src/sonic-linux-kernel/linux-4.9.189/mm/slab.c:2984!
[121568.853896] invalid opcode: 0000 1 SMP
[121568.858474] Modules linked in: binfmt_misc xt_mac macvlan
team_mode_loadbalance team xt_mark vxlan ip6_udp_tunnel udp_tunnel
8021q garp mrp dummy vrf iptable_mangle xt_TCPMSS ip6table_mangle at24
nvmem_core lm75 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4
xt_tcpudp ip6table_filter ip6_tables optoe accton_as7726_32x_psu(O)
accton_as7726_32x_leds(O) accton_as7726_32x_fan(O)
accton_as7726_32x_cpld(O) ym2651y(O) i2c_mux_pca954x i2c_mux
xt_conntrack nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo
linux_knet_cb(O) psample(O) linux_bcm_knet(O) linux_user_bde(O)
linux_kernel_bde(O) bonding intel_rapl sb_edac edac_core
x86_pkg_temp_thermal i2c_dev intel_powerclamp coretemp kvm_intel kvm
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel iTCO_wdt
iTCO_vendor_support intel_cstate gpio_ich evdev mxm_wmi intel_uncore
intel_rapl_perf ioatdma mei_me lpc_ich intel_pch_thermal sg mfd_core
mei shpchp ebtable_broute bridge stp wmi llc ebtable_nat
ebtable_filter ebtables acpi_pad button iptable_filter iptable_nat
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack
ip_tables x_tables autofs4 loop ext4 crc16 jbd2 crc32c_generic
fscrypto ecb mbcache nls_utf8 nls_cp437 nls_ascii vfat fat overlay
squashfs sd_mod crc32c_intel aesni_intel aes_x86_64 ahci glue_helper
lrw gf128mul ablk_helper cryptd libahci xhci_pci ehci_pci ehci_hcd
xhci_hcd libata ixgbe(O) i2c_i801 scsi_mod i2c_smbus tg3 usbcore
libphy usb_common dca ptp pps_core
[121569.001571] CPU: 7 PID: 5807 Comm: ip Tainted: G O
4.9.0-11-2-amd64 #1 Debian 4.9.189-3+deb9u2
[121569.012557] Hardware name: Accton AS7726-32X/AS7726-32X, BIOS
AS7726 V36 20180806 08/06/2018
[121569.022086] task: ffff9786b925b140 task.stack: ffffb2a8c3734000
[121569.028799] RIP: 0010:[<ffffffffb63e9363>] [<ffffffffb63e9363>]
kmem_cache_alloc_node_trace+0x553/0x5a0
[121569.039506] RSP: 0000:ffff9787bfdc3cc0 EFLAGS: 00010086
[121569.045537] RAX: 0000000000000001 RBX: ffff9787bf001700 RCX:
ffff9787bf0006c0
[121569.053611] RDX: ffff9787bf001708 RSI: 0000000000000000 RDI:
ffff9787bf001700
[121569.061683] RBP: ffff9787bf0006c0 R08: 0000000000000001 R09:
0000000000000004
[121569.069756] R10: 0000000000000000 R11: 00000000000000fa R12:
0000000000000004
[121569.077828] R13: ffff9787bfddbc90 R14: ffffe2de445b5f00 R15:
ffff9787bf0006c0
[121569.085901] FS: 00007fb6aba7a700(0000) GS:ffff9787bfdc0000(0000)
knlGS:0000000000000000
[121569.095042] CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[121569.101559] CR2: 00007f502e7f15d8 CR3: 00000003e4c64000 CR4:
0000000000360670
[121569.109631] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[121569.117701] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[121569.125772] Stack:
[121569.128111] 0000000000000000 d58a38ae00000000 0000000000000046
ffff9787bf001700
[121569.136494] 00000000a6333000 ffff9787bfddbc90 ffff9787bf001708
ffff9787bf001718
[121569.144867] ffffffff02090220 ffff9787bf0006c0 ffffffff02090220
0000000000002600
[121569.153242] Call Trace:
[121569.156069] <IRQ> [121569.158314] [<ffffffffb66e2e1e>] ?
__kmalloc_reserve.isra.35+0x2e/0x80
[121569.165807] [<ffffffffb66e3d92>] ? __alloc_skb+0x82/0x1c0
[121569.172032] [<ffffffffb66ea39c>] ? __netdev_alloc_skb+0x3c/0x110
[121569.178938] [<ffffffffb66c2210>] ? get_target_pstate_use_cpu_load+0x90/0x90
[121569.186915] [<ffffffffc0885632>] ? bkn_rx_refill+0xd8/0x300 [linux_bcm_knet]
[121569.194988] [<ffffffffc0886094>] ? bkn_rxtick+0x172/0x1ae [linux_bcm_knet]
[121569.202865] [<ffffffffc0885f22>] ? bkn_rx_restart+0xf4/0xf4 [linux_bcm_knet]
[121569.210939] [<ffffffffb62e9702>] ? call_timer_fn+0x32/0x120
[121569.217359] [<ffffffffb62e9a77>] ? run_timer_softirq+0x1d7/0x430
[121569.224266] [<ffffffffb62fabe0>] ? tick_sched_do_timer+0x30/0x30
[121569.231174] [<ffffffffb653ce14>] ? timerqueue_add+0x54/0xa0
[121569.237595] [<ffffffffb62eb768>] ? enqueue_hrtimer+0x38/0x80
[121569.244114] [<ffffffffb68086ed>] ? __do_softirq+0x10d/0x2b0
[121569.250535] [<ffffffffb62812a2>] ? irq_exit+0xc2/0xd0
[121569.256372] [<ffffffffb680816c>] ? smp_apic_timer_interrupt+0x4c/0x60
[121569.263764] [<ffffffffb680689e>] ? apic_timer_interrupt+0x9e/0xb0
[121569.270765] <EOI> [121569.273006] Code:
00 48 29 46 40 e9 d3 fe ff ff 48 8b 53 18 48 8b 74 24 38 4c 89 ff e8
2d 94 16 00 f6 45 23 40 74 ae 49 c7 46 10 00 00 00 00 eb a4 <0f> 0b 0f
0b 48 8b 74 24 18 48 89 cf 44 89 ea 44 89 4c 24 28 48
[121569.294762] RIP [<ffffffffb63e9363>] kmem_cache_alloc_node_trace+0x553/0x5a0
[121569.302835] RSP <ffff9787bfdc3cc0>
[ 0.000000] Linux version 4.9.0-11-2-amd64
(debian-kernel@lists.debian.org) (gcc version 6.3.0 20170516 (Debian
6.3.0-
