Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C82A1B54AE
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 08:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgDWGZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 02:25:30 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40470 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725562AbgDWGZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Apr 2020 02:25:30 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 290AED655491A23D2DD2;
        Thu, 23 Apr 2020 14:25:27 +0800 (CST)
Received: from [127.0.0.1] (10.166.215.92) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Thu, 23 Apr 2020
 14:25:23 +0800
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Change error code when ops is NULL
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
References: <20200422093329.GI2659@kadam>
 <20200423033314.49205-1-maowenan@huawei.com>
 <20200423033314.49205-2-maowenan@huawei.com>
 <CAADnVQLfqLBzsjK0KddZM7WTL3unzWw+v18L0pw8HQnWsEVUzA@mail.gmail.com>
From:   maowenan <maowenan@huawei.com>
Message-ID: <bd36c161-8831-1f61-1531-063723a8d8c2@huawei.com>
Date:   Thu, 23 Apr 2020 14:25:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAADnVQLfqLBzsjK0KddZM7WTL3unzWw+v18L0pw8HQnWsEVUzA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.166.215.92]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/4/23 13:43, Alexei Starovoitov wrote:
> On Wed, Apr 22, 2020 at 8:31 PM Mao Wenan <maowenan@huawei.com> wrote:
>>
>> There is one error printed when use BPF_MAP_TYPE_SOCKMAP to create map:
>> libbpf: failed to create map (name: 'sock_map'): Invalid argument(-22)
>>
>> This is because CONFIG_BPF_STREAM_PARSER is not set, and
>> bpf_map_types[type] return invalid ops. It is not clear to show the
>> cause of config missing with return code -EINVAL, so add pr_warn() and
>> change error code to describe the reason.
>>
>> Signed-off-by: Mao Wenan <maowenan@huawei.com>
>> ---
>>  kernel/bpf/syscall.c | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
>> index d85f37239540..7686778457c7 100644
>> --- a/kernel/bpf/syscall.c
>> +++ b/kernel/bpf/syscall.c
>> @@ -112,9 +112,10 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
>>                 return ERR_PTR(-EINVAL);
>>         type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
>>         ops = bpf_map_types[type];
>> -       if (!ops)
>> -               return ERR_PTR(-EINVAL);
>> -
>> +       if (!ops) {
>> +               pr_warn("map type %d not supported or kernel config not opened\n", type);
>> +               return ERR_PTR(-EOPNOTSUPP);
>> +       }
> 
> I don't think users will like it when kernel spams dmesg.
> If you need this level of verbosity please teach consumer of libbpf to
> print them.
> It's not a job of libbpf either.
thanks for reviw, so is it better to delete redundant pr_warn()?

> 
> .
> 


