Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3D5134208
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 13:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgAHMnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 07:43:53 -0500
Received: from smtp-out.kfki.hu ([148.6.0.46]:37575 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbgAHMnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jan 2020 07:43:52 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp1.kfki.hu (Postfix) with ESMTP id 5C5123C80136;
        Wed,  8 Jan 2020 13:43:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1578487426; x=1580301827; bh=/rV+HdWQtv
        hzFYxBKRovTDSHc8sdqd3hn9+O7S38F4Q=; b=YUbJb3SxbH5UyNHKv1BvNHvKE7
        zBust47e8d1fPd5wE9Qma1gLK2uhaVP/GwtRPpeKEKQ6ENmYzVH+WBz/VDC8i+Cs
        gjsXXtlLaCMhQmjZyn+psPXA8LMUyVuHjNhU0AZ6OWPF56/UiX1ZGdGh1IqJi5Qj
        1OkPUthlgjs85dn7A=
X-Virus-Scanned: Debian amavisd-new at smtp1.kfki.hu
Received: from smtp1.kfki.hu ([127.0.0.1])
        by localhost (smtp1.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Wed,  8 Jan 2020 13:43:46 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.240.2])
        by smtp1.kfki.hu (Postfix) with ESMTP id A94243C8013D;
        Wed,  8 Jan 2020 13:43:45 +0100 (CET)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 8429A20F00; Wed,  8 Jan 2020 13:43:45 +0100 (CET)
Date:   Wed, 8 Jan 2020 13:43:45 +0100 (CET)
From:   =?UTF-8?Q?Kadlecsik_J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>
To:     Jan Engelhardt <jengelh@inai.de>
cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
Subject: Re: [PATCH] netfilter: ipset: avoid null deref when IPSET_ATTR_LINENO
 is present
In-Reply-To: <20200108103726.32253-1-jengelh@inai.de>
Message-ID: <alpine.DEB.2.20.2001081342080.27242@blackhole.kfki.hu>
References: <20200108095938.3704-1-fw@strlen.de> <20200108103726.32253-1-jengelh@inai.de>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jan,

On Wed, 8 Jan 2020, Jan Engelhardt wrote:

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
> Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> Reported-by: syzbot+34bd2369d38707f3f4a7@syzkaller.appspotmail.com
> Fixes: a7b4f989a6294 ("netfilter: ipset: IP set core support")
> Signed-off-by: Jan Engelhardt <jengelh@inai.de>
> ---
> 
>  "Pass a dummy lineno storage, its easier than patching all set
>  implementations". This may be so, but that does not mean patching
>  the implementations is much harder (does not even warrant running
>  coccinelle), so I present this alternative patch.

I really appreciate it but better fix it in one place and be done
with it. :-)

Best regards,
Jozsef
 
>  net/netfilter/ipset/ip_set_bitmap_ip.c       | 2 +-
>  net/netfilter/ipset/ip_set_bitmap_ipmac.c    | 2 +-
>  net/netfilter/ipset/ip_set_bitmap_port.c     | 2 +-
>  net/netfilter/ipset/ip_set_hash_ip.c         | 4 ++--
>  net/netfilter/ipset/ip_set_hash_ipmac.c      | 4 ++--
>  net/netfilter/ipset/ip_set_hash_ipmark.c     | 4 ++--
>  net/netfilter/ipset/ip_set_hash_ipport.c     | 4 ++--
>  net/netfilter/ipset/ip_set_hash_ipportip.c   | 4 ++--
>  net/netfilter/ipset/ip_set_hash_ipportnet.c  | 4 ++--
>  net/netfilter/ipset/ip_set_hash_mac.c        | 2 +-
>  net/netfilter/ipset/ip_set_hash_net.c        | 4 ++--
>  net/netfilter/ipset/ip_set_hash_netiface.c   | 4 ++--
>  net/netfilter/ipset/ip_set_hash_netnet.c     | 4 ++--
>  net/netfilter/ipset/ip_set_hash_netport.c    | 4 ++--
>  net/netfilter/ipset/ip_set_hash_netportnet.c | 4 ++--
>  net/netfilter/ipset/ip_set_list_set.c        | 2 +-
>  16 files changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
> index abe8f77d7d23..9403730ca686 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ip.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
> @@ -137,7 +137,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
>  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
>  	int ret = 0;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP]))
> diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> index b618713297da..b16ebdddca83 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
> @@ -248,7 +248,7 @@ bitmap_ipmac_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u32 ip = 0;
>  	int ret = 0;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP]))
> diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
> index 23d6095cb196..cb22d85cef01 100644
> --- a/net/netfilter/ipset/ip_set_bitmap_port.c
> +++ b/net/netfilter/ipset/ip_set_bitmap_port.c
> @@ -161,7 +161,7 @@ bitmap_port_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u16 port_to;
>  	int ret = 0;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!ip_set_attr_netorder(tb, IPSET_ATTR_PORT) ||
> diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
> index 5d6d68eaf6a9..1195ee3539fb 100644
> --- a/net/netfilter/ipset/ip_set_hash_ip.c
> +++ b/net/netfilter/ipset/ip_set_hash_ip.c
> @@ -104,7 +104,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u32 ip = 0, ip_to = 0, hosts;
>  	int ret = 0;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP]))
> @@ -238,7 +238,7 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP]))
> diff --git a/net/netfilter/ipset/ip_set_hash_ipmac.c b/net/netfilter/ipset/ip_set_hash_ipmac.c
> index eceb7bc4a93a..9a1dc251988e 100644
> --- a/net/netfilter/ipset/ip_set_hash_ipmac.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipmac.c
> @@ -126,7 +126,7 @@ hash_ipmac4_uadt(struct ip_set *set, struct nlattr *tb[],
>  		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
>  		return -IPSET_ERR_PROTOCOL;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	ret = ip_set_get_ipaddr4(tb[IPSET_ATTR_IP], &e.ip) ||
> @@ -245,7 +245,7 @@ hash_ipmac6_uadt(struct ip_set *set, struct nlattr *tb[],
>  		     !ip_set_optattr_netorder(tb, IPSET_ATTR_SKBQUEUE)))
>  		return -IPSET_ERR_PROTOCOL;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	ret = ip_set_get_ipaddr6(tb[IPSET_ATTR_IP], &e.ip) ||
> diff --git a/net/netfilter/ipset/ip_set_hash_ipmark.c b/net/netfilter/ipset/ip_set_hash_ipmark.c
> index aba1df617d6e..6b975573db7c 100644
> --- a/net/netfilter/ipset/ip_set_hash_ipmark.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipmark.c
> @@ -103,7 +103,7 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u32 ip, ip_to = 0;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> @@ -228,7 +228,7 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
> index 1ff228717e29..7cec674af6de 100644
> --- a/net/netfilter/ipset/ip_set_hash_ipport.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipport.c
> @@ -112,7 +112,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	bool with_ports = false;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> @@ -270,7 +270,7 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	bool with_ports = false;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
> index fa88afd812fa..9ea4b8119cbe 100644
> --- a/net/netfilter/ipset/ip_set_hash_ipportip.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
> @@ -115,7 +115,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	bool with_ports = false;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> @@ -281,7 +281,7 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	bool with_ports = false;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
> index eef6ecfcb409..bf089de34330 100644
> --- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
> @@ -169,7 +169,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u8 cidr;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> @@ -419,7 +419,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u8 cidr;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] || !tb[IPSET_ATTR_IP2] ||
> diff --git a/net/netfilter/ipset/ip_set_hash_mac.c b/net/netfilter/ipset/ip_set_hash_mac.c
> index 0b61593165ef..6cfabfedc44f 100644
> --- a/net/netfilter/ipset/ip_set_hash_mac.c
> +++ b/net/netfilter/ipset/ip_set_hash_mac.c
> @@ -100,7 +100,7 @@ hash_mac4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_ETHER] ||
> diff --git a/net/netfilter/ipset/ip_set_hash_net.c b/net/netfilter/ipset/ip_set_hash_net.c
> index 136cf0781d3a..3d74b249db7b 100644
> --- a/net/netfilter/ipset/ip_set_hash_net.c
> +++ b/net/netfilter/ipset/ip_set_hash_net.c
> @@ -142,7 +142,7 @@ hash_net4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u32 ip = 0, ip_to = 0;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> @@ -308,7 +308,7 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
> index be5e95a0d876..32fc8f794d6a 100644
> --- a/net/netfilter/ipset/ip_set_hash_netiface.c
> +++ b/net/netfilter/ipset/ip_set_hash_netiface.c
> @@ -204,7 +204,7 @@ hash_netiface4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u32 ip = 0, ip_to = 0;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> @@ -416,7 +416,7 @@ hash_netiface6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> diff --git a/net/netfilter/ipset/ip_set_hash_netnet.c b/net/netfilter/ipset/ip_set_hash_netnet.c
> index da4ef910b12d..789fc367476e 100644
> --- a/net/netfilter/ipset/ip_set_hash_netnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_netnet.c
> @@ -170,7 +170,7 @@ hash_netnet4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u32 ip2 = 0, ip2_from = 0, ip2_to = 0;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	hash_netnet4_init(&e);
> @@ -401,7 +401,7 @@ hash_netnet6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	hash_netnet6_init(&e);
> diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
> index 34448df80fb9..292aeee525f9 100644
> --- a/net/netfilter/ipset/ip_set_hash_netport.c
> +++ b/net/netfilter/ipset/ip_set_hash_netport.c
> @@ -162,7 +162,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u8 cidr;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> @@ -378,7 +378,7 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	u8 cidr;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_IP] ||
> diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
> index 934c1712cba8..35c7b953507e 100644
> --- a/net/netfilter/ipset/ip_set_hash_netportnet.c
> +++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
> @@ -185,7 +185,7 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
>  	bool with_ports = false;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	hash_netportnet4_init(&e);
> @@ -463,7 +463,7 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
>  	bool with_ports = false;
>  	int ret;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	hash_netportnet6_init(&e);
> diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
> index cd747c0962fd..36b544c488d1 100644
> --- a/net/netfilter/ipset/ip_set_list_set.c
> +++ b/net/netfilter/ipset/ip_set_list_set.c
> @@ -353,7 +353,7 @@ list_set_uadt(struct ip_set *set, struct nlattr *tb[],
>  	struct ip_set *s;
>  	int ret = 0;
>  
> -	if (tb[IPSET_ATTR_LINENO])
> +	if (tb[IPSET_ATTR_LINENO] != NULL && lineno != NULL)
>  		*lineno = nla_get_u32(tb[IPSET_ATTR_LINENO]);
>  
>  	if (unlikely(!tb[IPSET_ATTR_NAME] ||
> -- 
> 2.24.1
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary
