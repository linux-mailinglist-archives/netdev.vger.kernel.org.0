Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FA8A1CD1CC
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 08:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgEKGZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 02:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725863AbgEKGZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 02:25:53 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A89C061A0C
        for <netdev@vger.kernel.org>; Sun, 10 May 2020 23:25:53 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jY1sq-0002h4-Ij; Mon, 11 May 2020 08:25:48 +0200
Received: from sha by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1jY1sk-0003yO-BB; Mon, 11 May 2020 08:25:42 +0200
Date:   Mon, 11 May 2020 08:25:42 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     zhoubo.mr@foxmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/davicom: Add SOC to dm9000 to initialize SROM_BANK
 clock.
Message-ID: <20200511062542.GO5877@pengutronix.de>
References: <20200510110213.2432-1-zhoubo.mr@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510110213.2432-1-zhoubo.mr@foxmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:04:25 up 81 days, 13:34, 93 users,  load average: 0.14, 0.30,
 0.19
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 07:02:13PM +0800, zhoubo.mr@foxmail.com wrote:
> From: To-run-away <zhoubo.mr@foxmail.com>
> 
> Increase the use of dm9000 to initialize the SROM_BANK clock in the SOC,
> otherwise the chip will not work.

The dm9000 doesn't have anything called SROM in it. You have to
describe the clock input pin of the dm9000 here, not the pin of
your SoC where the clock is coming out.

> The device tree file can be increased like this:
> ethernet@88000000 {
>     compatible = "davicom,dm9000";
>     ....
>     clocks = <&clocks CLK_SROMC>;
>     clock-names = "sromc";

This must be documented in
Documentation/devicetree/bindings/net/davicom-dm9000.txt.

> +	/* Enable clock if specified */
> +	if (!of_property_read_string(dev->of_node, "clock-names", &clk_name)) {
> +		struct clk *clk = devm_clk_get(dev, clk_name);
> +		if (IS_ERR(clk)) {
> +			dev_err(dev, "cannot get clock of %s\n", clk_name);
> +			ret = PTR_ERR(clk);
> +			goto out;
> +		}
> +		clk_prepare_enable(clk);
> +		dev_info(dev, "enable clock '%s'\n", clk_name);
> +	}

There's devm_clk_get_optional() which you should use here.

the "name" passed to devm_clk_get_optional() should match the name of
the clock, you must specify it according to the dm9000 datasheet. It
makes no sense to read the name from the device tree, instead pick a
name which you expect to be there.

Sascha

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
