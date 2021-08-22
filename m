Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EC03F3E21
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 08:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231670AbhHVG0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 02:26:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhHVG0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 02:26:49 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8D8C061575
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 23:26:08 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id ia27so7294564ejc.10
        for <netdev@vger.kernel.org>; Sat, 21 Aug 2021 23:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :to;
        bh=CNAfzRjhVav2QWeSxdaFmJfj8lizWarrDDhuVhR3dhw=;
        b=FUuuPbaCvkFxtfMTjzlEZVRB++hlyfsuqAd7ro+gXg9uqBaXxMvFTFe6dT0GiaslZc
         diW/brh22Bs3hkVC8ifwrKbNKTLLgDJExielzwL4IA6Y6c8F7GKr2XwmexzZdp9iKGx6
         1ENqGJ5rGXDGmEI1OyudmQoFsImM7yfctSUN/xKWTESqd+92vxO5VLoUUqsaWC2mbrCX
         xynnwrf53xVj1B7SB5OwqZn6cRRH+JS/205aydEKX1Ro3KpvZjAm7gRYLVQ9RNoQE9kU
         9OHRoU6LieIJ7osJocdKWh9gTsjUKufV20tPad5paF+6kqxeVnnIe5YHnr5i6A+wbJ4Q
         FHsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:to;
        bh=CNAfzRjhVav2QWeSxdaFmJfj8lizWarrDDhuVhR3dhw=;
        b=g+lJcXR7K+ktSuSFNiR08HoZ5ECXIvkajDhCrVYdl+yyv6LeQxsRKfnWPLEZxHhjb2
         ADQetrfCkOJll7h9E8Ab8LwnyN5vMPnSuiVtmMHaP1wpl83W16hn5qMy3EC4WimINwhX
         2c1w7sNUQ52XeTocF9SV1cZ3ONlvvgUI/LOhfR//SwqiJzvBWieHDoW1+nb6x0FOqIJR
         YDnJubqOYSSiZm/VfAufbm0747g/T44lLnWjJ7vWWkkZmAps4eh7FR8qE5yYqJ1N4MKE
         5RfctvyklOG+bui1lZ7G7oederbbtWAkWWNvSNeM0SccTTIwPoDOLiX4IgpvLqqYdkKH
         pIlw==
X-Gm-Message-State: AOAM532m7TGk9iG9OUwp3z2noWkMzElAxfNigsenlm0hNnP4/lVIPoOy
        nU0Y24JKOVWjDzkg4PwAA1M=
X-Google-Smtp-Source: ABdhPJz5BGUR+X/IjdofPipEJ/mtemP+wy7iE8tML+/TA3vnblZ0KsbHXT2NuMBUlptE7OOcppjZDw==
X-Received: by 2002:a17:906:454b:: with SMTP id s11mr29844622ejq.1.1629613567361;
        Sat, 21 Aug 2021 23:26:07 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id g5sm131434edb.20.2021.08.21.23.26.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 21 Aug 2021 23:26:06 -0700 (PDT)
From:   Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Napi thread Memory leak BUG report
Message-Id: <EBFBBD1F-4A46-4136-9B7D-0A1D1F8FE399@gmail.com>
Date:   Sun, 22 Aug 2021 09:26:05 +0300
To:     Wei Wang <weiwan@google.com>, netdev <netdev@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All

One report please check=20
Server run with kernel 5.13.8 2x 10Gb Intel 82599 card in Bond LACP (~ =
5-6Gb/s  In/Out)


[1355948.840012] napi/eth0-525: page allocation failure: order:0, =
mode:0x40a20(GFP_ATOMIC|__GFP_COMP), nodemask=3D(null)
[1355948.896397] CPU: 13 PID: 3450 Comm: napi/eth0-525 Tainted: G        =
   O      5.13.8 #1
[1355948.952301] Hardware name: Supermicro Super Server/X10DRL-LN4-1701, =
BIOS 3.2 12/18/2019
[1355949.008091] Call Trace:
[1355949.035349]  dump_stack+0x65/0x7d
[1355949.062132]  warn_alloc.cold+0x6d/0xd1
[1355949.088388]  __alloc_pages_slowpath.constprop.0+0x6c7/0xa70
[1355949.114621]  ? get_page_from_freelist+0xa2/0x450
[1355949.140437]  __alloc_pages+0x17d/0x1f0
[1355949.165710]  allocate_slab+0x274/0x430
[1355949.190328]  new_slab_objects+0x7e/0x200
[1355949.214445]  ___slab_alloc.constprop.0+0x1e8/0x2a0
[1355949.238295]  ? udp4_gro_receive+0x112/0x340
[1355949.261634]  kmem_cache_alloc+0x141/0x160
[1355949.284443]  build_skb+0x1a/0x1d0
[1355949.306649]  ixgbe_clean_rx_irq+0x533/0x790 [ixgbe]
[1355949.328676]  ixgbe_poll+0xeb/0x240 [ixgbe]
[1355949.350096]  __napi_poll+0x1f/0x100
[1355949.370886]  ? __napi_poll+0x100/0x100
[1355949.391125]  napi_threaded_poll+0x105/0x150
[1355949.410963]  kthread+0x101/0x120
[1355949.430210]  ? set_kthread_struct+0x30/0x30
[1355949.449085]  ret_from_fork+0x1f/0x30
[1355949.467390] Mem-Info:
[1355949.484952] active_anon:40 inactive_anon:206285 isolated_anon:0
                  active_file:101133 inactive_file:689275 =
isolated_file:0
                  unevictable:434554 dirty:47 writeback:0
                  slab_reclaimable:46218 slab_unreclaimable:441859
                  mapped:214474 shmem:5936 pagetables:3693 bounce:0
                  free:5120 free_pcp:5520 free_cma:0
[1355949.604412] Node 0 active_anon:160kB inactive_anon:825140kB =
active_file:404532kB inactive_file:2672580kB unevictable:1738216kB =
isolated(anon):0kB isolated(file):0kB mapped:857896kB dirty:188kB =
writeback:0kB shmem:23744kB writeback_tmp:0kB kernel_stack:6872kB =
pagetables:14772kB all_unreclaimable? no
[1355949.673265] Node 0 DMA free:1568kB min:12kB low:24kB high:36kB =
reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB =
active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB =
present:15968kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB =
local_pcp:0kB free_cma:0kB
[1355949.749390] lowmem_reserve[]: 0 1760 15707 15707
[1355949.769442] Node 0 DMA32 free:7812kB min:9888kB low:11688kB =
high:13488kB reserved_highatomic:24576KB active_anon:0kB =
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB =
writepending:0kB present:1965240kB managed:1899704kB mlocked:0kB =
bounce:0kB free_pcp:13268kB local_pcp:164kB free_cma:0kB
[1355949.854135] lowmem_reserve[]: 0 0 13946 13946
[1355949.876418] Node 0 Normal free:26176kB min:78420kB low:92700kB =
high:106980kB reserved_highatomic:147456KB active_anon:160kB =
inactive_anon:825140kB active_file:404532kB inactive_file:2480324kB =
unevictable:1738216kB writepending:188kB present:14680064kB =
managed:14289204kB mlocked:0kB bounce:0kB free_pcp:10928kB local_pcp:0kB =
free_cma:0kB
[1355949.994678] lowmem_reserve[]: 0 0 0 0
[1355950.019303] Node 0 DMA: 807*4kB (U) 280*8kB (U) 48*16kB (U) 1*32kB =
(U) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 6268kB
[1355950.070229] Node 0 DMA32: 1105*4kB (H) 752*8kB (H) 290*16kB (H) =
49*32kB (H) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D =
16644kB
[1355950.122653] Node 0 Normal: 3310*4kB (MH) 31*8kB (H) 18*16kB (H) =
70*32kB (H) 23*64kB (H) 15*128kB (H) 0*256kB 0*512kB 0*1024kB 0*2048kB =
0*4096kB =3D 19408kB
[1355950.201573] 1113893 total pagecache pages
[1355950.228084] 4165318 pages RAM
[1355950.254247] 0 pages HighMem/MovableOnly
[1355950.280201] 114251 pages reserved
[1355950.305465] 0 pages hwpoisoned
[1356027.554862] warn_alloc: 5784 callbacks suppressed
[1356027.554872] napi/eth0-518: page allocation failure: order:0, =
mode:0x40a20(GFP_ATOMIC|__GFP_COMP), nodemask=3D(null)
[1356027.627708] CPU: 8 PID: 3457 Comm: napi/eth0-518 Tainted: G         =
  O      5.13.8 #1
[1356027.675338] Hardware name: Supermicro Super Server/X10DRL-LN4-1701, =
BIOS 3.2 12/18/2019
[1356027.723435] Call Trace:
[1356027.746934]  dump_stack+0x65/0x7d
[1356027.769924]  warn_alloc.cold+0x6d/0xd1
[1356027.792347]  __alloc_pages_slowpath.constprop.0+0x6c7/0xa70
[1356027.814709]  ? rmqueue_bulk.constprop.0+0x34f/0x3f0
[1356027.836880]  ? get_page_from_freelist+0xa2/0x450
[1356027.858539]  __alloc_pages+0x17d/0x1f0
[1356027.879600]  allocate_slab+0x274/0x430
[1356027.900044]  ? __alloc_pages_slowpath.constprop.0+0x6c7/0xa70
[1356027.920485]  new_slab_objects+0x7e/0x200
[1356027.940740]  ___slab_alloc.constprop.0+0x1e8/0x2a0
[1356027.960924]  ? udp4_gro_receive+0x112/0x340
[1356027.980579]  kmem_cache_alloc+0x141/0x160
[1356027.999670]  build_skb+0x1a/0x1d0
[1356028.018119]  ixgbe_clean_rx_irq+0x533/0x790 [ixgbe]
[1356028.036457]  ixgbe_poll+0xeb/0x240 [ixgbe]
[1356028.054188]  __napi_poll+0x1f/0x100
[1356028.071349]  ? __napi_poll+0x100/0x100
[1356028.088288]  napi_threaded_poll+0x105/0x150
[1356028.105353]  kthread+0x101/0x120
[1356028.122363]  ? set_kthread_struct+0x30/0x30
[1356028.139536]  ret_from_fork+0x1f/0x30
[1356028.156745] Mem-Info:
[1356028.173541] active_anon:37 inactive_anon:206076 isolated_anon:0
                  active_file:101139 inactive_file:155137 =
isolated_file:0
                  unevictable:434555 dirty:49 writeback:0
                  slab_reclaimable:27790 slab_unreclaimable:524553
                  mapped:214259 shmem:5936 pagetables:3640 bounce:0
                  free:224652 free_pcp:7824 free_cma:0
[1356028.290224] Node 0 active_anon:148kB inactive_anon:824304kB =
active_file:404556kB inactive_file:620548kB unevictable:1738220kB =
isolated(anon):0kB isolated(file):0kB mapped:857036kB dirty:196kB =
writeback:0kB shmem:23744kB writeback_tmp:0kB kernel_stack:7008kB =
pagetables:14560kB all_unreclaimable? no
[1356028.360966] Node 0 DMA free:1120kB min:12kB low:24kB high:36kB =
reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB =
active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB =
present:15968kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB =
local_pcp:0kB free_cma:0kB
[1356028.438594] lowmem_reserve[]: 0 1760 15707 15707
[1356028.458663] Node 0 DMA32 free:660100kB min:1796kB low:3596kB =
high:5396kB reserved_highatomic:24576KB active_anon:0kB =
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB =
writepending:0kB present:1965240kB managed:1899704kB mlocked:0kB =
bounce:0kB free_pcp:29044kB local_pcp:0kB free_cma:0kB
[1356028.543426] lowmem_reserve[]: 0 0 13946 13946
[1356028.565614] Node 0 Normal free:679536kB min:14232kB low:28512kB =
high:42792kB reserved_highatomic:147456KB active_anon:148kB =
inactive_anon:824304kB active_file:404556kB inactive_file:620548kB =
unevictable:1738220kB writepending:196kB present:14680064kB =
managed:14289204kB mlocked:0kB bounce:0kB free_pcp:21672kB local_pcp:0kB =
free_cma:0kB
[1356028.684006] lowmem_reserve[]: 0 0 0 0
[1356028.708597] Node 0 DMA: 648*4kB (U) 450*8kB (U) 168*16kB (U) =
25*32kB (U) 1*64kB (U) 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB =
0*4096kB =3D 9744kB
[1356028.759494] Node 0 DMA32: 65801*4kB (U) 42641*8kB (UH) 21824*16kB =
(UH) 6177*32kB (UH) 575*64kB (UH) 14*128kB (UH) 1*256kB (H) 1*512kB (H) =
1*1024kB (H) 1*2048kB (H) 5*4096kB (H) =3D 1214092kB
[1356028.837674] Node 0 Normal: 147212*4kB (UMEH) 7078*8kB (UMEH) =
2933*16kB (MEH) 486*32kB (MEH) 44*64kB (MH) 1*128kB (H) 0*256kB 0*512kB =
0*1024kB 0*2048kB 0*4096kB =3D 710896kB
[1356028.917316] 696727 total pagecache pages
[1356028.944076] 4165318 pages RAM
[1356028.970349] 0 pages HighMem/MovableOnly
[1356028.996153] 114251 pages reserved
[1356029.021345] 0 pages hwpoisoned
[1356239.854889] warn_alloc: 1098 callbacks suppressed
[1356239.854903] ksoftirqd/20: page allocation failure: order:0, =
mode:0x40a20(GFP_ATOMIC|__GFP_COMP), nodemask=3D(null)
[1356239.927530] CPU: 20 PID: 112 Comm: ksoftirqd/20 Tainted: G          =
 O      5.13.8 #1
[1356239.975205] Hardware name: Supermicro Super Server/X10DRL-LN4-1701, =
BIOS 3.2 12/18/2019
[1356240.023327] Call Trace:
[1356240.046685]  dump_stack+0x65/0x7d
[1356240.069522]  warn_alloc.cold+0x6d/0xd1
[1356240.091827]  __alloc_pages_slowpath.constprop.0+0x6c7/0xa70
[1356240.114320]  ? __dev_xmit_skb+0x220/0x4a0
[1356240.136251]  ? get_page_from_freelist+0xa2/0x450
[1356240.157797]  __alloc_pages+0x17d/0x1f0
[1356240.178828]  allocate_slab+0x274/0x430
[1356240.199190]  ? __dev_queue_xmit+0x1b4/0x2e0
[1356240.219484]  new_slab_objects+0x7e/0x200
[1356240.239473]  ___slab_alloc.constprop.0+0x1e8/0x2a0
[1356240.259117]  ? get_unique_tuple+0x357/0x420 [nf_nat]
[1356240.278395]  kmem_cache_alloc+0x141/0x160
[1356240.297123]  dst_alloc+0x3c/0x150
[1356240.315303]  rt_dst_alloc+0x33/0xa0
[1356240.332961]  ip_route_input_slow+0x4a1/0x8c0
[1356240.350229]  ? nf_nat_inet_fn+0x1f1/0x230 [nf_nat]
[1356240.367201]  ip_route_input_noref+0x11/0x30
[1356240.383945]  ip_rcv_finish_core.constprop.0+0x55/0x2b0
[1356240.400952]  ip_rcv_finish+0x5e/0x90
[1356240.417765]  __netif_receive_skb_one_core+0x40/0x50
[1356240.434909]  process_backlog+0x82/0x120
[1356240.452081]  __napi_poll+0x1f/0x100
[1356240.468974]  net_rx_action+0x206/0x2c0
[1356240.485586]  __do_softirq+0xaf/0x1da
[1356240.501604]  ? smpboot_register_percpu_thread+0xf0/0xf0
[1356240.517576]  run_ksoftirqd+0x15/0x20
[1356240.533102]  smpboot_thread_fn+0xb3/0x150
[1356240.548167]  kthread+0x101/0x120
[1356240.562600]  ? set_kthread_struct+0x30/0x30
[1356240.577174]  ret_from_fork+0x1f/0x30
[1356240.591770] Mem-Info:
[1356240.606195] active_anon:38 inactive_anon:208920 isolated_anon:0
                  active_file:100270 inactive_file:100187 =
isolated_file:0
                  unevictable:434555 dirty:0 writeback:1
                  slab_reclaimable:24595 slab_unreclaimable:549802
                  mapped:215305 shmem:6478 pagetables:3633 bounce:0
                  free:368558 free_pcp:12189 free_cma:0
[1356240.714296] Node 0 active_anon:152kB inactive_anon:835356kB =
active_file:401080kB inactive_file:400748kB unevictable:1738220kB =
isolated(anon):0kB isolated(file):0kB mapped:861220kB dirty:0kB =
writeback:4kB shmem:25912kB writeback_tmp:0kB kernel_stack:7040kB =
pagetables:14532kB all_unreclaimable? no
[1356240.783104] Node 0 DMA free:5252kB min:12kB low:24kB high:36kB =
reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB =
active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB =
present:15968kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB =
local_pcp:0kB free_cma:0kB
[1356240.860182] lowmem_reserve[]: 0 1760 15707 15707
[1356240.880198] Node 0 DMA32 free:1141080kB min:1796kB low:3596kB =
high:5396kB reserved_highatomic:24576KB active_anon:0kB =
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB =
writepending:0kB present:1965240kB managed:1899704kB mlocked:0kB =
bounce:0kB free_pcp:30348kB local_pcp:0kB free_cma:0kB
[1356240.964822] lowmem_reserve[]: 0 0 13946 13946
[1356240.987085] Node 0 Normal free:840472kB min:14232kB low:28512kB =
high:42792kB reserved_highatomic:40960KB active_anon:152kB =
inactive_anon:834340kB active_file:401472kB inactive_file:401412kB =
unevictable:1738220kB writepending:0kB present:14680064kB =
managed:14289204kB mlocked:0kB bounce:0kB free_pcp:29024kB local_pcp:0kB =
free_cma:0kB
[1356241.104959] lowmem_reserve[]: 0 0 0 0
[1356241.129468] Node 0 DMA: 405*4kB (U) 337*8kB (U) 185*16kB (U) =
80*32kB (U) 21*64kB (U) 2*128kB (U) 0*256kB 0*512kB 0*1024kB 0*2048kB =
0*4096kB =3D 11436kB
[1356241.205024] Node 0 DMA32: 59240*4kB (U) 46427*8kB (UH) 25707*16kB =
(UH) 8812*32kB (UH) 1187*64kB (UH) 32*128kB (UH) 1*256kB (H) 1*512kB (H) =
1*1024kB (H) 1*2048kB (H) 5*4096kB (H) =3D 1406056kB
[1356241.282746] Node 0 Normal: 206429*4kB (UME) 23428*8kB (UMEH) =
7597*16kB (UMEH) 528*32kB (UMEH) 23*64kB (UME) 1*128kB (H) 1*256kB (H) =
0*512kB 0*1024kB 0*2048kB 1*4096kB (H) =3D 1157540kB
[1356241.362631] 641674 total pagecache pages
[1356241.389304] 4165318 pages RAM
[1356241.415276] 0 pages HighMem/MovableOnly
[1356241.440795] 114251 pages reserved
[1356241.465679] 0 pages hwpoisoned
[1356285.739182] warn_alloc: 7 callbacks suppressed
[1356285.739194] napi/eth0-516: page allocation failure: order:0, =
mode:0x40a20(GFP_ATOMIC|__GFP_COMP), nodemask=3D(null)
[1356285.810886] CPU: 23 PID: 3459 Comm: napi/eth0-516 Tainted: G        =
   O      5.13.8 #1
[1356285.858601] Hardware name: Supermicro Super Server/X10DRL-LN4-1701, =
BIOS 3.2 12/18/2019
[1356285.906320] Call Trace:
[1356285.929481]  dump_stack+0x65/0x7d
[1356285.952212]  warn_alloc.cold+0x6d/0xd1
[1356285.974636]  __alloc_pages_slowpath.constprop.0+0x6c7/0xa70
[1356285.996991]  ? get_page_from_freelist+0xa2/0x450
[1356286.018878]  __alloc_pages+0x17d/0x1f0
[1356286.040244]  allocate_slab+0x274/0x430
[1356286.060965]  new_slab_objects+0x7e/0x200
[1356286.081529]  ___slab_alloc.constprop.0+0x1e8/0x2a0
[1356286.102074]  ? udp4_gro_receive+0x112/0x340
[1356286.122139]  kmem_cache_alloc+0x141/0x160
[1356286.141728]  build_skb+0x1a/0x1d0
[1356286.160800]  ixgbe_clean_rx_irq+0x533/0x790 [ixgbe]
[1356286.179669]  ixgbe_poll+0xeb/0x240 [ixgbe]
[1356286.198030]  __napi_poll+0x1f/0x100
[1356286.215761]  ? __napi_poll+0x100/0x100
[1356286.232933]  napi_threaded_poll+0x105/0x150
[1356286.249768]  kthread+0x101/0x120
[1356286.266320]  ? set_kthread_struct+0x30/0x30
[1356286.283042]  ret_from_fork+0x1f/0x30
[1356286.299741] Mem-Info:
[1356286.316198] active_anon:0 inactive_anon:207684 isolated_anon:0
                  active_file:80191 inactive_file:80171 isolated_file:0
                  unevictable:434554 dirty:4 writeback:1
                  slab_reclaimable:26922 slab_unreclaimable:510061
                  mapped:214935 shmem:5986 pagetables:3789 bounce:0
                  free:260119 free_pcp:6956 free_cma:0
[1356286.417849] Node 0 active_anon:0kB inactive_anon:830736kB =
active_file:320764kB inactive_file:320684kB unevictable:1738216kB =
isolated(anon):0kB isolated(file):0kB mapped:859740kB dirty:16kB =
writeback:4kB shmem:23944kB writeback_tmp:0kB kernel_stack:7516kB =
pagetables:15156kB all_unreclaimable? no
[1356286.484625] Node 0 DMA free:32kB min:12kB low:24kB high:36kB =
reserved_highatomic:0KB active_anon:0kB inactive_anon:0kB =
active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB =
present:15968kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB =
local_pcp:0kB free_cma:0kB
[1356286.558906] lowmem_reserve[]: 0 1760 15707 15707
[1356286.578387] Node 0 DMA32 free:213200kB min:1796kB low:3596kB =
high:5396kB reserved_highatomic:24576KB active_anon:0kB =
inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB =
writepending:0kB present:1965240kB managed:1899704kB mlocked:0kB =
bounce:0kB free_pcp:20524kB local_pcp:72kB free_cma:0kB
[1356286.661029] lowmem_reserve[]: 0 0 13946 13946
[1356286.682751] Node 0 Normal free:1379780kB min:14232kB low:28512kB =
high:42792kB reserved_highatomic:147456KB active_anon:0kB =
inactive_anon:830736kB active_file:320892kB inactive_file:320624kB =
unevictable:1738216kB writepending:20kB present:14680064kB =
managed:14289204kB mlocked:0kB bounce:0kB free_pcp:22504kB local_pcp:0kB =
free_cma:0kB
[1356286.798238] lowmem_reserve[]: 0 0 0 0
[1356286.822360] Node 0 DMA: 799*4kB (U) 233*8kB (U) 19*16kB (U) 1*32kB =
(U) 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 5396kB
[1356286.872132] Node 0 DMA32: 88426*4kB (U) 43078*8kB (UH) 12878*16kB =
(UH) 2447*32kB (UH) 225*64kB (UH) 4*128kB (UH) 1*256kB (H) 0*512kB =
0*1024kB 1*2048kB (H) 5*4096kB (H) =3D 1020376kB
[1356286.949783] Node 0 Normal: 223914*4kB (UMEH) 25835*8kB (UMEH) =
7041*16kB (UMEH) 682*32kB (UMEH) 102*64kB (UMH) 17*128kB (H) 0*256kB =
0*512kB 0*1024kB 0*2048kB 0*4096kB =3D 1245520kB
[1356287.030089] 600896 total pagecache pages
[1356287.057106] 4165318 pages RAM
[1356287.083694] 0 pages HighMem/MovableOnly
[1356287.109821] 114251 pages reserved
[1356287.135287] 0 pages hwpoisoned





Martin=
