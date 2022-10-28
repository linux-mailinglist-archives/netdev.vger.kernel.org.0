Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A566C611E20
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 01:26:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiJ1X0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 19:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiJ1X0b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 19:26:31 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97525247E1B;
        Fri, 28 Oct 2022 16:26:20 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MzdpV4BrBz15MDq;
        Sat, 29 Oct 2022 07:21:22 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 29 Oct 2022 07:26:18 +0800
Message-ID: <de4bd247-2a99-2534-1cfa-1fc37ef19043@huawei.com>
Date:   Sat, 29 Oct 2022 07:26:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net] bpf, sockmap: fix the sk->sk_forward_alloc warning of
 sk_stream_kill_queues()
To:     John Fastabend <john.fastabend@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>
CC:     <jakub@cloudflare.com>
References: <1666941754-10216-1-git-send-email-wangyufen@huawei.com>
 <635c550a430c6_256e2089c@john.notmuch>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <635c550a430c6_256e2089c@john.notmuch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2022/10/29 6:17, John Fastabend 写道:
> Wang Yufen wrote:
>> When running `test_sockmap` selftests, got the following warning:
>>
>> WARNING: CPU: 2 PID: 197 at net/core/stream.c:205 sk_stream_kill_queues+0xd3/0xf0
>> Call Trace:
>>    <TASK>
>>    inet_csk_destroy_sock+0x55/0x110
>>    tcp_rcv_state_process+0xd28/0x1380
>>    ? tcp_v4_do_rcv+0x77/0x2c0
>>    tcp_v4_do_rcv+0x77/0x2c0
>>    __release_sock+0x106/0x130
>>    __tcp_close+0x1a7/0x4e0
>>    tcp_close+0x20/0x70
>>    inet_release+0x3c/0x80
>>    __sock_release+0x3a/0xb0
>>    sock_close+0x14/0x20
>>    __fput+0xa3/0x260
>>    task_work_run+0x59/0xb0
>>    exit_to_user_mode_prepare+0x1b3/0x1c0
>>    syscall_exit_to_user_mode+0x19/0x50
>>    do_syscall_64+0x48/0x90
>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>
>> The root case is: In commit 84472b436e76 ("bpf, sockmap: Fix more
>> uncharged while msg has more_data") , I used msg->sg.size replace
>> tosend rudely, which break the
>>     if (msg->apply_bytes && msg->apply_bytes < send)
>> scene.
> Ah nice catch. Feel free to add my ACK on a v2 with small typo fixup.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
>
>> Fixes: 84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has more_data")
>> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>>   net/ipv4/tcp_bpf.c | 10 ++++++----
>>   1 file changed, 6 insertions(+), 4 deletions(-)
>>
>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>> index a1626af..38d4735 100644
>> --- a/net/ipv4/tcp_bpf.c
>> +++ b/net/ipv4/tcp_bpf.c
>> @@ -278,7 +278,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>>   {
>>   	bool cork = false, enospc = sk_msg_full(msg);
>>   	struct sock *sk_redir;
>> -	u32 tosend, delta = 0;
>> +	u32 tosend, orgsize, sended, delta = 0;
>>   	u32 eval = __SK_NONE;
>>   	int ret;
>>   
>> @@ -333,10 +333,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>>   			cork = true;
>>   			psock->cork = NULL;
>>   		}
>> -		sk_msg_return(sk, msg, msg->sg.size);
>> +		sk_msg_return(sk, msg, tosend);
>>   		release_sock(sk);
>>   
>> +		orgsize = msg->sg.size;
>>   		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
>> +		sended = orgsize - msg->sg.size;
> Small english nitpick. Past tense of send is sent so could we make this,
>
>                  sent = orgsize - msg->sg.size;

I got it. Thanks.

>
>>   
>>   		if (eval == __SK_REDIRECT)
>>   			sock_put(sk_redir);
>> @@ -374,8 +376,8 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>>   		if (msg &&
>>   		    msg->sg.data[msg->sg.start].page_link &&
>>   		    msg->sg.data[msg->sg.start].length) {
>> -			if (eval == __SK_REDIRECT)
>> -				sk_mem_charge(sk, msg->sg.size);
>> +			if (eval == __SK_REDIRECT && tosend > sended)
> Other nit, you could probably omit the 'tosend > sended' check here. Because
> otherwise tosend == sended and the mem_charge of zer is a nop. But OTOH
> its probably ok to keep the check to avoid some extra work.
>
>> +				sk_mem_charge(sk, tosend - sended);
>>   			goto more_data;
>>   		}
>>   	}
>> -- 
>> 1.8.3.1
