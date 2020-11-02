Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 850132A2C0C
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 14:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbgKBNvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 08:51:24 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:58568 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725797AbgKBNvW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 08:51:22 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZaEx-004p3N-LP; Mon, 02 Nov 2020 14:51:19 +0100
Date:   Mon, 2 Nov 2020 14:51:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michal Simek <michal.simek@xilinx.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev <netdev@vger.kernel.org>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net-next 2/3] drivers: net: xilinx_emaclite: Fix
 -Wpointer-to-int-cast warnings with W=1
Message-ID: <20201102135119.GI1109407@lunn.ch>
References: <20201031174721.1080756-1-andrew@lunn.ch>
 <20201031174721.1080756-3-andrew@lunn.ch>
 <c0553efe-73a1-9e13-21e9-71c15d5099b9@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0553efe-73a1-9e13-21e9-71c15d5099b9@xilinx.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 08:20:47AM +0100, Michal Simek wrote:
> 
> 
> On 31. 10. 20 18:47, Andrew Lunn wrote:
> > drivers/net/ethernet//xilinx/xilinx_emaclite.c:341:35: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
> >   341 |   addr = (void __iomem __force *)((u32 __force)addr ^
> > 
> > Use long instead of u32 to avoid problems on 64 bit systems.
> > 
> > Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/ethernet/xilinx/xilinx_emaclite.c | 10 +++++-----
> >  1 file changed, 5 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > index 2c98e4cc07a5..f56c1fd01061 100644
> > --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > @@ -97,7 +97,7 @@
> >  #define ALIGNMENT		4
> >  
> >  /* BUFFER_ALIGN(adr) calculates the number of bytes to the next alignment. */
> > -#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((u32)adr)) % ALIGNMENT)
> > +#define BUFFER_ALIGN(adr) ((ALIGNMENT - ((long)adr)) % ALIGNMENT)
> 
> I can't see any reason to change unsigned type to signed one.

I just found out that the kernel has uintptr_t. I will change it to
that.

> >  	}
> >  
> >  	dev_info(dev,
> > -		 "Xilinx EmacLite at 0x%08X mapped to 0x%08X, irq=%d\n",
> > +		 "Xilinx EmacLite at 0x%08X mapped to 0x%08lX, irq=%d\n",
> >  		 (unsigned int __force)ndev->mem_start,
> > -		 (unsigned int __force)lp->base_addr, ndev->irq);
> > +		 (unsigned long __force)lp->base_addr, ndev->irq);
> 
> This is different case but I don't think address can be signed type here
> too.

So unsigned long.

   Andrew
