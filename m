Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0E05AD3D6
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237280AbiIEN1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiIEN1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:27:04 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E942D40BD2;
        Mon,  5 Sep 2022 06:27:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mdWCP2Z4OGF3Cn0l3It6siclPH5+K+Wk+JlGp94/LHY=; b=SjXigyoVpYE3wZDUd4goTLXLLV
        1vuDQQoXFwZkJcIrZ3EQA3aeF976bizaFA/kTIeVHwPq+/SA4ZXyz1hSYI9M/rklHGGmMtW5lxMdJ
        RJfZXsvkIfmsQZI8O0NpIgqVWOKv1/62NVKftQmcrkPSKEBRAqzd/bqf0PH5FLcUA0S4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVC7x-00FePq-Lu; Mon, 05 Sep 2022 15:27:01 +0200
Date:   Mon, 5 Sep 2022 15:27:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [Patch net] net: phy: lan87xx: change interrupt src of link_up
 to comm_ready
Message-ID: <YxX5JaRfyvKLrHw5@lunn.ch>
References: <20220905072017.9839-1-arun.ramadoss@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220905072017.9839-1-arun.ramadoss@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 12:50:17PM +0530, Arun Ramadoss wrote:
> Currently phy link up/down interrupt is enabled using the
> LAN87xx_INTERRUPT_MASK register. In the lan87xx_read_status function,
> phy link is determined using the T1_MODE_STAT_REG register comm_ready bit.
> comm_ready bit is set using the loc_rcvr_status & rem_rcvr_status.
> Whenever the phy link is up, LAN87xx_INTERRUPT_SOURCE link_up bit is set
> first but comm_ready bit takes some time to set based on local and
> remote receiver status.
> As per the current implementation, interrupt is triggered using link_up
> but the comm_ready bit is still cleared in the read_status function. So,
> link is always down.  Initially tested with the shared interrupt
> mechanism with switch and internal phy which is working, but after
> implementing interrupt controller it is not working.
> It can fixed either by updating the read_status function to read from
> LAN87XX_INTERRUPT_SOURCE register or enable the interrupt mask for
> comm_ready bit. But the validation team recommends the use of comm_ready
> for link detection.
> This patch fixes by enabling the comm_ready bit for link_up in the
> LAN87XX_INTERRUPT_MASK_2 register (MISC Bank) and link_down in
> LAN87xx_INTERRUPT_MASK register.
> 
> Fixes: 8a1b415d70b7 ("net: phy: added ethtool master-slave configuration
> 		     support")

Please don't wrap such lines, even when they are longer than 80
characters. They are used by tooling during back porting.

> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>


Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
