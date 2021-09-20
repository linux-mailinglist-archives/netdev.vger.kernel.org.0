Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7F24110E9
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 10:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhITI1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 04:27:49 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:35629 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234143AbhITI1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 04:27:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1632126382; x=1663662382;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=na1RttgUzSinIsRSHmrEfJEw3Fayx2xrkJqLJcO6Q3Q=;
  b=WEOIKNvCSxxS+l5QO28ESp6OAnqEaWj77j7RHYBXrCrKOkwYZSjIZrBm
   b8fxe17E5JO2gQSP1jSSVH3GYW59Skf5zlKf64HJn+67ZjocWRnbT9GVR
   GoK+6y3bh5ZjjzGm0+M7i0D3kFrJaFYfEoNVU5nhBIKG18TzsxSiFTYHf
   k=;
X-IronPort-AV: E=Sophos;i="5.85,307,1624320000"; 
   d="scan'208";a="138411144"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 20 Sep 2021 08:26:13 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-2d7489a4.us-east-1.amazon.com (Postfix) with ESMTPS id 7531A861E7;
        Mon, 20 Sep 2021 08:26:08 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.162.211) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 20 Sep 2021 08:25:59 +0000
References: <cover.1631289870.git.lorenzo@kernel.org>
 <f11d8399e17bc82f9ffcb613da0a457a96f56fec.1631289870.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.15; emacs 28.0.50
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <lorenzo.bianconi@redhat.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <dsahern@kernel.org>,
        <brouer@redhat.com>, <echaudro@redhat.com>, <jasowang@redhat.com>,
        <alexander.duyck@gmail.com>, <saeed@kernel.org>,
        <maciej.fijalkowski@intel.com>, <magnus.karlsson@intel.com>,
        <tirthendu.sarkar@intel.com>, <toke@redhat.com>
Subject: Re: [PATCH v14 bpf-next 03/18] net: mvneta: update mb bit before
 passing the xdp buffer to eBPF layer
In-Reply-To: <f11d8399e17bc82f9ffcb613da0a457a96f56fec.1631289870.git.lorenzo@kernel.org>
Date:   Mon, 20 Sep 2021 11:25:54 +0300
Message-ID: <pj41zlh7ef8xgt.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.211]
X-ClientProxiedBy: EX13P01UWA003.ant.amazon.com (10.43.160.197) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> ...
> diff --git a/drivers/net/ethernet/marvell/mvneta.c 
> b/drivers/net/ethernet/marvell/mvneta.c
> index 9d460a270601..0c7b84ca6efc 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> ...
> @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct mvneta_port 
> *pp, struct page_pool *pool,
>  		      struct xdp_buff *xdp, u32 desc_status)
>  {
>  	struct skb_shared_info *sinfo = 
>  xdp_get_shared_info_from_buff(xdp);
> -	int i, num_frags = sinfo->nr_frags;
>  	struct sk_buff *skb;
> +	u8 num_frags;
> +	int i;
> +
> +	if (unlikely(xdp_buff_is_mb(xdp)))
> +		num_frags = sinfo->nr_frags;

Hi,
nit, it seems that the num_frags assignment can be moved after the 
other 'if' condition you added (right before the 'for' for 
num_frags), or even be eliminated completely so that 
sinfo->nr_frags is used directly.
Either way it looks like you can remove one 'if'.

Shay

>  
>  	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
>  	if (!skb)
> @@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct mvneta_port 
> *pp, struct page_pool *pool,
>  	skb_put(skb, xdp->data_end - xdp->data);
>  	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
>  
> +	if (likely(!xdp_buff_is_mb(xdp)))
> +		goto out;
> +
>  	for (i = 0; i < num_frags; i++) {
>  		skb_frag_t *frag = &sinfo->frags[i];
>  
> @@ -2341,6 +2353,7 @@ mvneta_swbm_build_skb(struct mvneta_port 
> *pp, struct page_pool *pool,
>  				skb_frag_size(frag), PAGE_SIZE);
>  	}
>  
> +out:
>  	return skb;
>  }

