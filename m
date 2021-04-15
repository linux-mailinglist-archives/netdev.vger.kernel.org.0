Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2557D3610A7
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 19:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234230AbhDORBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 13:01:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233343AbhDORBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 13:01:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 889DC61184;
        Thu, 15 Apr 2021 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618506050;
        bh=liXNTZnCkzuhEiIIgBEQvZ8id7S3X1/Oub3kGffMpUg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NhBtPZChHrVbGsYc2e3gCrr6wuG7th+ubUARKfoB2XbDAnu2YjFkwas+Zfj7mUzeP
         7sa+yFwz6fU91/cHMS7CuQ9P5xlgDI/s8o74wrmqJhzwd4H2qDVtAZpHC4c0rb1Z+a
         6av/2yQouJCq28O+8sjX9Th/Z636fAXevjM50dIOBLybCI976S/1ALY3SDUmnE/YOe
         Sro9qj42Jl3FNUjp64VXIq5blveL3zuDn6Jm5ZR7esN3YUoYrohGeWQtxi6io+pGv9
         WQ+8bWRFFvgvcHo8bgIdwhnqj38UjFhR3mNJ839PHP4DP2vmhCToriKPk5nKDH+t6s
         LPcBd+Fmt5IFA==
Date:   Thu, 15 Apr 2021 10:00:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "Cc : Steffen Klassert" <steffen.klassert@secunet.com>,
        Huy Nguyen <huyn@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH net 2/3] net/xfrm: Add inner_ipproto into sec_path
Message-ID: <20210415100049.7dde542d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210414232540.138232-3-saeed@kernel.org>
References: <20210414232540.138232-1-saeed@kernel.org>
        <20210414232540.138232-3-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 16:25:39 -0700 Saeed Mahameed wrote:
> +static void get_inner_ipproto(struct sk_buff *skb, struct sec_path *sp)
> +{
> +	const struct ethhdr *eth;
> +
> +	if (!skb->inner_protocol)
> +		return;
> +
> +	if (skb->inner_protocol_type == ENCAP_TYPE_IPPROTO) {
> +		sp->inner_ipproto = skb->inner_protocol;
> +		return;
> +	}
> +
> +	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER)
> +		return;
> +
> +	eth = (struct ethhdr *)skb_inner_mac_header(skb);
> +
> +	switch (eth->h_proto) {
> +	case ntohs(ETH_P_IPV6):
> +		sp->inner_ipproto = inner_ipv6_hdr(skb)->nexthdr;
> +		break;
> +	case ntohs(ETH_P_IP):
> +		sp->inner_ipproto = inner_ip_hdr(skb)->protocol;
> +		break;
> +	default:
> +		return;
> +	}
> +}

Bunch of sparse warnings here, please check.
