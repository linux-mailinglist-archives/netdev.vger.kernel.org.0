Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BB92AFB7A
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgKKWiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:38:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbgKKWgS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:36:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB65F208B8;
        Wed, 11 Nov 2020 22:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605133553;
        bh=wsuDlpCkxMbDuHej5Dr+CbjaDQFm5Mhqmao2pqexM7Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ud4JmPX5VSFN56uuXkreh1EvlQX879v6vnulUTMyFLZimNfsLfkLD+LGbzphij16h
         /XumAnWyzWgdGy1pAB5JR4nzp/FuEDo4Hw/vohkxGMC6G6Ikh8KNRCIczx2fHwDx6X
         X4/BmvP+6rUPoK15tFNHKAvdQrv7rDG8BvlwvNhw=
Date:   Wed, 11 Nov 2020 14:25:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, raspl@linux.ibm.com
Subject: Re: [PATCH net-next v4 08/15] net/smc: Add ability to work with
 extended SMC netlink API
Message-ID: <20201111142551.6b975537@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109151814.15040-9-kgraul@linux.ibm.com>
References: <20201109151814.15040-1-kgraul@linux.ibm.com>
        <20201109151814.15040-9-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 16:18:07 +0100 Karsten Graul wrote:
> From: Guvenc Gulce <guvenc@linux.ibm.com>
> 
> smc_diag module should be able to work with legacy and
> extended netlink api. This is done by using the sequence field
> of the netlink message header. Sequence field is optional and was
> filled with a constant value MAGIC_SEQ in the current
> implementation.
> New constant values MAGIC_SEQ_V2 and MAGIC_SEQ_V2_ACK are used to
> signal the usage of the new Netlink API between userspace and
> kernel.
> 
> Signed-off-by: Guvenc Gulce <guvenc@linux.ibm.com>
> Signed-off-by: Karsten Graul <kgraul@linux.ibm.com>

> diff --git a/include/uapi/linux/smc_diag.h b/include/uapi/linux/smc_diag.h
> index 8cb3a6fef553..236c1c52d562 100644
> --- a/include/uapi/linux/smc_diag.h
> +++ b/include/uapi/linux/smc_diag.h
> @@ -6,6 +6,13 @@
>  #include <linux/inet_diag.h>
>  #include <rdma/ib_user_verbs.h>
>  
> +/* Sequence numbers */
> +enum {
> +	MAGIC_SEQ = 123456,
> +	MAGIC_SEQ_V2,
> +	MAGIC_SEQ_V2_ACK,
> +};
> +
>  /* Request structure */
>  struct smc_diag_req {
>  	__u8	diag_family;
> diff --git a/net/smc/smc_diag.c b/net/smc/smc_diag.c
> index 44be723c97fe..bc2b616524ff 100644
> --- a/net/smc/smc_diag.c
> +++ b/net/smc/smc_diag.c
> @@ -293,19 +293,24 @@ static int smc_diag_dump(struct sk_buff *skb, struct netlink_callback *cb)
>  	return skb->len;
>  }
>  
> +static int smc_diag_dump_ext(struct sk_buff *skb, struct netlink_callback *cb)
> +{
> +	return skb->len;
> +}
> +
>  static int smc_diag_handler_dump(struct sk_buff *skb, struct nlmsghdr *h)
>  {
>  	struct net *net = sock_net(skb->sk);
> -

Why did you drop the new line separating variables from code?

> +	struct netlink_dump_control c = {
> +		.min_dump_alloc = SKB_WITH_OVERHEAD(32768),
> +	};
>  	if (h->nlmsg_type == SOCK_DIAG_BY_FAMILY &&
>  	    h->nlmsg_flags & NLM_F_DUMP) {
> -		{
> -			struct netlink_dump_control c = {
> -				.dump = smc_diag_dump,
> -				.min_dump_alloc = SKB_WITH_OVERHEAD(32768),
> -			};
> -			return netlink_dump_start(net->diag_nlsk, skb, h, &c);
> -		}
> +		if (h->nlmsg_seq >= MAGIC_SEQ_V2)

This is not checked by the kernel, how do you know all user space
currently passes 123456?

Also, obviously, this is a rather weird abuse of sequence numbers.

Why don't you just add new attributes for new stuff you want to expose?
That's never mentioned anywhere, AFAICS.

> +			c.dump = smc_diag_dump_ext;
> +		else
> +			c.dump = smc_diag_dump;
> +		return netlink_dump_start(net->diag_nlsk, skb, h, &c);
>  	}
>  	return 0;
>  }

