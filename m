Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F99E3A6741
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 14:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbhFNNBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 09:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232685AbhFNNBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 09:01:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1E3C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 05:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2XWY8+T0nI37jhnflekaZn5L5kbBAayTpdpH7WTXkn0=; b=ngl8+5V1R8yzlqObB7WAQUsWv
        2m+zQDaIdJB89iDZsYZpkRo8B0g3FuBDgVwLhaqqPrbbVze2Le2E84P/5hz4HkRKEr/lOvB5JlZCZ
        WX5e+D/4XOQu0JTMXyj01ndqH2gX3cnCXLTY38Uje9hFlrlLjMlWCs1xYObu9ErJUkLIZfZIJKZBE
        tCMxgUksk4/mqOag+y9dyz53b2M4F7AY53ozfJSQpsk+lvovzliRQkIfsV5cHV+szvT4QH+va0zmf
        yH6ImPt6TCICHnvuaXTv5F6sK0uHNzZNTjITCo4kxAgUkoqJKw9EU7XusDEY1t1IYQc7IakZa61gf
        1JODS3HMg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45006)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lsmBm-0004I4-F0; Mon, 14 Jun 2021 13:59:38 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lsmBl-00048l-NJ; Mon, 14 Jun 2021 13:59:37 +0100
Date:   Mon, 14 Jun 2021 13:59:37 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Radu Pirea <radu-nicolae.pirea@oss.nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH v2 net-next 2/3] net: phy: nxp-c45-tja11xx: fix potential
 RX timestamp wraparound
Message-ID: <20210614125937.GU22278@shell.armlinux.org.uk>
References: <20210614123815.443467-1-olteanv@gmail.com>
 <20210614123815.443467-3-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614123815.443467-3-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 03:38:14PM +0300, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The reconstruction procedure for partial timestamps reads the current
> PTP time and fills in the low 2 bits of the second portion, as well as
> the nanoseconds portion, from the actual hardware packet timestamp.
> Critically, the reconstruction procedure works because it assumes that
> the current PTP time is strictly larger than the hardware timestamp was:
> it detects a 2-bit wraparound of the 'seconds' portion by checking whether
> the 'seconds' portion of the partial hardware timestamp is larger than
> the 'seconds' portion of the current time. That can only happen if the
> hardware timestamp was captured by the PHY during the last phase of a
> 'modulo 4 seconds' interval, and the current PTP time was read by the
> driver during the initial phase of the next 'modulo 4 seconds' interval.
> 
> The partial RX timestamps are added to priv->rx_queue in
> nxp_c45_rxtstamp() and they are processed potentially in parallel by the
> aux worker thread in nxp_c45_do_aux_work(). This means that it is
> possible for nxp_c45_do_aux_work() to process more than one RX timestamp
> during the same schedule.
> 
> There is one premature optimization that will cause issues: for RX
> timestamping, the driver reads the current time only once, and it uses
> that to reconstruct all PTP RX timestamps in the queue. For the second
> and later timestamps, this will be an issue if we are processing two RX
> timestamps which are to the left and to the right, respectively, of a
> 4-bit wraparound of the 'seconds' portion of the PTP time, and the
> current PTP time is also pre-wraparound.
> 
>  0.000000000        4.000000000        8.000000000        12.000000000
>  |..................|..................|..................|............>
>                  ^ ^ ^ ^                                            time
>                  | | | |
>                  | | | process hwts 1 and hwts 2
>                  | | |
>                  | | hwts 2
>                  | |
>                  | read current PTP time
>                  |
>                  hwts 1
> 
> What will happen in that case is that hwts 2 (post-wraparound) will use
> a stale current PTP time that is pre-wraparound.
> But nxp_c45_reconstruct_ts will not detect this condition, because it is
> not coded up for it, so it will reconstruct hwts 2 with a current time
> from the previous 4 second interval (i.e. 0.something instead of
> 4.something).
> 
> This is solvable by making sure that the full 64-bit current time is
> always read after the PHY has taken the partial RX timestamp. We do this
> by reading the current PTP time for every timestamp in the RX queue.
> 
> Fixes: 514def5dd339 ("phy: nxp-c45-tja11xx: add timestamping support")
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> v1->v2: none
> 
>  drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/nxp-c45-tja11xx.c b/drivers/net/phy/nxp-c45-tja11xx.c
> index 902fe1aa7782..118b393b1cbb 100644
> --- a/drivers/net/phy/nxp-c45-tja11xx.c
> +++ b/drivers/net/phy/nxp-c45-tja11xx.c
> @@ -427,8 +427,8 @@ static long nxp_c45_do_aux_work(struct ptp_clock_info *ptp)
>  		nxp_c45_process_txts(priv, &hwts);
>  	}
>  
> -	nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
>  	while ((skb = skb_dequeue(&priv->rx_queue)) != NULL) {
> +		nxp_c45_ptp_gettimex64(&priv->caps, &ts, NULL);
>  		ts_raw = __be32_to_cpu(NXP_C45_SKB_CB(skb)->header->reserved2);
>  		hwts.sec = ts_raw >> 30;
>  		hwts.nsec = ts_raw & GENMASK(29, 0);

This looks good, but while reviewing it, I've been looking at
nxp_c45_reconstruct_ts(). While it is logically correct, this makes
it difficult to understand:

	if ((ts->tv_sec & TS_SEC_MASK) < (hwts->sec & TS_SEC_MASK))
		ts->tv_sec -= BIT(2);

The use of BIT() here seems completely inappropriate and misleading.

The value we really want to be using here is TS_SEC_MASK + 1 - this
has the advantage of making it completely clear that _this_ value
depends on TS_SEC_MASK, and is not some unrelated value.

In any case, for _this_ patch:

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
