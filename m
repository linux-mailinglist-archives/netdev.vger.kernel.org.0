Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702706451D8
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 03:16:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiLGCQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 21:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLGCQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 21:16:22 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4477153EF2;
        Tue,  6 Dec 2022 18:16:21 -0800 (PST)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NRglY5JQyzqSwf;
        Wed,  7 Dec 2022 10:12:09 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 7 Dec 2022 10:16:18 +0800
Message-ID: <cb69ed14-6d14-f5c9-21c5-0b725256a5bf@huawei.com>
Date:   Wed, 7 Dec 2022 10:16:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH bpf-next] bpf, test_run: fix alignment problem in
 bpf_test_init()
To:     John Fastabend <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <andrii@kernel.org>, <davem@davemloft.net>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <martin.lau@linux.dev>, <song@kernel.org>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <sdf@google.com>, <haoluo@google.com>,
        <jolsa@kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20221129042644.231816-1-shaozhengchao@huawei.com>
 <638f9efdab7bb_8a9120824@john.notmuch>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <638f9efdab7bb_8a9120824@john.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/12/7 3:58, John Fastabend wrote:
> Zhengchao Shao wrote:
>> The problem reported by syz is as follows:
>> BUG: KASAN: slab-out-of-bounds in __build_skb_around+0x230/0x330
>> Write of size 32 at addr ffff88807ec6b2c0 by task bpf_repo/6711
>> Call Trace:
>> <TASK>
>> dump_stack_lvl+0x8e/0xd1
>> print_report+0x155/0x454
>> kasan_report+0xba/0x1f0
>> kasan_check_range+0x35/0x1b0
>> memset+0x20/0x40
>> __build_skb_around+0x230/0x330
>> build_skb+0x4c/0x260
>> bpf_prog_test_run_skb+0x2fc/0x1ce0
>> __sys_bpf+0x1798/0x4b60
>> __x64_sys_bpf+0x75/0xb0
>> do_syscall_64+0x35/0x80
>> entry_SYSCALL_64_after_hwframe+0x46/0xb0
>> </TASK>
>>
>> Allocated by task 6711:
>> kasan_save_stack+0x1e/0x40
>> kasan_set_track+0x21/0x30
>> __kasan_kmalloc+0xa1/0xb0
>> __kmalloc+0x4e/0xb0
>> bpf_test_init.isra.0+0x77/0x100
>> bpf_prog_test_run_skb+0x219/0x1ce0
>> __sys_bpf+0x1798/0x4b60
>> __x64_sys_bpf+0x75/0xb0
>> do_syscall_64+0x35/0x80
>> entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>> The process is as follows:
>> bpf_prog_test_run_skb()
>> 	bpf_test_init()
>> 		data = kzalloc()	//The length of input is 576.
>> 					//The actual allocated memory
>> 					//size is 1024.
>> 	build_skb()
>> 		__build_skb_around()
>> 			size = ksize(data)//size = 1024
>> 			size -= SKB_DATA_ALIGN(
>> 					sizeof(struct skb_shared_info));
>> 					//size = 704
>> 			skb_set_end_offset(skb, size);
>> 			shinfo = skb_shinfo(skb);//shinfo = data + 704
>> 			memset(shinfo...)	//Write out of bounds
>>
>> In bpf_test_init(), the accessible space allocated to data is 576 bytes,
>> and the memory allocated to data is 1024 bytes. In __build_skb_around(),
>> shinfo indicates the offset of 704 bytes of data, which triggers the issue
>> of writing out of bounds.
>>
>> Fixes: 1cf1cae963c2 ("bpf: introduce BPF_PROG_TEST_RUN command")
>> Reported-by: syzbot+fda18eaa8c12534ccb3b@syzkaller.appspotmail.com
>> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
>> ---
>>   net/bpf/test_run.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
>> index fcb3e6c5e03c..fbd5337b8f68 100644
>> --- a/net/bpf/test_run.c
>> +++ b/net/bpf/test_run.c
>> @@ -766,6 +766,8 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
>>   			   u32 size, u32 headroom, u32 tailroom)
>>   {
>>   	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
>> +	unsigned int true_size;
>> +	void *true_data;
>>   	void *data;
>>   
>>   	if (size < ETH_HLEN || size > PAGE_SIZE - headroom - tailroom)
>> @@ -779,6 +781,14 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
>>   	if (!data)
>>   		return ERR_PTR(-ENOMEM);
>>   
>> +	true_size = ksize(data);
>> +	if (size + headroom + tailroom < true_size) {
>> +		true_data = krealloc(data, true_size, GFP_USER | __GFP_ZERO);
> 
> This comes from a kzalloc, should we zero realloc'd memory as well?
> 
>> +			if (!true_data)
>> +				return ERR_PTR(-ENOMEM);
> 
> I think its worth fixing the extra tab here.
> 

Hi John:
	Thank you for your review. Your suggestion looks good to me. And I 
found Kees Cook also focus on this issue.
https://patchwork.kernel.org/project/netdevbpf/patch/20221206231659.never.929-kees@kernel.org/
Perhaps his solution will be more common?

Zhengchao Shao
>> +		data = true_data;
>> +	}
>> +
>>   	if (copy_from_user(data + headroom, data_in, user_size)) {
>>   		kfree(data);
>>   		return ERR_PTR(-EFAULT);
>> -- 
>> 2.17.1
>>
