Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E6DD3041
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfJJSYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:24:24 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:51122 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727032AbfJJSYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:24:07 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (webmail.solarflare.com [12.187.104.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 43149B4006A;
        Thu, 10 Oct 2019 18:24:05 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ocex03.SolarFlarecom.com
 (10.20.40.36) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 10 Oct
 2019 11:24:00 -0700
Subject: Re: [PATCH net-next1/2] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
To:     Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>, Eric Dumazet <edumazet@google.com>,
        "Ido Schimmel" <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20191010144226.4115-1-alobakin@dlink.ru>
 <20191010144226.4115-2-alobakin@dlink.ru>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <bb454c3c-1d86-f81e-a03e-86f8de3e9822@solarflare.com>
Date:   Thu, 10 Oct 2019 19:23:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191010144226.4115-2-alobakin@dlink.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-24966.005
X-TM-AS-Result: No-6.587700-4.000000-10
X-TMASE-MatchedRID: oTBA/+sdKab4ECMHJTM/ufZvT2zYoYOwC/ExpXrHizwZFDQxUvPcmL6Y
        VRYkPkYCSCF6HRRH3gIN25tj8sME0ixppiUy9o4cA9lly13c/gFdxx6WRf+5sFVkJxysad/I8oM
        fiEarrJBNrsF/gvwvK4N86bMbdBNQb6wZx1ul0pxNa4UOfkJSNKoxpAjnRFPjrnl6TLi5UmyDuU
        30s68UO6DNllOetTaoD3T/GOCyXu2jxYyRBa/qJQPTK4qtAgwIAYt5KiTiutkLbigRnpKlKTpcQ
        TtiHDgWl4w8bbXrRbUSd6OLRiQRmKej9k22410aJe5hZF11Za4I9un48LXJsdrC0b+bkMFDjgPx
        tWMuY/VOcEc3FZeduqDOZC1kUEQa4vn0zMfSmjYrbLOj1GuP3A+hgLflG6KEo9QjuF9BKnl4IFx
        QIbVomJRMZUCEHkRt
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.587700-4.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-24966.005
X-MDID: 1570731846-sucjTvnwbKCl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/2019 15:42, Alexander Lobakin wrote:
> Commit 323ebb61e32b4 ("net: use listified RX for handling GRO_NORMAL
> skbs") made use of listified skb processing for the users of
> napi_gro_frags().
> The same technique can be used in a way more common napi_gro_receive()
> to speed up non-merged (GRO_NORMAL) skbs for a wide range of drivers,
> including gro_cells and mac80211 users.
>
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
> ---
>  net/core/dev.c | 49 +++++++++++++++++++++++++------------------------
>  1 file changed, 25 insertions(+), 24 deletions(-)
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 8bc3dce71fc0..a33f56b439ce 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -5884,6 +5884,26 @@ struct packet_offload *gro_find_complete_by_type(__be16 type)
>  }
>  EXPORT_SYMBOL(gro_find_complete_by_type);
>  
> +/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
> +static void gro_normal_list(struct napi_struct *napi)
> +{
> +	if (!napi->rx_count)
> +		return;
> +	netif_receive_skb_list_internal(&napi->rx_list);
> +	INIT_LIST_HEAD(&napi->rx_list);
> +	napi->rx_count = 0;
> +}
> +
> +/* Queue one GRO_NORMAL SKB up for list processing.  If batch size exceeded,
> + * pass the whole batch up to the stack.
> + */
> +static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
> +{
> +	list_add_tail(&skb->list, &napi->rx_list);
> +	if (++napi->rx_count >= gro_normal_batch)
> +		gro_normal_list(napi);
> +}
> +
>  static void napi_skb_free_stolen_head(struct sk_buff *skb)
>  {
>  	skb_dst_drop(skb);
> @@ -5891,12 +5911,13 @@ static void napi_skb_free_stolen_head(struct sk_buff *skb)
>  	kmem_cache_free(skbuff_head_cache, skb);
>  }
>  
> -static gro_result_t napi_skb_finish(gro_result_t ret, struct sk_buff *skb)
> +static gro_result_t napi_skb_finish(struct napi_struct *napi,
> +				    struct sk_buff *skb,
> +				    gro_result_t ret)
Any reason why the argument order here is changed around?

-Ed
>  {
>  	switch (ret) {
>  	case GRO_NORMAL:
> -		if (netif_receive_skb_internal(skb))
> -			ret = GRO_DROP;
> +		gro_normal_one(napi, skb);
>  		break;
>  
>  	case GRO_DROP:
> @@ -5928,7 +5949,7 @@ gro_result_t napi_gro_receive(struct napi_struct *napi, struct sk_buff *skb)
>  
>  	skb_gro_reset_offset(skb);
>  
> -	ret = napi_skb_finish(dev_gro_receive(napi, skb), skb);
> +	ret = napi_skb_finish(napi, skb, dev_gro_receive(napi, skb));
>  	trace_napi_gro_receive_exit(ret);
>  
>  	return ret;
> @@ -5974,26 +5995,6 @@ struct sk_buff *napi_get_frags(struct napi_struct *napi)
>  }
>  EXPORT_SYMBOL(napi_get_frags);
>  
> -/* Pass the currently batched GRO_NORMAL SKBs up to the stack. */
> -static void gro_normal_list(struct napi_struct *napi)
> -{
> -	if (!napi->rx_count)
> -		return;
> -	netif_receive_skb_list_internal(&napi->rx_list);
> -	INIT_LIST_HEAD(&napi->rx_list);
> -	napi->rx_count = 0;
> -}
> -
> -/* Queue one GRO_NORMAL SKB up for list processing.  If batch size exceeded,
> - * pass the whole batch up to the stack.
> - */
> -static void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb)
> -{
> -	list_add_tail(&skb->list, &napi->rx_list);
> -	if (++napi->rx_count >= gro_normal_batch)
> -		gro_normal_list(napi);
> -}
> -
>  static gro_result_t napi_frags_finish(struct napi_struct *napi,
>  				      struct sk_buff *skb,
>  				      gro_result_t ret)

