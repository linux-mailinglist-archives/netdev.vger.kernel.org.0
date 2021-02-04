Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E54D30EA14
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhBDCVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234145AbhBDCVp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 21:21:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9A4464F51;
        Thu,  4 Feb 2021 02:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612405264;
        bh=z22fX17nBA76xdiYJKWJq/H/Bz0qshzVyPM92ooMce0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pfm9CyYyYWaYdEYYh20CxqlYeJu0d14qNT1y/zsxFd2FCw3Tszozv06Dwq7ijY+A+
         dBZjQ64UF1VJwi5amy6W9mn3lFp/uU4YgLe83IaUVDS0VBYz30whSGtoakrKcqNJWm
         oigRYEqG3nsRvLPibnMVUBR/T8Wekghdh7mfCaiQp3CV1UNHoGMkhGyBR/26YO4cQG
         6Bs++V87vvjO3iV6rePnJtaGTP3HNSddTRJWV8ZyX8dSjpGyThgVNbtyO9Yqm0mpz2
         0Lhgfp9GUZ3ORV73zQHgtNsMCCX0rqbtAnDuiJEpICc4ESP9TcmL9wkZ9Bab/6US2w
         rRCnMX2kh6DeA==
Date:   Wed, 3 Feb 2021 18:21:03 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     netdev@vger.kernel.org, idosch@nvidia.com,
        Yotam Gigi <yotam.gi@gmail.com>
Subject: Re: [PATCH net] net: psample: Fix the netlink skb length
Message-ID: <20210203182103.0f8350a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210203031028.171318-1-cmi@nvidia.com>
References: <20210203031028.171318-1-cmi@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  3 Feb 2021 11:10:28 +0800 Chris Mi wrote:
> Currently, the netlink skb length only includes metadata and data
> length. It doesn't include the psample generic netlink header length.

But what's the bug? Did you see oversized messages on the socket? Did
one of the nla_put() fail?

> Fixes: 6ae0a6286171 ("net: Introduce psample, a new genetlink channel for packet sampling")
> CC: Yotam Gigi <yotam.gi@gmail.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> Signed-off-by: Chris Mi <cmi@nvidia.com>
> ---
>  net/psample/psample.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/net/psample/psample.c b/net/psample/psample.c
> index 33e238c965bd..807d75f5a40f 100644
> --- a/net/psample/psample.c
> +++ b/net/psample/psample.c
> @@ -363,6 +363,7 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
>  	struct ip_tunnel_info *tun_info;
>  #endif
>  	struct sk_buff *nl_skb;
> +	int header_len;
>  	int data_len;
>  	int meta_len;
>  	void *data;
> @@ -381,12 +382,13 @@ void psample_sample_packet(struct psample_group *group, struct sk_buff *skb,
>  		meta_len += psample_tunnel_meta_len(tun_info);
>  #endif
>  
> +	/* psample generic netlink header size */
> +	header_len = nlmsg_total_size(GENL_HDRLEN + psample_nl_family.hdrsize);

GENL_HDRLEN is already included by genlmsg_new() and fam->hdrsize is 0
/ uninitialized for psample_nl_family. What am I missing? Ido?

>  	data_len = min(skb->len, trunc_size);
> -	if (meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
> -		data_len = PSAMPLE_MAX_PACKET_SIZE - meta_len - NLA_HDRLEN
> +	if (header_len + meta_len + nla_total_size(data_len) > PSAMPLE_MAX_PACKET_SIZE)
> +		data_len = PSAMPLE_MAX_PACKET_SIZE - header_len - meta_len - NLA_HDRLEN
>  			    - NLA_ALIGNTO;
> -
> -	nl_skb = genlmsg_new(meta_len + nla_total_size(data_len), GFP_ATOMIC);
> +	nl_skb = genlmsg_new(header_len + meta_len + nla_total_size(data_len), GFP_ATOMIC);
>  	if (unlikely(!nl_skb))
>  		return;
>  

