Return-Path: <netdev+bounces-2677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26F0A7030AA
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 16:55:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B23D72812AB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:55:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C963BD2E6;
	Mon, 15 May 2023 14:55:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5959C2FD
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 14:55:55 +0000 (UTC)
Received: from mail-m127104.qiye.163.com (mail-m127104.qiye.163.com [115.236.127.104])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6419B171F;
	Mon, 15 May 2023 07:55:49 -0700 (PDT)
Received: from [IPV6:240e:3b7:3270:1980:1173:5169:256c:13b8] (unknown [IPV6:240e:3b7:3270:1980:1173:5169:256c:13b8])
	by mail-m127104.qiye.163.com (Hmail) with ESMTPA id 015F4A4025D;
	Mon, 15 May 2023 22:55:39 +0800 (CST)
Message-ID: <0c007040-be5b-a372-6fb6-8ce1b601d74b@sangfor.com.cn>
Date: Mon, 15 May 2023 22:55:11 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Jeff Layton <jlayton@kernel.org>,
 Trond Myklebust <trond.myklebust@hammerspace.com>,
 Anna Schumaker <anna@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>,
 Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20230515021307.3072-1-dinghui@sangfor.com.cn>
 <65AFD2EF-E5D3-4461-B23A-D294486D5F65@oracle.com>
From: Ding Hui <dinghui@sangfor.com.cn>
In-Reply-To: <65AFD2EF-E5D3-4461-B23A-D294486D5F65@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDGksaVksfQkpKQkoZQhpIS1UTARMWGhIXJBQOD1
	lXWRgSC1lBWUlPSx5BSBlMQUhJTEtBSkJDS0FKSkxIQU5KTUJBSU5NGEFKSBlDWVdZFhoPEhUdFF
	lBWU9LSFVKSktISkxVSktLVUtZBg++
X-HM-Tid: 0a881fe8f37db282kuuu015f4a4025d
X-HM-MType: 1
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NjY6FBw*SD0KPx8jFE0UVjBN
	GT5PCRRVSlVKTUNPSk1JTk9LQkhPVTMWGhIXVR8SFRwTDhI7CBoVHB0UCVUYFBZVGBVFWVdZEgtZ
	QVlJT0seQUgZTEFISUxLQUpCQ0tBSkpMSEFOSk1CQUlOTRhBSkgZQ1lXWQgBWUFKS0pOTDcG
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/5/15 20:01, Chuck Lever III wrote:
> 
> 
>> On May 14, 2023, at 10:13 PM, Ding Hui <dinghui@sangfor.com.cn> wrote:
>>
>> After the listener svc_sock be freed, and before invoking svc_tcp_accept()
>> for the established child sock, there is a window that the newsock
>> retaining a freed listener svc_sock in sk_user_data which cloning from
>> parent.
> 
> Thank you, I will apply this (after testing it).
> 
> The next step is to figure out why SUNRPC is trying to accept
> on a dead listener. Any thoughts about that?
> 

A child sock is cloned from the listener sock, it inherits sk_data_ready
and sk_user_data from its parent sock, which is svc_tcp_listen_data_ready()
and listener svc_sock, the sk_state of the child becomes ESTABLISHED once
after TCP handshake in protocol stack.

Case 1:

listener sock      | child sock            |   nfsd thread
=>sk_data_ready    | =>sk_data_ready       |
-------------------+-----------------------+----------------------
svc_tcp_listen_data_ready
   svsk is listener svc_sock
   set_bit(XPT_CONN)
                                              svc_recv
                                                svc_tcp_accept(listener)
                                                  kernel_accept get child sock as newsock
                                                  svc_setup_socket(newsock)
                                                    newsock->sk_data_ready=svc_data_ready
                                                    newsock->sk_user_data=newsvsk
                     svc_data_ready
                       svsk is newsvsk


Case 2:

listener sock      | child sock            |   nfsd thread
=>sk_data_ready    | =>sk_data_ready       |
-------------------+-----------------------+----------------------
svc_tcp_listen_data_ready
   svsk is listener svc_sock
   set_bit(XPT_CONN)
                     svc_tcp_listen_data_ready
                       svsk is listener svc_sock
                                              svc_recv
                                                svc_tcp_accept(listener)
                                                  kernel_accept get the child sock as newsock
                                                  svc_setup_socket(newsock)
                                                    newsock->sk_data_ready=svc_data_ready
                                                    newsock->sk_user_data=newsvsk
                     svc_data_ready
                       svsk is newsvsk


The UAF case:

listener sock      | child sock            |   rpc.nfsd 0
=>sk_data_ready    | =>sk_data_ready       |
-------------------+-----------------------+----------------------
svc_tcp_listen_data_ready
   svsk is listener svc_sock
   set_bit(XPT_CONN)
                                             svc_xprt_destroy_all
                                               svc_xprt_free
                                                 kfree listener svc_sock
                                             // the child sock has not yet been accepted,
                                             // so it is not managed by SUNRPC for now.
                     svc_tcp_listen_data_ready
                       svsk is listener svc_sock
                       svsk->sk_odata // UAF!

> 
>> In the race windows if data is received on the newsock, we will
>> observe use-after-free report in svc_tcp_listen_data_ready().
>>
>> Reproduce by two tasks:
>>
>> 1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
>> 2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done
> 
> I will continue attempting to reproduce, as I would like a
> root cause for this issue.
> 
> 
>> KASAN report:
>>
>>   ==================================================================
>>   BUG: KASAN: slab-use-after-free in svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
>>   Read of size 8 at addr ffff888139d96228 by task nc/102553
>>   CPU: 7 PID: 102553 Comm: nc Not tainted 6.3.0+ #18
>>   Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
>>   Call Trace:
>>    <IRQ>
>>    dump_stack_lvl+0x33/0x50
>>    print_address_description.constprop.0+0x27/0x310
>>    print_report+0x3e/0x70
>>    kasan_report+0xae/0xe0
>>    svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
>>    tcp_data_queue+0x9f4/0x20e0
>>    tcp_rcv_established+0x666/0x1f60
>>    tcp_v4_do_rcv+0x51c/0x850
>>    tcp_v4_rcv+0x23fc/0x2e80
>>    ip_protocol_deliver_rcu+0x62/0x300
>>    ip_local_deliver_finish+0x267/0x350
>>    ip_local_deliver+0x18b/0x2d0
>>    ip_rcv+0x2fb/0x370
>>    __netif_receive_skb_one_core+0x166/0x1b0
>>    process_backlog+0x24c/0x5e0
>>    __napi_poll+0xa2/0x500
>>    net_rx_action+0x854/0xc90
>>    __do_softirq+0x1bb/0x5de
>>    do_softirq+0xcb/0x100
>>    </IRQ>
>>    <TASK>
>>    ...
>>    </TASK>
>>
>>   Allocated by task 102371:
>>    kasan_save_stack+0x1e/0x40
>>    kasan_set_track+0x21/0x30
>>    __kasan_kmalloc+0x7b/0x90
>>    svc_setup_socket+0x52/0x4f0 [sunrpc]
>>    svc_addsock+0x20d/0x400 [sunrpc]
>>    __write_ports_addfd+0x209/0x390 [nfsd]
>>    write_ports+0x239/0x2c0 [nfsd]
>>    nfsctl_transaction_write+0xac/0x110 [nfsd]
>>    vfs_write+0x1c3/0xae0
>>    ksys_write+0xed/0x1c0
>>    do_syscall_64+0x38/0x90
>>    entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>
>>   Freed by task 102551:
>>    kasan_save_stack+0x1e/0x40
>>    kasan_set_track+0x21/0x30
>>    kasan_save_free_info+0x2a/0x50
>>    __kasan_slab_free+0x106/0x190
>>    __kmem_cache_free+0x133/0x270
>>    svc_xprt_free+0x1e2/0x350 [sunrpc]
>>    svc_xprt_destroy_all+0x25a/0x440 [sunrpc]
>>    nfsd_put+0x125/0x240 [nfsd]
>>    nfsd_svc+0x2cb/0x3c0 [nfsd]
>>    write_threads+0x1ac/0x2a0 [nfsd]
>>    nfsctl_transaction_write+0xac/0x110 [nfsd]
>>    vfs_write+0x1c3/0xae0
>>    ksys_write+0xed/0x1c0
>>    do_syscall_64+0x38/0x90
>>    entry_SYSCALL_64_after_hwframe+0x72/0xdc
>>
>> Fix the UAF by simply doing nothing in svc_tcp_listen_data_ready()
>> if state != TCP_LISTEN, that will avoid dereferencing svsk for all
>> child socket.
>>
>> Link: https://lore.kernel.org/lkml/20230507091131.23540-1-dinghui@sangfor.com.cn/
>> Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead of open coding")
>> Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
>> Cc: <stable@vger.kernel.org>
>> ---
>> net/sunrpc/svcsock.c | 23 +++++++++++------------
>> 1 file changed, 11 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
>> index a51c9b989d58..9aca6e1e78e4 100644
>> --- a/net/sunrpc/svcsock.c
>> +++ b/net/sunrpc/svcsock.c
>> @@ -825,12 +825,6 @@ static void svc_tcp_listen_data_ready(struct sock *sk)
>>
>> trace_sk_data_ready(sk);
>>
>> - if (svsk) {
>> - /* Refer to svc_setup_socket() for details. */
>> - rmb();
>> - svsk->sk_odata(sk);
>> - }
>> -
>> /*
>> * This callback may called twice when a new connection
>> * is established as a child socket inherits everything
>> @@ -839,13 +833,18 @@ static void svc_tcp_listen_data_ready(struct sock *sk)
>> *    when one of child sockets become ESTABLISHED.
>> * 2) data_ready method of the child socket may be called
>> *    when it receives data before the socket is accepted.
>> - * In case of 2, we should ignore it silently.
>> + * In case of 2, we should ignore it silently and DO NOT
>> + * dereference svsk.
>> */
>> - if (sk->sk_state == TCP_LISTEN) {
>> - if (svsk) {
>> - set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
>> - svc_xprt_enqueue(&svsk->sk_xprt);
>> - }
>> + if (sk->sk_state != TCP_LISTEN)
>> + return;
>> +
>> + if (svsk) {
>> + /* Refer to svc_setup_socket() for details. */
>> + rmb();
>> + svsk->sk_odata(sk);
>> + set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
>> + svc_xprt_enqueue(&svsk->sk_xprt);
>> }
>> }
>>
>> -- 
>> 2.17.1
>>
> 
> --
> Chuck Lever
> 
> 
> 

-- 
Thanks,
-dinghui


