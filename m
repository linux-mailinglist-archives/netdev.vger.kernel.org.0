Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AE51DEB5C
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbgEVPBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 11:01:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39613 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730050AbgEVPBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 11:01:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590159689;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+91jG41Ttz/xk83LQb64gFYXYyDxR68BNaCEybObIeM=;
        b=ELiuyt1WH5Vxo29nLwswGmB0GM0Rj9Y2pevmcJiSjV2M+ev9aKm+e0z7yo4+G4Tsx+4+1m
        na62oPlHQX0UJunzaqQh0CqfOViJsxi1dV0AO3gXk93hF/TWqH5LuZSnIoAK8dmoMEXuxG
        +3hxUEyTLG9hD8EYvPpGArUu96FPhl0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-5h2XEasPNpyfM_GNdtOBOg-1; Fri, 22 May 2020 11:01:28 -0400
X-MC-Unique: 5h2XEasPNpyfM_GNdtOBOg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 61CF3107ACF5;
        Fri, 22 May 2020 15:01:26 +0000 (UTC)
Received: from [10.10.117.121] (ovpn-117-121.rdu2.redhat.com [10.10.117.121])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5D3095EE0C;
        Fri, 22 May 2020 15:01:25 +0000 (UTC)
Subject: Re: [PATCH net] tipc: block BH before using dst_cache
To:     Xin Long <lucien.xin@gmail.com>, Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        tipc-discussion@lists.sourceforge.net
References: <20200521182958.163436-1-edumazet@google.com>
 <CADvbK_cdSYZvTj6jFCXHEU0VhD8K7aQ3ky_fvUJ49N-5+ykJkg@mail.gmail.com>
 <CANn89i+x=xbXoKekC6bF_ZMBRMY_mkmuVbNSW3LcRncsiZGd_g@mail.gmail.com>
 <CANn89iJVSb3BWO=VGRX0KkvrxZ7=ZYaK6HwsexK8y+4NJqXopA@mail.gmail.com>
 <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
From:   Jon Maloy <jmaloy@redhat.com>
Message-ID: <76d02a44-91dd-ded6-c3dc-f86685ae1436@redhat.com>
Date:   Fri, 22 May 2020 11:01:24 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_eJx=PyH8MDCWQJMRW-p+nv9QtuQGG2TtYX=9n9oY7rJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/22/20 2:18 AM, Xin Long wrote:
> On Fri, May 22, 2020 at 1:55 PM Eric Dumazet <edumazet@google.com> wrote:
>> Resend to the list in non HTML form
>>
>>
>> On Thu, May 21, 2020 at 10:53 PM Eric Dumazet <edumazet@google.com> wrote:
>>>
>>>
>>> On Thu, May 21, 2020 at 10:50 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>> On Fri, May 22, 2020 at 2:30 AM Eric Dumazet <edumazet@google.com> wrote:
>>>>> dst_cache_get() documents it must be used with BH disabled.
>>>> Interesting, I thought under rcu_read_lock() is enough, which calls
>>>> preempt_disable().
>>>
>>> rcu_read_lock() does not disable BH, never.
>>>
>>> And rcu_read_lock() does not necessarily disable preemption.
> Then I need to think again if it's really worth using dst_cache here.
>
> Also add tipc-discussion and Jon to CC list.
The suggested solution will affect all bearers, not only UDP, so it is 
not a good.
Is there anything preventing us from disabling preemtion inside the 
scope of the rcu lock?

///jon

>
> Thanks.
>
>>>
>>>> have you checked other places where dst_cache_get() are used?
>>>
>>>
>>> Yes, other paths are fine.
>>>
>>>>
>>>>> sysbot reported :
>>>>>
>>>>> BUG: using smp_processor_id() in preemptible [00000000] code: /21697
>>>>> caller is dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
>>>>> CPU: 0 PID: 21697 Comm:  Not tainted 5.7.0-rc6-syzkaller #0
>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>> Call Trace:
>>>>>   __dump_stack lib/dump_stack.c:77 [inline]
>>>>>   dump_stack+0x188/0x20d lib/dump_stack.c:118
>>>>>   check_preemption_disabled lib/smp_processor_id.c:47 [inline]
>>>>>   debug_smp_processor_id.cold+0x88/0x9b lib/smp_processor_id.c:57
>>>>>   dst_cache_get+0x3a/0xb0 net/core/dst_cache.c:68
>>>>>   tipc_udp_xmit.isra.0+0xb9/0xad0 net/tipc/udp_media.c:164
>>>>>   tipc_udp_send_msg+0x3e6/0x490 net/tipc/udp_media.c:244
>>>>>   tipc_bearer_xmit_skb+0x1de/0x3f0 net/tipc/bearer.c:526
>>>>>   tipc_enable_bearer+0xb2f/0xd60 net/tipc/bearer.c:331
>>>>>   __tipc_nl_bearer_enable+0x2bf/0x390 net/tipc/bearer.c:995
>>>>>   tipc_nl_bearer_enable+0x1e/0x30 net/tipc/bearer.c:1003
>>>>>   genl_family_rcv_msg_doit net/netlink/genetlink.c:673 [inline]
>>>>>   genl_family_rcv_msg net/netlink/genetlink.c:718 [inline]
>>>>>   genl_rcv_msg+0x627/0xdf0 net/netlink/genetlink.c:735
>>>>>   netlink_rcv_skb+0x15a/0x410 net/netlink/af_netlink.c:2469
>>>>>   genl_rcv+0x24/0x40 net/netlink/genetlink.c:746
>>>>>   netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>>>>>   netlink_unicast+0x537/0x740 net/netlink/af_netlink.c:1329
>>>>>   netlink_sendmsg+0x882/0xe10 net/netlink/af_netlink.c:1918
>>>>>   sock_sendmsg_nosec net/socket.c:652 [inline]
>>>>>   sock_sendmsg+0xcf/0x120 net/socket.c:672
>>>>>   ____sys_sendmsg+0x6bf/0x7e0 net/socket.c:2362
>>>>>   ___sys_sendmsg+0x100/0x170 net/socket.c:2416
>>>>>   __sys_sendmsg+0xec/0x1b0 net/socket.c:2449
>>>>>   do_syscall_64+0xf6/0x7d0 arch/x86/entry/common.c:295
>>>>>   entry_SYSCALL_64_after_hwframe+0x49/0xb3
>>>>> RIP: 0033:0x45ca29
>>>>>
>>>>> Fixes: e9c1a793210f ("tipc: add dst_cache support for udp media")
>>>>> Cc: Xin Long <lucien.xin@gmail.com>
>>>>> Cc: Jon Maloy <jon.maloy@ericsson.com>
>>>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>>>> Reported-by: syzbot <syzkaller@googlegroups.com>
>>>>> ---
>>>>>   net/tipc/udp_media.c | 6 +++++-
>>>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/net/tipc/udp_media.c b/net/tipc/udp_media.c
>>>>> index d6620ad535461a4d04ed5ba90569ce8b7df9f994..28a283f26a8dff24d613e6ed57e5e69d894dae66 100644
>>>>> --- a/net/tipc/udp_media.c
>>>>> +++ b/net/tipc/udp_media.c
>>>>> @@ -161,9 +161,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
>>>>>                           struct udp_bearer *ub, struct udp_media_addr *src,
>>>>>                           struct udp_media_addr *dst, struct dst_cache *cache)
>>>>>   {
>>>>> -       struct dst_entry *ndst = dst_cache_get(cache);
>>>>> +       struct dst_entry *ndst;
>>>>>          int ttl, err = 0;
>>>>>
>>>>> +       local_bh_disable();
>>>>> +       ndst = dst_cache_get(cache);
>>>>>          if (dst->proto == htons(ETH_P_IP)) {
>>>>>                  struct rtable *rt = (struct rtable *)ndst;
>>>>>
>>>>> @@ -210,9 +212,11 @@ static int tipc_udp_xmit(struct net *net, struct sk_buff *skb,
>>>>>                                             src->port, dst->port, false);
>>>>>   #endif
>>>>>          }
>>>>> +       local_bh_enable();
>>>>>          return err;
>>>>>
>>>>>   tx_error:
>>>>> +       local_bh_enable();
>>>>>          kfree_skb(skb);
>>>>>          return err;
>>>>>   }
>>>>> --
>>>>> 2.27.0.rc0.183.gde8f92d652-goog
>>>>>

