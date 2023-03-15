Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850466BAC84
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:48:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbjCOJsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232139AbjCOJsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:48:12 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A76836703B;
        Wed, 15 Mar 2023 02:47:11 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id D2BC392009C; Wed, 15 Mar 2023 10:47:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id CAFB692009B;
        Wed, 15 Mar 2023 09:47:04 +0000 (GMT)
Date:   Wed, 15 Mar 2023 09:47:04 +0000 (GMT)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     Niklas Schnelle <schnelle@linux.ibm.com>
cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-hams@vger.kernel.org
Subject: Re: [PATCH v3 20/38] net: handle HAS_IOPORT dependencies
In-Reply-To: <20230314121216.413434-21-schnelle@linux.ibm.com>
Message-ID: <alpine.DEB.2.21.2303150938001.53876@angie.orcam.me.uk>
References: <20230314121216.413434-1-schnelle@linux.ibm.com> <20230314121216.413434-21-schnelle@linux.ibm.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Mar 2023, Niklas Schnelle wrote:

> those drivers requiring them. For the DEFXX driver there use of I/O
> ports is optional and we only need to fence those paths.can It also

 Some writing mess-up here, should it read:

"For the DEFXX driver the use of I/O ports is optional and we only need to 
fence those paths. It also [...]"

?

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

 This part would incorrectly disable the driver for !HAS_IOPORT and is not 
needed given the change below:

> diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
> index 1fef8a9b1a0f..5f386eba9618 100644
> --- a/drivers/net/fddi/defxx.c
> +++ b/drivers/net/fddi/defxx.c
> @@ -254,7 +254,7 @@ static const char version[] =
>  #define DFX_BUS_TC(dev) 0
>  #endif
>  
> -#if defined(CONFIG_EISA) || defined(CONFIG_PCI)
> +#ifdef HAS_IOPORT
>  #define dfx_use_mmio bp->mmio
>  #else
>  #define dfx_use_mmio true

is it?

  Maciej
