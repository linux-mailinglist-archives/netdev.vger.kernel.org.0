Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAB7062514C
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 04:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbiKKDLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 22:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbiKKDLp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 22:11:45 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260552EF48;
        Thu, 10 Nov 2022 19:11:42 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4N7kDh5RrKzJnbh;
        Fri, 11 Nov 2022 11:08:36 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:11:39 +0800
Received: from [10.67.111.205] (10.67.111.205) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 11 Nov 2022 11:11:38 +0800
Subject: Re: [PATCH bpf] selftests/bpf: Fix xdp_synproxy compilation failure
 in 32-bit arch
To:     Yonghong Song <yhs@meta.com>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <davem@davemloft.net>, <kuba@kernel.org>,
        <hawk@kernel.org>, <john.fastabend@gmail.com>, <andrii@kernel.org>,
        <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <mykolal@fb.com>, <shuah@kernel.org>,
        <tariqt@nvidia.com>, <maximmi@nvidia.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221108131242.17362-1-yangjihong1@huawei.com>
 <c8bd9f3b-52fa-08bd-e5df-e87b68ffdbba@meta.com>
From:   Yang Jihong <yangjihong1@huawei.com>
Message-ID: <f5391830-352a-6daa-9233-a177db43ba71@huawei.com>
Date:   Fri, 11 Nov 2022 11:11:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <c8bd9f3b-52fa-08bd-e5df-e87b68ffdbba@meta.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.205]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On 2022/11/8 23:59, Yonghong Song wrote:
> 
> 
> On 11/8/22 5:12 AM, Yang Jihong wrote:
>> xdp_synproxy fails to be compiled in the 32-bit arch, log is as follows:
>>
>>    xdp_synproxy.c: In function 'parse_options':
>>    xdp_synproxy.c:175:36: error: left shift count >= width of type 
>> [-Werror=shift-count-overflow]
>>      175 |                 *tcpipopts = (mss6 << 32) | (ttl << 24) | 
>> (wscale << 16) | mss4;
>>          |                                    ^~
>>    xdp_synproxy.c: In function 'syncookie_open_bpf_maps':
>>    xdp_synproxy.c:289:28: error: cast from pointer to integer of 
>> different size [-Werror=pointer-to-int-cast]
>>      289 |                 .map_ids = (__u64)map_ids,
>>          |                            ^
>>
>> Fix it.
>>
>> Fixes: fb5cd0ce70d4 ("selftests/bpf: Add selftests for raw syncookie 
>> helpers")
>> Signed-off-by: Yang Jihong <yangjihong1@huawei.com>
>> ---
>>   tools/testing/selftests/bpf/xdp_synproxy.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/xdp_synproxy.c 
>> b/tools/testing/selftests/bpf/xdp_synproxy.c
>> index ff35320d2be9..45fef01a87a8 100644
>> --- a/tools/testing/selftests/bpf/xdp_synproxy.c
>> +++ b/tools/testing/selftests/bpf/xdp_synproxy.c
>> @@ -172,7 +172,7 @@ static void parse_options(int argc, char *argv[], 
>> unsigned int *ifindex, __u32 *
>>       if (tcpipopts_mask == 0xf) {
>>           if (mss4 == 0 || mss6 == 0 || wscale == 0 || ttl == 0)
>>               usage(argv[0]);
>> -        *tcpipopts = (mss6 << 32) | (ttl << 24) | (wscale << 16) | mss4;
>> +        *tcpipopts = ((unsigned long long)mss6 << 32) | (ttl << 24) | 
>> (wscale << 16) | mss4;
> 
> This looks weird. Maybe we should define mss6 as unsigned long long to 
> avoid this casting at all?
OK, will fix in next version.

Thanks,
Yang
