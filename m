Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD4342AC95B
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbgKIX3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:40748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729243AbgKIX3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 18:29:16 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67801206B2;
        Mon,  9 Nov 2020 23:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604964555;
        bh=QLmsZu4I3VD2I6lWY3q3EZ+YXZZd264CGkdr7Y6bsvU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CDYdm9dEcW3pFo+imXDGh8eHy1+F0F5Cyw+IysJ9ZVkT4Me3cLfHTNwr3WfcS1sZq
         gafwWkNTc9GjKnJJc9M5vxT3babe81/ZKlDAjAmSCadQuaIh+t51hYVpsMPZbPn6SX
         KW/febL5oU1u66ENzi5M7SLIdBneg+TGmrwN8si8=
Date:   Mon, 9 Nov 2020 15:29:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Willem de Bruijn <willemb@google.com>,
        Guillaume Nault <gnault@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: skb_vlan_untag(): don't reset transport
 offset if set by GRO layer
Message-ID: <20201109152913.289c3cac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <zYurwsZRN7BkqSoikWQLVqHyxz18h4LhHU4NFa2Vw@cp4-web-038.plabs.ch>
References: <zYurwsZRN7BkqSoikWQLVqHyxz18h4LhHU4NFa2Vw@cp4-web-038.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Nov 2020 21:29:01 +0000 Alexander Lobakin wrote:
> Similar to commit fda55eca5a33f
> ("net: introduce skb_transport_header_was_set()"), avoid resetting
> transport offsets that were already set by GRO layer. This not only
> mirrors the behavior of __netif_receive_skb_core(), but also makes
> sense when it comes to UDP GSO fraglists forwarding: transport offset
> of such skbs is set only once by GRO receive callback and remains
> untouched and correct up to the xmitting driver in 1:1 case, but
> becomes junk after untagging in ingress VLAN case and breaks UDP
> GSO offload. This does not happen after this change, and all types
> of forwarding of UDP GSO fraglists work as expected.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/core/skbuff.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index c5e6c0b83a92..39c13b9cf79d 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -5441,9 +5441,11 @@ struct sk_buff *skb_vlan_untag(struct sk_buff *skb)
>  		goto err_free;
>  
>  	skb_reset_network_header(skb);
> -	skb_reset_transport_header(skb);
>  	skb_reset_mac_len(skb);
>  
> +	if (!skb_transport_header_was_set(skb))
> +		skb_reset_transport_header(skb);
> +

Patch looks fine, thanks, but I don't understand why you decided to 
move the reset?  It's not like it's not in order of headers, either.
Let's keep the series of resets identical to __netif_receive_skb_core(),
shall we?

>  	return skb;
>  
>  err_free:

