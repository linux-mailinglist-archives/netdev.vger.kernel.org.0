Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605DF4E8144
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 15:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiCZOBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Mar 2022 10:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiCZOBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Mar 2022 10:01:33 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6775BE43AE;
        Sat, 26 Mar 2022 06:59:56 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id F091822246;
        Sat, 26 Mar 2022 14:59:53 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648303194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qSkvkduEimyVrKzJ8Yv+VKXW8fAV/QUWUndikwdu5kU=;
        b=HSTeecf6+9+ARwUDlRHJEir6Be0zMXoNOjcqQps6pc8OeJNXvZEFre2N+Me4wYvtlG73TT
        HidPd3bZGC6uP/8/kWNpE49JG/rReLiQp05UwEJC+s9FqLyPytL3e2BRst6CoiAkehLAAm
        zLwOLYJaDJ3Del+VHkndlfB7N/hRJ4k=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 26 Mar 2022 14:59:53 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: lan966x: fix kernel oops on ioctl when I/F is
 down
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1ee5aec079e3eefff8475017ff1044bf@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-03-26 03:17, schrieb Andrew Lunn:
> On Sat, Mar 26, 2022 at 01:02:51AM +0100, Michael Walle wrote:
>> A SIOCGMIIPHY ioctl will cause a kernel oops when the interface is 
>> down.
>> Fix it by checking the state and if it's no running, return an error.
> 
> s/no/not/
> 
> I don't think it is just SIOCGMIIPHY. phy_has_hwtstamp(dev->phydev) is
> probably also an issue. The phy is connected in open, and disconnected
> in stop. So dev->phydev is not valid outside of that time.

phy_has_hwtstamp() handles NULL gracefully. And I guess the MAC 
timestamp
handling is working if there is no phydev. Not sure if the interface
has to be up though.

> But i'm also not sure it is guaranteed to be valid while the interface
> is up. The driver uses phylink, so there could be an SFP attached to a
> port, in which case, dev->phydev will not be set.

I wonder if we should use phylink_mii_ioctl() here. Maybe as a seperate
patch for the net-next if its open again?

> So rather than testing of running, it would be better to test if the
> phydev is NULL or not.

What about the following:

static int lan966x_port_ioctl(struct net_device *dev, struct ifreq *ifr,
			     int cmd)
{
	struct lan966x_port *port = netdev_priv(dev);

	if (!phy_has_hwtstamp(dev->phydev) && port->lan966x->ptp) {
		switch (cmd) {
		case SIOCSHWTSTAMP:
			return lan966x_ptp_hwtstamp_set(port, ifr);
		case SIOCGHWTSTAMP:
			return lan966x_ptp_hwtstamp_get(port, ifr);
		}
	}

	if (!dev->phydev)
		return -ENODEV;

	return phy_mii_ioctl(dev->phydev, ifr, cmd);
}

-michael
