Return-Path: <netdev+bounces-11401-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75A0B732F7D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 13:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEEB31C20D23
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 11:11:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9659B10968;
	Fri, 16 Jun 2023 11:11:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8904779D4
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 11:11:18 +0000 (UTC)
X-Greylist: delayed 602 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 16 Jun 2023 04:11:15 PDT
Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.48])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022F1C5;
	Fri, 16 Jun 2023 04:11:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 0F2FCCC0100;
	Fri, 16 Jun 2023 12:51:21 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP; Fri, 16 Jun 2023 12:51:18 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp2.kfki.hu (Postfix) with ESMTP id 8219DCC00FE;
	Fri, 16 Jun 2023 12:51:16 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 5CB2B3431A9; Fri, 16 Jun 2023 12:51:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 5B076343155;
	Fri, 16 Jun 2023 12:51:16 +0200 (CEST)
Date: Fri, 16 Jun 2023 12:51:16 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, 
    linux-hardening@vger.kernel.org, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, linux-kernel@vger.kernel.org, 
    "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
    Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: ipset: Replace strlcpy with strscpy
In-Reply-To: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
Message-ID: <b7f91b9f-84d9-8eb9-246f-68b4cb3721f9@netfilter.org>
References: <20230613003437.3538694-1-azeemshaikh38@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 13 Jun 2023, Azeem Shaikh wrote:

> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().
> 
> Direct replacement is safe here since return value from all
> callers of STRLCPY macro were ignored.
> 
> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> [2] https://github.com/KSPP/linux/issues/89
> 
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>

Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>

Best regards,
Jozsef

> ---
>  net/netfilter/ipset/ip_set_hash_netiface.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_hash_netiface.c b/net/netfilter/ipset/ip_set_hash_netiface.c
> index 031073286236..95aeb31c60e0 100644
> --- a/net/netfilter/ipset/ip_set_hash_netiface.c
> +++ b/net/netfilter/ipset/ip_set_hash_netiface.c
> @@ -40,7 +40,7 @@ MODULE_ALIAS("ip_set_hash:net,iface");
>  #define IP_SET_HASH_WITH_MULTI
>  #define IP_SET_HASH_WITH_NET0
>  
> -#define STRLCPY(a, b)	strlcpy(a, b, IFNAMSIZ)
> +#define STRSCPY(a, b)	strscpy(a, b, IFNAMSIZ)
>  
>  /* IPv4 variant */
>  
> @@ -182,11 +182,11 @@ hash_netiface4_kadt(struct ip_set *set, const struct sk_buff *skb,
>  
>  		if (!eiface)
>  			return -EINVAL;
> -		STRLCPY(e.iface, eiface);
> +		STRSCPY(e.iface, eiface);
>  		e.physdev = 1;
>  #endif
>  	} else {
> -		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
> +		STRSCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
>  	}
>  
>  	if (strlen(e.iface) == 0)
> @@ -400,11 +400,11 @@ hash_netiface6_kadt(struct ip_set *set, const struct sk_buff *skb,
>  
>  		if (!eiface)
>  			return -EINVAL;
> -		STRLCPY(e.iface, eiface);
> +		STRSCPY(e.iface, eiface);
>  		e.physdev = 1;
>  #endif
>  	} else {
> -		STRLCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
> +		STRSCPY(e.iface, SRCDIR ? IFACE(in) : IFACE(out));
>  	}
>  
>  	if (strlen(e.iface) == 0)
> -- 
> 2.41.0.162.gfafddb0af9-goog
> 
> 
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
PGP key : https://wigner.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics
          H-1525 Budapest 114, POB. 49, Hungary

