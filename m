Return-Path: <netdev+bounces-9685-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACF3E72A2ED
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 21:16:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 125681C21040
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 19:16:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA261951A;
	Fri,  9 Jun 2023 19:16:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94808408C0
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 19:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6914C433EF;
	Fri,  9 Jun 2023 19:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686338172;
	bh=roieoBhCqOAhqXezWmdmNJqktgkrmnYMvq3SKDINI7c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FTg3RTB1Maiq96w1flk1BdEIPR9CASdZmefm4Kml8J8jcvFlAsYJPIvkfi+34shnN
	 jM1PskIceHVcgBds1gAx2UXT0dcryX1iimA/BJSgVITwHM5qQpFfaYyYF4ozI5qaG+
	 eGvyjrK/qCfciuKhrk0n5okUBpsHeVCZhz57byYSIGTuw7dLwCodVv3QDPEQQ8Tdyg
	 yoz00QFllh1zrlgENEeMG4nFTm8iZR6zTrVr8rn9Ja5Z6ae+l62/ujkFqrxaUqw53O
	 a4Jpq0eAzeQt/Ec93ZeDmxVjnjoHDSYsx1Mvua1yBUR9SmPdzC7SCKrmtxsmozKEVu
	 67FNcaDqIY3hg==
Date: Fri, 9 Jun 2023 12:16:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
 dsahern@gmail.com
Subject: Re: [PATCH net-next 1/2] net: create device lookup API with
 reference tracking
Message-ID: <20230609121610.2d3edd22@kernel.org>
In-Reply-To: <CANn89iK1mhsEhvT_aitD-G8gEd4Pqo6bB3kHYFUDiRQmiM_Bhg@mail.gmail.com>
References: <20230609183207.1466075-1-kuba@kernel.org>
	<20230609183207.1466075-2-kuba@kernel.org>
	<CANn89iK1mhsEhvT_aitD-G8gEd4Pqo6bB3kHYFUDiRQmiM_Bhg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 9 Jun 2023 20:50:07 +0200 Eric Dumazet wrote:
> > -               dev = dev_get_by_index(net, ifindex);
> > +               dev = netdev_get_by_index(net, ifindex, &req_info->dev_tracker,
> > +                                         GFP_KERNEL);
> >                 if (!dev) {
> >                         NL_SET_ERR_MSG_ATTR(extack,
> >                                             tb[ETHTOOL_A_HEADER_DEV_INDEX],  
> 
> You forgot to change dev_put(dev) at line 126

Oh, good catch!

> Oh well, this would need GFP_ATOMIC, I guess this might be the reason
> you kept netdev_tracker_alloc()
> that can run after rcu_read_unlock()

Yes :(

