Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BC85954B9
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 10:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiHPINW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 04:13:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232483AbiHPIMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 04:12:35 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE33B56B95;
        Mon, 15 Aug 2022 22:37:13 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id p12-20020a7bcc8c000000b003a5360f218fso8788930wma.3;
        Mon, 15 Aug 2022 22:37:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=fZw0tqh/gY9JBgDZwY0XtBmgdrKoSHqHBFctJYFYahU=;
        b=D/8nU1zlGPejulKKr294LMuZOkBY3PR/0CaPTLVXZKQa9LPhrHQVaZEBSU/2Ea4Gvc
         +CSRgKcQVntbL9+R6diSpHjZpZHjWzp8qlDfYN2zoyvt82mCgVHHkZo48ObWa/FsXvtL
         ltaQdhG6C0rAkq6F9jh1uaWGBgqQjshNF/H/iKpUbDtQf/7RPPB675Mw14Y91rGIOTc3
         agtsmTte24TgbrycnD68/kviOReVcQ9NiWaMQxP+9lz/n3BfdF1ikQMBv4Hd7yphtr38
         JUlukWnnEfn0vPd7aNj9JIIMEuqaP58Ua82mGkXpjCherIJO+X+R6L5ERs7tfCQ9Qbpg
         NIUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=fZw0tqh/gY9JBgDZwY0XtBmgdrKoSHqHBFctJYFYahU=;
        b=g8RRQEmtynOhS8Ah9cFLj07N5treNcCl5ytYiBrwm2+9OdEzpgD6sqPJZSlhxNhlst
         ij7TO7hq94jXylp8qKyVMuCm1I4vVDfojelnysfeDCSeAntjs4tUvllZ0y+PXEgTRKQC
         K6yv0l3ZIN6K4NV9XPIojSOLFIkLzpDp1l6nJWGzkUTyzTf1d5QbrR+D3+1gV+NCfu0A
         FZ3VLR581dfHUZB05wZODpBoAzkjNpNjxahujo7zuN8YPVg5RQPxbvgkg+iT2K9TFeqi
         Jj54BHYdjTl8BwWf6cv9Vv32ruTKql0gYRXT3qvSx7vQNcN/gaf9oICSVkgcyV4s7cAl
         Gmkg==
X-Gm-Message-State: ACgBeo39g41CpufbyWqZBGhvNei6Lnil4cwB9G99WnQUWbp4WRVUi/t+
        OBG2gLZaXqFliVmPespvhjkpKEWNp/D2zaM35x5GTHDAyPH6kQQ/
X-Google-Smtp-Source: AA6agR5USNWHIpFb/LyInM2GxjnnYSR6Ov4D1Sf+5dyWH9bagy8VwaMNlDVUen5VYVIEiHLdfI09ElHbANNQ9sY5SsI=
X-Received: by 2002:a05:600c:2483:b0:3a5:e70c:d5f6 with SMTP id
 3-20020a05600c248300b003a5e70cd5f6mr7100918wms.51.1660628231947; Mon, 15 Aug
 2022 22:37:11 -0700 (PDT)
MIME-Version: 1.0
From:   Jiacheng Xu <578001344xu@gmail.com>
Date:   Tue, 16 Aug 2022 13:37:00 +0800
Message-ID: <CAO4S-mePh1_HhfWPrFEkZed9W6iiDDA-+0PYQ_Otqcxza6_33Q@mail.gmail.com>
Subject: KASAN: slab-out-of-bounds in ipvlan_queue_xmit
To:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com
Cc:     security@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_STARTS_WITH_NUMS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

When using modified Syzkaller to fuzz the latest Linux kernel, the
following crash was triggered.

HEAD commit: 3d7cb6b04c3f Linux-5.19
git tree: upstream

kernel config: https://drive.google.com/file/d/1wgIUDwP5ho29AM-K7HhysSTfWFpfXYkG/view?usp=sharing
syz repro: https://drive.google.com/file/d/1GcF5GvQ2LkFCm_ij_gCwb2qOUSAbdzRT/view?usp=sharing
C reproducer: https://drive.google.com/file/d/1XcEYzdr7cGzdjP8epEUe2HMJ0DgbZRWl/view?usp=sharing

Environment:
Ubuntu 20.04 on Linux 5.4.0
QEMU 4.2.1:
qemu-system-x86_64 \
  -m 2G \
  -smp 2 \
  -kernel /home/workdir/bzImage \
  -append "console=ttyS0 root=/dev/sda earlyprintk=serial net.ifnames=0" \
  -drive file=/home/workdir/stretch.img,format=raw \
  -net user,host=10.0.2.10,hostfwd=tcp:127.0.0.1:10021-:22 \
  -net nic,model=e1000 \
  -enable-kvm \
  -nographic \
  -pidfile vm.pid \
  2>&1 | tee vm.log

If you fix this issue, please add the following tag to the commit:
Credits to Jiacheng Xu<stitch@zju.edu.cn>

==================================================================
BUG: KASAN: slab-out-of-bounds in ipvlan_queue_xmit+0x16c0/0x1950
Read of size 4 at addr ffff888042046fff by task repro/6447

CPU: 1 PID: 6447 Comm: repro Not tainted 5.19.0 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 4
Call Trace:
<TASK>
dump_stack_lvl+0xcd/0x134
print_report.cold+0xe5/0x659
? ipvlan_queue_xmit+0x16c0/0x1950
kasan_report+0x8a/0x1b0
? audit_kill_trees+0x2f0/0x300
? ipvlan_queue_xmit+0x16c0/0x1950
ipvlan_queue_xmit+0x16c0/0x1950
? ipvlan_handle_mode_l3+0x120/0x120
? skb_csum_hwoffload_help+0x1a0/0x1a0
? __sanitizer_cov_trace_pc+0x1a/0x40
? validate_xmit_xfrm+0x49d/0x10a0
? __sanitizer_cov_trace_pc+0x1a/0x40
? netif_skb_features+0x45b/0xbb0
? __sanitizer_cov_trace_pc+0x1a/0x40
? validate_xmit_skb+0x878/0xec0
? __sanitizer_cov_trace_pc+0x1a/0x40
ipvlan_start_xmit+0x45/0x190
__dev_direct_xmit+0x42d/0x630
? validate_xmit_skb_list+0x140/0x140
? packet_poll+0x4d0/0x4d0
? __sanitizer_cov_trace_pc+0x1a/0x40
? netdev_pick_tx+0x14f/0xbe0
packet_direct_xmit+0x1b8/0x2b0
packet_sendmsg+0x223e/0x4d50
? __sanitizer_cov_trace_pc+0x1a/0x40
? aa_label_sk_perm+0x89/0xe0
? __sanitizer_cov_trace_pc+0x1a/0x40
? aa_sk_perm+0x30f/0xa90
? tpacket_rcv+0x32c0/0x32c0
? aa_af_perm+0x230/0x230
? __sanitizer_cov_trace_pc+0x1a/0x40
? __sanitizer_cov_trace_pc+0x1a/0x40
? tpacket_rcv+0x32c0/0x32c0
sock_sendmsg+0xc3/0x120
__sys_sendto+0x21a/0x330
? __ia32_sys_getpeername+0xb0/0xb0
? x86_pmu_start+0x30/0x270
? syscall_enter_from_user_mode+0x1c/0x70
? rcu_read_lock_sched_held+0x9c/0xd0
? rcu_read_lock_bh_held+0xb0/0xb0
__x64_sys_sendto+0xdd/0x1b0
? lockdep_hardirqs_on+0x79/0x100
? syscall_enter_from_user_mode+0x21/0x70
do_syscall_64+0x35/0xb0
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2dc0ae4469
Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 8
RSP: 002b:00007fff157b1d38 EFLAGS: 00000216 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2dc0ae4469
RDX: 000000000000000e RSI: 0000000020000100 RDI: 0000000000000005
RBP: 00007fff157b1d60 R08: 0000000020000140 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000216 R12: 000055dc98e00f10
R13: 00007fff157b1e70 R14: 0000000000000000 R15: 0000000000000000
</TASK>
Allocated by task 0:
(stack is not available)
The buggy address belongs to the object at ffff888042046000
which belongs to the cache kmalloc-2k of size 2048
The buggy address is located 2047 bytes to the right of
2048-byte region [ffff888042046000, ffff888042046800)

The buggy address belongs to the physical page:
page:ffffea0001081000 refcount:1 mapcount:0 mapping:0000000000000000 index:0x00
head:ffffea0001081000 order:3 compound_mapcount:0 compound_pincount:0
flags: 0x4fff00000010200(slab|head|node=1|zone=1|lastcpupid=0x7ff)
raw: 04fff00000010200 0000000000000000 dead000000000122 ffff888011842000
raw: 0000000000000000 0000000080080008 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd2a20(GFP_A4
prep_new_page+0x297/0x330
get_page_from_freelist+0x215f/0x3c50
__alloc_pages+0x321/0x710
alloc_pages+0x119/0x250
new_slab+0x2a9/0x3f0
___slab_alloc+0xd5a/0x1140
__slab_alloc.isra.0+0x4d/0xa0
__kmalloc_node_track_caller+0x321/0x440
kmalloc_reserve+0x32/0xd0
pskb_expand_head+0x148/0x1060
netlink_trim+0x1ea/0x240
netlink_broadcast+0x5b/0xd00
nlmsg_notify+0x8f/0x280
rtmsg_ifinfo_event.part.0+0xb6/0xe0
rtmsg_ifinfo+0x7f/0xa0
__dev_notify_flags+0x235/0x2c0
page last free stack trace:
free_pcp_prepare+0x51f/0xd00
free_unref_page+0x19/0x5b0
__unfreeze_partials+0x3d2/0x3f0
___cache_free+0x12c/0x140
qlist_free_all+0x6a/0x170
kasan_quarantine_reduce+0x13d/0x180
__kasan_slab_alloc+0xa2/0xc0
slab_post_alloc_hook+0x4d/0x4f0
kmem_cache_alloc+0x1be/0x460
getname_flags+0xd2/0x5b0
vfs_fstatat+0x73/0xb0
__do_sys_newlstat+0x8b/0x110
do_syscall_64+0x35/0xb0
entry_SYSCALL_64_after_hwframe+0x63/0xcd

Memory state around the buggy address:
ffff888042046e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff888042046f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888042046f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                                ^
ffff888042047000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff888042047080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ==================================================================
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 6447 Comm: repro Not tainted 5.19.0 #2
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 4
Call Trace:
<TASK>
dump_stack_lvl+0xcd/0x134
panic+0x2d7/0x636
? panic_print_sys_info.part.0+0x10b/0x10b
? asm_sysvec_apic_timer_interrupt+0x16/0x20
? ipvlan_queue_xmit+0x16c0/0x1950
end_report.part.0+0x3f/0x7c
kasan_report.cold+0x8/0x12
? audit_kill_trees+0x2f0/0x300
? ipvlan_queue_xmit+0x16c0/0x1950
ipvlan_queue_xmit+0x16c0/0x1950
? ipvlan_handle_mode_l3+0x120/0x120
? skb_csum_hwoffload_help+0x1a0/0x1a0
? __sanitizer_cov_trace_pc+0x1a/0x40
? validate_xmit_xfrm+0x49d/0x10a0
? __sanitizer_cov_trace_pc+0x1a/0x40
? netif_skb_features+0x45b/0xbb0
? __sanitizer_cov_trace_pc+0x1a/0x40
? validate_xmit_skb+0x878/0xec0
? __sanitizer_cov_trace_pc+0x1a/0x40
ipvlan_start_xmit+0x45/0x190
__dev_direct_xmit+0x42d/0x630
? validate_xmit_skb_list+0x140/0x140
? packet_poll+0x4d0/0x4d0
? __sanitizer_cov_trace_pc+0x1a/0x40
? netdev_pick_tx+0x14f/0xbe0
packet_direct_xmit+0x1b8/0x2b0
packet_sendmsg+0x223e/0x4d50
? __sanitizer_cov_trace_pc+0x1a/0x40
? aa_label_sk_perm+0x89/0xe0
? __sanitizer_cov_trace_pc+0x1a/0x40
? aa_sk_perm+0x30f/0xa90
? tpacket_rcv+0x32c0/0x32c0
? aa_af_perm+0x230/0x230
? __sanitizer_cov_trace_pc+0x1a/0x40
? __sanitizer_cov_trace_pc+0x1a/0x40
? tpacket_rcv+0x32c0/0x32c0
sock_sendmsg+0xc3/0x120
__sys_sendto+0x21a/0x330
? __ia32_sys_getpeername+0xb0/0xb0
? x86_pmu_start+0x30/0x270
? syscall_enter_from_user_mode+0x1c/0x70
? rcu_read_lock_sched_held+0x9c/0xd0
? rcu_read_lock_bh_held+0xb0/0xb0
__x64_sys_sendto+0xdd/0x1b0
? lockdep_hardirqs_on+0x79/0x100
? syscall_enter_from_user_mode+0x21/0x70
do_syscall_64+0x35/0xb0
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f2dc0ae4469
Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 8
RSP: 002b:00007fff157b1d38 EFLAGS: 00000216 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f2dc0ae4469
RDX: 000000000000000e RSI: 0000000020000100 RDI: 0000000000000005
RBP: 00007fff157b1d60 R08: 0000000020000140 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000216 R12: 000055dc98e00f10
R13: 00007fff157b1e70 R14: 0000000000000000 R15: 0000000000000000
</TASK>

Best Regards,
Jiacheng
