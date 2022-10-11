Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67B15FBC33
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 22:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbiJKUgb convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 11 Oct 2022 16:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbiJKUgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 16:36:10 -0400
Received: from mail.lixid.net (lixid.tarent.de [193.107.123.118])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C851621833
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 13:36:07 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.lixid.net (MTA) with ESMTP id 1138C14112E;
        Tue, 11 Oct 2022 22:36:06 +0200 (CEST)
Received: from mail.lixid.net ([127.0.0.1])
        by localhost (mail.lixid.net [127.0.0.1]) (MFA, port 10024) with LMTP
        id fZrZKnRI9_Z0; Tue, 11 Oct 2022 22:35:58 +0200 (CEST)
Received: from x61w.mirbsd.org (vpn-172-34-0-14.dynamic.tarent.de [172.34.0.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.lixid.net (MTA) with ESMTPS id D25E1140E95;
        Tue, 11 Oct 2022 22:35:58 +0200 (CEST)
Received: by x61w.mirbsd.org (Postfix, from userid 1000)
        id 6A970616C0; Tue, 11 Oct 2022 22:35:58 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by x61w.mirbsd.org (Postfix) with ESMTP id 65EB1616AF;
        Tue, 11 Oct 2022 22:35:58 +0200 (CEST)
Date:   Tue, 11 Oct 2022 22:35:58 +0200 (CEST)
From:   Thorsten Glaser <t.glaser@tarent.de>
To:     Dave Taht <dave.taht@gmail.com>
cc:     netdev@vger.kernel.org
Subject: Re: RFH, where did I go wrong?
In-Reply-To: <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
Message-ID: <d4103bc1-d0bb-5c66-10f5-2dae2cdb653d@tarent.de>
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de> <CAA93jw5J5XzhKb_L0C5uw1e3yz_4ithUnWO6nAmeeAEn7jyYiQ@mail.gmail.com> <1a1214b6-fc29-1e11-ec21-682684188513@tarent.de> <CAA93jw6ReJPD=5oQ8mvcDCMNV8px8pB4UBjq=PDJvfE=kwxCRg@mail.gmail.com>
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

On Thu, 8 Sep 2022, Dave Taht wrote:

> I would just keep time in ns throughout as its hard to think through.

I’ve converted the code to do just that now. The only conversions
left are from/to ms (for tc qdisc add/change/show) and one place
where the 1024ns-based units are used in debugfs reporting.

> I'll take a harder look, but does it crash if you rip out debugfs?

I’ve added enough ifdeffery to disable all of debugfs except for
the basic initialisation of it, so the file is present, and even
disabling the code to read the iptos byte and sort into different
FIFOs based on priority. Relayfs’ spinlock isn’t present then either.

And yes, it (commit dbb99579808dcf106264f28f3c8cf5ef2f2c05bf) still
crashes even if this time I get yet another message… all of those I
got seem to imply some kind of memory corruption though?

[ 8361.191173] list_del corruption. next->prev should be ffff979fc2046800, but was ffffb5bc00003c80
[ 8361.197092] ------------[ cut here ]------------
[ 8361.200466] kernel BUG at lib/list_debug.c:62!
[ 8361.203175] invalid opcode: 0000 [#1] SMP PTI
[ 8361.205751] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G           OE     5.10.0-18-amd64 #1 Debian 5.10.140-1
[ 8361.211219] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[ 8361.216048] RIP: 0010:__list_del_entry_valid.cold+0x1d/0x69
[ 8361.219379] Code: c7 c7 48 26 32 a6 e8 77 12 ff ff 0f 0b 48 89 fe 48 c7 c7 58 27 32 a6 e8 66 12 ff ff 0f 0b 48 c7 c7 68 28 32 a6 e8 58 12 ff ff <0f> 0b 48 89 f2 48 89 fe 48 c7 c7 28 28 32 a6 e8 44 12 ff ff 0f 0b
[ 8361.229618] RSP: 0018:ffffb5bc00003c48 EFLAGS: 00010246
[ 8361.232652] RAX: 0000000000000054 RBX: ffff979fc2046300 RCX: 0000000000000000
[ 8361.237195] RDX: 0000000000000000 RSI: ffff97a03ac1ca00 RDI: ffff97a03ac1ca00
[ 8361.241320] RBP: ffff979fc2046800 R08: 0000000000000000 R09: ffffb5bc00003a70
[ 8361.245429] R10: ffffb5bc00003a68 R11: ffffffffa68cb448 R12: ffffb5bc00003c80
[ 8361.249535] R13: ffffb5bc00003d00 R14: ffffffffa6a14ec0 R15: ffff979fc2046300
[ 8361.253763] FS:  0000000000000000(0000) GS:ffff97a03ac00000(0000) knlGS:0000000000000000
[ 8361.258400] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8361.261696] CR2: 000000c000589000 CR3: 0000000103ec4000 CR4: 0000000000000ef0
[ 8361.265693] Call Trace:
[ 8361.267488]  <IRQ>
[ 8361.268909]  ip_sublist_rcv_finish+0x25/0x70
[ 8361.271501]  ip_sublist_rcv+0x193/0x220
[ 8361.273857]  ? ip_rcv_finish_core.constprop.0+0x410/0x410
[ 8361.276990]  ip_list_rcv+0x135/0x160
[ 8361.279199]  __netif_receive_skb_list_core+0x2b0/0x2e0
[ 8361.282203]  netif_receive_skb_list_internal+0x1b7/0x2f0
[ 8361.285479]  ? inet_gro_receive+0x23a/0x300
[ 8361.288000]  gro_normal_one+0x77/0xa0
[ 8361.290249]  napi_gro_receive+0x152/0x190
[ 8361.292721]  virtnet_poll+0x14e/0x45a [virtio_net]
[ 8361.295570]  net_rx_action+0x145/0x3e0
[ 8361.297863]  __do_softirq+0xc5/0x279
[ 8361.300081]  asm_call_irq_on_stack+0x12/0x20
[ 8361.302651]  </IRQ>
[ 8361.304139]  do_softirq_own_stack+0x37/0x50
[ 8361.306649]  irq_exit_rcu+0x92/0xc0
[ 8361.308836]  common_interrupt+0x74/0x130
[ 8361.311219]  asm_common_interrupt+0x1e/0x40
[ 8361.313725] RIP: 0010:native_safe_halt+0xe/0x20
[ 8361.316416] Code: 00 f0 80 48 02 20 48 8b 00 a8 08 75 c0 e9 77 ff ff ff cc cc cc cc cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d a6 39 51 00 fb f4 <c3> cc cc cc cc 66 66 2e 0f 1f 84 00 00 00 00 00 66 90 e9 07 00 00
[ 8361.326934] RSP: 0018:ffffffffa6803eb8 EFLAGS: 00000202
[ 8361.329994] RAX: ffffffffa5af6390 RBX: 0000000000000000 RCX: ffff97a03ac30a40
[ 8361.334016] RDX: 0000000000a72606 RSI: ffffffffa6803e50 RDI: 0000079aa3bb2dc6
[ 8361.337990] RBP: ffffffffa6813940 R08: 0000000000000001 R09: 0000000000002c00
[ 8361.342018] R10: 0000000000002c00 R11: 0000000000000000 R12: 0000000000000000
[ 8361.346211] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 8361.350204]  ? __sched_text_end+0x6/0x6
[ 8361.352536]  default_idle+0xa/0x20
[ 8361.354654]  default_idle_call+0x3c/0xd0
[ 8361.357021]  do_idle+0x20c/0x2b0
[ 8361.359216]  cpu_startup_entry+0x19/0x20
[ 8361.361607]  start_kernel+0x574/0x599
[ 8361.363867]  secondary_startup_64_no_verify+0xb0/0xbb
[ 8361.366821] Modules linked in: sch_janz(OE) xt_conntrack nft_chain_nat xt_MASQUERADE nf_nat nf_conntrack_netlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 xfrm_user xfrm_algo nft_counter xt_addrtype nft_compat x_tables nf_tables libcrc32c br_netfilter bridge stp llc overlay nfnetlink nfsd auth_rpcgss nfs_acl nfs lockd grace nfs_ssc fscache sunrpc loop kvm_intel drm_kms_helper kvm cec irqbypass drm joydev evdev virtio_rng virtio_balloon serio_raw rng_core pcspkr qemu_fw_cfg button ext4 crc16 mbcache jbd2 crc32c_generic hid_generic usbhid hid virtio_net net_failover virtio_blk failover ata_generic uhci_hcd ata_piix ehci_hcd libata psmouse usbcore usb_common crc32c_intel scsi_mod virtio_pci virtio_ring virtio i2c_piix4 floppy [last unloaded: sch_janz]
[ 8361.406894] ---[ end trace a306e6bc977bf075 ]---
[ 8361.409635] RIP: 0010:__list_del_entry_valid.cold+0x1d/0x69
[ 8361.412841] Code: c7 c7 48 26 32 a6 e8 77 12 ff ff 0f 0b 48 89 fe 48 c7 c7 58 27 32 a6 e8 66 12 ff ff 0f 0b 48 c7 c7 68 28 32 a6 e8 58 12 ff ff <0f> 0b 48 89 f2 48 89 fe 48 c7 c7 28 28 32 a6 e8 44 12 ff ff 0f 0b
[ 8361.422997] RSP: 0018:ffffb5bc00003c48 EFLAGS: 00010246
[ 8361.426023] RAX: 0000000000000054 RBX: ffff979fc2046300 RCX: 0000000000000000
[ 8361.430242] RDX: 0000000000000000 RSI: ffff97a03ac1ca00 RDI: ffff97a03ac1ca00
[ 8361.434253] RBP: ffff979fc2046800 R08: 0000000000000000 R09: ffffb5bc00003a70
[ 8361.438312] R10: ffffb5bc00003a68 R11: ffffffffa68cb448 R12: ffffb5bc00003c80
[ 8361.442172] R13: ffffb5bc00003d00 R14: ffffffffa6a14ec0 R15: ffff979fc2046300
[ 8361.446497] FS:  0000000000000000(0000) GS:ffff97a03ac00000(0000) knlGS:0000000000000000
[ 8361.451201] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 8361.454526] CR2: 000000c000589000 CR3: 0000000103ec4000 CR4: 0000000000000ef0
[ 8361.458549] Kernel panic - not syncing: Fatal exception in interrupt
[ 8361.462556] Kernel Offset: 0x24200000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[ 8361.468698] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

TIA,
//mirabilos
-- 
Infrastrukturexperte • tarent solutions GmbH
Am Dickobskreuz 10, D-53121 Bonn • http://www.tarent.de/
Telephon +49 228 54881-393 • Fax: +49 228 54881-235
HRB AG Bonn 5168 • USt-ID (VAT): DE122264941
Geschäftsführer: Dr. Stefan Barth, Kai Ebenrett, Boris Esser, Alexander Steeg

                        ****************************************************
/⁀\ The UTF-8 Ribbon
╲ ╱ Campaign against      Mit dem tarent-Newsletter nichts mehr verpassen:
 ╳  HTML eMail! Also,     https://www.tarent.de/newsletter
╱ ╲ header encryption!
                        ****************************************************
