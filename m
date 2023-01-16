Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D1C66D199
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 23:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235015AbjAPWPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 17:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbjAPWPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 17:15:35 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A673610A95;
        Mon, 16 Jan 2023 14:15:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YJdSP6ajWattA/UAQ8BmtbdhHG1VfxlJKOf4GW8dgMw=; b=uEDh8oJ9HS6v+2ZzWzV3Wjaf8t
        kiivbrhcgMn9WltPkFhpqLF6oByGKlvD2UwpzvVYo8om22flSZUPMetaJlH/NR37iZo38iDiS93Ij
        yrJWXZ11jYqxFbYhtA6QWCtyDYYhqe4BA4bDc6/rvigTTmF5b+kg3zfyrfTZV6Hjg4IA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHXj6-002Gfb-A5; Mon, 16 Jan 2023 23:13:12 +0100
Date:   Mon, 16 Jan 2023 23:13:12 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Message-ID: <Y8XL+PKLabp9oTsZ@lunn.ch>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-3-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116173420.1278704-3-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int fwnode_phy_register_fixed_link(struct fwnode_handle *fwnode)
> +{
> +	struct fixed_phy_status status = {};
> +	struct fwnode_handle *fixed_link_node;
> +	u32 fixed_link_prop[5];
> +	const char *managed;
> +	int rc;
> +
> +	if (fwnode_property_read_string(fwnode, "managed", &managed) == 0 &&
> +	    strcmp(managed, "in-band-status") == 0) {
> +		/* status is zeroed, namely its .link member */
> +		goto register_phy;
> +	}
> +
> +	/* New binding */
> +	fixed_link_node = fwnode_get_named_child_node(fwnode, "fixed-link");
> +	if (fixed_link_node) {
> +		status.link = 1;
> +		status.duplex = fwnode_property_present(fixed_link_node,
> +							"full-duplex");
> +		rc = fwnode_property_read_u32(fixed_link_node, "speed",
> +					      &status.speed);
> +		if (rc) {
> +			fwnode_handle_put(fixed_link_node);
> +			return rc;
> +		}
> +		status.pause = fwnode_property_present(fixed_link_node, "pause");
> +		status.asym_pause = fwnode_property_present(fixed_link_node,
> +							    "asym-pause");
> +		fwnode_handle_put(fixed_link_node);
> +
> +		goto register_phy;
> +	}
> +
> +	/* Old binding */
> +	rc = fwnode_property_read_u32_array(fwnode, "fixed-link", fixed_link_prop,
> +					    ARRAY_SIZE(fixed_link_prop));
> +	if (rc)
> +		return rc;
> +
> +	status.link = 1;
> +	status.duplex = fixed_link_prop[1];
> +	status.speed  = fixed_link_prop[2];
> +	status.pause  = fixed_link_prop[3];
> +	status.asym_pause = fixed_link_prop[4];

This is one example of the issue i just pointed out. The "Old binding"
has been deprecated for years. Maybe a decade? There is no reason it
should be used in ACPI.

       Andrew
