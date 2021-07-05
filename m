Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8E63BB81B
	for <lists+netdev@lfdr.de>; Mon,  5 Jul 2021 09:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhGEHrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Jul 2021 03:47:47 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:6395 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhGEHrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Jul 2021 03:47:47 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4GJHgp59d4z77t6;
        Mon,  5 Jul 2021 15:41:42 +0800 (CST)
Received: from [10.174.176.245] (10.174.176.245) by
 dggeme766-chm.china.huawei.com (10.3.19.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 5 Jul 2021 15:45:07 +0800
Subject: Re: [PATCH bpf] samples/bpf: Fix the error return code of
 xdp_redirect's main()
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20210616042534.315097-1-wanghai38@huawei.com>
 <94aad4ed-8384-1841-88ec-6c7e39d63148@redhat.com>
From:   "wanghai (M)" <wanghai38@huawei.com>
Message-ID: <6f35ad34-1334-bdae-da7f-a20f1af34ea5@huawei.com>
Date:   Mon, 5 Jul 2021 15:45:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <94aad4ed-8384-1841-88ec-6c7e39d63148@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.176.245]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/7/2 18:29, Jesper Dangaard Brouer 写道:
>
> On 16/06/2021 06.25, Wang Hai wrote:
>> Fix to return a negative error code from the error handling
>> case instead of 0, as done elsewhere in this function.
>
> The main() function in C should never return a negative value on Unix 
> POSIX systems.
>
>
> There is a good explaination in exit(3p): `man 3p exit`
>
>    The  value  of  status may be 0, EXIT_SUCCESS, EXIT_FAILURE, or any 
> other value, though only the least significant 8 bits (that is, status 
> & 0377) shall be available to a waiting parent process.
>
> Thus, negative values are often seen as 255 in the $? program exit 
> status variable $?.
>
>
> Also explained in exit(3):
>
>     The C standard specifies two constants, EXIT_SUCCESS=0 and 
> EXIT_FAILURE=1.
>
> I see the 'samples/bpf/xdp_redirect_user.c' in most places just use 0 
> or 1.
>
Got it, thanks for the explanation, I will fix it to return 1, just like 
the other error paths in samples/bpf/xdp_redirect_user.c
>
>> If bpf_map_update_elem() failed, main() should return a negative error.
>>
>> Fixes: 832622e6bd18 ("xdp: sample program for new bpf_redirect helper")
>> Signed-off-by: Wang Hai <wanghai38@huawei.com>
>> ---
>>   samples/bpf/xdp_redirect_user.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/samples/bpf/xdp_redirect_user.c 
>> b/samples/bpf/xdp_redirect_user.c
>> index 41d705c3a1f7..c903f1ccc15e 100644
>> --- a/samples/bpf/xdp_redirect_user.c
>> +++ b/samples/bpf/xdp_redirect_user.c
>> @@ -213,5 +213,5 @@ int main(int argc, char **argv)
>>       poll_stats(2, ifindex_out);
>>     out:
>> -    return 0;
>> +    return ret;
>>   }
>
>
> (Sorry, I didn't complain it time as I see this patch is already applied)
>
> .
>
