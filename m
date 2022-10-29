Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F68A6124D5
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 20:05:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbiJ2SFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Oct 2022 14:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJ2SFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Oct 2022 14:05:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253585E574;
        Sat, 29 Oct 2022 11:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cIEBjiUkjwY2/RXSadR0Q093zEVPDDLafBXGHZBqVlQ=; b=LKP0eO6yucSiPjDXHqw8qe57VP
        uofHmIpExXdbcGS8K/7g7pI9V0sMc1OvlsdvQW4fvgBve30elVuDqDyKFk5zq1l3WsKxeGYaXzsDQ
        KPBPgrPSNShdiTEq6BkU5devwhRq6+cIJyy0dlST/HnmFlCwEHwhuw17J5GSOSklJQ9I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ooqCi-000udm-FT; Sat, 29 Oct 2022 20:05:08 +0200
Date:   Sat, 29 Oct 2022 20:05:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v6 2/3] net: ethernet: renesas: Add support for "Ethernet
 Switch"
Message-ID: <Y11rVIKtUDf1i5xP@lunn.ch>
References: <20221028065458.2417293-1-yoshihiro.shimoda.uh@renesas.com>
 <20221028065458.2417293-3-yoshihiro.shimoda.uh@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028065458.2417293-3-yoshihiro.shimoda.uh@renesas.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +	for (i = 0; i < RSWITCH_NUM_PORTS; i++) {
> +		err = register_netdev(priv->rdev[i]->ndev);
> +		if (err) {
> +			for (i--; i >= 0; i--)
> +				unregister_netdev(priv->rdev[i]->ndev);
> +			goto err_register_netdev;
> +		}
> +	}
> +
> +	err = rswitch_ether_port_init_all(priv);
> +	if (err)
> +		goto err_ether_port_init_all;

As soon as you call register_netdev() the devices are active, and can
be in use. E.G. NFS root can start mounting the filesystem before
register_netdev() even returns. Is it safe to call driver operations
before rswitch_ether_port_init_all().

	Andrew
