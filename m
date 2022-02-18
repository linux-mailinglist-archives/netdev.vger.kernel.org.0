Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7514BB590
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 10:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233366AbiBRJ23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 04:28:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233364AbiBRJ21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 04:28:27 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB33C9A39
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 01:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3yN3Lb63PBBx1XnDNBVt6J8RKbv23CammN/V+OEYSCI=; b=y9PwkHNl5YWHYMrYuz0vpzJHrd
        hN6ktdbztxv5EoXQDx6/o9jJvTeCW9ja5e4IitVpOEyPcXEaTeq0YfnB/FpG/2dG9GtpES1WHkbtu
        Hq52DPuZUs7l1/KfER27N7h+PAYOHG2DaJT58pfI+rRegZVVJ+1MlmVqgarRRN9/gQSo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nKzYd-006TWw-Ha; Fri, 18 Feb 2022 10:28:07 +0100
Date:   Fri, 18 Feb 2022 10:28:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: OF-ware slave_mii_bus
Message-ID: <Yg9mpxc9Var4xJLq@lunn.ch>
References: <20220218062147.7672-1-luizluca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220218062147.7672-1-luizluca@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 18, 2022 at 03:21:47AM -0300, Luiz Angelo Daros de Luca wrote:
> If found, register the DSA internally allocated slave_mii_bus with an OF
> "mdio" child object. It can save some drivers from creating their
> custom internal MDIO bus.

> @@ -924,7 +926,10 @@ static int dsa_switch_setup(struct dsa_switch *ds)
>  
>  		dsa_slave_mii_bus_init(ds);
>  
> -		err = mdiobus_register(ds->slave_mii_bus);
> +		dn = of_get_child_by_name(ds->dev->of_node, "mdio");
> +
> +		err = of_mdiobus_register(ds->slave_mii_bus, dn);
> +		of_node_put(dn);

This makes sense, but please update the binding document to include this:

Documentation/devicetree/bindings/net/dsa/dsa.yaml

	Andrew
