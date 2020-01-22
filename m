Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1DB1145B3E
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 18:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgAVR7n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 12:59:43 -0500
Received: from www62.your-server.de ([213.133.104.62]:55648 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbgAVR7n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 12:59:43 -0500
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuKI1-0007L0-6Z; Wed, 22 Jan 2020 18:59:41 +0100
Received: from [2001:1620:665:0:5795:5b0a:e5d5:5944] (helo=linux-3.fritz.box)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1iuKI0-000TOb-Ul; Wed, 22 Jan 2020 18:59:41 +0100
Subject: Re: [PATCH net] net, sk_msg: Don't check if sock is locked when
 tearing down psock
To:     Jakub Sitnicki <jakub@cloudflare.com>, netdev@vger.kernel.org
Cc:     John Fastabend <john.fastabend@gmail.com>,
        syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
References: <20200121123147.706666-1-jakub@cloudflare.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <caf4a5f0-c58f-5e22-afd1-bbb382824572@iogearbox.net>
Date:   Wed, 22 Jan 2020 18:59:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200121123147.706666-1-jakub@cloudflare.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.101.4/25703/Wed Jan 22 12:37:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/20 1:31 PM, Jakub Sitnicki wrote:
> As John Fastabend reports [0], psock state tear-down can happen on receive
> path *after* unlocking the socket, if the only other psock user, that is
> sockmap or sockhash, releases its psock reference before tcp_bpf_recvmsg
> does so:
> 
>   tcp_bpf_recvmsg()
>    psock = sk_psock_get(sk)                         <- refcnt 2
>    lock_sock(sk);
>    ...
>                                    sock_map_free()  <- refcnt 1
>    release_sock(sk)
>    sk_psock_put()                                   <- refcnt 0
> 
> Remove the lockdep check for socket lock in psock tear-down that got
> introduced in 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during
> tear down").
> 
> [0] https://lore.kernel.org/netdev/5e25dc995d7d_74082aaee6e465b441@john-XPS-13-9370.notmuch/
> 
> Fixes: 7e81a3530206 ("bpf: Sockmap, ensure sock lock held during tear down")
> Reported-by: syzbot+d73682fcf7fee6982fe3@syzkaller.appspotmail.com
> Suggested-by: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Given it's assigned to you right now, David, feel free to take directly to net:

Acked-by: Daniel Borkmann <daniel@iogearbox.net>

Thanks,
Daniel
