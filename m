Return-Path: <netdev+bounces-6466-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D8B15716639
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:08:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7992F1C20CE9
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:08:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC3F2415E;
	Tue, 30 May 2023 15:08:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D0417AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:08:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42DDC433D2;
	Tue, 30 May 2023 15:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685459283;
	bh=atU19E5ZqI+mbGrZ/FLjNQbQSHe+ozwX2f3ifK8RkQY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nd1bhVz2U0pD0hGPiOjcSlV2Y2D1hiYdG0UIjMfqW4DZMWlbn5IiGu6tFd25khzt3
	 gcdZMosDO+2qYBixXBrSU+DBtR6Shbjk+FjNoiym3nQsX7KuUwybA6gj40apJ+RKl9
	 fvZ6gtGnK1Xh19bWnireVarn95pxcxkp1JBWNNS/UxdKUnv2QTtoff+u4n4emS5R7b
	 vI75tuYlHqJ/TvZioygfqkXb79DnXvkOW/VMAUgs6y9uzYoWvgkamXP1zGpILeJPxr
	 xXKKVfu4YGMEiUxkBG/YkmdNQuoJ/1L5zb0nEHwIHScn8Ba2HU294LJhmWIxNBfhtx
	 A7vsuhpepmJ6A==
Message-ID: <eb6a1866-7c71-53c6-241f-0a38a4047f7e@kernel.org>
Date: Tue, 30 May 2023 09:08:01 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 3/4] nexthop: Do not return invalid nexthop
 object during multipath selection
Content-Language: en-US
To: Benjamin Poirier <bpoirier@nvidia.com>, netdev@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 Ido Schimmel <idosch@nvidia.com>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
 <20230529201914.69828-4-bpoirier@nvidia.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230529201914.69828-4-bpoirier@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/23 2:19 PM, Benjamin Poirier wrote:
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index c12acbf39659..ca501ced04fb 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1186,6 +1186,7 @@ static struct nexthop *nexthop_select_path_fdb(struct nh_group *nhg, int hash)
>  static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
>  {
>  	struct nexthop *rc = NULL;
> +	bool first = false;
>  	int i;
>  
>  	if (nhg->fdb_nh)
> @@ -1194,20 +1195,24 @@ static struct nexthop *nexthop_select_path_hthr(struct nh_group *nhg, int hash)
>  	for (i = 0; i < nhg->num_nh; ++i) {
>  		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
>  
> -		if (hash > atomic_read(&nhge->hthr.upper_bound))
> -			continue;
> -
>  		/* nexthops always check if it is good and does
>  		 * not rely on a sysctl for this behavior
>  		 */
> -		if (nexthop_is_good_nh(nhge->nh))
> -			return nhge->nh;
> +		if (!nexthop_is_good_nh(nhge->nh))
> +			continue;
>  
> -		if (!rc)
> +		if (!first) {

Setting 'first' and 'rc' are equivalent, so 'first' is not needed. As I
recall it was used in fib_select_multipath before the nexthop
refactoring (eba618abacade) because nhsel == 0 is valid, so the loop
could not rely on it.



>  			rc = nhge->nh;
> +			first = true;
> +		}
> +
> +		if (hash > atomic_read(&nhge->hthr.upper_bound))
> +			continue;
> +
> +		return nhge->nh;
>  	}
>  
> -	return rc;
> +	return rc ? : nhg->nh_entries[0].nh;
>  }
>  
>  static struct nexthop *nexthop_select_path_res(struct nh_group *nhg, int hash)



