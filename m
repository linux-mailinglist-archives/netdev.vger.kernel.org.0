Return-Path: <netdev+bounces-4288-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 043CC70BE78
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 14:38:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3434281097
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 12:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F74BE71;
	Mon, 22 May 2023 12:38:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ED412B70
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 12:38:04 +0000 (UTC)
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F30DFF1;
	Mon, 22 May 2023 05:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
	s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
	Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
	bh=7fKI+TyL9epRhFvl3Z3296PLWzJTB8PM1oCdqjqMAXc=; b=4iKj9bqO7apDBCcsUu1X3JHG8Y
	vG1LbRHOFKXnXRK1qfdUKrP60ay5wQPJsJEIV+KUsgsFzAThlHT40zC0iCMgE1indGo6EjdMnhfFE
	dgFde4RV5VpTFtSpoHjNXSsVk9UuYs7ojdopEd5q5sThZ1HyYf5kvb1nDGhpx6W81yrE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
	(envelope-from <andrew@lunn.ch>)
	id 1q14hB-00DXcM-0J; Mon, 22 May 2023 14:31:25 +0200
Date: Mon, 22 May 2023 14:31:24 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ramon.nordin.rodriguez@ferroamp.se, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v2 2/6] net: phy: microchip_t1s: replace
 read-modify-write code with phy_modify_mmd
Message-ID: <2c78f2cc-ff5e-4dcd-a309-de21a5725053@lunn.ch>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-3-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522113331.36872-3-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>  
>  	/* Read-Modified Write Pseudocode (from AN1699)
>  	 * current_val = read_register(mmd, addr) // Read current register value

Hi Parthiban

Maybe extend the comment to indicate that although AN1699 says Read,
Modify, Write, the write is not required if the register already has
the required value. That is what phy_modify_mmd() actually does.

> @@ -74,12 +72,11 @@ static int lan867x_config_init(struct phy_device *phydev)
>  	 * write_register(mmd, addr, new_val) // Write back updated register value
>  	 */
>  	for (int i = 0; i < ARRAY_SIZE(lan867x_fixup_registers); i++) {
> -		reg = lan867x_fixup_registers[i];
> -		reg_value = phy_read_mmd(phydev, MDIO_MMD_VEND2, reg);
> -		reg_value &= ~lan867x_fixup_masks[i];
> -		reg_value |= lan867x_fixup_values[i];
> -		err = phy_write_mmd(phydev, MDIO_MMD_VEND2, reg, reg_value);
> -		if (err != 0)
> +		err = phy_modify_mmd(phydev, MDIO_MMD_VEND2,
> +				     lan867x_fixup_registers[i],
> +				     lan867x_fixup_masks[i],
> +				     lan867x_fixup_values[i]);
> +		if (err)
>  			return err;
>  	}


    Andrew

---
pw-bot: cr

