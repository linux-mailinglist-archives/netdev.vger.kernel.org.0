Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D52B7315
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727423AbgKRA3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:29:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726992AbgKRA3y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Nov 2020 19:29:54 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D80E62223D;
        Wed, 18 Nov 2020 00:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605659394;
        bh=r8XAimaONr7zbCURlQv+7ePgRFrgF4MHkAemhqIUE2k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ew49X7tSK4BPNvFiaTGIXEiKlCgg9UUIDboi1LHg+8kMO0Beis37Wp+l61GoRIyeu
         8SMOJhWPEIRnmCelYUSlFAIVTtzQ/A6JxHRwi/CThDobyWZGWOmfzGo69DXQFHm5rJ
         KHVGvX9Kh9DIrBODNSVhaJUoDrFtOGlns0IdeFhw=
Date:   Tue, 17 Nov 2020 16:29:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        davem@davemloft.net, gnault@redhat.com, pabeni@redhat.com,
        lorenzo@kernel.org
Subject: Re: [PATCH net-next] ip_gre: remove CRC flag from dev features in
 gre_gso_segment
Message-ID: <20201117162952.29c1a699@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
References: <52ee1b515df977b68497b1b08290d00a22161279.1605518147.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 17:15:47 +0800 Xin Long wrote:
> This patch is to let it always do CRC checksum in sctp_gso_segment()
> by removing CRC flag from the dev features in gre_gso_segment() for
> SCTP over GRE, just as it does in Commit 527beb8ef9c0 ("udp: support
> sctp over udp in skb_udp_tunnel_segment") for SCTP over UDP.
> 
> It could set csum/csum_start in GSO CB properly in sctp_gso_segment()
> after that commit, so it would do checksum with gso_make_checksum()
> in gre_gso_segment(), and Commit 622e32b7d4a6 ("net: gre: recompute
> gre csum for sctp over gre tunnels") can be reverted now.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Makes sense, but does GRE tunnels don't always have a csum.

Is the current hardware not capable of generating CRC csums over
encapsulated patches at all?

I guess UDP tunnels can be configured without the csums as well 
so the situation isn't much different.

> diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
> index e0a2465..a5935d4 100644
> --- a/net/ipv4/gre_offload.c
> +++ b/net/ipv4/gre_offload.c
> @@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>  				       netdev_features_t features)
>  {
>  	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
> -	bool need_csum, need_recompute_csum, gso_partial;
>  	struct sk_buff *segs = ERR_PTR(-EINVAL);
>  	u16 mac_offset = skb->mac_header;
>  	__be16 protocol = skb->protocol;
>  	u16 mac_len = skb->mac_len;
>  	int gre_offset, outer_hlen;
> +	bool need_csum, gso_partial;

Nit, rev xmas tree looks broken now.

>  	if (!skb->encapsulation)
>  		goto out;
> @@ -41,10 +41,10 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>  	skb->protocol = skb->inner_protocol;
>  
>  	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
> -	need_recompute_csum = skb->csum_not_inet;
>  	skb->encap_hdr_csum = need_csum;
>  
>  	features &= skb->dev->hw_enc_features;
> +	features &= ~NETIF_F_SCTP_CRC;
>  
>  	/* segment inner packet. */
>  	segs = skb_mac_gso_segment(skb, features);
> @@ -99,15 +99,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
>  		}
>  
>  		*(pcsum + 1) = 0;
> -		if (need_recompute_csum && !skb_is_gso(skb)) {
> -			__wsum csum;
> -
> -			csum = skb_checksum(skb, gre_offset,
> -					    skb->len - gre_offset, 0);
> -			*pcsum = csum_fold(csum);
> -		} else {
> -			*pcsum = gso_make_checksum(skb, 0);
> -		}
> +		*pcsum = gso_make_checksum(skb, 0);
>  	} while ((skb = skb->next));
>  out:
>  	return segs;

