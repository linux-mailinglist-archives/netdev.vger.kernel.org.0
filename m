Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D434C84A8
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbiCAHGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:06:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiCAHGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:06:30 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C4A69CC1;
        Mon, 28 Feb 2022 23:05:49 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4K77Sh6dnWz1GByg;
        Tue,  1 Mar 2022 15:01:08 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Mar 2022 15:05:46 +0800
Subject: Re: [PATCH bpf-next 2/4] bpf, sockmap: Fix memleak in tcp_bpf_sendmsg
 while sk msg is full
To:     John Fastabend <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>
CC:     <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-3-wangyufen@huawei.com>
 <621d9aed541f_8c47920864@john.notmuch>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <5eb1bdf2-8f2c-2599-9961-2aace2e8baa6@huawei.com>
Date:   Tue, 1 Mar 2022 15:05:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <621d9aed541f_8c47920864@john.notmuch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/3/1 12:02, John Fastabend 写道:
> Wang Yufen wrote:
>> If tcp_bpf_sendmsg() is running while sk msg is full, sk_msg_alloc()
>> returns -ENOSPC, tcp_bpf_sendmsg() goto wait for memory. If partial memory
>> has been alloced by sk_msg_alloc(), that is, msg_tx->sg.size is greater
>> than osize after sk_msg_alloc(), memleak occurs. To fix we use
>> sk_msg_trim() to release the allocated memory, then goto wait for memory.
> Small nit, "sk_msg_alloc() returns -ENOSPC" should be something like, "when
> sk_msg_alloc() returns -ENOMEM error,..." That error path is from ENOMEM not
> the ENOSPC.
Thanks, I will fix in v2.
>
> But nice find thanks! I think we might have seen this in a couple cases on
> our side as well.
>
>> This issue can cause the following info:
>> WARNING: CPU: 3 PID: 7950 at net/core/stream.c:208 sk_stream_kill_queues+0xd4/0x1a0
>> Call Trace:
>>   <TASK>
>>   inet_csk_destroy_sock+0x55/0x110
>>   __tcp_close+0x279/0x470
>>   tcp_close+0x1f/0x60
>>   inet_release+0x3f/0x80
>>   __sock_release+0x3d/0xb0
>>   sock_close+0x11/0x20
>>   __fput+0x92/0x250
>>   task_work_run+0x6a/0xa0
>>   do_exit+0x33b/0xb60
>>   do_group_exit+0x2f/0xa0
>>   get_signal+0xb6/0x950
>>   arch_do_signal_or_restart+0xac/0x2a0
>>   exit_to_user_mode_prepare+0xa9/0x200
>>   syscall_exit_to_user_mode+0x12/0x30
>>   do_syscall_64+0x46/0x80
>>   entry_SYSCALL_64_after_hwframe+0x44/0xae
>>   </TASK>
>>
>> WARNING: CPU: 3 PID: 2094 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
>> Call Trace:
>>   <TASK>
>>   __sk_destruct+0x24/0x1f0
>>   sk_psock_destroy+0x19b/0x1c0
>>   process_one_work+0x1b3/0x3c0
>>   kthread+0xe6/0x110
>>   ret_from_fork+0x22/0x30
>>   </TASK>
>>
>> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   net/ipv4/tcp_bpf.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>> index 9b9b02052fd3..ac9f491cc139 100644
>> --- a/net/ipv4/tcp_bpf.c
>> +++ b/net/ipv4/tcp_bpf.c
>> @@ -421,8 +421,10 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
>>   		osize = msg_tx->sg.size;
>>   		err = sk_msg_alloc(sk, msg_tx, msg_tx->sg.size + copy, msg_tx->sg.end - 1);
>>   		if (err) {
>> -			if (err != -ENOSPC)
>> +			if (err != -ENOSPC) {
>> +				sk_msg_trim(sk, msg_tx, osize);
>>   				goto wait_for_memory;
>> +			}
>>   			enospc = true;
>>   			copy = msg_tx->sg.size - osize;
>>   		}
>> -- 
>> 2.25.1
>>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> .
