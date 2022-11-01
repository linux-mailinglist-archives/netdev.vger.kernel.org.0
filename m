Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B331B614282
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiKABBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiKABBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:01:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671751570A;
        Mon, 31 Oct 2022 18:01:52 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N1Wth6JBdzHvSj;
        Tue,  1 Nov 2022 09:01:32 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 1 Nov 2022 09:01:50 +0800
Message-ID: <86f9a599-2bcf-d811-8190-35e004f9dcc6@huawei.com>
Date:   Tue, 1 Nov 2022 09:01:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH net v2] bpf, sockmap: fix the sk->sk_forward_alloc warning
 of sk_stream_kill_queues()
To:     Jakub Sitnicki <jakub@cloudflare.com>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <john.fastabend@gmail.com>
References: <1667000674-13237-1-git-send-email-wangyufen@huawei.com>
 <87fsf3q36k.fsf@cloudflare.com> <877d0fpqt4.fsf@cloudflare.com>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <877d0fpqt4.fsf@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
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


在 2022/11/1 6:26, Jakub Sitnicki 写道:
> On Mon, Oct 31, 2022 at 06:56 PM +01, Jakub Sitnicki wrote:
>> On Sat, Oct 29, 2022 at 07:44 AM +08, Wang Yufen wrote:
>>> When running `test_sockmap` selftests, got the following warning:
>>>
>>> WARNING: CPU: 2 PID: 197 at net/core/stream.c:205 sk_stream_kill_queues+0xd3/0xf0
>>> Call Trace:
>>>    <TASK>
>>>    inet_csk_destroy_sock+0x55/0x110
>>>    tcp_rcv_state_process+0xd28/0x1380
>>>    ? tcp_v4_do_rcv+0x77/0x2c0
>>>    tcp_v4_do_rcv+0x77/0x2c0
>>>    __release_sock+0x106/0x130
>>>    __tcp_close+0x1a7/0x4e0
>>>    tcp_close+0x20/0x70
>>>    inet_release+0x3c/0x80
>>>    __sock_release+0x3a/0xb0
>>>    sock_close+0x14/0x20
>>>    __fput+0xa3/0x260
>>>    task_work_run+0x59/0xb0
>>>    exit_to_user_mode_prepare+0x1b3/0x1c0
>>>    syscall_exit_to_user_mode+0x19/0x50
>>>    do_syscall_64+0x48/0x90
>>>    entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>
>>> The root case is: In commit 84472b436e76 ("bpf, sockmap: Fix more
>>> uncharged while msg has more_data") , I used msg->sg.size replace
>>> tosend rudely, which break the
>>>     if (msg->apply_bytes && msg->apply_bytes < send)
>>> scene.

Sorry, I made a mistake here:  send --> tosend

alse will change in v3

>>>
>>> Fixes: 84472b436e76 ("bpf, sockmap: Fix more uncharged while msg has more_data")
>>> Reported-by: Jakub Sitnicki <jakub@cloudflare.com>
>>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>>> Acked-by: John Fastabend <john.fastabend@gmail.com>
>>> ---
>>> v1 -> v2: typo fixup
>>>   net/ipv4/tcp_bpf.c | 8 +++++---
>>>   1 file changed, 5 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
>>> index a1626af..774d481 100644
>>> --- a/net/ipv4/tcp_bpf.c
>>> +++ b/net/ipv4/tcp_bpf.c
>>> @@ -278,7 +278,7 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>>>   {
>>>   	bool cork = false, enospc = sk_msg_full(msg);
>>>   	struct sock *sk_redir;
>>> -	u32 tosend, delta = 0;
>>> +	u32 tosend, orgsize, sent, delta = 0;
>>>   	u32 eval = __SK_NONE;
>>>   	int ret;
>>>   
>>> @@ -333,10 +333,12 @@ static int tcp_bpf_send_verdict(struct sock *sk, struct sk_psock *psock,
>>>   			cork = true;
>>>   			psock->cork = NULL;
>>>   		}
>>> -		sk_msg_return(sk, msg, msg->sg.size);
>>> +		sk_msg_return(sk, msg, tosend);
>>>   		release_sock(sk);
>>>   
>>> +		orgsize = msg->sg.size;
>>>   		ret = tcp_bpf_sendmsg_redir(sk_redir, msg, tosend, flags);
>>> +		sent = orgsize - msg->sg.size;
>> If I'm reading the code right, it's the same as:
>>
>>                  sent = tosend - msg->sg.size;
>>
>> If so, no need for orgsize.
> Sorry, that doesn't make any sense. I misread the code.
>
> The fix is correct.
>
> If I can have a small ask to rename `orgsize` to something more common.
>
> We have `orig_size` or `origsize` in use today, but no `orgsize`:
ok, I will change in v3, thanks.
>
> $ git grep -c '\<orig_size\>' -- net
> net/core/sysctl_net_core.c:3
> net/psample/psample.c:1
> net/tls/tls_device.c:5
> net/tls/tls_sw.c:7
> $ git grep -c '\<origsize\>' -- net
> net/bridge/netfilter/ebtables.c:5
> net/ipv4/netfilter/arp_tables.c:10
> net/ipv4/netfilter/ip_tables.c:10
> net/ipv6/netfilter/ip6_tables.c:10
>
> It reads a bit better, IMHO.
>
> Thanks for fixing it so quickly.
>
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
