Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3B1343657
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 02:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCVBhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 21:37:55 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3493 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhCVBhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 21:37:32 -0400
Received: from DGGEML402-HUB.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4F3cWx3nwFzRSjD;
        Mon, 22 Mar 2021 09:35:41 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 DGGEML402-HUB.china.huawei.com (10.3.17.38) with Microsoft SMTP Server (TLS)
 id 14.3.498.0; Mon, 22 Mar 2021 09:37:25 +0800
Received: from [127.0.0.1] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2106.2; Mon, 22 Mar
 2021 09:37:25 +0800
Subject: Re: [Linuxarm] [PATCH net] net: sched: fix packet stuck problem for
 lockless qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Wei Wang <weiwan@google.com>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Taehee Yoo <ap420073@gmail.com>,
        "Linux Kernel Network Developers" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linuxarm@openeuler.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        <linux-can@vger.kernel.org>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        Josh Hunt <johunt@akamai.com>,
        "Jike Song" <albcamus@gmail.com>,
        Kehuan Feng <kehuan.feng@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
References: <1616050402-37023-1-git-send-email-linyunsheng@huawei.com>
 <e5c2d82c-0158-3997-80b6-4aab56c61367@huawei.com>
 <CAM_iQpV4HX5L1b8ofUig-bi3r_MDdsjThqaxfoRCd=02XZBprQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <383f1c9b-016f-0aaa-def3-9d8786d40b01@huawei.com>
Date:   Mon, 22 Mar 2021 09:37:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAM_iQpV4HX5L1b8ofUig-bi3r_MDdsjThqaxfoRCd=02XZBprQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme711-chm.china.huawei.com (10.1.199.107) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/3/20 3:45, Cong Wang wrote:
> On Fri, Mar 19, 2021 at 2:25 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>> I had done some performance test to see if there is value to
>> fix the packet stuck problem and support lockless qdisc bypass,
>> here is some result using pktgen in 'queue_xmit' mode on a dummy
>> device as Paolo Abeni had done in [1], and using pfifo_fast qdisc:
>>
>> threads  vanilla    locked-qdisc    vanilla+this_patch
>>    1     2.6Mpps      2.9Mpps            2.5Mpps
>>    2     3.9Mpps      4.8Mpps            3.6Mpps
>>    4     5.6Mpps      3.0Mpps            4.7Mpps
>>    8     2.7Mpps      1.6Mpps            2.8Mpps
>>    16    2.2Mpps      1.3Mpps            2.3Mpps
>>
>> locked-qdisc: test by removing the "TCQ_F_NOLOCK | TCQ_F_CPUSTATS".
> 
> I read this as this patch introduces somehow a performance
> regression for -net, as the lockless bypass patch you submitted is
> for -net-next.

Yes, right now there is performance regression for fixing this bug,
but the problem is that if we can not fix the above data race without
any performance regression, do you prefer to send this patch to
-net, or to -net-next with the lockless bypass patch?

Any idea to fix this with less performance regression?

> 
> Thanks.
> 
> .
> 

