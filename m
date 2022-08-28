Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C509C5A3C1C
	for <lists+netdev@lfdr.de>; Sun, 28 Aug 2022 08:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbiH1GRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Aug 2022 02:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiH1GRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Aug 2022 02:17:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7873751A06
        for <netdev@vger.kernel.org>; Sat, 27 Aug 2022 23:17:10 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oSBb0-0002bl-Vt; Sun, 28 Aug 2022 08:16:34 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oSBau-0003CU-E0; Sun, 28 Aug 2022 08:16:28 +0200
Date:   Sun, 28 Aug 2022 08:16:28 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        kernel test robot <lkp@intel.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v3 6/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220828061628.GA26078@pengutronix.de>
References: <20220827051033.3903585-1-o.rempel@pengutronix.de>
 <20220827051033.3903585-7-o.rempel@pengutronix.de>
 <Ywpkqt2pDmpzXWWn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ywpkqt2pDmpzXWWn@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 27, 2022 at 08:38:34PM +0200, Andrew Lunn wrote:
> > +static int pse_set_pse_config(struct net_device *dev,
> > +			      struct netlink_ext_ack *extack,
> > +			      struct nlattr **tb)
> > +{
> > +	struct phy_device *phydev = dev->phydev;
> > +	struct pse_control_config config = {};
> > +	int ret;
> > +
> > +	if (!tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL])
> > +		return -EINVAL;
> 
> I would make use of extack here, and report what is missing.
> 
> > +
> > +	config.admin_cotrol = nla_get_u8(tb[ETHTOOL_A_PODL_PSE_ADMIN_CONTROL]);
> 
> It would be good to have some basic validation here, make sure user
> space has passed a reasonable value.

this values are already validate by the ethnl_pse_set_policy

> You should also define what 0 and
> ETHTOOL_A_PODL_PSE_ADMIN_CONTROL_UNKNOWN means here when passed in. In
> future, there could be additional things which could be configured, so
> struct pse_control_config gets additional members.
> ETHTOOL_A_PODL_PSE_ADMIN_CONTROL appears to be mandatory, you return
> -EVINAL if missing, so if you don't want to change it, but change some
> other new thing, maybe 0 should be passed here? And the driver should
> not consider it an error?

ack. changed to 0 and added comment.

> ETHTOOL_A_PODL_PSE_ADMIN_CONTROL_UNKNOWN
> however seems invalid and so should be rejected here?

yes. it is already rejected. I added comment to make it more visible

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
