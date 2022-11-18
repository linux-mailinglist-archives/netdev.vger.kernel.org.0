Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 898D162F682
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:44:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235271AbiKRNop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241574AbiKRNon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:44:43 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5206C781BB;
        Fri, 18 Nov 2022 05:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=OHv2PldMBepVVDAa5A0JeBaGKPLN9PMK5om1gj1ebDw=; b=iz4b8o5Xxospq1YOk7rNOn2xvx
        W5kXpYeRlHKZhzq4FuMm6INdH/g/isz00SgdqnxwK4LEvl7/bIkud/cfLuo/QJTsaMvd6GbGOLE09
        t37xgnsYQFHcoIba4e41VufAQT76vUncRywBdGw6hQMFzSpq9VomE6vuqtVBfp62L06Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ow1fF-002nYk-RN; Fri, 18 Nov 2022 14:44:17 +0100
Date:   Fri, 18 Nov 2022 14:44:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        mw@semihalf.com, linux@armlinux.org.uk, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yusongping@huawei.com
Subject: Re: [PATCH net v2] net: mdio-ipq4019: fix possible invalid pointer
 dereference
Message-ID: <Y3eMMc7maaPCKUNS@lunn.ch>
References: <20221117090514.118296-1-tanghui20@huawei.com>
 <Y3Y94/My9Al4pw+h@lunn.ch>
 <6cad3105-0e70-d890-162b-513855885fde@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6cad3105-0e70-d890-162b-513855885fde@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So, the code should be as follows, is that right?
> 
> +	void __iomem *devm_ioremap_resource_optional(struct device *dev,
> +                                    	     const struct resource *res)
> +	{
> +		void __iomem *base;
> +
> +		base = __devm_ioremap_resource(dev, res, DEVM_IOREMAP);
> +		if (IS_ERR(base) && PTR_ERR(base) == -ENOMEM)
> +			return NULL;
> +
> +		return base;
> +	}
> 
> 
> [...]
> 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> -	if (res)
> +	if (res) {
> +		priv->eth_ldo_rdy = devm_ioremap_resource_optional(&pdev->dev, res)
> +		if (IS_ERR(priv->eth_ldo_rdy))
> +			return PTR_ERR(priv->eth_ldo_rdy);
> +	}
> [...]

Yes, that is the basic concept.

The only thing i might change is the double meaning of -ENOMEM.
__devm_ioremap_resource() allocates memory, and if that memory
allocation fails, it returns -ENOMEM. If the resource does not exist,
it also returns -ENOMEM. So you cannot tell these two error conditions
apart. Most of the other get_foo() calls return -ENODEV if the
gpio/regulator/clock does not exist, so you can tell if you are out of
memory. But ioremap is specifically about memory so -ENOMEM actually
makes sense.

If you are out of memory, it seems likely the problem is not going to
go away quickly, so the next allocation will also fail, and hopefully
the error handling will then work. So i don't think it is major
issue. So yes, go with the code above.

      Andrew
