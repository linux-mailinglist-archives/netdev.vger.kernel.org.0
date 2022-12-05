Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD696427B7
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:42:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbiLELm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231230AbiLELmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:42:15 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA811A040
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:41:37 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id d14so10410952edj.11
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 03:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=ciDqOz7QBEaYSG+9kgUvBDfSsFw75go5Ww9A2XztpY8=;
        b=Jf1TBvWXq99vnq1/v/ne5piywMGh3O8AyELpmWRr0tKnhCOqlmgDd0MfI9dJVXAsAW
         IEQVUUvfiJO5LaDlPw05cKS0cf2fH2CKU7xHfFxOuoHP4QdYMY8hOIAuSYSwGRR5lsjn
         YUojtZ854TamRTBZTxKxe1k8w8fekn0pzeEQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ciDqOz7QBEaYSG+9kgUvBDfSsFw75go5Ww9A2XztpY8=;
        b=ZBykH8FUjCaK6RlN+WClrDzfVm2z6e/Od3xyjE7H4U8ogio/aHlvHXfrMzjkFjiHQu
         EBvooL3Mn3lY5v8UZeQ7cZEtvNTF0dA5eY5ZlwxggiBSyPRWGPlh4uGIuUzJvQdxwB0F
         KPB820V1SkQlD86Ya7se+D1Ci/1M4Y6pyupj23JTyloEMXPVSiCogn0/cZTS/Znd6nvg
         jSovH0qlJTvxiRzGX6C8diGT9jx1rnH2ymXAxIkrk6qRfYXzIPuQQWa21yp/dSIhd7Ac
         DI3UDEFPTWO+2IWigBNFNrLk3pRBK0IxGe9E+X9czUdNst32h6BHszuGthzkecP4X6zF
         zBhg==
X-Gm-Message-State: ANoB5pnPnEwA2bKGWn0TE7ijxDKhhwksu6JbieEKXFFQrvgQouhiMmAf
        ciB7/cUGLTU4QTXGxpvZ6zHcVQ==
X-Google-Smtp-Source: AA0mqf7fgwtAttImu1KTp9pGRK2DnYDeHQepa9kpk/isMqEDgWRPPufyiUxxdoBsUm3MEzgVIRPT5Q==
X-Received: by 2002:a05:6402:1107:b0:463:9b53:cbf6 with SMTP id u7-20020a056402110700b004639b53cbf6mr66351851edv.173.1670240495532;
        Mon, 05 Dec 2022 03:41:35 -0800 (PST)
Received: from cloudflare.com (79.184.124.239.ipv4.supernova.orange.pl. [79.184.124.239])
        by smtp.gmail.com with ESMTPSA id fe17-20020a1709072a5100b007be301a1d51sm6103669ejc.211.2022.12.05.03.41.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 03:41:35 -0800 (PST)
References: <20221114191619.124659-1-jakub@cloudflare.com>
 <Y4nKX8IXjHLSVHnz@Laptop-X1>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Tom Parkin <tparkin@katalix.com>,
        Haowei Yan <g1042620637@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with
 sk_callback_lock
Date:   Mon, 05 Dec 2022 11:24:39 +0100
In-reply-to: <Y4nKX8IXjHLSVHnz@Laptop-X1>
Message-ID: <87y1rmhyc2.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 05:50 PM +08, Hangbin Liu wrote:
> On Mon, Nov 14, 2022 at 08:16:19PM +0100, Jakub Sitnicki wrote:
>> sk->sk_user_data has multiple users, which are not compatible with each
>> other. Writers must synchronize by grabbing the sk->sk_callback_lock.
>> 
>> l2tp currently fails to grab the lock when modifying the underlying tunnel
>> socket fields. Fix it by adding appropriate locking.
>> 
>> We err on the side of safety and grab the sk_callback_lock also inside the
>> sk_destruct callback overridden by l2tp, even though there should be no
>> refs allowing access to the sock at the time when sk_destruct gets called.
>> 
>> v4:
>> - serialize write to sk_user_data in l2tp sk_destruct
>> 
>> v3:
>> - switch from sock lock to sk_callback_lock
>> - document write-protection for sk_user_data
>> 
>> v2:
>> - update Fixes to point to origin of the bug
>> - use real names in Reported/Tested-by tags
>> 
>> Cc: Tom Parkin <tparkin@katalix.com>
>> Fixes: 3557baabf280 ("[L2TP]: PPP over L2TP driver core")
>> Reported-by: Haowei Yan <g1042620637@gmail.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>> 
>> This took me forever. Sorry about that.
>> 
>>  include/net/sock.h   |  2 +-
>>  net/l2tp/l2tp_core.c | 19 +++++++++++++------
>>  2 files changed, 14 insertions(+), 7 deletions(-)
>> 
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 5db02546941c..e0517ecc6531 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -323,7 +323,7 @@ struct sk_filter;
>>    *	@sk_tskey: counter to disambiguate concurrent tstamp requests
>>    *	@sk_zckey: counter to order MSG_ZEROCOPY notifications
>>    *	@sk_socket: Identd and reporting IO signals
>> -  *	@sk_user_data: RPC layer private data
>> +  *	@sk_user_data: RPC layer private data. Write-protected by @sk_callback_lock.
>>    *	@sk_frag: cached page frag
>>    *	@sk_peek_off: current peek_offset value
>>    *	@sk_send_head: front of stuff to transmit
>> diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
>> index 7499c51b1850..754fdda8a5f5 100644
>> --- a/net/l2tp/l2tp_core.c
>> +++ b/net/l2tp/l2tp_core.c
>> @@ -1150,8 +1150,10 @@ static void l2tp_tunnel_destruct(struct sock *sk)
>>  	}
>>  
>>  	/* Remove hooks into tunnel socket */
>> +	write_lock_bh(&sk->sk_callback_lock);
>>  	sk->sk_destruct = tunnel->old_sk_destruct;
>>  	sk->sk_user_data = NULL;
>> +	write_unlock_bh(&sk->sk_callback_lock);
>>  
>>  	/* Call the original destructor */
>>  	if (sk->sk_destruct)
>
> Hi Jakub,
>
> I have a similar issue with vxlan driver. Similar with commit
> ad6c9986bcb6 ("vxlan: Fix GRO cells race condition between receive and link
> delete"). There is still a race condition on vxlan that when receive a packet
> while deleting a VXLAN device. In vxlan_ecn_decapsulate(), the
> vxlan_get_sk_family() call panic as sk is NULL.
>
>  #0 [ffffa25ec6978a38] machine_kexec at ffffffff8c669757
>  #1 [ffffa25ec6978a90] __crash_kexec at ffffffff8c7c0a4d
>  #2 [ffffa25ec6978b58] crash_kexec at ffffffff8c7c1c48
>  #3 [ffffa25ec6978b60] oops_end at ffffffff8c627f2b
>  #4 [ffffa25ec6978b80] page_fault_oops at ffffffff8c678fcb
>  #5 [ffffa25ec6978bd8] exc_page_fault at ffffffff8d109542
>  #6 [ffffa25ec6978c00] asm_exc_page_fault at ffffffff8d200b62
>     [exception RIP: vxlan_ecn_decapsulate+0x3b]
>     RIP: ffffffffc1014e7b  RSP: ffffa25ec6978cb0  RFLAGS: 00010246
>     RAX: 0000000000000008  RBX: ffff8aa000888000  RCX: 0000000000000000
>     RDX: 000000000000000e  RSI: ffff8a9fc7ab803e  RDI: ffff8a9fd1168700
>     RBP: ffff8a9fc7ab803e   R8: 0000000000700000   R9: 00000000000010ae
>     R10: ffff8a9fcb748980  R11: 0000000000000000  R12: ffff8a9fd1168700
>     R13: ffff8aa000888000  R14: 00000000002a0000  R15: 00000000000010ae
>     ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
>  #7 [ffffa25ec6978ce8] vxlan_rcv at ffffffffc10189cd [vxlan]
>  #8 [ffffa25ec6978d90] udp_queue_rcv_one_skb at ffffffff8cfb6507
>  #9 [ffffa25ec6978dc0] udp_unicast_rcv_skb at ffffffff8cfb6e45
> #10 [ffffa25ec6978dc8] __udp4_lib_rcv at ffffffff8cfb8807
> #11 [ffffa25ec6978e20] ip_protocol_deliver_rcu at ffffffff8cf76951
> #12 [ffffa25ec6978e48] ip_local_deliver at ffffffff8cf76bde
> #13 [ffffa25ec6978ea0] __netif_receive_skb_one_core at ffffffff8cecde9b
> #14 [ffffa25ec6978ec8] process_backlog at ffffffff8cece139
> #15 [ffffa25ec6978f00] __napi_poll at ffffffff8ceced1a
> #16 [ffffa25ec6978f28] net_rx_action at ffffffff8cecf1f3
> #17 [ffffa25ec6978fa0] __softirqentry_text_start at ffffffff8d4000ca
> #18 [ffffa25ec6978ff0] do_softirq at ffffffff8c6fbdc3
> --- <IRQ stack> ---
>
>> struct socket ffff8a9fd1168700
> struct socket {
>   state = SS_FREE,
>   type = 0,
>   flags = 0,
>   file = 0xffff8a9fcb748000,
>   sk = 0x0,
>   ops = 0x0,
>
> So I'm wondering if we should also have locks in udp_tunnel_sock_release().
> Or should we add a checking in sk state before calling vxlan_get_sk_family()?

This is how like to think about it:

To know when it is safe to load vs->sock->sk->sk_family, we have to ask:

1. What ensures that the objects remain alive/valid in our scope?
2. What protects the objects from being mutated?

In case of vxlan_sock object in the context of vxlan_ecn_decapsulate():

1. We are in an RCU read side section (ip_local_deliver_finish).
2. RCU-protected objects are not to be mutated while readers exist.

The classic "What is RCU, Fundamentally?" article explains it much
better than I ever could:

https://lwn.net/Articles/262464/

As to where the problem lies. I belive udp_tunnel_sock_release() is not
keeping the (2) promise.

After unpublishing the sk_user_data, we should wait for any existing
readers accessing the vxlan_sock to finish with synchronize_rcu(),
before releaseing the socket.

That is:

--- a/net/ipv4/udp_tunnel_core.c
+++ b/net/ipv4/udp_tunnel_core.c
@@ -176,6 +176,7 @@ EXPORT_SYMBOL_GPL(udp_tunnel_xmit_skb);
 void udp_tunnel_sock_release(struct socket *sock)
 {
        rcu_assign_sk_user_data(sock->sk, NULL);
+       synchronize_rcu();
        kernel_sock_shutdown(sock, SHUT_RDWR);
        sock_release(sock);
 }


Otherwise accessing vxlan_sock state doesn't look safe to me.
