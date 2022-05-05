Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056A251BFC8
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 14:48:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377756AbiEEMvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 08:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377741AbiEEMvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 08:51:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D3C5548D;
        Thu,  5 May 2022 05:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=fbetl70oZ0vZnWSXLoFnWrsoXubOKY3J/3Z8Hk4eMTc=; b=Pi
        jLlDfq5PMT7+/FemaIfSg0gNilq1mWd+aLdGJ+2W5IIhseYTdzr772Xw7+TE+SuiAfkmvoE6twUJS
        7Dqx5T+iK7Dcb6VDabOQb+remyjJxUqyNQc+4bhwjfLyMo7GrIil1wYzTKtS5H580z4UGBnXJ3TCY
        KnmhyMF4Cpj/+U4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nmatb-001M5R-8O; Thu, 05 May 2022 14:47:51 +0200
Date:   Thu, 5 May 2022 14:47:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiabing Wan <wanjiabing@vivo.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: Remove unnecessary comparison in
 lan8814_handle_interrupt
Message-ID: <YnPHdzegs33G4JJ8@lunn.ch>
References: <20220505030217.1651422-1-wanjiabing@vivo.com>
 <YnO/VGKVHfFJG7/7@lunn.ch>
 <2ec61428-d9af-7712-b008-cf6b7e445aaa@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2ec61428-d9af-7712-b008-cf6b7e445aaa@vivo.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, I actually check the lanphy_read_page_reg and I notice 'data' is
> declared
> as a 'u32' variable. So I think the comparison is meaningless. But the
> return type is int.
> 
> 1960  static int lanphy_read_page_reg(struct phy_device *phydev, int page,
> u32 addr)
> 1961  {
> 1962      u32 data;
> 1963
> 1964      phy_lock_mdio_bus(phydev);
> 1965      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL, page);
> 1966      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA, addr);
> 1967      __phy_write(phydev, LAN_EXT_PAGE_ACCESS_CONTROL,
> 1968              (page | LAN_EXT_PAGE_ACCESS_CTRL_EP_FUNC));
> 1969      data = __phy_read(phydev, LAN_EXT_PAGE_ACCESS_ADDRESS_DATA);
> 1970      phy_unlock_mdio_bus(phydev);
> 1971
> 1972      return data;
> 1973  }
> > 
> > So the real problem here is, tsu_irq_status is defined as u16, when in
> > fact it should be an int.
> 
> Should the 'data' in lanphy_read_page_reg be declared by 'int'?

Yes.

Another one of those learning over time. If you find a bug, look
around and you will probably find the same bug in other places nearby.

This is actually a pretty common issue we have with Ethernet PHY
drivers, the sign bit getting thrown away. Developers look at the
datasheet and see 16 bit registers, and so use u16, and forget about
the error code. Maybe somebody can write a coccicheck script looking
for calls to and of the phy_read() variants and the result value is
assigned to an unsigned int?

> Finally, I also find other variable, for example, 'u16 addr' in
> lan8814_probe.
> I think they all should be declared by 'int'.

addr should never be used as a return type, so can never carry an
error code. Also, PHYs only have 32 registers, so address is never
greater than 0x1f. So this is O.K.

	Andrew
