Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB225AD835
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbiIEROD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:14:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237123AbiIEROB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:14:01 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE4362AB4;
        Mon,  5 Sep 2022 10:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CUMIXcV5t7ZQeqthxA5sV3p/yXcIvPxOuRdWJnvekYM=; b=Bgh+hwiypOFveZbbjwinXdyxqh
        Hp9ztqlk0eHMoGBZWeofYXhpoo0Ee+cf9uzkZLgdQzBRXbkrWo3b00pQ3NzloLr0iYjRAbhmOmPjh
        vSUyjE+kabeaUv+7gTMpboCiF0dCTG95SeARdHYuNLpK0OJa12AP/iuUmuHCKxHvpTkM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVFfJ-00FfSv-Ew; Mon, 05 Sep 2022 19:13:41 +0200
Date:   Mon, 5 Sep 2022 19:13:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Xiaowu Ding <xiaowu.ding@jaguarmicro.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQw==?= =?utf-8?Q?H?= net-next] driver:
 cadence macb driver support acpi mode
Message-ID: <YxYuRaXxtyMIF/A6@lunn.ch>
References: <20220824121351.578-1-xiaowu.ding@jaguarmicro.com>
 <YwZA+1z7BDCXZn/3@lunn.ch>
 <PS2PR06MB343298952D34545A7372FEFAF27F9@PS2PR06MB3432.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PS2PR06MB343298952D34545A7372FEFAF27F9@PS2PR06MB3432.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 05, 2022 at 02:25:06AM +0000, Xiaowu Ding wrote:
> Hi Andrew:
> 	Thank you very much for your advices.
>  
> 	There will be some problems with the clk_hw_register_fixed_rate interface in the acpi mode.
> 	It seems that the kernel common clock framework can not support the acpi mode,just support the dt mode.

It has two modes:

https://elixir.bootlin.com/linux/v6.0-rc4/source/drivers/clk/clkdev.c#L100
struct clk *clk_get(struct device *dev, const char *con_id)
{
	const char *dev_id = dev ? dev_name(dev) : NULL;
	struct clk_hw *hw;

	if (dev && dev->of_node) {
		hw = of_clk_get_hw(dev->of_node, 0, con_id);
		if (!IS_ERR(hw) || PTR_ERR(hw) == -EPROBE_DEFER)
			return clk_hw_create_clk(dev, hw, dev_id, con_id);
	}

	return __clk_get_sys(dev, dev_id, con_id);
}

If dev has an of_node, it uses of_clk_get_hw().

If dev does not have an of node, it uses __clk_get_sys(), which looks
purely using the clock name.

The common clock framework is older than DT, and so does not force you
to use DT. Please look at making __clk_get_sys() work for you
scenario. You should just need to register the fixed clock using the
correct name. Look at some of the very old boards which have not been
converted to DT.

   Andrew
