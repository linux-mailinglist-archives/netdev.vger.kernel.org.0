Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77AD3636779
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:42:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbiKWRmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237702AbiKWRmh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:42:37 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5AE65DA;
        Wed, 23 Nov 2022 09:42:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lXKv7tLmFFWSiFg8XDXNAbAKOuzyytUGwHdhjfEns0U=; b=ThkdbeRfetBSUlnQpyTOfNDiFR
        EFDF1RzD+bITt4TW/q7TAfzp6sIsf1q/EZ1YS+IwqXg36AVOi1YNx6YvTmLl/VB9YL/HPfaMjwCvN
        QOGWgtdeW9+8/AxQdxZrewpX/AA8vDEfYwGW1Bud87Vq5PH21vz46+oF//g7OKa3gbPU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oxtl4-003FQg-Hv; Wed, 23 Nov 2022 18:42:02 +0100
Date:   Wed, 23 Nov 2022 18:42:02 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, vigneshr@ti.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 net-next 4/6] net: ethernet: ti: am65-cpsw: Add
 suspend/resume support
Message-ID: <Y35bahTL2cMgXM1F@lunn.ch>
References: <20221123124835.18937-1-rogerq@kernel.org>
 <20221123124835.18937-5-rogerq@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123124835.18937-5-rogerq@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int am65_cpsw_nuss_ndev_add_tx_napi(struct am65_cpsw_common *common);
> +

Please move the code around so you don't need this. Ideally as a patch
which only does the move. It is then trivial to review.

>  static void am65_cpsw_port_set_sl_mac(struct am65_cpsw_port *slave,
>  				      const u8 *dev_addr)
>  {
> @@ -555,11 +558,24 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
>  	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
>  	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
>  	int ret, i;
> +	u32 reg;
>  
>  	ret = pm_runtime_resume_and_get(common->dev);
>  	if (ret < 0)
>  		return ret;
>  
> +	/* Idle MAC port */
> +	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
> +	cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
> +	cpsw_sl_ctl_reset(port->slave.mac_sl);
> +
> +	/* soft reset MAC */
> +	cpsw_sl_reg_write(port->slave.mac_sl, CPSW_SL_SOFT_RESET, 1);
> +	mdelay(1);
> +	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
> +	if (reg)
> +		dev_info(common->dev, "mac reset not yet done\n");

Should that be dev_info()? dev_dbg()

       Andrew
