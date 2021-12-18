Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4994B479A71
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 11:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbhLRK7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 05:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbhLRK7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 05:59:03 -0500
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch [IPv6:2001:1600:3:17::8faf])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4D7C06173E
        for <netdev@vger.kernel.org>; Sat, 18 Dec 2021 02:59:02 -0800 (PST)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4JGNBr62JtzMqHGq;
        Sat, 18 Dec 2021 11:59:00 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4JGNBr2HYYzlj3vs;
        Sat, 18 Dec 2021 11:59:00 +0100 (CET)
Message-ID: <c325e5f6-d8d5-b085-fd2d-7f454629a1ec@digikod.net>
Date:   Sat, 18 Dec 2021 12:01:15 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     yusongping <yusongping@huawei.com>,
        Artem Kuzin <artem.kuzin@huawei.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <20211210072123.386713-1-konstantin.meskhidze@huawei.com>
 <b50ed53a-683e-77cf-9dc2-f4ae1b5fa0fd@digikod.net>
 <12467d8418f04fbf9fd4a456a2a999f1@huawei.com>
 <b535d1d4-3564-b2af-a5e8-3ba6c0fa86c9@digikod.net>
 <c8588051-8795-9b8a-cb36-f5440b590581@digikod.net>
 <a1769c4239ee4e8aadb65f9ebb6061d8@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH 0/2] Landlock network PoC implementation
In-Reply-To: <a1769c4239ee4e8aadb65f9ebb6061d8@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18/12/2021 09:26, Konstantin Meskhidze wrote:
> Hi, Mickaёl
> Thanks again for your opinion about minimal Landlock IPv4 network version.
> I have already started refactoring the code.
> Here are some additional thoughts about the design.

[...]

>>>
>>> Accesses/suffixes should be:
>>> - CREATE
>>> - ACCEPT
>>> - BIND
>>> - LISTEN
>>> - CONNECT
>>> - RECEIVE (RECEIVE_FROM and SEND_TO should not be needed)
>>> - SEND
>>> - SHUTDOWN
>>> - GET_OPTION (GETSOCKOPT)
>>> - SET_OPTION (SETSOCKOPT)
> 
>>> For now, the only access rights should be LANDLOCK_ACCESS_NET_BIND_TCP and LANDLOCK_ACCESS_NET_CONNECT_TCP (tie to two LSM hooks with struct sockaddr).
> 
>>> These attribute and access right changes reduce the scope of the network access control and make it simpler but still really useful. Datagram (e.g. UDP, which could add BIND_UDP and SEND_UDP) sockets will be more
>>> complex to restrict correctly and should then come in another patch series, once TCP is supported.
> 
> I think that having access rights like LANDLOCK_ACCESS_NET_CREATE_TCP_SOCKET_DENY/LANDLOCK_ACCESS_NET_CREATE_UDP_SOCKET_DENY might be useful during initialization phase of container/sandbox, cause a user could have the possibility to restrict the creation of some type of sockets at all, and to reduce the attack surface related to security aspect.
> So the logic could be the following:
> 	1. Process restricts creation UDP sockets, allows TCP one.
> 		- LANDLOCK_ACCESS_NET_CREATE_*_SOCKET_DENY rules are tied to process task_struct cause there are no sockets inodes created at this moment.
> 	2. Creates necessary number of sockets.
> 	3. Restricts sockets' access rights.
> 		- LANDLOCK_ACCESS_NET_BIND_* / LANDLOCK_ACCESS_NET_CONNECT_* access rights are tied to sockets inodes individually.	
> 

Reducing the attack surface on the kernel is valuable but not the 
primary goal of Landlock. seccomp is designed for this task and a 
seccomp filters can easily forbid creation of specific sockets. We 
should consider using both Landlock and seccomp, and your use case of 
denying UDP vs. TCP is good.

Anyway, the LANDLOCK_ACCESS_NET_CREATE_TCP_SOCKET_DENY name in not 
appropriate. Indeed, mixing "access" and "deny" doesn't make sense. A 
LANDLOCK_ACCESS_NET_CREATE_TCP access could be useful if we can define 
such TCP socket semantic, e.g. with a port, which is not possible when 
creating a socket, and it is OK.
