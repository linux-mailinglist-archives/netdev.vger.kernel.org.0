Return-Path: <netdev+bounces-3034-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E6B77052B4
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:48:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7400A2816DF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:48:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E301E28C1C;
	Tue, 16 May 2023 15:48:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B0D34CF9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 15:48:21 +0000 (UTC)
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTP id 88C9D7D82;
	Tue, 16 May 2023 08:48:04 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id D22EA92009E; Tue, 16 May 2023 17:48:02 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id CDA8492009D;
	Tue, 16 May 2023 16:48:02 +0100 (BST)
Date: Tue, 16 May 2023 16:48:02 +0100 (BST)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Niklas Schnelle <schnelle@linux.ibm.com>
cc: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, 
    Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
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
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, 
    linux-pci@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>, 
    netdev@vger.kernel.org, linux-can@vger.kernel.org, 
    intel-wired-lan@lists.osuosl.org, linux-hams@vger.kernel.org
Subject: Re: [PATCH v4 20/41] net: handle HAS_IOPORT dependencies
In-Reply-To: <20230516110038.2413224-21-schnelle@linux.ibm.com>
Message-ID: <alpine.DEB.2.21.2305161644060.50034@angie.orcam.me.uk>
References: <20230516110038.2413224-1-schnelle@linux.ibm.com> <20230516110038.2413224-21-schnelle@linux.ibm.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 16 May 2023, Niklas Schnelle wrote:

> diff --git a/drivers/net/fddi/defxx.c b/drivers/net/fddi/defxx.c
> index 1fef8a9b1a0f..0fbbb7286008 100644
> --- a/drivers/net/fddi/defxx.c
> +++ b/drivers/net/fddi/defxx.c
> @@ -254,7 +254,7 @@ static const char version[] =
>  #define DFX_BUS_TC(dev) 0
>  #endif
>  
> -#if defined(CONFIG_EISA) || defined(CONFIG_PCI)
> +#ifdef CONFIG_HAS_IOPORT
>  #define dfx_use_mmio bp->mmio
>  #else
>  #define dfx_use_mmio true

 For this part:

Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>

  Maciej

