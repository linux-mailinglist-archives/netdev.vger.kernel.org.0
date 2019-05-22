Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18874268AA
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 18:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730210AbfEVQ5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 12:57:37 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44893 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729712AbfEVQ5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 12:57:37 -0400
Received: by mail-qt1-f196.google.com with SMTP id f24so3191384qtk.11
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 09:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=kyQfvz4VZZmyuNriR/ug4NiGJDmlgUVtzxY+5vgV4xs=;
        b=I1q/yoYs/6HOlX+E0LI3YL+bF2PEZvkfOxwa5BTPCYyf9vGJSYYNVPT/WPV6x7aqnq
         pp0PEc2mtTf+Zc8guMpz3NwluQF6XydcsjMqZGkN063/i7LvgWjd2jMBq+ZKS11xYYsS
         PQQy5q0KUsEtiL+6bbmWmxo7ZSvYnl6Q2dK+hfLurguJk7RF0WedtzWfdKefUvr67fBG
         7DPxp4QYmNHM/Da7FY4ExeZiPLPA773gpd0bASZBcyRYYHWLcLrGl0uSdG9e1HTDF90n
         On+uKM4tc1mXmumGC8KI6Qk6c5O3ca+co23Dl5Ve4rFYOrmFZAzDu0ei+nthsOPTXXjw
         LPZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=kyQfvz4VZZmyuNriR/ug4NiGJDmlgUVtzxY+5vgV4xs=;
        b=movp9XbJKLkapH+cZoyOskOkCXQQfW1jVRPW0lWvUEwTS3ggP1IiTniI8uzAG2vJm/
         3q9zz9RUMEIhWybgEsmyE48OvW0l2ZdbMML7CNHdTCOxnE7NgTq9Dce64yFdZxxi/gVW
         8u68gH8ek6oh7p4snky3StBv9dqHmR8+ow55kvZeePvC/zNNcLKDoA0VAR+b+AcbafDm
         y7n/c8rTVEXMi9gMyrRMVVZ5hEGWKiaKghgA1SKqEvbaUIoSmXhZIbzEBkchuQCw9nPB
         FzmIn8X59UfLtk2rFc7YkNB4Jj37Tdcd8V2z3yQA0iMNcpC/aYHVM6/O02NhkCONXxK9
         TfIA==
X-Gm-Message-State: APjAAAUnQHi4ZQCeDOQg9I5tMC/AjSxrlpG0+2ktJfOoYtynNyO5+AVt
        vpB6zC/4LqCZYFamAXtfqoN10A==
X-Google-Smtp-Source: APXvYqyrWGTRv0RW2IrpHyy7p2cCz1OxOt7jtoi8lejl0UYEj1n08uYxpIoFcnmQrDSEEmfCOQcf+w==
X-Received: by 2002:ac8:3696:: with SMTP id a22mr75082520qtc.296.1558544255538;
        Wed, 22 May 2019 09:57:35 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id q27sm15361017qtf.27.2019.05.22.09.57.34
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 22 May 2019 09:57:35 -0700 (PDT)
Date:   Wed, 22 May 2019 09:57:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org,
        David Beckett <david.beckett@netronome.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [bpf PATCH v4 1/4] bpf: tls, implement unhash to avoid
 transition out of ESTABLISHED
Message-ID: <20190522095730.047ad08f@cakuba.netronome.com>
In-Reply-To: <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
References: <155746412544.20677.8888193135689886027.stgit@john-XPS-13-9360>
 <155746426913.20677.2783358822817593806.stgit@john-XPS-13-9360>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 May 2019 21:57:49 -0700, John Fastabend wrote:
> It is possible (via shutdown()) for TCP socks to go through TCP_CLOSE
> state via tcp_disconnect() without calling into close callback. This
> would allow a kTLS enabled socket to exist outside of ESTABLISHED
> state which is not supported.
> 
> Solve this the same way we solved the sock{map|hash} case by adding
> an unhash hook to remove tear down the TLS state.
> 
> In the process we also make the close hook more robust. We add a put
> call into the close path, also in the unhash path, to remove the
> reference to ulp data after free. Its no longer valid and may confuse
> things later if the socket (re)enters kTLS code paths. Second we add
> an 'if(ctx)' check to ensure the ctx is still valid and not released
> from a previous unhash/close path.
> 
> Fixes: d91c3e17f75f2 ("net/tls: Only attach to sockets in ESTABLISHED state")
> Reported-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Looks like David Beckett managed to trigger another nasty on the
release path :/

    BUG: kernel NULL pointer dereference, address: 0000000000000012
    PGD 0 P4D 0
    Oops: 0000 [#1] SMP PTI
    CPU: 7 PID: 0 Comm: swapper/7 Not tainted
    5.2.0-rc1-00139-g14629453a6d3 #21 RIP: 0010:tcp_peek_len+0x10/0x60
    RSP: 0018:ffffc02e41c54b98 EFLAGS: 00010246
    RAX: 0000000000000000 RBX: ffff9cf924c4e030 RCX: 0000000000000051
    RDX: 0000000000000000 RSI: 000000000000000c RDI: ffff9cf97128f480
    RBP: ffff9cf9365e0300 R08: ffff9cf94fe7d2c0 R09: 0000000000000000
    R10: 000000000000036b R11: ffff9cf939735e00 R12: ffff9cf91ad9ae40
    R13: ffff9cf924c4e000 R14: ffff9cf9a8fcbaae R15: 0000000000000020
    FS: 0000000000000000(0000) GS:ffff9cf9af7c0000(0000)
    knlGS:0000000000000000 CS: 0010 DS: 0000 ES: 0000 CR0:
    0000000080050033 CR2: 0000000000000012 CR3: 000000013920a003 CR4:
    00000000003606e0 DR0: 0000000000000000 DR1: 0000000000000000 DR2:
    0000000000000000 DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
    0000000000000400 Call Trace:
     <IRQ>
     strp_data_ready+0x48/0x90
     tls_data_ready+0x22/0xd0 [tls]
     tcp_rcv_established+0x569/0x620
     tcp_v4_do_rcv+0x127/0x1e0
     tcp_v4_rcv+0xad7/0xbf0
     ip_protocol_deliver_rcu+0x2c/0x1c0
     ip_local_deliver_finish+0x41/0x50
     ip_local_deliver+0x6b/0xe0
     ? ip_protocol_deliver_rcu+0x1c0/0x1c0
     ip_rcv+0x52/0xd0
     ? ip_rcv_finish_core.isra.20+0x380/0x380
     __netif_receive_skb_one_core+0x7e/0x90
     netif_receive_skb_internal+0x42/0xf0
     napi_gro_receive+0xed/0x150
     nfp_net_poll+0x7a2/0xd30 [nfp]
     ? kmem_cache_free_bulk+0x286/0x310
     net_rx_action+0x149/0x3b0
     __do_softirq+0xe3/0x30a
     ? handle_irq_event_percpu+0x6a/0x80
     irq_exit+0xe8/0xf0
     do_IRQ+0x85/0xd0
     common_interrupt+0xf/0xf
     </IRQ>
    RIP: 0010:cpuidle_enter_state+0xbc/0x450

If I read this right strparser calls sock->ops->peek_len(sock), but the
sock->sk is already NULL.  I'm guess this is because inet_release()
does:

		sock->sk = NULL;
		sk->sk_prot->close(sk, timeout);

And I don't really see a way for ktls to know that sock->sk is about to
be cleared, and therefore no way to stop strparser.  Or for strparser
to always do the check, given tcp_peek_len() will do another dereference
of sock->sk :S

That's mostly a guess, it takes me half an hour of ktls connections
running to repro.

Any advice would be appreciated..  Can we move the sock->sk assignment
after close?..

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 5183a2daba64..aff93e7cdb31 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -428,8 +428,8 @@ int inet_release(struct socket *sock)
                if (sock_flag(sk, SOCK_LINGER) &&
                    !(current->flags & PF_EXITING))
                        timeout = sk->sk_lingertime;
-               sock->sk = NULL;
                sk->sk_prot->close(sk, timeout);
+               sock->sk = NULL;
        }
        return 0;
 }

I don't see IPv6 clearing this pointer, perhaps we don't have to?
We tested it and it seems to works, but this is pre-git code, so
it's hard to tell what the reason to clear was :)
