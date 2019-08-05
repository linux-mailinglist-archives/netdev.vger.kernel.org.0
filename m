Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 424718203E
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 17:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfHEPbC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 11:31:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34466 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728939AbfHEPbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 11:31:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gl1e0DAfh8g9b9ah5STjd2Zeh92eqoUeJ7vLy3eAWZo=; b=uXIsqssj3khLZ27sybWP7psCpR
        O4ohKMstle//0j1xFo4zCF1BMCMNXODoC4qNcfv1eoQ8TrGQmS7zG+dgxot0zS4X1s98/VTJ9KJTE
        qyANtw6BIwJWOewiw2WW8xQKk2bsgk4UJ8x4YxTO3PMeEM/X+L8Wb7zPwIXvh1CCvISc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1huews-0007xd-DM; Mon, 05 Aug 2019 17:30:58 +0200
Date:   Mon, 5 Aug 2019 17:30:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, f.fainelli@gmail.com,
        hkallweit1@gmail.com
Subject: Re: [PATCH 15/16] net: phy: adin: add ethtool get_stats support
Message-ID: <20190805153058.GU24275@lunn.ch>
References: <20190805165453.3989-1-alexandru.ardelean@analog.com>
 <20190805165453.3989-16-alexandru.ardelean@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805165453.3989-16-alexandru.ardelean@analog.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 05, 2019 at 07:54:52PM +0300, Alexandru Ardelean wrote:
> This change implements retrieving all the error counters from the PHY.
> The PHY supports several error counters/stats. The `Mean Square Errors`
> status values are only valie when a link is established, and shouldn't be
> incremented. These values characterize the quality of a signal.

I think you mean accumulated, not incremented?

> 
> The rest of the error counters are self-clearing on read.
> Most of them are reports from the Frame Checker engine that the PHY has.
> 
> Not retrieving the `LPI Wake Error Count Register` here, since that is used
> by the PHY framework to check for any EEE errors. And that register is
> self-clearing when read (as per IEEE spec).
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
> ---
>  drivers/net/phy/adin.c | 108 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 108 insertions(+)
> 
> diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
> index a1f3456a8504..04896547dac8 100644
> --- a/drivers/net/phy/adin.c
> +++ b/drivers/net/phy/adin.c
> @@ -103,6 +103,32 @@ static struct clause22_mmd_map clause22_mmd_map[] = {
>  	{ MDIO_MMD_PCS, MDIO_PCS_EEE_WK_ERR,	ADIN1300_LPI_WAKE_ERR_CNT_REG },
>  };
>  
> +struct adin_hw_stat {
> +	const char *string;
> +	u16 reg1;
> +	u16 reg2;
> +	bool do_not_inc;

do_not_accumulate? or reverse its meaning, clear_on_read?

   Andrew
