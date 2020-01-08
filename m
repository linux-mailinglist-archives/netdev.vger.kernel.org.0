Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A58133F01
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbgAHKLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:11:37 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:57567 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgAHKLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 05:11:37 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jan 2020 05:11:35 EST
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 63C883C8014A;
        Wed,  8 Jan 2020 11:05:22 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1578477920; x=1580292321; bh=z01xoCok9/
        SA9zQmk6rkuuNWBedGHt+kVfPLPyII/qQ=; b=EW1MNqnHLMHFSHgk2DlR9sAOxp
        U0b0cGnzUP1AOnHihBquvghg3Mq2WpHGWv8P8eCj+4rk0lYDEuYbjHeIl28w9/ck
        KjdGjiPv6A3TgUykrLM5XHf1iKGXn2EHdmfxHejhQKN7mtX4wI6+iceuOVFZr08H
        /5e8BqRNkgwwkqfsw=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed,  8 Jan 2020 11:05:20 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp1.kfki.hu (Postfix) with ESMTP id E164F3C80144;
        Wed,  8 Jan 2020 11:05:19 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id BBFA120F00; Wed,  8 Jan 2020 11:05:19 +0100 (CET)
Date:   Wed, 8 Jan 2020 11:05:19 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO
 is present
In-Reply-To: <20200108095938.3704-1-fw@strlen.de>
Message-ID: <alpine.DEB.2.20.2001081102010.27242@blackhole.kfki.hu>
References: <000000000000a347ef059b8ee979@google.com> <20200108095938.3704-1-fw@strlen.de>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Jan 2020, Florian Westphal wrote:

> The set uadt functions assume lineno is never NULL, but it is in
> case of ip_set_utest().
> 
> syzkaller managed to generate a netlink message that calls this with
> LINENO attr present:
> 
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> RIP: 0010:hash_mac4_uadt+0x1bc/0x470 net/netfilter/ipset/ip_set_hash_mac.c:104
> Call Trace:
>  ip_set_utest+0x55b/0x890 net/netfilter/ipset/ip_set_core.c:1867
>  nfnetlink_rcv_msg+0xcf2/0xfb0 net/netfilter/nfnetlink.c:229
>  netlink_rcv_skb+0x177/0x450 net/netlink/af_netlink.c:2477
>  nfnetlink_rcv+0x1ba/0x460 net/netfilter/nfnetlink.c:563
> 
> pass a dummy lineno storage, its easier than patching all set
> implementations.

I have just written the same patch... you were faster.
 
> This seems to be a day-0 bug.

Yes, alas. One could extend the check of attributes in ip_set_utest() to 
bail out with protocol error if attr[IPSET_ATTR_LINENO] is present.
 
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Best regards,
Jozsef

> Reported-by: syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
> Fixes: a7b4f989a6294 ("netfilter: ipset: IP set core support")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/ipset/ip_set_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 169e0a04f814..cf895bc80871 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1848,6 +1848,7 @@ static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
>  	struct ip_set *set;
>  	struct nlattr *tb[IPSET_ATTR_ADT_MAX + 1] = {};
>  	int ret = 0;
> +	u32 lineno;
>  
>  	if (unlikely(protocol_min_failed(attr) ||
>  		     !attr[IPSET_ATTR_SETNAME] ||
> @@ -1864,7 +1865,7 @@ static int ip_set_utest(struct net *net, struct sock *ctnl, struct sk_buff *skb,
>  		return -IPSET_ERR_PROTOCOL;
>  
>  	rcu_read_lock_bh();
> -	ret = set->variant->uadt(set, tb, IPSET_TEST, NULL, 0, 0);
> +	ret = set->variant->uadt(set, tb, IPSET_TEST, &lineno, 0, 0);
>  	rcu_read_unlock_bh();
>  	/* Userspace can't trigger element to be re-added */
>  	if (ret == -EAGAIN)
> -- 
> 2.24.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
