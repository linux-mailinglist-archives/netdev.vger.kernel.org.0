Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F98249C4DD
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 09:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238130AbiAZIGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 03:06:12 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4516 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiAZIGL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 03:06:11 -0500
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JkGRP68zHz67wqg;
        Wed, 26 Jan 2022 16:02:41 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Wed, 26 Jan 2022 09:06:08 +0100
Message-ID: <0934a27a-d167-87ea-97d2-b3ac952832ff@huawei.com>
Date:   Wed, 26 Jan 2022 11:05:53 +0300
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
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <CA+FuTSf4EjgjBCCOiu-PHJcTMia41UkTh8QJ0+qdxL_J8445EA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml753-chm.china.huawei.com (10.201.108.203) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



1/25/2022 5:17 PM, Willem de Bruijn пишет:
> On Mon, Jan 24, 2022 at 3:02 AM Konstantin Meskhidze
> <konstantin.meskhidze@huawei.com> wrote:
>>
>> Support of socket_bind() and socket_connect() hooks.
>> Current prototype can restrict binding and connecting of TCP
>> types of sockets. Its just basic idea how Landlock could support
>> network confinement.
>>
>> Changes:
>> 1. Access masks array refactored into 1D one and changed
>> to 32 bits. Filesystem masks occupy 16 lower bits and network
>> masks reside in 16 upper bits.
>> 2. Refactor API functions in ruleset.c:
>>      1. Add void *object argument.
>>      2. Add u16 rule_type argument.
>> 3. Use two rb_trees in ruleset structure:
>>      1. root_inode - for filesystem objects
>>      2. root_net_port - for network port objects
>>
>> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> 
>> +static int hook_socket_connect(struct socket *sock, struct sockaddr *address, int addrlen)
>> +{
>> +       short socket_type;
>> +       struct sockaddr_in *sockaddr;
>> +       u16 port;
>> +       const struct landlock_ruleset *const dom = landlock_get_current_domain();
>> +
>> +       /* Check if the hook is AF_INET* socket's action */
>> +       if ((address->sa_family != AF_INET) && (address->sa_family != AF_INET6))
>> +               return 0;
> 
> Should this be a check on the socket family (sock->ops->family)
> instead of the address family?

Actually connect() function checks address family:

int __inet_stream_connect(... ,struct sockaddr *uaddr ,...) {
...
	if (uaddr) {
		if (addr_len < sizeof(uaddr->sa_family))
		return -EINVAL;

		if (uaddr->sa_family == AF_UNSPEC) {
			err = sk->sk_prot->disconnect(sk, flags);
			sock->state = err ? SS_DISCONNECTING : 	
			SS_UNCONNECTED;
		goto out;
		}
	}

...
}

> 
> It is valid to pass an address with AF_UNSPEC to a PF_INET(6) socket.
> And there are legitimate reasons to want to deny this. Such as passing
> a connection to a unprivileged process and disallow it from disconnect
> and opening a different new connection.

As far as I know using AF_UNSPEC to unconnect takes effect on 
UDP(DATAGRAM) sockets.
To unconnect a UDP socket, we call connect but set the family member of 
the socket address structure (sin_family for IPv4 or sin6_family for 
IPv6) to AF_UNSPEC. It is the process of calling connect on an already 
connected UDP socket that causes the socket to become unconnected.

This RFC patch just supports TCP connections. I need to check the logic
if AF_UNSPEC provided in connenct() function for TCP(STREAM) sockets.
Does it disconnect already established TCP connection?

Thank you for noticing about this issue. Need to think through how
to manage it with Landlock network restrictions for both TCP and UDP
sockets.

> 
>> +
>> +       socket_type = sock->type;
>> +       /* Check if it's a TCP socket */
>> +       if (socket_type != SOCK_STREAM)
>> +               return 0;
>> +
>> +       if (!dom)
>> +               return 0;
>> +
>> +       /* Get port value in host byte order */
>> +       sockaddr = (struct sockaddr_in *)address;
>> +       port = ntohs(sockaddr->sin_port);
>> +
>> +       return check_socket_access(dom, port, LANDLOCK_ACCESS_NET_CONNECT_TCP);
>> +}
> .
