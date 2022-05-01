Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0DAB5168C8
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 00:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355869AbiEAWvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 18:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234297AbiEAWvp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 18:51:45 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF6FB4349C;
        Sun,  1 May 2022 15:48:10 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id B5CF392009E; Mon,  2 May 2022 00:48:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id A6C2392009D;
        Sun,  1 May 2022 23:48:09 +0100 (BST)
Date:   Sun, 1 May 2022 23:48:09 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Arnd Bergmann <arnd@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "open list:CAN NETWORK DRIVERS" <linux-can@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        "open list:AX.25 NETWORK LAYER" <linux-hams@vger.kernel.org>
Subject: Re: [RFC v2 21/39] net: add HAS_IOPORT dependencies
In-Reply-To: <20220429135108.2781579-36-schnelle@linux.ibm.com>
Message-ID: <alpine.DEB.2.21.2205012324130.9383@angie.orcam.me.uk>
References: <20220429135108.2781579-1-schnelle@linux.ibm.com> <20220429135108.2781579-36-schnelle@linux.ibm.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022, Niklas Schnelle wrote:

> In a future patch HAS_IOPORT=n will result in inb()/outb() and friends
> not being declared. We thus need to add HAS_IOPORT as dependency for
> those drivers using them. It also turns out that with HAS_IOPORT handled
> explicitly HAMRADIO does not need the !S390 dependency and successfully
> builds the bpqether driver.
[...]
> diff --git a/drivers/net/fddi/Kconfig b/drivers/net/fddi/Kconfig
> index 846bf41c2717..fa3f1e0fe143 100644
> --- a/drivers/net/fddi/Kconfig
> +++ b/drivers/net/fddi/Kconfig
> @@ -29,7 +29,7 @@ config DEFZA
>  
>  config DEFXX
>  	tristate "Digital DEFTA/DEFEA/DEFPA adapter support"
> -	depends on FDDI && (PCI || EISA || TC)
> +	depends on FDDI && (PCI || EISA || TC) && HAS_IOPORT
>  	help
>  	  This is support for the DIGITAL series of TURBOchannel (DEFTA),
>  	  EISA (DEFEA) and PCI (DEFPA) controllers which can connect you

 NAK, this has to be sorted out differently (and I think we discussed it 
before).

 The driver works just fine with MMIO where available, so if `inb'/`outb' 
do get removed, then only parts that rely on port I/O need to be disabled.  
In fact there's already such provision there in drivers/net/fddi/defxx.c 
for TURBOchannel systems (CONFIG_TC), which have no port I/O space either:

#if defined(CONFIG_EISA) || defined(CONFIG_PCI)
#define dfx_use_mmio bp->mmio
#else
#define dfx_use_mmio true
#endif

so I guess it's just the conditional that will have to be changed to:

#ifdef CONFIG_HAS_IOPORT

replacing the current explicit bus dependency list.  The compiler will 
then optimise away all the port I/O stuff (though I suspect dummy function 
declarations may be required for `inb'/`outb', etc.).

 I can verify a suitable change with a TURBOchannel configuration once the 
MIPS part has been sorted.

  Maciej
