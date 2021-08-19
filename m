Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AF63F1509
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 10:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237160AbhHSIUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 04:20:10 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:17049 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbhHSIS7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 04:18:59 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GqyGz1h4YzbfN6;
        Thu, 19 Aug 2021 16:14:35 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 16:18:20 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 19 Aug
 2021 16:18:19 +0800
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
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <f0d935b9-45fe-4c51-46f0-1f526167877f@huawei.com>
Date:   Thu, 19 Aug 2021 16:18:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <83b8bae8-d524-36a1-302e-59198410d9a9@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme716-chm.china.huawei.com (10.1.199.112) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/8/19 6:05, David Ahern wrote:
> On 8/17/21 9:32 PM, Yunsheng Lin wrote:
>> This patchset adds the socket to netdev page frag recycling
>> support based on the busy polling and page pool infrastructure.
>>
>> The profermance improve from 30Gbit to 41Gbit for one thread iperf
>> tcp flow, and the CPU usages decreases about 20% for four threads
>> iperf flow with 100Gb line speed in IOMMU strict mode.
>>
>> The profermance improve about 2.5% for one thread iperf tcp flow
>> in IOMMU passthrough mode.
>>
> 
> Details about the test setup? cpu model, mtu, any other relevant changes
> / settings.

CPU is arm64 Kunpeng 920, see:
https://www.hisilicon.com/en/products/Kunpeng/Huawei-Kunpeng-920

mtu is 1500, the relevant changes/settings I can think of the iperf
client runs on the same numa as the nic hw exists(which has one 100Gbit
port), and the driver has the XPS enabled too.

> 
> How does that performance improvement compare with using the Tx ZC API?
> At 1500 MTU I see a CPU drop on the Tx side from 80% to 20% with the ZC
> API and ~10% increase in throughput. Bumping the MTU to 3300 and
> performance with the ZC API is 2x the current model with 1/2 the cpu.

I added a sysctl node to decide whether pfrag pool is used:
net.ipv4.tcp_use_pfrag_pool

and use msg_zerocopy to compare the result:
Server uses cmd "./msg_zerocopy -4 -i eth4 -C 32 -S 192.168.100.2 -r tcp"
Client uses cmd "./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -"

The zc does seem to improve the CPU usages significantly, but not for throughput
with mtu 1500. And the result seems to be similar with mtu 3300.

the detail result is below:

(1) IOMMU strict mode + net.ipv4.tcp_use_pfrag_pool = 0:
root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp
tx=115317 (7196 MB) txc=0 zc=n

 Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp':

        4315472244      cycles

       4.199890190 seconds time elapsed

       0.084328000 seconds user
       1.528714000 seconds sys
root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z
tx=90121 (5623 MB) txc=90121 zc=y

 Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z':

        1715892155      cycles

       4.243329050 seconds time elapsed

       0.083275000 seconds user
       0.755355000 seconds sys


(2)IOMMU strict mode + net.ipv4.tcp_use_pfrag_pool = 1:
root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp
tx=138932 (8669 MB) txc=0 zc=n

 Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp':

        4034016168      cycles

       4.199877510 seconds time elapsed

       0.058143000 seconds user
       1.644480000 seconds sys
root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z
tx=93369 (5826 MB) txc=93369 zc=y

 Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z':

        1815300491      cycles

       4.243259530 seconds time elapsed

       0.051767000 seconds user
       0.796610000 seconds sys


(3)IOMMU passthrough + net.ipv4.tcp_use_pfrag_pool=0
root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp
tx=129927 (8107 MB) txc=0 zc=n

 Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp':

        3720131007      cycles

       4.200651840 seconds time elapsed

       0.038604000 seconds user
       1.455521000 seconds sys
root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z
tx=135285 (8442 MB) txc=135285 zc=y

 Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp -z':

        1721949875      cycles

       4.242596800 seconds time elapsed

       0.024963000 seconds user
       0.779391000 seconds sys

(4)IOMMU  passthrough + net.ipv4.tcp_use_pfrag_pool=1
root@(none):/# perf stat -e cycles ./msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp
tx=151844 (9475 MB) txc=0 zc=n

 Performance counter stats for './msg_zerocopy -4 -i eth4 -C 0 -S 192.168.100.1 -D 192.168.100.2 tcp':

        3786216097      cycles

       4.200606520 seconds time elapsed

       0.028633000 seconds user
       1.569736000 seconds sys


> 
> Epyc 7502, ConnectX-6, IOMMU off.
> 
> In short, it seems like improving the Tx ZC API is the better path
> forward than per-socket page pools.

The main goal is to optimize the SMMU mapping/unmaping, if the cost of memcpy
it higher than the SMMU mapping/unmaping + page pinning, then Tx ZC may be a
better path, at leas it is not sure for small packet?


> .
> 
