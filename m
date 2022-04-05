Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C93054F43E5
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:09:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358975AbiDEUEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1454535AbiDEP6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 11:58:36 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ACBA82D19
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 08:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=fdTy2QipSt2ilSloKM6Bz0bLZTQbPg4xCc/LdGQ2Lls=; b=EBche/hJNuTuHsxC+sdoH/7FA3
        FT80nu32uYuNi6J1O23hcThReg2oDdw1ELNMJplZbpA235gQk1Ne41jxxwOXUGnSCpaZU31ewmwEZ
        9fJk0kc25GXWTGTtz19oWXsVFH4O13SC2Sn71K3QmhDCrOkHKHKuOWqRMHmuO+J8CO0Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbkjY-00EGET-7v; Tue, 05 Apr 2022 17:04:40 +0200
Date:   Tue, 5 Apr 2022 17:04:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Conor.Dooley@microchip.com
Cc:     palmer@rivosinc.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, linux@armlinux.org.uk,
        hkallweit1@gmail.com, linux-riscv@lists.infradead.org
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Message-ID: <YkxaiEbHwduhS2+p@lunn.ch>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [ 2.818894] macb 20112000.ethernet eth0: PHY [20112000.ethernet-ffffffff:09] driver [Generic PHY] (irq=POLL)
> [ 2.828915] macb 20112000.ethernet eth0: configuring for phy/sgmii link mode
> [11.045411] macb 20112000.ethernet eth0: Link is Up - 1Gbps/Full - flow control off
> [11.053247] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready

You have a multi-part link. You need that the PHY reports the line
side is up. Put some printk in genphy_update_link() and look at
phydev->link. You also need that the SGMII link between the PHY and
the SoC is up. That is a bit harder to see, but try adding #define
DEBUG at the top of phylink.c and phy.c so you get additional debug
prints for the state machines.

       Andrew
