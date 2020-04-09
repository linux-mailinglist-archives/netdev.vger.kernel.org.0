Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7691A3A80
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 21:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgDITaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 15:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:57956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbgDITaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 15:30:04 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65CD820757;
        Thu,  9 Apr 2020 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586460603;
        bh=mLtpWtosiJzJlEqp5k7RMONE+HpeLB3DE0STNjyW9LU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jTxCJT2afh9/7HfKb3adoCLaO32cqU5ypwkLhdE4KnWu/cgLGxCKop7D7hGNu2xfs
         4qcQ3m02Z3laDoF5C5TdWqrScQv9nfeMneZKXVVFnVQB3kYfwdhEpxLoYAyODWb4K3
         rKtgjQzPdZSwtnkQ6VGhYLyWzrM4aAgOr8t1Bf+0=
Message-ID: <6e356a3654cf716cf8398d986fcfaaec27521af6.camel@kernel.org>
Subject: Re: Page allocation error - CephFS kernel client hang - 5.4.20
 kernel.
From:   Jeff Layton <jlayton@kernel.org>
To:     Jesper Krogh <jesper.krogh@gmail.com>, netdev@vger.kernel.org
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Date:   Thu, 09 Apr 2020 15:30:01 -0400
In-Reply-To: <CAED-sicdkasoUwtbE5kg_UuRBswgKqTxhMR2qi-jdYokxZWJcg@mail.gmail.com>
References: <CAED-sicdkasoUwtbE5kg_UuRBswgKqTxhMR2qi-jdYokxZWJcg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2020-04-09 at 19:38 +0200, Jesper Krogh wrote:
> Hi.
> 
> Jeff suggested me to post it here to se if some of you can figure this out.
> The system is VM running 16GB memory 16 v-cores KVM/QEMU  client is 5.4.20
> and the workload is the "bacula" filedaemon essentially reading data
> off a cephfs
> mountpoint only with the purpose of shipping it to the network to the
> tape-library.
> Concurrency is 3-5 threads reading catalogs sequentially -- nothing
> else  (except
>  standard distro stuff) on the host.
> 
> I have indications from a physical machine that I can reproduce it
> there  - although kernel 5.2.8 and a mixed workload but same end
> result.
> 
> Attached is the full kernel.log from bootup until the "crash" where the CephFS
> mountpoint goes stale and cannot be recovered without a hard reboot of the VM.
> 
> Thread on Ceph-devel is here:
> https://www.spinics.net/lists/ceph-devel/msg48034.html
> 
> When this happens the VM has "very high" iowait  - because reading
> from Ceph essentially "only" is waiting for data to come from the
> network. But it can be as high as 150+ on a machine with 16 cores and
> 5 active threads reading from CephFS mountpoint - It feels excessive
> to me - but if it worked for me I wouldn't care about it.
> 
> Apr  5 14:20:45 wombat kernel: [10956.183074] kworker/7:0: page
> allocation failure: order:0, mode:0xa20(GFP_ATOMIC),
> nodemask=(null),cpuset=/,mems_allowed=0
> Apr  5 14:20:45 wombat kernel: [10956.183089] CPU: 7 PID: 7499 Comm:
> kworker/7:0 Not tainted 5.4.30 #5
> Apr  5 14:20:45 wombat kernel: [10956.183090] Hardware name: Bochs
> Bochs, BIOS Bochs 01/01/2011
> Apr  5 14:20:45 wombat kernel: [10956.183141] Workqueue: ceph-msgr
> ceph_con_workfn [libceph]
> Apr  5 14:20:45 wombat kernel: [10956.183143] Call Trace:
> Apr  5 14:20:45 wombat kernel: [10956.183146]  <IRQ>
> Apr  5 14:20:45 wombat kernel: [10956.183279]  dump_stack+0x6d/0x95
> Apr  5 14:20:45 wombat kernel: [10956.183284]  warn_alloc+0x10c/0x170
> Apr  5 14:20:45 wombat kernel: [10956.183288]
> __alloc_pages_slowpath+0xe6c/0xef0
> Apr  5 14:20:45 wombat kernel: [10956.183290]
> __alloc_pages_nodemask+0x2f3/0x360
> Apr  5 14:20:45 wombat kernel: [10956.183295]  alloc_pages_current+0x6a/0xe0
> Apr  5 14:20:45 wombat kernel: [10956.183301]  skb_page_frag_refill+0xda/0x100
> Apr  5 14:20:45 wombat kernel: [10956.183310]
> try_fill_recv+0x285/0x6f0 [virtio_net]
> Apr  5 14:20:45 wombat kernel: [10956.183314]
> virtnet_poll+0x32d/0x364 [virtio_net]
> Apr  5 14:20:45 wombat kernel: [10956.183321]  net_rx_action+0x265/0x3e0
> Apr  5 14:20:45 wombat kernel: [10956.183328]  __do_softirq+0xf9/0x2aa
> Apr  5 14:20:45 wombat kernel: [10956.183332]  irq_exit+0xae/0xb0
> Apr  5 14:20:45 wombat kernel: [10956.183335]  do_IRQ+0x59/0xe0
> Apr  5 14:20:45 wombat kernel: [10956.183337]  common_interrupt+0xf/0xf
> Apr  5 14:20:45 wombat kernel: [10956.183338]  </IRQ>
> Apr  5 14:20:45 wombat kernel: [10956.183341] RIP:
> 0010:kvm_clock_get_cycles+0x1/0x20
> Apr  5 14:20:45 wombat kernel: [10956.183343] Code: 89 04 10 75 d6 b8
> f4 ff ff ff 5d c3 48 c1 e1 06 31 c0 48 81 c1 00 10 60 89 49 89 0c 10
> eb be 66 2e 0f 1f 84 00 00 00 00 00 55 <48> 89 e5 65 48 8b 3d e4 8f 7a
> 78 e8 ff 0f 00 00 5d c3 0f 1f 00 66
> Apr  5 14:20:45 wombat kernel: [10956.183344] RSP:
> 0018:ffffaf6881cb7ab8 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffdc
> Apr  5 14:20:45 wombat kernel: [10956.183346] RAX: ffffffff8786e040
> RBX: 000009f6c5a66e6c RCX: 0000000000001000
> Apr  5 14:20:45 wombat kernel: [10956.183347] RDX: 0000000000000000
> RSI: 0000000000001000 RDI: ffffffff88e3c0e0
> Apr  5 14:20:45 wombat kernel: [10956.183348] RBP: ffffaf6881cb7ae0
> R08: 000000000002241a R09: 0000000000001000
> Apr  5 14:20:45 wombat kernel: [10956.183348] R10: 0000000000000000
> R11: 0000000000001000 R12: 0000000000000000
> Apr  5 14:20:45 wombat kernel: [10956.183349] R13: 0000000000176864
> R14: ffff9fa900931fb4 R15: 0000000000000000
> Apr  5 14:20:45 wombat kernel: [10956.183351]  ? kvmclock_setup_percpu+0x80/0x80
> Apr  5 14:20:45 wombat kernel: [10956.183354]  ? ktime_get+0x3e/0xa0
> Apr  5 14:20:45 wombat kernel: [10956.183365]  tcp_mstamp_refresh+0x12/0x40
> Apr  5 14:20:45 wombat kernel: [10956.183368]  tcp_rcv_space_adjust+0x22/0x1d0
> Apr  5 14:20:45 wombat kernel: [10956.183369]  tcp_recvmsg+0x28b/0xbc0
> Apr  5 14:20:45 wombat kernel: [10956.183374]  ? aa_sk_perm+0x43/0x190
> Apr  5 14:20:45 wombat kernel: [10956.183380]  inet_recvmsg+0x64/0xf0
> Apr  5 14:20:45 wombat kernel: [10956.183384]  sock_recvmsg+0x66/0x70
> Apr  5 14:20:45 wombat kernel: [10956.183392]
> ceph_tcp_recvpage+0x79/0xb0 [libceph]
> Apr  5 14:20:45 wombat kernel: [10956.183400]
> read_partial_message+0x3c3/0x7c0 [libceph]
> Apr  5 14:20:45 wombat kernel: [10956.183407]
> ceph_con_workfn+0xa6a/0x23d0 [libceph]
> Apr  5 14:20:45 wombat kernel: [10956.183409]  ? __switch_to_asm+0x40/0x70
> Apr  5 14:20:45 wombat kernel: [10956.183410]  ? __switch_to_asm+0x34/0x70
> Apr  5 14:20:45 wombat kernel: [10956.183411]  ? __switch_to_asm+0x40/0x70
> Apr  5 14:20:45 wombat kernel: [10956.183413]  ? __switch_to_asm+0x34/0x70
> Apr  5 14:20:45 wombat kernel: [10956.183415]  process_one_work+0x167/0x400
> Apr  5 14:20:45 wombat kernel: [10956.183416]  worker_thread+0x4d/0x460
> Apr  5 14:20:45 wombat kernel: [10956.183419]  kthread+0x105/0x140
> Apr  5 14:20:45 wombat kernel: [10956.183420]  ? rescuer_thread+0x370/0x370
> Apr  5 14:20:45 wombat kernel: [10956.183421]  ?
> kthread_destroy_worker+0x50/0x50
> Apr  5 14:20:45 wombat kernel: [10956.183423]  ret_from_fork+0x35/0x40
> Apr  5 14:20:45 wombat kernel: [10956.183425] Mem-Info:
> Apr  5 14:20:45 wombat kernel: [10956.183430] active_anon:39163
> inactive_anon:39973 isolated_anon:0
> Apr  5 14:20:45 wombat kernel: [10956.183430]  active_file:85386
> inactive_file:3756171 isolated_file:32
> Apr  5 14:21:02 wombat kernel: [10956.183430]  unevictable:0 dirty:0
> writeback:0 unstable:0
> Apr  5 14:21:02 wombat kernel: [10956.183430]  slab_reclaimable:81555
> slab_unreclaimable:45634
> Apr  5 14:21:02 wombat kernel: [10956.183430]  mapped:4433 shmem:560
> pagetables:980 bounce:0
> Apr  5 14:21:02 wombat kernel: [10956.183430]  free:33869 free_pcp:103
> free_cma:0
> Apr  5 14:21:02 wombat kernel: [10956.183433] Node 0
> active_anon:156652kB inactive_anon:159892kB active_file:341544kB
> inactive_file:15024684kB unevictable:0kB isolated(anon):0kB
> isolated(file):128kB mapped:17732kB dirty:0kB writeback:0kB
> shmem:2240kB shmem_thp: 0kB shmem_pmdmapped: 0kB anon_thp: 0kB
> writeback_tmp:0kB unstable:0kB all_unreclaimable? no
> Apr  5 14:21:02 wombat kernel: [10956.183434] Node 0 DMA free:15908kB
> min:64kB low:80kB high:96kB active_anon:0kB inactive_anon:0kB
> active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB
> present:15992kB managed:15908kB mlocked:0kB kernel_stack:0kB
> pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> Apr  5 14:21:02 wombat kernel: [10956.183437] lowmem_reserve[]: 0 3444
> 15930 15930 15930
> Apr  5 14:21:02 wombat kernel: [10956.183439] Node 0 DMA32
> free:55284kB min:14596kB low:18244kB high:21892kB active_anon:4452kB
> inactive_anon:9072kB active_file:5560kB inactive_file:3333524kB
> unevictable:0kB writepending:0kB present:3653608kB managed:3588072kB
> mlocked:0kB kernel_stack:740kB pagetables:32kB bounce:0kB
> free_pcp:164kB local_pcp:164kB free_cma:0kB
> Apr  5 14:21:02 wombat kernel: [10956.183442] lowmem_reserve[]: 0 0
> 12485 12485 12485
> Apr  5 14:21:02 wombat kernel: [10956.183444] Node 0 Normal
> free:64284kB min:171972kB low:185200kB high:198428kB
> active_anon:152200kB inactive_anon:150820kB active_file:335984kB
> inactive_file:11691288kB unevictable:0kB writepending:0kB
> present:13107200kB managed:12793540kB mlocked:0kB kernel_stack:6684kB
> pagetables:3888kB bounce:0kB free_pcp:248kB local_pcp:248kB
> free_cma:0kB
> Apr  5 14:21:02 wombat kernel: [10956.183447] lowmem_reserve[]: 0 0 0 0 0
> Apr  5 14:21:02 wombat kernel: [10956.183448] Node 0 DMA: 1*4kB (U)
> 0*8kB 0*16kB 1*32kB (U) 2*64kB (U) 1*128kB (U) 1*256kB (U) 0*512kB
> 1*1024kB (U) 1*2048kB (M) 3*4096kB (M) = 15908kB
> Apr  5 14:21:02 wombat kernel: [10956.183455] Node 0 DMA32: 72*4kB
> (MEH) 172*8kB (UMEH) 310*16kB (UH) 155*32kB (UEH) 265*64kB (UMH)
> 113*128kB (UMEH) 34*256kB (UE) 3*512kB (UM) 2*1024kB (M) 0*2048kB
> 0*4096kB = 55296kB
> Apr  5 14:21:02 wombat kernel: [10956.183462] Node 0 Normal: 392*4kB
> (UMEH) 792*8kB (UMEH) 258*16kB (UMH) 318*32kB (MEH) 648*64kB (MH)
> 10*128kB (M) 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 64960kB
> Apr  5 14:21:02 wombat kernel: [10956.183469] Node 0 hugepages_total=0
> hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
> Apr  5 14:21:02 wombat kernel: [10956.183470] Node 0 hugepages_total=0
> hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
> Apr  5 14:21:02 wombat kernel: [10956.183471] 3843456 total pagecache pages
> Apr  5 14:21:02 wombat kernel: [10956.183473] 1281 pages in swap cache
> Apr  5 14:21:02 wombat kernel: [10956.183475] Swap cache stats: add
> 13816, delete 12535, find 3296/6045
> Apr  5 14:21:02 wombat kernel: [10956.183475] Free swap  = 4004652kB
> Apr  5 14:21:02 wombat kernel: [10956.183476] Total swap = 4038652kB
> Apr  5 14:21:02 wombat kernel: [10956.183476] 4194200 pages RAM
> Apr  5 14:21:02 wombat kernel: [10956.183477] 0 pages HighMem/MovableOnly
> Apr  5 14:21:02 wombat kernel: [10956.183477] 94820 pages reserved
> Apr  5 14:21:02 wombat kernel: [10956.183478] 0 pages cma reserved
> Apr  5 14:21:02 wombat kernel: [10956.183478] 0 pages hwpoisoned
> Apr  5 14:25:15 wombat kernel: [11225.534971] warn_alloc: 43 callbacks
> suppressed

(re-cc'ing ceph-devel)

Sorry, when you first posted this, I think I was missing some context in
the order of messages in the logs. The first hint of problems occurs
just a little after the mount, and shows up as a hung task that's trying
to lock a page:

Apr  5 13:40:03 wombat kernel: [ 8514.297183] libceph: client10738004 fsid dbc33946-ba1f-477c-84df-c63a3c9c91a6
Apr  5 13:43:10 wombat kernel: [ 8701.053320] INFO: task kworker/u16:26:5732 blocked for more than 120 seconds.
Apr  5 13:43:10 wombat kernel: [ 8701.053363]       Not tainted 5.4.30 #5
Apr  5 13:43:10 wombat kernel: [ 8701.053377] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Apr  5 13:43:10 wombat kernel: [ 8701.053402] kworker/u16:26  D    0  5732      2 0x80004000
Apr  5 13:43:10 wombat kernel: [ 8701.053432] Workqueue: ceph-inode ceph_inode_work [ceph]
Apr  5 13:43:10 wombat kernel: [ 8701.053435] Call Trace:
Apr  5 13:43:10 wombat kernel: [ 8701.053452]  __schedule+0x45f/0x710
Apr  5 13:43:10 wombat kernel: [ 8701.053454]  schedule+0x3e/0xa0
Apr  5 13:43:10 wombat kernel: [ 8701.053457]  io_schedule+0x16/0x40
Apr  5 13:43:10 wombat kernel: [ 8701.053462]  __lock_page+0x12a/0x1d0
Apr  5 13:43:10 wombat kernel: [ 8701.053464]  ? file_fdatawait_range+0x30/0x30
Apr  5 13:43:10 wombat kernel: [ 8701.053468]  truncate_inode_pages_range+0x52c/0x980
Apr  5 13:43:10 wombat kernel: [ 8701.053476]  ? drop_inode_snap_realm+0x98/0xa0 [ceph]
Apr  5 13:43:10 wombat kernel: [ 8701.053481]  ? fsnotify_grab_connector+0x4d/0x90
Apr  5 13:43:10 wombat kernel: [ 8701.053483]  truncate_inode_pages_final+0x4c/0x60
Apr  5 13:43:10 wombat kernel: [ 8701.053488]  ceph_evict_inode+0x2d/0x210 [ceph]
Apr  5 13:43:10 wombat kernel: [ 8701.053490]  evict+0xca/0x1a0
Apr  5 13:43:10 wombat kernel: [ 8701.053491]  iput+0x1ba/0x210
Apr  5 13:43:10 wombat kernel: [ 8701.053496]  ceph_inode_work+0x40/0x270 [ceph]
Apr  5 13:43:10 wombat kernel: [ 8701.053499]  process_one_work+0x167/0x400
Apr  5 13:43:10 wombat kernel: [ 8701.053500]  worker_thread+0x4d/0x460
Apr  5 13:43:10 wombat kernel: [ 8701.053504]  kthread+0x105/0x140
Apr  5 13:43:10 wombat kernel: [ 8701.053505]  ? rescuer_thread+0x370/0x370
Apr  5 13:43:10 wombat kernel: [ 8701.053506]  ? kthread_destroy_worker+0x50/0x50
Apr  5 13:43:10 wombat kernel: [ 8701.053510]  ret_from_fork+0x35/0x40

It's doing this to try and evict an inode from the cache. The question
there is why that page is locked. It may be under I/O of some sort (read
or write).

There are more warnings like that, and only later do we see the page
allocation failure. One possibility may be that you're getting into a
situation where you have some pagecache pages locked and under I/O, and
those I/Os are taking a really long time to complete. That could end up
causing cascading memory pressure issues if inode eviction is lining up
behind that.

When we get to the page allocation failure, it looks a bit bogus as it
seems like there are plenty of free pages available according to the
summary, but it still failed. One possibility is that there really
weren't any free pages at the time of the failed allocation, but some
came free before it could print out the summary.

So, this may have something to do with ceph after all (since it may be
sitting on pagecache), but it would be good to have the virtio_net devs
weigh in on why else this might have failed.

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

