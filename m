Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB2565CB15
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 01:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238797AbjADArM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 19:47:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238527AbjADArL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 19:47:11 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B10E295
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 16:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fzAYK8XENSnKctlJIpDHoKZD1BfWPcqTtAgkHNZR9O4=; b=mSujSeX3tHxdRCZhbg8bsFcGi3
        /BmILa6nlck53LVrCjKExT38cLnLuIv0dh/v99wtzqH7Rd7woLggmQ82BCMytc+TIPqZHvoWogBS8
        KREn39+iL8cdfrJbFDgXdXTOXnUOi0M6kGdqa6Mjos5XwO/2EiytF4zR7ck89AbwNKVs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pCrvp-0015hP-U2; Wed, 04 Jan 2023 01:47:01 +0100
Date:   Wed, 4 Jan 2023 01:47:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, Jamie Gloudon <jamie.gloudon@gmx.fr>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net-next 1/1] e1000e: Enable Link Partner Advertised
 Support
Message-ID: <Y7TMhVy5CdqqysRb@lunn.ch>
References: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230103230653.1102544-1-anthony.l.nguyen@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> --- a/drivers/net/ethernet/intel/e1000e/phy.c
> +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> @@ -2,6 +2,7 @@
>  /* Copyright(c) 1999 - 2018 Intel Corporation. */
>  
>  #include "e1000.h"
> +#include <linux/ethtool.h>
>  
>  static s32 e1000_wait_autoneg(struct e1000_hw *hw);
>  static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
> @@ -1011,6 +1012,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
>  		 */
>  		mii_autoneg_adv_reg &=
>  		    ~(ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> +		phy->autoneg_advertised &=
> +		    ~(ADVERTISED_Pause | ADVERTISED_Asym_Pause);
>  		break;
>  	case e1000_fc_rx_pause:
>  		/* Rx Flow control is enabled, and Tx Flow control is
> @@ -1024,6 +1027,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
>  		 */
>  		mii_autoneg_adv_reg |=
>  		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> +		phy->autoneg_advertised |=
> +		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
>  		break;
>  	case e1000_fc_tx_pause:
>  		/* Tx Flow control is enabled, and Rx Flow control is
> @@ -1031,6 +1036,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
>  		 */
>  		mii_autoneg_adv_reg |= ADVERTISE_PAUSE_ASYM;
>  		mii_autoneg_adv_reg &= ~ADVERTISE_PAUSE_CAP;
> +		phy->autoneg_advertised |= ADVERTISED_Asym_Pause;
> +		phy->autoneg_advertised &= ~ADVERTISED_Pause;
>  		break;
>  	case e1000_fc_full:
>  		/* Flow control (both Rx and Tx) is enabled by a software
> @@ -1038,6 +1045,8 @@ static s32 e1000_phy_setup_autoneg(struct e1000_hw *hw)
>  		 */
>  		mii_autoneg_adv_reg |=
>  		    (ADVERTISE_PAUSE_ASYM | ADVERTISE_PAUSE_CAP);
> +		phy->autoneg_advertised |=
> +		    (ADVERTISED_Pause | ADVERTISED_Asym_Pause);
>  		break;
>  	default:
>  		e_dbg("Flow control param set incorrectly\n");
> -- 

I don't know this driver at all. What i don't see anywhere here is
using the results of the pause auto-neg. Is there some code somewhere
that looks at the local and link peer advertising values and runs a
resolve algorithm to determine what pause should be used, and program
it into the MAC?

    Andrew
