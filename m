Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84DA53C5AE1
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233599AbhGLKmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 06:42:32 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6917 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbhGLKma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 06:42:30 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GNgCq4szZz7BcH;
        Mon, 12 Jul 2021 18:36:07 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 18:39:39 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Mon, 12 Jul
 2021 18:39:38 +0800
Subject: Re: [Linuxarm] [PATCH rfc v3 0/4] add frag page support in page pool
From:   Yunsheng Lin <linyunsheng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
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
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
References: <1626081581-54524-1-git-send-email-linyunsheng@huawei.com>
Message-ID: <22579591-606c-9967-42e5-fcfe18875026@huawei.com>
Date:   Mon, 12 Jul 2021 18:39:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <1626081581-54524-1-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme709-chm.china.huawei.com (10.1.199.105) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this patch set, will send out a new series
without duplicated patch 3 and fix a bug for a corner case.

On 2021/7/12 17:19, Yunsheng Lin wrote:
> This patchset adds frag page support in page pool and
> enable skb's page frag recycling based on page pool in
> hns3 drvier.
> 
> RFC v3:
> 1. Implement the semantic of "page recycling only wait for the
>    page pool user instead of all user of a page" 
> 2. Support the frag allocation of different sizes
> 3. Merge patch 4 & 5 to one patch as it does not make sense to
>    use page_pool_dev_alloc_pages() API directly with elevated
>    refcnt.
> 4. other minor comment suggested by Alexander.
> 
> RFC v2:
> 1. Split patch 1 to more reviewable one.
> 2. Repurpose the lower 12 bits of the dma address to store the
>    pagecnt_bias as suggested by Alexander.
> 3. support recycling to pool->alloc for elevated refcnt case
>    too.
> 
> 
> Yunsheng Lin (4):
>   page_pool: keep pp info as long as page pool owns the page
>   page_pool: add interface for getting and setting pagecnt_bias
>   page_pool: add frag page recycling support in page pool
>   net: hns3: support skb's frag page recycling based on page pool
> 
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.c |  79 ++++++++++++-
>  drivers/net/ethernet/hisilicon/hns3/hns3_enet.h |   3 +
>  drivers/net/ethernet/marvell/mvneta.c           |   6 +-
>  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |   2 +-
>  drivers/net/ethernet/ti/cpsw.c                  |   2 +-
>  drivers/net/ethernet/ti/cpsw_new.c              |   2 +-
>  include/linux/skbuff.h                          |   4 +-
>  include/net/page_pool.h                         |  58 +++++++--
>  net/core/page_pool.c                            | 150 +++++++++++++++++++++---
>  9 files changed, 262 insertions(+), 44 deletions(-)
> 
