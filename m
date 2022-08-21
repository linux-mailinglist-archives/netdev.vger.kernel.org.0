Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F70059B1BE
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 06:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiHUEkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 00:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbiHUEj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 00:39:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC32220C9
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 21:39:57 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oPckJ-0007TV-Kd; Sun, 21 Aug 2022 06:39:35 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oPckG-0007zt-4g; Sun, 21 Aug 2022 06:39:32 +0200
Date:   Sun, 21 Aug 2022 06:39:32 +0200
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
        Jonathan Corbet <corbet@lwn.net>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH net-next v1 7/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220821043932.GJ10138@pengutronix.de>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-8-o.rempel@pengutronix.de>
 <YwEk8h9C9XhT6Yyc@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YwEk8h9C9XhT6Yyc@lunn.ch>
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

On Sat, Aug 20, 2022 at 08:16:18PM +0200, Andrew Lunn wrote:
> On Fri, Aug 19, 2022 at 02:01:09PM +0200, Oleksij Rempel wrote:
> > Add interface to support Power Sourcing Equipment. At current step it
> > provides generic way to address all variants of PSE devices as defined
> > in IEEE 802.3-2018 but support only objects specified for IEEE 802.3-2018 104.4
> > PoDL Power Sourcing Equipment (PSE).
> > 
> > Currently supported and mandatory objects are:
> > IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatus
> > IEEE 802.3-2018 30.15.1.1.2 aPoDLPSEAdminState
> > IEEE 802.3-2018 30.15.1.2.1 acPoDLPSEAdminControl
> > 
> > This is minimal interface needed to control PSE on each separate
> > ethernet port but it provides not all mandatory objects specified in
> > IEEE 802.3-2018.
> 
> > +static int pse_get_pse_attributs(struct net_device *dev,
> > +				 struct pse_reply_data *data)
> > +{
> > +	struct phy_device *phydev = dev->phydev;
> > +	int ret;
> > +
> > +	if (!phydev)
> > +		return -EOPNOTSUPP;
> > +
> > +	mutex_lock(&phydev->lock);
> > +	if (!phydev->psec) {
> > +		ret = -EOPNOTSUPP;
> > +		goto error_unlock;
> > +	}
> > +
> > +	ret = pse_podl_get_admin_sate(phydev->psec);
> > +	if (ret < 0)
> > +		goto error_unlock;
> > +
> > +	data->podl_pse_admin_state = ret;
> > +
> > +	ret = pse_podl_get_pw_d_status(phydev->psec);
> > +	if (ret < 0)
> > +		goto error_unlock;
> > +
> > +	data->podl_pse_pw_d_status = ret;
> 
> I'm wondering how this is going to scale. At some point, i expect
> there will be an implementation that follows C45.2.9. I see 14 values
> which could be returned. I don't think 14 ops in the driver structure
> makes sense. Plus c30.15.1 defines other values.
> 
> The nice thing about netlink is you can have as many or are little
> attributes in the message as you want. For cable testing, i made use
> of this. There is no standardisation, different PHYs offer different
> sorts of results. So i made the API flexible. The PHY puts whatever
> results it has into the message, and ethtool(1) just walks the message
> and prints what is in it.
> 
> I'm wondering if we want a similar sort of API here?
> net/ethtool/pse-pd.c allocates the netlink messages, adds the header,
> and then passes it to the driver. The driver then uses helpers from
> ethtool to add whatever attributes it wants to the message. pse-pd
> then completes the message, and returns it to user space? This seems
> like it will scale better.

Yes. Sounds good. I'll make a new version.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
