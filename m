Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C586C7018
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 19:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjCWSRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 14:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbjCWSRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 14:17:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C17F759;
        Thu, 23 Mar 2023 11:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=STJMpZw/O8wMVxyP+JM78oZub4Zt2Yu1QTj/QtlxVZk=; b=Z39Q3mmeQBpZRwu4MJZ4XNrHJ2
        i+q8x1vuzJrzmUxyty6St09gG0iGaDAg5daFtPEt91Jeo5e3ZK9p7+zLTpuavVFuxNqBzjUKbp3nI
        J4VwsJbnQ80qtnHna/13KkFLhS8o2lkLSrBkB5yTw6BiKM3XMLdlV26yOKoQBLbeiKxM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pfPV9-008E8W-Ga; Thu, 23 Mar 2023 19:17:27 +0100
Date:   Thu, 23 Mar 2023 19:17:27 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Subject: Re: [PATCH RFC net-next 6/7] net: dsa: mv88e6xxx: provide software
 node for default settings
Message-ID: <4ae939e1-8d11-4308-ace3-7e862f0bd24a@lunn.ch>
References: <ZBrtqPW29NnxVoEc@shell.armlinux.org.uk>
 <E1pex8f-00Dvo9-KT@rmk-PC.armlinux.org.uk>
 <04869523-3711-41a6-81ba-ddf2b12fd22e@lunn.ch>
 <ZBthf8EsnQIttGdI@shell.armlinux.org.uk>
 <5922c650-0ef3-4e60-84e6-0bfe535e5a98@lunn.ch>
 <ZBtjl9+bhtpKPmjr@shell.armlinux.org.uk>
 <8133635f-8d19-4899-83e2-0bf9b7b644b2@lunn.ch>
 <ZBwQoU4Mw6egvCEl@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBwQoU4Mw6egvCEl@shell.armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So, given that this is only supposed to be used for mv88e6xxx because
> of it's legacy, maybe the check in dsa_port_phylink_create() should
> be:
> 
>         fwnode = of_fwnode_handle(dp->dn);
>         if (fwnode && ds->ops->port_get_fwnode) {
> 
> In other words, we only allow the replacement of the firmware
> description if one already existed.

That sounds reasonable.

> Alternatively, we could use:
> 
> 	if (!dsa_port_is_user(dp) && ds->ops->port_get_fwnode) {
> 
> since mv88e6xxx today only does this "max speed" thing for CPU and
> DSA ports, and thus we only need to replace the firmware description
> for these ports - and we can document that port_get_fwnode is only
> for CPU and DSA ports.

Also reasonable.

The first seems better for the Non-DT, where as the second makes it
clear it is supposed to be for CPU and DSA ports only.

Is it over the top to combine them?

   Andrew
