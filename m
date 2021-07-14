Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875303C7E69
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 08:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238013AbhGNGQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 02:16:43 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6813 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237958AbhGNGQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 02:16:42 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GPn9h5mkvzXsvb;
        Wed, 14 Jul 2021 14:08:08 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Jul 2021 14:13:43 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 14:13:42 +0800
Subject: Re: [PATCH rfc v4 4/4] net: hns3: support skb's frag page recycling
 based on page pool
To:     Denis Kirjanov <kda@linux-powerpc.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <alexander.duyck@gmail.com>, <linux@armlinux.org.uk>,
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
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
References: <1626168272-25622-1-git-send-email-linyunsheng@huawei.com>
 <1626168272-25622-5-git-send-email-linyunsheng@huawei.com>
 <CAOJe8K33OM0_FpMtE_iDqRHYNGoKrZyBaoe6TiSHumcAoMsFnQ@mail.gmail.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <61d984ae-bfdd-3552-ca87-8e099aae5427@huawei.com>
Date:   Wed, 14 Jul 2021 14:13:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <CAOJe8K33OM0_FpMtE_iDqRHYNGoKrZyBaoe6TiSHumcAoMsFnQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme705-chm.china.huawei.com (10.1.199.101) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/13 19:42, Denis Kirjanov wrote:
> On 7/13/21, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>> This patch adds skb's frag page recycling support based on
>> the elevated refcnt support in page pool.
>>
>> The performance improves above 10~20% with IOMMU disabled.
>> The performance improves about 200% when IOMMU is enabled
>> and iperf server shares the same cpu with irq/NAPI.
> 
> Could you share workload details?

The testcase is simple, using iperf TCP with only one thread.
The the iperf server CPU and NAPI softirq CPU is pinned to the
same CPU, the performance improves from 14Gbit to 33Gbit when
SMMU is in strict mode, so the above state is not accurate, it
should be "improves to about 200% when IOMMU is in strict mode"

> 
>>
