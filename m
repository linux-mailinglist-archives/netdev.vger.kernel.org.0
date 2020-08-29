Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037C22566BB
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 11:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgH2J7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 05:59:11 -0400
Received: from mg.ssi.bg ([178.16.128.9]:54552 "EHLO mg.ssi.bg"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726869AbgH2J7K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Aug 2020 05:59:10 -0400
Received: from mg.ssi.bg (localhost [127.0.0.1])
        by mg.ssi.bg (Proxmox) with ESMTP id C43EB36ADB;
        Sat, 29 Aug 2020 12:59:06 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [178.16.128.7])
        by mg.ssi.bg (Proxmox) with ESMTP id 1EE2D36AD6;
        Sat, 29 Aug 2020 12:59:06 +0300 (EEST)
Received: from ja.ssi.bg (unknown [178.16.129.10])
        by ink.ssi.bg (Postfix) with ESMTPS id 128B73C09BA;
        Sat, 29 Aug 2020 12:58:57 +0300 (EEST)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id 07T9wsnW007570;
        Sat, 29 Aug 2020 12:58:55 +0300
Date:   Sat, 29 Aug 2020 12:58:54 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Yaroslav Bolyukin <iam@lach.pw>
cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH] Remove ipvs v6 dependency on iptables
In-Reply-To: <20200829085005.24931-1-iam@lach.pw>
Message-ID: <alpine.LFD.2.23.451.2008291233110.3043@ja.home.ssi.bg>
References: <e4765a73-e6a1-f5ba-dd8b-7c1ee1e5883d@6wind.com> <20200829085005.24931-1-iam@lach.pw>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sat, 29 Aug 2020, Yaroslav Bolyukin wrote:

> This dependency was added as part of commit ecefa32ffda201975
> ("ipvs: Fix faulty IPv6 extension header handling in IPVS"), because it
> had dependency on ipv6_find_hdr, which was located in iptables-specific
> code
> 
> But it is no longer required after commit e6f890cfde0e74d5b
> ("ipv6:Move ipv6_find_hdr() out of Netfilter code.")
> 
> Also remove ip6tables include from ip_vs
> 
> Signed-off-by: Yaroslav Bolyukin <iam@lach.pw>

	The commit you reference better to be added as special
tag, eg: Fixes: f8f626754ebe ("ipv6: Move ipv6_find_hdr() out of 
Netfilter code.") before the Signed-off-by line. Then you may skip 
mentioning the commit in the description, it will be in Fixes tag.
Note that the first 12 chars from the commit id are used, not the last.
Second Fixes line can be for 63dca2c0b0e7 ("ipvs: Fix faulty IPv6 
extension header handling in IPVS"). Both Fixes lines should not be
wrapped.

	The Subject line needs to include version and tree,
for example: [PATCHv2 net-next] ipvs: remove v6 dependency on iptables
You increase the version when sending modified patch.

	You can check the Documentation/process/submitting-patches.rst
guide for more info.

> ---
>  include/net/ip_vs.h        | 3 ---
>  net/netfilter/ipvs/Kconfig | 1 -
>  2 files changed, 4 deletions(-)
> 
> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 9a59a3378..d609e957a 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h
> @@ -25,9 +25,6 @@
>  #include <linux/ip.h>
>  #include <linux/ipv6.h>			/* for struct ipv6hdr */
>  #include <net/ipv6.h>
> -#if IS_ENABLED(CONFIG_IP_VS_IPV6)
> -#include <linux/netfilter_ipv6/ip6_tables.h>
> -#endif
>  #if IS_ENABLED(CONFIG_NF_CONNTRACK)
>  #include <net/netfilter/nf_conntrack.h>
>  #endif
> diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
> index 2c1593089..eb0e329f9 100644
> --- a/net/netfilter/ipvs/Kconfig
> +++ b/net/netfilter/ipvs/Kconfig
> @@ -29,7 +29,6 @@ if IP_VS
>  config	IP_VS_IPV6
>  	bool "IPv6 support for IPVS"
>  	depends on IPV6 = y || IP_VS = IPV6
> -	select IP6_NF_IPTABLES
>  	select NF_DEFRAG_IPV6
>  	help
>  	  Add IPv6 support to IPVS.
> -- 

Regards

--
Julian Anastasov <ja@ssi.bg>

