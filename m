Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C56168C78F
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 21:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230181AbjBFUWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 15:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbjBFUWG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 15:22:06 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266BC298FC;
        Mon,  6 Feb 2023 12:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UPMS4+GiWA1iXl0wn+OuZDqgqDg2WCg1eOAbQZg4o/A=; b=Ufqok60DPuutPt3mZYvVllAdpr
        vqgARf95i+7li7VXd+qCF+uMbh2gHzJVjuZA1Ce6sLoNVs+80/oC3ParNoDOi4sm4gnGfk6qLrOUI
        Nn399vQObd78Z/8hNeIDFWSJWioVLKXGC+qRO8fTJjjvr7UT+2XeZ/h4NqG7RhOC1EVM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pP7zf-004EiV-Vm; Mon, 06 Feb 2023 21:21:39 +0100
Date:   Mon, 6 Feb 2023 21:21:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arun.Ramadoss@microchip.com, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v4 00/23] net: add EEE support for KSZ9477 and
 AR8035 with i.MX6
Message-ID: <Y+FhU+5KJrEYX2CU@lunn.ch>
References: <20230201145845.2312060-1-o.rempel@pengutronix.de>
 <20230204001332.dd4oq4nxqzmuhmb2@skbuf>
 <20230206054713.GD12366@pengutronix.de>
 <20230206141038.vp5pdkjyco6pyosl@skbuf>
 <Y+EfSKRwQMRgEurL@lunn.ch>
 <20230206183706.GH12366@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206183706.GH12366@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> SmartEEE will be probably a bit more challenging. If MAC do not
> advertise EEE support, SmartEEE can be enabled. But it would break PTP
> if SmartEEE is active. Except SmartEEE capable PHY implements own PTP
> support. In any case, user space will need extra information to
> identify potential issues.

If we have a MAC driver which does not implement the ethtool set_eee()
and get_eee() ops, and a dev->phydev with the SmartEEE flag set, we
could have net/ethtool/eee.c call direct into phylib.

As for PTP and EEE, maybe we want the core PTP code to try calling
get_eee() and at minimum issue a warning if it is enabled, if it
thinks MAC PTP is being used?

       Andrew
