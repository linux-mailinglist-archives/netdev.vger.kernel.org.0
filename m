Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E323F1B10B3
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbgDTPvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:51:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725971AbgDTPvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 11:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Lh77a99giPljqfF36wbR0jOKjoMG3OF3sHupKS46WYE=; b=lopszBcHlHRYucGagBBMuuJfuc
        ZEegBviREAiKs4htL8mldriJ5rojFadfRnLfU5IeenyJ9b82skgC/JV2VgmkWXJx1hAtaobs8ZXUQ
        sArq730y/W8m8rvohR8RiT5tUg3wGNCWJg6/eHLIYpnd5Yj8bv27nqj1D456miFm02+I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jQYhF-003r2w-Ox; Mon, 20 Apr 2020 17:50:57 +0200
Date:   Mon, 20 Apr 2020 17:50:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Vasut <marex@denx.de>
Cc:     Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Petr Stetiar <ynezz@true.cz>,
        YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH V4 07/19] net: ks8851: Remove ks8851_rdreg32()
Message-ID: <20200420155057.GC917792@lunn.ch>
References: <20200414182029.183594-1-marex@denx.de>
 <20200414182029.183594-8-marex@denx.de>
 <20200420140700.6632hztejwcgjwsf@wunner.de>
 <99104102-7973-e80f-9006-9a448403562b@denx.de>
 <20200420142002.2l57umsi3rh5ka7e@wunner.de>
 <e8924fbc-b515-527c-a772-b5ac5cfc1cf4@denx.de>
 <20200420144403.eoo47sq7pwp6yc7d@wunner.de>
 <0edb18eb-0c18-c3cd-a0b7-4ba23428f354@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0edb18eb-0c18-c3cd-a0b7-4ba23428f354@denx.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 05:38:16PM +0200, Marek Vasut wrote:
> On 4/20/20 4:44 PM, Lukas Wunner wrote:
> > On Mon, Apr 20, 2020 at 04:24:05PM +0200, Marek Vasut wrote:
> >> On 4/20/20 4:20 PM, Lukas Wunner wrote:
> >>> On Mon, Apr 20, 2020 at 04:12:59PM +0200, Marek Vasut wrote:
> >>>> On 4/20/20 4:07 PM, Lukas Wunner wrote:
> >>>>> On Tue, Apr 14, 2020 at 08:20:17PM +0200, Marek Vasut wrote:
> >>>>>> The ks8851_rdreg32() is used only in one place, to read two registers
> >>>>>> using a single read. To make it easier to support 16-bit accesses via
> >>>>>> parallel bus later on, replace this single read with two 16-bit reads
> >>>>>> from each of the registers and drop the ks8851_rdreg32() altogether.
> >>>>>>
> >>>>>> If this has noticeable performance impact on the SPI variant of KS8851,
> >>>>>> then we should consider using regmap to abstract the SPI and parallel
> >>>>>> bus options and in case of SPI, permit regmap to merge register reads
> >>>>>> of neighboring registers into single, longer, read.
> >>>>>
> >>>>> Bisection has shown this patch to be the biggest cause of the performance
> >>>>> regression introduced by this series:  Latency increases by about 9 usec.
> >>>>
> >>>> Just for completeness, did you perform this bisect on current linux-next
> >>>> without any patches except this series OR your patched rpi downstream
> >>>> vendor tree Linux 4.19 with preempt-rt patch applied ?
> >>>
> >>> The latter because latency without CONFIG_PREEMPT_RT_FULL=y is too imprecise
> >>> to really see the difference and that's the configuration we care about.
> >>
> >> Why am I not able to see the same on the RPi3 then ?
> >> How can I replicate this observation ?
> > 
> > Compile this branch with CONFIG_PREEMPT_RT_FULL=y:
> > 
> > https://github.com/l1k/linux/commits/revpi-4.19-marek-v4
> > 
> > Alternatively, download this file:
> > 
> > http://wunner.de/ks8851-marekv4.tar
> > 
> > Install the "raspberrypi-kernel" deb-package included in the tarball on a
> > stock Raspbian image and copy one of the included ks8851.ko to:
> > /lib/modules/4.19.95-rt38-v7+/kernel/drivers/net/ethernet/micrel
> 
> Why don't you rather try to replicate this problem in linux-next?

Hi Lukas

4.19 is dead in terms of development work. It is now over 18 months
old. All mainline development work is done against either the last
-rc1 kernel, or a subsystems specific 'for-next' branch.

Please test Marek patches against net-next. If there are performance
regressions with net-next, they should be addressed, but mainline does
not care about some random long time dead tree.

    Andrew
