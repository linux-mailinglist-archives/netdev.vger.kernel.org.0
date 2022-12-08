Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83050646DA1
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 11:55:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLHKzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 05:55:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiLHKyz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 05:54:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 445A7F7B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 02:47:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DEC2061ECF
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 10:47:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E488C433D6;
        Thu,  8 Dec 2022 10:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670496476;
        bh=U3wv/ZoFkxtYg0cs2bqh+1rePcoW6CrTAx6+QDj5EKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P/e3snFQswgZ7ynTAxMbNdwQg8r6WXWa+zgaI+1g0CWESyXYwilvnPAdoT1XPvXcN
         SfbmOPWNMTvd4B+NiZ30svOUgXfjAAY9p6Rh01qgr3wdkvkY19hnetbATwTWD9Ngyp
         cEAdukRdTurDr0b/IFA1Sk92dN88vmqvLxtLffiZA7Ev4pPzVTkkUcxwBe8TVsMzHU
         32gQ4UdoyBcQYorsEVy1EhQLG0lRG8nfCC1QbIcuEcUXWqVykVPAO2d9sSFZmvqSIF
         Nr4UFpavb7htqr0PlYXVflhms8UnsEdbXOvpwhl5eQ7f5eTwHOoOLvZss+n6fgKy4x
         FE2m+XoiQ1+3w==
Date:   Thu, 8 Dec 2022 12:47:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v3] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <Y5HA10woHD9n8mpZ@unreal>
References: <20221208092411.1961448-1-yangyingliang@huawei.com>
 <Y5GxxIc9EY6h/qj2@unreal>
 <840947dc-8560-ca51-f4d6-0e2628c181b1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <840947dc-8560-ca51-f4d6-0e2628c181b1@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 06:31:00PM +0800, Yang Yingliang wrote:
> 
> On 2022/12/8 17:43, Leon Romanovsky wrote:
> > On Thu, Dec 08, 2022 at 05:24:11PM +0800, Yang Yingliang wrote:
> > > The dev_kfree_skb() is defined as consume_skb(), and it is not allowed
> > > to call consume_skb() from hardware interrupt context or with interrupts
> > > being disabled. So replace dev_kfree_skb() with dev_consume_skb_irq()
> > > under spin_lock_irqsave().
> > While dev_kfree_skb and consume_skb are the same, the dev_kfree_skb_irq
> > and dev_consume_skb_irq are not. You can't blindly replace
> > dev_kfree_skb with dev_consume_skb_irq. You should check every place, analyze
> > and document why specific option was chosen.
> While calling dev_kfree_skb(consume_skb), the SKB will not be marked as
> dropped,
> to keep the same meaning, so replace it with dev_consume_skb_irq()

This annotation code is relatively new (from 2013), while you are
changing code from pre-git era (<2005). 

Thanks

> 
> Thanks,
> Yang
> > 
> >    3791 static inline void dev_kfree_skb_irq(struct sk_buff *skb)
> >    3792 {
> >    3793         __dev_kfree_skb_irq(skb, SKB_REASON_DROPPED);
> >    3794 }
> >    3795
> >    3796 static inline void dev_consume_skb_irq(struct sk_buff *skb)
> >    3797 {
> >    3798         __dev_kfree_skb_irq(skb, SKB_REASON_CONSUMED);
> >    3799 }
> > 
> > Thanks
> > 
> > 
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > ---
> > > v2 -> v3:
> > >    Update commit message.
> > > 
> > > v1 -> v2:
> > >    Add fix tag.
> > > ---
> > >   drivers/net/ethernet/neterion/s2io.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
> > > index 1d3c4474b7cb..a83d61d45936 100644
> > > --- a/drivers/net/ethernet/neterion/s2io.c
> > > +++ b/drivers/net/ethernet/neterion/s2io.c
> > > @@ -2386,7 +2386,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
> > >   			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);
> > >   			if (skb) {
> > >   				swstats->mem_freed += skb->truesize;
> > > -				dev_kfree_skb(skb);
> > > +				dev_consume_skb_irq(skb);
> > >   				cnt++;
> > >   			}
> > >   		}
> > > -- 
> > > 2.25.1
> > > 
> > .
