Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E3336F5AE
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 08:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230347AbhD3G3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 02:29:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:51344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhD3G3g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Apr 2021 02:29:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3B5D7AD5C;
        Fri, 30 Apr 2021 06:28:47 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 14DB0607C3; Fri, 30 Apr 2021 08:28:46 +0200 (CEST)
Date:   Fri, 30 Apr 2021 08:28:46 +0200
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
Message-ID: <20210430062846.vrdf7ggsgskkhgzp@lion.mk-sys.cz>
References: <20210419235503.eo77f6s73a4d25oh@lion.mk-sys.cz>
 <20210420203459.h7top4zogn56oa55@lion.mk-sys.cz>
 <80d64438-e3e5-e861-4da0-f6c89e3c73f7@huawei.com>
 <20210421053123.wdq3kwlvf72kwtch@lion.mk-sys.cz>
 <6a8dea49-3a3e-4172-1d65-5dbcb0125eda@huawei.com>
 <20210421084428.xbjgoi4r2d6t65gy@lion.mk-sys.cz>
 <b3dacf14-0fb6-0cad-8b85-f5c8d7cd97ef@huawei.com>
 <a6abb3d8-f857-14e1-4212-a12df36027cf@huawei.com>
 <e90e662d-ace1-1f32-6050-861db0a7e976@huawei.com>
 <f06355b4-2b00-fc52-4d9d-9c866436e559@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f06355b4-2b00-fc52-4d9d-9c866436e559@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 11:15:01AM +0800, Yunsheng Lin wrote:
> On 2021/4/30 11:11, Yunsheng Lin wrote:
> > On 2021/4/23 17:42, Yunsheng Lin wrote:
> >> On 2021/4/21 17:25, Yunsheng Lin wrote:
> >>> On 2021/4/21 16:44, Michal Kubecek wrote:
> >>>
> >>>>
> >>>> I'll try running some tests also on other architectures, including arm64
> >>>> and s390x (to catch potential endinanity issues).
> >>
> >> I tried debugging nperf in arm64, with the below patch:
> >>
> >> Any idea what went wrong here?
> >>
> >> Also, Would you mind running netperf to see if there is similar issue
> >> in your system?
> > 
> > Hi, Michal
> >     I was able to reproduce the fluctuation for one thread TCP_STREAM test,
> 
> I was *not* able
> Sorry for the typo.

I was able to reproduce the same problem with netperf:

marfak:~ # for i in {1..60}; do netperf -H 172.17.1.1 -l 30 -t TCP_STREAM -- -m 1048576; done
131072  16384 1048576    30.00    9413.36   
131072  16384 1048576    30.01    7473.68   <---
131072  16384 1048576    30.00    9413.97   
131072  16384 1048576    30.00    9413.76   
131072  16384 1048576    30.01    9024.25   
131072  16384 1048576    30.01    8364.78   
131072  16384 1048576    30.00    9413.22   
131072  16384 1048576    30.00    9414.29   
131072  16384 1048576    30.00    9414.32   
131072  16384 1048576    30.00    9412.58   
131072  16384 1048576    30.00    9412.79   
131072  16384 1048576    30.00    9413.18   
131072  16384 1048576    30.01    8771.57   <---
131072  16384 1048576    30.00    9414.01   
131072  16384 1048576    30.00    9413.93   
131072  16384 1048576    30.00    9413.97   
131072  16384 1048576    30.00    9414.05   
131072  16384 1048576    30.00    9412.92   
131072  16384 1048576    30.00    9413.40   
131072  16384 1048576    30.00    9414.41   
131072  16384 1048576    30.00    9413.25   
131072  16384 1048576    30.00    9413.38   
131072  16384 1048576    30.00    9412.28   
131072  16384 1048576    30.00    9413.50   
131072  16384 1048576    30.00    9414.12   
131072  16384 1048576    30.00    9414.27   
131072  16384 1048576    30.00    9412.96   
131072  16384 1048576    30.00    9413.71   
131072  16384 1048576    30.01    9205.98   
131072  16384 1048576    30.00    9413.69   
131072  16384 1048576    30.00    9413.60   
131072  16384 1048576    30.01    8297.03   <---
131072  16384 1048576    30.00    9414.09   
131072  16384 1048576    30.00    9414.38   
131072  16384 1048576    30.00    9413.62   
131072  16384 1048576    30.00    9411.09   
131072  16384 1048576    30.00    9414.37   
131072  16384 1048576    30.00    9414.37   
131072  16384 1048576    30.00    9412.52   
131072  16384 1048576    30.00    9414.06   
131072  16384 1048576    30.00    9413.66   
131072  16384 1048576    30.00    9411.63   
131072  16384 1048576    30.00    9414.17   
131072  16384 1048576    30.00    9414.07   
131072  16384 1048576    30.00    9414.09   
131072  16384 1048576    30.00    9414.37   
131072  16384 1048576    30.00    9390.00   
131072  16384 1048576    30.00    9413.72   
131072  16384 1048576    30.01    9260.97   
131072  16384 1048576    30.01    9334.91   
131072  16384 1048576    30.00    9413.57   
131072  16384 1048576    30.00    9412.01   
131072  16384 1048576    30.00    9414.36   
131072  16384 1048576    30.00    9412.47   
131072  16384 1048576    30.00    9413.73   
131072  16384 1048576    30.00    9413.48   
131072  16384 1048576    30.00    9413.36   
131072  16384 1048576    30.01    9327.42   
131072  16384 1048576    30.01    9240.33   
131072  16384 1048576    30.00    9413.97   

(filtered only the interesting lines)

But after some more testing, I was also able to see similar results with
unpatched mainline kernel:

131072  16384 1048576    30.00    9413.28   
131072  16384 1048576    30.01    9007.17   
131072  16384 1048576    30.01    9153.22   
131072  16384 1048576    30.00    9414.28   
131072  16384 1048576    30.01    9244.68   
131072  16384 1048576    30.01    9230.49   
131072  16384 1048576    30.00    8723.24   <---
131072  16384 1048576    30.01    8289.21   <---
131072  16384 1048576    30.01    9258.33   
131072  16384 1048576    30.00    9251.47   
131072  16384 1048576    30.00    9414.23   
131072  16384 1048576    30.01    9276.87   
131072  16384 1048576    30.01    9255.61   
131072  16384 1048576    30.00    9072.78   
131072  16384 1048576    30.00    9412.09   
131072  16384 1048576    30.01    9393.00   
131072  16384 1048576    30.00    9413.39   
131072  16384 1048576    30.01    9404.01   
131072  16384 1048576    30.01    8412.83   <---
131072  16384 1048576    30.01    9368.23   
131072  16384 1048576    30.01    9259.11   
131072  16384 1048576    30.01    9121.65   
131072  16384 1048576    30.01    9169.87   
131072  16384 1048576    30.01    9154.03   
131072  16384 1048576    30.01    9336.34   
131072  16384 1048576    30.00    9187.73   
131072  16384 1048576    30.00    9412.54   
131072  16384 1048576    30.01    6836.37   <---
131072  16384 1048576    30.01    9388.09   
131072  16384 1048576    30.01    8755.78   <---
131072  16384 1048576    30.01    9167.63   
131072  16384 1048576    30.00    9410.80   
131072  16384 1048576    30.01    9392.71   
131072  16384 1048576    30.01    9238.50   
131072  16384 1048576    30.01    9382.78   
131072  16384 1048576    30.01    9328.23   
131072  16384 1048576    30.01    9396.04   
131072  16384 1048576    30.01    9286.10   
131072  16384 1048576    30.00    9412.44   
131072  16384 1048576    30.01    7952.34   <---
131072  16384 1048576    30.01    9309.95   
131072  16384 1048576    30.00    9133.38   
131072  16384 1048576    30.01    8672.75   
131072  16384 1048576    30.00    9414.28   
131072  16384 1048576    30.00    9411.34   
131072  16384 1048576    30.00    9414.27   
131072  16384 1048576    30.01    9313.60   
131072  16384 1048576    30.01    9315.10   
131072  16384 1048576    30.00    9413.23   
131072  16384 1048576    30.01    9285.77   
131072  16384 1048576    30.00    9414.28   
131072  16384 1048576    30.00    9406.39   
131072  16384 1048576    30.01    9343.74   
131072  16384 1048576    30.01    9179.17   
131072  16384 1048576    30.01    9081.18   
131072  16384 1048576    30.00    9412.85   
131072  16384 1048576    30.00    9413.66   
131072  16384 1048576    30.01    9346.16   
131072  16384 1048576    30.00    9410.01   
131072  16384 1048576    30.00    9411.22   

It's not clear why I haven't seen these before but the problem is
unlikely to by related to your patch set.

Michal
