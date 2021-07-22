Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63F23D1FC8
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 10:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbhGVHim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 03:38:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:12238 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbhGVHil (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 03:38:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GVlZF707Wz1CMYX;
        Thu, 22 Jul 2021 16:13:09 +0800 (CST)
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Jul 2021 16:18:49 +0800
Received: from [10.69.30.204] (10.69.30.204) by dggpemm500005.china.huawei.com
 (7.185.36.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2176.2; Thu, 22 Jul
 2021 16:18:48 +0800
Subject: Re: [PATCH v2 3/4] tools headers UAPI: add cpu_relax() implementation
 for x86 and arm64
To:     David Laight <David.Laight@ACULAB.COM>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
CC:     "nickhu@andestech.com" <nickhu@andestech.com>,
        "green.hu@gmail.com" <green.hu@gmail.com>,
        "deanbo422@gmail.com" <deanbo422@gmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "yury.norov@gmail.com" <yury.norov@gmail.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "ojeda@kernel.org" <ojeda@kernel.org>,
        "ndesaulniers@gooogle.com" <ndesaulniers@gooogle.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
References: <1626747709-34013-1-git-send-email-linyunsheng@huawei.com>
 <1626747709-34013-4-git-send-email-linyunsheng@huawei.com>
 <5db490c6f264431e91bcdbb62fcf3be5@AcuMS.aculab.com>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <9efd2434-feac-a385-f3c5-4a0fb0cc7706@huawei.com>
Date:   Thu, 22 Jul 2021 16:18:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <5db490c6f264431e91bcdbb62fcf3be5@AcuMS.aculab.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.69.30.204]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggpemm500005.china.huawei.com (7.185.36.74)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/7/22 4:53, David Laight wrote:
> From: Yunsheng Lin
>> Sent: 20 July 2021 03:22
>>
>> As x86 and arm64 is the two available systems that I can build
>> and test the cpu_relax() implementation, so only add cpu_relax()
>> implementation for x86 and arm64, other arches can be added easily
>> when needed.
>>
> ...
>> +#if defined(__i386__) || defined(__x86_64__)
>> +/* REP NOP (PAUSE) is a good thing to insert into busy-wait loops. */
>> +static __always_inline void rep_nop(void)
>> +{
>> +	asm volatile("rep; nop" ::: "memory");
>> +}
> 
> Beware, Intel increased the stall for 'rep nop' in some recent
> cpu to IIRC about 200 cycles.
> 
> They even document that this might have a detrimental effect.
> It is basically far too long for the sort of thing it makes
> sense to busy-wait for.

Thanks for the info:)
I will be beware of that when playing with  'rep nop' in newer
x86 cpu.

> .
> 
