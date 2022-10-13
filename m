Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A15A5FD2E6
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiJMBpO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJMBpK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:45:10 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B02B93F1C6;
        Wed, 12 Oct 2022 18:45:06 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MnsfP1Wxhz1P79c;
        Thu, 13 Oct 2022 09:40:29 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 09:45:03 +0800
Message-ID: <1d7b081c-9ae1-b5bd-e97e-518147e06099@huawei.com>
Date:   Thu, 13 Oct 2022 09:45:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v4 5/6] selftests/bpf: Fix error failure of case
 test_xdp_adjust_tail_grow
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Xu Kuohai <xukuohai@huaweicloud.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20221011120108.782373-1-xukuohai@huaweicloud.com>
 <20221011120108.782373-6-xukuohai@huaweicloud.com>
 <611e9bed-df6a-0da9-fbf9-4046f4211a7d@linux.dev>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <611e9bed-df6a-0da9-fbf9-4046f4211a7d@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/2022 7:17 AM, Martin KaFai Lau wrote:
> On 10/11/22 5:01 AM, Xu Kuohai wrote:
>> From: Xu Kuohai <xukuohai@huawei.com>
>>
>> test_xdp_adjust_tail_grow failed with ipv6:
>>    test_xdp_adjust_tail_grow:FAIL:ipv6 unexpected error: -28 (errno 28)
>>
>> The reason is that this test case tests ipv4 before ipv6, and when ipv4
>> test finished, topts.data_size_out was set to 54, which is smaller than the
>> ipv6 output data size 114, so ipv6 test fails with NOSPC error.
>>
>> Fix it by reset topts.data_size_out to sizeof(buf) before testing ipv6.
>>
>> Fixes: 04fcb5f9a104 ("selftests/bpf: Migrate from bpf_prog_test_run")
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> ---
>>   tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
>> index 9b9cf8458adf..009ee37607df 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
>> @@ -63,6 +63,7 @@ static void test_xdp_adjust_tail_grow(void)
>>       expect_sz = sizeof(pkt_v6) + 40; /* Test grow with 40 bytes */
>>       topts.data_in = &pkt_v6;
>>       topts.data_size_in = sizeof(pkt_v6);
>> +    topts.data_size_out = sizeof(buf);
> 
> lgtm but how was it working before... weird.
> 

the test case returns before this line is executed, see patch 6

>>       err = bpf_prog_test_run_opts(prog_fd, &topts);
>>       ASSERT_OK(err, "ipv6");
>>       ASSERT_EQ(topts.retval, XDP_TX, "ipv6 retval");
> 
> .

