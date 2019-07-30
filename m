Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DABA7AA57
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 15:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728647AbfG3N60 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 09:58:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725871AbfG3N60 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 09:58:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Es6gjsVPZhh7oW/B1PaVyk+/dbg1z3rminfkvhJm4mo=; b=i9+mzTgzpdN4RWXie0ZZI6S5Er
        GkL2RWUfOi4lPJE+3j25yRw13laef2pVwFBZxEtOHn7kBsBRJYspoSP3Q1RGVqBOdG2HUZ9f9wsjU
        lnAuMiMCceSunKhrMLGypjHpYHIVdaDNMo6DZZ53fF1i4qxdDBvOWQneWUP3qfAJp5/M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSdy-0007y3-SS; Tue, 30 Jul 2019 15:58:22 +0200
Date:   Tue, 30 Jul 2019 15:58:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH 4/4] net: dsa: mv88e6xxx: add PTP support for MV88E6250
 family
Message-ID: <20190730135822.GI28552@lunn.ch>
References: <20190730100429.32479-1-h.feurstein@gmail.com>
 <20190730100429.32479-5-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730100429.32479-5-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 720cace3db4e..64872251e479 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -273,6 +273,10 @@ struct mv88e6xxx_chip {
>  	u16 trig_config;
>  	u16 evcap_config;
>  	u16 enable_count;
> +	u32 ptp_cc_shift;
> +	u32 ptp_cc_mult;
> +	u32 ptp_cc_mult_num;
> +	u32 ptp_cc_mult_dem;

Hi Hubert

Please add these to mv88e6xxx_ptp_ops. You can create a new one of
6250 which has the different values.

>  
>  	/* Per-port timestamping resources. */
>  	struct mv88e6xxx_port_hwtstamp port_hwtstamp[DSA_MAX_PORTS];
> diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
> index 768d256f7c9f..51cdf4712517 100644
> --- a/drivers/net/dsa/mv88e6xxx/ptp.c
> +++ b/drivers/net/dsa/mv88e6xxx/ptp.c
> @@ -15,11 +15,38 @@
>  #include "hwtstamp.h"
>  #include "ptp.h"
>  
> -/* Raw timestamps are in units of 8-ns clock periods. */
> -#define CC_SHIFT	28
> -#define CC_MULT		(8 << CC_SHIFT)
> -#define CC_MULT_NUM	(1 << 9)
> -#define CC_MULT_DEM	15625ULL
> +/* The adjfine API clamps ppb between [-32,768,000, 32,768,000], and
> + * therefore scaled_ppm between [-2,147,483,648, 2,147,483,647].
> + * Set the maximum supported ppb to a round value smaller than the maximum.
> + *
> + * Percentually speaking, this is a +/- 0.032x adjustment of the
> + * free-running counter (0.968x to 1.032x).
> + */
> +#define MV88E6XXX_MAX_ADJ_PPB	32000000
> +
> +/* Family MV88E6250:
> + * Raw timestamps are in units of 10-ns clock periods.
> + *
> + * clkadj = scaled_ppm * 10*2^28 / (10^6 * 2^16)
> + * simplifies to
> + * clkadj = scaled_ppm * 2^7 / 5^5
> + */
> +#define MV88E6250_CC_SHIFT	28
> +#define MV88E6250_CC_MULT	(10 << MV88E6250_CC_SHIFT)
> +#define MV88E6250_CC_MULT_NUM	(1 << 7)
> +#define MV88E6250_CC_MULT_DEM	3125ULL
> +
> +/* Other families:
> + * Raw timestamps are in units of 8-ns clock periods.
> + *
> + * clkadj = scaled_ppm * 8*2^28 / (10^6 * 2^16)
> + * simplifies to
> + * clkadj = scaled_ppm * 2^9 / 5^6
> + */
> +#define MV88E6XXX_CC_SHIFT	28
> +#define MV88E6XXX_CC_MULT	(8 << MV88E6XXX_CC_SHIFT)
> +#define MV88E6XXX_CC_MULT_NUM	(1 << 9)
> +#define MV88E6XXX_CC_MULT_DEM	15625ULL

Nice comments :-)

     Andrew
