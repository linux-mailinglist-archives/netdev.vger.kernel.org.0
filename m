Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6064845EBA2
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 11:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376959AbhKZKeN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 26 Nov 2021 05:34:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbhKZKcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 05:32:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9037CC06137F
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 02:19:18 -0800 (PST)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1mqYJv-0008Rr-KS; Fri, 26 Nov 2021 11:19:07 +0100
Received: from pza by lupine with local (Exim 4.94.2)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1mqYJt-0005nZ-Nq; Fri, 26 Nov 2021 11:19:05 +0100
Message-ID: <65e4c9936f95a23ad56498ac198fd4df35eb8fd6.camel@pengutronix.de>
Subject: Re: [PATCH net-next v4 2/6] net: lan966x: add the basic lan966x
 driver
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk, andrew@lunn.ch, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Fri, 26 Nov 2021 11:19:05 +0100
In-Reply-To: <20211126090540.3550913-3-horatiu.vultur@microchip.com>
References: <20211126090540.3550913-1-horatiu.vultur@microchip.com>
         <20211126090540.3550913-3-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Horatiu,

On Fri, 2021-11-26 at 10:05 +0100, Horatiu Vultur wrote:
[...]
> +static int lan966x_reset_switch(struct lan966x *lan966x)
> +{
> +	struct reset_control *reset;
> +	int val = 0;
> +	int ret;
> +
> +	reset = devm_reset_control_get_shared(lan966x->dev, "switch");
> +	if (IS_ERR(reset))
> +		return dev_err_probe(lan966x->dev, PTR_ERR(reset),
> +				     "Could not obtain switch reset");
> +	reset_control_reset(reset);
> +
> +	reset = devm_reset_control_get_shared(lan966x->dev, "phy");
> +	if (IS_ERR(reset))
> +		return dev_err_probe(lan966x->dev, PTR_ERR(reset),
> +				     "Could not obtain phy reset\n");
> +	reset_control_reset(reset);

In general, please request all resources before activating the hardware.
Here I'd request both reset controls first and only then trigger them.
That way a failure to optain the phy reset won't cause an unnecessary
switch reset.

[...]
> +static int lan966x_remove(struct platform_device *pdev)
> +{
> +	return 0;
> +}

If there is nothing to do here, this function can be removed altogether.

regards
Philipp
