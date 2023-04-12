Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 599AD6DE912
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 03:48:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjDLBsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 21:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbjDLBsT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 21:48:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECDA7469D;
        Tue, 11 Apr 2023 18:48:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F07162AD9;
        Wed, 12 Apr 2023 01:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CAF3C433D2;
        Wed, 12 Apr 2023 01:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681264095;
        bh=Pwva1zUZZWgALz6s4BWXSDqH8zfMPLPj6NoNuxX43uI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=me1cRiJr+yQaMYoqgKw1IbJXbr5RMOAyK3OSd7EW2oBisPzeNiWdts/OChmpzcA48
         WB+p5QPLDrhR0cx7vozobJYor//FJ+fIfiIe8NAdDdohyKBqejjijVr18Gzup15V/7
         g8We3OmGOkZoD9H5nE5FOyyWLiHvDxbCq3T/rjS2MDcuaq0ArGEc4TSQYyjaXcgECF
         a/HHY8fTG1XXE4iz3ku4XjNuhkSa1j8r0oB/swE0FdI4WPZ4J1hLLwVGArr69rRBvw
         /ncE2iEzJANhUucXRyJCXET6P1VaPSL6KCJKO7D2SBvFVDp4nwJYuzIkitFUMevXfC
         1+lwpPCozVR3w==
Date:   Tue, 11 Apr 2023 18:48:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rafal Ozieblo <rafalo@cadence.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH net] net: macb: fix a memory corruption in extended
 buffer descriptor mode
Message-ID: <20230411184814.5be340a8@kernel.org>
In-Reply-To: <20230407172402.103168-1-roman.gushchin@linux.dev>
References: <20230407172402.103168-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  7 Apr 2023 10:24:02 -0700 Roman Gushchin wrote:
> The problem is resolved by extending the MACB_RX_WADDR_SIZE
> in the extended mode.
> 
> Fixes: 7b4296148066 ("net: macb: Add support for PTP timestamps in DMA descriptors")
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> Co-developed-by: Lars-Peter Clausen <lars@metafoo.de>
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/net/ethernet/cadence/macb.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index c1fc91c97cee..1b330f7cfc09 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -826,8 +826,13 @@ struct macb_dma_desc_ptp {
>  #define MACB_RX_USED_SIZE			1
>  #define MACB_RX_WRAP_OFFSET			1
>  #define MACB_RX_WRAP_SIZE			1
> +#ifdef MACB_EXT_DESC
> +#define MACB_RX_WADDR_OFFSET			3
> +#define MACB_RX_WADDR_SIZE			29
> +#else
>  #define MACB_RX_WADDR_OFFSET			2
>  #define MACB_RX_WADDR_SIZE			30
> +#endif

Changing register definition based on Kconfig seems a bit old school.

Where is the extended descriptor mode enabled? Is it always on if
Kconfig is set or can it be off for some platforms based on other
capabilities? Judging by macb_dma_desc_get_size() small descriptors 
can still be used even with EXT_DESC?

If I'm grepping correctly thru the painful macro magic this register 
is only used in macb_get_addr(). It'd seem a bit more robust to me 
to open code the extraction of the address based on bp->hw_dma_cap
in that one function.

In addition to maintainers please also CC Harini Katakam
<harini.katakam@xilinx.com> on v2.
