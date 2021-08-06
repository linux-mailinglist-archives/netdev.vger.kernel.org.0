Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DB23E3216
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 01:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244755AbhHFXWx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 19:22:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230280AbhHFXWw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 19:22:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96B2061158;
        Fri,  6 Aug 2021 23:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628292155;
        bh=C6ywIFcePa4Rg5+pKYASIbZl4SqTp+oziLoHdx7Hrco=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q9iCWQcw5s6RiIsyZ847VZIMq8WVPEEgek58P0pI7hRWotpKq5TH348eaO7wzJIZk
         O0d6J96F5tu097KlybmyZxdHWtf+jr+0Ce/GmMRC3pCVa9uwGS1IJxdg96En9eHCRq
         NfH0XP0cHulSofFC67dX3reaAS/VhrejllTBUfpMZ2IU8M7JSNY9prpfT6UubJdoux
         GZCaUDAl3ocFCa6U+TSQVX1ILxczc6GX5pcemzojLzIOSS8TIM22tMbLiupUO1WSJO
         cglm765PkDh1NMiJXQYbalZiT+TdykHdRFg4d384MfWbRIuYBvHz3sTDSQDwv2PxKG
         U1eOgSKWQgaBA==
Date:   Fri, 6 Aug 2021 16:22:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Martin Varghese <martin.varghese@nokia.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] bareudp: Fix invalid read beyond skb's linear data
Message-ID: <20210806162234.69334902@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com>
References: <7741c46545c6ef02e70c80a9b32814b22d9616b3.1628264975.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 6 Aug 2021 17:52:06 +0200 Guillaume Nault wrote:
> Data beyond the UDP header might not be part of the skb's linear data.
> Use skb_copy_bits() instead of direct access to skb->data+X, so that
> we read the correct bytes even on a fragmented skb.
> 
> Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS.")
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  drivers/net/bareudp.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index a7ee0af1af90..54e321a695ce 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -71,12 +71,18 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>  		family = AF_INET6;
>  
>  	if (bareudp->ethertype == htons(ETH_P_IP)) {
> -		struct iphdr *iphdr;
> +		__u8 ipversion;
>  
> -		iphdr = (struct iphdr *)(skb->data + BAREUDP_BASE_HLEN);
> -		if (iphdr->version == 4) {
> -			proto = bareudp->ethertype;
> -		} else if (bareudp->multi_proto_mode && (iphdr->version == 6)) {
> +		if (skb_copy_bits(skb, BAREUDP_BASE_HLEN, &ipversion,
> +				  sizeof(ipversion))) {

No preference just curious - could skb_header_pointer() be better suited?

> +			bareudp->dev->stats.rx_dropped++;
> +			goto drop;
> +		}
> +		ipversion >>= 4;
> +
> +		if (ipversion == 4) {
> +			proto = htons(ETH_P_IP);
> +		} else if (ipversion == 6 && bareudp->multi_proto_mode) {
>  			proto = htons(ETH_P_IPV6);
>  		} else {
>  			bareudp->dev->stats.rx_dropped++;

