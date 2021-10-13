Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAF042C66C
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 18:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhJMQdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 12:33:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhJMQdX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 12:33:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA0A060D42;
        Wed, 13 Oct 2021 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634142679;
        bh=tk7dYRRqNKWuQBIee//5tg36h5svVIa15Raz/Q4nRfk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nNfSvV6n5CqhPgmpOe7TXWR1TVoKwy7SYaoYFlDwt+7V0OpGwJXeyHJZliB36oLm4
         jt8D1bLdXqdaJ8Ot/psQJFjmMk++DsTZz8h9kQnqH2CesUT0tMbRVSUYXHDydNBl9p
         xrzHQvSIcsfCDZfxKD4CrOAacum+mFI8AFYm2mEhDSG8rbkCnSJavOOKkFLeXbzt6i
         NdwILACWuOLNuUVBoTYqWo0MDawJFacB6upUvIYoEc9qVb8Nj+JYsvlUY+pyD8OiTC
         YuIi4hDCERwvZGdzOysk3pqgnZ6C6ViwXOMCvAuimyPt3JWZBgATQ6i6Ht73qvfnfU
         CusUgsjR9Mb3Q==
Date:   Wed, 13 Oct 2021 09:31:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Subject: Re: [PATCH net] icmp: fix icmp_ext_echo_iio parsing in
 icmp_build_probe
Message-ID: <20211013093118.691255c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <61b6693f08f4f96f00cdeb2b8c78568e39f85029.1634028187.git.lucien.xin@gmail.com>
References: <61b6693f08f4f96f00cdeb2b8c78568e39f85029.1634028187.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Oct 2021 04:43:07 -0400 Xin Long wrote:
> In icmp_build_probe(), the icmp_ext_echo_iio parsing should be done
> step by step and skb_header_pointer() return value should always be
> checked, this patch fixes 3 places in there:
> 
>   - On case ICMP_EXT_ECHO_CTYPE_NAME, it should only copy ident.name
>     from skb by skb_header_pointer(), its len is ident_len. Besides,
>     the return value of skb_header_pointer() should always be checked.
> 
>   - On case ICMP_EXT_ECHO_CTYPE_INDEX, move ident_len check ahead of
>     skb_header_pointer(), and also do the return value check for
>     skb_header_pointer().
> 
>   - On case ICMP_EXT_ECHO_CTYPE_ADDR, before accessing iio->ident.addr.
>     ctype3_hdr.addrlen, skb_header_pointer() should be called first,
>     then check its return value and ident_len.
>     On subcases ICMP_AFI_IP and ICMP_AFI_IP6, also do check for ident.
>     addr.ctype3_hdr.addrlen and skb_header_pointer()'s return value.
>     On subcase ICMP_AFI_IP, the len for skb_header_pointer() should be
>     "sizeof(iio->extobj_hdr) + sizeof(iio->ident.addr.ctype3_hdr) +
>     sizeof(struct in_addr)" or "ident_len".
> 
> Fixes: d329ea5bd884 ("icmp: add response to RFC 8335 PROBE messages")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 8b30cadff708..818c79266c48 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -1061,38 +1061,48 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
>  	dev = NULL;
>  	switch (iio->extobj_hdr.class_type) {
>  	case ICMP_EXT_ECHO_CTYPE_NAME:
> -		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
>  		if (ident_len >= IFNAMSIZ)
>  			goto send_mal_query;
> +		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> +					 ident_len, &_iio);
> +		if (!iio)
> +			goto send_mal_query;
>  		memset(buff, 0, sizeof(buff));
>  		memcpy(buff, &iio->ident.name, ident_len);
>  		dev = dev_get_by_name(net, buff);
>  		break;
>  	case ICMP_EXT_ECHO_CTYPE_INDEX:
> -		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> -					 sizeof(iio->ident.ifindex), &_iio);
>  		if (ident_len != sizeof(iio->ident.ifindex))
>  			goto send_mal_query;
> +		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> +					 ident_len, &_iio);
> +		if (!iio)
> +			goto send_mal_query;
>  		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
>  		break;
>  	case ICMP_EXT_ECHO_CTYPE_ADDR:
> -		if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> -				 iio->ident.addr.ctype3_hdr.addrlen)
> +		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> +					 sizeof(iio->ident.addr.ctype3_hdr), &_iio);
> +		if (!iio || ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> +					 iio->ident.addr.ctype3_hdr.addrlen)
>  			goto send_mal_query;
>  		switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
>  		case ICMP_AFI_IP:
> +			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in_addr))
> +				goto send_mal_query;
>  			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> -						 sizeof(struct in_addr), &_iio);
> -			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> -					 sizeof(struct in_addr))
> +						 ident_len, &_iio);
> +			if (!iio)
>  				goto send_mal_query;
>  			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
>  			break;
>  #if IS_ENABLED(CONFIG_IPV6)
>  		case ICMP_AFI_IP6:
> -			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> -			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
> -					 sizeof(struct in6_addr))
> +			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
> +				goto send_mal_query;
> +			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
> +						 ident_len, &_iio);
> +			if (!iio)
>  				goto send_mal_query;
>  			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
>  			dev_hold(dev);

If I'm reading this right we end up with the same skb_header_pointer
call 4 times, every path ends up calling:

 skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) + ident_len, &_iio);

and looks like the skb does not get modified in between so these calls
are equivalent.

So why don't we instead consolidate the paths:

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 8b30cadff708..efa2ec1a85bf 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1057,11 +1057,15 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 	if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
 		goto send_mal_query;
 	ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
+	iio = skb_header_pointer(skb, sizeof(_ext_hdr),
+				 sizeof(iio->extobj_hdr) + ident_len, &_iio);
+	if (!iio)
+		goto send_mal_query;
+
 	status = 0;
 	dev = NULL;
 	switch (iio->extobj_hdr.class_type) {
 	case ICMP_EXT_ECHO_CTYPE_NAME:
-		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
 		if (ident_len >= IFNAMSIZ)
 			goto send_mal_query;
 		memset(buff, 0, sizeof(buff));
@@ -1069,8 +1073,6 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 		dev = dev_get_by_name(net, buff);
 		break;
 	case ICMP_EXT_ECHO_CTYPE_INDEX:
-		iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
-					 sizeof(iio->ident.ifindex), &_iio);
 		if (ident_len != sizeof(iio->ident.ifindex))
 			goto send_mal_query;
 		dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
@@ -1081,18 +1083,13 @@ bool icmp_build_probe(struct sk_buff *skb, struct icmphdr *icmphdr)
 			goto send_mal_query;
 		switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
 		case ICMP_AFI_IP:
-			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(iio->extobj_hdr) +
-						 sizeof(struct in_addr), &_iio);
-			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
-					 sizeof(struct in_addr))
+			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in_addr))
 				goto send_mal_query;
 			dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
 			break;
 #if IS_ENABLED(CONFIG_IPV6)
 		case ICMP_AFI_IP6:
-			iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
-			if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) +
-					 sizeof(struct in6_addr))
+			if (iio->ident.addr.ctype3_hdr.addrlen != sizeof(struct in6_addr))
 				goto send_mal_query;
 			dev = ipv6_stub->ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
 			dev_hold(dev);
-- 
2.31.1

