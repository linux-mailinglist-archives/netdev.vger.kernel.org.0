Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595236E0602
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 06:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjDME3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 00:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjDME3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 00:29:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414543AAB
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 21:29:49 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pmoaY-0005Ck-8l; Thu, 13 Apr 2023 06:29:38 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pmoaW-0000UJ-95; Thu, 13 Apr 2023 06:29:36 +0200
Date:   Thu, 13 Apr 2023 06:29:36 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230413042936.GA12562@pengutronix.de>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230411172456.3003003-3-o.rempel@pengutronix.de>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 07:24:55PM +0200, Oleksij Rempel wrote:

...

>  drivers/net/dsa/microchip/ksz9477_acl.c | 950 ++++++++++++++++++++++++

I'll better split tc-flower code and ACL code to separate files. This
chips support other engines which can be used for priority remaping. For
example DiffServ/DSCP

>  drivers/net/dsa/microchip/ksz_common.c  |  40 +
>  drivers/net/dsa/microchip/ksz_common.h  |   1 +
...

> +/**
> + * ksz9477_acl_port_enable - Enables ACL functionality on a given port.
> + * @dev: The ksz_device instance.
> + * @port: The port number on which to enable ACL functionality.
> + *
> + * This function enables ACL functionality on the specified port by configuring
> + * the appropriate control registers. It returns 0 if the operation is
> + * successful, or a negative error code if an error occurs.
> + */
> +static int ksz9477_acl_port_enable(struct ksz_device *dev, int port)
> +{
> +	int ret;
> +
> +	ret = ksz_prmw8(dev, port, P_PRIO_CTRL, 0, PORT_ACL_PRIO_ENABLE |
> +			PORT_OR_PRIO);

According to KSZ9477S 5.2.8.2 Port Priority Control Register
"To achieve the desired functionality, do not set more than one bit at a
time in this register.
...
Bit 6 - OR’ed Priority
...
Bit 2 - 802.1p Priority Classification
Bit 1 - Diffserv Priority Classification
Bit 0 - ACL Priority Classification
"
@Arun  what will happen if multiple engines are used for packet
prioritization? For example ACL || Diffserv || 802.1p... ?
If I see it correctly, it is possible but not recommended. Should I
prevent usage of multiple prio sources? 


> +	if (ret)
> +		return ret;
> +
> +	return ksz_pwrite8(dev, port, REG_PORT_MRI_AUTHEN_CTRL,
> +			   PORT_ACL_ENABLE |
> +			   FIELD_PREP(PORT_AUTHEN_MODE, PORT_AUTHEN_PASS));
> +}

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
