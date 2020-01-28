Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C048314CEB5
	for <lists+netdev@lfdr.de>; Wed, 29 Jan 2020 17:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgA2Q6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jan 2020 11:58:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:34494 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgA2Q6n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jan 2020 11:58:43 -0500
Received: from localhost (dhcp-077-249-119-090.chello.nl [77.249.119.90])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D98F914F07357;
        Wed, 29 Jan 2020 08:58:41 -0800 (PST)
Date:   Tue, 28 Jan 2020 10:54:23 +0100 (CET)
Message-Id: <20200128.105423.909425131743544201.davem@davemloft.net>
To:     thomas.egerer@secunet.com
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH net] xfrm: Interpret XFRM_INF as 32 bit value for
 non-ESN states
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8a3e5a49-5906-b6a6-beb7-0479bc64dcd0@secunet.com>
References: <8a3e5a49-5906-b6a6-beb7-0479bc64dcd0@secunet.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Jan 2020 08:58:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Egerer <thomas.egerer@secunet.com>
Date: Mon, 27 Jan 2020 15:31:14 +0100

> Currently, when left unconfigured, hard and soft packet limit are set to
> XFRM_INF ((__u64)~0). This can be problematic for non-ESN states, as
> their 'natural' packet limit is 2^32 - 1 packets. When reached, instead
> of creating an expire event, the states become unusable and increase
> their respective 'state expired' counter in the xfrm statistics. The
> only way for them to actually expire is based on their lifetime limits.
> 
> This patch reduces the packet limit of non-ESN states with XFRM_INF as
> their soft/hard packet limit to their maximum achievable sequence
> number in order to trigger an expire, which can then be used by an IKE
> daemon to reestablish the connection.
> 
> Signed-off-by: Thomas Egerer <thomas.egerer@secunet.com>

Please always CC: the ipsec maintainers for patches to IPSEC.

Steffen, I assume I will get this from you.

Thanks.

> ---
>  net/xfrm/xfrm_user.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
> index b88ba45..84d4008 100644
> --- a/net/xfrm/xfrm_user.c
> +++ b/net/xfrm/xfrm_user.c
> @@ -505,6 +505,13 @@ static void copy_from_user_state(struct xfrm_state *x, struct xfrm_usersa_info *
>  
>  	if (!x->sel.family && !(p->flags & XFRM_STATE_AF_UNSPEC))
>  		x->sel.family = p->family;
> +
> +	if ((x->props.flags & XFRM_STATE_ESN) == 0 {
> +		if (x->lft.soft_packet_limit == XFRM_INF)
> +			x->lft.soft_packet_limit == (__u32)~0;
> +		if (x->lft.hard_packet_limit == XFRM_INF)
> +			x->lft.hard_packet_limit == (__u32)~0;
> +	}
>  }
>  
>  /*
> -- 
> 2.6.4
> 
