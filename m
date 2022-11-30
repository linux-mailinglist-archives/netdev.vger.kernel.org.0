Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9B9B63E0DF
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiK3Tlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiK3Tlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:41:46 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E8C58C46D;
        Wed, 30 Nov 2022 11:41:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zXus7AWbGFvlZk8Sk7ecVLyo2Fsrg0juin66Hc7tbkM=; b=vx83Cifa15/f9FRPh/8/OJaaLi
        2Th5+WMD3IQT6xqoidPo+vhBW7nAI4mU3m2SBngSrwS7Y3avipQJTvGTxbLdjhyj2iDsysKAZyod7
        y3BkMnoDsPajUpr0T7dBuUTw6FDdkQ5LFSOOMk+EHhkiZ00MZlDot3Jd13RAN7qZUjm8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p0SxV-003zgR-1Q; Wed, 30 Nov 2022 20:41:29 +0100
Date:   Wed, 30 Nov 2022 20:41:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Brian Masney <bmasney@redhat.com>
Cc:     irusskikh@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cth451@gmail.com
Subject: Re: [PATCH] net: atlantic: fix check for invalid ethernet addresses
Message-ID: <Y4ex6WqiY8IdwfHe@lunn.ch>
References: <20221130174259.1591567-1-bmasney@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130174259.1591567-1-bmasney@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 12:42:59PM -0500, Brian Masney wrote:
> The Qualcomm sa8540p automotive development board (QDrive3) has an
> Aquantia NIC wired over PCIe. The ethernet MAC address assigned to
> all of the boards in our lab is 00:17:b6:00:00:00. The existing
> check in aq_nic_is_valid_ether_addr() only checks for leading zeros
> in the MAC address. Let's update the check to also check for trailing
> zeros in the MAC address so that a random MAC address is assigned
> in this case.
> 
> Signed-off-by: Brian Masney <bmasney@redhat.com>
> ---
>  drivers/net/ethernet/aquantia/atlantic/aq_nic.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> index 06508eebb585..c9c850bbc805 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> @@ -293,7 +293,8 @@ static bool aq_nic_is_valid_ether_addr(const u8 *addr)
>  	/* Some engineering samples of Aquantia NICs are provisioned with a
>  	 * partially populated MAC, which is still invalid.
>  	 */
> -	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0);
> +	return !(addr[0] == 0 && addr[1] == 0 && addr[2] == 0) &&
> +		!(addr[3] == 0 && addr[4] == 0 && addr[5] == 0);

Hi Brian

is_valid_ether_addr()

	Andrew
