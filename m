Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CE6366733
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 10:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237379AbhDUIpE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 04:45:04 -0400
Received: from mx2.suse.de ([195.135.220.15]:37844 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235083AbhDUIpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 04:45:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 305CCB15C;
        Wed, 21 Apr 2021 08:44:29 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 24FA060789; Wed, 21 Apr 2021 10:44:28 +0200 (CEST)
Date:   Wed, 21 Apr 2021 10:44:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, olteanv@gmail.com,
        ast@kernel.org, daniel@iogearbox.net, andriin@fb.com,
        edumazet@google.com, weiwan@google.com, cong.wang@bytedance.com,
        ap420073@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        mkl@pengutronix.de, linux-can@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, bpf@vger.kernel.org,
        pabeni@redhat.com, mzhivich@akamai.com, johunt@akamai.com,
        albcamus@gmail.com, kehuan.feng@gmail.com, a.fatoum@pengutronix.de,
        atenart@kernel.org, alexander.duyck@gmail.com, hdanton@sina.com,
        jgross@suse.com, JKosina@suse.com
Subject: Re: [PATCH net v4 1/2] net: sched: fix packet stuck problem for
 lockless qdisc
Message-ID: <20210421084428.xbjgoi4r2d6t65gy@lion.mk-sys.cz>
References: <1618535809-11952-1-git-send-email-linyunsheng@huawei.com>
 <1618535809-11952-2-git-send-email-linyunsheng@huawei.com>
 <20210419152946.3n7adsd355rfeoda@lion.mk-sys.cz>
 <20210419235503.eo77f6s73a4d25oh@lion.mk-sys.cz>
 <20210420203459.h7top4zogn56oa55@lion.mk-sys.cz>
 <80d64438-e3e5-e861-4da0-f6c89e3c73f7@huawei.com>
 <20210421053123.wdq3kwlvf72kwtch@lion.mk-sys.cz>
 <6a8dea49-3a3e-4172-1d65-5dbcb0125eda@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a8dea49-3a3e-4172-1d65-5dbcb0125eda@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 21, 2021 at 04:21:54PM +0800, Yunsheng Lin wrote:
> 
> I tried using below shell to simulate your testcase:
> 
> #!/bin/sh
> 
> for((i=0; i<20; i++))
> do
>         taskset -c 0-31 netperf -t TCP_STREAM -H 192.168.100.2 -l 30 -- -m 1048576
> done
> 
> And I got a quite stable result: 9413~9416 (10^6bits/sec) for 10G netdev.

Perhaps try it without the taskset, in my test, there was only one
connection.

> > 
> >   https://github.com/mkubecek/nperf
> > 
> > It is still raw and a lot of features are missing but it can be already
> > used for multithreaded TCP_STREAM and TCP_RR tests. In particular, the
> > output above was with
> > 
> >   nperf -H 172.17.1.1 -l 30 -i 20 --exact -t TCP_STREAM -M 1
> 
> I tried your nperf too, unfortunately it does not seem to work on my
> system(arm64), which exits very quickly and output the blow result:
> 
> root@(none):/home# nperf -H 192.168.100.2 -l 30 -i 20 --exact -t TCP_STREAM -M 1
> server: 192.168.100.2, port 12543
> iterations: 20, threads: 1, test length: 30
> test: TCP_STREAM, message size: 1048576
> 
> 1             4.0 B/s,  avg           4.0 B/s, mdev           0.0 B/s (  0.0%)
[...]

Did you start nperfd on the other side? (It plays a role similar to
netserver for netperf.) Few days ago I noticed that there is something
wrong with error handling in case of failed connection but didn't get to
fixing it yet.

I'll try running some tests also on other architectures, including arm64
and s390x (to catch potential endinanity issues).

Michal
