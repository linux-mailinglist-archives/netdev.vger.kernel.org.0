Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C0F6E11E5
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjDMQMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjDMQMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:12:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E1D2A5F4;
        Thu, 13 Apr 2023 09:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FVYOgyseeRwqSgD/hQ55YdrmTythSIKHwgSAnZeA3F4=; b=1yo/qQX2G+yy8iamSXWUStlQTN
        rpTKb921ieMfljkLrBjS9JUuKkbLROmWK5Yyr8AtzmMBlFR4wzTC1zB+3pxKs39Zw4KiGHPRD/F8T
        xoIbvR3HqfU7AzdeEC2u7XyRU+DkCOicZIrzG1DeBijHN8ytg1LOJ9/vCzvMRID8NnyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmzYi-00ACn8-Jc; Thu, 13 Apr 2023 18:12:28 +0200
Date:   Thu, 13 Apr 2023 18:12:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ladislav Michl <oss-lists@triops.cz>
Cc:     linux-staging@lists.linux.dev, netdev@vger.kernel.org,
        linux-mips@vger.kernel.org,
        Chris Packham <chris.packham@alliedtelesis.co.nz>
Subject: Re: [PATCH 2/3] staging: octeon: avoid needless device allocation
Message-ID: <543bfbb6-af60-4b5d-abf8-0274ab0b713f@lunn.ch>
References: <ZDgNexVTEfyGo77d@lenoch>
 <ZDgOLHw1IkmWVU79@lenoch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZDgOLHw1IkmWVU79@lenoch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  	num_interfaces = cvmx_helper_get_number_of_interfaces();
>  	for (interface = 0; interface < num_interfaces; interface++) {
> +		int num_ports, port_index;
> +		const struct net_device_ops *ops;
> +		const char *name;
> +		phy_interface_t phy_mode = PHY_INTERFACE_MODE_NA;
>  		cvmx_helper_interface_mode_t imode =
> -		    cvmx_helper_interface_get_mode(interface);
> -		int num_ports = cvmx_helper_ports_on_interface(interface);
> -		int port_index;
> +			cvmx_helper_interface_get_mode(interface);
> +
> +		switch (imode) {
> +		case CVMX_HELPER_INTERFACE_MODE_NPI:
> +			ops = &cvm_oct_npi_netdev_ops;
> +			name = "npi%d";

In general, the kernel does not give the interface names other than
ethX. userspace can rename them, e.g. systemd with its persistent
names. So as part of getting this driver out of staging, i would throw
this naming code away.

> +		num_ports = cvmx_helper_ports_on_interface(interface);
>  		for (port_index = 0,
>  		     port = cvmx_helper_get_ipd_port(interface, 0);
>  		     port < cvmx_helper_get_ipd_port(interface, num_ports);
>  		     port_index++, port++) {
>  			struct octeon_ethernet *priv;
>  			struct net_device *dev =
> -			    alloc_etherdev(sizeof(struct octeon_ethernet));
> +				alloc_etherdev(sizeof(struct octeon_ethernet));

Please try to avoid white space changed. Put such white space changes
into a patch of their own, with a commit message saying it just
contains whitespace cleanup.


>  			if (!dev) {
>  				pr_err("Failed to allocate ethernet device for port %d\n",
>  				       port);
> @@ -830,7 +875,12 @@ static int cvm_oct_probe(struct platform_device *pdev)
>  			priv->port = port;
>  			priv->queue = cvmx_pko_get_base_queue(priv->port);
>  			priv->fau = fau - cvmx_pko_get_num_queues(port) * 4;
> -			priv->phy_mode = PHY_INTERFACE_MODE_NA;
> +			priv->phy_mode = phy_mode;

You should be getting phy_mode from DT.

Ideally, you want lots of small patches which are obviously
correct. So i would try to break this up into smaller changes.

I also wounder if you are addresses issues in the correct order. This
driver is in staging for a reason. It needs a lot of work. You might
be better off first cleaning it up. And then consider moving it to
phylink.

	 Andrew
