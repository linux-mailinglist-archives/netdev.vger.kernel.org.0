Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142F0C146A
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 14:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbfI2MJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 08:09:59 -0400
Received: from srv2.anyservers.com ([77.79.239.202]:45580 "EHLO
        srv2.anyservers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbfI2MJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 08:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=asmblr.net;
         s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-Id:
        Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+BNgMg8JsIMPDcDrcbhTFGDMF4MD54GvX0gFq5iPH14=; b=kIYiryJuPOlYUBSf/KGTZ81qWK
        ScBqrTh8sBsUehsRdyTKFmMtKJ4pstHTwChzPgCY7dst3dhO385qBu5enLI/mTCNUMGT/aJoj8mro
        Dg9of0Dfg6u9lu/KT+F+OzKSjjMQHFrGIgF0xzvcaiWEDLj01SY3MrhCC+QNqNBqQU18TwShgUhYi
        yhofMRDoRnbMZkzebYJaFWCBuELAa0c2k6Mo2RFXZfhQlaoMT3rPTGGJhW8CfTwmH1MecMxGpZqF/
        +4BxdYKZEjsnG8W1BM80IUq2PVf2XXzosedSLPM9EBkc/aC+M4uYW00IYcJqIZ/h6Zpk/Ld/6MSVS
        VnQZkTOg==;
Received: from [5.174.236.109] (port=55200 helo=milkyway.galaxy)
        by srv2.anyservers.com with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.91)
        (envelope-from <amade@asmblr.net>)
        id 1iEX0U-003gdJ-6L; Sun, 29 Sep 2019 13:04:50 +0200
From:   =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amade@asmblr.net>
Subject: [RFC PATCH 0/2] Incorrect memory access when using TAP
Date:   Sun, 29 Sep 2019 13:05:00 +0200
Message-Id: <20190929110502.2284-1-amade@asmblr.net>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - srv2.anyservers.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - asmblr.net
X-Get-Message-Sender-Via: srv2.anyservers.com: authenticated_id: amade@asmblr.net
X-Authenticated-Sender: srv2.anyservers.com: amade@asmblr.net
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've recently started using virt-manager to setup my virtual machines,
along with macvtap bridge. When I start VM I noticed that following
appears in dmesg:

[  125.256517] ==================================================================
[  125.256524] BUG: KASAN: slab-out-of-bounds in sock_init_data+0x262/0x560
[  125.256525] Read of size 4 at addr ffff8887d1825a28 by task libvirtd/3749

[  125.256529] CPU: 1 PID: 3749 Comm: libvirtd Tainted: G                T 5.3.0+ #50
[  125.256530] Hardware name: ASUS All Series/SABERTOOTH Z97 MARK 2, BIOS 3503 04/18/2018
[  125.256531] Call Trace:
[  125.256535]  dump_stack+0x5b/0x88
[  125.256539]  print_address_description.constprop.0+0x19/0x210
[  125.256541]  ? sock_init_data+0x262/0x560
[  125.256543]  __kasan_report.cold+0x1a/0x40
[  125.256545]  ? sock_init_data+0x262/0x560
[  125.256547]  ? sock_init_data+0x262/0x560
[  125.256549]  kasan_report+0x2a/0x40
[  125.256551]  sock_init_data+0x262/0x560
[  125.256554]  tap_open+0x2af/0x580
[  125.256556]  chrdev_open+0x171/0x380
[  125.256558]  ? cdev_put.part.0+0x30/0x30
[  125.256561]  do_dentry_open+0x2dd/0x7f0
[  125.256562]  ? cdev_put.part.0+0x30/0x30
[  125.256564]  ? __ia32_sys_fchdir+0xe0/0xe0
[  125.256567]  ? security_inode_permission+0x56/0x70
[  125.256570]  path_openat+0x94f/0x22e0
[  125.256573]  ? preempt_count_sub+0xf/0xb0
[  125.256576]  ? __rcu_read_unlock+0x79/0x2b0
[  125.256578]  ? path_lookupat.isra.0+0x4c0/0x4c0
[  125.256581]  ? __is_insn_slot_addr+0x56/0x80
[  125.256583]  ? kernel_text_address+0xdc/0xf0
[  125.256585]  ? unwind_get_return_address+0x2d/0x40
[  125.256587]  ? profile_setup.cold+0x96/0x96
[  125.256589]  ? arch_stack_walk+0x8a/0xd0
[  125.256591]  do_filp_open+0x110/0x1a0
[  125.256593]  ? may_open_dev+0x50/0x50
[  125.256595]  ? expand_files+0x9b/0x330
[  125.256596]  ? rb_insert_color+0x32/0x3e0
[  125.256598]  ? copy_fd_bitmaps+0x110/0x110
[  125.256600]  ? preempt_count_sub+0xf/0xb0
[  125.256602]  ? _raw_spin_lock+0x82/0xd0
[  125.256604]  ? preempt_count_sub+0xf/0xb0
[  125.256605]  ? _raw_spin_unlock+0x19/0x30
[  125.256607]  ? __alloc_fd+0x110/0x270
[  125.256609]  do_sys_open+0x1fb/0x2f0
[  125.256610]  ? filp_open+0x50/0x50
[  125.256613]  do_syscall_64+0x5e/0x190
[  125.256615]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  125.256617] RIP: 0033:0x73dc99750972
[  125.256619] Code: 00 00 85 c0 74 95 44 89 54 24 0c e8 48 f2 ff ff 44 8b 54 24 0c 44 89 e2 48 89 ee 41 89 c0 bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 77 2c 44 89 c7 89 44 24 0c e8 7a f2 ff ff 8b 44
[  125.256620] RSP: 002b:000073dc837fd230 EFLAGS: 00000293 ORIG_RAX: 0000000000000101
[  125.256622] RAX: ffffffffffffffda RBX: 000073dc837fd340 RCX: 000073dc99750972
[  125.256623] RDX: 0000000000000002 RSI: 000073dc7401e430 RDI: 00000000ffffff9c
[  125.256624] RBP: 000073dc7401e430 R08: 0000000000000000 R09: 000073dc7401b300
[  125.256625] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000002
[  125.256626] R13: 000073dc7401ee60 R14: 000000000000000a R15: 000073dc3c09a910

[  125.256629] Allocated by task 3749:
[  125.256630]  save_stack+0x20/0x80
[  125.256632]  __kasan_kmalloc.constprop.0+0xc3/0xd0
[  125.256633]  __kmalloc+0x151/0x2e0
[  125.256635]  sk_prot_alloc+0x10b/0x1c0
[  125.256636]  sk_alloc+0x2b/0x370
[  125.256637]  tap_open+0x11c/0x580
[  125.256639]  chrdev_open+0x171/0x380
[  125.256640]  do_dentry_open+0x2dd/0x7f0
[  125.256641]  path_openat+0x94f/0x22e0
[  125.256642]  do_filp_open+0x110/0x1a0
[  125.256644]  do_sys_open+0x1fb/0x2f0
[  125.256645]  do_syscall_64+0x5e/0x190
[  125.256646]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[  125.256647] Freed by task 4309:
[  125.256649]  save_stack+0x20/0x80
[  125.256650]  __kasan_slab_free+0x12c/0x170
[  125.256651]  kfree+0xa5/0x230
[  125.256653]  alloc_iova_fast+0x2bb/0x380
[  125.256656]  intel_alloc_iova+0xad/0xc0
[  125.256657]  intel_map_sg+0xe0/0x210
[  125.256659]  ata_qc_issue+0x4aa/0x4c0
[  125.256661]  ata_scsi_translate+0x1b0/0x2c0
[  125.256663]  ata_scsi_queuecmd+0x13f/0x400
[  125.256664]  scsi_queue_rq+0xbed/0xf00
[  125.256667]  __blk_mq_try_issue_directly+0x263/0x380
[  125.256668]  blk_mq_try_issue_directly+0x81/0xf0
[  125.256670]  blk_mq_make_request+0x5fe/0x770
[  125.256672]  generic_make_request+0x176/0x530
[  125.256673]  submit_bio+0x9f/0x260
[  125.256676]  submit_bh_wbc+0x348/0x380
[  125.256677]  ll_rw_block+0x123/0x130
[  125.256679]  __breadahead+0x91/0xe0
[  125.256681]  __ext4_get_inode_loc+0x65e/0x720
[  125.256682]  __ext4_iget+0x1ff/0x1980
[  125.256684]  ext4_lookup+0x21a/0x380
[  125.256686]  path_openat+0xae2/0x22e0
[  125.256687]  do_filp_open+0x110/0x1a0
[  125.256688]  do_sys_open+0x1fb/0x2f0
[  125.256689]  do_syscall_64+0x5e/0x190
[  125.256690]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

[  125.256692] The buggy address belongs to the object at ffff8887d1825468
                which belongs to the cache kmalloc-2k of size 2048
[  125.256694] The buggy address is located 1472 bytes inside of
                2048-byte region [ffff8887d1825468, ffff8887d1825c68)
[  125.256694] The buggy address belongs to the page:
[  125.256696] page:ffffea001f460800 refcount:1 mapcount:0 mapping:ffff8887db0113c0 index:0x0 compound_mapcount: 0
[  125.256698] flags: 0x200000000010200(slab|head)
[  125.256701] raw: 0200000000010200 ffffea001d55a008 ffff8887db003470 ffff8887db0113c0
[  125.256703] raw: 0000000000000000 00000000000d000d 00000001ffffffff 0000000000000000
[  125.256703] page dumped because: kasan: bad access detected

[  125.256704] Memory state around the buggy address:
[  125.256706]  ffff8887d1825900: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  125.256707]  ffff8887d1825980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  125.256708] >ffff8887d1825a00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  125.256709]                                   ^
[  125.256710]  ffff8887d1825a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  125.256712]  ffff8887d1825b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
[  125.256712] ==================================================================
[  125.256713] Disabling lock debugging due to kernel taint

From my investigation it happen because of:
		sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
in sock_init_data().

From this it seems quite obvious that sock_init_data() actually expects
passed  sock  argument to be allocated with sock_alloc.

Following patches are attempt to fix this by using sock_alloc(), it
seems to work fine on my system, but I'm not that well versed on
networking internals.

Few points of doubt:
 * TAP & TUN apparently just need, sock without inode, so doing
sock_alloc doesn't seem that good
 * As far as I understand an API I should put sock_release somewhere,
but if I put it in places that seem logical to me it causes oops on null
pointer, does network API free scoket automatically somewhere?
 * Maybe it is just simpler and more error proof to add some flag inside
sock_alloc, so it knows that it can do SOCK_INODE call...

Cheers,
Amadeusz


Amadeusz Sławiński (2):
  net: tap: Fix incorrect memory access
  net: tun: Fix incorrect memory access

 drivers/net/tap.c      | 34 ++++++++++------
 drivers/net/tun.c      | 92 +++++++++++++++++++++++-------------------
 include/linux/if_tap.h |  2 +-
 3 files changed, 72 insertions(+), 56 deletions(-)

-- 
2.23.0

