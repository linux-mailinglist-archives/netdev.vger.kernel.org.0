Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED09D51F642
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 10:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbiEIH6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 03:58:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236703AbiEIHxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 03:53:48 -0400
Received: from mxout04.lancloud.ru (mxout04.lancloud.ru [45.84.86.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93363166444
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 00:49:53 -0700 (PDT)
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 37FB020C4C1E
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH net-next 02/10] net: mdio: mdiobus_register: Update
 validation test
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
CC:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "Joakim Zhang" <qiangqing.zhang@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Markus Koch <markus@notsyncing.net>,
        "Geert Uytterhoeven" <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Hao Chen <chenhao288@hisilicon.com>
References: <20220508153049.427227-1-andrew@lunn.ch>
 <20220508153049.427227-3-andrew@lunn.ch>
From:   Sergey Shtylyov <s.shtylyov@omp.ru>
Organization: Open Mobile Platform
Message-ID: <ae79823f-3697-feee-32e6-645c6f4b4e93@omp.ru>
Date:   Mon, 9 May 2022 10:49:49 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220508153049.427227-3-andrew@lunn.ch>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1907.lancloud.ru (fd00:f066::207)
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 5/8/22 6:30 PM, Andrew Lunn wrote:

> Now that C45 uses its own read/write methods, the validation performed
> when a bus is registers needs updating. All combinations of C22 and
> C45 are supported, but both read and write methods must be provided,
> read only busses are not supported etc.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  drivers/net/phy/mdio_bus.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 46a03c0b45e3..818d22fb3cb5 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -526,8 +526,16 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	int i, err;
>  	struct gpio_desc *gpiod;
>  
> -	if (NULL == bus || NULL == bus->name ||
> -	    NULL == bus->read || NULL == bus->write)
> +	if (NULL == bus || NULL == bus->name)

   I suggest (!bus || !bus->name) to be consistent with the code below.
   BTW, doesn't checkpatch.pl complain about NULL == bus?

> +		return -EINVAL;
> +
> +	if (!bus->read != !bus->write)
> +		return -EINVAL;
> +
> +	if (!bus->read_c45 != !bus->write_c45)
> +		return -EINVAL;

   Hm, that's complicated! :-)

> +
> +	if (!bus->read && !bus->read_c45)
>  		return -EINVAL;
>  
>  	if (bus->parent && bus->parent->of_node)

MBR, Sergey
