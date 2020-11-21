Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A832BC23F
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 22:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbgKUVWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 16:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:42602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728402AbgKUVWG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 16:22:06 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B2EE2158C;
        Sat, 21 Nov 2020 21:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605993725;
        bh=e7ZuL5BeMskLyEE1VDz0qCWw/zrL13Gs0SlkViT39rw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EdcYa8fdnJFd1i1z7PzH9Gl3T4FmteoIkpQ8a9d0rarEAYwxA9q3W+EO4Zuh+86dn
         ZUYGYLd0FSacuiVPNrIvGzLhEwwFFzunuaqCWMXFYfK6E+7MyzzFYL/uUov4RBkocs
         nl/4vwIkdPWBzCnVeE+4ohDylYQ4fwG/baieIZ9U=
Date:   Sat, 21 Nov 2020 13:22:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: Re: [PATCH v4] aquantia: Remove the build_skb path
Message-ID: <20201121132204.43f9c4fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
        <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119221510.GI15137@breakpoint.cc>
        <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119222800.GJ15137@breakpoint.cc>
        <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119225842.GK15137@breakpoint.cc>
        <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 23:52:55 +0000 Ramsay, Lincoln wrote:
> When performing IPv6 forwarding, there is an expectation that SKBs
> will have some headroom. When forwarding a packet from the aquantia
> driver, this does not always happen, triggering a kernel warning.
> 
> aq_ring.c has this code (edited slightly for brevity):
> 
> if (buff->is_eop && buff->len <= AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {
>     skb = build_skb(aq_buf_vaddr(&buff->rxdata), AQ_CFG_RX_FRAME_MAX);
> } else {
>     skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
> 
> There is a significant difference between the SKB produced by these
> 2 code paths. When napi_alloc_skb creates an SKB, there is a certain
> amount of headroom reserved. However, this is not done in the
> build_skb codepath.
> 
> As the hardware buffer that build_skb is built around does not
> handle the presence of the SKB header, this code path is being
> removed and the napi_alloc_skb path will always be used. This code
> path does have to copy the packet header into the SKB, but it adds
> the packet data as a frag.
> 
> Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>

I was going to apply as a fix to net and stable but too many small nits
here to pass. First of all please add a From: line at the beginning of
the mail which matches the signoff (or use git-send-email, it'll get it
right).

> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> index 4f913658eea4..425e8e5afec7 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
> @@ -413,85 +413,64 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
>  					      buff->rxdata.pg_off,
>  					      buff->len, DMA_FROM_DEVICE);
>  
> -		/* for single fragment packets use build_skb() */
> -		if (buff->is_eop &&
> -		    buff->len <= AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {
> -			skb = build_skb(aq_buf_vaddr(&buff->rxdata),
> +		skb = napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);
> +		if (unlikely(!skb)) {
> +			u64_stats_update_begin(&self->stats.rx.syncp);
> +			self->stats.rx.skb_alloc_fails++;
> +			u64_stats_update_end(&self->stats.rx.syncp);
> +			err = -ENOMEM;
> +			goto err_exit;
> +		}
> +		if (is_ptp_ring)
> +			buff->len -=
> +				aq_ptp_extract_ts(self->aq_nic, skb,
> +					aq_buf_vaddr(&buff->rxdata),
> +					buff->len);

Align continuations of the lines under '(' like: 

  ./scripts/checkpatch.pl --max-line-length=80 --strict 

is asking you to.

> +		hdr_len = buff->len;
> +		if (hdr_len > AQ_CFG_RX_HDR_SIZE)
> +			hdr_len = eth_get_headlen(skb->dev,
> +							aq_buf_vaddr(&buff->rxdata),
> +							AQ_CFG_RX_HDR_SIZE);

ditto

> +		memcpy(__skb_put(skb, hdr_len), aq_buf_vaddr(&buff->rxdata),
> +			ALIGN(hdr_len, sizeof(long)));

And here, etc.

> +		if (buff->len - hdr_len > 0) {
> +			skb_add_rx_frag(skb, 0, buff->rxdata.page,
> +					buff->rxdata.pg_off + hdr_len,
> +					buff->len - hdr_len,

> +		if (!buff->is_eop) {
> +			buff_ = buff;
> +			i = 1U;
> +			do {
> +				next_ = buff_->next,

The end of this line should be a semicolon.

> +				buff_ = &self->buff_ring[next_];

Thanks!
