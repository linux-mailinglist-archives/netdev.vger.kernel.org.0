Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DCE52BF95
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239509AbiERPot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbiERPok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:44:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818BC62ED;
        Wed, 18 May 2022 08:44:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DE15B81FB7;
        Wed, 18 May 2022 15:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572A1C385A5;
        Wed, 18 May 2022 15:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652888672;
        bh=yqHK14+o4FTfkkq3NNmohwK2DnXpjOlfNvCu9g713i8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=D7oyQgD++gY2In4fkrJy6/wEeR2tEK2wDl65xLcM5MpAi46HGeImLGsNj1lUDwHmV
         hWu/l4Ug/yIDE7cf463HzRXXIpFCRr11oq7/tHCyxtLF9ZWub++cm3DtPmADnnAzP1
         obt4GbFfEoE2VBnWuZzK9sQIw9esG8q45pOG3J91THIgAZ1a8tAYrw2+ddk+y75POq
         eZVQi5qNv0eI7PjEcS0R8OuMopiCIBlbVlmiKrP1BHl5zhLWM2uOvp2qIsp1XfefS+
         ZVcAd1YGMcPyZMyjhjS6FSszZVIGg1lTNYGJ9QgcG6Nj7ZmXkJ2PeIkC9GcCBlRWUq
         FaNWuQurkmTMw==
Date:   Wed, 18 May 2022 08:44:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 11/15] net: ethernet: mtk_eth_soc: introduce
 device register map
Message-ID: <20220518084431.66aa1737@kernel.org>
In-Reply-To: <YoTA+5gLC4zhoQ0F@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <78e8c6ed230130b75aae77e6d05a9b35e298860a.1652716741.git.lorenzo@kernel.org>
        <20220517184122.522ed708@kernel.org>
        <YoTA+5gLC4zhoQ0F@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 11:48:43 +0200 Lorenzo Bianconi wrote:
> > On Mon, 16 May 2022 18:06:38 +0200 Lorenzo Bianconi wrote:  
> > >  /* PDMA RX Base Pointer Register */
> > > -#define MTK_PRX_BASE_PTR0	0x900
> > > +#define MTK_PRX_BASE_PTR0	(eth->soc->reg_map[MTK_PDMA_BASE] + 0x100)
> > >  #define MTK_PRX_BASE_PTR_CFG(x)	(MTK_PRX_BASE_PTR0 + (x * 0x10))  
> > 
> > Implicit macro arguments are really unpleasant for people doing
> > tree-wide changes or otherwise unfamiliar with the driver.
> > 
> > Nothing we can do to avoid this?  
> 
> I used this approach in order to have just few changes in the codebase. I guess the best
> option would be to explicitly add eth parameter to the register macros, what do you think?

I don't think there's a best known practice, you'll have to exercise
your judgment. Taking a look at a random example of MTK_PDMA_INT_STATUS.
Looks like that one is already assigned to eth->tx_int_status_reg.
Maybe that can be generalized? Personally I'd forgo the macros
completely and just use eth->soc->register_name in the code.
