Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6EE6C5421
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 19:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjCVSvc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 14:51:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjCVSv3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 14:51:29 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF5867727;
        Wed, 22 Mar 2023 11:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3TaGrmidi4jFHjI6XKbWUve1I4hxTveF67kfs2EX8xo=; b=Ji6w27akNxkMkONJZhj//adQXM
        Fz9JX48tvzpiBKfQb7LxDGqslWSTUn7HA+Qt1PPYTH6PppIg6onoxx+b4PcJ+ajsHNOpGeheWgDcv
        auVDu3cD6uW0v+XTou7QZIPjlfCzNQpvtKPwgOkHWuE23Y9u8S8euMUY0x4zqup2CwBI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pf3YQ-0085xq-Ng; Wed, 22 Mar 2023 19:51:22 +0100
Date:   Wed, 22 Mar 2023 19:51:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Daniel Scally <djrscally@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH RFC net-next 5/7] net: dsa: avoid DT validation for
 drivers which provide default config
Message-ID: <db06c9d7-9ad7-42f0-9b40-6e325f6bcc62@lunn.ch>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8a-00Dvo3-G7@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pex8a-00Dvo3-G7@rmk-PC.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 12:00:16PM +0000, Russell King (Oracle) wrote:
> When a DSA driver (e.g. mv88e6xxx) provides a default configuration,
> avoid validating the DT description as missing elements will be
> provided by the DSA driver.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  net/dsa/port.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/dsa/port.c b/net/dsa/port.c
> index c30e3a7d2145..23d9970c02d3 100644
> --- a/net/dsa/port.c
> +++ b/net/dsa/port.c
> @@ -1951,6 +1951,9 @@ static void dsa_shared_port_validate_of(struct dsa_port *dp,
>  	*missing_phy_mode = false;
>  	*missing_link_description = false;
>  
> +	if (dp->ds->ops->port_get_fwnode)
> +		return;

I wounder if you should actually call it for the given port, and
ensure it does not return -EOPNOTSUPP, or -EINVAL, etc, because it is
not going to override that port? Then the DT values should be
validated?

	Andrew
