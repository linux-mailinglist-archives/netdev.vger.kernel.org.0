Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 173CB411144
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 10:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235965AbhITIrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 04:47:14 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:41607 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230488AbhITIrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 04:47:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1632127545; x=1663663545;
  h=references:from:to:cc:in-reply-to:date:message-id:
   mime-version:subject;
  bh=Plc447rOnwLbbiZzTvbrt3Upf5NEGhNTpdAwDVBvNqI=;
  b=Y+UnzZ+MMLTz5oZT8UibggrSJzmp7bWvCTo9x2g1lfUG9kz6UD/+1z/g
   fgQodGjtOR++G125vLPatt2msHc/MmkEXdEsX3PtP3/87673OJKF2wSVw
   ru7p5vCBmuwK4fGSOoC2a8v24obSNTKaw7UnofO4NU1cAA+73TXvlOIRd
   o=;
X-IronPort-AV: E=Sophos;i="5.85,307,1624320000"; 
   d="scan'208";a="148762280"
Subject: Re: [PATCH v14 bpf-next 03/18] net: mvneta: update mb bit before passing the
 xdp buffer to eBPF layer
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-42f764a0.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 20 Sep 2021 08:45:36 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-42f764a0.us-east-1.amazon.com (Postfix) with ESMTPS id 6029DC01A2;
        Mon, 20 Sep 2021 08:45:34 +0000 (UTC)
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.161.43) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.23; Mon, 20 Sep 2021 08:45:25 +0000
References: <cover.1631289870.git.lorenzo@kernel.org>
 <f11d8399e17bc82f9ffcb613da0a457a96f56fec.1631289870.git.lorenzo@kernel.org>
 <pj41zlh7ef8xgt.fsf@u570694869fb251.ant.amazon.com>
 <YUhIQEIJxLRPpaRP@lore-desk>
User-agent: mu4e 1.4.15; emacs 28.0.50
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
CC:     Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>,
        <john.fastabend@gmail.com>, <dsahern@kernel.org>,
        <brouer@redhat.com>, <echaudro@redhat.com>, <jasowang@redhat.com>,
        <alexander.duyck@gmail.com>, <saeed@kernel.org>,
        <maciej.fijalkowski@intel.com>, <magnus.karlsson@intel.com>,
        <tirthendu.sarkar@intel.com>, <toke@redhat.com>
In-Reply-To: <YUhIQEIJxLRPpaRP@lore-desk>
Date:   Mon, 20 Sep 2021 11:45:20 +0300
Message-ID: <pj41zlee9j8wkf.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.43]
X-ClientProxiedBy: EX13D13UWA001.ant.amazon.com (10.43.160.136) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo.bianconi@redhat.com> writes:

>> 
>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>> 
>> > ...
>> > diff --git a/drivers/net/ethernet/marvell/mvneta.c
>> > b/drivers/net/ethernet/marvell/mvneta.c
>> > index 9d460a270601..0c7b84ca6efc 100644
>> > --- a/drivers/net/ethernet/marvell/mvneta.c
>> > +++ b/drivers/net/ethernet/marvell/mvneta.c
>> > ...
>> > @@ -2320,8 +2325,12 @@ mvneta_swbm_build_skb(struct 
>> > mvneta_port *pp,
>> > struct page_pool *pool,
>> >  		      struct xdp_buff *xdp, u32 desc_status)
>> >  {
>> >  	struct skb_shared_info *sinfo = 
>> >  xdp_get_shared_info_from_buff(xdp);
>> > -	int i, num_frags = sinfo->nr_frags;
>> >  	struct sk_buff *skb;
>> > +	u8 num_frags;
>> > +	int i;
>> > +
>> > +	if (unlikely(xdp_buff_is_mb(xdp)))
>> > +		num_frags = sinfo->nr_frags;
>> 
>> Hi,
>> nit, it seems that the num_frags assignment can be moved after 
>> the other
>> 'if' condition you added (right before the 'for' for 
>> num_frags), or even be
>> eliminated completely so that sinfo->nr_frags is used directly.
>> Either way it looks like you can remove one 'if'.
>> 
>> Shay
>
> Hi Shay,
>
> we can't move nr_frags assignement after build_skb() since this 
> field will be
> overwritten by that call.
>
> Regards,
> Lorenzo
>

Sorry, silly mistake of me.

Guess this assignment can be done anyway since there doesn't seem 
to be new cache misses introduced by it.
Anyway, nice catch, sorry for misleading you

>> 
>> >  	skb = build_skb(xdp->data_hard_start, PAGE_SIZE);
>> >  	if (!skb)
>> > @@ -2333,6 +2342,9 @@ mvneta_swbm_build_skb(struct 
>> > mvneta_port *pp,
>> > struct page_pool *pool,
>> >  	skb_put(skb, xdp->data_end - xdp->data);
>> >  	skb->ip_summed = mvneta_rx_csum(pp, desc_status);
>> > +	if (likely(!xdp_buff_is_mb(xdp)))
>> > +		goto out;
>> > +
>> >  	for (i = 0; i < num_frags; i++) {
>> >  		skb_frag_t *frag = &sinfo->frags[i];
>> >   @@ -2341,6 +2353,7 @@ mvneta_swbm_build_skb(struct 
>> >   mvneta_port *pp,
>> > struct page_pool *pool,
>> >  				skb_frag_size(frag), PAGE_SIZE);
>> >  	}
>> > +out:
>> >  	return skb;
>> >  }
>> 

