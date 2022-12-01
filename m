Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C966963F3A1
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 16:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231555AbiLAPUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 10:20:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiLAPUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 10:20:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C47CA47F2;
        Thu,  1 Dec 2022 07:20:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mDOf95eDTZe1lv0pAYb0o56fQ3mCO67yFPfF16RFTr8=; b=nvV4tr2Xebh0CdlfoCcpcWIwGN
        0J1UQKFuGN/RTM0vUU+DCOlZPRxeIQXi2vvFmfmrEYMwbYXGTN6APcx3Ci2R0NpcckMM+DMNTK9eR
        M9istheCxbVY+vG6kQY1HxTOQ8xend1fwl4TCWtMt1+ZW3ITmlgpgz4eOgQY3muhUGEs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0lLa-0044WM-9q; Thu, 01 Dec 2022 16:19:34 +0100
Date:   Thu, 1 Dec 2022 16:19:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, davem@davemloft.net,
        maciej.fijalkowski@intel.com, kuba@kernel.org, edumazet@google.com,
        vigneshr@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 net-next 4/6] net: ethernet: ti: am65-cpsw: Add
 suspend/resume support
Message-ID: <Y4jGBtWurJ4tmHOc@lunn.ch>
References: <20221129133501.30659-1-rogerq@kernel.org>
 <20221129133501.30659-5-rogerq@kernel.org>
 <9fdc4e0eee7ead18c119b6bc3e93f7f73d2980cd.camel@redhat.com>
 <c41064a1-9da7-d848-6f9f-e1f3b722c063@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c41064a1-9da7-d848-6f9f-e1f3b722c063@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 01:44:28PM +0200, Roger Quadros wrote:
> Hi,
> 
> On 01/12/2022 13:40, Paolo Abeni wrote:
> > On Tue, 2022-11-29 at 15:34 +0200, Roger Quadros wrote:
> >> @@ -555,11 +556,26 @@ static int am65_cpsw_nuss_ndo_slave_open(struct net_device *ndev)
> >>  	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
> >>  	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
> >>  	int ret, i;
> >> +	u32 reg;
> >>  
> >>  	ret = pm_runtime_resume_and_get(common->dev);
> >>  	if (ret < 0)
> >>  		return ret;
> >>  
> >> +	/* Idle MAC port */
> >> +	cpsw_sl_ctl_set(port->slave.mac_sl, CPSW_SL_CTL_CMD_IDLE);
> >> +	cpsw_sl_wait_for_idle(port->slave.mac_sl, 100);
> >> +	cpsw_sl_ctl_reset(port->slave.mac_sl);
> >> +
> >> +	/* soft reset MAC */
> >> +	cpsw_sl_reg_write(port->slave.mac_sl, CPSW_SL_SOFT_RESET, 1);
> >> +	mdelay(1);
> >> +	reg = cpsw_sl_reg_read(port->slave.mac_sl, CPSW_SL_SOFT_RESET);
> >> +	if (reg) {
> >> +		dev_err(common->dev, "soft RESET didn't complete\n");
> > 
> > I *think* Andrew was asking for dev_dbg() here, but let's see what he
> > has to say :)
> 
> In the earlier revision we were not exiting with error, so dev_dbg()
> was more appropriate there.
> In this revision we error out so I thought dev_err() was ok.

Yes, i would agree. It is fatal, so dev_err() is appropriate.

What is not shown here is the return value. I think it is -EBUSY? I'm
wondering if -ETIMEDOUT is better?

	  Andrew
