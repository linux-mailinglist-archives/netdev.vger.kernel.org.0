Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E654646BDB
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 10:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiLHJ1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 04:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiLHJ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 04:27:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C035E3EC
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 01:27:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64A8F61E32
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 09:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4117AC433D6;
        Thu,  8 Dec 2022 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670491625;
        bh=ESeskUdYBC9fgV8cGjaYD1AtAXlbrpoK3+yftPEuFms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rnql24uJ7/39FhGtS47/s1ncKDVaSDGH4J3m679HTnkoGprk4AUXcNwGaZafh0VlF
         zbXvZxP1kCnkRjWkjFUXkk0oD3JHTVC8csZnZ6CUmg2d/0MToUogU3SCYBVeVE1qUF
         qYkZGQdkAgFTokJLJgt7ODVJ0IX/+aWFD6ySnmpVRcd/l/2SVQsFL83p3JCAVNF+lz
         Ih7thp6ET6SmNMl/27K6SA0xbq2yaju0zQFo6wz0I32wasJsiFwpEBMrQqM1P4LIKN
         dTVM6YFpTqI0IgMkEQEZ3wxh1MJvVLXss7GPOjW6oiofoPKJr7hEc5eUOMckJ90bBs
         a0nhoPLIWVoiw==
Date:   Thu, 8 Dec 2022 11:27:01 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, jdmason@kudzu.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH net v2] ethernet: s2io: don't call dev_kfree_skb() under
 spin_lock_irqsave()
Message-ID: <Y5Gt5ZkfYPd+DHKI@unreal>
References: <20221207012540.2717379-1-yangyingliang@huawei.com>
 <Y5GYqsgKxhUpfTn/@unreal>
 <f31d0ce3-50fc-6206-bc7a-2a67ec0951db@huawei.com>
 <Y5GlfDf9iQgFl8yc@unreal>
 <2e425086-b96e-65ac-f004-99f55af2e8d0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2e425086-b96e-65ac-f004-99f55af2e8d0@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 08, 2022 at 05:03:20PM +0800, Yang Yingliang wrote:
> 
> On 2022/12/8 16:51, Leon Romanovsky wrote:
> > On Thu, Dec 08, 2022 at 04:40:35PM +0800, Yang Yingliang wrote:
> > > On 2022/12/8 15:56, Leon Romanovsky wrote:
> > > > On Wed, Dec 07, 2022 at 09:25:40AM +0800, Yang Yingliang wrote:
> > > > > It is not allowed to call consume_skb() from hardware interrupt context
> > > > > or with interrupts being disabled. So replace dev_kfree_skb() with
> > > > > dev_consume_skb_irq() under spin_lock_irqsave().
> > > > > 
> > > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > > > > ---
> > > > > v1 -> v2:
> > > > >     Add fix tag.
> > > > > ---
> > > > >    drivers/net/ethernet/neterion/s2io.c | 2 +-
> > > > >    1 file changed, 1 insertion(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
> > > > > index 1d3c4474b7cb..a83d61d45936 100644
> > > > > --- a/drivers/net/ethernet/neterion/s2io.c
> > > > > +++ b/drivers/net/ethernet/neterion/s2io.c
> > > > > @@ -2386,7 +2386,7 @@ static void free_tx_buffers(struct s2io_nic *nic)
> > > > >    			skb = s2io_txdl_getskb(&mac_control->fifos[i], txdp, j);
> > > > >    			if (skb) {
> > > > >    				swstats->mem_freed += skb->truesize;
> > > > > -				dev_kfree_skb(skb);
> > > > > +				dev_consume_skb_irq(skb);
> > > > And why did you use dev_consume_skb_irq() and not dev_kfree_skb_irq()?
> > > I chose dev_consume_skb_irq(), because dev_kfree_skb() is consume_skb().
> > Your commit message, title and actual change are totally misleading.
> > You replaced *_kfree_* with *_consume_* while talking about running it
> > in interrupts disabled context.
> I didn't mention dev_kfree_skb() is same as consume_skb(), I can add it to
> my
> commit message and send a new version.

I need you to send patch with commit message which aligns to the actual change.
Right now, it is not.

Thanks

> 
> Thanks,
> Yang
> > 
> > Thanks
> > 
> > > Thanks,
> > > Yang
> > > > Thanks
> > > > 
> > > > >    				cnt++;
> > > > >    			}
> > > > >    		}
> > > > > -- 
> > > > > 2.25.1
> > > > > 
> > > > .
> > .
