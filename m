Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616FA64240B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 09:04:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiLEIE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 03:04:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231938AbiLEIEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 03:04:09 -0500
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7119215735
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 00:04:02 -0800 (PST)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-143ffc8c2b2so12599638fac.2
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 00:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eGlAqvTht1mSNcbJZLEDsOza/yCze1M2hdyhkbVZYw4=;
        b=Y6SatBDQv+DutqCjKxAc1ybocrGCiKCxMhNuA+GTFZAqaJb/B0zYMDO8RsZhI7nVe6
         IYmfcCkt/htwcEtxNPLWCbBqhnVhywNEbPVINO5K5TT4GK/r3GauMJos4xCoxG4DZUkQ
         UCaRbnL7yjCbkv7u0qngkwRBvsWegAH3v4+siiYGl4GIR+mZhND3RGy+c6eBUQtxJAa0
         UfEK7aTTgyZ7K9Xk9aI6bv0iDe2RjE8vNtLAYy5sQpfTqCRfxfeEo6UVRUVq7YCX8v+C
         r2Bn1KVkS5FK53Nmf/sHLkpFZeOnwab13FI4YeidOraIcsgID8MMVShErk/mubH//Lo/
         R60w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGlAqvTht1mSNcbJZLEDsOza/yCze1M2hdyhkbVZYw4=;
        b=2hw730KF1Ar1MyQyTqx3LPeSzkaI9fGq9hZ8IVFEL6jaQKprJ5JiyfB/IUV7GrX2cw
         5oClvDRGQNJXy4qRRaZJl4VdJkM2135Wte6UI9yu66AeauVyuV714MramBQ2WC0d0Ei5
         zJbCrkuhSiXhvV1WzKWM1kGMUANtWAq/PcDSki/fGgQIsHpADui6ZUI9N6q527e4VQks
         jwkQSfArnBgSjnMIOiUieLPWqhaOVGwvaOSFwJdSz4eZCsE0yvm81/B3a/+gvwAUWJTG
         pa4ySrglnqP8RgQsxumiIB+hVWWDPAFM3E/JW5n7ECKFhrguC+M8qttqwvTeGLePpsxO
         wMeg==
X-Gm-Message-State: ANoB5pkoAMvd/2zSZtzkoiKeJwI5IueAehQWCti4eMwuS745DSwOzdXn
        Fg8f4m24xzt8BGEytd8sGBnHZabBIS5B2LVnNv25gQ==
X-Google-Smtp-Source: AA0mqf6HXnDDZ7dpqFJiz8f/ikkYER8y8gDnI1lcKQnFJ9Wl2v8oW4qX26QL1Sy5ozhNtRg2vHheJ7KBY08wolYGv7I=
X-Received: by 2002:a05:6871:4609:b0:143:955d:ed7 with SMTP id
 nf9-20020a056871460900b00143955d0ed7mr22253914oab.233.1670227441360; Mon, 05
 Dec 2022 00:04:01 -0800 (PST)
MIME-Version: 1.0
References: <000000000000fa798505ee880a25@google.com> <ac0d8823-e7b3-4524-8864-89b4c85315b5n@googlegroups.com>
In-Reply-To: <ac0d8823-e7b3-4524-8864-89b4c85315b5n@googlegroups.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 5 Dec 2022 09:03:49 +0100
Message-ID: <CACT4Y+bz-z9s+sDh916rfw9ezW0XROkAKfMDvdVi-wDuf849MQ@mail.gmail.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in __build_skb_around
To:     pepsipu <soopthegoop@gmail.com>,
        syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com,
        Kees Cook <keescook@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        kasan-dev <kasan-dev@googlegroups.com>
Cc:     syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Andrii Nakryiko <andrii@kernel.org>, ast@kernel.org,
        bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hao Luo <haoluo@google.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, jolsa@kernel.org,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, martin.lau@linux.dev,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Stanislav Fomichev <sdf@google.com>, song@kernel.org,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 4 Dec 2022 at 19:16, pepsipu <soopthegoop@gmail.com> wrote:
>
> I believe this is a KASAN bug.
>
> I made an easier to read version that still triggers KASAN:
>
> #define _GNU_SOURCE
>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <sys/syscall.h>
> #include <sys/types.h>
> #include <linux/bpf.h>
> #include <unistd.h>
>
> #include "bpf.h"
>
> int main(void)
> {
>     __u64 insns[] = {
>         (BPF_CALL | BPF_JMP) | ((__u64)0x61 << 32),
>         (BPF_AND | BPF_ALU),
>         (BPF_EXIT | BPF_JMP),
>     };
>     bpf_load_attr_t load_attr = {
>         .prog_type = BPF_PROG_TYPE_CGROUP_SKB,
>         .insn_cnt = sizeof(insns) / sizeof(__u64),
>         .insns = (__u64)insns,
>         .license = (__u64) "GPL",
>     };
>     long prog_fd = syscall(__NR_bpf, BPF_PROG_LOAD, &load_attr, sizeof(bpf_load_attr_t));
>     if (prog_fd == -1)
>     {
>         printf("could not load bpf prog");
>         exit(-1);
>     }
>     bpf_trun_attr_t trun_attr = {
>         .prog_fd = prog_fd,
>         .data_size_in = 0x81,
>         .data_size_out = -1,
>         .data_in = (__u64) "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
>     };
>
>     syscall(__NR_bpf, BPF_PROG_TEST_RUN, &trun_attr, sizeof(bpf_trun_attr_t));
>     return 0;
> }
>
> It looks like KASAN believes the tail access of SKB's backing buffer, the SKB shared info struct, allocated by bpf_test_init is out-of-bounds.
> This is likely because when the SKB is setup, in build_skb, the tail is calculated as "data + ksize(data) - sizeof(skb_shared_info)". ksize returns the size of the slab, not the allocation, so the tail is much further past the allocation.
> However, KASAN is usually supposed to correct for ksize calls by unpoisioning the entire slab it's called on... I'm not sure why this is happening.

Hi,

[+orignal CC list, please keep it in replies, almost none of relevant
receivers read syzkaller-bugs@ mailing list]

Also +Kees and kasan-dev for ksize.

After the following patch the behavior has changed and KASAN does not
unpoison the fail of the object:

mm: Make ksize() a reporting-only function
https://lore.kernel.org/all/20221118035656.gonna.698-kees@kernel.org/

Kees, is this bpf case is a remaining ksize() use that needs to be fixed?


> On Monday, November 28, 2022 at 5:42:31 AM UTC-8 syzbot wrote:
>>
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit: c35bd4e42885 Add linux-next specific files for 20221124
>> git tree: linux-next
>> console+strace: https://syzkaller.appspot.com/x/log.txt?x=15e5d7e5880000
>> kernel config: https://syzkaller.appspot.com/x/.config?x=11e19c740a0b2926
>> dashboard link: https://syzkaller.appspot.com/bug?extid=fda18eaa8c12534ccb3b
>> compiler: gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>> syz repro: https://syzkaller.appspot.com/x/repro.syz?x=1096f205880000
>> C reproducer: https://syzkaller.appspot.com/x/repro.c?x=10b2d68d880000
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/968fee464d14/disk-c35bd4e4.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/4f46fe801b5b/vmlinux-c35bd4e4.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/c2cdf8fb264e/bzImage-c35bd4e4.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+fda18e...@syzkaller.appspotmail.com
>>
>> ==================================================================
>> BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x235/0x340 net/core/skbuff.c:294
>> Write of size 32 at addr ffff88802aa172c0 by task syz-executor413/5295
>>
>> CPU: 0 PID: 5295 Comm: syz-executor413 Not tainted 6.1.0-rc6-next-20221124-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
>> Call Trace:
>> <TASK>
>> __dump_stack lib/dump_stack.c:88 [inline]
>> dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
>> print_address_description mm/kasan/report.c:253 [inline]
>> print_report+0x15e/0x45d mm/kasan/report.c:364
>> kasan_report+0xbf/0x1f0 mm/kasan/report.c:464
>> check_region_inline mm/kasan/generic.c:183 [inline]
>> kasan_check_range+0x141/0x190 mm/kasan/generic.c:189
>> memset+0x24/0x50 mm/kasan/shadow.c:44
>> __build_skb_around+0x235/0x340 net/core/skbuff.c:294
>> __build_skb+0x4f/0x60 net/core/skbuff.c:328
>> build_skb+0x22/0x280 net/core/skbuff.c:340
>> bpf_prog_test_run_skb+0x343/0x1e10 net/bpf/test_run.c:1131
>> bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
>> __sys_bpf+0x1599/0x4ff0 kernel/bpf/syscall.c:4997
>> __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
>> __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
>> __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5081
>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>> RIP: 0033:0x7f30de9aad19
>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007ffeaee34318 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
>> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f30de9aad19
>> RDX: 0000000000000028 RSI: 0000000020000180 RDI: 000000000000000a
>> RBP: 00007f30de96eec0 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f30de96ef50
>> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>> </TASK>
>>
>> Allocated by task 5295:
>> kasan_save_stack+0x22/0x40 mm/kasan/common.c:45
>> kasan_set_track+0x25/0x30 mm/kasan/common.c:52
>> ____kasan_kmalloc mm/kasan/common.c:376 [inline]
>> ____kasan_kmalloc mm/kasan/common.c:335 [inline]
>> __kasan_kmalloc+0xa5/0xb0 mm/kasan/common.c:385
>> kasan_kmalloc include/linux/kasan.h:212 [inline]
>> __do_kmalloc_node mm/slab_common.c:955 [inline]
>> __kmalloc+0x5a/0xd0 mm/slab_common.c:968
>> kmalloc include/linux/slab.h:575 [inline]
>> kzalloc include/linux/slab.h:711 [inline]
>> bpf_test_init.isra.0+0xa5/0x150 net/bpf/test_run.c:778
>> bpf_prog_test_run_skb+0x22e/0x1e10 net/bpf/test_run.c:1097
>> bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
>> __sys_bpf+0x1599/0x4ff0 kernel/bpf/syscall.c:4997
>> __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
>> __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
>> __x64_sys_bpf+0x79/0xc0 kernel/bpf/syscall.c:5081
>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> The buggy address belongs to the object at ffff88802aa17000
>> which belongs to the cache kmalloc-1k of size 1024
>> The buggy address is located 704 bytes inside of
>> 1024-byte region [ffff88802aa17000, ffff88802aa17400)
>>
>> The buggy address belongs to the physical page:
>> page:ffffea0000aa8400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2aa10
>> head:ffffea0000aa8400 order:3 compound_mapcount:0 subpages_mapcount:0 compound_pincount:0
>> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
>> raw: 00fff00000010200 ffff888012441dc0 dead000000000122 0000000000000000
>> raw: 0000000000000000 0000000080100010 00000001ffffffff 0000000000000000
>> page dumped because: kasan: bad access detected
>> page_owner tracks the page as allocated
>> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2040(__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5295, tgid 5295 (strace-static-x), ts 57049914920, free_ts 56991966201
>> prep_new_page mm/page_alloc.c:2541 [inline]
>> get_page_from_freelist+0x119c/0x2cd0 mm/page_alloc.c:4293
>> __alloc_pages+0x1cb/0x5b0 mm/page_alloc.c:5551
>> alloc_pages+0x1aa/0x270 mm/mempolicy.c:2285
>> alloc_slab_page mm/slub.c:1833 [inline]
>> allocate_slab+0x25e/0x350 mm/slub.c:1980
>> new_slab mm/slub.c:2033 [inline]
>> ___slab_alloc+0xa91/0x1400 mm/slub.c:3211
>> __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3310
>> slab_alloc_node mm/slub.c:3395 [inline]
>> __kmem_cache_alloc_node+0x1a9/0x430 mm/slub.c:3472
>> __do_kmalloc_node mm/slab_common.c:954 [inline]
>> __kmalloc+0x4a/0xd0 mm/slab_common.c:968
>> kmalloc include/linux/slab.h:575 [inline]
>> kzalloc include/linux/slab.h:711 [inline]
>> tomoyo_init_log+0x1282/0x1ec0 security/tomoyo/audit.c:275
>> tomoyo_supervisor+0x354/0xf10 security/tomoyo/common.c:2088
>> tomoyo_audit_env_log security/tomoyo/environ.c:36 [inline]
>> tomoyo_env_perm+0x183/0x200 security/tomoyo/environ.c:63
>> tomoyo_environ security/tomoyo/domain.c:672 [inline]
>> tomoyo_find_next_domain+0x13d2/0x1f80 security/tomoyo/domain.c:879
>> tomoyo_bprm_check_security security/tomoyo/tomoyo.c:101 [inline]
>> tomoyo_bprm_check_security+0x133/0x1c0 security/tomoyo/tomoyo.c:91
>> security_bprm_check+0x49/0xb0 security/security.c:897
>> search_binary_handler fs/exec.c:1723 [inline]
>> exec_binprm fs/exec.c:1777 [inline]
>> bprm_execve fs/exec.c:1851 [inline]
>> bprm_execve+0x732/0x19f0 fs/exec.c:1808
>> do_execveat_common+0x724/0x890 fs/exec.c:1956
>> page last free stack trace:
>> reset_page_owner include/linux/page_owner.h:24 [inline]
>> free_pages_prepare mm/page_alloc.c:1448 [inline]
>> free_pcp_prepare+0x65c/0xc00 mm/page_alloc.c:1498
>> free_unref_page_prepare mm/page_alloc.c:3379 [inline]
>> free_unref_page+0x1d/0x490 mm/page_alloc.c:3474
>> __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2617
>> qlink_free mm/kasan/quarantine.c:168 [inline]
>> qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
>> kasan_quarantine_reduce+0x192/0x220 mm/kasan/quarantine.c:294
>> __kasan_slab_alloc+0x66/0x90 mm/kasan/common.c:307
>> kasan_slab_alloc include/linux/kasan.h:202 [inline]
>> slab_post_alloc_hook mm/slab.h:761 [inline]
>> slab_alloc_node mm/slub.c:3433 [inline]
>> slab_alloc mm/slub.c:3441 [inline]
>> __kmem_cache_alloc_lru mm/slub.c:3448 [inline]
>> kmem_cache_alloc+0x1e3/0x430 mm/slub.c:3457
>> vm_area_alloc+0x20/0x100 kernel/fork.c:458
>> mmap_region+0x44c/0x1dd0 mm/mmap.c:2605
>> do_mmap+0x831/0xf60 mm/mmap.c:1412
>> vm_mmap_pgoff+0x1af/0x280 mm/util.c:520
>> ksys_mmap_pgoff+0x7d/0x5a0 mm/mmap.c:1458
>> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>> do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>>
>> Memory state around the buggy address:
>> ffff88802aa17180: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> ffff88802aa17200: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>> >ffff88802aa17280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ^
>> ffff88802aa17300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff88802aa17380: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ==================================================================
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzk...@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
