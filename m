Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9B7B3910D3
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 08:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232620AbhEZGnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 02:43:53 -0400
Received: from www62.your-server.de ([213.133.104.62]:44712 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232336AbhEZGnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 02:43:52 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1llnF7-00074V-5W; Wed, 26 May 2021 08:42:13 +0200
Received: from [85.7.101.30] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1llnF6-000Rf8-SY; Wed, 26 May 2021 08:42:12 +0200
Subject: Re: [PATCH v7 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Benjamin Herrenschmidt <benh@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ncardwell@google.com, ycheng@google.com
References: <20210521182104.18273-1-kuniyu@amazon.co.jp>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <c423bd7b-03ab-91f2-60af-25c6dfa28b71@iogearbox.net>
Date:   Wed, 26 May 2021 08:42:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20210521182104.18273-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.2/26181/Tue May 25 13:17:38 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/21/21 8:20 PM, Kuniyuki Iwashima wrote:
> The SO_REUSEPORT option allows sockets to listen on the same port and to
> accept connections evenly. However, there is a defect in the current
> implementation [1]. When a SYN packet is received, the connection is tied
> to a listening socket. Accordingly, when the listener is closed, in-flight
> requests during the three-way handshake and child sockets in the accept
> queue are dropped even if other listeners on the same port could accept
> such connections.
> 
> This situation can happen when various server management tools restart
> server (such as nginx) processes. For instance, when we change nginx
> configurations and restart it, it spins up new workers that respect the new
> configuration and closes all listeners on the old workers, resulting in the
> in-flight ACK of 3WHS is responded by RST.
> 
> To avoid such a situation, users have to know deeply how the kernel handles
> SYN packets and implement connection draining by eBPF [2]:
> 
>    1. Stop routing SYN packets to the listener by eBPF.
>    2. Wait for all timers to expire to complete requests
>    3. Accept connections until EAGAIN, then close the listener.
> 
>    or
> 
>    1. Start counting SYN packets and accept syscalls using the eBPF map.
>    2. Stop routing SYN packets.
>    3. Accept connections up to the count, then close the listener.
> 
> In either way, we cannot close a listener immediately. However, ideally,
> the application need not drain the not yet accepted sockets because 3WHS
> and tying a connection to a listener are just the kernel behaviour. The
> root cause is within the kernel, so the issue should be addressed in kernel
> space and should not be visible to user space. This patchset fixes it so
> that users need not take care of kernel implementation and connection
> draining. With this patchset, the kernel redistributes requests and
> connections from a listener to the others in the same reuseport group
> at/after close or shutdown syscalls.
> 
> Although some software does connection draining, there are still merits in
> migration. For some security reasons, such as replacing TLS certificates,
> we may want to apply new settings as soon as possible and/or we may not be
> able to wait for connection draining. The sockets in the accept queue have
> not started application sessions yet. So, if we do not drain such sockets,
> they can be handled by the newer listeners and could have a longer
> lifetime. It is difficult to drain all connections in every case, but we
> can decrease such aborted connections by migration. In that sense,
> migration is always better than draining.
> 
> Moreover, auto-migration simplifies user space logic and also works well in
> a case where we cannot modify and build a server program to implement the
> workaround.
> 
> Note that the source and destination listeners MUST have the same settings
> at the socket API level; otherwise, applications may face inconsistency and
> cause errors. In such a case, we have to use the eBPF program to select a
> specific listener or to cancel migration.
> 
> Special thanks to Martin KaFai Lau for bouncing ideas and exchanging code
> snippets along the way.
> 
> 
> Link:
>   [1] The SO_REUSEPORT socket option
>   https://lwn.net/Articles/542629/
> 
>   [2] Re: [PATCH 1/1] net: Add SO_REUSEPORT_LISTEN_OFF socket option as drain mode
>   https://lore.kernel.org/netdev/1458828813.10868.65.camel@edumazet-glaptop3.roam.corp.google.com/

This series needs review/ACKs from TCP maintainers. Eric/Neal/Yuchung please take
a look again.

Thanks,
Daniel
