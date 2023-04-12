Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88B5A6DEA01
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 05:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbjDLDs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 23:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLDs5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 23:48:57 -0400
X-Greylist: delayed 34081 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 11 Apr 2023 20:48:56 PDT
Received: from out-18.mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A69B310C0
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 20:48:56 -0700 (PDT)
Date:   Tue, 11 Apr 2023 20:48:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1681271334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B4bNfnPuXfdXFddsjnv8bc73z8VhUA5WzYvlHx/Q22A=;
        b=Qb9ceMjZSnxCt7WT8HwvtOBx6u7ZrYEnoeZzIdFkOqwstgTbMJyMctIPy9nCoLH06pN7F3
        le1HxQNCSbWUNdRDw80gwqfTp++RsM+rsvBO4S8b20cLGHeTy6v3BQZRFtI8a3nPISY9KJ
        Tr8Jym1DXBzBOyisqb+oWFoKFwXPPpc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Lars-Peter Clausen <lars@metafoo.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rafal Ozieblo <rafalo@cadence.com>
Subject: Re: [PATCH net] net: macb: fix a memory corruption in extended
 buffer descriptor mode
Message-ID: <ZDYqIj4Fg3tlGKd5@P9FQF9L96D.corp.robot.car>
References: <20230407172402.103168-1-roman.gushchin@linux.dev>
 <20230411184814.5be340a8@kernel.org>
 <6c025530-e2f1-955f-fa5f-8779db23edde@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c025530-e2f1-955f-fa5f-8779db23edde@metafoo.de>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 08:13:51PM -0700, Lars-Peter Clausen wrote:
> On 4/11/23 18:48, Jakub Kicinski wrote:
> > On Fri,  7 Apr 2023 10:24:02 -0700 Roman Gushchin wrote:
> > > The problem is resolved by extending the MACB_RX_WADDR_SIZE
> > > in the extended mode.
> > > 
> > > Fixes: 7b4296148066 ("net: macb: Add support for PTP timestamps in DMA descriptors")
> > > Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> > > Co-developed-by: Lars-Peter Clausen <lars@metafoo.de>
> > > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > > ---
> > >   drivers/net/ethernet/cadence/macb.h | 5 +++++
> > >   1 file changed, 5 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> > > index c1fc91c97cee..1b330f7cfc09 100644
> > > --- a/drivers/net/ethernet/cadence/macb.h
> > > +++ b/drivers/net/ethernet/cadence/macb.h
> > > @@ -826,8 +826,13 @@ struct macb_dma_desc_ptp {
> > >   #define MACB_RX_USED_SIZE			1
> > >   #define MACB_RX_WRAP_OFFSET			1
> > >   #define MACB_RX_WRAP_SIZE			1
> > > +#ifdef MACB_EXT_DESC
> > > +#define MACB_RX_WADDR_OFFSET			3
> > > +#define MACB_RX_WADDR_SIZE			29
> > > +#else
> > >   #define MACB_RX_WADDR_OFFSET			2
> > >   #define MACB_RX_WADDR_SIZE			30
> > > +#endif
> > Changing register definition based on Kconfig seems a bit old school.
> > 
> > Where is the extended descriptor mode enabled? Is it always on if
> > Kconfig is set or can it be off for some platforms based on other
> > capabilities? Judging by macb_dma_desc_get_size() small descriptors
> > can still be used even with EXT_DESC?
> > 
> > If I'm grepping correctly thru the painful macro magic this register
> > is only used in macb_get_addr(). It'd seem a bit more robust to me
> > to open code the extraction of the address based on bp->hw_dma_cap
> > in that one function.
> > 
> > In addition to maintainers please also CC Harini Katakam
> > <harini.katakam@xilinx.com> on v2.
> 
> We had an alternative patch which fixes this based on runtime settings. But
> it didn't seem to be worth it considering the runtime overhead, even though
> it is small. The skb buffer address is guaranteed to be cacheline aligned,
> otherwise the DMA wouldn't work at all. So we know that the LSBs must always
> be 0. We could even unconditionally define MACB_RX_WADDR_OFFSET as 3.

I'd personally prefer this.

> 
> Alternative runtime base patch:
> 
> diff --git a/drivers/net/ethernet/cadence/macb_main.c
> b/drivers/net/ethernet/cadence/macb_main.c
> index d13fb1d31821..1a40d5a26f36 100644
> --- a/drivers/net/ethernet/cadence/macb_main.c
> +++ b/drivers/net/ethernet/cadence/macb_main.c
> @@ -1042,6 +1042,10 @@ static dma_addr_t macb_get_addr(struct macb *bp,
> struct macb_dma_desc *desc)
>         }
>  #endif
>         addr |= MACB_BF(RX_WADDR, MACB_BFEXT(RX_WADDR, desc->addr));
> +#ifdef CONFIG_MACB_USE_HWSTAMP
> +       if (bp->hw_dma_cap & HW_DMA_CAP_PTP)
> +               addr &= ~GEM_BIT(DMA_RXVALID_OFFSET);
> +#endif
>         return addr;
>  }
> 

I think this version is slightly worse because it adds an unconditional
if statement, which can be removed with certain config options.
I can master a version with a helper function, if it's preferable.

But if you like this one, it's fine too, let me know, I'll send an updated
version.

Thanks!
