Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D866B2A19B6
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgJaSkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:40:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbgJaSkq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:40:46 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF11320702;
        Sat, 31 Oct 2020 18:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604169646;
        bh=skJUEgoqkET7svqQtfRHu/uPx8Rw/sIJQTtx5ZQkuVA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jx3Df7BZD/Y1daJQjmKryx9YdgWk3r0M5kqspBdywfNnJ8juemsw4B2kQwA0+PyaM
         4z3rstZSSWaxJA1gJE0y98PvVy8JyBw1Oepo6aJJUSlu75ekOpgF0d7TyUpIbeV6RD
         dpZONZV/OCYoVnR3lc3Z8HOtBh0YX16PWHKiqT40=
Date:   Sat, 31 Oct 2020 11:40:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] net: ethernet: ti: cpsw: disable PTPv1 hw timestamping
 advertisement
Message-ID: <20201031114042.7ccdf507@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029190910.30789-1-grygorii.strashko@ti.com>
References: <20201029190910.30789-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 21:09:10 +0200 Grygorii Strashko wrote:
> The TI CPTS does not natively support PTPv1, only PTPv2. But, as it
> happens, the CPTS can provide HW timestamp for PTPv1 Sync messages, because
> CPTS HW parser looks for PTP messageType id in PTP message octet 0 which
> value is 0 for PTPv1. As result, CPTS HW can detect Sync messages for PTPv1
> and PTPv2 (Sync messageType = 0 for both), but it fails for any other PTPv1
> messages (Delay_req/resp) and will return PTP messageType id 0 for them.
> 
> The commit e9523a5a32a1 ("net: ethernet: ti: cpsw: enable
> HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter") added PTPv1 hw timestamping
> advertisement by mistake, only to make Linux Kernel "timestamping" utility
> work, and this causes issues with only PTPv1 compatible HW/SW - Sync HW
> timestamped, but Delay_req/resp are not.
> 
> Hence, fix it disabling PTPv1 hw timestamping advertisement, so only PTPv1
> compatible HW/SW can properly roll back to SW timestamping.
> 
> Fixes: e9523a5a32a1 ("net: ethernet: ti: cpsw: enable HWTSTAMP_FILTER_PTP_V1_L4_EVENT filter")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

CC: Richard

> diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
> index 4d02c5135611..4619c3a950b0 100644
> --- a/drivers/net/ethernet/ti/cpsw_ethtool.c
> +++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
> @@ -728,7 +728,6 @@ int cpsw_get_ts_info(struct net_device *ndev, struct ethtool_ts_info *info)
>  		(1 << HWTSTAMP_TX_ON);
>  	info->rx_filters =
>  		(1 << HWTSTAMP_FILTER_NONE) |
> -		(1 << HWTSTAMP_FILTER_PTP_V1_L4_EVENT) |
>  		(1 << HWTSTAMP_FILTER_PTP_V2_EVENT);
>  	return 0;
>  }
> diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
> index 51cc29f39038..31c5e36ff706 100644
> --- a/drivers/net/ethernet/ti/cpsw_priv.c
> +++ b/drivers/net/ethernet/ti/cpsw_priv.c
> @@ -639,13 +639,10 @@ static int cpsw_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
>  		break;
>  	case HWTSTAMP_FILTER_ALL:
>  	case HWTSTAMP_FILTER_NTP_ALL:
> -		return -ERANGE;
>  	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
>  	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
>  	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
> -		priv->rx_ts_enabled = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
> -		cfg.rx_filter = HWTSTAMP_FILTER_PTP_V1_L4_EVENT;
> -		break;
> +		return -ERANGE;
>  	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
>  	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
>  	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:

