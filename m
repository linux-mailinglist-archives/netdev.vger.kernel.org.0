Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2622836A349
	for <lists+netdev@lfdr.de>; Sat, 24 Apr 2021 23:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbhDXVwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 17:52:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:52544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229778AbhDXVwp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 24 Apr 2021 17:52:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8665461152;
        Sat, 24 Apr 2021 21:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619301126;
        bh=o3OoMNK/IghjSJvhPQEmAGGIedBeMRwzlmyAYnWps8Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EOweIolik/yWko0S2h/Q61uCUd8E/yBaj8RJFO83bbUbnZNz6Ogf3vWn3FbdxRQbn
         3XmqipoPDEIBJMQV+0wbiXJC7vYVTFTrHdXhUR5ZnZRKD+1Qm7f8ugG7cIX8hGkmVU
         +S3DP9hiMx/rZATfRcN18JrXTqZzZXNTBXNIzcyFUWQ5OVNH9ixO/1PNkcrmRGnCxP
         9ZMUNLNU5NGkltkX4h9JKY8bxmiMq58AyvNF5w/m/K/etHbGAGPvkCreUaRZ6XZsil
         JUy8B38QoNy3Ra7xzxmDO+LDn/8t5s0uWbp50lW9NBklzWR6iylJbmiM3x4Ti7sHTY
         VDV7iDIxwFnRQ==
Date:   Sat, 24 Apr 2021 14:52:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, gospo@broadcom.com
Subject: Re: [PATCH net-next 10/10] bnxt_en: Implement
 .ndo_features_check().
Message-ID: <20210424145205.1bfbdb06@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1619295271-30853-11-git-send-email-michael.chan@broadcom.com>
References: <1619295271-30853-1-git-send-email-michael.chan@broadcom.com>
        <1619295271-30853-11-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Apr 2021 16:14:31 -0400 Michael Chan wrote:
> +	features = vlan_features_check(skb, features);
> +	if (!skb->encapsulation)
> +		return features;
> +
> +	switch (vlan_get_protocol(skb)) {
> +	case htons(ETH_P_IP):
> +		l4_proto = ip_hdr(skb)->protocol;
> +		break;
> +	case htons(ETH_P_IPV6):
> +		l4_proto = ipv6_hdr(skb)->nexthdr;
> +		break;
> +	default:
> +		return features;
> +	}
> +
> +	/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
> +	if (l4_proto == IPPROTO_UDP) {
> +		struct bnxt *bp = netdev_priv(dev);
> +		__be16 udp_port = udp_hdr(skb)->dest;
> +
> +		if (udp_port != bp->vxlan_port && udp_port != bp->nge_port)
> +			return features & ~(NETIF_F_CSUM_MASK |
> +					    NETIF_F_GSO_MASK);
> +	}
> +	return features;

This is still written a little too much like a block list.

What if, for example it's a UDP tunnel but with extension headers?
Is there any particular case that is served by not writing it as:

	if (l4_proto == UDP && (port == bp->vxl_port ||
				port == bp->nge_port))
		return features;
	return features & ~(CSUM | GSO);
?

Sorry for not realizing this earlier.
