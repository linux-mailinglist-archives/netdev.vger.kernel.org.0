Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B551136470F
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241254AbhDSP0C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 11:26:02 -0400
Received: from mx2.suse.de ([195.135.220.15]:33296 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232354AbhDSP0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 11:26:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BFCB8AD09;
        Mon, 19 Apr 2021 15:25:28 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id CF386603AA; Mon, 19 Apr 2021 17:25:27 +0200 (CEST)
Date:   Mon, 19 Apr 2021 17:25:27 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     Juergen Gross <jgross@suse.com>, Jiri Kosina <jikos@kernel.org>,
        davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        jonas.bonn@netrounds.com, pabeni@redhat.com, mzhivich@akamai.com,
        johunt@akamai.com, albcamus@gmail.com, kehuan.feng@gmail.com,
        a.fatoum@pengutronix.de, atenart@kernel.org,
        alexander.duyck@gmail.com
Subject: Re: [Linuxarm] Re: [PATCH net v3] net: sched: fix packet stuck
 problem for lockless qdisc
Message-ID: <20210419152527.6dxgtrmzhhwgjrul@lion.mk-sys.cz>
References: <1616641991-14847-1-git-send-email-linyunsheng@huawei.com>
 <20210418225956.a6ot6xox4eq6cvv5@lion.mk-sys.cz>
 <a50daff3-c716-f11c-4dfa-c5c1f85a9e12@huawei.com>
 <97129769-5328-58ec-c4a7-a303e0a638a6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97129769-5328-58ec-c4a7-a303e0a638a6@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 08:21:38PM +0800, Yunsheng Lin wrote:
> On 2021/4/19 10:04, Yunsheng Lin wrote:
> > On 2021/4/19 6:59, Michal Kubecek wrote:
> >> I tried this patch o top of 5.12-rc7 with real devices. I used two
> >> machines with 10Gb/s Intel ixgbe NICs, sender has 16 CPUs (2 8-core CPUs
> >> with HT disabled) and 16 Rx/Tx queues, receiver has 48 CPUs (2 12-core
> >> CPUs with HT enabled) and 48 Rx/Tx queues. With multiple TCP streams on
> >> a saturated ethernet, the CPU consumption grows quite a lot:
> >>
> >>     threads     unpatched 5.12-rc7    5.12-rc7 + v3   
> >>       1               25.6%               30.6%
> >>       8               73.1%              241.4%
> >>     128              132.2%             1012.0%
> 
> I do not really read the above number, but I understand that v3 has a cpu
> usage impact when it is patched to 5.12-rc7, so I do a test too on a arm64
> system with a hns3 100G netdev, which is in node 0, and node 0 has 32 cpus.
> 
> root@(none)$ cat /sys/class/net/eth4/device/numa_node
> 0
> root@(none)$ numactl -H
> available: 4 nodes (0-3)
> node 0 cpus: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
> node 0 size: 128646 MB
> node 0 free: 127876 MB
> node 1 cpus: 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63
> node 1 size: 129019 MB
> node 1 free: 128796 MB
> node 2 cpus: 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90 91 92 93 94 95
> node 2 size: 129019 MB
> node 2 free: 128755 MB
> node 3 cpus: 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127
> node 3 size: 127989 MB
> node 3 free: 127772 MB
> node distances:
> node   0   1   2   3
>   0:  10  16  32  33
>   1:  16  10  25  32
>   2:  32  25  10  16
>   3:  33  32  16  10
> 
> and I use below cmd to only use 16 tx/rx queue with 72 tx queue depth in
> order to trigger the tx queue stopping handling:
> ethtool -L eth4 combined 16
> ethtool -G eth4 tx 72
> 
> threads       unpatched          patched_v4    patched_v4+queue_stopped_opt
>    16      11% (si: 3.8%)     20% (si:13.5%)       11% (si:3.8%)
>    32      12% (si: 4.4%)     30% (si:22%)         13% (si:4.4%)
>    64      13% (si: 4.9%)     35% (si:26%)         13% (si:4.7%)
> 
> "11% (si: 3.8%)": 11% means the total cpu useage in node 0, and 3.8%
> means the softirq cpu useage .
> And thread number is as below iperf cmd:
> taskset -c 0-31 iperf -c 192.168.100.2 -t 1000000 -i 1 -P *thread*

The problem I see with this is that iperf's -P option only allows
running the test in multiple connections but they do not actually run in
multiple threads. Therefore this may not result in as much concurrency
as it seems.

Also, 100Gb/s ethernet is not so easy to saturate, trying 10Gb/s or
1Gb/s might put more pressure on qdisc code concurrency.

Michal

> It seems after applying the queue_stopped_opt patch, the cpu usage
> is closed to the unpatch one, at least with my testcase, maybe you
> can try your testcase with the queue_stopped_opt patch to see if
> it make any difference?

I will, I was not aware of v4 submission. I'll write a short note to it
so that it does not accidentally get applied before we know for sure
what the CPU usage impact is.

Michal
