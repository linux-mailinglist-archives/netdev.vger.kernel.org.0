Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7DB2D4F25
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 12:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729117AbfJLKtx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 06:49:53 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36585 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727083AbfJLKtx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 06:49:53 -0400
Received: by mail-pg1-f196.google.com with SMTP id 23so7270377pgk.3;
        Sat, 12 Oct 2019 03:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CKzoOCBU83sCPMzDHQyLdCwFveOeVbaB4oF2R1VkE+g=;
        b=KgOcuv9jDFFNxf+p412p8nmsabm/ErZulfUN/6WDBFh1gOrzdsKrJV9QAG5QvvvMbD
         y2/t7CpcC1Z919okSMP5RYZmCFjh9wjIzWhKT8CIp2lbNoFiPlxDRHn4icjOei7AI6AS
         nb+hBd800PwNmNmEdjfh+msh5gvl2pGuXWMxQB6uz0dY2xclEEbl8s1PfydFBvbg3Kog
         TpnQwUj8W6SAGGu6mYRbXa9pSWTlvFh/TdG3xyQSmThhah7S+wWgiVLWzhn0ejR4TSN8
         JbJbDsgHd3xUIvt81kahtyvDznC8q53H8qN/gQoy6il6iTEtVDYKKv95X20eY9hKhR/8
         15pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CKzoOCBU83sCPMzDHQyLdCwFveOeVbaB4oF2R1VkE+g=;
        b=LZpf/txF/6ChRpJADAU2A77ipoqJBd6NhjAGBroZLVFb9PS0UuPc5VTa3joUWZgr1m
         qNZ91zsFBhrJVR5aI5/4IncaahzO6aQIFbmlFl5HEMuHuaGx8E6+erbXqwG4Fa6zduGt
         g1eRIZpH+dPfFCQuvzVnFiHUlS3K2iJ3mDXCLwYysrjsCfg8Wb6LsLoLfJ6sXFenQOac
         eMIVE0kDR3Z757RT/ZOAwTL3/e4rxoYkb7lZU0w4+IKwu1AWWOz6PfiwkET+HBpdmyN+
         aCqCmgQ+ZELPKwZfMm/Bh6GK0nuGrQj1/Hoh6x396ySXQ2WPcRb7Mhcx1GjC/bUZe3m8
         5e9A==
X-Gm-Message-State: APjAAAWHgDBSaipYMX6tg5sLDmTIsP+/LOs/Dl4QvWzZsajBV/VGkUoc
        JpkGjhklzFkJVep+5X6JElNVomyh
X-Google-Smtp-Source: APXvYqxILWzISNg6tqGfCZGkW4J7WabpBjmDAyQH1CFw01hJKKc9jt60XV+2zxOHQE3JdRAvN5HWpw==
X-Received: by 2002:a17:90a:eac4:: with SMTP id ev4mr23392197pjb.97.1570877391979;
        Sat, 12 Oct 2019 03:49:51 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id g4sm10817681pfo.33.2019.10.12.03.49.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Oct 2019 03:49:50 -0700 (PDT)
Subject: Re: [PATCH net] rxrpc: Fix possible NULL pointer access in ICMP
 handling
To:     David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Cc:     linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
References: <157071915431.29197.5055122258964729288.stgit@warthog.procyon.org.uk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <bf358fc5-c0e1-070f-b073-1675e3d13fd8@gmail.com>
Date:   Sat, 12 Oct 2019 03:49:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <157071915431.29197.5055122258964729288.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/19 7:52 AM, David Howells wrote:
> If an ICMP packet comes in on the UDP socket backing an AF_RXRPC socket as
> the UDP socket is being shut down, rxrpc_error_report() may get called to
> deal with it after sk_user_data on the UDP socket has been cleared, leading
> to a NULL pointer access when this local endpoint record gets accessed.
> 
> Fix this by just returning immediately if sk_user_data was NULL.
> 
> The oops looks like the following:
> 
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> ...
> RIP: 0010:rxrpc_error_report+0x1bd/0x6a9
> ...
> Call Trace:
>  ? sock_queue_err_skb+0xbd/0xde
>  ? __udp4_lib_err+0x313/0x34d
>  __udp4_lib_err+0x313/0x34d
>  icmp_unreach+0x1ee/0x207
>  icmp_rcv+0x25b/0x28f
>  ip_protocol_deliver_rcu+0x95/0x10e
>  ip_local_deliver+0xe9/0x148
>  __netif_receive_skb_one_core+0x52/0x6e
>  process_backlog+0xdc/0x177
>  net_rx_action+0xf9/0x270
>  __do_softirq+0x1b6/0x39a
>  ? smpboot_register_percpu_thread+0xce/0xce
>  run_ksoftirqd+0x1d/0x42
>  smpboot_thread_fn+0x19e/0x1b3
>  kthread+0xf1/0xf6
>  ? kthread_delayed_work_timer_fn+0x83/0x83
>  ret_from_fork+0x24/0x30
> 
> Fixes: 17926a79320a ("[AF_RXRPC]: Provide secure RxRPC sockets for use by userspace and kernel both")
> Reported-by: syzbot+611164843bd48cc2190c@syzkaller.appspotmail.com
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  net/rxrpc/peer_event.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
> index c97ebdc043e4..61451281d74a 100644
> --- a/net/rxrpc/peer_event.c
> +++ b/net/rxrpc/peer_event.c
> @@ -151,6 +151,9 @@ void rxrpc_error_report(struct sock *sk)
>  	struct rxrpc_peer *peer;
>  	struct sk_buff *skb;
>  
> +	if (unlikely(!local))
> +		return;
> +
>  	_enter("%p{%d}", sk, local->debug_id);
>  
>  	/* Clear the outstanding error value on the socket so that it doesn't
> 

Okay, but we also need this.

diff --git a/net/rxrpc/peer_event.c b/net/rxrpc/peer_event.c
index c97ebdc043e44525eaecdd54bc447c1895bdca74..38db10e61f7a5cb50f9ee036b5e16ec284e723ac 100644
--- a/net/rxrpc/peer_event.c
+++ b/net/rxrpc/peer_event.c
@@ -145,9 +145,9 @@ static void rxrpc_adjust_mtu(struct rxrpc_peer *peer, struct sock_exterr_skb *se
  */
 void rxrpc_error_report(struct sock *sk)
 {
+       struct rxrpc_local *local = rcu_dereference_sk_user_data(sk);
        struct sock_exterr_skb *serr;
        struct sockaddr_rxrpc srx;
-       struct rxrpc_local *local = sk->sk_user_data;
        struct rxrpc_peer *peer;
        struct sk_buff *skb;

