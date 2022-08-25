Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3C55A185A
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243017AbiHYSIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:08:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243003AbiHYSH7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:07:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03608BD139;
        Thu, 25 Aug 2022 11:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A5AE61CBD;
        Thu, 25 Aug 2022 18:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C7CC433D6;
        Thu, 25 Aug 2022 18:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661450878;
        bh=P7IaUuILhRlBKJWD1XTENmsK+U18RlbZ9W1q2qOV2Gg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MVyN+2QvVESzlEmFSFTsVrR1t5Tqw+qRrxpT5tXMtmxn8ppIOxbunQ5WNV1Wm3P+Y
         Izhe8Cbh7go0eWf4DqWDADgKMsygr4M8MqPF6vtAatwOHFFxSPzPwo68+OG8h4vxtw
         49Fu/DDDcP9iqwqPF3TLW02e8HVlcu8qRU2vK4T7G299Qlqn7i7bkKqL5lTeTGFEJU
         xaeEbMxF8VMljf550nbqb/r7Kbhz28r4yioODHsFrNFhAt1UP9lh87DIFu4mgxXHWQ
         bK1dDgQK6o0D6z4e06maZXZpqA0ux/+KKbXqUPiInXACcq5cQJWiiDF5RsFrZxIKAq
         NLAs7VdTtPZ3g==
Date:   Thu, 25 Aug 2022 11:07:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
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
Subject: Re: [PATCH net-next v2 6/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220825110756.6361fff7@kernel.org>
In-Reply-To: <20220825130211.3730461-7-o.rempel@pengutronix.de>
References: <20220825130211.3730461-1-o.rempel@pengutronix.de>
        <20220825130211.3730461-7-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 15:02:10 +0200 Oleksij Rempel wrote:
> +void ethtool_set_ethtool_pse_ops(const struct ethtool_pse_ops *ops)
> +{
> +	rtnl_lock();
> +	ethtool_pse_ops = ops;
> +	rtnl_unlock();
> +}
> +EXPORT_SYMBOL_GPL(ethtool_set_ethtool_pse_ops);

Do we really need the loose linking on the PSE ops?
It's not a lot of code, and the pcdev->ops should be 
enough to decouple drivers, it seems.

> +static int pse_set_pse_config(struct net_device *dev,
> +			      struct netlink_ext_ack *extack,
> +			      struct nlattr **tb)
> +{
> +	struct phy_device *phydev = dev->phydev;
> +	struct pse_control_config config = {};
> +	const struct ethtool_pse_ops *ops;
> +	int ret;
> +
> +	if (!tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL])
> +		return 0;

If SET has no useful attrs the usual response is -EINVAL.

> +	ops = ethtool_pse_ops;
> +	if (!ops || !ops->set_config)
> +		return -EOPNOTSUPP;
> +
> +	config.admin_cotrol = nla_get_u8(tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL]);
> +
> +	if (!phydev)
> +		return -EOPNOTSUPP;
> +
> +	// todo resolve phydev dependecy

My lack of phydev understanding and laziness are likely the cause,
but I haven't found an explanation for this todo. What is it about?

> +	if (!phydev->psec)
> +		ret = -EOPNOTSUPP;
> +	else
> +		ret = ops->set_config(phydev->psec, extack, &config);
> +
> +	return ret;
> +}
