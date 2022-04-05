Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0927F4F44FC
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352295AbiDEUDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457498AbiDEQDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 12:03:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D451DCA
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 08:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=H64sRER9IZxDyAABR4li+balZ2bAMiCWiOIqNVvYBBY=; b=nH1T1WK2+6p6RiVuFqClvkbtlZ
        wu20h6W+A0u1TMyE4EWPfYt+dCJMamgFgGcc76SHE6KoU0ySg4GgDt/kjBuWx0oyXhNmMs2xedJiA
        WQBKzH/D8HaKeANKX9AYEsqJuzn3tkdcXbx+BA9xlqtvL67ZlpfNeqmn/XldV2nbg7zmjWXLmXOFS
        cF6616bnLDA0vuBw+kG7gFpwWBVfPppYjnCKpAGngtxeTWugWeSn8YxCFGodEyKfTXfrW5FHsyooF
        C04ziHmT0t61kh/DM+DfUlfVb6YyWDB3ezMGBHMOv+SD13k61FsHDVua/Z7WaFKQi2UcTmOO7kZ5w
        aMmaUQQQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58130)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nblUS-0001dg-Gd; Tue, 05 Apr 2022 16:53:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nblUQ-0004JB-RD; Tue, 05 Apr 2022 16:53:06 +0100
Date:   Tue, 5 Apr 2022 16:53:06 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Conor.Dooley@microchip.com
Cc:     palmer@rivosinc.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux-riscv@lists.infradead.org
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Message-ID: <Ykxl4m1uPPDktZnD@shell.armlinux.org.uk>
References: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f4b057d-1985-5fd3-65c0-f944161c7792@microchip.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 05, 2022 at 01:05:12PM +0000, Conor.Dooley@microchip.com wrote:
> Hey,
> I seem to have come across a regression in the default riscv defconfig
> between riscv-for-linus-5.18-mw0 (bbde015227e8) & v5.18-rc1, exposed by
> c5179ef1ca0c ("RISC-V: Enable RISC-V SBI CPU Idle driver for QEMU virt
> machine") which causes the ethernet phy to not come up on my Icicle kit:
> [ 3.179864] macb 20112000.ethernet eth0: validation of sgmii with support 0000000,00000000,00006280 and advertisement 0000000,00000000,00004280 failed: -EINVAL
> [ 3.194490] macb 20112000.ethernet eth0: Could not attach PHY (-22)

I don't think that would be related to the idle driver. This looks like
the PHY hasn't filled in the supported mask at probe time - do you have
the driver for the PHY built-in or the PHY driver module loaded?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
