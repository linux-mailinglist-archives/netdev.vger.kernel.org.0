Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D49A4696CD
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 14:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244349AbhLFNYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 08:24:36 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40452 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244221AbhLFNYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 08:24:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BBWE+DJp3u0wHRr1lCBNrPq6EQ1CqplMxGd0XuecKGQ=; b=hGWZj/G7h5ddlz4maD6TdIsLPf
        XXIbBBLiv+WFiP39jM5gPt+oo6plfefx89fN0hXkoIuV+mAHnjpujbj3U6r8f9S4b6q9Z8tFzNtcl
        gnjNMDBIOG/xzsWHILY7P1dLpDaoG0JX22xnhqO32vrXRZ2lP4E0lBFo9sQBHad54tpk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muDvT-00FfAJ-FX; Mon, 06 Dec 2021 14:21:03 +0100
Date:   Mon, 6 Dec 2021 14:21:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ameer Hamza <amhamza.mgc@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: initialize return variable on
 declaration
Message-ID: <Ya4OP+jQYd/UwiQK@lunn.ch>
References: <20211206113219.17640-1-amhamza.mgc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211206113219.17640-1-amhamza.mgc@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 06, 2021 at 04:32:19PM +0500, Ameer Hamza wrote:
> Uninitialized err variable defined in mv88e6393x_serdes_power
> function may cause undefined behaviour if it is called from
> mv88e6xxx_serdes_power_down context.
> 
> Addresses-Coverity: 1494644 ("Uninitialized scalar variable")
> 
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/serdes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
> index 55273013bfb5..33727439724a 100644
> --- a/drivers/net/dsa/mv88e6xxx/serdes.c
> +++ b/drivers/net/dsa/mv88e6xxx/serdes.c
> @@ -1507,7 +1507,7 @@ int mv88e6393x_serdes_power(struct mv88e6xxx_chip *chip, int port, int lane,
>  			    bool on)
>  {
>  	u8 cmode = chip->ports[port].cmode;
> -	int err;
> +	int err = 0;
>  
>  	if (port != 0 && port != 9 && port != 10)
>  		return -EOPNOTSUPP;

Hi Marek

This warning likely comes from cmode not being a SERDES mode, and that
is not handles in the switch statementing. Do we want an

default:
	err = EINVAL;

?

	Andrew
