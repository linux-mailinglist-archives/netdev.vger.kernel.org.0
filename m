Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F83F324419
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 19:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhBXSyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 13:54:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:36402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235091AbhBXSx0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Feb 2021 13:53:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61CE164F6E;
        Wed, 24 Feb 2021 18:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614192446;
        bh=1NA7qcES3t/vO/ZkcZZXDfpfXyYaG6cYJqooPeHG5x4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IrCqghMeogb8DwA4gyWpcqutctX/5RDC4hILQs9TpSAvmDZWz/oDdTxr3ITHIPvd5
         wZ+MD3P0NApKP7xIW83XF9iC78MZUgjusdH0y/DlWZH5nXPzuJkWMN2oMPWsjDmVCB
         tzm01bY3+knwPp/qAJ7I8pxf0DwIAzsfxk+85dMqx1X1s/Nr1q7aCPdQFCU/arFEzT
         fESaXX2ulv0uU/QtIuFdy7OI57Z6CgLIAsv+AliKNFmrH2oWR5/3+yjMeHwR9wgwP0
         vcEM4pqb1pdHdPJbsi5da2wEo81PW4BPE424g17LKnwJvULr/y5Nt6q0f1gY+5Ve09
         S+M28Hg+h1FAA==
Date:   Wed, 24 Feb 2021 10:47:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>
Cc:     Kaustubh Pandey <kapandey@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sharathv@codeaurora.org,
        chinagar@codeaurora.org
Subject: Re: [PATCH] ipv6: Honor route mtu if it is within limit of dev mtu
Message-ID: <20210224104721.6a86d972@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1614011555-21951-1-git-send-email-kapandey@codeaurora.org>
References: <1614011555-21951-1-git-send-email-kapandey@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 22:02:35 +0530 Kaustubh Pandey wrote:
> When netdevice MTU is increased via sysfs, NETDEV_CHANGEMTU is raised.
> 
> addrconf_notify -> rt6_mtu_change -> rt6_mtu_change_route ->
> fib6_nh_mtu_change
> 
> As part of handling NETDEV_CHANGEMTU notification we land up on a
> condition where if route mtu is less than dev mtu and route mtu equals
> ipv6_devconf mtu, route mtu gets updated.
> 
> Due to this v6 traffic end up using wrong MTU then configured earlier.
> This commit fixes this by removing comparison with ipv6_devconf
> and updating route mtu only when it is greater than incoming dev mtu.
> 
> This can be easily reproduced with below script:
> pre-condition:
> device up(mtu = 1500) and route mtu for both v4 and v6 is 1500
> 
> test-script:
> ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1400
> ip -6 route change 2001::/64 dev eth0 metric 256 mtu 1400
> echo 1400 > /sys/class/net/eth0/mtu
> ip route change 192.168.0.0/24 dev eth0 src 192.168.0.1 mtu 1500
> echo 1500 > /sys/class/net/eth0/mtu
> 
> Signed-off-by: Kaustubh Pandey <kapandey@codeaurora.org>
> ---
>  net/ipv6/route.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 1536f49..653b6c7 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4813,8 +4813,7 @@ static int fib6_nh_mtu_change(struct fib6_nh *nh, void *_arg)
>  		struct inet6_dev *idev = __in6_dev_get(arg->dev);
>  		u32 mtu = f6i->fib6_pmtu;
>  
> -		if (mtu >= arg->mtu ||
> -		    (mtu < arg->mtu && mtu == idev->cnf.mtu6))
> +		if (mtu >= arg->mtu)
>  			fib6_metric_set(f6i, RTAX_MTU, arg->mtu);
>  
>  		spin_lock_bh(&rt6_exception_lock);

David, Hideaki - any thoughts on this one? Can we change this long
standing behavior?
