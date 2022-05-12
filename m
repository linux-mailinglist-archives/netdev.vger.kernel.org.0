Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7C03524C75
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 14:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353584AbiELMMF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 08:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353577AbiELMMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 08:12:03 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45D33DDF0
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 05:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=LVYox6TUjikfM1g8DCrpsqL5vDrC5VjkI/gscOyZbsI=; b=h7K+RjsCnELaFYgCxVNtDNzVWu
        LcYBGH5pRNJhWanUhKWy9q5P5F7sJ2ddj7j3fu3qtKKBr9QS6oX8OcmJK6kkDsLsJyAoZ6IMsafCi
        72I+0GnYRE2fcJeCLtSr6fLkMyp189DyaD5Z9gQAyHEvHHB37IiUXUktdr8TRGF9QJEM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1np7fh-002RnL-6v; Thu, 12 May 2022 14:11:57 +0200
Date:   Thu, 12 May 2022 14:11:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 10/14] net: txgbe: Add ethtool support
Message-ID: <Ynz5jZUQorkPmJ/o@lunn.ch>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
 <20220511032659.641834-11-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511032659.641834-11-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int txgbe_get_link_ksettings(struct net_device *netdev,
> +			     struct ethtool_link_ksettings *cmd)
> +{
> +	struct txgbe_adapter *adapter = netdev_priv(netdev);
> +	struct txgbe_hw *hw = &adapter->hw;
> +	u32 supported_link;
> +	u32 link_speed = 0;
> +	bool autoneg = false;
> +	u32 supported, advertising;
> +	bool link_up;



> +
> +	if (!in_interrupt()) {
> +		TCALL(hw, mac.ops.check_link, &link_speed, &link_up, false);
> +	} else {
> +		/* this case is a special workaround for RHEL5 bonding
> +		 * that calls this routine from interrupt context
> +		 */
> +		link_speed = adapter->link_speed;
> +		link_up = adapter->link_up;
> +	}

Does mainline do this? You are contributing this driver to mainline,
not a vendor kernel. Don't work around vendor issues.

    Andrew
