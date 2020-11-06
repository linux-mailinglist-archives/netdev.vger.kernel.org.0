Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3302A9E7C
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 21:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgKFUNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 15:13:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgKFUNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 15:13:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2914DC0613CF;
        Fri,  6 Nov 2020 12:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=5oicY2GKZKEFQuBu7/i2kWiW5yuI7LeLWBSKiBk081Y=; b=aOx4EJ3siU16FxqTqnb58GqQ1C
        oE22Z86+qRbyNltQRky48XuAerEqq/HuEEDQ32M12gnvOR9YtSGKETk7+D9wTVgTBSf/tFihP2PVs
        1UBMHvzL6xYS1BmCyuRIfaLydIz2jQNkV538v8Y6VP9D4KW70us2wTYg1adDjq8/WoTLBSyj+a3FZ
        gO6MYWE7diXUROsf3csHaczCrSkRL/SfLS2ay82ucI2mJoD2YM5x8Lk0J5bbMMyTRMdv5Xm21a92O
        aBODnpSkvzNFnAtTERX1jLbpGvXuSXHEWl6HSvslhyuEYW4wBy3u3f8b5umCaBjkhgplEBfCvVgD0
        SPg4sj/w==;
Received: from [2601:1c0:6280:3f0::a1cb]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kb86m-0007Xl-Tc; Fri, 06 Nov 2020 20:13:17 +0000
Subject: Re: [PATCH net] net: marvell: prestera: fix compilation with
 CONFIG_BRIDGE=m
To:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>
References: <20201106161128.24069-1-vadym.kochan@plvision.eu>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <4d67e1d4-4f5c-a0c1-ce87-42e141215aa1@infradead.org>
Date:   Fri, 6 Nov 2020 12:13:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201106161128.24069-1-vadym.kochan@plvision.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/6/20 8:11 AM, Vadym Kochan wrote:
> With CONFIG_BRIDGE=m the compilation fails:
> 
>     ld: drivers/net/ethernet/marvell/prestera/prestera_switchdev.o: in function `prestera_bridge_port_event':
>     prestera_switchdev.c:(.text+0x2ebd): undefined reference to `br_vlan_enabled'
> 
> in case the driver is statically enabled.
> 
> Fix it by adding 'BRIDGE || BRIDGE=n' dependency.
> 
> Fixes: e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implementation")
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>


Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.

> ---
>  drivers/net/ethernet/marvell/prestera/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/Kconfig b/drivers/net/ethernet/marvell/prestera/Kconfig
> index b1fcc44f566a..b6f20e2034c6 100644
> --- a/drivers/net/ethernet/marvell/prestera/Kconfig
> +++ b/drivers/net/ethernet/marvell/prestera/Kconfig
> @@ -6,6 +6,7 @@
>  config PRESTERA
>  	tristate "Marvell Prestera Switch ASICs support"
>  	depends on NET_SWITCHDEV && VLAN_8021Q
> +	depends on BRIDGE || BRIDGE=n
>  	select NET_DEVLINK
>  	help
>  	  This driver supports Marvell Prestera Switch ASICs family.
> 


-- 
~Randy
