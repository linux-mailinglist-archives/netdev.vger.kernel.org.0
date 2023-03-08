Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CCC86AFF8A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 08:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjCHHRE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 02:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjCHHRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 02:17:01 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9FEFA8C6A
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 23:16:59 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZo2d-0005BM-Pk; Wed, 08 Mar 2023 08:16:51 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1pZo2b-0004gI-Ne; Wed, 08 Mar 2023 08:16:49 +0100
Date:   Wed, 8 Mar 2023 08:16:49 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Message-ID: <20230308071649.GD1692@pengutronix.de>
References: <20230306124940.865233-1-o.rempel@pengutronix.de>
 <20230306124940.865233-2-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230306124940.865233-2-o.rempel@pengutronix.de>
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

On Mon, Mar 06, 2023 at 01:49:40PM +0100, Oleksij Rempel wrote:
> +static int ksz_queue_set_strict(struct ksz_device *dev, int port, int queue)
> +{
> +	int ret;
> +
> +	/* In order to ensure proper prioritization, it is necessary to set the
> +	 * rate limit for the related queue to zero. Otherwise strict priority
> +	 * mode will not work.
> +	 */
> +	ret = ksz_pwrite8(dev, port, KSZ9477_REG_PORT_OUT_RATE_0 + queue,
> +			  KSZ9477_OUT_RATE_NO_LIMIT);

Uff, this part works by accident. KSZ9477_REG_PORT_OUT_RATE_0 registers
should be written in a direct order. According to the documentation
"update will not take effect until the Port Queue 3 Egress Limit
Control Register is written.". But we are writing in a reverse order -
queue 3 is written first.

> +	if (ret)
> +		return ret;
> +
> +	ret = ksz_pwrite32(dev, port, REG_PORT_MTI_QUEUE_INDEX__4, queue);
> +	if (ret)
> +		return ret;
> +
> +	return ksz_setup_tc_mode(dev, port, MTI_SCHEDULE_STRICT_PRIO,
> +				 MTI_SHAPING_OFF);
> +}
> +
> +static int ksz_queue_set_wrr(struct ksz_device *dev, int port, int queue,
> +			     int weight)
> +{
> +	int ret;
> +
> +	/* In order to ensure proper prioritization, it is necessary to set the
> +	 * rate limit for the related queue to zero. Otherwise weighted round
> +	 * robin mode will not work.
> +	 */
> +	ret = ksz_pwrite8(dev, port, KSZ9477_REG_PORT_OUT_RATE_0 + queue,
> +			  KSZ9477_OUT_RATE_NO_LIMIT);

same here.
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
