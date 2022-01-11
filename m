Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30F5B48AA11
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 10:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349132AbiAKJBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 04:01:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349137AbiAKJBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 04:01:21 -0500
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE596C061748
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 01:01:20 -0800 (PST)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed20:21ee:483:c1e3:4013])
        by laurent.telenet-ops.be with bizsmtp
        id hM1H2600S0njLPq01M1HU9; Tue, 11 Jan 2022 10:01:18 +0100
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1n7D1p-0095rS-9y; Tue, 11 Jan 2022 10:01:17 +0100
Date:   Tue, 11 Jan 2022 10:01:17 +0100 (CET)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@linux-m68k.org
Subject: Re: [PATCH net-next 10/32] netfilter: flowtable: remove ipv4/ipv6
 modules
In-Reply-To: <20220109231640.104123-11-pablo@netfilter.org>
Message-ID: <alpine.DEB.2.22.394.2201110953410.2167203@ramsan.of.borg>
References: <20220109231640.104123-1-pablo@netfilter.org> <20220109231640.104123-11-pablo@netfilter.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 	Hi Pablo, Florian,

On Mon, 10 Jan 2022, Pablo Neira Ayuso wrote:
> From: Florian Westphal <fw@strlen.de>
>
> Just place the structs and registration in the inet module.
> nf_flow_table_ipv6, nf_flow_table_ipv4 and nf_flow_table_inet share
> same module dependencies: nf_flow_table, nf_tables.
>
> before:
>   text	   data	    bss	    dec	    hex	filename
>   2278	   1480	      0	   3758	    eae	nf_flow_table_inet.ko
>   1159	   1352	      0	   2511	    9cf	nf_flow_table_ipv6.ko
>   1154	   1352	      0	   2506	    9ca	nf_flow_table_ipv4.ko
>
> after:
>   2369	   1672	      0	   4041	    fc9	nf_flow_table_inet.ko
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for your patch, which is now commit c42ba4290b2147aa
("netfilter: flowtable: remove ipv4/ipv6 modules") upstream.

> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -59,12 +59,8 @@ config NF_TABLES_ARP
> endif # NF_TABLES
>
> config NF_FLOW_TABLE_IPV4
> -	tristate "Netfilter flow table IPv4 module"
> -	depends on NF_FLOW_TABLE
> -	help
> -	  This option adds the flow table IPv4 support.
> -
> -	  To compile it as a module, choose M here.
> +	tristate
> +	select NF_FLOW_TABLE_INET

What is the point in keeping this symbol? It is invisble, selected
by nothing (so it can no longer be enabled), and its last user is
removed below.
Is there a mistake, or should this symbol just be removed?

> config NF_DUP_IPV4
> 	tristate "Netfilter IPv4 packet duplication to alternate destination"

> --- a/net/ipv4/netfilter/Makefile
> +++ b/net/ipv4/netfilter/Makefile
> @@ -24,9 +24,6 @@ obj-$(CONFIG_NFT_REJECT_IPV4) += nft_reject_ipv4.o
>  obj-$(CONFIG_NFT_FIB_IPV4) += nft_fib_ipv4.o
>  obj-$(CONFIG_NFT_DUP_IPV4) += nft_dup_ipv4.o
> 
> -# flow table support
> -obj-$(CONFIG_NF_FLOW_TABLE_IPV4) += nf_flow_table_ipv4.o
> -
>  # generic IP tables
>  obj-$(CONFIG_IP_NF_IPTABLES) += ip_tables.o

> --- a/net/ipv6/netfilter/Kconfig
> +++ b/net/ipv6/netfilter/Kconfig
> @@ -48,12 +48,8 @@ endif # NF_TABLES_IPV6
> endif # NF_TABLES
>
> config NF_FLOW_TABLE_IPV6
> -	tristate "Netfilter flow table IPv6 module"
> -	depends on NF_FLOW_TABLE
> -	help
> -	  This option adds the flow table IPv6 support.
> -
> -	  To compile it as a module, choose M here.
> +	tristate
> +	select NF_FLOW_TABLE_INET

Likewise, except that its last user was not removed:

     net/ipv6/netfilter/Makefile:obj-$(CONFIG_NF_FLOW_TABLE_IPV6) += nf_flow_table_ipv6.o

> config NF_DUP_IPV6
> 	tristate "Netfilter IPv6 packet duplication to alternate destination"

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
