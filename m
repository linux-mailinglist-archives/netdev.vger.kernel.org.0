Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BFE4A2B60
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 04:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352270AbiA2DMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 22:12:25 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4558 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240864AbiA2DMY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 22:12:24 -0500
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JlzrV1LHzz67MLx;
        Sat, 29 Jan 2022 11:11:54 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Sat, 29 Jan 2022 04:12:20 +0100
Message-ID: <d84ed5b3-837a-811a-6947-e857ceba3f83@huawei.com>
Date:   Sat, 29 Jan 2022 06:12:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 1/2] landlock: TCP network hooks implementation
Content-Language: ru
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     <mic@digikod.net>, <linux-security-module@vger.kernel.org>,
        <netdev@vger.kernel.org>, <netfilter@vger.kernel.org>,
        <yusongping@huawei.com>, <artem.kuzin@huawei.com>
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <20220124080215.265538-2-konstantin.meskhidze@huawei.com>
 <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
 <0934a27a-d167-87ea-97d2-b3ac952832ff@huawei.com>
 <CA+FuTSc8ZAeaHWVYf-zmn6i5QLJysYGJppAEfb7tRbtho7_DKA@mail.gmail.com>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <CA+FuTSc8ZAeaHWVYf-zmn6i5QLJysYGJppAEfb7tRbtho7_DKA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



1/26/2022 5:15 PM, Willem de Bruijn пишет:
> On Wed, Jan 26, 2022 at 3:06 AM Konstantin Meskhidze
> <konstantin.meskhidze@huawei.com> wrote:
>>
>>
>>
>> 1/25/2022 5:17 PM, Willem de Bruijn пишет:
>>> On Mon, Jan 24, 2022 at 3:02 AM Konstantin Meskhidze
>>> <konstantin.meskhidze@huawei.com> wrote:
>>>>
>>>> Support of socket_bind() and socket_connect() hooks.
>>>> Current prototype can restrict binding and connecting of TCP
>>>> types of sockets. Its just basic idea how Landlock could support
>>>> network confinement.
>>>>
>>>> Changes:
>>>> 1. Access masks array refactored into 1D one and changed
>>>> to 32 bits. Filesystem masks occupy 16 lower bits and network
>>>> masks reside in 16 upper bits.
>>>> 2. Refactor API functions in ruleset.c:
>>>>       1. Add void *object argument.
>>>>       2. Add u16 rule_type argument.
>>>> 3. Use two rb_trees in ruleset structure:
>>>>       1. root_inode - for filesystem objects
>>>>       2. root_net_port - for network port objects
>>>>
>>>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>>>
>>>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
>>>> +{
>>>> +       short socket_type;
>>>> +       struct sockaddr_in *sockaddr;
>>>> +       u16 port;
>>>> +       const struct landlock_ruleset *const dom = landlock_get_current_domain();
>>>> +
>>>> +       /* Check if the hook is AF_INET* socket's action */
>>>> +       if ((address->sa_family != AF_INET) && (address->sa_family != AF_INET6))
>>>> +               return 0;
>>>
>>> Should this be a check on the socket family (sock->ops->family)
>>> instead of the address family?
>>
>> Actually connect() function checks address family:
>>
>> int __inet_stream_connect(... ,struct sockaddr *uaddr ,...) {
>> ...
>>          if (uaddr) {
>>                  if (addr_len < sizeof(uaddr->sa_family))
>>                  return -EINVAL;
>>
>>                  if (uaddr->sa_family == AF_UNSPEC) {
>>                          err = sk->sk_prot->disconnect(sk, flags);
>>                          sock->state = err ? SS_DISCONNECTING :
>>                          SS_UNCONNECTED;
>>                  goto out;
>>                  }
>>          }
>>
>> ...
>> }
> 
> Right. My question is: is the intent of this feature to be limited to
> sockets of type AF_INET(6) or to addresses?
> 
> I would think the first. Then you also want to catch operations on
> such sockets that may pass a different address family. AF_UNSPEC is
> the known offender that will effect a state change on AF_INET(6)
> sockets.

  The intent is to restrict INET sockets to bind/connect to some ports.
  You can apply some number of Landlock rules with port defenition:
  	1. Rule 1 allows to connect to sockets with port X.
  	2. Rule 2 forbids to connect to socket with port Y.
	3. Rule 3 forbids to bind a socket to address with port Z.

	and so on...
> 
>>>
>>> It is valid to pass an address with AF_UNSPEC to a PF_INET(6) socket.
>>> And there are legitimate reasons to want to deny this. Such as passing
>>> a connection to a unprivileged process and disallow it from disconnect
>>> and opening a different new connection.
>>
>> As far as I know using AF_UNSPEC to unconnect takes effect on
>> UDP(DATAGRAM) sockets.
>> To unconnect a UDP socket, we call connect but set the family member of
>> the socket address structure (sin_family for IPv4 or sin6_family for
>> IPv6) to AF_UNSPEC. It is the process of calling connect on an already
>> connected UDP socket that causes the socket to become unconnected.
>>
>> This RFC patch just supports TCP connections. I need to check the logic
>> if AF_UNSPEC provided in connenct() function for TCP(STREAM) sockets.
>> Does it disconnect already established TCP connection?
>>
>> Thank you for noticing about this issue. Need to think through how
>> to manage it with Landlock network restrictions for both TCP and UDP
>> sockets.
> 
> AF_UNSPEC also disconnects TCP.

So its possible to call connect() with AF_UNSPEC and make a socket 
unconnected. If you want to establish another connection to a socket 
with port Y, and if there is a landlock rule has applied to a process 
(or container) which restricts to connect to a socket with port Y, it 
will be banned.
Thats the basic logic.
> 
>>>
>>>> +
>>>> +       socket_type = sock->type;
>>>> +       /* Check if it's a TCP socket */
>>>> +       if (socket_type != SOCK_STREAM)
>>>> +               return 0;
>>>> +
>>>> +       if (!dom)
>>>> +               return 0;
>>>> +
>>>> +       /* Get port value in host byte order */
>>>> +       sockaddr = (struct sockaddr_in *)address;
>>>> +       port = ntohs(sockaddr->sin_port);
>>>> +
>>>> +       return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_CONNECT_TCP);
>>>> +}
>>> .
> .
