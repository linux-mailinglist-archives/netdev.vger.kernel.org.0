Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4767D5523E9
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245472AbiFTScP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242530AbiFTScO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:32:14 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290AC1D0EE;
        Mon, 20 Jun 2022 11:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Cv/O7zb/kXAuRbf7PPZy0zV7UOelG4vjvn/esylaMkU=; b=TLIYEbwtyvNALjQ8rED/+y6w59
        EjWAw4TXs1Lve9iUwCeKeDAsB7brqozjt80fRoVY72M5QL8zQXWIJ/tNeQxVjTK2JKFgfddLcG3VG
        jCnoSI8RJAb1mgq1BF9CbYcYEGzu2tGaO0AZYvY3dEbvdf4GBQeMC1Ur8aK3amZuUOEw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3MC2-007dlK-PF; Mon, 20 Jun 2022 20:32:10 +0200
Date:   Mon, 20 Jun 2022 20:32:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, lenb@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH 10/12] net: dsa: add ACPI support
Message-ID: <YrC9KpEuYCgHv14l@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-11-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-11-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>  static int dsa_port_parse_dsa(struct dsa_port *dp)
>  {
> +	/* Cascade switch connection is not supported in ACPI world. */
> +	if (is_acpi_node(dp->fwnode)) {
> +		dev_warn(dp->ds->dev,
> +			 "DSA type is not supported with ACPI, disable port #%d\n",
> +			 dp->index);
> +		dp->type = DSA_PORT_TYPE_UNUSED;
> +		return 0;
> +	}
> +

Did you try this? I'm not sure it will work correctly. When a switch
registers with the DSA core, the core will poke around in DT and fill
in various bits of information, including the DSA links. Once that has
completed, the core will look at all the switches registered so far
and try to determine if it has a complete set, i.e, it has both ends
of all DSA links. If it does have a complete set, it then calls the
setup methods on each switch, and gets them configured. If it finds it
does not have a complete setup, it does nothing, waiting for the next
switch to register.

So if somebody passed an ACPI description with multiple switches, it
is likely to call the setup methods as soon as the first switch is
registered. And it might call those same setup methods a second time,
when the second switch registers, on both switches. And when the third
switch registers, it will probably call the setup methods yet again on
all the switches....

You will have a much safer system if you return -EINVAL if you find a
DSA link in ACPI. That should abort the switch probe.

    Andrew
