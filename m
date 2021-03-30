Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B9E34E966
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 15:40:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232211AbhC3Njv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 09:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbhC3Njq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 09:39:46 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C47C061574
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:39:45 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id l15so17537343ybm.0
        for <netdev@vger.kernel.org>; Tue, 30 Mar 2021 06:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Sp0V6qJMW6UQgabwJyQu/v9sEFqpb+CS1knlwkg60z0=;
        b=Z2XtBadBnC4JS3Y7Ad+ArmOnVqKlPeHeD29OMwjVtdd9wVTIQ/OXJEUyqqFrrn8Wik
         R1GKY8fTCNjKqgsihKz4TPlRapbjMAKnpg4Wh4JPa2YmsoBGbRugERJtkL6mgoRKgW20
         ZYXbgpIbD/oHM+QV868zIcG/0U8c3mbnFxhiqlsNXyl6izt9dTs3Vo3MdDJ/z/OjMcE1
         ju4zGH0Hm8POF4pUKwHrAskzJjqx+ePr/v+krzWVTwpIHoRZ2H7vB/13F5Yj8rx7b/R1
         Vl0YOgJLt/MzfncyjqCDbNaqjphPuquyxN0uRYB1E7FcNltWMf63rED1OhvqyN5K9rNa
         jg7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Sp0V6qJMW6UQgabwJyQu/v9sEFqpb+CS1knlwkg60z0=;
        b=BAhQDIcTYAu8El47il+w5W2KrNRZ8XO5v222+L9Ow945IEJoj0r7rbewfJkJaHB65l
         VjDAsdWcgeLwkDUIzZekppNCVM8joykuae2spvc3WGCTUuoMGq6IThfp5Z5zGeQyijgr
         ZQhMT+0gMQ90kRc8WSRPfX0lKs1fNwKyELybGykHjiI0xUqwFiBLiTAHsSOjXF13qZry
         pXi5h1v0T9Ui3dt7YVxxdDRFSAHyBoy7kxro3Owq1RKXVIqWSJs1PRMBE+1cqoyJ3NrT
         vjpLJsywBSkpr5LTcb3+knSsGxgZ1RZP+K2okmw2sKbaUi5Dtuc2DkS2WnT03pCUc3+/
         rZgw==
X-Gm-Message-State: AOAM531ry4ZmIqljP93JNoP0ni7AptloFofuJDqkPIVAJLi99mRsDllZ
        7s0RZ8kHGHrm6oumKvD/FsCeEt4c8Pe6ZeN13Rbt0Q==
X-Google-Smtp-Source: ABdhPJw2dE3TYf4DcezMDyeE2D2xzMs/tGKCJZpfhYDgV3Zwod7msz4NaxzRb3G7716xmZFhB+xKiMwthrA3sJQcDAc=
X-Received: by 2002:a25:3614:: with SMTP id d20mr28798386yba.452.1617111584350;
 Tue, 30 Mar 2021 06:39:44 -0700 (PDT)
MIME-Version: 1.0
References: <20210316223647.4080796-1-weiwan@google.com> <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
 <CANn89iJxXOZktXv6Arh82OAGOpn523NuOcWFDaSmJriOaXQMRw@mail.gmail.com> <AE7C80D4-DD7E-4AA7-B261-A66B30F57D3B@gmail.com>
In-Reply-To: <AE7C80D4-DD7E-4AA7-B261-A66B30F57D3B@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Mar 2021 15:39:32 +0200
Message-ID: <CANn89iKyWgYeD_B-iJxL50C4BHYiDh+dWOyFYXatteF=eU7zoA@mail.gmail.com>
Subject: Re: [PATCH net v4] net: fix race between napi kthread mode and busy poll
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 11:25 AM Martin Zaharinov <micron10@gmail.com> wrot=
e:
>
> Hi Eric and Wei
>
> Please check this log :
>

Please send a normal report to netdev.

This has nothing to to with us (Eric & Wei)

Thanks.

>
> 1584288.951272] napi/eth0-523: page allocation failure: order:0, mode:0x4=
0a20(GFP_ATOMIC|__GFP_COMP), nodemask=3D(null)
> [1584289.003674] CPU: 4 PID: 3179 Comm: napi/eth0-523 Tainted: G         =
  O      5.11.4 #1
> [1584289.055545] Hardware name: Supermicro SYS-5038MR-H8TRF/X10SRD-F, BIO=
S 3.2 11/22/2019
> [1584289.107263] Call Trace:
> [1584289.107266]  dump_stack+0x58/0x6b
> [1584289.209562]  warn_alloc.cold+0x70/0xd4
> [1584289.209569]  __alloc_pages_slowpath.constprop.0+0xd57/0xfb0
> [1584289.209574]  __alloc_pages_nodemask+0x15a/0x180
> [1584289.474009]  allocate_slab+0x272/0x450
> [1584289.496731]  ___slab_alloc.constprop.0+0x41e/0x4d0
> [1584289.519147]  kmem_cache_alloc+0x110/0x120
> [1584289.541416]  build_skb+0x1a/0x200
> [1584289.563121]  ixgbe_clean_rx_irq+0x5fc/0xa10 [ixgbe]
> [1584289.584618]  ixgbe_poll+0xeb/0x2a0 [ixgbe]
> [1584289.605528]  __napi_poll+0x1f/0x130
> [1584289.625842]  napi_threaded_poll+0x110/0x160
> [1584289.646110]  ? __napi_poll+0x130/0x130
> [1584289.665810]  kthread+0xea/0x120
> [1584289.684836]  ? kthread_park+0x80/0x80
> [1584289.703440]  ret_from_fork+0x1f/0x30
> [1584289.721616] Mem-Info:
> [1584289.739066] active_anon:8157 inactive_anon:2100191 isolated_anon:0
>                   active_file:17408 inactive_file:149 isolated_file:32
>                   unevictable:1440359 dirty:17500 writeback:0
>                   slab_reclaimable:43368 slab_unreclaimable:155124
>                   mapped:817431 shmem:7650 pagetables:32093 bounce:0
>                   free:17832 free_pcp:113 free_cma:0
> [1584289.842614] Node 0 active_anon:32628kB inactive_anon:8400764kB activ=
e_file:69312kB inactive_file:880kB unevictable:5761436kB isolated(anon):0kB=
 isolated(file):128kB mapped:3269724kB dirty:69740kB writeback:0kB shmem:30=
600kB writeback_tmp:0kB kernel_stack:5376kB pagetables:128372kB all_unrecla=
imable? no
> [1584289.913793] Node 0 DMA free:13836kB min:12kB low:24kB high:36kB rese=
rved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inact=
ive_file:0kB unevictable:0kB writepending:0kB present:15968kB managed:15884=
kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [1584289.986882] lowmem_reserve[]: 0 1741 15726 15726
> [1584290.005519] Node 0 DMA32 free:54448kB min:9780kB low:11560kB high:13=
340kB reserved_highatomic:24576KB active_anon:5104kB inactive_anon:760844kB=
 active_file:51532kB inactive_file:388kB unevictable:885428kB writepending:=
51744kB present:1965124kB managed:1899588kB mlocked:0kB bounce:0kB free_pcp=
:684kB local_pcp:0kB free_cma:0kB
> [1584290.104980] lowmem_reserve[]: 0 0 13985 13985
> [1584290.125807] Node 0 Normal free:2288kB min:78608kB low:92928kB high:1=
07248kB reserved_highatomic:32768KB active_anon:27524kB inactive_anon:76399=
20kB active_file:17776kB inactive_file:1304kB unevictable:4876016kB writepe=
nding:17736kB present:14680064kB managed:14326620kB mlocked:0kB bounce:0kB =
free_pcp:288kB local_pcp:28kB free_cma:0kB
> [1584290.237051] lowmem_reserve[]: 0 0 0 0
> [1584290.260423] Node 0 DMA: 1*4kB (U) 1*8kB (U) 0*16kB 0*32kB 2*64kB (U)=
 1*128kB (U) 1*256kB (U) 0*512kB 1*1024kB (U) 0*2048kB 3*4096kB (M) =3D 138=
36kB
> [1584290.308847] Node 0 DMA32: 12500*4kB (UMEH) 553*8kB (MH) 0*16kB 0*32k=
B 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 54424kB
> [1584290.358363] Node 0 Normal: 0*4kB 25*8kB (H) 0*16kB 5*32kB (H) 1*64kB=
 (H) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 424kB
> [1584290.409087] 1465768 total pagecache pages
> [1584290.434531] 4165289 pages RAM
> [1584290.459616] 0 pages HighMem/MovableOnly
> [1584290.484480] 104766 pages reserved
> [1584290.508709] 0 pages hwpoisoned
> [1584301.710231] team0: Failed to send options change via netlink (err -1=
05)
> [1584302.635731] telegraf invoked oom-killer: gfp_mask=3D0x400dc0(GFP_KER=
NEL_ACCOUNT|__GFP_ZERO), order=3D1, oom_score_adj=3D0
> [1584302.682874] CPU: 0 PID: 3494492 Comm: telegraf Tainted: G           =
O      5.11.4 #1
> [1584302.729535] Hardware name: Supermicro SYS-5038MR-H8TRF/X10SRD-F, BIO=
S 3.2 11/22/2019
> [1584302.776532] Call Trace:
> [1584302.799361]  dump_stack+0x58/0x6b
> [1584302.821791]  dump_header+0x4c/0x2e6
> [1584302.843580]  oom_kill_process.cold+0xb/0x10
> [1584302.865223]  out_of_memory.part.0+0x125/0x5f0
> [1584302.886641]  out_of_memory+0x54/0xa0
> [1584302.907302]  __alloc_pages_slowpath.constprop.0+0xb03/0xfb0
> [1584302.927913]  __alloc_pages_nodemask+0x15a/0x180
> [1584302.947874]  __get_free_pages+0x8/0x30
> [1584302.967246]  pgd_alloc+0x21/0x180
> [1584302.986355]  mm_alloc+0x1af/0x250
> [1584303.005085]  alloc_bprm+0x80/0x2a0
> [1584303.023328]  do_execveat_common+0x8b/0x330
> [1584303.041181]  __x64_sys_execve+0x2b/0x40
> [1584303.058513]  do_syscall_64+0x2d/0x40
> [1584303.075281]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [1584303.091891] RIP: 0033:0x488376
> [1584303.108045] Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc=
 cc cc cc 48 8b 7c 24 10 48 8b 74 24 18 48 8b 54 24 20 48 8b 44 24 08 0f 05=
 <48> 3d 01 f0 ff ff 76 1b 48 c7 44 24 28 ff ff ff ff 48 c7 44 24 30
> [1584303.159632] RSP: 002b:000000c001108528 EFLAGS: 00000206 ORIG_RAX: 00=
0000000000003b
> [1584303.195446] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 0000000=
000488376
> [1584303.231451] RDX: 000000c002b1a080 RSI: 000000c0028432e0 RDI: 000000c=
000cae660
> [1584303.267407] RBP: 000000c0011086c8 R08: 0000000000000018 R09: 0000000=
000000000
> [1584303.303594] R10: 0000000000000008 R11: 0000000000000206 R12: 0000000=
00047f258
> [1584303.340218] R13: 000000000000000e R14: 000000000000000d R15: 0000000=
000000100
> [1584303.379094] Mem-Info:
> [1584303.398713] active_anon:8159 inactive_anon:2138194 isolated_anon:0
>                   active_file:12975 inactive_file:168 isolated_file:32
>                   unevictable:909709 dirty:12864 writeback:10
>                   slab_reclaimable:42415 slab_unreclaimable:154783
>                   mapped:39825 shmem:14744 pagetables:26041 bounce:0
>                   free:537002 free_pcp:1813 free_cma:0
> [1584303.547011] Node 0 active_anon:32636kB inactive_anon:8552776kB activ=
e_file:51476kB inactive_file:1112kB unevictable:3638836kB isolated(anon):0k=
B isolated(file):128kB mapped:159480kB dirty:51024kB writeback:28kB shmem:5=
8976kB writeback_tmp:0kB kernel_stack:5392kB pagetables:104164kB all_unrecl=
aimable? no
> [1584303.640025] Node 0 DMA free:13428kB min:12kB low:24kB high:36kB rese=
rved_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inact=
ive_file:0kB unevictable:0kB writepending:0kB present:15968kB managed:15884=
kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [1584303.739414] lowmem_reserve[]: 0 1741 15726 15726
> [1584303.764535] Node 0 DMA32 free:121320kB min:5872kB low:7652kB high:94=
32kB reserved_highatomic:24576KB active_anon:5104kB inactive_anon:761140kB =
active_file:37160kB inactive_file:772kB unevictable:885428kB writepending:3=
7672kB present:1965124kB managed:1899588kB mlocked:0kB bounce:0kB free_pcp:=
1448kB local_pcp:0kB free_cma:0kB
> [1584303.888935] lowmem_reserve[]: 0 0 13985 13985
> [1584303.913532] Node 0 Normal free:1970692kB min:78608kB low:92928kB hig=
h:107248kB reserved_highatomic:126976KB active_anon:27524kB inactive_anon:7=
812248kB active_file:13664kB inactive_file:1528kB unevictable:2753408kB wri=
tepending:12888kB present:14680064kB managed:14326620kB mlocked:0kB bounce:=
0kB free_pcp:4076kB local_pcp:0kB free_cma:0kB
> [1584304.036531] lowmem_reserve[]: 0 0 0 0
> [1584304.060733] Node 0 DMA: 1*4kB (U) 40*8kB (U) 37*16kB (U) 32*32kB (U)=
 24*64kB (U) 14*128kB (U) 8*256kB (U) 2*512kB (U) 1*1024kB (U) 0*2048kB 1*4=
096kB (M) =3D 13460kB
> [1584304.134551] Node 0 DMA32: 15098*4kB (UMEH) 6204*8kB (UMEH) 662*16kB =
(UMEH) 20*32kB (UMEH) 1*64kB (U) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB =
0*4096kB =3D 121320kB
> [1584304.209349] Node 0 Normal: 1038*4kB (UEH) 392*8kB (EH) 56*16kB (UEH)=
 28*32kB (UEH) 14*64kB (MEH) 25*128kB (MEH) 6*256kB (MH) 3*512kB (UMH) 3*10=
24kB (MH) 5*2048kB (UMH) 472*4096kB (U) =3D 1962872kB
> [1584304.287094] 933871 total pagecache pages
> [1584304.312815] 4165289 pages RAM
> [1584304.337915] 0 pages HighMem/MovableOnly
> [1584304.362522] 104766 pages reserved
> [1584304.386516] 0 pages hwpoisoned
>
> > On 20 Mar 2021, at 11:55, Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sat, Mar 20, 2021 at 9:45 AM Martin Zaharinov <micron10@gmail.com> w=
rote:
> >>
> >> Hi Wei
> >> Check this:
> >>
> >> [   39.706567] ------------[ cut here ]------------
> >> [   39.706568] RTNL: assertion failed at net/ipv4/udp_tunnel_nic.c (55=
7)
> >> [   39.706585] WARNING: CPU: 0 PID: 429 at net/ipv4/udp_tunnel_nic.c:5=
57 __udp_tunnel_nic_reset_ntf+0xea/0x100
> >
> > Probably more relevant to Intel maintainers than Wei :/
> >
> >> [   39.706594] Modules linked in: i40e(+) nf_nat_sip nf_conntrack_sip =
nf_nat_pptp nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp nf_c=
onntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ip=
mi_si ipmi_devintf ipmi_msghandler rtc_cmos megaraid_sas
> >> [   39.706614] CPU: 0 PID: 429 Comm: kworker/0:2 Tainted: G           =
O      5.11.7 #1
> >> [   39.706618] Hardware name: Supermicro X11DPi-N(T)/X11DPi-NT, BIOS 3=
.4 11/23/2020
> >> [   39.706619] Workqueue: events work_for_cpu_fn
> >> [   39.706627] RIP: 0010:__udp_tunnel_nic_reset_ntf+0xea/0x100
> >> [   39.706631] Code: c0 79 f1 00 00 0f 85 4e ff ff ff ba 2d 02 00 00 4=
8 c7 c6 45 3c 3a 93 48 c7 c7 40 de 39 93 c6 05 a0 79 f1 00 01 e8 f5 ad 0c 0=
0 <0f> 0b e9 28 ff ff ff 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00
> >> [   39.706634] RSP: 0018:ffffa8390d9b3b38 EFLAGS: 00010292
> >> [   39.706637] RAX: 0000000000000039 RBX: ffff8e02630b2768 RCX: 000000=
00ffdfffff
> >> [   39.706639] RDX: 00000000ffdfffff RSI: ffff8e80ad400000 RDI: 000000=
0000000001
> >> [   39.706641] RBP: ffff8e025df72000 R08: ffff8e80bb3fffe8 R09: 000000=
00ffffffea
> >> [   39.706643] R10: 00000000ffdfffff R11: 80000000ffe00000 R12: ffff8e=
02630b2008
> >> [   39.706645] R13: 0000000000000000 R14: ffff8e024a88ba00 R15: 000000=
0000000000
> >> [   39.706646] FS:  0000000000000000(0000) GS:ffff8e40bf800000(0000) k=
nlGS:0000000000000000
> >> [   39.706649] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [   39.706651] CR2: 00000000004d8f40 CR3: 0000002ca140a002 CR4: 000000=
00001706f0
> >> [   39.706652] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000=
0000000000
> >> [   39.706654] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000=
0000000400
> >> [   39.706656] Call Trace:
> >> [   39.706658]  i40e_setup_pf_switch+0x617/0xf80 [i40e]
> >> [   39.706683]  i40e_probe.part.0.cold+0x8dc/0x109e [i40e]
> >> [   39.706708]  ? acpi_ns_check_object_type+0xd4/0x193
> >> [   39.706713]  ? acpi_ns_check_package_list+0xfd/0x205
> >> [   39.706716]  ? __kmalloc+0x37/0x160
> >> [   39.706720]  ? kmem_cache_alloc+0xcb/0x120
> >> [   39.706723]  ? irq_get_irq_data+0x5/0x20
> >> [   39.706726]  ? mp_check_pin_attr+0xe/0xf0
> >> [   39.706729]  ? irq_get_irq_data+0x5/0x20
> >> [   39.706731]  ? mp_map_pin_to_irq+0xb7/0x2c0
> >> [   39.706735]  ? acpi_register_gsi_ioapic+0x86/0x150
> >> [   39.706739]  ? pci_conf1_read+0x9f/0xf0
> >> [   39.706743]  ? pci_bus_read_config_word+0x2e/0x40
> >> [   39.706746]  local_pci_probe+0x1b/0x40
> >> [   39.706750]  work_for_cpu_fn+0xb/0x20
> >> [   39.706754]  process_one_work+0x1ec/0x350
> >> [   39.706758]  worker_thread+0x24b/0x4d0
> >> [   39.706760]  ? process_one_work+0x350/0x350
> >> [   39.706762]  kthread+0xea/0x120
> >> [   39.706766]  ? kthread_park+0x80/0x80
> >> [   39.706770]  ret_from_fork+0x1f/0x30
> >> [   39.706774] ---[ end trace 7a203f3ec972a377 ]---
> >>
> >> Martin
> >>
> >>
> >>> On 17 Mar 2021, at 0:36, Wei Wang <weiwan@google.com> wrote:
> >>>
> >>> Currently, napi_thread_wait() checks for NAPI_STATE_SCHED bit to
> >>> determine if the kthread owns this napi and could call napi->poll() o=
n
> >>> it. However, if socket busy poll is enabled, it is possible that the
> >>> busy poll thread grabs this SCHED bit (after the previous napi->poll(=
)
> >>> invokes napi_complete_done() and clears SCHED bit) and tries to poll
> >>> on the same napi. napi_disable() could grab the SCHED bit as well.
> >>> This patch tries to fix this race by adding a new bit
> >>> NAPI_STATE_SCHED_THREADED in napi->state. This bit gets set in
> >>> ____napi_schedule() if the threaded mode is enabled, and gets cleared
> >>> in napi_complete_done(), and we only poll the napi in kthread if this
> >>> bit is set. This helps distinguish the ownership of the napi between
> >>> kthread and other scenarios and fixes the race issue.
> >>>
> >>> Fixes: 29863d41bb6e ("net: implement threaded-able napi poll loop sup=
port")
> >>> Reported-by: Martin Zaharinov <micron10@gmail.com>
> >>> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> >>> Signed-off-by: Wei Wang <weiwan@google.com>
> >>> Cc: Alexander Duyck <alexanderduyck@fb.com>
> >>> Cc: Eric Dumazet <edumazet@google.com>
> >>> Cc: Paolo Abeni <pabeni@redhat.com>
> >>> Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
> >>> ---
> >>> Change since v3:
> >>> - Add READ_ONCE() for thread->state and add comments in
> >>>   ____napi_schedule().
> >>>
> >>> include/linux/netdevice.h |  2 ++
> >>> net/core/dev.c            | 19 ++++++++++++++++++-
> >>> 2 files changed, 20 insertions(+), 1 deletion(-)
> >>>
> >>> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> >>> index 5b67ea89d5f2..87a5d186faff 100644
> >>> --- a/include/linux/netdevice.h
> >>> +++ b/include/linux/netdevice.h
> >>> @@ -360,6 +360,7 @@ enum {
> >>>      NAPI_STATE_IN_BUSY_POLL,        /* sk_busy_loop() owns this NAPI=
 */
> >>>      NAPI_STATE_PREFER_BUSY_POLL,    /* prefer busy-polling over soft=
irq processing*/
> >>>      NAPI_STATE_THREADED,            /* The poll is performed inside =
its own thread*/
> >>> +     NAPI_STATE_SCHED_THREADED,      /* Napi is currently scheduled =
in threaded mode */
> >>> };
> >>>
> >>> enum {
> >>> @@ -372,6 +373,7 @@ enum {
> >>>      NAPIF_STATE_IN_BUSY_POLL        =3D BIT(NAPI_STATE_IN_BUSY_POLL)=
,
> >>>      NAPIF_STATE_PREFER_BUSY_POLL    =3D BIT(NAPI_STATE_PREFER_BUSY_P=
OLL),
> >>>      NAPIF_STATE_THREADED            =3D BIT(NAPI_STATE_THREADED),
> >>> +     NAPIF_STATE_SCHED_THREADED      =3D BIT(NAPI_STATE_SCHED_THREAD=
ED),
> >>> };
> >>>
> >>> enum gro_result {
> >>> diff --git a/net/core/dev.c b/net/core/dev.c
> >>> index 6c5967e80132..d3195a95f30e 100644
> >>> --- a/net/core/dev.c
> >>> +++ b/net/core/dev.c
> >>> @@ -4294,6 +4294,13 @@ static inline void ____napi_schedule(struct so=
ftnet_data *sd,
> >>>               */
> >>>              thread =3D READ_ONCE(napi->thread);
> >>>              if (thread) {
> >>> +                     /* Avoid doing set_bit() if the thread is in
> >>> +                      * INTERRUPTIBLE state, cause napi_thread_wait(=
)
> >>> +                      * makes sure to proceed with napi polling
> >>> +                      * if the thread is explicitly woken from here.
> >>> +                      */
> >>> +                     if (READ_ONCE(thread->state) !=3D TASK_INTERRUP=
TIBLE)
> >>> +                             set_bit(NAPI_STATE_SCHED_THREADED, &nap=
i->state);
> >>>                      wake_up_process(thread);
> >>>                      return;
> >>>              }
> >>> @@ -6486,6 +6493,7 @@ bool napi_complete_done(struct napi_struct *n, =
int work_done)
> >>>              WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
> >>>
> >>>              new =3D val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
> >>> +                           NAPIF_STATE_SCHED_THREADED |
> >>>                            NAPIF_STATE_PREFER_BUSY_POLL);
> >>>
> >>>              /* If STATE_MISSED was set, leave STATE_SCHED set,
> >>> @@ -6968,16 +6976,25 @@ static int napi_poll(struct napi_struct *n, s=
truct list_head *repoll)
> >>>
> >>> static int napi_thread_wait(struct napi_struct *napi)
> >>> {
> >>> +     bool woken =3D false;
> >>> +
> >>>      set_current_state(TASK_INTERRUPTIBLE);
> >>>
> >>>      while (!kthread_should_stop() && !napi_disable_pending(napi)) {
> >>> -             if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
> >>> +             /* Testing SCHED_THREADED bit here to make sure the cur=
rent
> >>> +              * kthread owns this napi and could poll on this napi.
> >>> +              * Testing SCHED bit is not enough because SCHED bit mi=
ght be
> >>> +              * set by some other busy poll thread or by napi_disabl=
e().
> >>> +              */
> >>> +             if (test_bit(NAPI_STATE_SCHED_THREADED, &napi->state) |=
| woken) {
> >>>                      WARN_ON(!list_empty(&napi->poll_list));
> >>>                      __set_current_state(TASK_RUNNING);
> >>>                      return 0;
> >>>              }
> >>>
> >>>              schedule();
> >>> +             /* woken being true indicates this thread owns this nap=
i. */
> >>> +             woken =3D true;
> >>>              set_current_state(TASK_INTERRUPTIBLE);
> >>>      }
> >>>      __set_current_state(TASK_RUNNING);
> >>> --
> >>> 2.31.0.rc2.261.g7f71774620-goog
> >>>
> >>
>
