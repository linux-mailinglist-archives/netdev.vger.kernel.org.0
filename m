Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9B61307F1B
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 21:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhA1UEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 15:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbhA1UCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 15:02:42 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4D0C06121C
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 12:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=xgw2Sk8c2aqdwfgX/8qLjH2vUjcUkRFiXB5v+hG8mpY=; b=qQJXL+YJW/QgC51yXdMErRw3Kx
        RJDT0EiTx2LI7GFOMl9mddYgFDdmx13RsqaBjziEMP2BRUGWrsh814z5XoQyI+1VFJFFFPwNxZeVv
        CdUtqdsJzSpeRDZ5CFZKGfvWip/BPIOGay9YzZahZM4M6RSYvenXZsmg3+YuuxWC6eShflryXg3mf
        xYzlzel2eX63Kpl9ReL9get1CUnXsQTnvztRXodTLTWGqb0ig0myuvUrI9evUtMeDSoxOWEHjHDsM
        RCe7oCGTumdNGIos4aHT3HoTsUSiZzwJOjEsGwPHairZYnYADweHtEfiJzytaDKuqA9gZ9ERvul1b
        atUTUWPw==;
Received: from [2601:1c0:6280:3f0::7650]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1l5DTB-00012G-RY; Thu, 28 Jan 2021 20:00:46 +0000
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Add missing TAPRIO
 dependency
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210128163338.22665-1-kurt@linutronix.de>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <1a076f95-3945-c300-4fea-22d28205aef6@infradead.org>
Date:   Thu, 28 Jan 2021 12:00:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20210128163338.22665-1-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/21 8:33 AM, Kurt Kanzenbach wrote:
> Add missing dependency to TAPRIO to avoid build failures such as:
> 
> |ERROR: modpost: "taprio_offload_get" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
> |ERROR: modpost: "taprio_offload_free" [drivers/net/dsa/hirschmann/hellcreek_sw.ko] undefined!
> 
> Fixes: 24dfc6eb39b2 ("net: dsa: hellcreek: Add TAPRIO offloading support")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  drivers/net/dsa/hirschmann/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> Note: It's not against net, because the fixed commit is not in net tree, yet.
> 
> diff --git a/drivers/net/dsa/hirschmann/Kconfig b/drivers/net/dsa/hirschmann/Kconfig
> index e01191107a4b..9ea2c643f8f8 100644
> --- a/drivers/net/dsa/hirschmann/Kconfig
> +++ b/drivers/net/dsa/hirschmann/Kconfig
> @@ -5,6 +5,7 @@ config NET_DSA_HIRSCHMANN_HELLCREEK
>  	depends on NET_DSA
>  	depends on PTP_1588_CLOCK
>  	depends on LEDS_CLASS
> +	depends on NET_SCH_TAPRIO
>  	select NET_DSA_TAG_HELLCREEK
>  	help
>  	  This driver adds support for Hirschmann Hellcreek TSN switches.
> 

Thanks. This fixes the build errors.
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
 

However, I do see this in the build output when
NET_DSA_HIRSCHMANN_HELLCREEK is disabled:

  AR      drivers/net/dsa/hirschmann/built-in.a

That is an empty archive file (8 bytes), which is caused by
drivers/net/dsa/Makefile:

obj-y				+= hirschmann/


Is there some reason that it's not done like this?
This passes my y/m/n testing.

---
From: Randy Dunlap <rdunlap@infradead.org>

This prevents descending into the net/dsa/hirschmann/ subdirectory
and building an empty archive file:

  AR      drivers/net/dsa/hirschmann/built-in.a

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/net/dsa/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20210128.orig/drivers/net/dsa/Makefile
+++ linux-next-20210128/drivers/net/dsa/Makefile
@@ -18,7 +18,7 @@ obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX) +=
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_PLATFORM) += vitesse-vsc73xx-platform.o
 obj-$(CONFIG_NET_DSA_VITESSE_VSC73XX_SPI) += vitesse-vsc73xx-spi.o
 obj-y				+= b53/
-obj-y				+= hirschmann/
+obj-$(CONFIG_NET_DSA_HIRSCHMANN_HELLCREEK) += hirschmann/
 obj-y				+= microchip/
 obj-y				+= mv88e6xxx/
 obj-y				+= ocelot/




