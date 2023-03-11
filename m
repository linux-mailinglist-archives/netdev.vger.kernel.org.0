Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A659F6B5D4B
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:20:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjCKPTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:19:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbjCKPTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:19:52 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4441064AAC;
        Sat, 11 Mar 2023 07:19:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CBIHH9XG4nVS2bo3uP1GEXEkJNI0edg39kNsKztVQlk=; b=l4EjBefxpGWGF2I882PqNfNHfr
        SQcMBUSWRaxbqFS0QJjhz5ZCNhwpds6Z/gxSjq4P9JrzRll90EflueF5UqPq1t0JSa+DgIT4I09yp
        DgbiDNgLCOVlBgyFK9KDL4Mqkgfl/MVry2wWZ9EY9l28okHIys5j2gJ+RqYhbSYtkt8k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pb10Z-0074Ef-9u; Sat, 11 Mar 2023 16:19:43 +0100
Date:   Sat, 11 Mar 2023 16:19:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: move call to
 mv88e6xxx_mdios_register()
Message-ID: <98767929-b401-402b-8e6b-d997cf27bfb0@lunn.ch>
References: <20230311094141.34578-1-klaus.kudielka@gmail.com>
 <20230311094141.34578-2-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311094141.34578-2-klaus.kudielka@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 10:41:41AM +0100, Klaus Kudielka wrote:
> >From commit 1a136ca2e089 ("net: mdio: scan bus based on bus capabilities
> for C22 and C45") onwards, mdiobus_scan_bus_c45() is being called on buses
> with MDIOBUS_NO_CAP. On a Turris Omnia (Armada 385, 88E6176 switch), this
> causes a significant increase of boot time, from 1.6 seconds, to 6.3
> seconds. The boot time stated here is until start of /init.
> 
> Further testing revealed that the C45 scan is indeed expensive (around
> 2.7 seconds, due to a huge number of bus transactions), and called twice.
> 
> It was suggested, to call mv88e6xxx_mdios_register() at the beginning of
> mv88e6xxx_setup(), and mv88e6xxx_mdios_unregister() at the end of
> mv88e6xxx_teardown(). This is accomplished by this patch.
> 
> Testing on the Turris Omnia revealed, that this improves the situation.
> Now mdiobus_scan_bus_c45() is called only once, ending up in a boot time
> of 4.3 seconds.

For those who are interested, here is a bit of background on why this
change reduces the number of bus scans.

The MAC driver probes, which i think in this case is mvneta. Part way
through its probe, it registers its MDIO bus. That triggers a scan of
its bus, and the switch is found. The mv88e6xxx driver is then loaded
and its probe function called. towards the end of the mv88e6xxxx probe
function, it registers its MDIO bus. That causes a scan of the
switches MDIO bus. Which is slow. After the scan completes, the
mv88e6xxx probe continues, and registers the switch with DSA core. The
core then parses the DT binding for the switch and looks for the
master ethernet interface. That is the interface which mvneta
provides. But mvneta is still only part way through its probe. It has
not yet registered its interface with the netdev core. So the DSA core
fails to find it and return EPROBE_DEFER. This causes the mv88e6xxx
driver to unwind its probe. The mvneat then gets a chance to finish
its probe and register its netdev. Some timer later, the driver core
runs the probes again for those drivers which returned EPROBE_DEFER,
mv88e6xxx registers its MDIO bus again, another scan is performed, the
switch is registered with the code, and this time the master device is
available, so things continue. The DSA core then calls the drivers
.setup() callback to get the switch into a usable state.

I think what remains in the probe function is cheap, so it can
probable stay there and be done twice. But it might be worth putting
in a few printks to get some time stamps and see if anything is
expensive.

>  static int mv88e6xxx_setup(struct dsa_switch *ds)
> @@ -3889,6 +3892,10 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
>  	int err;
>  	int i;
>  
> +	err = mv88e6xxx_mdios_register(chip);
> +	if (err)
> +		return err;
> +
>  	chip->ds = ds;
>  	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);

Other calls in mv88e6xxx_setup() can fail, so you need to extend the
cleanup to remove the mdio bus on failure.

	Andrew
