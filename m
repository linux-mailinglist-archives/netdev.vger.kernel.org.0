Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2211C1B0EC6
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726601AbgDTOoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:44:05 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:56533 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgDTOoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:44:05 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id 79AFA2800B483;
        Mon, 20 Apr 2020 16:44:03 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 491E515BC99; Mon, 20 Apr 2020 16:44:03 +0200 (CEST)
Date:   Mon, 20 Apr 2020 16:44:03 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Marek Vasut <marex@denx.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V4 07/19] net: ks8851: Remove ks8851_rdreg32()
Message-ID: <20200420144403.eoo47sq7pwp6yc7d@wunner.de>
References: <20200414182029.183594-1-marex@denx.de>
 <20200414182029.183594-8-marex@denx.de>
 <20200420140700.6632hztejwcgjwsf@wunner.de>
 <99104102-7973-e80f-9006-9a448403562b@denx.de>
 <20200420142002.2l57umsi3rh5ka7e@wunner.de>
 <e8924fbc-b515-527c-a772-b5ac5cfc1cf4@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e8924fbc-b515-527c-a772-b5ac5cfc1cf4@denx.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 04:24:05PM +0200, Marek Vasut wrote:
> On 4/20/20 4:20 PM, Lukas Wunner wrote:
> > On Mon, Apr 20, 2020 at 04:12:59PM +0200, Marek Vasut wrote:
> >> On 4/20/20 4:07 PM, Lukas Wunner wrote:
> >>> On Tue, Apr 14, 2020 at 08:20:17PM +0200, Marek Vasut wrote:
> >>>> The ks8851_rdreg32() is used only in one place, to read two registers
> >>>> using a single read. To make it easier to support 16-bit accesses via
> >>>> parallel bus later on, replace this single read with two 16-bit reads
> >>>> from each of the registers and drop the ks8851_rdreg32() altogether.
> >>>>
> >>>> If this has noticeable performance impact on the SPI variant of KS8851,
> >>>> then we should consider using regmap to abstract the SPI and parallel
> >>>> bus options and in case of SPI, permit regmap to merge register reads
> >>>> of neighboring registers into single, longer, read.
> >>>
> >>> Bisection has shown this patch to be the biggest cause of the performance
> >>> regression introduced by this series:  Latency increases by about 9 usec.
> >>
> >> Just for completeness, did you perform this bisect on current linux-next
> >> without any patches except this series OR your patched rpi downstream
> >> vendor tree Linux 4.19 with preempt-rt patch applied ?
> > 
> > The latter because latency without CONFIG_PREEMPT_RT_FULL=y is too imprecise
> > to really see the difference and that's the configuration we care about.
> 
> Why am I not able to see the same on the RPi3 then ?
> How can I replicate this observation ?

Compile this branch with CONFIG_PREEMPT_RT_FULL=y:

https://github.com/l1k/linux/commits/revpi-4.19-marek-v4

Alternatively, download this file:

http://wunner.de/ks8851-marekv4.tar

Install the "raspberrypi-kernel" deb-package included in the tarball on a
stock Raspbian image and copy one of the included ks8851.ko to:
/lib/modules/4.19.95-rt38-v7+/kernel/drivers/net/ethernet/micrel

Thanks,

Lukas
