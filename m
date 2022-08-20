Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608E659AF74
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 20:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbiHTSQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 14:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbiHTSQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 14:16:42 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EF017071;
        Sat, 20 Aug 2022 11:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=t0pyLnK8OrpfhUWATUbAE+IWUhh8PnntBsAGRXSYTts=; b=IhbwOvYcpUK7EBUTNf020L0ywn
        KVC7WewJWw/Euj8lPlka2wIdLliFsuH3Qf3eMjYcLmYjSJvqacfqOV+4xulGbljEViFxivPWITHti
        i+2jVOYLuWoNriMiI32kVue9YpeQ4Vm2ptXTtuEHZwpXhwMGX6pMqSvKq4ScuGNXiF4c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oPT18-00E3jH-DP; Sat, 20 Aug 2022 20:16:18 +0200
Date:   Sat, 20 Aug 2022 20:16:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 7/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <YwEk8h9C9XhT6Yyc@lunn.ch>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-8-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220819120109.3857571-8-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 02:01:09PM +0200, Oleksij Rempel wrote:
> Add interface to support Power Sourcing Equipment. At current step it
> provides generic way to address all variants of PSE devices as defined
> in IEEE 802.3-2018 but support only objects specified for IEEE 802.3-2018 104.4
> PoDL Power Sourcing Equipment (PSE).
> 
> Currently supported and mandatory objects are:
> IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatus
> IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
> IEEE 802.3-2018 30.15.1.2.1 acPoDLPSEAdminControl
> 
> This is minimal interface needed to control PSE on each separate
> ethernet port but it provides not all mandatory objects specified in
> IEEE 802.3-2018.

> +static int pse_get_pse_attributs(struct net_device *dev,
> +				 struct pse_reply_data *data)
> +{
> +	struct phy_device *phydev = dev->phydev;
> +	int ret;
> +
> +	if (!phydev)
> +		return -EOPNOTSUPP;
> +
> +	mutex_lock(&phydev->lock);
> +	if (!phydev->psec) {
> +		ret = -EOPNOTSUPP;
> +		goto error_unlock;
> +	}
> +
> +	ret = pse_podl_get_admin_sate(phydev->psec);
> +	if (ret < 0)
> +		goto error_unlock;
> +
> +	data->podl_pse_admin_state = ret;
> +
> +	ret = pse_podl_get_pw_d_status(phydev->psec);
> +	if (ret < 0)
> +		goto error_unlock;
> +
> +	data->podl_pse_pw_d_status = ret;

I'm wondering how this is going to scale. At some point, i expect
there will be an implementation that follows C45.2.9. I see 14 values
which could be returned. I don't think 14 ops in the driver structure
makes sense. Plus c30.15.1 defines other values.

The nice thing about netlink is you can have as many or are little
attributes in the message as you want. For cable testing, i made use
of this. There is no standardisation, different PHYs offer different
sorts of results. So i made the API flexible. The PHY puts whatever
results it has into the message, and ethtool(1) just walks the message
and prints what is in it.

I'm wondering if we want a similar sort of API here?
net/ethtool/pse-pd.c allocates the netlink messages, adds the header,
and then passes it to the driver. The driver then uses helpers from
ethtool to add whatever attributes it wants to the message. pse-pd
then completes the message, and returns it to user space? This seems
like it will scale better.

     Andrew

