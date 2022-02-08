Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B494ADA5B
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 14:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244880AbiBHNsE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 08:48:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242978AbiBHNsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 08:48:04 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DEAC03FED0
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 05:48:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vZmOEoPp5YutcQ6LA1ts65evPIfiU3qva+sKcIewuZw=; b=Ar3XLpn9w77LbQoKo/bPiJUwPp
        iXh5GHKqIcncNSKa/+p2SmNcWetGe4o0A95lzqNk7SZgvEaguHIQCoOmwgqTphSvrR1QgtkA2qoEd
        LCJzOAEVCfozGiSXcAyVpNtUVOeYJiS/zNu7dfpBmjFg+TLmokjB0Djmc5iqMUSmdXho=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHQqf-004rz8-9U; Tue, 08 Feb 2022 14:48:01 +0100
Date:   Tue, 8 Feb 2022 14:48:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [v4] dsa: mv88e6xxx: make serdes SGMII/Fiber tx amplitude
 configurable
Message-ID: <YgJ0kexWU4FROzNJ@lunn.ch>
References: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208094455.28870-1-holger.brunck@hitachienergy.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static struct mv88e6352_serdes_p2p_to_val mv88e6352_serdes_p2p_to_val[] = {

Please add a const to this. It will make the memory usage a little
smaller and help protect from overwrite.

> +	/* Mapping of configurable mikrovolt values to the register value */
> +	{ 14000, 0},
> +	{ 112000, 1},
> +	{ 210000, 2},
> +	{ 308000, 3},
> +	{ 406000, 4},
> +	{ 504000, 5},
> +	{ 602000, 6},
> +	{ 700000, 7},
> +};
> +
> +int mv88e6352_serdes_set_tx_p2p_amplitude(struct mv88e6xxx_chip *chip, int port,
> +					  int val)
> +{
> +	bool found = false;
> +	u16 reg;
> +	int err;
> +	int i;
> +
> +	if (!mv88e6352_port_has_serdes(chip, port))
> +		return -EOPNOTSUPP;

Russell just reworked this call. Did you take that into account?

> +
> +	for (i = 0; i < ARRAY_SIZE(mv88e6352_serdes_p2p_to_val); ++i) {
> +		if (mv88e6352_serdes_p2p_to_val[i].mv == val) {
> +			reg = mv88e6352_serdes_p2p_to_val[i].regval;

i has the same value as mv88e6352_serdes_p2p_to_val[i].regval, so you
can drop it and just use i.

    Andrew
