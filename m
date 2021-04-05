Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1BD835488D
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbhDEWPR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:15:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233052AbhDEWPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:15:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC00A61005;
        Mon,  5 Apr 2021 22:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617660908;
        bh=taMvKwtiyX/ytNA6YFmosFq1KcQlxPDQvCekn/DU0wo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a1z5BoqpHrPN9+qzgmOh58WEJtrUxAXRpK2TqiEvg33g0ZxifzPt9KIBaKme2z2Cq
         wr2CmW/ZFDi8uxW+ofIsyhHop03xm4Jw3NIRXWdx6SAwsOgRm491dEf39TtUq6VgQ3
         9OtfUEQJrnvDpi+sA9i4zeANpp6/duEVrWMnsmHKokXh2mQhrF6QbmOAWIPlpVphnI
         i50FOV7HrYUn/rRtUWazSxCmJY+/6A45EVOAev/9/DJpfyhKkNB4Quscuht6JQGrqA
         194rnY48SHhCvBMwmEW47I04mpork8DFvkjKXrRsF6LLDAYCBJ6ZPLolvMxR9Pn7hg
         SZm2zkqkleSQQ==
Date:   Mon, 5 Apr 2021 15:15:07 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Subject: Re: [PATCH] net: Allow to specify ifindex when device is moved to
 another namespace
Message-ID: <20210405151507.5b8879f1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210405071223.138101-1-avagin@gmail.com>
References: <20210402073622.1260310-1-avagin@gmail.com>
        <20210405071223.138101-1-avagin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  5 Apr 2021 00:12:23 -0700 Andrei Vagin wrote:
> Currently, we can specify ifindex on link creation. This change allows
> to specify ifindex when a device is moved to another network namespace.
> 
> Even now, a device ifindex can be changed if there is another device
> with the same ifindex in the target namespace. So this change doesn't
> introduce completely new behavior, it adds more control to the process.
> 
> CRIU users want to restore containers with pre-created network devices.
> A user will provide network devices and instructions where they have to
> be restored, then CRIU will restore network namespaces and move devices
> into them. The problem is that devices have to be restored with the same
> indexes that they have before C/R.
> 
> Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
> Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>

> @@ -2354,7 +2354,7 @@ static int netvsc_register_vf(struct net_device *vf_netdev)
>  	 */
>  	if (!net_eq(dev_net(ndev), dev_net(vf_netdev))) {
>  		ret = dev_change_net_namespace(vf_netdev,
> -					       dev_net(ndev), "eth%d");
> +					       dev_net(ndev), "eth%d", 0);

Given vast majority of callers pass 0 as the new param - perhaps
dev_change_net_namespace() should become a static inline wrapper
over a function with more parameters?

>  		if (ret)
>  			netdev_err(vf_netdev,
>  				   "could not move to same namespace as %s: %d\n",

> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 1bdcb33fb561..d51252afde0a 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -2266,6 +2266,9 @@ static int validate_linkmsg(struct net_device *dev, struct nlattr *tb[])
>  			return -EINVAL;
>  	}
>  
> +	if (tb[IFLA_NEW_IFINDEX] && nla_get_s32(tb[IFLA_NEW_IFINDEX]) <= 0)
> +		return -EINVAL;

I think you need to add IFLA_NEW_IFINDEX to ifla_policy, it used to be
an output only attribute, it's missing input validation. You can add
policy right there NLA_POLICY_MIN(NLA_S32, 0) - .min is 16 bit but it'd
get promoted correctly, I believe?

>  	if (tb[IFLA_AF_SPEC]) {
>  		struct nlattr *af;
>  		int rem, err;

