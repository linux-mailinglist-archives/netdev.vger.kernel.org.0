Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB08520214
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 18:14:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbiEIQSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 12:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238834AbiEIQSQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 12:18:16 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD75270CB4
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 09:14:20 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id s129-20020a6b2c87000000b00657c1a3b52fso10227511ios.21
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 09:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=VvQlc8+EhhLI7M/YO/8cWqo6JKCATXD6JgKcPNZMDLY=;
        b=rTxGlzcaOE1LArZMSECe5EWKhpza92Jv/20KJ7mw0cNaEvTvQCKuSyTFA1Wgz95pNS
         TXD//Ov52JVC+qUl9UztvnU+lXn2dWm2LpKuTxtElOR9APunp6429ogx8ptEwitqRqLV
         KqQyNuI8LrdjHQ+Zy4wo22WHB6qjQaAuq8R8k+wankRiMQi9RFZBXNWwMZK7MsBwnHmi
         fvcGaT2v8aKxnXSqNKKBQ7oTmoXgXqVX5TErsIEH38ZsUAFw1SGHlUWU3Sx0u7qmfPiS
         W8rJSVSNvDVLrqIU7X+BTue6JtUP6jpw4P3O8oXL3xjOklxrInoyd9nHjOEaLnnXNdY2
         NM2A==
X-Gm-Message-State: AOAM530tkt+OxpWXM+2j/ryoRQi3v+qY49biZvAfqDegt/xSoS9+xmyT
        VKukzWO2kps9Be78/0kFCSu1Uj32hcuzGx1PyUdNzoRshZw/
X-Google-Smtp-Source: ABdhPJwdSGns/yjn6V4PBmzYy6jqV8HGYcg/jOneHbZMN6wBxGVRugH46O1z8O+EkYnLaq9djxvi95f+dUKwdL79dHfH92Z/Pclc
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3487:b0:32b:e72f:8f6c with SMTP id
 t7-20020a056638348700b0032be72f8f6cmr4463447jal.98.1652112860205; Mon, 09 May
 2022 09:14:20 -0700 (PDT)
Date:   Mon, 09 May 2022 09:14:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000029572505de968021@google.com>
Subject: [syzbot] KASAN: use-after-free Read in bio_poll
From:   syzbot <syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, axboe@kernel.dk,
        bpf@vger.kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c5eb0a61238d Linux 5.18-rc6
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=112bf03ef00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79caa0035f59d385
dashboard link: https://syzkaller.appspot.com/bug?extid=99938118dfd9e1b0741a
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12311571f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=177a2e86f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+99938118dfd9e1b0741a@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in bio_poll+0x275/0x3c0 block/blk-core.c:942
Read of size 4 at addr ffff8880751d92b4 by task syz-executor486/3607

CPU: 0 PID: 3607 Comm: syz-executor486 Not tainted 5.18.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 bio_poll+0x275/0x3c0 block/blk-core.c:942
 __iomap_dio_rw+0x10ee/0x1ae0 fs/iomap/direct-io.c:658
 iomap_dio_rw+0x38/0x90 fs/iomap/direct-io.c:681
 ext4_dio_write_iter fs/ext4/file.c:566 [inline]
 ext4_file_write_iter+0xe4d/0x1510 fs/ext4/file.c:677
 call_write_iter include/linux/fs.h:2050 [inline]
 do_iter_readv_writev+0x3d1/0x640 fs/read_write.c:726
 do_iter_write+0x182/0x700 fs/read_write.c:852
 vfs_writev+0x1aa/0x630 fs/read_write.c:925
 do_pwritev+0x1b6/0x270 fs/read_write.c:1022
 __do_sys_pwritev2 fs/read_write.c:1081 [inline]
 __se_sys_pwritev2 fs/read_write.c:1072 [inline]
 __x64_sys_pwritev2+0xeb/0x150 fs/read_write.c:1072
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f6846af7e69
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fffe8df3bb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000148
RAX: ffffffffffffffda RBX: 0000000000008ff2 RCX: 00007f6846af7e69
RDX: 0000000000000001 RSI: 0000000020000240 RDI: 0000000000000004
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000003
R10: 0000000000001400 R11: 0000000000000246 R12: 00007fffe8df3bdc
R13: 431bde82d7b634db R14: 0000000000000000 R15: 0000000000000000
 </TASK>

The buggy address belongs to the physical page:
page:ffffea0001d47640 refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x751d9
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000000 ffffea0001e3d2c8 ffffea00008b7a48 0000000000000000
raw: 0000000000000000 00000000000c0000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x92880(GFP_NOWAIT|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_NOMEMALLOC), pid 3605, tgid 3605 (syz-executor486), ts 36797088171, free_ts 37121806576
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 slab_alloc mm/slub.c:3225 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3232 [inline]
 kmem_cache_alloc+0x360/0x3b0 mm/slub.c:3242
 mempool_alloc+0x146/0x350 mm/mempool.c:392
 bio_alloc_bioset+0x31d/0x4e0 block/bio.c:492
 bio_alloc include/linux/bio.h:426 [inline]
 iomap_dio_bio_iter+0x9bc/0x14c0 fs/iomap/direct-io.c:314
 iomap_dio_iter fs/iomap/direct-io.c:435 [inline]
 __iomap_dio_rw+0x84a/0x1ae0 fs/iomap/direct-io.c:591
 iomap_dio_rw+0x38/0x90 fs/iomap/direct-io.c:681
 ext4_dio_write_iter fs/ext4/file.c:566 [inline]
 ext4_file_write_iter+0xe4d/0x1510 fs/ext4/file.c:677
 call_write_iter include/linux/fs.h:2050 [inline]
 do_iter_readv_writev+0x3d1/0x640 fs/read_write.c:726
 do_iter_write+0x182/0x700 fs/read_write.c:852
 vfs_writev+0x1aa/0x630 fs/read_write.c:925
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 rcu_do_batch kernel/rcu/tree.c:2535 [inline]
 rcu_core+0x7b1/0x1880 kernel/rcu/tree.c:2786
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558

Memory state around the buggy address:
 ffff8880751d9180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880751d9200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff8880751d9280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                     ^
 ffff8880751d9300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff8880751d9380: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches
