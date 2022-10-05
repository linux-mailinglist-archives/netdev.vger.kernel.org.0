Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E935F5A1B
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 20:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiJEStg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Oct 2022 14:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231231AbiJESrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 14:47:53 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8327C2A247
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 11:47:51 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 4599614114E;
        Wed,  5 Oct 2022 20:47:49 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id 83n2JP0LuUnT; Wed,  5 Oct 2022 20:47:49 +0200 (CEST)
Received: from tglase.lan.tarent.de (tglase.lan.tarent.de [172.26.3.108])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id 2955F140EF0;
        Wed,  5 Oct 2022 20:47:49 +0200 (CEST)
Received: by tglase.lan.tarent.de (Postfix, from userid 2339)
        id DB6A222118A; Wed,  5 Oct 2022 20:47:48 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by tglase.lan.tarent.de (Postfix) with ESMTP id C1A8B221187;
        Wed,  5 Oct 2022 20:47:48 +0200 (CEST)
Date:   Wed, 5 Oct 2022 20:47:48 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Haye.Haehne@telekom.de
cc:     netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <FR2P281MB29596B8EA9AC8940C5A95B7690559@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
Message-ID: <daddd9a0-eb6c-6b93-8831-ddc45685234f@tarent.de>
References: <FR2P281MB2959684780DC911876D2465590419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <FR2P281MB2959EBC7E6CE9A1A8D01A01F90419@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de> <CAHNKnsQGwV9Z9dSrKusLV7qE+Xw_4eqEDtHKTVJxuuy6H+pWRA@mail.gmail.com>
 <cd3867e0-b645-c6cd-3464-29ffb142de5e@tarent.de> <FR2P281MB29597303CA232BBEF6E328DF90479@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <d0755144-c038-8332-1084-b62cc9c6499@tarent.de> <FR2P281MB2959289F36EFC955105DD1DF90469@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
 <bd8c8a7f-8a8e-3992-d631-d2f74d38483@tarent.de> <FR2P281MB2959185CA486AB5A5868C4D490529@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM> <1b62f51-a017-e21-31f3-2ccd72b6c8ad@tarent.de> <FR2P281MB29596B8EA9AC8940C5A95B7690559@FR2P281MB2959.DEUP281.PROD.OUTLOOK.COM>
Content-Language: de-DE-1901
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I finally managed to reproduce it, and this is the full trace, from virsh console
output from an emulated serial console. (Took multiple test runs of 10 minutes
each to crash it still…)

The beginning of the trace seems a little hard to read because it’s interspersed
with the list of loaded modules for some reason (crash code not MP-safe?), but
the basic points (rtnl and sendmsg) are similar; there’s a second trace below
though which I didn’t see in the screen photos from my colleagues.

I now have some ideas I could try (including those Dave Täht wrote to me in
private replies), but if this rings with someone or if someone has got a good
idea how to debug this (the new info here is “nonzero _refcount”) be my guest
and share.

Thanks in advance,
//mirabilos

[852650.833646] ------------[ cut here ]------------
[852650.835760] BUG: Bad page state in process swapper/0  pfn:10178
[852650.837103] kernel BUG at mm/slub.c:305!
[852650.841016] page:000000009e06fd59 refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10178
[852650.841019] flags: 0xfffffc0000000()
[852650.841028] raw: 000fffffc0000000 dead000000000100 dead000000000122 0000000000000000
[852650.843530] invalid opcode: 0000 [#1] SMP PTI
[852650.843534] CPU: 2 PID: 4397 Comm: tc Tainted: G           OE     5.10.0-18-amd64 #1 Debian 5.10.140-1
[852650.843537] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[852650.849183] raw: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000000
[852650.851804] RIP: 0010:__slab_free+0x21b/0x430
[852650.856338] page dumped because: nonzero _refcount
[852650.859047] Code: 44 24 20 e8 07 fc ff ff 44 8b 44 24 20 85 c0 0f 85 37 fe ff ff eb ae 41 f7 46 08 00 0d 21 00 0f 85 17 ff ff ff e9 09 ff ff ff <0f> 0b 80 4c 24 5b 80 45 31 c9 e9 76 fe ff ff f3 90 49 8b 04 24 a8
[852650.864402] Modules linked in:
[852650.869306] RSP: 0018:ffffa0f545bcb990 EFLAGS: 00010246
[852650.873856]  sch_janz(OE)
[852650.876721]
[852650.879594]  xt_conntrack
[852650.895021] RAX: ffff9450c114ef00 RBX: 000000008010000f RCX: ffff9450c114ee00
[852650.897053]  nft_chain_nat
[852650.901578] RDX: ffff9450c114ee00 RSI: ffffe246c4045380 RDI: ffff9450c0042600
[852650.903352]  xt_MASQUERADE
[852650.905027] RBP: ffffa0f545bcba40 R08: 0000000000000001 R09: ffffffff8e2ec1b1
[852650.906794]  nf_nat
[852650.912292] R10: ffff9450c114ee00 R11: ffff944ff5f8c300 R12: ffffe246c4045380
[852650.914132]  nf_conntrack_netlink
[852650.920046] R13: ffff9450c114ee00 R14: ffff9450c0042600 R15: ffff9450c114ee00
[852650.921866]  nf_conntrack
[852650.926695] FS:  00007f084af58740(0000) GS:ffff94513ad00000(0000) knlGS:0000000000000000
[852650.928341]  nf_defrag_ipv6
[852650.933091] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[852650.935495]  nf_defrag_ipv4
[852650.940282] CR2: 0000555772316de0 CR3: 00000000101cc000 CR4: 0000000000000ee0
[852650.942128]  xfrm_user
[852650.948202] Call Trace:
[852650.950305]  xfrm_algo
[852650.954000]  ? __free_one_page+0x3a5/0x450
[852650.955985]  nft_counter
[852650.960821]  ? kfree_skb+0x41/0xb0
[852650.962539]  xt_addrtype
[852650.964695]  kfree+0x410/0x490
[852650.966410]  nft_compat
[852650.969219]  kfree_skb+0x41/0xb0
[852650.970966]  x_tables
[852650.973479]  __rtnl_unlock+0x34/0x50
[852650.975417]  nf_tables
[852650.977653]  netdev_run_todo+0x60/0x360
[852650.979345]  libcrc32c
[852650.981765]  rtnetlink_rcv_msg+0x134/0x380
[852650.983525]  br_netfilter
[852650.985953]  ? _copy_to_iter+0xb5/0x4c0
[852650.987597]  bridge
[852650.990183]  ? __free_one_page+0x3a5/0x450
[852650.991979]  stp
[852650.995073]  ? kernel_init_free_pages+0x46/0x60
[852650.997083]  llc
[852650.999666]  ? rtnl_calcit.isra.0+0x120/0x120
[852651.001219]  overlay
[852651.004233]  netlink_rcv_skb+0x50/0x100
[852651.005848]  nfnetlink
[852651.009049]  netlink_unicast+0x209/0x2d0
[852651.010449]  nfsd auth_rpcgss nfs_acl nfs lockd grace nfs_ssc fscache sunrpc loop kvm_intel kvm drm_kms_helper
[852651.013943]  netlink_sendmsg+0x250/0x4b0
[852651.015615]  irqbypass
[852651.018929]  sock_sendmsg+0x62/0x70
[852651.020735]  cec
[852651.023896]  ____sys_sendmsg+0x232/0x270
[852651.030369]  drm
[852651.033098]  ? import_iovec+0x2d/0x40
[852651.035110]  virtio_rng
[852651.037626]  ? sendmsg_copy_msghdr+0x80/0xa0
[852651.039206]  virtio_balloon
[852651.042319]  ___sys_sendmsg+0x75/0xc0
[852651.044113]  evdev
[852651.047167]  ? wp_page_copy+0x2fd/0x840
[852651.049031]  rng_core
[852651.052467]  ? handle_mm_fault+0x1143/0x1c10
[852651.054539]  joydev
[852651.057269]  __sys_sendmsg+0x59/0xa0
[852651.058931]  serio_raw
[852651.061516]  do_syscall_64+0x33/0x80
[852651.063385]  pcspkr
[852651.066605]  entry_SYSCALL_64_after_hwframe+0x61/0xc6
[852651.068996]  qemu_fw_cfg
[852651.071465] RIP: 0033:0x7f084b084fc3
[852651.073916]  button
[852651.076976] Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
[852651.078698]  ext4
[852651.082814] RSP: 002b:00007ffd63fd6708 EFLAGS: 00000246
[852651.084859]  crc16
[852651.087757]  ORIG_RAX: 000000000000002e
[852651.089473]  mbcache
[852651.106133] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f084b084fc3
[852651.107962]  jbd2
[852651.112893] RDX: 0000000000000000 RSI: 00007ffd63fd6770 RDI: 0000000000000003
[852651.114442]  crc32c_generic
[852651.117215] RBP: 00000000633dcefa R08: 0000000000000001 R09: 00007f084b156be0
[852651.118924]  hid_generic usbhid hid virtio_net virtio_blk net_failover failover uhci_hcd ata_generic ehci_hcd ata_piix psmouse usbcore libata crc32c_intel virtio_pci
[852651.123723] R10: 0000555773f318f0 R11: 0000000000000246 R12: 0000000000000001
[852651.125316]  virtio_ring
[852651.130148] R13: 0000000000000004 R14: 00007ffd63fe6a48 R15: 0000555772315f80
[852651.132112]  i2c_piix4
[852651.137135] Modules linked in:
[852651.146865]  virtio
[852651.151664]  sch_janz(OE)
[852651.153468]  scsi_mod
[852651.158290]  xt_conntrack
[852651.160056]  usb_common
[852651.162176]  nft_chain_nat
[852651.163832]  floppy
[852651.165820]  xt_MASQUERADE
[852651.167494]  [last unloaded: sch_janz]
[852651.169464]  nf_nat
[852651.171178]
[852651.173168]  nf_conntrack_netlink
[852651.174807] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE     5.10.0-18-amd64 #1 Debian 5.10.140-1
[852651.176719]  nf_conntrack
[852651.179456] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[852651.181137]  nf_defrag_ipv6
[852651.182504] Call Trace:
[852651.184737]  nf_defrag_ipv4
[852651.191593]  <IRQ>
[852651.193439]  xfrm_user
[852651.198995]  dump_stack+0x6b/0x83
[852651.201000]  xfrm_algo
[852651.203174]  bad_page.cold+0x63/0x94
[852651.205314]  nft_counter xt_addrtype nft_compat x_tables nf_tables libcrc32c br_netfilter bridge stp llc overlay nfnetlink nfsd auth_rpcgss nfs_acl nfs lockd grace nfs_ssc fscache sunrpc loop kvm_intel kvm
[852651.207205]  get_page_from_freelist+0xc0b/0x1330
[852651.209090]  drm_kms_helper
[852651.211501]  ? __napi_alloc_skb+0x3f/0xf0
[852651.213379]  irqbypass
[852651.215934]  __alloc_pages_nodemask+0x161/0x310
[852651.227502]  cec
[852651.230870]  skb_page_frag_refill+0x8d/0x130
[852651.232841]  drm
[852651.235627]  try_fill_recv+0x310/0x700 [virtio_net]
[852651.237401]  virtio_rng
[852651.240976]  virtnet_poll+0x34a/0x45a [virtio_net]
[852651.242446]  virtio_balloon
[852651.245349]  net_rx_action+0x145/0x3e0
[852651.246901]  evdev
[852651.250248]  __do_softirq+0xc5/0x279
[852651.252027]  rng_core
[852651.255413]  asm_call_irq_on_stack+0x12/0x20
[852651.257525]  joydev
[852651.260184]  </IRQ>
[852651.261747]  serio_raw
[852651.264346]  do_softirq_own_stack+0x37/0x50
[852651.266108]  pcspkr
[852651.268992]  irq_exit_rcu+0x92/0xc0
[852651.270695]  qemu_fw_cfg
[852651.272427]  sysvec_apic_timer_interrupt+0x36/0x80
[852651.274102]  button
[852651.277273]  asm_sysvec_apic_timer_interrupt+0x12/0x20
[852651.278928]  ext4
[852651.281830] RIP: 0010:native_safe_halt+0xe/0x20
[852651.283587]  crc16
[852651.286888] Code: 00 f0 80 48 02 20 48 8b 00 a8 08 75 c0 e9 77 ff ff ff cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d a6 39 51 00 fb f4 <c3> cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 e9 07 00 00
[852651.288550]  mbcache
[852651.292157] RSP: 0018:ffffffff8f203eb8 EFLAGS: 00000212
[852651.293745]  jbd2
[852651.296934]
[852651.298648]  crc32c_generic
[852651.310456] RAX: ffffffff8e4f6390 RBX: 0000000000000000 RCX: ffff94513ac30a40
[852651.312430]  hid_generic
[852651.315540] RDX: 0000000010af973e RSI: ffffffff8f203e50 RDI: 0003077bfb649443
[852651.317392]  usbhid
[852651.318707] RBP: ffffffff8f213940 R08: 0000000000000001 R09: 0000000000000001
[852651.321202]  hid
[852651.325831] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[852651.327840]  virtio_net
[852651.332590] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[852651.332596]  ? __sched_text_end+0x6/0x6
[852651.332600]  default_idle+0xa/0x20
[852651.332603]  default_idle_call+0x3c/0xd0
[852651.332606]  do_idle+0x20c/0x2b0
[852651.332610]  cpu_startup_entry+0x19/0x20
[852651.332621]  start_kernel+0x574/0x599
[852651.332627]  secondary_startup_64_no_verify+0xb0/0xbb
[852651.372595]  virtio_blk net_failover failover uhci_hcd ata_generic ehci_hcd ata_piix psmouse usbcore libata crc32c_intel virtio_pci virtio_ring i2c_piix4 virtio scsi_mod usb_common floppy [last unloaded: sch_janz]
[852651.384220] general protection fault, probably for non-canonical address 0x61a18e4baaf4c70c: 0000 [#2] SMP PTI
[852651.384301] ---[ end trace 0c5eff17e57064a0 ]---
[852651.389902] CPU: 0 PID: 12 Comm: ksoftirqd/0 Tainted: G    B D    OE     5.10.0-18-amd64 #1 Debian 5.10.140-1
[852651.389903] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[852651.389909] RIP: 0010:__kmalloc_node_track_caller+0xd7/0x2a0
[852651.389911] Code: 41 39 ce 74 19 48 8b 0c 24 44 89 f2 44 89 fe 4c 89 e7 e8 5c e8 ff ff 48 89 44 24 08 eb 42 41 8b 4c 24 28 49 8b 3c 24 48 01 c1 <48> 8b 19 48 89 ce 49 33 9c 24 b8 00 00 00 48 8d 4a 01 48 0f ce 48
[852651.389913] RSP: 0018:ffffa0f54006bb70 EFLAGS: 00010206
[852651.389915] RAX: 61a18e4baaf4c60c RBX: 00000000ffffffff RCX: 61a18e4baaf4c70c
[852651.389919] RDX: 00000000011b11c1 RSI: 0000000000082a20 RDI: 0000000000033120
[852651.392771] RIP: 0010:__slab_free+0x21b/0x430
[852651.398467] RBP: ffff9450c0042600 R08: ffff94513ac33120 R09: ffff944ff5e31600
[852651.398469] R10: 0000000000005a00 R11: 0000000000000600 R12: ffff9450c0042600
[852651.398470] R13: 0000000000000200 R14: 00000000ffffffff R15: 0000000000082a20
[852651.398473] FS:  0000000000000000(0000) GS:ffff94513ac00000(0000) knlGS:0000000000000000
[852651.398474] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[852651.398476] CR2: 00007fb16cdc4030 CR3: 00000001043ee000 CR4: 0000000000000ef0
[852651.398481] Call Trace:
[852651.398487]  ? __napi_alloc_skb+0x3f/0xf0
[852651.398491]  __alloc_skb+0x79/0x200
[852651.403422] Code: 44 24 20 e8 07 fc ff ff 44 8b 44 24 20 85 c0 0f 85 37 fe ff ff eb ae 41 f7 46 08 00 0d 21 00 0f 85 17 ff ff ff e9 09 ff ff ff <0f> 0b 80 4c 24 5b 80 45 31 c9 e9 76 fe ff ff f3 90 49 8b 04 24 a8
[852651.406803]  __napi_alloc_skb+0x3f/0xf0
[852651.406810]  page_to_skb+0x61/0x370 [virtio_net]
[852651.406815]  receive_buf+0xdfe/0x1a20 [virtio_net]
[852651.406819]  ? inet_gro_receive+0x23a/0x300
[852651.406825]  ? gro_normal_one+0x31/0xa0
[852651.417319] RSP: 0018:ffffa0f545bcb990 EFLAGS: 00010246
[852651.420409]  virtnet_poll+0x14e/0x45a [virtio_net]
[852651.420414]  net_rx_action+0x145/0x3e0
[852651.420418]  __do_softirq+0xc5/0x279
[852651.420422]  run_ksoftirqd+0x2a/0x40
[852651.420425]  smpboot_thread_fn+0xc5/0x160
[852651.420428]  ? smpboot_register_percpu_thread+0xf0/0xf0
[852651.420433]  kthread+0x11b/0x140
[852651.424873]
[852651.429080]  ? __kthread_bind_mask+0x60/0x60
[852651.429084]  ret_from_fork+0x22/0x30
[852651.429086] Modules linked in: sch_janz(OE) xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter xt_addrtype nft_compat x_tables nf_tables libcrc32c
[852651.431825] RAX: ffff9450c114ef00 RBX: 000000008010000f RCX: ffff9450c114ee00
[852651.436085]  br_netfilter bridge stp llc overlay nfnetlink nfsd auth_rpcgss nfs_acl nfs lockd grace nfs_ssc fscache sunrpc loop kvm_intel kvm drm_kms_helper irqbypass cec drm virtio_rng virtio_balloon evdev rng_core joydev serio_raw
[852651.440362] RDX: ffff9450c114ee00 RSI: ffffe246c4045380 RDI: ffff9450c0042600
[852651.444563]  pcspkr qemu_fw_cfg button ext4 crc16 mbcache jbd2 crc32c_generic hid_generic usbhid hid virtio_net virtio_blk net_failover failover uhci_hcd ata_generic ehci_hcd ata_piix psmouse usbcore libata crc32c_intel virtio_pci virtio_ring i2c_piix4 virtio scsi_mod usb_common floppy [last unloaded: sch_janz]
[852651.444636] ---[ end trace 0c5eff17e57064a1 ]---
[852651.449355] RBP: ffffa0f545bcba40 R08: 0000000000000001 R09: ffffffff8e2ec1b1
[852651.449358] R10: ffff9450c114ee00 R11: ffff944ff5f8c300 R12: ffffe246c4045380
[852651.452820] RIP: 0010:__slab_free+0x21b/0x430
[852651.452824] Code: 44 24 20 e8 07 fc ff ff 44 8b 44 24 20 85 c0 0f 85 37 fe ff ff eb ae 41 f7 46 08 00 0d 21 00 0f 85 17 ff ff ff e9 09 ff ff ff <0f> 0b 80 4c 24 5b 80 45 31 c9 e9 76 fe ff ff f3 90 49 8b 04 24 a8
[852651.457211] R13: ffff9450c114ee00 R14: ffff9450c0042600 R15: ffff9450c114ee00
[852651.458887] RSP: 0018:ffffa0f545bcb990 EFLAGS: 00010246
[852651.461412] FS:  00007f084af58740(0000) GS:ffff94513ad00000(0000) knlGS:0000000000000000
[852651.463607]
[852651.474096] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[852651.476642] RAX: ffff9450c114ef00 RBX: 000000008010000f RCX: ffff9450c114ee00
[852651.476643] RDX: ffff9450c114ee00 RSI: ffffe246c4045380 RDI: ffff9450c0042600
[852651.476646] RBP: ffffa0f545bcba40 R08: 0000000000000001 R09: ffffffff8e2ec1b1
[852651.479436] CR2: 0000555772316de0 CR3: 00000000101cc000 CR4: 0000000000000ee0
[852651.482322] R10: ffff9450c114ee00 R11: ffff944ff5f8c300 R12: ffffe246c4045380
[852651.482325] R13: ffff9450c114ee00 R14: ffff9450c0042600 R15: ffff9450c114ee00
[852651.631634] FS:  0000000000000000(0000) GS:ffff94513ac00000(0000) knlGS:0000000000000000
[852651.636352] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[852651.639739] CR2: 00007fb16cdc4030 CR3: 00000001043ee000 CR4: 0000000000000ef0
[852651.643985] Kernel panic - not syncing: Fatal exception in interrupt
[852651.647874] Kernel Offset: 0xcc00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[852651.653955] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
