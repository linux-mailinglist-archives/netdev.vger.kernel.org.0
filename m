Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F25084EED3B
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 14:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345989AbiDAMiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 08:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345955AbiDAMiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 08:38:00 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F121AE61C;
        Fri,  1 Apr 2022 05:36:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sULdgJFq1r98J4IABATa5J7jKAkJH1Eot/nxqWikadM=; b=wRJNXr0AplaS8BsuBS5hgbZ+9N
        IfvMPO+CiPI+vC0GG6e1xfZEndUIjiXKaMEQDQ/eKDe+CrPNL5067sHkCeVdnCJvWF8/eBpuZapYJ
        w3zg3ZUgL0K3vXjqnaE6hz9hIvD2poZRBFHPnA2TKIc1cZhbra5qnq1OSSyex2oDtm80=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1naGVb-00DfXD-Ty; Fri, 01 Apr 2022 14:36:07 +0200
Date:   Fri, 1 Apr 2022 14:36:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, richardcochran@gmail.com,
        UNGLinuxDriver@microchip.com
Subject: Re: [RFC PATCH net-next 1/2] ethtool: Extend to allow to set PHY
 latencies
Message-ID: <YkbxtzE/BRfz0XTW@lunn.ch>
References: <20220401093909.3341836-1-horatiu.vultur@microchip.com>
 <20220401093909.3341836-2-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220401093909.3341836-2-horatiu.vultur@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 01, 2022 at 11:39:08AM +0200, Horatiu Vultur wrote:
> Extend ethtool uapi to allow to configure the latencies for the PHY.
> Allow to configure the latency per speed and per direction.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  include/uapi/linux/ethtool.h |  6 ++++++
>  net/ethtool/common.c         |  6 ++++++
>  net/ethtool/ioctl.c          | 10 ++++++++++
>  3 files changed, 22 insertions(+)
> 
> diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> index 7bc4b8def12c..f120904a4e43 100644
> --- a/include/uapi/linux/ethtool.h
> +++ b/include/uapi/linux/ethtool.h
> @@ -296,6 +296,12 @@ enum phy_tunable_id {
>  	ETHTOOL_PHY_DOWNSHIFT,
>  	ETHTOOL_PHY_FAST_LINK_DOWN,
>  	ETHTOOL_PHY_EDPD,
> +	ETHTOOL_PHY_LATENCY_RX_10MBIT,
> +	ETHTOOL_PHY_LATENCY_TX_10MBIT,
> +	ETHTOOL_PHY_LATENCY_RX_100MBIT,
> +	ETHTOOL_PHY_LATENCY_TX_100MBIT,
> +	ETHTOOL_PHY_LATENCY_RX_1000MBIT,
> +	ETHTOOL_PHY_LATENCY_TX_1000MBIT,

How does this scale with 2.5G, 5G, 10G, 14G, 40G, etc.

Could half duplex differ to full duplex? What about 1000BaseT vs
1000BaseT1 and 1000BaseT2? The Aquantia/Marvell PHY can do both
1000BaseT and 1000BaseT2 and will downshift from 4 pairs to 2 pairs if
you have the correct magic in its firmware blobs.

A more generic API would pass a link mode, a direction and a
latency. The driver can then return -EOPNOTSUPP for a mode it does not
support.

	Andrew
