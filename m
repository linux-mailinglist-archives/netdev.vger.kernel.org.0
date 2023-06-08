Return-Path: <netdev+bounces-9384-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ABC0728A5D
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 401651C20FA4
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:43:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E38DA34CFC;
	Thu,  8 Jun 2023 21:43:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8638E34CC5
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:43:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B388C433EF;
	Thu,  8 Jun 2023 21:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686260582;
	bh=YGH2ApjTeXlWFZBF/1a8/IjBjOglKxu0ElYH1PlBcX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=duGWzXtYuCJ0cSrjbJMU4tR19+s6Gw5zNj7oD86B7FUCTpbOP9zVECeMEtU8MB+i8
	 YvOhS1KAXYZyf2g+x/twmHfdnPwcwhkUZqCxs+F/7PzojaiTYqyunuZQO1wTPqNhWq
	 LZdnRuGVd7ly3jX4MVXrAFlvxJX72rtd/cXWlk1Jweeuo7xdqmhk+mFqQXCvAeD6HL
	 doJ/L8wCNm3C0nULHsbK8B3KCtaCI55aPk97R/QfdX9rPwNcpxwvWoO1IQUOACp3sh
	 vblX6FUttt/uLhxkxGfM1aBWo923Sorj5OD23eZz2+/d1SMHzfo4nPzEfR+oekjCxN
	 QPKEyLcUcXxew==
Date: Thu, 8 Jun 2023 15:42:59 -0600
From: David Ahern <dsahern@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com
Subject: Re: [PATCH net] net: ethtool: correct MAX attribute value for stats
Message-ID: <20230608214259.GA19475@u2004-local>
References: <20230608162344.1210365-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608162344.1210365-1-kuba@kernel.org>

On Thu, Jun 08, 2023 at 09:23:44AM -0700, Jakub Kicinski wrote:
> When compiling YNL generated code compiler complains about
> array-initializer-out-of-bounds. Turns out the MAX value
> for STATS_GRP uses the value for STATS.
> 
> This may lead to random corruptions in user space (kernel
> itself doesn't use this value as it never parses stats).
> 
> Fixes: f09ea6fb1272 ("ethtool: add a new command for reading standard stats")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  include/uapi/linux/ethtool_netlink.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
> index 1ebf8d455f07..73e2c10dc2cc 100644
> --- a/include/uapi/linux/ethtool_netlink.h
> +++ b/include/uapi/linux/ethtool_netlink.h
> @@ -783,7 +783,7 @@ enum {
>  
>  	/* add new constants above here */
>  	__ETHTOOL_A_STATS_GRP_CNT,
> -	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_CNT - 1)
> +	ETHTOOL_A_STATS_GRP_MAX = (__ETHTOOL_A_STATS_GRP_CNT - 1)
>  };
>  
>  enum {
> -- 
> 2.40.1
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

