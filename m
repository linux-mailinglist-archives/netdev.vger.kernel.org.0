Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9E859ADC5
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 14:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345973AbiHTMBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 08:01:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345987AbiHTMBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 08:01:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E6D2A3467
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 05:00:59 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oPN9R-0001x5-Dv; Sat, 20 Aug 2022 14:00:29 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1oPN9O-0000zR-NS; Sat, 20 Aug 2022 14:00:26 +0200
Date:   Sat, 20 Aug 2022 14:00:26 +0200
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
Subject: Re: [PATCH net-next v1 4/7] net: pse-pd: add generic PSE driver
Message-ID: <20220820120026.GF10138@pengutronix.de>
References: <20220819120109.3857571-1-o.rempel@pengutronix.de>
 <20220819120109.3857571-5-o.rempel@pengutronix.de>
 <Yv/4du75DNO2Xykr@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Yv/4du75DNO2Xykr@lunn.ch>
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

On Fri, Aug 19, 2022 at 10:54:14PM +0200, Andrew Lunn wrote:
> > +static int
> > +gen_pse_podl_get_admin_sate(struct pse_controller_dev *pcdev, unsigned long id)
> 
> Should that be state?

ack. fixed.

> > +{
> > +	struct gen_pse_priv *priv = to_gen_pse(pcdev);
> > +
> > +	/* aPoDLPSEAdminState can be different to aPoDLPSEPowerDetectionStatus
> > +	 * which is provided by the regulator.
> > +	 */
> > +	return priv->admin_state;
> > +}
> > +
> > +static int
> > +gen_pse_podl_set_admin_control(struct pse_controller_dev *pcdev,
> > +			       unsigned long id,
> > +			       enum ethtool_podl_pse_admin_state state)
> > +{
> > +	struct gen_pse_priv *priv = to_gen_pse(pcdev);
> > +	int ret;
> > +
> > +	if (priv->admin_state == state)
> > +		goto set_state;
> 
> return 0; ?

ack. done

> > +	platform_set_drvdata(pdev, priv);
> > +
> > +	priv->admin_state = ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED;
> 
> There is the comment earlier:
> 
> 	/* aPoDLPSEAdminState can be different to aPoDLPSEPowerDetectionStatus
> 	 * which is provided by the regulator.
> 
> Is this because the regulator might of been turned on, but it has
> detected a short and turned itself off? So it is administratively on,
> but off in order to stop the magic smoke escaping?

ack. According to 30.15.1.1.3 aPoDLPSEPowerDetectionStatus, we may have
following:
/**
 * enum ethtool_podl_pse_pw_d_status - power detection status of the PoDL PSE.
 *	IEEE 802.3-2018 30.15.1.1.3 aPoDLPSEPowerDetectionStatus:
 * @ETHTOOL_PODL_PSE_PW_D_STATUS_UNKNOWN: PoDL PSE
 * @ETHTOOL_PODL_PSE_PW_D_STATUS_DISABLED: "The enumeration “disabled” is
 *	asserted true when the PoDL PSE state diagram variable mr_pse_enable is
 *	false"
 * @ETHTOOL_PODL_PSE_PW_D_STATUS_SEARCHING: "The enumeration “searching” is
 *	asserted true when either of the PSE state diagram variables
 *	pi_detecting or pi_classifying is true."
 * @ETHTOOL_PODL_PSE_PW_D_STATUS_DELIVERING: "The enumeration “deliveringPower”
 *	is asserted true when the PoDL PSE state diagram variable pi_powered is
 *	true."
 * @ETHTOOL_PODL_PSE_PW_D_STATUS_SLEEP: "The enumeration “sleep” is asserted
 *	true when the PoDL PSE state diagram variable pi_sleeping is true."
 * @ETHTOOL_PODL_PSE_PW_D_STATUS_IDLE: "The enumeration “idle” is asserted true
 *	when the logical combination of the PoDL PSE state diagram variables
 *	pi_prebiased*!pi_sleeping is true."
 * @ETHTOOL_PODL_PSE_PW_D_STATUS_ERROR: "The enumeration “error” is asserted
 *	true when the PoDL PSE state diagram variable overload_held is true."
 */

Probably all of them, except of ETHTOOL_PODL_PSE_PW_D_STATUS_SEARCHING can be
potentially implemented in this driver on top of regulator framework.

> But what about the other way around? Something has already turned the
> regulator on, e.g. the bootloader. Should the default be
> ETHTOOL_PODL_PSE_ADMIN_STATE_DISABLED even thought power is being
> delivered? Do we want to put the regulator into the off state at
> probe, so it is in a well defined state? Or set priv->admin_state to
> whatever regulator_is_enabled() indicates?

Good question. I assume, automotive folks would love be able to enable
regulator in the boot loader on the PSE to let the Powered Device boot parallel
to the PSE.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
