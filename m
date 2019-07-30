Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA46B7AA68
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 16:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729122AbfG3OAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 10:00:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47814 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726351AbfG3OAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 10:00:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=SwbAuGYNR738vPMX2wZZ770KkNXn/jj+ytesRumbdT8=; b=6CZpF/kcIpVApWLtxS1muDtDSi
        riqNwSSmZlOIBoHBRiKrs82NVgKFOOR+NQj1nEN7qOTLoZ+Ae4e4YQjkF7xNM3CTHSpD6nDZoCZvJ
        nG4KecaIEE1aoQU77ebwgXiM3bntFivJbXDkhxOmGC3nJEHeMls51HPxmivp0rCFY1Ks=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hsSfh-000805-L0; Tue, 30 Jul 2019 16:00:09 +0200
Date:   Tue, 30 Jul 2019 16:00:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, richardcochran@gmail.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: extend PTP gettime function to read
 system clock
Message-ID: <20190730140009.GJ28552@lunn.ch>
References: <20190730101007.344-1-h.feurstein@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190730101007.344-1-h.feurstein@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 30, 2019 at 12:10:07PM +0200, Hubert Feurstein wrote:
> This adds support for the PTP_SYS_OFFSET_EXTENDED ioctl.
> 
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>

Please include the PTP maintainer for patches like this. Richard also
wrote this PTP code.

      Andrew

> ---
>  drivers/net/dsa/mv88e6xxx/ptp.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
> index 51cdf4712517..1ff983376f95 100644
> --- a/drivers/net/dsa/mv88e6xxx/ptp.c
> +++ b/drivers/net/dsa/mv88e6xxx/ptp.c
> @@ -230,14 +230,17 @@ static int mv88e6xxx_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>  	return 0;
>  }
>  
> -static int mv88e6xxx_ptp_gettime(struct ptp_clock_info *ptp,
> -				 struct timespec64 *ts)
> +static int mv88e6xxx_ptp_gettimex(struct ptp_clock_info *ptp,
> +				  struct timespec64 *ts,
> +				  struct ptp_system_timestamp *sts)
>  {
>  	struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
>  	u64 ns;
>  
>  	mv88e6xxx_reg_lock(chip);
> +	ptp_read_system_prets(sts);
>  	ns = timecounter_read(&chip->tstamp_tc);
> +	ptp_read_system_postts(sts);
>  	mv88e6xxx_reg_unlock(chip);
>  
>  	*ts = ns_to_timespec64(ns);
> @@ -386,7 +389,7 @@ static void mv88e6xxx_ptp_overflow_check(struct work_struct *work)
>  	struct mv88e6xxx_chip *chip = dw_overflow_to_chip(dw);
>  	struct timespec64 ts;
>  
> -	mv88e6xxx_ptp_gettime(&chip->ptp_clock_info, &ts);
> +	mv88e6xxx_ptp_gettimex(&chip->ptp_clock_info, &ts, NULL);
>  
>  	schedule_delayed_work(&chip->overflow_work,
>  			      MV88E6XXX_TAI_OVERFLOW_PERIOD);
> @@ -444,7 +447,7 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
>  	chip->ptp_clock_info.max_adj    = MV88E6XXX_MAX_ADJ_PPB;
>  	chip->ptp_clock_info.adjfine	= mv88e6xxx_ptp_adjfine;
>  	chip->ptp_clock_info.adjtime	= mv88e6xxx_ptp_adjtime;
> -	chip->ptp_clock_info.gettime64	= mv88e6xxx_ptp_gettime;
> +	chip->ptp_clock_info.gettimex64	= mv88e6xxx_ptp_gettimex;
>  	chip->ptp_clock_info.settime64	= mv88e6xxx_ptp_settime;
>  	chip->ptp_clock_info.enable	= ptp_ops->ptp_enable;
>  	chip->ptp_clock_info.verify	= ptp_ops->ptp_verify;
> -- 
> 2.22.0
> 
