Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94F1DD1A39
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 22:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731956AbfJIU6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 16:58:49 -0400
Received: from correo.us.es ([193.147.175.20]:59666 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731940AbfJIU6s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 16:58:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5E06F129182D
        for <netdev@vger.kernel.org>; Wed,  9 Oct 2019 22:58:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F7C5A7D62
        for <netdev@vger.kernel.org>; Wed,  9 Oct 2019 22:58:44 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4D16FFB362; Wed,  9 Oct 2019 22:58:44 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3A29DA72F;
        Wed,  9 Oct 2019 22:58:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Oct 2019 22:58:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9888742EE38E;
        Wed,  9 Oct 2019 22:58:41 +0200 (CEST)
Date:   Wed, 9 Oct 2019 22:58:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH net] netfilter: conntrack: avoid possible false sharing
Message-ID: <20191009205843.fxs3bn6bjd5i7lzh@salvia>
References: <20191009161913.18600-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191009161913.18600-1-edumazet@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 09, 2019 at 09:19:13AM -0700, Eric Dumazet wrote:
> As hinted by KCSAN, we need at least one READ_ONCE()
> to prevent a compiler optimization.
> 
> More details on :
> https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
> 
> sysbot report :
> BUG: KCSAN: data-race in __nf_ct_refresh_acct / __nf_ct_refresh_acct
> 
> read to 0xffff888123eb4f08 of 4 bytes by interrupt on cpu 0:
>  __nf_ct_refresh_acct+0xd4/0x1b0 net/netfilter/nf_conntrack_core.c:1796
>  nf_ct_refresh_acct include/net/netfilter/nf_conntrack.h:201 [inline]
>  nf_conntrack_tcp_packet+0xd40/0x3390 net/netfilter/nf_conntrack_proto_tcp.c:1161
>  nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1633 [inline]
>  nf_conntrack_in+0x410/0xaa0 net/netfilter/nf_conntrack_core.c:1727
>  ipv4_conntrack_in+0x27/0x40 net/netfilter/nf_conntrack_proto.c:178
>  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
>  nf_hook_slow+0x83/0x160 net/netfilter/core.c:512
>  nf_hook include/linux/netfilter.h:260 [inline]
>  NF_HOOK include/linux/netfilter.h:303 [inline]
>  ip_rcv+0x12f/0x1a0 net/ipv4/ip_input.c:523
>  __netif_receive_skb_one_core+0xa7/0xe0 net/core/dev.c:5004
>  __netif_receive_skb+0x37/0xf0 net/core/dev.c:5118
>  netif_receive_skb_internal+0x59/0x190 net/core/dev.c:5208
>  napi_skb_finish net/core/dev.c:5671 [inline]
>  napi_gro_receive+0x28f/0x330 net/core/dev.c:5704
>  receive_buf+0x284/0x30b0 drivers/net/virtio_net.c:1061
>  virtnet_receive drivers/net/virtio_net.c:1323 [inline]
>  virtnet_poll+0x436/0x7d0 drivers/net/virtio_net.c:1428
>  napi_poll net/core/dev.c:6352 [inline]
>  net_rx_action+0x3ae/0xa50 net/core/dev.c:6418
>  __do_softirq+0x115/0x33f kernel/softirq.c:292
> 
> write to 0xffff888123eb4f08 of 4 bytes by task 7191 on cpu 1:
>  __nf_ct_refresh_acct+0xfb/0x1b0 net/netfilter/nf_conntrack_core.c:1797
>  nf_ct_refresh_acct include/net/netfilter/nf_conntrack.h:201 [inline]
>  nf_conntrack_tcp_packet+0xd40/0x3390 net/netfilter/nf_conntrack_proto_tcp.c:1161
>  nf_conntrack_handle_packet net/netfilter/nf_conntrack_core.c:1633 [inline]
>  nf_conntrack_in+0x410/0xaa0 net/netfilter/nf_conntrack_core.c:1727
>  ipv4_conntrack_local+0xbe/0x130 net/netfilter/nf_conntrack_proto.c:200
>  nf_hook_entry_hookfn include/linux/netfilter.h:135 [inline]
>  nf_hook_slow+0x83/0x160 net/netfilter/core.c:512
>  nf_hook include/linux/netfilter.h:260 [inline]
>  __ip_local_out+0x1f7/0x2b0 net/ipv4/ip_output.c:114
>  ip_local_out+0x31/0x90 net/ipv4/ip_output.c:123
>  __ip_queue_xmit+0x3a8/0xa40 net/ipv4/ip_output.c:532
>  ip_queue_xmit+0x45/0x60 include/net/ip.h:236
>  __tcp_transmit_skb+0xdeb/0x1cd0 net/ipv4/tcp_output.c:1158
>  __tcp_send_ack+0x246/0x300 net/ipv4/tcp_output.c:3685
>  tcp_send_ack+0x34/0x40 net/ipv4/tcp_output.c:3691
>  tcp_cleanup_rbuf+0x130/0x360 net/ipv4/tcp.c:1575
> 
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 1 PID: 7191 Comm: syz-fuzzer Not tainted 5.3.0+ #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> 
> Fixes: cc16921351d8 ("netfilter: conntrack: avoid same-timeout update")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks.

> ---
>  net/netfilter/nf_conntrack_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 0c63120b2db2e1ea9983a6b1ce8d2aefebc29501..5cd610b547e0d1e3463a65ba3627f265c836bdc5 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -1792,8 +1792,8 @@ void __nf_ct_refresh_acct(struct nf_conn *ct,
>  	if (nf_ct_is_confirmed(ct))
>  		extra_jiffies += nfct_time_stamp;
>  
> -	if (ct->timeout != extra_jiffies)
> -		ct->timeout = extra_jiffies;
> +	if (READ_ONCE(ct->timeout) != extra_jiffies)
> +		WRITE_ONCE(ct->timeout, extra_jiffies);
>  acct:
>  	if (do_acct)
>  		nf_ct_acct_update(ct, ctinfo, skb->len);
> -- 
> 2.23.0.581.g78d2f28ef7-goog
> 
