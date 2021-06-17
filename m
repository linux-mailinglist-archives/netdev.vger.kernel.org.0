Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21333AB43C
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 15:04:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhFQNGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 09:06:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42614 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230137AbhFQNGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 09:06:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=UrQRVydZueRPn4YnzvsA9iA4X83PDZ9p8q4NE3A5rb8=; b=fB
        T6sZdaWCgSTUcQjV56KfGjBHSrQygJ8bihOYTEFlBUMhK6bDQEIf/g0cO7SOgeigqzOuJZCzOnccO
        cEe0EeTa0fPZ7cYqU66/8qArQygniqKGfpYNE1ItZ9kBbFbVyaQgeaBb5hYvhHjWl+ZXknU+MP2p/
        RLq5kiV1V92EHLs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ltrgv-009uED-Sa; Thu, 17 Jun 2021 15:04:17 +0200
Date:   Thu, 17 Jun 2021 15:04:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "frieder.schrempf@kontron.de" <frieder.schrempf@kontron.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
Message-ID: <YMtIUVSMxL0iMJLX@lunn.ch>
References: <20210611095005.3909-1-qiangqing.zhang@nxp.com>
 <20210611.132514.1451796354248475314.davem@davemloft.net>
 <DB8PR04MB679518CF771FEBE118E395A3E6309@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMicuzWwAKz5ffWB@lunn.ch>
 <DB8PR04MB6795A2A1D51D95E996B7B75FE60F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YMn3Sd65rzvKasEb@lunn.ch>
 <DB8PR04MB679584EA53A9842D10C33B1EE60E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DB8PR04MB679584EA53A9842D10C33B1EE60E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 17, 2021 at 11:40:58AM +0000, Joakim Zhang wrote:
> 
> Hi Andrew,
> 
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: 2021年6月16日 21:06
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>
> > Cc: David Miller <davem@davemloft.net>; kuba@kernel.org;
> > frieder.schrempf@kontron.de; netdev@vger.kernel.org;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH V2 net-next 0/2] net: fec: fix TX bandwidth fluctuations
> > 
> > > I try below build options, also can't reproduce this issue, so really don't know
> > how to fix it.
> > >
> > > make ARCH=arm64 distclean
> > > make ARCH=arm64 allmodconfig
> > > make -j8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- W=1 / make -j8
> > ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- W=2 / make -j8
> > ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- W=3
> > >
> > > I saw many unrelated warnings...
> > 
> > Then it could be sparse. Install sparse and use C=1.
> 
> After applying the patch #2, I tried to use C=1 yesterday, I double check it today, still no warnings. Anything I missing?
> 
> $ make -j8 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- W=1,C=1
>   CALL    scripts/atomic/check-atomics.sh
>   CALL    scripts/checksyscalls.sh
>   CHK     include/generated/compile.h
>   CHK     kernel/kheaders_data.tar.xz
>   CC [M]  drivers/net/ethernet/freescale/fec_main.o
>   LD [M]  drivers/net/ethernet/freescale/fec.o
>   MODPOST modules-only.symvers
>   GEN     Module.symvers
>   CC [M]  drivers/net/ethernet/freescale/fec.mod.o
>   LD [M]  drivers/net/ethernet/freescale/fec.ko
> 
> Best Regards,
> Joakim Zhang
> >      Andrew


If you look at
https://patchwork.hopto.org/static/nipa/498729/12315211/build_32bit/stdout

you see:

Kernel: arch/x86/boot/bzImage is ready  (#9396)

So it is building for 32 bit x86. So try

make -j8 ARCH=i386 W=1 C=1

Assuming your host is an x86 machine.

	 Andrew
