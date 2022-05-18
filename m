Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E51452BF67
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239569AbiERPrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:47:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239534AbiERPrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:47:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CCE2187046;
        Wed, 18 May 2022 08:47:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5C3AB81FB7;
        Wed, 18 May 2022 15:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271A6C385A5;
        Wed, 18 May 2022 15:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652888862;
        bh=bs9W7OCncR8gEQ1uTaOzOqEwcuKz+nCPcAJadJVgxNc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UZO5OfN2DSJz+BoS0Xq/rGAZmjmQFfex307IwzNHldkA4Vv4MOaL7foOTDUtx5nrz
         lcrHqDjXUlzNbILx2j+RCzjKef4u+1+KU5nijpNWHslUOP0c7bBcdTJlpQrihfIDFP
         r9/RbSc7YCHUl5bZ3PS2GR1p85XvHNB941mxhRSFMX2gW5+FOKPtgkDgI8SpGC7fr1
         gxKIO4d10CjWcuKxgpTV5YMrpI92I2YeFYESDvKGyAVDvZpVgBjVdxVfQBhU7x5+J3
         FsCml0JYbo+G68tWS2N+jP7KeltVjyLy7aQ8AsdFaOfPe8hxfksyKvtSITNf9+FRvy
         2OG72z6kkUvIw==
Date:   Wed, 18 May 2022 08:47:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        Sam.Shih@mediatek.com, linux-mediatek@lists.infradead.org,
        devicetree@vger.kernel.org, robh@kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next 12/15] net: ethernet: mtk_eth_soc: introduce
 MTK_NETSYS_V2 support
Message-ID: <20220518084740.7947b51b@kernel.org>
In-Reply-To: <YoTCCAKpE5ijiom0@lore-desk>
References: <cover.1652716741.git.lorenzo@kernel.org>
        <cc1bd411e3028e2d6b0365ed5d29f3cea66223f8.1652716741.git.lorenzo@kernel.org>
        <20220517184433.3cb2fd5a@kernel.org>
        <YoTCCAKpE5ijiom0@lore-desk>
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

On Wed, 18 May 2022 11:53:12 +0200 Lorenzo Bianconi wrote:
> > > +	WRITE_ONCE(desc->txd7, 0);
> > > +	WRITE_ONCE(desc->txd8, 0);  
> > 
> > Why all the WRITE_ONCE()? Don't you just need a barrier between writing
> > the descriptor and kicking the HW?   
> 
> I used this approach just to be aligned with current codebase:
> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mediatek/mtk_eth_soc.c#L1006
> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/mediatek/mtk_eth_soc.c#L1031
> 
> but I guess we can even convert the code to use barrier instead. Agree?

Oh, I didn't realize. No preference on converting the old code 
but it looks like a cargo cult to me so in the new code let's 
not WRITE_ONCE() all descriptor writes unless there's a reason.
