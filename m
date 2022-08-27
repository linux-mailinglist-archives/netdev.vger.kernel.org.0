Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 292685A398F
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 20:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiH0Siz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Aug 2022 14:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229884AbiH0Six (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Aug 2022 14:38:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 025CDC22B9;
        Sat, 27 Aug 2022 11:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GkYGAg3qcPD2jpV5HOzvtigzyj8tXyVIkxDsZezVgdI=; b=RIYJrZ+4dnmjFQXx6VLi0MZx18
        KW7rJpigeSJk74iaPr9D1oXPmbupZjKY+PszhprVY19MqrcZrKAq219yYKA6v0wor51CAFNCi0ICw
        mUyoQg+fg+Er3H6iaosyw6vnuqFCqvUW5v5BLCCFAEYwlyPwnzhG3yGdRnVZbjzfa7R4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oS0hW-00EnON-IQ; Sat, 27 Aug 2022 20:38:34 +0200
Date:   Sat, 27 Aug 2022 20:38:34 +0200
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
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 6/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <Ywpkqt2pDmpzXWWn@lunn.ch>
References: <20220827051033.3903585-1-o.rempel@pengutronix.de>
 <20220827051033.3903585-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220827051033.3903585-7-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int pse_set_pse_config(struct net_device *dev,
> +			      struct netlink_ext_ack *extack,
> +			      struct nlattr **tb)
> +{
> +	struct phy_device *phydev = dev->phydev;
> +	struct pse_control_config config = {};
> +	int ret;
> +
> +	if (!tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL])
> +		return -EINVAL;

I would make use of extack here, and report what is missing.

> +
> +	config.admin_cotrol = nla_get_u8(tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL]);

It would be good to have some basic validation here, make sure user
space has passed a reasonable value.

You should also define what 0 and
ETHTOOL_A_PODL_PSE_ADMIN_CONTROL_UNKNOWN means here when passed in. In
future, there could be additional things which could be configured, so
struct pse_control_config gets additional members.
ETHTOOL_A_PODL_PSE_ADMIN_CONTROL appears to be mandatory, you return
-EVINAL if missing, so if you don't want to change it, but change some
other new thing, maybe 0 should be passed here? And the driver should
not consider it an error?  ETHTOOL_A_PODL_PSE_ADMIN_CONTROL_UNKNOWN
however seems invalid and so should be rejected here?

	Andrew
