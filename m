Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDFE32C3E6
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354454AbhCDAIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:49 -0500
Received: from mga02.intel.com ([134.134.136.20]:57261 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377445AbhCCHRb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 02:17:31 -0500
IronPort-SDR: DOyiL31QVEu6GSHhfTbmDFH/3I9QtSETiXuBPiobZrCYXY8+bsJMwTi1J2K+W6ml0i/fwvOm4Y
 FHnJwVGcufGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9911"; a="174247774"
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="174247774"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 23:14:31 -0800
IronPort-SDR: Ugd5v/PI7dn/AdDkmtShX8ns1liL0/mdL2a741NulTMRboT/LJdZbhFnaTC2RUJvOfhRnGdCGb
 b2XVrlyGe4XA==
X-IronPort-AV: E=Sophos;i="5.81,219,1610438400"; 
   d="scan'208";a="407113563"
Received: from jdibley-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.61.121])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2021 23:14:22 -0800
Subject: Re: [PATCH bpf-next 2/2] libbpf, xsk: add libbpf_smp_store_release
 libbpf_smp_load_acquire
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>, maximmi@nvidia.com,
        Andrii Nakryiko <andrii@kernel.org>
References: <20210301104318.263262-1-bjorn.topel@gmail.com>
 <20210301104318.263262-3-bjorn.topel@gmail.com>
 <CAEf4BzZFDAcnaWU2JGL2GKmTTWQPDrcdgEn2NOM9cGFe16XheQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <a65075f7-b46c-9131-f969-a6458e6001b7@intel.com>
Date:   Wed, 3 Mar 2021 08:14:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAEf4BzZFDAcnaWU2JGL2GKmTTWQPDrcdgEn2NOM9cGFe16XheQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-03-03 05:38, Andrii Nakryiko wrote:
> On Mon, Mar 1, 2021 at 2:43 AM Björn Töpel <bjorn.topel@gmail.com> wrote:
>>
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> Now that the AF_XDP rings have load-acquire/store-release semantics,
>> move libbpf to that as well.
>>
>> The library-internal libbpf_smp_{load_acquire,store_release} are only
>> valid for 32-bit words on ARM64.
>>
>> Also, remove the barriers that are no longer in use.
>>
>> Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
>> ---
>>   tools/lib/bpf/libbpf_util.h | 72 +++++++++++++++++++++++++------------
>>   tools/lib/bpf/xsk.h         | 17 +++------
>>   2 files changed, 55 insertions(+), 34 deletions(-)
>>
>> diff --git a/tools/lib/bpf/libbpf_util.h b/tools/lib/bpf/libbpf_util.h
>> index 59c779c5790c..94a0d7bb6f3c 100644
>> --- a/tools/lib/bpf/libbpf_util.h
>> +++ b/tools/lib/bpf/libbpf_util.h
>> @@ -5,6 +5,7 @@
>>   #define __LIBBPF_LIBBPF_UTIL_H
>>
>>   #include <stdbool.h>
>> +#include <linux/compiler.h>
>>
>>   #ifdef __cplusplus
>>   extern "C" {
>> @@ -15,29 +16,56 @@ extern "C" {
>>    * application that uses libbpf.
>>    */
>>   #if defined(__i386__) || defined(__x86_64__)
>> -# define libbpf_smp_rmb() asm volatile("" : : : "memory")
>> -# define libbpf_smp_wmb() asm volatile("" : : : "memory")
>> -# define libbpf_smp_mb() \
>> -       asm volatile("lock; addl $0,-4(%%rsp)" : : : "memory", "cc")
>> -/* Hinders stores to be observed before older loads. */
>> -# define libbpf_smp_rwmb() asm volatile("" : : : "memory")
> 
> So, technically, these four are part of libbpf's API, as libbpf_util.h
> is actually installed on target hosts. Seems like xsk.h is the only
> one that is using them, though.
> 
> So the question is whether it's ok to remove them now?
>

I would say that. Ideally, the barriers shouldn't be visible at all,
since they're only used as an implementation detail for the static
inline functions.


> And also, why wasn't this part of xsk.h in the first place?
>

I guess there was a "maybe it can be useful for more than the XDP socket 
parts of libbpf"-idea. I'll move them to xsk.h for the v2, which will 
make the migration easier.


Björn


>> +# define libbpf_smp_store_release(p, v)                                        \
>> +       do {                                                            \
>> +               asm volatile("" : : : "memory");                        \
>> +               WRITE_ONCE(*p, v);                                      \
>> +       } while (0)
>> +# define libbpf_smp_load_acquire(p)                                    \
>> +       ({                                                              \
>> +               typeof(*p) ___p1 = READ_ONCE(*p);                       \
>> +               asm volatile("" : : : "memory");                        \
>> +               ___p1;                                                  \
>> +       })
> 
> [...]
> 
