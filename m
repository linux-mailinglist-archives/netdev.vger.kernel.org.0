Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F1383BC4AE
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 04:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhGFCGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 22:06:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9479 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbhGFCGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 22:06:44 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GJm442kMtzZrBL;
        Tue,  6 Jul 2021 10:00:52 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 6 Jul 2021 10:04:03 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 10:04:03 +0800
Subject: Re: [PATCH net-next 1/2] tools: add missing infrastructure for
 building ptr_ring.h
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jasowang@redhat.com>,
        <nickhu@andestech.com>, <green.hu@gmail.com>,
        <deanbo422@gmail.com>, <akpm@linux-foundation.org>,
        <yury.norov@gmail.com>, <andriy.shevchenko@linux.intel.com>,
        <ojeda@kernel.org>, <ndesaulniers@gooogle.com>, <joe@perches.com>,
        <linux-kernel@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>
References: <1625457455-4667-1-git-send-email-linyunsheng@huawei.com>
 <1625457455-4667-2-git-send-email-linyunsheng@huawei.com>
 <20210705143144-mutt-send-email-mst@kernel.org>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <cbc4053e-7eda-4c46-5b98-558c741e45b6@huawei.com>
Date:   Tue, 6 Jul 2021 10:04:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20210705143144-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme704-chm.china.huawei.com (10.1.199.100) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/6 2:39, Michael S. Tsirkin wrote:
> On Mon, Jul 05, 2021 at 11:57:34AM +0800, Yunsheng Lin wrote:
>> In order to build ptr_ring.h in userspace, the cacheline
>> aligning, cpu_relax() and slab related infrastructure is
>> needed, so add them in this patch.
>>
>> As L1_CACHE_BYTES may be different for different arch, which
>> is mostly defined in include/generated/autoconf.h, so user may
>> need to do "make defconfig" before building a tool using the
>> API in linux/cache.h.
>>
>> Also "linux/lockdep.h" is not added in "tools/include" yet,
>> so remove it in "linux/spinlock.h", and the only place using
>> "linux/spinlock.h" is tools/testing/radix-tree, removing that
>> does not break radix-tree testing.
>>
>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> This is hard to review.
> Try to split this please. Functional changes separate from
> merely moving code around.

Sure.

> 
> 
>> ---
>>  tools/include/asm/cache.h          | 56 ++++++++++++++++++++++++
>>  tools/include/asm/processor.h      | 36 ++++++++++++++++
>>  tools/include/generated/autoconf.h |  1 +
>>  tools/include/linux/align.h        | 15 +++++++
>>  tools/include/linux/cache.h        | 87 ++++++++++++++++++++++++++++++++++++++
>>  tools/include/linux/gfp.h          |  4 ++
>>  tools/include/linux/slab.h         | 46 ++++++++++++++++++++
>>  tools/include/linux/spinlock.h     |  2 -
>>  8 files changed, 245 insertions(+), 2 deletions(-)
>>  create mode 100644 tools/include/asm/cache.h
>>  create mode 100644 tools/include/asm/processor.h
>>  create mode 100644 tools/include/generated/autoconf.h
>>  create mode 100644 tools/include/linux/align.h
>>  create mode 100644 tools/include/linux/cache.h
>>  create mode 100644 tools/include/linux/slab.h
>>
>> diff --git a/tools/include/asm/cache.h b/tools/include/asm/cache.h
>> new file mode 100644
>> index 0000000..071e310
>> --- /dev/null
>> +++ b/tools/include/asm/cache.h
>> @@ -0,0 +1,56 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#ifndef __TOOLS_LINUX_ASM_CACHE_H
>> +#define __TOOLS_LINUX_ASM_CACHE_H
>> +
>> +#include <generated/autoconf.h>
>> +
>> +#if defined(__i386__) || defined(__x86_64__)
>> +#define L1_CACHE_SHIFT	(CONFIG_X86_L1_CACHE_SHIFT)
>> +#elif defined(__arm__)
>> +#define L1_CACHE_SHIFT	(CONFIG_ARM_L1_CACHE_SHIFT)
>> +#elif defined(__aarch64__)
>> +#define L1_CACHE_SHIFT	(6)
>> +#elif defined(__powerpc__)
>> +
>> +/* bytes per L1 cache line */
>> +#if defined(CONFIG_PPC_8xx)
>> +#define L1_CACHE_SHIFT	4
>> +#elif defined(CONFIG_PPC_E500MC)
>> +#define L1_CACHE_SHIFT	6
>> +#elif defined(CONFIG_PPC32)
>> +#if defined(CONFIG_PPC_47x)
>> +#define L1_CACHE_SHIFT	7
>> +#else
>> +#define L1_CACHE_SHIFT	5
>> +#endif
>> +#else /* CONFIG_PPC64 */
>> +#define L1_CACHE_SHIFT	7
>> +#endif
>> +
>> +#elif defined(__sparc__)
>> +#define L1_CACHE_SHIFT 5
>> +#elif defined(__alpha__)
>> +
>> +#if defined(CONFIG_ALPHA_GENERIC) || defined(CONFIG_ALPHA_EV6)
>> +#define L1_CACHE_SHIFT	6
>> +#else
>> +/* Both EV4 and EV5 are write-through, read-allocate,
>> +   direct-mapped, physical.
>> +*/
>> +#define L1_CACHE_SHIFT	5
>> +#endif
>> +
>> +#elif defined(__mips__)
>> +#define L1_CACHE_SHIFT	CONFIG_MIPS_L1_CACHE_SHIFT
>> +#elif defined(__ia64__)
>> +#define L1_CACHE_SHIFT	CONFIG_IA64_L1_CACHE_SHIFT
>> +#elif defined(__nds32__)
>> +#define L1_CACHE_SHIFT	5
>> +#else
>> +#define L1_CACHE_SHIFT	5
>> +#endif
>> +
>> +#define L1_CACHE_BYTES	(1 << L1_CACHE_SHIFT)
>> +
>> +#endif
>> diff --git a/tools/include/asm/processor.h b/tools/include/asm/processor.h
>> new file mode 100644
>> index 0000000..3198ad6
>> --- /dev/null
>> +++ b/tools/include/asm/processor.h
>> @@ -0,0 +1,36 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#ifndef __TOOLS_LINUX_ASM_PROCESSOR_H
>> +#define __TOOLS_LINUX_ASM_PROCESSOR_H
>> +
>> +#include <pthread.h>
>> +
>> +#if defined(__i386__) || defined(__x86_64__)
>> +#include "../../arch/x86/include/asm/vdso/processor.h"
>> +#elif defined(__arm__)
>> +#include "../../arch/arm/include/asm/vdso/processor.h"
>> +#elif defined(__aarch64__)
>> +#include "../../arch/arm64/include/asm/vdso/processor.h"
>> +#elif defined(__powerpc__)
>> +#include "../../arch/powerpc/include/vdso/processor.h"
>> +#elif defined(__s390__)
>> +#include "../../arch/s390/include/vdso/processor.h"
>> +#elif defined(__sh__)
>> +#include "../../arch/sh/include/asm/processor.h"
>> +#elif defined(__sparc__)
>> +#include "../../arch/sparc/include/asm/processor.h"
>> +#elif defined(__alpha__)
>> +#include "../../arch/alpha/include/asm/processor.h"
>> +#elif defined(__mips__)
>> +#include "../../arch/mips/include/asm/vdso/processor.h"
>> +#elif defined(__ia64__)
>> +#include "../../arch/ia64/include/asm/processor.h"
>> +#elif defined(__xtensa__)
>> +#include "../../arch/xtensa/include/asm/processor.h"
>> +#elif defined(__nds32__)
>> +#include "../../arch/nds32/include/asm/processor.h"
>> +#else
>> +#define cpu_relax()	sched_yield()
> 
> Does this have a chance to work outside of kernel?

I am not sure I understand what you meant here.
sched_yield() is a pthread API, so it should work in the
user space.
And it allow the rigntest to compile when it is built on
the arch which is not handled as above.

> 
>> +#endif
> 
> did you actually test or even test build all these arches?
> Not sure we need to bother with hacks like these.

Only x86_64 and arm64 arches have been built and tested.

This is added referring the tools/include/asm/barrier.h.

> 
> 
>> +

