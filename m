Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D192812ABBE
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 11:58:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfLZK6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 05:58:43 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40440 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfLZK6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Dec 2019 05:58:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cALXG2PbENnF/2C4T/h1SafJ/8huCECIJInZZtNQHYo=; b=kVYNn3Hfe1mrIUKV2yO7A+gBA4
        uJSJzhMTF9IgIRKcqoqSz1YCtaOy3UomYKPa5ipy9SPMorCbFI2UtalIKcpbCOnQs9ONMwGdvS1N5
        oFHX/iOSbW+5HIQ4RqR9wuNXD6FcyGrMvbKN65ty/2jBEI0IgwjkxTWe3ALmlgMPqQr4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ikQqk-0001AF-Hk; Thu, 26 Dec 2019 11:58:38 +0100
Date:   Thu, 26 Dec 2019 11:58:38 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] net: mscc: ocelot: support PPS signal generation
Message-ID: <20191226105838.GD1480@lunn.ch>
References: <20191226095851.24325-1-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226095851.24325-1-yangbo.lu@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 26, 2019 at 05:58:51PM +0800, Yangbo Lu wrote:
> This patch is to support PPS signal generation for Ocelot family
> switches, including VSC9959 switch.

Hi Yangbo

Please always Cc: Richard Cochran <richardcochran@gmail.com> for ptp
patches.

	Andrew

> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> ---
>  drivers/net/dsa/ocelot/felix_vsc9959.c  |  2 ++
>  drivers/net/ethernet/mscc/ocelot.c      | 25 +++++++++++++++++++++++++
>  drivers/net/ethernet/mscc/ocelot_ptp.h  |  2 ++
>  drivers/net/ethernet/mscc/ocelot_regs.c |  2 ++
>  include/soc/mscc/ocelot.h               |  2 ++
>  5 files changed, 33 insertions(+)
> 
> diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
> index b9758b0..ee0ce7c 100644
> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
> @@ -287,6 +287,8 @@ static const u32 vsc9959_ptp_regmap[] = {
>  	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
>  	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
>  	REG(PTP_PIN_TOD_NSEC,              0x00000c),
> +	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
> +	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
>  	REG(PTP_CFG_MISC,                  0x0000a0),
>  	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
>  	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
> diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
> index 985b46d..c0f8a9e 100644
> --- a/drivers/net/ethernet/mscc/ocelot.c
> +++ b/drivers/net/ethernet/mscc/ocelot.c
> @@ -2147,6 +2147,29 @@ static struct ptp_clock_info ocelot_ptp_clock_info = {
>  	.adjfine	= ocelot_ptp_adjfine,
>  };
>  
> +static void ocelot_ptp_init_pps(struct ocelot *ocelot)
> +{
> +	u32 val;
> +
> +	/* PPS signal generation uses CLOCK action. Together with SYNC option,
> +	 * a single pulse will be generated after <WAFEFORM_LOW> nanoseconds
> +	 * after the time of day has increased the seconds. The pulse will
> +	 * get a width of <WAFEFORM_HIGH> nanoseconds.
> +	 *
> +	 * In default,
> +	 * WAFEFORM_LOW = 0
> +	 * WAFEFORM_HIGH = 1us
> +	 */
> +	ocelot_write_rix(ocelot, 0, PTP_PIN_WF_LOW_PERIOD, ALT_PPS_PIN);
> +	ocelot_write_rix(ocelot, 1000, PTP_PIN_WF_HIGH_PERIOD, ALT_PPS_PIN);
> +
> +	val = ocelot_read_rix(ocelot, PTP_PIN_CFG, ALT_PPS_PIN);
> +	val &= ~(PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION_MASK | PTP_PIN_CFG_DOM);
> +	val |= (PTP_PIN_CFG_SYNC | PTP_PIN_CFG_ACTION(PTP_PIN_ACTION_CLOCK));
> +
> +	ocelot_write_rix(ocelot, val, PTP_PIN_CFG, ALT_PPS_PIN);
> +}
> +
>  static int ocelot_init_timestamp(struct ocelot *ocelot)
>  {
>  	struct ptp_clock *ptp_clock;
> @@ -2478,6 +2501,8 @@ int ocelot_init(struct ocelot *ocelot)
>  				"Timestamp initialization failed\n");
>  			return ret;
>  		}
> +
> +		ocelot_ptp_init_pps(ocelot);
>  	}
>  
>  	return 0;
> diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.h b/drivers/net/ethernet/mscc/ocelot_ptp.h
> index 9ede14a..21bc744 100644
> --- a/drivers/net/ethernet/mscc/ocelot_ptp.h
> +++ b/drivers/net/ethernet/mscc/ocelot_ptp.h
> @@ -13,6 +13,8 @@
>  #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
>  #define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ
>  #define PTP_PIN_TOD_NSEC_RSZ		PTP_PIN_CFG_RSZ
> +#define PTP_PIN_WF_HIGH_PERIOD_RSZ	PTP_PIN_CFG_RSZ
> +#define PTP_PIN_WF_LOW_PERIOD_RSZ	PTP_PIN_CFG_RSZ
>  
>  #define PTP_PIN_CFG_DOM			BIT(0)
>  #define PTP_PIN_CFG_SYNC		BIT(2)
> diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
> index b88b589..ed4dd01 100644
> --- a/drivers/net/ethernet/mscc/ocelot_regs.c
> +++ b/drivers/net/ethernet/mscc/ocelot_regs.c
> @@ -239,6 +239,8 @@ static const u32 ocelot_ptp_regmap[] = {
>  	REG(PTP_PIN_TOD_SEC_MSB,           0x000004),
>  	REG(PTP_PIN_TOD_SEC_LSB,           0x000008),
>  	REG(PTP_PIN_TOD_NSEC,              0x00000c),
> +	REG(PTP_PIN_WF_HIGH_PERIOD,        0x000014),
> +	REG(PTP_PIN_WF_LOW_PERIOD,         0x000018),
>  	REG(PTP_CFG_MISC,                  0x0000a0),
>  	REG(PTP_CLK_CFG_ADJ_CFG,           0x0000a4),
>  	REG(PTP_CLK_CFG_ADJ_FREQ,          0x0000a8),
> diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
> index 64cbbbe..c2ab20d 100644
> --- a/include/soc/mscc/ocelot.h
> +++ b/include/soc/mscc/ocelot.h
> @@ -325,6 +325,8 @@ enum ocelot_reg {
>  	PTP_PIN_TOD_SEC_MSB,
>  	PTP_PIN_TOD_SEC_LSB,
>  	PTP_PIN_TOD_NSEC,
> +	PTP_PIN_WF_HIGH_PERIOD,
> +	PTP_PIN_WF_LOW_PERIOD,
>  	PTP_CFG_MISC,
>  	PTP_CLK_CFG_ADJ_CFG,
>  	PTP_CLK_CFG_ADJ_FREQ,
> -- 
> 2.7.4
> 
