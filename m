Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5A04A5C59
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 13:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238140AbiBAMdt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 07:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237872AbiBAMdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 07:33:47 -0500
Received: from smtp-8fab.mail.infomaniak.ch (smtp-8fab.mail.infomaniak.ch [IPv6:2001:1600:3:17::8fab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8865EC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 04:33:47 -0800 (PST)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Jp49N58W8zMqFsJ;
        Tue,  1 Feb 2022 13:33:44 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Jp49N1htQzlhSM8;
        Tue,  1 Feb 2022 13:33:44 +0100 (CET)
Message-ID: <0d33f7cd-6846-5e7e-62b9-fbd0b28ecea9@digikod.net>
Date:   Tue, 1 Feb 2022 13:33:46 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
 <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
 <0934a27a-d167-87ea-97d2-b3ac952832ff@huawei.com>
 <CA+FuTSc8ZAeaHWVYf-zmn6i5QLJysYGJppAEfb7tRbtho7_DKA@mail.gmail.com>
 <d84ed5b3-837a-811a-6947-e857ceba3f83@huawei.com>
 <CA+FuTSeVhLdeXokyG4x__HGJyNOwsSicLOb4NKJA-gNp59S5uA@mail.gmail.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
In-Reply-To: <CA+FuTSeVhLdeXokyG4x__HGJyNOwsSicLOb4NKJA-gNp59S5uA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 31/01/2022 18:14, Willem de Bruijn wrote:
> On Fri, Jan 28, 2022 at 10:12 PM Konstantin Meskhidze
> <konstantin.meskhidze@huawei.com> wrote:
>>
>>
>>
>> 1/26/2022 5:15 PM, Willem de Bruijn пишет:
>>> On Wed, Jan 26, 2022 at 3:06 AM Konstantin Meskhidze
>>> <konstantin.meskhidze@huawei.com> wrote:
>>>>
>>>>
>>>>
>>>> 1/25/2022 5:17 PM, Willem de Bruijn пишет:
>>>>> On Mon, Jan 24, 2022 at 3:02 AM Konstantin Meskhidze
>>>>> <konstantin.meskhidze@huawei.com> wrote:
>>>>>>
>>>>>> Support of socket_bind() and socket_connect() hooks.
>>>>>> Current prototype can restrict binding and connecting of TCP
>>>>>> types of sockets. Its just basic idea how Landlock could support
>>>>>> network confinement.
>>>>>>
>>>>>> Changes:
>>>>>> 1. Access masks array refactored into 1D one and changed
>>>>>> to 32 bits. Filesystem masks occupy 16 lower bits and network
>>>>>> masks reside in 16 upper bits.
>>>>>> 2. Refactor API functions in ruleset.c:
>>>>>>        1. Add void *object argument.
>>>>>>        2. Add u16 rule_type argument.
>>>>>> 3. Use two rb_trees in ruleset structure:
>>>>>>        1. root_inode - for filesystem objects
>>>>>>        2. root_net_port - for network port objects
>>>>>>
>>>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>>>
>>>>>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
>>>>>> +{
>>>>>> +       short socket_type;
>>>>>> +       struct sockaddr_in *sockaddr;
>>>>>> +       u16 port;
>>>>>> +       const struct landlock_ruleset *const dom = landlock_get_current_domain();
>>>>>> +
>>>>>> +       /* Check if the hook is AF_INET* socket's action */
>>>>>> +       if ((address->sa_family != AF_INET) && (address->sa_family != AF_INET6))
>>>>>> +               return 0;
>>>>>
>>>>> Should this be a check on the socket family (sock->ops->family)
>>>>> instead of the address family?
>>>>
>>>> Actually connect() function checks address family:
>>>>
>>>> int __inet_stream_connect(... ,struct sockaddr *uaddr ,...) {
>>>> ...
>>>>           if (uaddr) {
>>>>                   if (addr_len < sizeof(uaddr->sa_family))
>>>>                   return -EINVAL;
>>>>
>>>>                   if (uaddr->sa_family == AF_UNSPEC) {
>>>>                           err = sk->sk_prot->disconnect(sk, flags);
>>>>                           sock->state = err ? SS_DISCONNECTING :
>>>>                           SS_UNCONNECTED;
>>>>                   goto out;
>>>>                   }
>>>>           }
>>>>
>>>> ...
>>>> }
>>>
>>> Right. My question is: is the intent of this feature to be limited to
>>> sockets of type AF_INET(6) or to addresses?
>>>
>>> I would think the first. Then you also want to catch operations on
>>> such sockets that may pass a different address family. AF_UNSPEC is
>>> the known offender that will effect a state change on AF_INET(6)
>>> sockets.
>>
>>    The intent is to restrict INET sockets to bind/connect to some ports.
>>    You can apply some number of Landlock rules with port defenition:
>>          1. Rule 1 allows to connect to sockets with port X.
>>          2. Rule 2 forbids to connect to socket with port Y.
>>          3. Rule 3 forbids to bind a socket to address with port Z.
>>
>>          and so on...
>>>
>>>>>
>>>>> It is valid to pass an address with AF_UNSPEC to a PF_INET(6) socket.
>>>>> And there are legitimate reasons to want to deny this. Such as passing
>>>>> a connection to a unprivileged process and disallow it from disconnect
>>>>> and opening a different new connection.
>>>>
>>>> As far as I know using AF_UNSPEC to unconnect takes effect on
>>>> UDP(DATAGRAM) sockets.
>>>> To unconnect a UDP socket, we call connect but set the family member of
>>>> the socket address structure (sin_family for IPv4 or sin6_family for
>>>> IPv6) to AF_UNSPEC. It is the process of calling connect on an already
>>>> connected UDP socket that causes the socket to become unconnected.
>>>>
>>>> This RFC patch just supports TCP connections. I need to check the logic
>>>> if AF_UNSPEC provided in connenct() function for TCP(STREAM) sockets.
>>>> Does it disconnect already established TCP connection?
>>>>
>>>> Thank you for noticing about this issue. Need to think through how
>>>> to manage it with Landlock network restrictions for both TCP and UDP
>>>> sockets.
>>>
>>> AF_UNSPEC also disconnects TCP.
>>
>> So its possible to call connect() with AF_UNSPEC and make a socket
>> unconnected. If you want to establish another connection to a socket
>> with port Y, and if there is a landlock rule has applied to a process
>> (or container) which restricts to connect to a socket with port Y, it
>> will be banned.
>> Thats the basic logic.
> 
> Understood, and that works fine for connect. It would be good to also
> ensure that a now-bound socket cannot call listen. Possibly for
> follow-on work.

Are you thinking about a new access right for listen? What would be the 
use case vs. the bind access right?
