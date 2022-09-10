Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60DE15B44DE
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 09:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbiIJHQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 03:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiIJHQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 03:16:29 -0400
Received: from einhorn-mail-out.in-berlin.de (einhorn.in-berlin.de [192.109.42.8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D078AA4B16
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 00:16:26 -0700 (PDT)
X-Envelope-From: thomas@x-berg.in-berlin.de
Received: from x-berg.in-berlin.de (x-change.in-berlin.de [217.197.86.40])
        by einhorn.in-berlin.de  with ESMTPS id 28A7G3vs2676777
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Sat, 10 Sep 2022 09:16:03 +0200
Received: from thomas by x-berg.in-berlin.de with local (Exim 4.94.2)
        (envelope-from <thomas@x-berg.in-berlin.de>)
        id 1oWuig-0002Uw-ID; Sat, 10 Sep 2022 09:16:02 +0200
Date:   Sat, 10 Sep 2022 09:16:02 +0200
From:   Thomas Osterried <thomas@x-berg.in-berlin.de>
To:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Bernard Pidoux <f6bvp@free.fr>,
        Duoming Zhou <duoming@zju.edu.cn>, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org
Subject: [AX25] patch did not fix --  was: ax25: fix incorrect dev_tracker
 usage
Message-ID: <Yxw5siQ3FC6VHo7C@x-berg.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

patch:
  "ax25: fix incorrect dev_tracker usage"
commit
   d7c4c9e075f8cc6d88d277bc24e5d99297f03c06
date 2022-07-28

..does not fix

Tested it with current towalrds tree, which uses latest change
7c6327c77d509e78bff76f2a4551fcfee851682e (netdev_put() instead of dev_put_track()).


userspace:
# rmmod bpqether

refcount complpanis about
[  302.326051] unregister_netdevice: waiting for bpq1 to become free. Usage count = -2
[  312.406495] unregister_netdevice: waiting for bpq1 to become free. Usage count = -2



trace (comparable to trace mentioned iin d7c4c9e075f8cc6d88d277bc24e5d99297f03c06):

[  291.965794] refcount_t: underflow; use-after-free.
[  291.968761] WARNING: CPU: 0 PID: 5954 at lib/refcount.c:28 refcount_warn_saturate+0xba/0x110
[  291.973994] Modules linked in: nft_chain_nat(E) xt_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) xt_tcpudp(E) nft_compat(E) nf_tables(E) libcrc32c(E) nfnetlink(E) tun(E) mkiss(E) bpqether(E-) ax25(OE) snd_pcm(E) snd_timer(E) snd(E) soundcore(E) pcspkr(E) qxl(E) drm_ttm_helper(E) evdev(E) serio_raw(E) ttm(E) virtio_console(E) virtio_balloon(E) drm_kms_helper(E) qemu_fw_cfg(E) button(E) netconsole(E) fuse(E) drm(E) configfs(E) ip_tables(E) x_tables(E) autofs4(E) ext4(E) crc32c_generic(E) crc16(E) mbcache(E) jbd2(E) virtio_net(E) net_failover(E) virtio_blk(E) failover(E) hid_generic(E) usbhid(E) hid(E) crc32c_intel(E) psmouse(E) ata_generic(E) ehci_pci(E) uhci_hcd(E) ata_piix(E) ehci_hcd(E) libata(E) usbcore(E) usb_common(E) virtio_pci(E) virtio_pci_legacy_dev(E) scsi_mod(E) virtio_pci_modern_dev(E) virtio(E) virtio_ring(E) scsi_common(Endard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[  292.025488] RIP: 0010:refcount_warn_saturate+0xba/0x110
[  292.027887] Code: 01 01 e8 e6 10 45 00 0f 0b c3 cc cc cc cc 80 3d 32 bf 10 01 00 75 85 48 c7 c7 80 57 76 92 c6 05 22 bf 10 01 01 e8 c3 10 45 00 <0f> 0b c3 cc cc cc cc 80 3d 0d bf 10 01 00 0f 85 5e ff ff ff 48 c7
[  292.035844] RSP: 0018:ffffae0d806fbd30 EFLAGS: 00010286
[  292.038080] RAX: 0000000000000000 RBX: ffff8fd9888b3e40 RCX: 0000000000000000
[  292.040926] RDX: 0000000000000001 RSI: ffffffff9274e0e2 RDI: 00000000ffffffff
[  292.043823] RBP: ffff8fd983c05e00 R08: 0000000000000000 R09: 00000000ffffefff
[  292.046710] R10: ffffae0d806fbbd0 R11: ffffffff92acbaa8 R12: ffff8fd988ce0000
[  292.049458] R13: ffff8fd983488000 R14: 0000000000000001 R15: ffff8fd983488080
[  292.052199] FS:  0000000000000000(0000) GS:ffff8fd99fc00000(0063) knlGS:00000000f7ee2700
[  292.055244] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[  292.057403] CR2: 00000000f6ec4e20 CR3: 00000000037d6000 CR4: 00000000000006f0
[  292.060108] Call Trace:
[  292.061079]  <TASK>
[  292.061971]  ax25_device_event+0x234/0x250 [ax25]
[  292.063758]  raw_notifier_call_chain+0x44/0x60
[  292.065392]  dev_close_many+0xe9/0x140
[  292.066834]  dev_close+0x7f/0xb0
[  292.068044]  bpq_device_event+0x209/0x2a0 [bpqether]
[  292.069910]  call_netdevice_unregister_notifiers+0x66/0xb0
[  292.071874]  unregister_netdevice_notifier+0x6c/0xb0
[  292.073716]  bpq_cleanup_driver+0x24/0x62f [bpqether]
[  292.075588]  __do_sys_delete_module+0x198/0x300
[  292.077298]  ? fpregs_assert_state_consistent+0x22/0x50
[  292.079290]  ? exit_to_user_mode_prepare+0x3a/0x150
[  292.081081]  __do_fast_syscall_32+0x6f/0xf0
[  292.082709]  do_fast_syscall_32+0x2f/0x70
[  292.084215]  entry_SYSENTER_compat_after_hwframe+0x70/0x82
[  292.086244] RIP: 0023:0xf7f25559
[  292.087482] Code: 10 05 03 74 b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10 08 03 74 d8 01 00 00 00 00 00 00 00 00 00 51 52 55 89 e5 0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 8d b4 26 00 00 00 00 8d b4 26 00 00 00 00
[  292.097365] RSP: 002b:00000000fff45da8 EFLAGS: 00200206 ORIG_RAX: 00000000000102028] RAX: ffffffffffffffda RBX: 00000000569cd19c RCX: 0000000000000800
[  292.106296] RDX: 00000000565aa939 RSI: 00000000569cd160 RDI: 00000000569cd160
[  292.110722] RBP: 00000000fff468e4 R08: 0000000000000000 R09: 0000000000000000
[  292.115096] R10: 0000000000000000 R11: 0000000000200206 R12: 0000000000000000
[  292.119435] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[  292.123755]  </TASK>
[  292.126362] ---[ end trace 0000000000000000 ]---



