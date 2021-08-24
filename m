Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83643F59F4
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhHXImX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 04:42:23 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:14316 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232714AbhHXImV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Aug 2021 04:42:21 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Gv2dY3H2rz7w4V;
        Tue, 24 Aug 2021 16:41:21 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 24 Aug 2021 16:41:35 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 24 Aug
 2021 16:41:34 +0800
Subject: Re: [PATCH RFC 0/7] add socket to netdev page frag recycling support
To:     David Ahern <dsahern@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
        <mw@semihalf.com>, <linuxarm@openeuler.org>,
        <yisen.zhuang@huawei.com>, <salil.mehta@huawei.com>,
        <thomas.petazzoni@bootlin.com>, <hawk@kernel.org>,
        <ilias.apalodimas@linaro.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>,
        <akpm@linux-foundation.org>, <peterz@infradead.org>,
        <will@kernel.org>, <willy@infradead.org>, <vbabka@suse.cz>,
        <fenghua.yu@intel.com>, <guro@fb.com>, <peterx@redhat.com>,
        <feng.tang@intel.com>, <jgg@ziepe.ca>, <mcroce@microsoft.com>,
        <hughd@google.com>, <jonathan.lemon@gmail.com>, <alobakin@pm.me>,
        <willemb@google.com>, <wenxu@ucloud.cn>, <cong.wang@bytedance.com>,
        <haokexin@gmail.com>, <nogikh@google.com>, <elver@google.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
        <chenhao288@hisilicon.com>, <edumazet@google.com>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>,
        <memxor@gmail.com>, <linux@rempel-privat.de>, <atenart@kernel.org>,
        <weiwan@google.com>, <ap420073@gmail.com>, <arnd@arndb.de>,
        <mathew.j.martineau@linux.intel.com>, <aahringo@redhat.com>,
        <ceggers@arri.de>, <yangbo.lu@nxp.com>, <fw@strlen.de>,
        <xiangxia.m.yue@gmail.com>, <linmiaohe@huawei.com>
References: <1629257542-36145-1-git-send-email-linyunsheng@huawei.com>
 <83b8bae8-d524-36a1-302e-59198410d9a9@gmail.com>
 <f0d935b9-45fe-4c51-46f0-1f526167877f@huawei.com>
 <619b5ca5-a48b-49e9-2fef-a849811d62bb@gmail.com>
 <744e88b6-7cb4-ea99-0523-4bfa5a23e15c@huawei.com>
 <80701f7a-e7c6-eb86-4018-67033f0823bf@gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <71ee12f2-8b71-923d-f993-ad4a43b9802d@huawei.com>
Date:   Tue, 24 Aug 2021 16:41:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <80701f7a-e7c6-eb86-4018-67033f0823bf@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme702-chm.china.huawei.com (10.1.199.98) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/24 11:34, David Ahern wrote:
> On 8/22/21 9:32 PM, Yunsheng Lin wrote:
>>
>> I assumed the "either Rx or Tx is cpu bound" meant either Rx or Tx is the
>> bottleneck?
> 
> yes.
> 
>>
>> It seems iperf3 support the Tx ZC, I retested using the iperf3, Rx settings
>> is not changed when testing, MTU is 1500:
> 
> -Z == sendfile API. That works fine to a point and that point is well
> below 100G.
> 
> I mean TCP with MSG_ZEROCOPY and SO_ZEROCOPY.
> 
>>
>> IOMMU in strict mode:
>> 1. Tx ZC case:
>>    22Gbit with Tx being bottleneck(cpu bound)
>> 2. Tx non-ZC case with pfrag pool enabled:
>>    40Git with Rx being bottleneck(cpu bound)
>> 3. Tx non-ZC case with pfrag pool disabled:
>>    30Git, the bottleneck seems not to be cpu bound, as the Rx and Tx does
>>    not have a single CPU reaching about 100% usage.
>>
>>>
>>> At 1500 MTU lowering CPU usage on the Tx side does not accomplish much
>>> on throughput since the Rx is 100% cpu.
>>
>> As above performance data, enabling ZC does not seems to help when IOMMU
>> is involved, which has about 30% performance degrade when pfrag pool is
>> disabled and 50% performance degrade when pfrag pool is enabled.
> 
> In a past response you should numbers for Tx ZC API with a custom
> program. That program showed the dramatic reduction in CPU cycles for Tx
> with the ZC API.

As I deduced the cpu usage from the cycles in "perf stat -e cycles XX", which
does not seem to include the cycles for NAPI polling, which does the tx clean
(including dma unmapping) and does not run in the same cpu as msg_zerocopy runs.

I retested it using msg_zerocopy:
       msg_zerocopy cpu usage      NAPI polling cpu usage
ZC:        23%                               70%
non-ZC     50%                               40%

So it seems to match now, sorry for the confusion.

> 
>>
>>>
>>> At 3300 MTU you have ~47% the pps for the same throughput. Lower pps
>>> reduces Rx processing and lower CPU to process the incoming stream. Then
>>> using the Tx ZC API you lower the Tx overehad allowing a single stream
>>> to faster - sending more data which in the end results in much higher
>>> pps and throughput. At the limit you are CPU bound (both ends in my
>>> testing as Rx side approaches the max pps, and Tx side as it continually
>>> tries to send data).
>>>
>>> Lowering CPU usage on Tx the side is a win regardless of whether there
>>> is a big increase on the throughput at 1500 MTU since that configuration
>>> is an Rx CPU bound problem. Hence, my point that we have a good start
>>> point for lowering CPU usage on the Tx side; we should improve it rather
>>> than add per-socket page pools.
>>
>> Acctually it is not a per-socket page pools, the page pool is still per
>> NAPI, this patchset adds multi allocation context to the page pool, so that
>> the tx can reuse the same page pool with rx, which is quite usefully if the
>> ARFS is enabled.
>>
>>>
>>> You can stress the Tx side and emphasize its overhead by modifying the
>>> receiver to drop the data on Rx rather than copy to userspace which is a
>>> huge bottleneck (e.g., MSG_TRUNC on recv). This allows the single flow
>>
>> As the frag page is supported in page pool for Rx, the Rx probably is not
>> a bottleneck any more, at least not for IOMMU in strict mode.
>>
>> It seems iperf3 does not support MSG_TRUNC yet, any testing tool supporting
>> MSG_TRUNC? Or do I have to hack the kernel or iperf3 tool to do that?
> 
> https://github.com/dsahern/iperf, mods branch
> 
> --zc_api is the Tx ZC API; --rx_drop adds MSG_TRUNC to recv.

Thanks for sharing the tool.
I retested using above iperf, and result is similar to previous result
too.

> 
> 
>>
>>> stream to go faster and emphasize Tx bottlenecks as the pps at 3300
>>> approaches the top pps at 1500. e.g., doing this with iperf3 shows the
>>> spinlock overhead with tcp_sendmsg, overhead related to 'select' and
>>> then gup_pgd_range.
>>
>> When IOMMU is in strict mode, the overhead with IOMMU seems to be much
>> bigger than spinlock(23% to 10%).
>>
>> Anyway, I still think ZC mostly benefit to packet which is bigger than a
>> specific size and IOMMU disabling case.
>>
>>
>>> .
>>>
> 
> .
> 
