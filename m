Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504DB364EE2
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:55:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232563AbhDSXzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:55:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:48568 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229471AbhDSXzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:55:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F291BB49A;
        Mon, 19 Apr 2021 23:55:04 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 77CD960789; Tue, 20 Apr 2021 01:55:03 +0200 (CEST)
Date:   Tue, 20 Apr 2021 01:55:03 +0200
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
Message-ID: <20210419235503.eo77f6s73a4d25oh@lion.mk-sys.cz>
References: <1618535809-11952-1-git-send-email-linyunsheng@huawei.com>
 <1618535809-11952-2-git-send-email-linyunsheng@huawei.com>
 <20210419152946.3n7adsd355rfeoda@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210419152946.3n7adsd355rfeoda@lion.mk-sys.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 19, 2021 at 05:29:46PM +0200, Michal Kubecek wrote:
> 
> As pointed out in the discussion on v3, this patch may result in
> significantly higher CPU consumption with multiple threads competing on
> a saturated outgoing device. I missed this submission so that I haven't
> checked it yet but given the description of v3->v4 changes above, it's
> quite likely that it suffers from the same problem.

And it indeed does. However, with the additional patch from the v3
discussion, the numbers are approximately the same as with an unpatched
mainline kernel.

As with v4, I tried this patch on top of 5.12-rc7 with real devices.
I used two machines with 10Gb/s Intel ixgbe NICs, sender has 16 CPUs
(2 8-core CPUs with HT disabled) and 16 Rx/Tx queues, receiver has
48 CPUs (2 12-core CPUs with HT enabled) and 48 Rx/Tx queues.

  threads    5.12-rc7    5.12-rc7 + v4    5.12-rc7 + v4 + stop
     1        25.1%          38.1%            22.9%
     8        66.2%         277.0%            74.1%
    16        90.1%         150.7%            91.0%
    32       107.2%         272.6%           108.3%
    64       116.3%         487.5%           118.1%
   128       126.1%         946.7%           126.9%

(The values are normalized to one core, i.e. 100% corresponds to one
fully used logical CPU.)

So it seems that repeated scheduling while the queue was stopped is
indeed the main performance issue and that other cases of the logic
being too pessimistic do not play significant role. There is an
exception with 8 connections/threads and the result with just this
series also looks abnormally high (e.g. much higher than with
16 threads). It might be worth investigating what happens there and
what do the results with other thread counts around 8 look like.

I'll run some more tests with other traffic patterns tomorrow and
I'm also going to take a closer look at the additional patch.

Michal
