Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CD46079C9
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbiJUOj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbiJUOj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:39:56 -0400
Received: from vps0.lunn.ch (unknown [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CEC4B0E1;
        Fri, 21 Oct 2022 07:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=D9L9gWEpqVSBkoML8PsO+P3x7+AWH1EUh92SK7KY3pI=; b=49jIcLnMiwuJE4tD9XSbawbmB/
        FlTXGg0PNbhAHZtw7MLLHh7r4VhO/o6+PWH/z73jgqoIE0pY4PhHvueaHneuKFtTddu3hl5oK5iar
        AgDV+G9JDLgWMxdCjOqupEEib4aZOPKg5M3/yKyrTZC1oZUnwag5TOHtsK4gVgvEeudc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oltBU-000F8B-6x; Fri, 21 Oct 2022 16:39:40 +0200
Date:   Fri, 21 Oct 2022 16:39:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v5 2/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Message-ID: <Y1KvLP39QFyvbARB@lunn.ch>
References: <20221021124556.100445-1-maxime.chevallier@bootlin.com>
 <20221021124556.100445-3-maxime.chevallier@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021124556.100445-3-maxime.chevallier@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NEUTRAL,SPF_NEUTRAL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int ipqess_axi_remove(struct platform_device *pdev)
> +{
> +	const struct net_device *netdev = platform_get_drvdata(pdev);
> +	struct ipqess *ess = netdev_priv(netdev);
> +
> +	ipqess_hw_stop(ess);
> +	unregister_netdev(ess->netdev);

Should the unregister come first? What happens if the network stack
tries to use the interface during/after ipqess_hw_stop()? It just
seems like it would be safer to first unregister the interface, and
then stop it?

> +struct ipqess_tx_desc {
> +	__le16  len;
> +	__le16  svlan_tag;
> +	__le32  word1;
> +	__le32  addr;
> +	__le32  word3;
> +} __aligned(16) __packed;
> +
> +struct ipqess_rx_desc {
> +	u16 rrd0;
> +	u16 rrd1;
> +	u16 rrd2;
> +	u16 rrd3;
> +	u16 rrd4;
> +	u16 rrd5;
> +	u16 rrd6;
> +	u16 rrd7;
> +} __aligned(16) __packed;

The TX descriptor is little endian, but the RX descriptor is host
endian?

	Andrew
