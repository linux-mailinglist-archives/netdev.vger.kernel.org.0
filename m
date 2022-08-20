Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D1B59ADED
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 14:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344848AbiHTMb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 08:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345227AbiHTMb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 08:31:56 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62D96BCF8
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 05:31:55 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oPNdn-0005aE-Mi; Sat, 20 Aug 2022 14:31:51 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oPNdk-0002pe-TW; Sat, 20 Aug 2022 14:31:48 +0200
Date:   Sat, 20 Aug 2022 14:31:48 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     devicetree@vger.kernel.org, kernel@pengutronix.de,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
Subject: Re: [PATCH net-next v1 7/7] ethtool: add interface to interact with
 Ethernet Power Equipment
Message-ID: <20220820123148.GH10138@pengutronix.de>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-8-o.rempel@pengutronix.de>
 <Yv/9XVjRaa5jwpBo@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yv/9XVjRaa5jwpBo@lunn.ch>
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

On Fri, Aug 19, 2022 at 11:15:09PM +0200, Andrew Lunn wrote:
> > $ ip l
> > ...
> > 5: t1l1@eth0: <BROADCAST,MULTICAST> ..
> > ...
> > 
> > $ ethtool --show-pse t1l1
> > PSE attributs for t1l1:
> > PoDL PSE Admin State: disabled
> > PoDL PSE Power Detection Status: disabled
> > 
> > $ ethtool --set-pse t1l1 podl-pse-admin-control enable
> > $ ethtool --show-pse t1l1
> > PSE attributs for t1l1:
> > PoDL PSE Admin State: enabled
> > PoDL PSE Power Detection Status: delivering power
> 
> Here you seem to indicate that delivering power is totally independent
> of the interface admin status, <BROADCAST,MULTICAST>. The interface is
> admin down, yet you can make it deliver power. I thought there might
> be a link between interface admin status and power? Do the standards
> say anything about this? Is there some sort of industrial norm?
> 
> I'm also wondering about the defaults. It seems like the defaults you
> are proposing is power is off by default, and you have to use ethtool
> to enable power. That does not seem like the most friendly
> settings. Why not an 'auto' mode where if the PHY has PoDL PSE
> capabilities, on ifup it is enabled, on ifdown it is disabled? And you
> can put it into a 'manual' mode where you control it independent of
> administrative status of the interface?

Hm. I would say, safe option is to enable PSE manually. Here are my
reasons:
- some system may require to have power be enabled on boot, before we
  start to care about administrative state of the interface.
- in some cases powered device should stay enabled, even if we do
  ifup/ifdown

I assume, safe defaults should be:
- keep PSE always off, except system was configured to enable it on
  boot.
- keep PSE on after it was enabled, even on if up/down
- bind PSE admin state to the interface state only if user explicitly
  requested it.

At this round is only default, manual mode is implemented. Automatic
mode can be added later if needed.

These are my points, but i'm open for discussion.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
