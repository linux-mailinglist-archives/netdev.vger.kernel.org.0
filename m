Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021462A6FB9
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 22:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731114AbgKDVfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 16:35:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726434AbgKDVfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 16:35:51 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B04D20825;
        Wed,  4 Nov 2020 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604525750;
        bh=Mt2Ey+e0UYQXZSNwMWtoCIDU4GeJ9STTWWx++lonPvY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uPVQlJ0IYvp2Z9Va89J7khtBM/ovxhjCHv/W8GLdW4YupI07KaNbFi64L248M+TtS
         j62eNAzZ5fDvrD2bZIfWHwfZY0nGuJUjSI8rIlgzqgLqzV7M0UQ78owgG5iqbrRSH1
         o1HHb+C9B9efXyIkVCz25NeZdmXlSTu1p5JxL0Ik=
Date:   Wed, 4 Nov 2020 13:35:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dingtianhong@huawei.com,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH] net: macvlan: remove redundant initialization in
 macvlan_dev_netpoll_setup
Message-ID: <20201104133549.2fc0c0fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604490791-53825-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604490791-53825-1-git-send-email-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 06:53:11 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The initialization for err with 0 seems useless, as it is soon updated
> with -ENOMEM. So, we can init err with -ENOMEM.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> ---
>  drivers/net/macvlan.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index dd96020..a568b39 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -1096,10 +1096,9 @@ static int macvlan_dev_netpoll_setup(struct net_device *dev, struct netpoll_info
>  	struct macvlan_dev *vlan = netdev_priv(dev);
>  	struct net_device *real_dev = vlan->lowerdev;
>  	struct netpoll *netpoll;
> -	int err = 0;

Removing the ' = 0' would be better, let's keep the assignment of
-ENOMEM close to where it matters.

> +	int err = -ENOMEM;
>  
>  	netpoll = kzalloc(sizeof(*netpoll), GFP_KERNEL);
> -	err = -ENOMEM;
>  	if (!netpoll)
>  		goto out;
>  

