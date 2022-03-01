Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1298F4C84E1
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 08:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232834AbiCAHYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 02:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiCAHYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 02:24:51 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADC3E3BA52;
        Mon, 28 Feb 2022 23:24:08 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K77xk24mLzdfd2;
        Tue,  1 Mar 2022 15:22:50 +0800 (CST)
Received: from [10.174.177.215] (10.174.177.215) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Mar 2022 15:24:05 +0800
Subject: Re: [PATCH bpf-next 4/4] bpf, sockmap: Fix double uncharge the mem of
 sk_msg
To:     John Fastabend <john.fastabend@gmail.com>, <daniel@iogearbox.net>,
        <jakub@cloudflare.com>, <lmb@cloudflare.com>,
        <davem@davemloft.net>, <bpf@vger.kernel.org>
CC:     <edumazet@google.com>, <yoshfuji@linux-ipv6.org>,
        <dsahern@kernel.org>, <kuba@kernel.org>, <ast@kernel.org>,
        <andrii@kernel.org>, <kafai@fb.com>, <songliubraving@fb.com>,
        <yhs@fb.com>, <kpsingh@kernel.org>, <netdev@vger.kernel.org>
References: <20220225014929.942444-1-wangyufen@huawei.com>
 <20220225014929.942444-5-wangyufen@huawei.com>
 <621d9d067de02_8c479208b9@john.notmuch>
From:   wangyufen <wangyufen@huawei.com>
Message-ID: <01e30509-406f-2c78-59a7-663f4ccccd04@huawei.com>
Date:   Tue, 1 Mar 2022 15:24:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <621d9d067de02_8c479208b9@john.notmuch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.215]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
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


在 2022/3/1 12:11, John Fastabend 写道:
> Wang Yufen wrote:
>> If tcp_bpf_sendmsg is running during a tear down operation, psock may be
>> freed.
>>
>> tcp_bpf_sendmsg()
>>   tcp_bpf_send_verdict()
>>    sk_msg_return()
>>    tcp_bpf_sendmsg_redir()
>>     unlikely(!psock))
>>     sk_msg_free()
>>
>> The mem of msg has been uncharged in tcp_bpf_send_verdict() by
>> sk_msg_return(), so we need to use sk_msg_free_nocharge while psock
>> is null.
>>
>> This issue can cause the following info:
>> WARNING: CPU: 0 PID: 2136 at net/ipv4/af_inet.c:155 inet_sock_destruct+0x13c/0x260
>> Call Trace:
>>   <TASK>
>>   __sk_destruct+0x24/0x1f0
>>   sk_psock_destroy+0x19b/0x1c0
>>   process_one_work+0x1b3/0x3c0
>>   worker_thread+0x30/0x350
>>   ? process_one_work+0x3c0/0x3c0
>>   kthread+0xe6/0x110
>>   ? kthread_complete_and_exit+0x20/0x20
>>   ret_from_fork+0x22/0x30
>>   </TASK>
>>
>> Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   net/ipv4/tcp_bpf.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>> index 1f0364e06619..03c037d2a055 100644
>> --- a/net/ipv4/tcp_bpf.c
>> +++ b/net/ipv4/tcp_bpf.c
>> @@ -139,7 +139,7 @@ int tcp_bpf_sendmsg_redir(struct sock *sk, struct sk_msg *msg,
>>   	int ret;
>>   
>>   	if (unlikely(!psock)) {
>> -		sk_msg_free(sk, msg);
>> +		sk_msg_free_nocharge(sk, msg);
>>   		return 0;
>>   	}
>>   	ret = ingress ? bpf_tcp_ingress(sk, psock, msg, bytes, flags) :
> Did you consider simply returning an error code here? This would then
> trigger the sk_msg_free_nocharge in the error path of __SK_REDIRECT
> and would have the side effect of throwing an error up to user space.
> This would be a slight change in behavior from user side but would
> look the same as an error if the redirect on the socket threw an
> error so I think it would be OK.

Yes, I think it would be better to return -EPIPE,  will do in v2.

Thanks.

>
> Thanks,
> John
> .
