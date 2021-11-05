Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 862B1446B3C
	for <lists+netdev@lfdr.de>; Sat,  6 Nov 2021 00:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbhKEXcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 19:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229917AbhKEXcY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 19:32:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A63B060F21;
        Fri,  5 Nov 2021 23:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636154983;
        bh=sLf3jqks+AykbgrZ3CMM39szmLwmwF8FxvsdqYSCW2I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gLtXiYoASD3tLg2TvNlG1R+l7n8gb5YrxHFYXpFbvCTgOxouWJ93EV3PzbjCHyg0p
         h85tf3Ah5nbJd+Otm3rQ7J7INBXyu5IM2CwWHzhVbsQjzMv5IT7ySX1rAeySR6BlZO
         Z+ytFTA5jiQW0G1JlDhE+j1+32p535Ci7LppeGHcKCfSBNTcKYoNvZz2JaeOcS+ajs
         OQmtzBj8HuAvXlHkQDCov0UBtRV8x/UetISDGW7ier5RViIjuJtZ/PfyVNJGh2MNpt
         oVTtsnFIDs5dNZ9yiAdM8REYrmQKG3fGmcaIVzVVrX8v8DL3vzozdx9bxCDGPjS/J1
         WeBAVHvph3SyQ==
Date:   Fri, 5 Nov 2021 16:29:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, john.fastabend@gmail.com,
        dsahern@kernel.org, brouer@redhat.com, echaudro@redhat.com,
        jasowang@redhat.com, alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com, toke@redhat.com
Subject: Re: [PATCH v17 bpf-next 12/23] bpf: add multi-buff support to the
 bpf_xdp_adjust_tail() API
Message-ID: <20211105162941.46b807e5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
References: <cover.1636044387.git.lorenzo@kernel.org>
        <fd0400802295a87a921ba95d880ad27b9f9b8636.1636044387.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 18:35:32 +0100 Lorenzo Bianconi wrote:
> This change adds support for tail growing and shrinking for XDP multi-buff.
> 
> When called on a multi-buffer packet with a grow request, it will always
> work on the last fragment of the packet. So the maximum grow size is the
> last fragments tailroom, i.e. no new buffer will be allocated.
> 
> When shrinking, it will work from the last fragment, all the way down to
> the base buffer depending on the shrinking size. It's important to mention
> that once you shrink down the fragment(s) are freed, so you can not grow
> again to the original size.

> +static int bpf_xdp_mb_increase_tail(struct xdp_buff *xdp, int offset)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	skb_frag_t *frag = &sinfo->frags[sinfo->nr_frags - 1];
> +	int size, tailroom;
> +
> +	tailroom = xdp->frame_sz - skb_frag_size(frag) - skb_frag_off(frag);

I know I complained about this before but the assumption that we can
use all the space up to xdp->frame_sz makes me uneasy.

Drivers may not expect the idea that core may decide to extend the 
last frag.. I don't think the skb path would ever do this.

How do you feel about any of these options: 
 - dropping this part for now (return an error for increase)
 - making this an rxq flag or reading the "reserved frag size"
   from rxq (so that drivers explicitly opt-in)
 - adding a test that can be run on real NICs
?

> +static int bpf_xdp_mb_shrink_tail(struct xdp_buff *xdp, int offset)
> +{
> +	struct skb_shared_info *sinfo = xdp_get_shared_info_from_buff(xdp);
> +	int i, n_frags_free = 0, len_free = 0, tlen_free = 0;
> +
> +	if (unlikely(offset > ((int)xdp_get_buff_len(xdp) - ETH_HLEN)))

nit: outer parens unnecessary

> +		return -EINVAL;


> @@ -371,6 +371,7 @@ static void __xdp_return(void *data, struct xdp_mem_info *mem, bool napi_direct,
>  		break;
>  	}
>  }
> +EXPORT_SYMBOL_GPL(__xdp_return);

Why the export?
