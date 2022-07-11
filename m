Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175B9570513
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 16:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbiGKOHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 10:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbiGKOHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 10:07:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 90E8219C18
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 07:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657548436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K3bRd2dpFtpuMGYuYjoPUXKp0GUe3T2Nj8Fu1hH4wAk=;
        b=dY6cG2Ebnb6tZMvlt+nmGY903m5CjS0fDRyYuBZjvi/xGGQ/l3Ox1lL4U2vO9O45FUzcoq
        pfU2Bm+86ZQeRBZ6Mq6AL+6VH4hrxAmEkru1lXfaEvEWuNBsjfPDMg6PDv8j/oXpIdLuRN
        T06phLgbdD76rKbE/Xm8kiLtgC/B82w=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-617-6gJdb1lPNuqchjN0KIouJQ-1; Mon, 11 Jul 2022 10:07:13 -0400
X-MC-Unique: 6gJdb1lPNuqchjN0KIouJQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D69222813D26;
        Mon, 11 Jul 2022 14:07:12 +0000 (UTC)
Received: from [172.16.176.1] (unknown [10.22.48.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 99EFD492C3B;
        Mon, 11 Jul 2022 14:07:10 +0000 (UTC)
From:   "Benjamin Coddington" <bcodding@redhat.com>
To:     "Trond Myklebust" <trondmy@hammerspace.com>,
        "Eric Dumazet" <edumazet@google.com>
Cc:     edumazet@google.com, smayhew@redhat.com, davem@davemloft.net,
        chuck.lever@oracle.com, sfrench@samba.org, tj@kernel.org,
        anna@kernel.org, kuba@kernel.org, jlayton@kernel.org,
        gnault@redhat.com, josef@toxicpanda.com, netdev@vger.kernel.org,
        pabeni@redhat.com
Subject: Re: [RFC net] Should sk_page_frag() also look at the current GFP
 context?
Date:   Mon, 11 Jul 2022 10:07:09 -0400
Message-ID: <9ADC95E9-7756-4706-8B45-E1BB65020216@redhat.com>
In-Reply-To: <e8de4a15c934658b06ee1de10fd21975b972f902.camel@hammerspace.com>
References: <b4d8cb09c913d3e34f853736f3f5628abfd7f4b6.1656699567.git.gnault@redhat.com>
 <CANn89i+=GyHjkrHMZAftB-toEhi9GcAQom1_bpT+S0qMvCz0DQ@mail.gmail.com>
 <429C561E-2F85-4DB5-993C-B2DD4E575BF0@redhat.com>
 <e8de4a15c934658b06ee1de10fd21975b972f902.camel@hammerspace.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 Jul 2022, at 16:04, Trond Myklebust wrote:

> On Fri, 2022-07-08 at 14:10 -0400, Benjamin Coddington wrote:
>> On 7 Jul 2022, at 12:29, Eric Dumazet wrote:
>>
>>> On Fri, Jul 1, 2022 at 8:41 PM Guillaume Nault <gnault@redhat.com>
>>> wrote:
>>>>
>>>> I'm investigating a kernel oops that looks similar to
>>>> 20eb4f29b602 ("net: fix sk_page_frag() recursion from memory
>>>> reclaim")
>>>> and dacb5d8875cc ("tcp: fix page frag corruption on page fault").
>>>>
>>>> This time the problem happens on an NFS client, while the
>>>> previous
>>>> bzs
>>>> respectively used NBD and CIFS. While NBD and CIFS clear __GFP_FS
>>>> in
>>>> their socket's ->sk_allocation field (using GFP_NOIO or
>>>> GFP_NOFS),
>>>> NFS
>>>> leaves sk_allocation to its default value since commit
>>>> a1231fda7e94
>>>> ("SUNRPC: Set memalloc_nofs_save() on all rpciod/xprtiod jobs").
>>>>
>>>> To recap the original problems, in commit 20eb4f29b602 and
>>>> dacb5d8875cc,
>>>> memory reclaim happened while executing tcp_sendmsg_locked(). The
>>>> code
>>>> path entered tcp_sendmsg_locked() recursively as pages to be
>>>> reclaimed
>>>> were backed by files on the network. The problem was that both
>>>> the
>>>> outer and the inner tcp_sendmsg_locked() calls used
>>>> current->task_frag,
>>>> thus leaving it in an inconsistent state. The fix was to use the
>>>> socket's ->sk_frag instead for the file system socket, so that
>>>> the
>>>> inner and outer calls wouln't step on each other's toes.
>>>>
>>>> But now that NFS doesn't modify ->sk_allocation anymore,
>>>> sk_page_frag()
>>>> sees sunrpc sockets as plain TCP ones and returns ->task_frag in
>>>> the
>>>> inner tcp_sendmsg_locked() call.
>>>>
>>>> Also it looks like the trend is to avoid GFS_NOFS and GFP_NOIO
>>>> and
>>>> use
>>>> memalloc_no{fs,io}_save() instead. So maybe other network file
>>>> systems
>>>> will also stop setting ->sk_allocation in the future and we
>>>> should
>>>> teach sk_page_frag() to look at the current GFP flags. Or should
>>>> we
>>>> stick to ->sk_allocation and make NFS drop __GFP_FS again?
>>>>
>>>> Signed-off-by: Guillaume Nault <gnault@redhat.com>
>>>
>>> Can you provide a Fixes: tag ?
>>>
>>>> ---
>>>>  include/net/sock.h | 8 ++++++--
>>>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>>> index 72ca97ccb460..b934c9851058 100644
>>>> --- a/include/net/sock.h
>>>> +++ b/include/net/sock.h
>>>> @@ -46,6 +46,7 @@
>>>>  #include <linux/netdevice.h>
>>>>  #include <linux/skbuff.h>      /* struct sk_buff */
>>>>  #include <linux/mm.h>
>>>> +#include <linux/sched/mm.h>
>>>>  #include <linux/security.h>
>>>>  #include <linux/slab.h>
>>>>  #include <linux/uaccess.h>
>>>> @@ -2503,14 +2504,17 @@ static inline void
>>>> sk_stream_moderate_sndbuf(struct sock *sk)
>>>>   * socket operations and end up recursing into sk_page_frag()
>>>>   * while it's already in use: explicitly avoid task page_frag
>>>>   * usage if the caller is potentially doing any of them.
>>>> - * This assumes that page fault handlers use the GFP_NOFS flags.
>>>> + * This assumes that page fault handlers use the GFP_NOFS flags
>>>> + * or run under memalloc_nofs_save() protection.
>>>>   *
>>>>   * Return: a per task page_frag if context allows that,
>>>>   * otherwise a per socket one.
>>>>   */
>>>>  static inline struct page_frag *sk_page_frag(struct sock *sk)
>>>>  {
>>>> -       if ((sk->sk_allocation & (__GFP_DIRECT_RECLAIM |
>>>> __GFP_MEMALLOC | __GFP_FS)) ==
>>>> +       gfp_t gfp_mask = current_gfp_context(sk->sk_allocation);
>>>
>>> This is slowing down TCP sendmsg() fast path, reading current-
>>>> flags,
>>> possibly cold value.
>>
>> True - current->flags is pretty distant from current->task_frag.
>>
>>> I would suggest using one bit in sk, close to sk->sk_allocation to
>>> make the decision,
>>> instead of testing sk->sk_allocation for various flags.
>>>
>>> Not sure if we have available holes.
>>
>> Its looking pretty packed on my build.. the nearest hole is 5
>> cachelines
>> away.
>>
>> It'd be nice to allow network filesystem to use task_frag when
>> possible.
>>
>> If we expect sk_page_frag() to only return task_frag once per call
>> stack,
>> then can we simply check it's already in use, perhaps by looking at
>> the
>> size field?
>>
>> Or maybe can we set sk_allocation early from current_gfp_context()
>> outside
>> the fast path?
>
> Why not just add a bit to sk->sk_allocation itself, and have
> __sock_create() default to setting it when the 'kern' parameter is non-
> zero? NFS is not alone in following the request of the mm team to
> deprecate use of GFP_NOFS and GFP_NOIO.

Can we overload sk_allocation safely?  There's 28 GFP flags already, I'm
worried about unintended consequences if sk_allocation gets passed on.

What about a flag in sk_gso_type?  Looks like there's 13 free there, and its
in the same cacheline as sk_allocation and sk_frag.

Ben

