Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF0549F139
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345516AbiA1Cr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:47:27 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54534 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345463AbiA1Cr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:47:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EABAB82355;
        Fri, 28 Jan 2022 02:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF486C340E4;
        Fri, 28 Jan 2022 02:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643338044;
        bh=xn+z77IqeoOQE8kwleftxoTkBBJ+JD/1YNW9n/lWJQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UTCEfi1bpvEfn2UmCspRrF8P3oEwHZA3xscYlC+BoAtt32f3vRUh+nWc3tll07MwL
         5IUwLkPdMBs90Ovzfbw9Iw1zBtEdS0dqp1FZn2U9n66/+lpLDi3CN0OxmqNy2t6VM1
         8fxDAuA3DtjEVqOx8vUaiog6GOz86oJDSVfekCy+H1AqcmHwL713ghKbxvDAXMhl0f
         Lj8xscAP4PsUfpUjH6kiCumcAXYFmWFV4vZpqzYbuVi/+GAEAiBvtK9EKR5PIaScsI
         4dhhx6wXSpPlC25RRHTDs++sd7Ckz/5L9x7RsjWop8cDZY1bEjLf4cXddkSJo3rQra
         JDdDZEsfGqarw==
Date:   Thu, 27 Jan 2022 18:47:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jay.vosburgh@canonical.com,
        nikolay@nvidia.com, huyd12@chinatelecom.cn
Subject: Re: [PATCH v10] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
Message-ID: <20220127184722.60cdb806@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220125142418.96167-1-sunshouxin@chinatelecom.cn>
References: <20220125142418.96167-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jan 2022 09:24:18 -0500 Sun Shouxin wrote:
> +/* determine if the packet is NA or NS */
> +static bool __alb_determine_nd(struct icmp6hdr *hdr)
> +{
> +	if (hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
> +	    hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION) {
> +		return true;
> +	}
> +
> +	return false;
> +}
> +
> +static bool alb_determine_nd(struct sk_buff *skb, struct bonding *bond)
> +{
> +	struct ipv6hdr *ip6hdr;
> +	struct icmp6hdr *hdr;
> +
> +	if (!pskb_network_may_pull(skb, sizeof(*ip6hdr)))
> +		return true;
> +
> +	ip6hdr = ipv6_hdr(skb);
> +	if (ip6hdr->nexthdr == IPPROTO_ICMPV6) {

	if (ip6hdr->nexthdr != IPPROTO_ICMPV6)
		return false;

This way there's no need to indent the rest of the function.

> +		if (!pskb_may_pull(skb, sizeof(*ip6hdr) + sizeof(*hdr)))

What happened to the _network part? pskb_network_may_pull(), right?

> +			return true;
> +
> +		hdr = icmp6_hdr(skb);
> +		return __alb_determine_nd(hdr);

Why create a full helper for this condition? Why not just:

	return hdr->icmp6_type == NDISC_NEIGHBOUR_ADVERTISEMENT ||
	       hdr->icmp6_type == NDISC_NEIGHBOUR_SOLICITATION;


> +	}
> +
> +	return false;
> +}
