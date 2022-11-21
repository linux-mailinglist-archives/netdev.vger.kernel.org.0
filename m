Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4294D632542
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 15:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229930AbiKUONh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 09:13:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiKUONP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 09:13:15 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6CA11C2C;
        Mon, 21 Nov 2022 06:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hmcYM8Hy3CsFIKQSfVLJ79ErmXZM58kJ44FUCnY1kW0=; b=vDBAOB6+F/VIwIT/223EtnfdKQ
        EBUd2uqXhjPbufQFAeM5C7ObvnVc9RAdFun7OGtqWmbp6JCmuKS04ptVf2EnzbuCNSI04UUh8qheA
        n9oqnNZgqMAdZhwnZg2N3hKxW1en1TtIE257rZI8Gq//KYk2XtfaezwCLXii9oggPUVQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ox7V4-0030yn-9U; Mon, 21 Nov 2022 15:10:18 +0100
Date:   Mon, 21 Nov 2022 15:10:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_id()
Message-ID: <Y3uGyrxeSbajJqpr@lunn.ch>
References: <20221121075618.15877-1-korotkov.maxim.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121075618.15877-1-korotkov.maxim.s@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 21, 2022 at 10:56:18AM +0300, Maxim Korotkov wrote:
> The value of an arithmetic expression "n * id.data" is subject
> to possible overflow due to a failure to cast operands to a larger data
> type before performing arithmetic. Added cast of first operand to u64
> for avoiding overflow.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 2adc6edcaec0 ("ethtool: fix error handling in ethtool_phys_id")
> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
> ---
>  net/ethtool/ioctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> index 6a7308de192d..cf87e53c2e74 100644
> --- a/net/ethtool/ioctl.c
> +++ b/net/ethtool/ioctl.c
> @@ -2007,7 +2007,7 @@ static int ethtool_phys_id(struct net_device *dev, void __user *useraddr)
>  	} else {
>  		/* Driver expects to be called at twice the frequency in rc */
>  		int n = rc * 2, interval = HZ / n;
> -		u64 count = n * id.data, i = 0;
> +		u64 count = (u64)n * id.data, i = 0;


How about moving the code around a bit, change n to a u64 and drop the
cast? Does this look correct?

		int interval = HZ / rc / 2;
		u64 n = rc * 2;
		u64 count = n * id.data;

		i = 0;

I just don't like casts, they suggest the underlying types are wrong,
so should fix that, not add a cast.

	Andrew
