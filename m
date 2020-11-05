Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663EE2A73E5
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 01:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387445AbgKEAip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 19:38:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:50538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726608AbgKEAip (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 19:38:45 -0500
Received: from sx1.lan (c-24-6-56-119.hsd1.ca.comcast.net [24.6.56.119])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1FC202080D;
        Thu,  5 Nov 2020 00:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604536724;
        bh=sjNjOJHO0NGjiUqAB0P25+fWUu6Ubi1Y9pli2T2hipk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=SeyXtvLkjuSU2kk/gDAxvzF9kiB7shbkzwC+VR8GUTCwyIBQT0dK8nMP41TERAJrP
         PUfjVd/2fWZ9uEoGoSlBEM6gA+GuJGoa0Fmns3cEWfbSoxl6oMk5oaBRgrPZWLYdBn
         v7e4YC2qm03mpWubbXGYLp81wO4h8AFxwFQUgjgc=
Message-ID: <c8f7ec13a4a64e258ad07a7029551ea6f6d21df2.camel@kernel.org>
Subject: Re: [net-next 09/12] net/mlx5e: Validate stop_room size upon user
 input
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Vladyslav Tarasiuk <vladyslavt@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Date:   Wed, 04 Nov 2020 16:38:43 -0800
In-Reply-To: <20201104140256.1b65e751@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201103194738.64061-1-saeedm@nvidia.com>
         <20201103194738.64061-10-saeedm@nvidia.com>
         <20201104140256.1b65e751@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-11-04 at 14:02 -0800, Jakub Kicinski wrote:
> On Tue, 3 Nov 2020 11:47:35 -0800 Saeed Mahameed wrote:
> > From: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> > 
> > Stop room is a space that may be taken by WQEs in the SQ during a
> > packet
> > transmit. It is used to check if next packet has enough room in the
> > SQ.
> > Stop room guarantees this packet can be served and if not, the
> > queue is
> > stopped, so no more packets are passed to the driver until it's
> > ready.
> > 
> > Currently, stop_room size is calculated and validated upon tx
> > queues
> > allocation. This makes it impossible to know if user provided valid
> > input for certain parameters when interface is down.
> > 
> > Instead, store stop_room in mlx5e_sq_param and create
> > mlx5e_validate_params(), to validate its fields upon user input
> > even
> > when the interface is down.
> > 
> > Signed-off-by: Vladyslav Tarasiuk <vladyslavt@nvidia.com>
> > Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> 32 bit build wants you to use %zd or such: 
> 

We do not test 32 bit. Will fix this,
Thanks.

> drivers/net/ethernet/mellanox/mlx5/core/en/params.c: In function
> ‘mlx5e_validate_params’:
> drivers/net/ethernet/mellanox/mlx5/core/en/params.c:182:72: warning:
> format ‘%lu’ expects argument of type ‘long unsigned int’, but
> argument 4 has type ‘size_t’ {aka ‘unsigned int’} [-Wformat=]
>   182 |   netdev_err(priv->netdev, "Stop room %hu is bigger than the
> SQ size %lu\n",
>       |                                                              
>         ~~^
>       |                                                              
>           |
>       |                                                              
>           long unsigned int
>       |                                                              
>         %u
>   183 |       stop_room, sq_size);
>       |                  ~~~~~~~                                     
>            
>       |                  |
>       |                  size_t {aka unsigned int}

