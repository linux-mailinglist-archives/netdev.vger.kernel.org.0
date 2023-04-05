Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3976D8594
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDESDw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjDESDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:03:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D01AC6EAB;
        Wed,  5 Apr 2023 11:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BB3862A87;
        Wed,  5 Apr 2023 18:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F150AC4339B;
        Wed,  5 Apr 2023 18:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680717762;
        bh=aT/QSekGZ6qxIVg6oZI+/BJiVR31MMBehvh5nsLZPFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KilFKdOA7T0HZQGoP2XLwDq25p142goZ/oHbpNMBGK9IpA0zYV4Gyf+2kKDtkC/nP
         Q9zgYC92ZeJpg25z/li0GNKnXn1dWq8qWfYILKLaxgw/bGL1AESipeRQMhFEZPhsjT
         y4S4XgLmDNbvJdB0saTnL326Waj6PxDTaJXVeUHGO4wFqau0yqpRTuR1mohR4xJbz8
         r0GY5a7khnOYg4H4oNnC79QIxeNZZJnHBCO6L2S5QNSDl9nkHF1rScFM/rxluTuV6U
         fdEIhGZDwmxtBdMrbnYjogBg4YnCwhxmJDmxy9dK7Gl5QPZtbHSpLdfxx3Vrr/IMhT
         wGnPbfEpS2xpA==
Date:   Wed, 5 Apr 2023 20:02:37 +0200
From:   Simon Horman <horms@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH net-next] net: sunhme: move asm includes to below linux
 includes
Message-ID: <ZC23vf6tNKU1FgRP@kernel.org>
References: <20230405-sunhme-includes-fix-v1-1-bf17cc5de20d@kernel.org>
 <082e6ff7-6799-fa80-81e2-6f8092f8bb51@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <082e6ff7-6799-fa80-81e2-6f8092f8bb51@gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 05, 2023 at 01:34:11PM -0400, Sean Anderson wrote:
> On 4/5/23 13:29, Simon Horman wrote:
> > A recent rearrangement of includes has lead to a problem on m68k
> > as flagged by the kernel test robot.
> > 
> > Resolve this by moving the block asm includes to below linux includes.
> > A side effect i that non-Sparc asm includes are now immediately
> > before Sparc asm includes, which seems nice.
> > 
> > Using sparse v0.6.4 I was able to reproduce this problem as follows
> > using the config provided by the kernel test robot:
> > 
> > $ wget https://download.01.org/0day-ci/archive/20230404/202304041748.0sQc4K4l-lkp@intel.com/config
> > $ cp config .config
> > $ make ARCH=m68k oldconfig
> > $ make ARCH=m68k C=2 M=drivers/net/ethernet/sun
> >     CC [M]  drivers/net/ethernet/sun/sunhme.o
> >   In file included from drivers/net/ethernet/sun/sunhme.c:19:
> >   ./arch/m68k/include/asm/irq.h:78:11: error: expected ‘;’ before ‘void’
> >      78 | asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
> >         |           ^~~~~
> >         |           ;
> >   ./arch/m68k/include/asm/irq.h:78:40: warning: ‘struct pt_regs’ declared inside parameter list will not be visible outside of this definition or declaration
> >      78 | asmlinkage void do_IRQ(int irq, struct pt_regs *regs);
> >         |                                        ^~~~~~~
> 
> This seems like a problem with the header. m68k's asm/irq.h should include linux/interrupt.h before its declarations.

Hi Sean,

I do see your point. But TBH I'm unsure which way to go on this one.
Geert, do you have any input?

> --Sean
> 
> > Compile tested only.
> > 
> > Fixes: 1ff4f42aef60 ("net: sunhme: Alphabetize includes")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/oe-kbuild-all/202304041748.0sQc4K4l-lkp@intel.com/
> > Signed-off-by: Simon Horman <horms@kernel.org>
> > ---
> >   drivers/net/ethernet/sun/sunhme.c | 7 ++++---
> >   1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/sun/sunhme.c b/drivers/net/ethernet/sun/sunhme.c
> > index ec85aef35bf9..b93613cd1994 100644
> > --- a/drivers/net/ethernet/sun/sunhme.c
> > +++ b/drivers/net/ethernet/sun/sunhme.c
> > @@ -14,9 +14,6 @@
> >    *     argument : macaddr=0x00,0x10,0x20,0x30,0x40,0x50
> >    */
> > -#include <asm/byteorder.h>
> > -#include <asm/dma.h>
> > -#include <asm/irq.h>
> >   #include <linux/bitops.h>
> >   #include <linux/crc32.h>
> >   #include <linux/delay.h>
> > @@ -45,6 +42,10 @@
> >   #include <linux/types.h>
> >   #include <linux/uaccess.h>
> > +#include <asm/byteorder.h>
> > +#include <asm/dma.h>
> > +#include <asm/irq.h>
> > +
> >   #ifdef CONFIG_SPARC
> >   #include <asm/auxio.h>
> >   #include <asm/idprom.h>
> > 
> 
