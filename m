Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8607E25B9F
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 03:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbfEVBWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:22:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726703AbfEVBW3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 May 2019 21:22:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=F/vekzvwEmTmUVLJ188rgE4OvEloUFG1J7wMKhPC69I=; b=E2S5XFswpOJLwfXb5tmiYPkUs7
        RosQSFSVBV8sdwA/hy0smQCGDPmCI05Ftex3ylIQnA3Jds0Yyg6nGdFDB5ICHgLbL3qQpgyGyf1do
        8kx7ObANAsmq9fRX5CcgvZTZ+NWulSB+XhVEBTdoZON+OuG7IRYA4nXaL8uqdQIFIBic=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTFxb-0000EC-GO; Wed, 22 May 2019 03:22:27 +0200
Date:   Wed, 22 May 2019 03:22:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 5/6] net: mdio: of: Register discovered MII
 time stampers.
Message-ID: <20190522012227.GA734@lunn.ch>
References: <20190521224723.6116-6-richardcochran@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521224723.6116-6-richardcochran@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +struct mii_timestamper *of_find_mii_timestamper(struct device_node *node)
> +{
> +	struct of_phandle_args arg;
> +	int err;
> +
> +	err = of_parse_phandle_with_fixed_args(node, "timestamper", 1, 0, &arg);
> +
> +	if (err == -ENOENT)
> +		return NULL;
> +	else if (err)
> +		return ERR_PTR(err);
> +
> +	if (arg.args_count != 1)
> +		return ERR_PTR(-EINVAL);
> +
> +	return register_mii_timestamper(arg.np, arg.args[0]);
> +}
> +
>  static int of_mdiobus_register_phy(struct mii_bus *mdio,
>  				    struct device_node *child, u32 addr)
>  {
> +	struct mii_timestamper *mii_ts;
>  	struct phy_device *phy;
>  	bool is_c45;
>  	int rc;
>  	u32 phy_id;
>  
> +	mii_ts = of_find_mii_timestamper(child);
> +	if (IS_ERR(mii_ts))
> +		return PTR_ERR(mii_ts);
> +
>  	is_c45 = of_device_is_compatible(child,
>  					 "ethernet-phy-ieee802.3-c45");
>  

Hi Richard

There can be errors after this, e.g. of_irq_get() returns
-EPROBE_DEFER, or from phy_device_register().

Shouldn't unregister_mii_timestamper() be called on error?

	  Andrew
