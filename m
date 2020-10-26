Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A0B2997E4
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 21:24:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731397AbgJZUYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 16:24:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731368AbgJZUYi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 16:24:38 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 87510207E8;
        Mon, 26 Oct 2020 20:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603743877;
        bh=INfT04YagxPwCUQS/ES/9gs9KqN/WO51F0pMbi77SHk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0m6jYe7LJr+jTYKY8f8ALqMSdzc76hA/3yyBVgoKqSUJpoVx4M3ptduhSb1CXjQDr
         rzVdorzvE1lsR2vdGyvBV3jZpRwm7g3MlRKtsI8OfN24DX6RgsL0R3yB9MMQ+i1nYb
         JTCERyZUGoBhYp2n2TrUcGGQLPHjBJwBX46E5XFc=
Date:   Mon, 26 Oct 2020 13:24:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <joe@perches.com>, <vvs@virtuozzo.com>, <davem@davemloft.net>,
        <lirongqing@baidu.com>, <roopa@cumulusnetworks.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 -next] neigh: Adjustment calculation method of
 neighbour path symbols
Message-ID: <20201026132436.3a57a98e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201026022126.117741-1-zhangqilong3@huawei.com>
References: <20201026022126.117741-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 10:21:26 +0800 Zhang Qilong wrote:
> Using size of "net//neigh/" is not clear, the use
> of stitching("net/" + /neigh") should be clearer.
> 
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> ---
>  net/core/neighbour.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 8e39e28b0a8d..0474e73c4f9f 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -3623,7 +3623,14 @@ int neigh_sysctl_register(struct net_device *dev, struct neigh_parms *p,
>  	int i;
>  	struct neigh_sysctl_table *t;
>  	const char *dev_name_source;
> -	char neigh_path[ sizeof("net//neigh/") + IFNAMSIZ + IFNAMSIZ ];
> +
> +	/*
> +	 * The path pattern is as follows
> +	 * "net/%s/neigh/%s", minusing one
> +	 * is for unnecessary terminators.
> +	 */
> +	char neigh_path[sizeof("net/") - 1 + IFNAMSIZ +
> +			sizeof("/neigh/") + IFNAMSIZ];

Let's leave this. The code is fine, the re-factoring is not worth the 
back an forth.

>  	char *p_name;
>  
>  	t = kmemdup(&neigh_sysctl_template, sizeof(*t), GFP_KERNEL);

