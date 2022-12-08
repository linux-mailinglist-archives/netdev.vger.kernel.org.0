Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E6F0646B09
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 09:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbiLHIvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 03:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbiLHIvQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 03:51:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34727CDC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:51:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3A29B80D67
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:51:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE7EC433C1;
        Thu,  8 Dec 2022 08:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670489472;
        bh=nURjHJt3VSfBj7tqjTeLVMOi52i8o/BhoDNewmHpe5E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fjqUjDuHAchfFjxYfLwOqtlj3ceOp+5ukSZyFmsB9CsxjdwRYeUlDLGnAdASksHWi
         KSW3AlPTjyNOAg1ZynoccYz3qUAkQqDNxCEcgeZohCQIQe8j7/qwnkj26qJf8UyBW1
         H6rYuI9wA4enLe4WyRinqLu03m7JtKrSoNvfXSG+QS462Lqp7H0ATsK+GbkfH5w5Jk
         BDoqVmmALugJseBqfxGowJGXsAxHXMhqkW1owDQfnsmgRsh8NtaQ39XwM2/0wuR8m9
         rUjl+8jeSdosIqhd4jt5N0/hze6z9aUCQSZDGTmm0nBLjS3fFb3ef3vJZ7IfhKl/iT
         Le7Xab6Hs5Y1A==
Date:   Thu, 8 Dec 2022 10:51:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v2] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <Y5GlfDf9iQgFl8yc@unreal>
References: <20221207012540.2717379-1-yangyingliang@huawei.com>
 <Y5GYqsgKxhUpfTn/@unreal>
 <f31d0ce3-50fc-6206-bc7a-2a67ec0951db@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f31d0ce3-50fc-6206-bc7a-2a67ec0951db@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 04:40:35PM +0800, Yang Yingliang wrote:
> 
> On 2022/12/8 15:56, Leon Romanovsky wrote:
> > On Wed, Dec 07, 2022 at 09:25:40AM +0800, Yang Yingliang wrote:
> > > It is not allowed to call consume_skb() from hardware interrupt context
> > > or with interrupts being disabled. So replace dev_kfree_skb() with
> > > dev_consume_skb_irq() under spin_lock_irqsave().
> > > 
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > ---
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
> > And why did you use dev_consume_skb_irq() and not dev_kfree_skb_irq()?
> I chose dev_consume_skb_irq(), because dev_kfree_skb() is consume_skb().

Your commit message, title and actual change are totally misleading.
You replaced *_kfree_* with *_consume_* while talking about running it
in interrupts disabled context.

Thanks

> 
> Thanks,
> Yang
> > 
> > Thanks
> > 
> > >   				cnt++;
> > >   			}
> > >   		}
> > > -- 
> > > 2.25.1
> > > 
> > .
