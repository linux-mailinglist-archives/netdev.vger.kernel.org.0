Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28BC54787DB
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 10:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233400AbhLQJhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 04:37:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233195AbhLQJhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 04:37:13 -0500
Received: from smtp-190f.mail.infomaniak.ch (smtp-190f.mail.infomaniak.ch [IPv6:2001:1600:3:17::190f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209D7C06173E
        for <netdev@vger.kernel.org>; Fri, 17 Dec 2021 01:37:13 -0800 (PST)
Received: from smtp-3-0000.mail.infomaniak.ch (unknown [10.4.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JFkQs0fsQzMqGbj;
        Fri, 17 Dec 2021 10:37:09 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4JFkQr41vPzlj4cc;
        Fri, 17 Dec 2021 10:37:08 +0100 (CET)
Message-ID: <c8588051-8795-9b8a-cb36-f5440b590581@digikod.net>
Date:   Fri, 17 Dec 2021 10:39:23 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     yusongping <yusongping@huawei.com>,
        Artem Kuzin <artem.kuzin@huawei.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        netfilter@vger.kernel.org
References: <20211210072123.386713-1-konstantin.meskhidze@huawei.com>
 <b50ed53a-683e-77cf-9dc2-f4ae1b5fa0fd@digikod.net>
 <12467d8418f04fbf9fd4a456a2a999f1@huawei.com>
 <b535d1d4-3564-b2af-a5e8-3ba6c0fa86c9@digikod.net>
Subject: Re: [RFC PATCH 0/2] Landlock network PoC implementation
In-Reply-To: <b535d1d4-3564-b2af-a5e8-3ba6c0fa86c9@digikod.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New discussions and RFCs should also include netdev and netfilter 
mailing lists. For people new to Landlock, the goal is to enable 
unprivileged processes (and then potentially malicious ones) to limit 
their own network access (i.e. create a security sandbox for themselves).

Thinking more about network access control for Landlock use case, here 
are better suggestions:

On 14/12/2021 12:51, Mickaël Salaün wrote:
> 
> On 14/12/2021 04:49, Konstantin Meskhidze wrote:
>> Hi Mickaёl.
>> I've been thinking about your reply:
>>
>>> 4. Kernel objects.
>>> For filesystem restrictions inodes objects are used to tie landlock 
>>> rules.
>>> But for socket operations it's preferred to use task_struct object of
>>> a process, cause sockets' inodes are created just after
>>> security_socket_create() hook is called, and if its needed to have
>>> some restriction rule for creating sockets, this rule can't be tied
>>> to a socket inode cause there is no any has been created at the hook's
>>> catching moment, see the sock_create_lite() function below:
>>
>> - For the file system, we use inodes to identify hierarchies. We can't
>> - safely rely on stateless objects (e.g. path strings) because the file
>> - system changes, and then the rules must change with it.
>>
>> - To identify network objects (from the user point of view), we can rely
>> - on stateless rule definitions because they may be absolute (i.e. IP
>> - address), e.g. sandbox process creating a new connection or 
>> receveing an
>> - UDP packet. It is not be the case with UNIX socket if they are come 
>> from
>> - a path (i.e. inode) though. In this case we'll have to use the existing
>> - file system identification mechanism and probably extend the current FS
>> - access rights.
>> - A sandbox is a set of processes handled as "subjects". Generic inet
>> - rules should not be tied to processes (for now) but on 
>> subnets/protocols.
>>
>> In current Landlock version inodes are the objects to tie rules to.
>> For network you are saying that we can rely on stateless rule 
>> definitions and
>> rules should be tied to subnets/protocols, not to processes' 
>> task_struct objects.
>> Cause Landlock architecture requires all rules to be tied to a different
>> kernel objects, and when LSM hooks are caught there must be search
>> procedure completed in a ruleset's red-black tree structure:
>>     kernel_object -> landlock_object <- landlock_rule 
>> <-----landlock_ruleset
>>
>> What kind of kernel objects do you mean by subnets/protocols?
>> Do you suggest using sockets' inodes in this case or using network rules
>> without to be tied to any kernel object?
> 
> The subnets/protocols is the definition provided when creating a rule 
> (i.e. the object from the user point of view), but the kernel may relies 
> on other internal representations. I guess datagram packets would need 
> to be matched against IP/port everytime they are received by a sandboxed 
> process, but tagging sockets or their underlying inodes for stream 
> connections make sense.
> 
> I don't have experience in the network LSM hooks though, any input is 
> welcome.
> 
>>     socket_inode -> landlock_object <- landlock_rule 
>> <-----landlock_ruleset
>>              OR
>>     landlock_object <- landlock_rule <-----landlock_ruleset
>>
>> -----Original Message-----
>> From: Mickaël Salaün <mic@digikod.net>
>> Sent: Monday, December 13, 2021 4:30 PM
>> To: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
>> Cc: linux-security-module@vger.kernel.org; yusongping 
>> <yusongping@huawei.com>; Artem Kuzin <artem.kuzin@huawei.com>
>> Subject: Re: [RFC PATCH 0/2] Landlock network PoC implementation
>>
>> Hi Konstantin,
>>
>> On 10/12/2021 08:21, Konstantin Meskhidze wrote:

[...]

>>
>> To sum up, for IPv4 restrictions, we need a new rule type identified
>> with LANDLOCK_RULE_NET_CIDR4. This will handle a new
>> struct landlock_net_cidr4_attr {
>>       __u64 allowed_access;
>>       __u32 address; // IPv4
>>       __u8 prefix; // From 0 to 32
>>       __u8 type; // SOCK_DGRAM, SOCK_STREAM
>>       __u16 port;
>> } __attribute__((packed));
>> // https://datatracker.ietf.org/doc/html/rfc4632

IP addresses (and subnets) should not be part of a rule, at least for 
now. Indeed, IP addresses are tied either to the system architecture 
(e.g. container configuration), the local network or Internet, hence 
moving targets not controlled by application developers. Moreover, from 
a kernel point of view, it is more complex to check and handle subnets, 
which are most of the time tied to the Netfilter infrastructure, not 
suitable for Landlock because of its unprivileged nature.

On the other side, protocols such as TCP and their associated ports are 
normalized and are tied to an application semantic (e.g. TCP/443 for HTTPS).

There is other advantages to exclude subnets from this type of rules for 
now (e.g. they could be composed with protocols/ports), but that may 
come later.

I then think that a first MVP to bring network access control support to 
Landlock should focus only on TCP and related ports (i.e. services). I 
propose to not use my previous definition of landlock_net_cidr4_attr but 
to have a landlock_net_service_attr instead:

struct landlock_net_service_attr {
     __u64 allowed_access; // LANDLOCK_NET_*_TCP
     __u16 port;
} __attribute__((packed));

This attribute should handle IPv4 and IPv6 indistinguishably.

[...]

>>
>> Accesses/suffixes should be:
>> - CREATE
>> - ACCEPT
>> - BIND
>> - LISTEN
>> - CONNECT
>> - RECEIVE (RECEIVE_FROM and SEND_TO should not be needed)
>> - SEND
>> - SHUTDOWN
>> - GET_OPTION (GETSOCKOPT)
>> - SET_OPTION (SETSOCKOPT)

For now, the only access rights should be LANDLOCK_ACCESS_NET_BIND_TCP 
and LANDLOCK_ACCESS_NET_CONNECT_TCP (tie to two LSM hooks with struct 
sockaddr).

These attribute and access right changes reduce the scope of the network 
access control and make it simpler but still really useful. Datagram 
(e.g. UDP, which could add BIND_UDP and SEND_UDP) sockets will be more 
complex to restrict correctly and should then come in another patch 
series, once TCP is supported.
