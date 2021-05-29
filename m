Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC4E43949D0
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 03:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhE2B1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 21:27:09 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:5135 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhE2B1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 21:27:07 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FsP1j0W6jzYn66;
        Sat, 29 May 2021 09:22:49 +0800 (CST)
Received: from dggema762-chm.china.huawei.com (10.1.198.204) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 29 May 2021 09:25:30 +0800
Received: from [10.174.179.129] (10.174.179.129) by
 dggema762-chm.china.huawei.com (10.1.198.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 29 May 2021 09:25:29 +0800
Subject: Re: [PATCH] selftests/bpf: Fix return value check in attach_bpf()
To:     Daniel Borkmann <daniel@iogearbox.net>, <shuah@kernel.org>,
        <ast@kernel.org>, <andrii@kernel.org>
CC:     <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yi.zhang@huawei.com>
References: <20210528090758.1108464-1-yukuai3@huawei.com>
 <c5a37d91-dd20-55e3-a78b-272a00b940d5@iogearbox.net>
From:   "yukuai (C)" <yukuai3@huawei.com>
Message-ID: <b22eac4a-aad5-917d-5f26-7955b798779b@huawei.com>
Date:   Sat, 29 May 2021 09:25:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <c5a37d91-dd20-55e3-a78b-272a00b940d5@iogearbox.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.129]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema762-chm.china.huawei.com (10.1.198.204)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021/05/29 4:46, Daniel Borkmann wrote:
> On 5/28/21 11:07 AM, Yu Kuai wrote:
>> use libbpf_get_error() to check the return value of
>> bpf_program__attach().
>>
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   tools/testing/selftests/bpf/benchs/bench_rename.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/bpf/benchs/bench_rename.c 
>> b/tools/testing/selftests/bpf/benchs/bench_rename.c
>> index c7ec114eca56..b7d4a1d74fca 100644
>> --- a/tools/testing/selftests/bpf/benchs/bench_rename.c
>> +++ b/tools/testing/selftests/bpf/benchs/bench_rename.c
>> @@ -65,7 +65,7 @@ static void attach_bpf(struct bpf_program *prog)
>>       struct bpf_link *link;
>>       link = bpf_program__attach(prog);
>> -    if (!link) {
>> +    if (libbpf_get_error(link)) {
>>           fprintf(stderr, "failed to attach program!\n");
>>           exit(1);
>>       }
> 
> Could you explain the rationale of this patch? bad2e478af3b 
> ("selftests/bpf: Turn
> on libbpf 1.0 mode and fix all IS_ERR checks") explains: 'Fix all the 
> explicit
> IS_ERR checks that now will be broken because libbpf returns NULL on 
> error (and
> sets errno).' So the !link check looks totally reasonable to me. 
> Converting to
> libbpf_get_error() is not wrong in itself, but given you don't make any 
> use of
> the err code, there is also no point in this diff here.
Hi,

I was thinking that bpf_program__attach() can return error code
theoretically(for example -ESRCH), and such case need to be handled.

Thanks,
Yu Kuai
> 
> Thanks,
> Daniel
> .
> 
