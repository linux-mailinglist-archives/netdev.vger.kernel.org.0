Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60919441BA9
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 14:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231794AbhKANZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 09:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbhKANZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 09:25:16 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8798BC061714;
        Mon,  1 Nov 2021 06:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=zk7FJWTzuL8NwWu8TJAjAhULBbphyLU1o/0Lk1PLGqM=; b=ju6iFhCitIaM+RnRDypd+1odK3
        FBtNPS5DkmhVsiupsj1msYw5Wvwf2IMyCP4ph2iYR/t1VV8Kvmsrc+QqT3h8ONldfGt1BEUIoNLh9
        8dyFpkEMPomSHpjxYww/c3iS56dfFbpCCpxZOrJ9iKIzMv1T0jQXTp1hA8AhbeWcBQBUvYuB1UdnJ
        vWCSBM8C2pvALZTVMudRDdTos4ja0BhVmddFklmg1ambVAzGtPM7ZhAEVHDytuiYg2pfQkWPFbViD
        XPf+gicRsXQlcMhbPUuCcgwgNJ1XSXDluK/eU7VuGelclDJoqsPLEURJPjhWlVezF/YKXSN5J85m7
        8GwX/w+g==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mhXGr-00GSuj-6A; Mon, 01 Nov 2021 13:22:41 +0000
Subject: Re: [PATCH net-next 6/6] mctp i2c: MCTP I2C binding driver
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     Zev Weiss <zev@bewilderbeest.net>, Wolfram Sang <wsa@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brendan Higgins <brendanhiggins@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
References: <20211101090405.1405987-1-matt@codeconstruct.com.au>
 <20211101090405.1405987-7-matt@codeconstruct.com.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5650511d-f6aa-97a4-ce82-060c2c51afb5@infradead.org>
Date:   Mon, 1 Nov 2021 06:22:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211101090405.1405987-7-matt@codeconstruct.com.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi--

On 11/1/21 2:04 AM, Matt Johnston wrote:
> diff --git a/drivers/net/mctp/Kconfig b/drivers/net/mctp/Kconfig
> index d8f966cedc89..a468ba7c2f0b 100644
> --- a/drivers/net/mctp/Kconfig
> +++ b/drivers/net/mctp/Kconfig
> @@ -3,6 +3,18 @@ if MCTP
>   
>   menu "MCTP Device Drivers"
>   
> +config MCTP_TRANSPORT_I2C
> +	tristate "MCTP SMBus/I2C transport"
> +	# i2c-mux is optional, but we must build as a module if i2c-mux is a module
> +	depends on !I2C_MUX || I2C_MUX=y || m

I'm fairly sure that the ending "m" there forces this to always be built
as a loadable module.  Is that what you meant to do here?

Maybe you want something like this?

	depends on I2C_MUX || !I2C_MUX

That should limit how this driver can be built if I2C_MUX is m.

> +	depends on I2C
> +	depends on I2C_SLAVE
> +	select MCTP_FLOWS
> +	help
> +	  Provides a driver to access MCTP devices over SMBus/I2C transport,
> +	  from DMTF specification DSP0237. A MCTP protocol network device is
> +	  created for each I2C bus that has been assigned a mctp-i2c device.


-- 
~Randy
