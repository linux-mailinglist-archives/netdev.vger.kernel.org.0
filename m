Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC35F65E7AD
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232026AbjAEJXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbjAEJXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:23:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E544058323
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 01:22:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5671CB81A3A
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 09:22:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87769C433D2;
        Thu,  5 Jan 2023 09:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672910563;
        bh=bra3Q5LZ9I7DJVX2XXny9sRRgedfqb1w3VNoJ9iefJ4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kLd2MaPePknvqTr6BLM+ZwmTw0mmPyxeeyRzDJWHHLjO6Y/EYYPWqbHE/+hhpFIWx
         DPNn3lh+ZOgPF69OypUeQqbBz+BxNKYYTB5O631LhcGYrOtMdyOqNQ2aS045g6FaHM
         7aH9GO1t5D0BCSWfOx5+bVvbJCtCDG+Syx0Gw/2nuRKBgCxO+QWxXeM/EdeTL3IKSf
         q0qRPCeNgUYIcMI3pLjn0dwdREtryN2VNkyEGRPvJAvK4WDiUZg9fd2FzHu9U8fpLs
         UySPS8wMu/oBd2OocRaJU4SyXqARCoE+kJfIddlhd92ajhY/AJ4VkbU4g9g4dBlCCD
         ihKGq3e48eAgg==
Date:   Thu, 5 Jan 2023 11:22:38 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, sujuan.chen@mediatek.com,
        daniel@makrotopia.org
Subject: Re: [PATCH v2 net-next 5/5] net: ethernet: mtk_wed: add
 reset/reset_complete callbacks
Message-ID: <Y7aW3k4xZVfDb6oh@unreal>
References: <cover.1672840858.git.lorenzo@kernel.org>
 <3145529a2588bba0ded16fc3c1c93ae799024442.1672840859.git.lorenzo@kernel.org>
 <Y7WKcdWap3SrLAp3@unreal>
 <Y7WURTK70778grfD@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y7WURTK70778grfD@lore-desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 04, 2023 at 03:59:17PM +0100, Lorenzo Bianconi wrote:
> > On Wed, Jan 04, 2023 at 03:03:14PM +0100, Lorenzo Bianconi wrote:
> > > Introduce reset and reset_complete wlan callback to schedule WLAN driver
> > > reset when ethernet/wed driver is resetting.
> > > 
> > > Tested-by: Daniel Golle <daniel@makrotopia.org>
> > > Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > > Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  drivers/net/ethernet/mediatek/mtk_eth_soc.c |  6 ++++
> > >  drivers/net/ethernet/mediatek/mtk_wed.c     | 40 +++++++++++++++++++++
> > >  drivers/net/ethernet/mediatek/mtk_wed.h     |  8 +++++
> > >  include/linux/soc/mediatek/mtk_wed.h        |  2 ++
> > >  4 files changed, 56 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > index bafae4f0312e..2d74e26f45c9 100644
> > > --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> > > @@ -3913,6 +3913,10 @@ static void mtk_pending_work(struct work_struct *work)
> > >  		mtk_w32(eth, val, MTK_MAC_MCR(i));
> > >  	}
> > >  
> > > +	rtnl_unlock();
> > > +	mtk_wed_fe_reset();
> > > +	rtnl_lock();
> > 
> > Is it safe to call rtnl_unlock(), perform some work and lock again?
> 
> Yes, mtk_pending_work sets MTK_RESETTING bit and a new reset work is not
> scheduled until this bit is cleared

I'm more worried about opening a window for user-space access while you
are performing FW reset.

<...>

> > > diff --git a/include/linux/soc/mediatek/mtk_wed.h b/include/linux/soc/mediatek/mtk_wed.h
> > > index db637a13888d..ddff54fc9717 100644
> > > --- a/include/linux/soc/mediatek/mtk_wed.h
> > > +++ b/include/linux/soc/mediatek/mtk_wed.h
> > > @@ -150,6 +150,8 @@ struct mtk_wed_device {
> > >  		void (*release_rx_buf)(struct mtk_wed_device *wed);
> > >  		void (*update_wo_rx_stats)(struct mtk_wed_device *wed,
> > >  					   struct mtk_wed_wo_rx_stats *stats);
> > > +		int (*reset)(struct mtk_wed_device *wed);
> > > +		int (*reset_complete)(struct mtk_wed_device *wed);
> > 
> > I don't see any driver implementation of these callbacks in this series.
> > Did I miss it?
> 
> These callbacks are implemented in the mt76 driver. I have not added these
> patches to the series since mt76 patches usually go through Felix/Kalle's
> trees (anyway I am fine to add them to the series if they can go into net-next
> directly).

Usually patches that use specific functionality are submitted together
with API changes.

> 
> Regards,
> Lorenzo
> 
> > 
> > Thanks
> > 
> > >  	} wlan;
> > >  #endif
> > >  };
> > > -- 
> > > 2.39.0
> > > 


