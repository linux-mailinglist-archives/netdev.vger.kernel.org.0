Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA9060DC51
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 09:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiJZHlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 03:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiJZHlA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 03:41:00 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC9961101
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 00:40:58 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1onb1f-0006ye-HE; Wed, 26 Oct 2022 09:40:35 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1onb1c-0003YL-O6; Wed, 26 Oct 2022 09:40:32 +0200
Date:   Wed, 26 Oct 2022 09:40:32 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, andrew@lunn.ch, saeedm@nvidia.com,
        corbet@lwn.net, michael.chan@broadcom.com,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        moshet@nvidia.com, linux@rempel-privat.de,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <20221026074032.GF8675@pengutronix.de>
References: <20221026020948.1913777-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221026020948.1913777-1-kuba@kernel.org>
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
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Oct 25, 2022 at 07:09:48PM -0700, Jakub Kicinski wrote:
> The previous attempt to augment carrier_down (see Link)
> was not met with much enthusiasm so let's do the simple
> thing of exposing what some devices already maintain.
> Add a common ethtool statistic for link going down.
> Currently users have to maintain per-driver mapping
> to extract the right stat from the vendor-specific ethtool -S
> stats. carrier_down does not fit the bill because it counts
> a lot of software related false positives.
> 
> Add the statistic to the extended link state API to steer
> vendors towards implementing all of it.
> 
> Implement for bnxt. mlx5 and (possibly) enic also have
> a counter for this but I leave the implementation to their
> maintainers.
> 
> Link: https://lore.kernel.org/r/20220520004500.2250674-1-kuba@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: corbet@lwn.net
> CC: michael.chan@broadcom.com
> CC: huangguangbin2@huawei.com
> CC: chenhao288@hisilicon.com
> CC: moshet@nvidia.com
> CC: linux@rempel-privat.de
> CC: linux-doc@vger.kernel.org
> ---
>  Documentation/networking/ethtool-netlink.rst  |  1 +
>  .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 15 +++++++++++++++
>  include/linux/ethtool.h                       | 14 ++++++++++++++
>  include/uapi/linux/ethtool_netlink.h          |  2 ++
>  net/ethtool/linkstate.c                       | 19 ++++++++++++++++++-
>  5 files changed, 50 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> index d578b8bcd8a4..5454aa6c013c 100644
> --- a/Documentation/networking/ethtool-netlink.rst
> +++ b/Documentation/networking/ethtool-netlink.rst
> @@ -491,6 +491,7 @@ any attributes.
>    ``ETHTOOL_A_LINKSTATE_SQI_MAX``       u32     Max support SQI value
>    ``ETHTOOL_A_LINKSTATE_EXT_STATE``     u8      link extended state
>    ``ETHTOOL_A_LINKSTATE_EXT_SUBSTATE``  u8      link extended substate
> +  ``ETHTOOL_A_LINKSTATE_EXT_DOWN_CNT``  u64     count of link down events
>    ====================================  ======  ============================
>  
>  For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> index cc89e5eabcb9..d5957ed00759 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> @@ -4112,6 +4112,20 @@ static void bnxt_get_rmon_stats(struct net_device *dev,
>  	*ranges = bnxt_rmon_ranges;
>  }
>  
> +static void bnxt_get_link_ext_stats(struct net_device *dev,
> +				    struct ethtool_link_ext_stats *stats)
> +{
> +	struct bnxt *bp = netdev_priv(dev);
> +	u64 *rx;
> +
> +	if (BNXT_VF(bp) || !(bp->flags & BNXT_FLAG_PORT_STATS_EXT))
> +		return;
> +
> +	rx = bp->rx_port_stats_ext.sw_stats;
> +	stats->LinkDownEvents =
> +		*(rx + BNXT_RX_STATS_EXT_OFFSET(link_down_events));
> +}
> +

s/LinkDownEvents/link_down_events.

What is the best way to implement it on devices without dedicated HW
counter? I assume in most cases only PHY driver would not real state of
link.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
