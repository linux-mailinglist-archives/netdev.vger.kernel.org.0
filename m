Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91CBA1E1897
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbgEZAyh convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 May 2020 20:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388083AbgEZAyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 20:54:37 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E83C061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 17:54:37 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFD6B12796438;
        Mon, 25 May 2020 17:54:36 -0700 (PDT)
Date:   Mon, 25 May 2020 17:54:35 -0700 (PDT)
Message-Id: <20200525.175435.627428313116549298.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, maze@google.com,
        willemb@google.com
Subject: Re: [PATCH net-next] tcp: allow traceroute -Mtcp for unpriv users
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200524180002.148619-1-edumazet@google.com>
References: <20200524180002.148619-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 17:54:37 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Sun, 24 May 2020 11:00:02 -0700

> Unpriv users can use traceroute over plain UDP sockets, but not TCP ones.
> 
> $ traceroute -Mtcp 8.8.8.8
> You do not have enough privileges to use this traceroute method.
> 
> $ traceroute -n -Mudp 8.8.8.8
> traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
>  1  192.168.86.1  3.631 ms  3.512 ms  3.405 ms
>  2  10.1.10.1  4.183 ms  4.125 ms  4.072 ms
>  3  96.120.88.125  20.621 ms  19.462 ms  20.553 ms
>  4  96.110.177.65  24.271 ms  25.351 ms  25.250 ms
>  5  69.139.199.197  44.492 ms  43.075 ms  44.346 ms
>  6  68.86.143.93  27.969 ms  25.184 ms  25.092 ms
>  7  96.112.146.18  25.323 ms 96.112.146.22  25.583 ms 96.112.146.26  24.502 ms
>  8  72.14.239.204  24.405 ms 74.125.37.224  16.326 ms  17.194 ms
>  9  209.85.251.9  18.154 ms 209.85.247.55  14.449 ms 209.85.251.9  26.296 ms^C
> 
> We can easily support traceroute over TCP, by queueing an error message
> into socket error queue.
> 
> Note that applications need to set IP_RECVERR/IPV6_RECVERR option to
> enable this feature, and that the error message is only queued
> while in SYN_SNT state.
> 
> socket(AF_INET6, SOCK_STREAM, IPPROTO_IP) = 3
> setsockopt(3, SOL_IPV6, IPV6_RECVERR, [1], 4) = 0
> setsockopt(3, SOL_SOCKET, SO_TIMESTAMP_OLD, [1], 4) = 0
> setsockopt(3, SOL_IPV6, IPV6_UNICAST_HOPS, [5], 4) = 0
> connect(3, {sa_family=AF_INET6, sin6_port=htons(8787), sin6_flowinfo=htonl(0),
>         inet_pton(AF_INET6, "2002:a05:6608:297::", &sin6_addr), sin6_scope_id=0}, 28) = -1 EHOSTUNREACH (No route to host)
> recvmsg(3, {msg_name={sa_family=AF_INET6, sin6_port=htons(8787), sin6_flowinfo=htonl(0),
>         inet_pton(AF_INET6, "2002:a05:6608:297::", &sin6_addr), sin6_scope_id=0},
>         msg_namelen=1024->28, msg_iov=[{iov_base="`\r\337\320\0004\6\1&\7\370\260\200\231\16\27\0\0\0\0\0\0\0\0 \2\n\5f\10\2\227"..., iov_len=1024}],
>         msg_iovlen=1, msg_control=[{cmsg_len=32, cmsg_level=SOL_SOCKET, cmsg_type=SO_TIMESTAMP_OLD, cmsg_data={tv_sec=1590340680, tv_usec=272424}},
>                                    {cmsg_len=60, cmsg_level=SOL_IPV6, cmsg_type=IPV6_RECVERR}],
>         msg_controllen=96, msg_flags=MSG_ERRQUEUE}, MSG_ERRQUEUE) = 144
> 
> Suggested-by: Maciej ¯enczykowski <maze@google.com
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thanks Eric.
