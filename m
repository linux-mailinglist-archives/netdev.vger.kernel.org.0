Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F34D6DBB0A
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 14:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjDHM64 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 8 Apr 2023 08:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDHM6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Apr 2023 08:58:55 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C9AFAF3F;
        Sat,  8 Apr 2023 05:58:50 -0700 (PDT)
Received: from kwepemm600001.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PtwFH1tcMznb7Z;
        Sat,  8 Apr 2023 20:55:15 +0800 (CST)
Received: from dggpeml500020.china.huawei.com (7.185.36.88) by
 kwepemm600001.china.huawei.com (7.193.23.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sat, 8 Apr 2023 20:58:44 +0800
Received: from dggpeml500020.china.huawei.com ([7.185.36.88]) by
 dggpeml500020.china.huawei.com ([7.185.36.88]) with mapi id 15.01.2507.023;
 Sat, 8 Apr 2023 20:58:44 +0800
From:   "jiangheng (G)" <jiangheng14@huawei.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        "Chuck Lever" <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [BUG REPORT] softlock up in sunrpc xprt_end_transmit
Thread-Topic: [BUG REPORT] softlock up in sunrpc xprt_end_transmit
Thread-Index: AdlqGVZwXbatbSlrR027WDTuyoZcSQ==
Date:   Sat, 8 Apr 2023 12:58:44 +0000
Message-ID: <a666574cbc40467698108abd664d47c4@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.117.195]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,
on linux 5.10, When we performed a pressure test on the nfs, a soft lock appeared in the sunrpc. The call stack is as follows::

[ 9101.352822] nfs: Unknown parameter 'time'
[ 9101.352866] nfs: Unknown parameter 'time'
[ 9101.352897] nfs: Unknown parameter 'time'
[ 9101.371096] nfs: Unknown parameter 'time'
[ 9113.565686] WARN: soft lockup - CPU#0 stuck for 11s! [mount.nfs:416907] [ 9113.566231] Sample time: 9113152707554 ns(HZ: 250) [ 9113.566232] Sample stat: 
[ 9113.566235]  curr: user: 704341612740, nice: 147841070, sys: 3534402945130, idle: 4282970293860, iowait: 490295074600, irq: 42190618900, softirq: 58359875870, st: 0 [ 9113.566237]  deta: user: 704341612740, nice: 147841070, sys: 3534402945130, idle: 4282970293860, iowait: 490295074600, irq: 42190618900, softirq: 58359875870, st: 0 [ 9113.566237] Sample softirq:
[ 9113.566239]        TIMER:     529280
[ 9113.566240]       NET_TX:       1796
[ 9113.566241]       NET_RX:     919176
[ 9113.566242]        BLOCK:    2853203
[ 9113.566243]      TASKLET:      39177
[ 9113.566244]        SCHED:    1127611
[ 9113.566245]      HRTIMER:          7
[ 9113.566246]          RCU:    3058196
[ 9113.566247] Sample irqstat:
[ 9113.566249]     irq    1: delta    4574226, curr:    4574226, IPI
[ 9113.566250]     irq    2: delta      93760, curr:      93760, IPI
[ 9113.566253]     irq   12: delta    2337685, curr:    2337685, arch_timer
[ 9113.566262]     irq   48: delta         51, curr:         51, ehci_hcd:usb1
[ 9113.566265]     irq   53: delta          1, curr:          1, PCIe PME
[ 9113.566267]     irq   57: delta          1, curr:          1, PCIe PME
[ 9113.566269]     irq   61: delta          6, curr:          6, PCIe PME
[ 9113.566271]     irq   65: delta          6, curr:          6, PCIe PME
[ 9113.566273]     irq   69: delta          6, curr:          6, PCIe PME
[ 9113.566276]     irq   73: delta          6, curr:          6, PCIe PME
[ 9113.566279]     irq   81: delta      18528, curr:      18528, virtio2-input.0
[ 9113.566281]     irq   82: delta     665654, curr:     665654, virtio2-output.0
[ 9113.566284]     irq   87: delta     153505, curr:     153505, virtio4-input.0
[ 9113.566286]     irq   90: delta      12792, curr:      12792, virtio1-control
[ 9113.566288]     irq   94: delta          2, curr:          2, virtio5-event
[ 9113.566290]     irq   95: delta    3017695, curr:    3017695, virtio5-request
[ 9113.566295] CPU: 0 PID: 416907 Comm: mount.nfs Kdump: loaded Tainted: G           O      5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64 #1
[ 9113.566296] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 [ 9113.566298] Call trace:
[ 9113.566304]  dump_backtrace+0x0/0x1e4 [ 9113.566307]  show_stack+0x20/0x2c [ 9113.566313]  dump_stack+0xd8/0x140 [ 9113.566315]  watchdog_print_info+0x48/0x54 [ 9113.566318]  watchdog_process_before_softlockup+0x98/0xa0
[ 9113.566319]  watchdog_timer_fn+0x1ac/0x2d0 [ 9113.566322]  __run_hrtimer+0x98/0x2a0 [ 9113.566323]  __hrtimer_run_queues+0xbc/0x130 [ 9113.566325]  hrtimer_interrupt+0x13c/0x3c0 [ 9113.566330]  arch_timer_handler_virt+0x3c/0x50 [ 9113.566332]  handle_percpu_devid_irq+0x90/0x1f4
[ 9113.566335]  generic_handle_irq+0x58/0x70 [ 9113.566336]  __handle_domain_irq+0x6c/0xe0 [ 9113.566338]  gic_handle_irq+0x88/0x2b0 [ 9113.566340]  el1_irq+0xb8/0x140 [ 9113.566388]  xprt_reserve_xprt_cong+0x58/0x1c0 [sunrpc] [ 9113.566407]  xprt_prepare_transmit+0xb0/0x110 [sunrpc] [ 9113.566426]  call_transmit+0x34/0xb4 [sunrpc] [ 9113.566444]  __rpc_execute+0x74/0x400 [sunrpc] [ 9113.566462]  rpc_execute+0x68/0x90 [sunrpc] [ 9113.566479]  rpc_run_task+0x98/0x110 [sunrpc] [ 9113.566497]  rpc_call_sync+0x64/0xc4 [sunrpc] [ 9113.566529]  nfs_mount+0x114/0x27c [nfs] [ 9113.566543]  nfs_request_mount.constprop.0.isra.0+0xd0/0x1d4 [nfs] [ 9113.566555]  nfs_try_mount_request+0x54/0x2bc [nfs] [ 9113.566566]  nfs_try_get_tree+0x58/0xec [nfs] [ 9113.566577]  nfs_get_tree+0x44/0x6c [nfs] [ 9113.566582]  vfs_get_tree+0x30/0xf4 [ 9113.566585]  do_new_mount+0x16c/0x1e0 [ 9113.566587]  path_mount+0x1bc/0x2c0 [ 9113.566589]  __arm64_sys_mount+0x114/0x140 [ 9113.566591]  el0_svc_common.constprop.0+0x7c/0x1bc
[ 9113.566592]  do_el0_svc+0x2c/0x94
[ 9113.566595]  el0_svc+0x20/0x30
[ 9113.566597]  el0_sync_handler+0xb0/0xb4 [ 9113.566608]  el0_sync+0x160/0x180 [ 9125.566258] watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [mount.nfs:416907] [ 9125.566871] Modules linked in: kbox(O) kboxdriver(O) sch_netem nfsv3 nfs_acl cts rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd grace nfs_ssc fscache xfs binfmt_misc nft_fib_inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_tables ebtable_nat ebtable_broute ip6table_nat ip6table_mangle ip6table_raw ip6table_security iptable_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_mangle iptable_raw iptable_security rfkill ip_set nfnetlink ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter ip_tables sysmonitor(O) sunrpc sg vfat fat sch_fq_codel fuse ksecurec(O) ext4 mbcache jbd2 sd_mod t10_pi virtio_scsi virtio_gpu ghash_ce sha2_ce virtio_net net_failover failover virtio_console virtio_dma_buf sha256_arm64 sha1_ce virtio_pci virtio_mmio virtio_ring virtio dm_mirror dm_region_hash dm_log dm_mod aes_neon_bs aes_neon_blk aes_ce_blk crypto_simd cryptd aes_ce_cipher [ 9125.566963]  [last unloaded: kboxdriver] [ 9125.566967] Sample time: 9125152869899 ns(HZ: 250) [ 9125.566968] Sample stat: 
[ 9125.566971]  curr: user: 704341612740, nice: 147841070, sys: 3546387321660, idle: 4282970293860, iowait: 490295074600, irq: 42206243200, softirq: 58359875870, st: 0 [ 9125.566973]  deta: user: 704341612740, nice: 147841070, sys: 3546387321660, idle: 4282970293860, iowait: 490295074600, irq: 42206243200, softirq: 58359875870, st: 0 [ 9125.566974] Sample softirq:
[ 9125.566976]        TIMER:     529280
[ 9125.566977]       NET_TX:       1796
[ 9125.566978]       NET_RX:     919176
[ 9125.566978]        BLOCK:    2853203
[ 9125.566979]      TASKLET:      39177
[ 9125.566981]        SCHED:    1127611
[ 9125.566981]      HRTIMER:          7
[ 9125.566982]          RCU:    3058196
[ 9125.566984] Sample irqstat:
[ 9125.566986]     irq    1: delta    4574226, curr:    4574226, IPI
[ 9125.566987]     irq    2: delta      93760, curr:      93760, IPI
[ 9125.566990]     irq   12: delta    2340688, curr:    2340688, arch_timer
[ 9125.566999]     irq   48: delta         51, curr:         51, ehci_hcd:usb1
[ 9125.567002]     irq   53: delta          1, curr:          1, PCIe PME
[ 9125.567004]     irq   57: delta          1, curr:          1, PCIe PME
[ 9125.567006]     irq   61: delta          6, curr:          6, PCIe PME
[ 9125.567008]     irq   65: delta          6, curr:          6, PCIe PME
[ 9125.567010]     irq   69: delta          6, curr:          6, PCIe PME
[ 9125.567012]     irq   73: delta          6, curr:          6, PCIe PME
[ 9125.567016]     irq   81: delta      18528, curr:      18528, virtio2-input.0
[ 9125.567018]     irq   82: delta     665654, curr:     665654, virtio2-output.0
[ 9125.567019]     irq   84: delta          1, curr:          1, virtio3-input.0
[ 9125.567022]     irq   87: delta     153505, curr:     153505, virtio4-input.0
[ 9125.567024]     irq   90: delta      12792, curr:      12792, virtio1-control
[ 9125.567026]     irq   94: delta          2, curr:          2, virtio5-event
[ 9125.567028]     irq   95: delta    3017696, curr:    3017696, virtio5-request
[ 9125.567032] CPU: 0 PID: 416907 Comm: mount.nfs Kdump: loaded Tainted: G           O      5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64 #1
[ 9125.567034] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 [ 9125.567036] pstate: 60400005 (nZCv daif +PAN -UAO -TCO BTYPE=--) [ 9125.567080] pc : xprt_end_transmit+0xb8/0x124 [sunrpc] [ 9125.567100] lr : call_transmit+0xa4/0xb4 [sunrpc] [ 9125.567101] sp : ffff80010aa83910 [ 9125.567102] x29: ffff80010aa83910 x28: ffff00004aaf2680 [ 9125.567105] x27: 0000000000000000 x26: ffff8001017a2098 [ 9125.567107] x25: 0000000000000000 x24: ffff80010143d008 [ 9125.567109] x23: ffff80010143d008 x22: ffff0000d3fa7690 [ 9125.567111] x21: ffff800081033210 x20: ffff0000591d8c00 [ 9125.567113] x19: ffff0000d3fa7000 x18: 0000000000000000 [ 9125.567116] x17: 0000000000000000 x16: ffff800100b08770 [ 9125.567118] x15: 0000000000000004 x14: ffff8001017d49f0 [ 9125.567120] x13: 0000000000000000 x12: 0000000000000030 [ 9125.567122] x11: 0000000000000000 x10: 0000000000000001 [ 9125.567124] x9 : ffff8000810332b4 x8 : ffffffffffffff9b [ 9125.567126] x7 : 0000000000000001 x6 : 0000000000000000 [ 9125.567128] x5 : 00007dffc1b5e988 x4 : 0000000000000000 [ 9125.567130] x3 : 0000000000000000 x2 : 0000000000000001 [ 9125.567132] x1 : 0000000000000000 x0 : ffff0000d3fa7690 [ 9125.567135] Call trace:
[ 9125.567156]  xprt_end_transmit+0xb8/0x124 [sunrpc] [ 9125.567174]  call_transmit+0xa4/0xb4 [sunrpc] [ 9125.567193]  __rpc_execute+0x74/0x400 [sunrpc] [ 9125.567210]  rpc_execute+0x68/0x90 [sunrpc] [ 9125.567228]  rpc_run_task+0x98/0x110 [sunrpc] [ 9125.567246]  rpc_call_sync+0x64/0xc4 [sunrpc] [ 9125.567278]  nfs_mount+0x114/0x27c [nfs] [ 9125.567291]  nfs_request_mount.constprop.0.isra.0+0xd0/0x1d4 [nfs] [ 9125.567302]  nfs_try_mount_request+0x54/0x2bc [nfs] [ 9125.567314]  nfs_try_get_tree+0x58/0xec [nfs] [ 9125.567325]  nfs_get_tree+0x44/0x6c [nfs] [ 9125.567330]  vfs_get_tree+0x30/0xf4 [ 9125.567334]  do_new_mount+0x16c/0x1e0 [ 9125.567335]  path_mount+0x1bc/0x2c0 [ 9125.567337]  __arm64_sys_mount+0x114/0x140 [ 9125.567340]  el0_svc_common.constprop.0+0x7c/0x1bc
[ 9125.567341]  do_el0_svc+0x2c/0x94
[ 9125.567346]  el0_svc+0x20/0x30
[ 9125.567348]  el0_sync_handler+0xb0/0xb4 [ 9125.567350]  el0_sync+0x160/0x180 [ 9125.567352] [kbox] catch rlock event on cpu 0, rlock reason:SOFT-WATCHDOG detected!
[ 9125.567356] [kbox] catch rlock event, start logging [ 9125.567359] [kbox] start to collect [ 9125.577001] [kbox] collected_len = 1177956, g_printk_tmp_log_buf_len = 3145728 [ 9125.581540] [kbox] save kbox pre log success [ 9125.581648] cpu 0 will send nmi ,the cpumask = 0xe
[ 9125.582281] CPU: 1 PID: 0 Comm: swapper/1 Kdump: loaded Tainted: G           O      5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64 #1
[ 9125.582291] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 [ 9125.582293] Call trace:
[ 9125.582294]  dump_backtrace+0x0/0x1e4 [ 9125.582295]  show_stack+0x20/0x2c [ 9125.582296]  dump_stack+0xd8/0x140 [ 9125.582297]  kbox_print_cpus_trace+0x40/0x80 [kbox] [ 9125.582298]  do_handle_IPI+0xe0/0x39c [ 9125.582300]  ipi_handler+0x24/0x34 [ 9125.582301]  handle_percpu_devid_fasteoi_ipi+0x84/0x14c
[ 9125.582302]  generic_handle_irq+0x58/0x70 [ 9125.582303]  __handle_domain_irq+0x6c/0xe0 [ 9125.582304]  gic_handle_irq+0x88/0x2b0 [ 9125.582305]  el1_irq+0xb8/0x140 [ 9125.582307]  arch_cpu_idle+0x18/0x40 [ 9125.582308]  default_idle_call+0x5c/0x1c0 [ 9125.582309]  cpuidle_idle_call+0x174/0x1b0 [ 9125.582310]  do_idle+0x158/0x160 [ 9125.582312]  cpu_startup_entry+0x30/0x11c [ 9125.582313]  secondary_start_kernel+0x158/0x1e4
[ 9125.582314] Sample time: 9125168142009 ns(HZ: 250) [ 9125.582315] Sample stat: 
[ 9125.582317]  curr: user: 724776295090, nice: 94351110, sys: 3910489195840, idle: 3888847397680, iowait: 515238314120, irq: 29777149630, softirq: 55571481180, st: 0 [ 9125.582319]  deta: user: 724776295090, nice: 94351110, sys: 3910489195840, idle: 3888847397680, iowait: 515238314120, irq: 29777149630, softirq: 55571481180, st: 0 [ 9125.582320] Sample softirq:
[ 9125.582321]           HI:          2
[ 9125.582322]        TIMER:     345066
[ 9125.582324]       NET_TX:        173
[ 9125.582325]       NET_RX:    2015738
[ 9125.582325]      TASKLET:      57022
[ 9125.582327]        SCHED:     920420
[ 9125.582328]          RCU:    2689429
[ 9125.582329] Sample irqstat:
[ 9125.582330]     irq    1: delta    1822068, curr:    1822068, IPI
[ 9125.582332]     irq    2: delta      88326, curr:      88326, IPI
[ 9125.582333]     irq    9: delta          1, curr:          1, IPI
[ 9125.582334]     irq   12: delta    2301385, curr:    2301385, arch_timer
[ 9125.582335]     irq   82: delta     902667, curr:     902667, virtio2-output.0
[ 9125.582337]     irq   84: delta     670719, curr:     670719, virtio3-input.0
[ 9125.582338]     irq   87: delta     431234, curr:     431234, virtio4-input.0
[ 9125.582340]     irq   90: delta      19335, curr:      19335, virtio1-control
[ 9125.582341]     irq   94: delta          1, curr:          1, virtio5-event
[ 9125.582344] CPU: 3 PID: 0 Comm: swapper/3 Kdump: loaded Tainted: G           O      5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64 #1
[ 9125.582352] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 [ 9125.582353] Call trace:
[ 9125.582354]  dump_backtrace+0x0/0x1e4 [ 9125.582355]  show_stack+0x20/0x2c [ 9125.582357]  dump_stack+0xd8/0x140 [ 9125.582358]  kbox_print_cpus_trace+0x40/0x80 [kbox] [ 9125.582359]  do_handle_IPI+0xe0/0x39c [ 9125.582360]  ipi_handler+0x24/0x34 [ 9125.582361]  handle_percpu_devid_fasteoi_ipi+0x84/0x14c
[ 9125.582362]  generic_handle_irq+0x58/0x70 [ 9125.582364]  __handle_domain_irq+0x6c/0xe0 [ 9125.582365]  gic_handle_irq+0x88/0x2b0 [ 9125.582366]  el1_irq+0xb8/0x140 [ 9125.582367]  arch_cpu_idle+0x18/0x40 [ 9125.582369]  default_idle_call+0x5c/0x1c0 [ 9125.582370]  cpuidle_idle_call+0x174/0x1b0 [ 9125.582371]  do_idle+0x158/0x160 [ 9125.582372]  cpu_startup_entry+0x30/0x11c [ 9125.582373]  secondary_start_kernel+0x158/0x1e4
[ 9125.582374] Sample time: 9125168110050 ns(HZ: 250) [ 9125.582376] Sample stat: 
[ 9125.582377]  curr: user: 729739797980, nice: 101548160, sys: 4045500121700, idle: 3966440313580, iowait: 282109642230, irq: 31591894520, softirq: 69408276750, st: 0 [ 9125.582380]  deta: user: 729739797980, nice: 101548160, sys: 4045500121700, idle: 3966440313580, iowait: 282109642230, irq: 31591894520, softirq: 69408276750, st: 0 [ 9125.582381] Sample softirq:
[ 9125.582383]        TIMER:     268844
[ 9125.582384]       NET_TX:        267
[ 9125.582385]       NET_RX:    2728023
[ 9125.582386]      TASKLET:      20056
[ 9125.582387]        SCHED:     877073
[ 9125.582388]      HRTIMER:         91
[ 9125.582449]          RCU:    2498916
[ 9125.582451] Sample irqstat:
[ 9125.582452]     irq    1: delta    1704591, curr:    1704591, IPI
[ 9125.582453]     irq    2: delta      87703, curr:      87703, IPI
[ 9125.582455]     irq    9: delta          1, curr:          1, IPI
[ 9125.582456]     irq   12: delta    2299208, curr:    2299208, arch_timer
[ 9125.582457]     irq   81: delta     438039, curr:     438039, virtio2-input.0
[ 9125.582459]     irq   82: delta     257442, curr:     257442, virtio2-output.0
[ 9125.582460]     irq   84: delta     966776, curr:     966776, virtio3-input.0
[ 9125.582461]     irq   87: delta    1039695, curr:    1039695, virtio4-input.0
[ 9125.582463]     irq   90: delta       9832, curr:       9832, virtio1-control
[ 9125.582467] CPU: 2 PID: 0 Comm: swapper/2 Kdump: loaded Tainted: G           O      5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64 #1
[ 9125.582471] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 [ 9125.582472] Call trace:
[ 9125.582474]  dump_backtrace+0x0/0x1e4 [ 9125.582475]  show_stack+0x20/0x2c [ 9125.582476]  dump_stack+0xd8/0x140 [ 9125.582477]  kbox_print_cpus_trace+0x40/0x80 [kbox] [ 9125.582478]  do_handle_IPI+0xe0/0x39c [ 9125.582479]  ipi_handler+0x24/0x34 [ 9125.582480]  handle_percpu_devid_fasteoi_ipi+0x84/0x14c
[ 9125.582481]  generic_handle_irq+0x58/0x70 [ 9125.582482]  __handle_domain_irq+0x6c/0xe0 [ 9125.582483]  gic_handle_irq+0x88/0x2b0 [ 9125.582485]  el1_irq+0xb8/0x140 [ 9125.582486]  arch_cpu_idle+0x18/0x40 [ 9125.582487]  default_idle_call+0x5c/0x1c0 [ 9125.582488]  cpuidle_idle_call+0x174/0x1b0 [ 9125.582489]  do_idle+0x158/0x160 [ 9125.582490]  cpu_startup_entry+0x30/0x11c [ 9125.582491]  secondary_start_kernel+0x158/0x1e4
[ 9125.582492] Sample time: 9125168182397 ns(HZ: 250) [ 9125.582494] Sample stat: 
[ 9125.582495]  curr: user: 728729600830, nice: 143816300, sys: 3880725560230, idle: 4130118023190, iowait: 232349647860, irq: 32197515740, softirq: 120481741950, st: 0 [ 9125.582497]  deta: user: 728729600830, nice: 143816300, sys: 3880725560230, idle: 4130118023190, iowait: 232349647860, irq: 32197515740, softirq: 120481741950, st: 0 [ 9125.582499] Sample softirq:
[ 9125.582500]           HI:          2
[ 9125.582501]        TIMER:     350970
[ 9125.582502]       NET_TX:      30906
[ 9125.582503]       NET_RX:    3266744
[ 9125.582504]      TASKLET:      21378
[ 9125.582505]        SCHED:     913487
[ 9125.582506]      HRTIMER:         39
[ 9125.582507]          RCU:    2598774
[ 9125.582508] Sample irqstat:
[ 9125.582509]     irq    1: delta    1565956, curr:    1565956, IPI
[ 9125.582510]     irq    2: delta      82113, curr:      82113, IPI
[ 9125.582512]     irq    9: delta          1, curr:          1, IPI
[ 9125.582513]     irq   12: delta    2334079, curr:    2334079, arch_timer
[ 9125.582514]     irq   55: delta          1, curr:          1, PCIe PME
[ 9125.582516]     irq   59: delta          1, curr:          1, PCIe PME
[ 9125.582517]     irq   63: delta          6, curr:          6, PCIe PME
[ 9125.582518]     irq   67: delta          6, curr:          6, PCIe PME
[ 9125.582519]     irq   71: delta          6, curr:          6, PCIe PME
[ 9125.582520]     irq   75: delta          6, curr:          6, PCIe PME
[ 9125.582521]     irq   79: delta          1, curr:          1, virtio0-virtqueues
[ 9125.582523]     irq   81: delta    3030056, curr:    3030056, virtio2-input.0
[ 9125.582524]     irq   82: delta     218431, curr:     218431, virtio2-output.0
[ 9125.582525]     irq   87: delta      15354, curr:      15354, virtio4-input.0
[ 9125.582527]     irq   90: delta       2384, curr:       2384, virtio1-control
[ 9126.617943] smp_nmi_call_function:async mode, i finished!
[ 9126.617950] smp_nmi_call_function:this time is running cpumask = 0x0 [ 9126.638135] [kbox] cpu1 nmi buf len=0, continue [ 9126.638136] [kbox] cpu2 nmi buf len=0, continue [ 9126.638137] [kbox] cpu3 nmi buf len=0, continue [ 9126.651305] [kbox] notify die begin [ 9126.651308] [kbox] no notify die func register. no need to notify [ 9126.651323] Kernel panic - not syncing: softlockup: hung tasks
[ 9126.651330] CPU: 0 PID: 416907 Comm: mount.nfs Kdump: loaded Tainted: G           O L    5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64 #1
[ 9126.651331] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015 [ 9126.651334] Call trace:
[ 9126.651340]  dump_backtrace+0x0/0x1e4 [ 9126.651343]  show_stack+0x20/0x2c [ 9126.651349]  dump_stack+0xd8/0x140 [ 9126.651350]  panic+0x220/0x4d0 [ 9126.651354]  watchdog_timer_fn+0x26c/0x2d0 [ 9126.651356]  __run_hrtimer+0x98/0x2a0 [ 9126.651358]  __hrtimer_run_queues+0xbc/0x130 [ 9126.651359]  hrtimer_interrupt+0x13c/0x3c0 [ 9126.651364]  arch_timer_handler_virt+0x3c/0x50 [ 9126.651366]  handle_percpu_devid_irq+0x90/0x1f4
[ 9126.651369]  generic_handle_irq+0x58/0x70 [ 9126.651371]  __handle_domain_irq+0x6c/0xe0 [ 9126.651373]  gic_handle_irq+0x88/0x2b0 [ 9126.651374]  el1_irq+0xb8/0x140 [ 9126.651421]  xprt_end_transmit+0xb8/0x124 [sunrpc] [ 9126.651440]  call_transmit+0xa4/0xb4 [sunrpc] [ 9126.651459]  __rpc_execute+0x74/0x400 [sunrpc] [ 9126.651477]  rpc_execute+0x68/0x90 [sunrpc] [ 9126.651495]  rpc_run_task+0x98/0x110 [sunrpc] [ 9126.651513]  rpc_call_sync+0x64/0xc4 [sunrpc] [ 9126.651545]  nfs_mount+0x114/0x27c [nfs] [ 9126.651558]  nfs_request_mount.constprop.0.isra.0+0xd0/0x1d4 [nfs] [ 9126.651570]  nfs_try_mount_request+0x54/0x2bc [nfs] [ 9126.651582]  nfs_try_get_tree+0x58/0xec [nfs] [ 9126.651594]  nfs_get_tree+0x44/0x6c [nfs] [ 9126.651598]  vfs_get_tree+0x30/0xf4 [ 9126.651601]  do_new_mount+0x16c/0x1e0 [ 9126.651603]  path_mount+0x1bc/0x2c0 [ 9126.651605]  __arm64_sys_mount+0x114/0x140 [ 9126.651607]  el0_svc_common.constprop.0+0x7c/0x1bc
[ 9126.651608]  do_el0_svc+0x2c/0x94
[ 9126.651611]  el0_svc+0x20/0x30
[ 9126.651613]  el0_sync_handler+0xb0/0xb4 [ 9126.651614]  el0_sync+0x160/0x180 [ 9126.651617] kernel fault(0x5) notification starting on CPU 0 [ 9126.651618] kernel fault(0x5) notification finished on CPU 0 [ 9126.651619] SMP: stopping secondary CPUs [ 9126.651676] [kbox] catch panic event, panic reason:softlockup: hung tasks [ 9126.651679] [kbox] rlock event has been record!
[ 9126.651679] [kbox] notify die begin
[ 9126.651680] [kbox] no notify die func register. no need to notify [ 9126.651682] [kbox] end panic event [ 9126.651684] Kernel Offset: disabled [ 9126.651686] CPU features: 0x0000,88000002,2a208038 [ 9126.651687] Memory Limit: none [ 9126.653439] Starting crashdump kernel...
[ 9126.653446] Bye!


Crash:bt -l
#0 [ffff800102c3bb50] __crash_kexec at ffff8001001c2248
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/./arch/arm64/include/asm/kexec.h: 57
#1 [ffff800102c3bce0] panic at ffff800100d2bf4c
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/kernel/panic.c: 382
#2 [ffff800102c3bdd0] watchdog_timer_fn at ffff80010020baa8
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/kernel/watchdog.c: 574
#3 [ffff800102c3be20] __run_hrtimer at ffff800100192ed8
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/kernel/time/hrtimer.c: 1586
#4 [ffff800102c3be70] __hrtimer_run_queues at ffff80010019319c
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/kernel/time/hrtimer.c: 1650
#5 [ffff800102c3bed0] hrtimer_interrupt at ffff8001001937d8
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/kernel/time/hrtimer.c: 1712
#6 [ffff800102c3bf40] arch_timer_handler_virt at ffff800100aab3c8
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/drivers/clocksource/arm_arch_timer.c: 674
#7 [ffff800102c3bf50] handle_percpu_devid_irq at ffff80010016598c
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/./arch/arm64/include/asm/percpu.h: 45
#8 [ffff800102c3bf80] generic_handle_irq at ffff80010015b3d4
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/./include/linux/irqdesc.h: 154
#9 [ffff800102c3bf90] __handle_domain_irq at ffff80010015c318
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/kernel/irq/irqdesc.c: 699
#10 [ffff800102c3bfd0] gic_handle_irq at ffff800100010144
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/./include/linux/irqdesc.h: 172
--- <IRQ stack> ---
#11 [ffff80010aa838f0] el1_irq at ffff800100012374
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/arch/arm64/kernel/entry.S: 672
#12 [ffff80010aa83910] xprt_end_transmit at ffff80008103a234 [sunrpc]
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/./arch/arm64/include/asm/atomic_lse.h: 370
#13 [ffff80010aa83940] call_transmit at ffff8000810332b0 [sunrpc]
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/net/sunrpc/clnt.c: 2151
#14 [ffff80010aa83960] __rpc_execute at ffff800081053f80 [sunrpc]
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/net/sunrpc/sched.c: 894
#15 [ffff80010aa839b0] rpc_execute at ffff800081054694 [sunrpc]
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/net/sunrpc/sched.c: 971
#16 [ffff80010aa839d0] rpc_run_task at ffff800081034844 [sunrpc]
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/net/sunrpc/clnt.c: 1147
#17 [ffff80010aa839f0] rpc_call_sync at ffff8000810349e0 [sunrpc]
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/net/sunrpc/clnt.c: 1176
#18 [ffff80010aa83a70] nfs_mount at ffff8000814c51b4 [nfs]
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/fs/nfs/mount_clnt.c: 189
#19 [ffff80010aa83b70] nfs_request_mount.constprop.0 at ffff8000814b4e4c [nfs]
    /usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/fs/nfs/super.c: 851
#20 [ffff80010aa83bf0] nfs_try_mount_request at ffff8000814b4fa4 [nfs]
/usr/src/debug/kernel-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/linux-5.10.0-60.18.0.50.h734.eulerosv2r11.aarch64/fs/nfs/super.c: 872

The above backtrace seems to be caused by the lock (xprt->transport_lock). According to the code review, it seems that the same thread is repeatedly locked(xprt->transport_lock):
xprt_prepare_transmit
    xprt_lock_write
        spin_lock(&xprt->transport_lock);
        xprt->ops->reserve_xprt -->      xprt_reserve_xprt_cong
        spin_unlock(&xprt->transport_lock);

xprt_reserve_xprt_cong
    out_sleep:
        rpc_sleep_check_activated(task)
            if !RPC_IS_ACTIVATED(task)
                rpc_put_task_async
                    ...
                    xprt_release
                        spin_lock(&xprt->transport_lock);

I wonder if softlockup is due to the above code? When softlockup is occurs, NFS is repeatedly mounted, and is difficult to reproduce.
Please help analyze the possible causes of this.
