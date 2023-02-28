Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308176A6214
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjB1WDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:03:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjB1WDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:03:20 -0500
X-Greylist: delayed 1676 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Feb 2023 14:03:18 PST
Received: from hosting.gsystem.sk (hosting.gsystem.sk [212.5.213.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CBCDAC15F;
        Tue, 28 Feb 2023 14:03:18 -0800 (PST)
Received: from [192.168.0.2] (chello089173232159.chello.sk [89.173.232.159])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hosting.gsystem.sk (Postfix) with ESMTPSA id E622C7A0205;
        Tue, 28 Feb 2023 22:35:20 +0100 (CET)
From:   Ondrej Zary <linux@zary.sk>
To:     Arnd Bergmann <arnd@kernel.org>
Subject: Re: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Date:   Tue, 28 Feb 2023 22:35:12 +0100
User-Agent: KMail/1.9.10
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <20230227133457.431729-1-arnd@kernel.org>
In-Reply-To: <20230227133457.431729-1-arnd@kernel.org>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <202302282235.12508.linux@zary.sk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 27 February 2023 14:34:51 Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Based on some recent discussions [1][2][3], I experimented wtih what
> drivers/pcmcia would look like if we completely removed 16-bit support,
> which was one of the options that Dominik suggested for winding down
> pcmcia maintenance.
> 
> The remaining cardbus/yenta support is essentially a PCI hotplug driver
> with a slightly unusual sysfs interface, and it would still support all
> 32-bit cardbus hosts and cards, but no longer work with the even older
> 16-bit cards that require the pcmcia_driver infrastructure.
> 
> I don't expect this to be a problem normal laptop support, as the last
> PC models that predate Cardbus support (e.g. 1997 ThinkPad 380ED) are
> all limited to i586MMX CPUs and 80MB of RAM. This is barely enough to
> boot Tiny Core Linux but not a regular distro.
> 
> Support for device drivers is somewhat less clear. Losing support for
> 16-bit cards in cardbus sockets is obviously a limiting factor for
> anyone who still has those cards, but there is also a good chance that
> the only reason to keep the cards around is for using them in pre-cardbus
> machines that cannot be upgrade to 32-bit devices.

I think that most users are using CardBus controllers, either in laptops (from Pentium MMX up to Core 2, e.g. DELL Latitude E6400) or as PCI (or even PCIe) adapters for desktop machines.
Users generally treat all the cards as PCMCIA and don't know that there are two kinds of them (16-bit PCMCIA and 32-bit CardBus).

> Completely removing the 16-bit PCMCIA support would however break some
> 20+ year old embedded machines that rely on CompactFlash cards as their
> mass-storage device (extension), this notably includes early PocketPC
> models and the reference implementations for OMAP1, StrongARM1100,
> Alchemy and PA-Semi. All of these are still maintained, though most
> of the PocketPC machines got removed in the 6.3 merge window and the
> PA-Semi Electra board is the only one that was introduced after
> 2003.
> 
> The approach that I take in this series is to split drivers/pcmcia
> into two mutually incompatible parts: the Cardbus support contains
> all the code that is relevant for post-1997 laptops and gets moved
> to drivers/pci/hotplug, while the drivers/pcmcia/ subsystem is
> retained for both the older laptops and the embedded systems but no
> longer works with the yenta socket host driver. The BCM63xx
> PCMCIA/Cardbus host driver appears to be unused and conflicts with
> this series, so it is removed in the process.

This is bad. The drivers remain but could not be used by most machines :(

-- 
Ondrej Zary
