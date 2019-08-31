Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E35BA435C
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 10:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfHaIjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 04:39:06 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60044 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726402AbfHaIjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Aug 2019 04:39:06 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i3yuR-0000g8-4S; Sat, 31 Aug 2019 10:38:59 +0200
Date:   Sat, 31 Aug 2019 10:38:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Leonardo Bras <leonardo@linux.ibm.com>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5 1/1] net: br_netfiler_hooks: Drops IPv6 packets if
 IPv6 module is not loaded
Message-ID: <20190831083859.GT20113@breakpoint.cc>
References: <20190831044032.31931-1-leonardo@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190831044032.31931-1-leonardo@linux.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Leonardo Bras <leonardo@linux.ibm.com> wrote:
> A kernel panic can happen if a host has disabled IPv6 on boot and have to
> process guest packets (coming from a bridge) using it's ip6tables.
> 
> IPv6 packets need to be dropped if the IPv6 module is not loaded, and the
> host ip6tables will be used.
> 
> Signed-off-by: Leonardo Bras <leonardo@linux.ibm.com>
> ---
> Changes from v4:
> - Check if the host ip6tables is going to be used before testing 
>   ipv6 module presence 
> - Adds a warning about ipv6 module disabled.
> 
> 
>  net/bridge/br_netfilter_hooks.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index d3f9592f4ff8..af7800103e51 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -496,6 +496,10 @@ static unsigned int br_nf_pre_routing(void *priv,
>  		if (!brnet->call_ip6tables &&
>  		    !br_opt_get(br, BROPT_NF_CALL_IP6TABLES))
>  			return NF_ACCEPT;
> +		if (!ipv6_mod_enabled()) {
> +			pr_warn_once("Module ipv6 is disabled, so call_ip6tables is not supported.");
> +			return NF_DROP;
> +		}

pr_warn_once needs a '\n'.  Pablo, can you mangle this locally when
applying?

Patch looks good to me, so:

Acked-by: Florian Westphal <fw@strlen.de>
