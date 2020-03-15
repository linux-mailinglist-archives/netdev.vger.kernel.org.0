Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F257185EF1
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 19:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728289AbgCOSZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 14:25:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36936 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727399AbgCOSZR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 15 Mar 2020 14:25:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=powrQRe80aGxECCk+dtKXN3HLIybmgxMPcgaJHiSaLo=; b=dAcfOEZLeXaGsh5vQBzTzYpWwQ
        QoBvIvwFJzEm7lg/gI+jxgbSj+tKI67zGiWkn2sB/cov0fXbMtF1TkZOn2UjLqKuMsIVoUZAgeqwq
        l/ChR1erxzLionAxTCXDjevryHRoejIn+qRqTo7H8NmWNNkTO2OIFi0ilnDo6ULD+noQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jDXwe-0002FB-B9; Sun, 15 Mar 2020 19:25:04 +0100
Date:   Sun, 15 Mar 2020 19:25:04 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 1/2] net: stmmac: use readl_poll_timeout()
 function in init_systime()
Message-ID: <20200315182504.GA8524@lunn.ch>
References: <20200315150301.32129-1-zhengdejin5@gmail.com>
 <20200315150301.32129-2-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200315150301.32129-2-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 11:03:00PM +0800, Dejin Zheng wrote:
> The init_systime() function use an open coded of readl_poll_timeout().
> Replace the open coded handling with the proper function.
> 
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
> v1 -> v2:
> 	- no changed.
> 
>  .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
> index 020159622559..2a24e2a7db3b 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c
> @@ -10,6 +10,7 @@
>  *******************************************************************************/
>  
>  #include <linux/io.h>
> +#include <linux/iopoll.h>
>  #include <linux/delay.h>
>  #include "common.h"
>  #include "stmmac_ptp.h"
> @@ -53,8 +54,8 @@ static void config_sub_second_increment(void __iomem *ioaddr,
>  
>  static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
>  {
> -	int limit;
>  	u32 value;
> +	int err;
>  
>  	writel(sec, ioaddr + PTP_STSUR);
>  	writel(nsec, ioaddr + PTP_STNSUR);
> @@ -64,13 +65,10 @@ static int init_systime(void __iomem *ioaddr, u32 sec, u32 nsec)
>  	writel(value, ioaddr + PTP_TCR);
>  
>  	/* wait for present system time initialize to complete */
> -	limit = 10;
> -	while (limit--) {
> -		if (!(readl(ioaddr + PTP_TCR) & PTP_TCR_TSINIT))
> -			break;
> -		mdelay(10);
> -	}
> -	if (limit < 0)
> +	err = readl_poll_timeout(ioaddr + PTP_TCR, value,
> +				 !(value & PTP_TCR_TSINIT),
> +				 10000, 100000);
> +	if (err)
>  		return -EBUSY;

Hi Dejin

It is normal to just return whatever error code readl_poll_timeout()
returned.

	Andrew
