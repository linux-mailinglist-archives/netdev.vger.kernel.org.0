Return-Path: <netdev+bounces-6449-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F06B716565
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 16:58:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEE372811FA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E9623C86;
	Tue, 30 May 2023 14:57:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E4B17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E902C43446;
	Tue, 30 May 2023 14:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685458675;
	bh=73+UDU+unOjvtv62nEMnbe11+qS0aLNpOC7OKJDByuk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cUGo0sfQWnh++vJoqXTZWMmbnJ1ViMjHatQWO4giG+0BgEcGgIdGb5GjuTg/aazxA
	 ZioZGQXhHqm2+AVckkghW823303qX8kiZLDx68R/WsbJOGUbj/77kl5QBxQeYs1loU
	 FFjfHb9HfRwKElc8XcApE1V7eBJslWNq0LLyR/OUGqfc2lWht77tU2FoBmpNJbx2Vw
	 //VP0Yn9nvd9NoTNVIRU+tzj2XujJNfiXzCRdBNWxBk+a0ctYAXyZn/ku9JptwkKU5
	 TpBWuPfQkHPmrtuV9s8+U0yjqXGC9IRs1SqLm29wJj5aHbBjHl7WUVWW4rZKEbTYC8
	 RVHzRYjTFzQsw==
Message-ID: <d030c097-ac93-eed4-5bdd-11f902b16fca@kernel.org>
Date: Tue, 30 May 2023 08:57:54 -0600
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/4] nexthop: Factor out hash threshold fdb
 nexthop selection
Content-Language: en-US
To: Benjamin Poirier <bpoirier@nvidia.com>, netdev@vger.kernel.org
Cc: Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
 Ido Schimmel <idosch@nvidia.com>
References: <20230529201914.69828-1-bpoirier@nvidia.com>
 <20230529201914.69828-2-bpoirier@nvidia.com>
From: David Ahern <dsahern@kernel.org>
In-Reply-To: <20230529201914.69828-2-bpoirier@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/29/23 2:19 PM, Benjamin Poirier wrote:
> diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
> index f95142e56da0..27089dea0ed0 100644
> --- a/net/ipv4/nexthop.c
> +++ b/net/ipv4/nexthop.c
> @@ -1152,11 +1152,31 @@ static bool ipv4_good_nh(const struct fib_nh *nh)
>  	return !!(state & NUD_VALID);
>  }
>  
> +static struct nexthop *nexthop_select_path_fdb(struct nh_group *nhg, int hash)
> +{
> +	int i;
> +
> +	for (i = 0; i < nhg->num_nh; i++) {
> +		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
> +
> +		if (hash > atomic_read(&nhge->hthr.upper_bound))
> +			continue;
> +
> +		return nhge->nh;
> +	}
> +
> +	WARN_ON_ONCE(1);

I do not see how the stack is going to provide useful information; it
should always be vxlan_xmit ... nexthop_select_path_fdb, right?

besides that:
Reviewed-by: David Ahern <dsahern@kernel.org>



