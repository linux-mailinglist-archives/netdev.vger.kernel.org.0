Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E3136D94B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 16:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240156AbhD1OM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 10:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231375AbhD1OM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Apr 2021 10:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 269E86143E;
        Wed, 28 Apr 2021 14:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619619102;
        bh=JqXmB8zVNyXt71+iiCPZtiUidbF8eGCSLfw79Z1buCE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DgOlO1ukeDW/i4at6ahybTst2rUcsJxWEYrgQjjQOwjcfSjvrlYK63d2LOD5t17k9
         8iyDu8sAxdZSIAlevDUKcJk9vxYlJd8Sl0mEYLtvCEa2/ngGkAgcLR+8VWxgGSvvDO
         2WI9rGpZ15z3L+OIC1bSROFuL57IGDhWrlREWaoBrNMP66x4V9egJfj+IQvWSnQlFD
         MTGDvCw33qpgGFOTdUj1hyPnN/JO9nSFHta9zrnx6XZMGCkI9nagDi5eVPYUAO8e2s
         uxzxkHTagZpZISUYBWsD9qqF1tQzi0T+nXdjVwpwA0k0tu9jjfGz13BbnLnPwk2RvP
         dk5tNQw6SLlRA==
Date:   Wed, 28 Apr 2021 15:00:45 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Gal Pressman <galpress@amazon.com>
Cc:     David Ahern <dsahern@gmail.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Yossi Leybovich <sleybo@amazon.com>,
        Alexander Matushevsky <matua@amazon.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH iproute2-next 2/2] rdma: Add copy-on-fork to get sys
 command
Message-ID: <YIlObZNuu8TBxHLH@unreal>
References: <20210428114231.96944-1-galpress@amazon.com>
 <20210428114231.96944-3-galpress@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428114231.96944-3-galpress@amazon.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 28, 2021 at 02:42:31PM +0300, Gal Pressman wrote:
> The new attribute indicates that the kernel copies DMA pages on fork,
> hence fork support through madvise and MADV_DONTFORK is not needed.
> 
> If the attribute is not reported (expected on older kernels),
> copy-on-fork is disabled.
> 
> Example:
> $ rdma sys
> netns shared
> copy-on-fork on

I don't think that we need to print them on separate lines.
$ rdma sys
netns shared copy-on-fork on
> 
> Signed-off-by: Gal Pressman <galpress@amazon.com>
> ---
>  rdma/sys.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/rdma/sys.c b/rdma/sys.c
> index 8fb565d70598..dd9c6da33e2a 100644
> --- a/rdma/sys.c
> +++ b/rdma/sys.c
> @@ -38,6 +38,15 @@ static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
>  		print_color_string(PRINT_ANY, COLOR_NONE, "netns", "netns %s\n",
>  				   mode_str);
>  	}
> +
> +	if (tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK])
> +		print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork",
> +				   "copy-on-fork %s\n",
> +				   mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]));
> +	else
> +		print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork",
> +				   "copy-on-fork %s\n", false);

Let's simplify it
        bool cow = false;

 +	if (tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK])
 +		cow = mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_COPY_ON_FORK]);
 +
 +	print_color_on_off(PRINT_ANY, COLOR_NONE, "copy-on-fork", "copy-on-fork %s", cow);



> +
>  	return MNL_CB_OK;
>  }
>  
> -- 
> 2.31.1
> 
