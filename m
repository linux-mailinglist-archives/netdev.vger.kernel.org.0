Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E965315EF
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 22:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfEaUNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 16:13:45 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:36944 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727287AbfEaUNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 16:13:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wIylVf3jkiJAX6D8EYgS89slrfft1UhSYMxY+tqkH3g=; b=BLN4ViPmHxkC0MfATTk+vfukb
        ZqvHh1+n2S+ibEB1GB6hfbkaFaF6+FPgGS1910PCLvpuL/yCCxpn27Tp2is2sUBSL35gfgx31vHs5
        deUVLPFHpzbC/7ucwbM2uYa7JomP2VvH4NzP1ujT/9h+rqC7FDyaPhdq4oBK022uH2RyMlkY9FAXd
        0jxWVqW7q2xRivfOMxBi5c/zisxFbArHsp1cszbT/DV7pVeLNhUOjHTBT5QOfhNj6Ap1qSrOTz8FY
        usRse0z2sWhab6+aq6hSr1JPofgzUpJ18qaxXsHy2Nx8pHsP6FSs/iVRs7OnMY4evV3jL0gC+eHwy
        l556x1Alw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38430)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hWnuI-0002tB-Ju; Fri, 31 May 2019 21:13:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hWnuI-0006cn-06; Fri, 31 May 2019 21:13:42 +0100
Date:   Fri, 31 May 2019 21:13:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <hancock@sedsystems.ca>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: Use smaller chunk size when reading
 I2C data
Message-ID: <20190531201341.syriememelbklhvo@shell.armlinux.org.uk>
References: <1559330285-30246-1-git-send-email-hancock@sedsystems.ca>
 <1559330285-30246-3-git-send-email-hancock@sedsystems.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1559330285-30246-3-git-send-email-hancock@sedsystems.ca>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 31, 2019 at 01:18:03PM -0600, Robert Hancock wrote:
> The SFP driver was reading up to 256 bytes of I2C data from the SFP
> module in a single chunk. However, some I2C controllers do not support
> reading that many bytes in a single transaction. Change to use a more
> compatible 16-byte chunk size, since this is not performance critical.

This is the wrong place to fix the problem.  We still end up reading
more than 16 bytes with this approach.  I already have a patch fixing
this the right way, which is in the queue to be sent.

> 
> Signed-off-by: Robert Hancock <hancock@sedsystems.ca>
> ---
>  drivers/net/phy/sfp.c | 38 ++++++++++++++++++++++++--------------
>  1 file changed, 24 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
> index 6b6c83d..23a40a7 100644
> --- a/drivers/net/phy/sfp.c
> +++ b/drivers/net/phy/sfp.c
> @@ -1651,7 +1651,7 @@ static int sfp_module_info(struct sfp *sfp, struct ethtool_modinfo *modinfo)
>  static int sfp_module_eeprom(struct sfp *sfp, struct ethtool_eeprom *ee,
>  			     u8 *data)
>  {
> -	unsigned int first, last, len;
> +	unsigned int first, last;
>  	int ret;
>  
>  	if (ee->len == 0)
> @@ -1659,26 +1659,36 @@ static int sfp_module_eeprom(struct sfp *sfp, struct ethtool_eeprom *ee,
>  
>  	first = ee->offset;
>  	last = ee->offset + ee->len;
> -	if (first < ETH_MODULE_SFF_8079_LEN) {
> -		len = min_t(unsigned int, last, ETH_MODULE_SFF_8079_LEN);
> -		len -= first;
>  
> -		ret = sfp_read(sfp, false, first, data, len);
> +	while (first < last) {
> +		bool a2;
> +		unsigned int this_addr, len;
> +
> +		if (first < ETH_MODULE_SFF_8079_LEN) {
> +			len = min_t(unsigned int, last,
> +				    ETH_MODULE_SFF_8079_LEN);
> +			len -= first;
> +			a2 = false;
> +			this_addr = first;
> +		} else {
> +			len = min_t(unsigned int, last,
> +				    ETH_MODULE_SFF_8472_LEN);
> +			len -= first;
> +			a2 = true;
> +			this_addr = first - ETH_MODULE_SFF_8079_LEN;
> +		}
> +		/* Some I2C adapters cannot read 256 bytes in a single read.
> +		 * Use a smaller chunk size to ensure we are within limits.
> +		 */
> +		len = min_t(unsigned int, len, 16);
> +
> +		ret = sfp_read(sfp, a2, this_addr, data, len);
>  		if (ret < 0)
>  			return ret;
>  
>  		first += len;
>  		data += len;
>  	}
> -	if (first < ETH_MODULE_SFF_8472_LEN && last > ETH_MODULE_SFF_8079_LEN) {
> -		len = min_t(unsigned int, last, ETH_MODULE_SFF_8472_LEN);
> -		len -= first;
> -		first -= ETH_MODULE_SFF_8079_LEN;
> -
> -		ret = sfp_read(sfp, true, first, data, len);
> -		if (ret < 0)
> -			return ret;
> -	}
>  	return 0;
>  }
>  
> -- 
> 1.8.3.1
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
