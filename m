Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2894F750D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 07:06:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiDGFIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 01:08:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiDGFIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 01:08:09 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40660F52
        for <netdev@vger.kernel.org>; Wed,  6 Apr 2022 22:06:08 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ncKLP-0006RW-3i; Thu, 07 Apr 2022 07:06:07 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1ncKLN-0004wr-2B; Thu, 07 Apr 2022 07:06:05 +0200
Date:   Thu, 7 Apr 2022 07:06:05 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de
Subject: Re: [PATCH v2] net: phy: micrel: ksz9031/ksz9131: add cabletest
 support
Message-ID: <20220407050605.GA21228@pengutronix.de>
References: <20220407020812.1095295-1-marex@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220407020812.1095295-1-marex@denx.de>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:29:02 up 7 days, 16:58, 36 users,  load average: 0.12, 0.08, 0.08
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 04:08:12AM +0200, Marek Vasut wrote:
...

> +static int ksz9x31_cable_test_result_trans(u16 status)
> +{
> +	switch (FIELD_GET(KSZ9x31_LMD_VCT_ST_MASK, status)) {
> +	case KSZ9x31_LMD_VCT_ST_NORMAL:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OK;
> +	case KSZ9x31_LMD_VCT_ST_OPEN:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_SAME_SHORT;
> +	case KSZ9x31_LMD_VCT_ST_SHORT:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_OPEN;

This conversation looks twisted:
VCT_ST_OPEN -> CODE_SAME_SHORT
VCT_ST_SHORT -> CODE_OPEN

> +	case KSZ9x31_LMD_VCT_ST_FAIL:
> +		fallthrough;
> +	default:
> +		return ETHTOOL_A_CABLE_RESULT_CODE_UNSPEC;
> +	}
> +}
> +
...
> +static int ksz9x31_cable_test_get_status(struct phy_device *phydev,
> +					 bool *finished)
> +{
> +	struct kszphy_priv *priv = phydev->priv;
> +	unsigned long pair_mask = 0xf;
> +	int retries = 20;
> +	int pair, ret, rv;
> +
> +	*finished = false;
> +
> +	/* Try harder if link partner is active */
> +	while (pair_mask && retries--) {
> +		for_each_set_bit(pair, &pair_mask, 4) {
> +			ret = ksz9x31_cable_test_one_pair(phydev, pair);
> +			if (ret == -EAGAIN)
> +				continue;
> +			if (ret < 0)
> +				return ret;
> +			clear_bit(pair, &pair_mask);
> +		}
> +		/* If link partner is in autonegotiation mode it will send 2ms
> +		 * of FLPs with at least 6ms of silence.
> +		 * Add 2ms sleep to have better chances to hit this silence.
> +		 */
> +		if (pair_mask)
> +			usleep_range(2000, 3000);

Not a blocker, just some ideas:
In my experience, active link partner may affect test result in way,
that the PHY wont report it as failed test. Especially, if the cable is
on the edge of specification (for example too long cable).
At same time 6ms of silence is PHY specific implementation. For example
KSZ PHYs tend to send burst of FLPs and the switch to other MDI-X pair
(if auto MDI-X is enabled). Some RTL PHYs tend to send random firework of pulses
on different pairs.

May be we should not fight against autoneg and misuse it a bit? For
example:
0. force MDI configuration
1. limit autoneg to 10mbit
2. allow the link
3. switch to test and run on unused pair
4. force MDI-X configuration and goto 1.

Other options can be:
- implement autoneg next page tx/rx and pass linux-vendor specific
  information over it (some thing like, please stop autoneg for X amount
  of sec)
- advertise remote fault

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
