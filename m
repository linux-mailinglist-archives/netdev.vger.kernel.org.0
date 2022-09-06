Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0917E5AE925
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 15:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240359AbiIFNLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 09:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240362AbiIFNL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 09:11:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB6BC6CD2A
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 06:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=+nmDwEK1v3HmMHGsmNgJmXnx6xeKeZSsnpTnHeCnATI=; b=FpgON0so2eGOsD6qDCjG9vB765
        BDzqDgIhg97IjS/nKnCO1cwPgQzZUPKjRC2EWgLK8b21ETo7IHt9PhP0lApMiV0y6hxiLIvQkqkN8
        RrGNKtaBuDrYpX9k2ovTKGT74mL74+9w+WrLlpD6ng8Fstn2w49xj+//22jViv+Yml4o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVYM6-00Fkh8-SU; Tue, 06 Sep 2022 15:11:06 +0200
Date:   Tue, 6 Sep 2022 15:11:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com
Subject: Re: [PATCH v2 net] net: phy: aquantia: wait for the suspend/resume
 operations to finish
Message-ID: <YxdG6r0pF7NSW+EJ@lunn.ch>
References: <20220906130451.1483448-1-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906130451.1483448-1-ioana.ciornei@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int aqr107_wait_processor_intensive_op(struct phy_device *phydev)
> +{
> +	int val, err;
> +
> +	/* The datasheet notes to wait at least 1ms after issuing a
> +	 * processor intensive operation before checking.
> +	 * We cannot use the 'sleep_before_read' parameter of read_poll_timeout
> +	 * because that just determines the maximum time slept, not the minimum.
> +	 */
> +	usleep_range(1000, 5000);
> +
> +	err = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
> +					VEND1_GLOBAL_GEN_STAT2, val,
> +					!(val & VEND1_GLOBAL_GEN_STAT2_OP_IN_PROG),
> +					AQR107_OP_IN_PROG_SLEEP,
> +					AQR107_OP_IN_PROG_TIMEOUT, false);
> +	if (err) {
> +		phydev_err(phydev, "timeout: processor-intensive MDIO operation\n");
> +		return err;
> +	}
> +
> +	return 0;

nitpick: You could simplify this to:

> +	if (err)
> +		phydev_err(phydev, "timeout: processor-intensive MDIO operation\n");
> +
> +	return err;
> +}

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
