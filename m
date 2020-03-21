Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBB418E2EE
	for <lists+netdev@lfdr.de>; Sat, 21 Mar 2020 17:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727628AbgCUQlz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Mar 2020 12:41:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49156 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727033AbgCUQly (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Mar 2020 12:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LHaettDoJoZs2+agn5nomuBUacGsVNBQvMqBGMyT69I=; b=s+zuYFO0L8hQXbXVRJyeygiLMl
        NRVWcOGfqaLo+kW/8OdHMAsW5Dj7WmR+e2DdSArbv8OeQCipkm1+WEVeKzSctVKro2W4+8mQRH8Qv
        iVk/aK81qBWmCBeOtaJDr5wLt46aG8KLNu68INVD3iJeodnVoA2bhBizPoqMevRW5GOo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jFhBc-00066K-HH; Sat, 21 Mar 2020 17:41:24 +0100
Date:   Sat, 21 Mar 2020 17:41:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dejin Zheng <zhengdejin5@gmail.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, allison@lohutok.net, corbet@lwn.net,
        alexios.zavras@intel.com, broonie@kernel.org, tglx@linutronix.de,
        mchehab+samsung@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/7] net: phy: introduce
 phy_read_mmd_poll_timeout macro
Message-ID: <20200321164124.GC22639@lunn.ch>
References: <20200320133431.9354-1-zhengdejin5@gmail.com>
 <20200320133431.9354-4-zhengdejin5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320133431.9354-4-zhengdejin5@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 20, 2020 at 09:34:27PM +0800, Dejin Zheng wrote:
> it is sometimes necessary to poll a phy register by phy_read_mmd()
> function until its value satisfies some condition. introduce
> phy_read_mmd_poll_timeout() macros that do this.
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
> ---
> v1 -> v2:
> 	- passed a phydev, device address and a reg to replace args...
> 	  parameter in phy_read_mmd_poll_timeout() by Andrew Lunn 's
> 	  suggestion. Andrew Lunn <andrew@lunn.ch>, Thanks very much for
> 	  your help!
> 	- handle phy_read_mmd return an error(the return value < 0) in
> 	  phy_read_mmd_poll_timeout(). Thanks Andrew again.
> 
>  include/linux/phy.h | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 36d9dea04016..bb351f8b8769 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -24,6 +24,7 @@
>  #include <linux/mod_devicetable.h>
>  #include <linux/u64_stats_sync.h>
>  #include <linux/irqreturn.h>
> +#include <linux/iopoll.h>
>  
>  #include <linux/atomic.h>
>  
> @@ -784,6 +785,19 @@ static inline int __phy_modify_changed(struct phy_device *phydev, u32 regnum,
>   */
>  int phy_read_mmd(struct phy_device *phydev, int devad, u32 regnum);
>  
> +#define phy_read_mmd_poll_timeout(val, cond, sleep_us, timeout_us, \
> +				  phydev, devad, regnum) \
> +({ \
> +	int ret = 0; \
> +	ret = read_poll_timeout(phy_read_mmd, val, cond || val < 0, sleep_us, \
> +				timeout_us, phydev, devad, regnum); \

Hi Dejin

You probably should have ( ) here to deal with precedence issues.

(cond) || val < 0

       Andrew
