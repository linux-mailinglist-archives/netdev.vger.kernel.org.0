Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70C0762DC3F
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbiKQNFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231634AbiKQNFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:05:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5D2668680;
        Thu, 17 Nov 2022 05:05:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 453FD61DC8;
        Thu, 17 Nov 2022 13:05:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF665C433C1;
        Thu, 17 Nov 2022 13:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668690332;
        bh=ZBEVfZF0QfQVnHQWHX5dlMjl2pKu1VG+I2bBas101IA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dpDWeSb5XkVrG8JHsAMvnoA9fhp2c6yoZ3FwJtqXYxbiCSKfWgmKGanNImUWBDVw/
         IBllnoICpbAQl2ErpTx0t1Mole0ubfTgTcmq+4XU5gjhLpt1hZO7oOHm3BSPhJKKTx
         +H6J1bfg5WJK54MCbGNpRdAS2HdA0Qi/D1ajMVx1+iTajXK7pQKvkxsULCoaaaWNSU
         wps/PM2FZBtzhJ7O8ZfoMmLT6mYe728drxe+3iZdr/7U3+NWVlEyZ3dGgBUQFolQ+T
         ewkVSRvZdWCyXojC3QwAuIJo/sw4ElrXonvM2V2W6f1GvijlfKWp4VyA7jmFLE10en
         j+E0340KFrZpA==
Date:   Thu, 17 Nov 2022 15:05:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] sfc: fix potential memleak in
 __ef100_hard_start_xmit()
Message-ID: <Y3YxlxPIiw43QiKE@unreal>
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
 <Y3YctdnKDDvikQcl@unreal>
 <efedaa0e-33ce-24c6-bb9d-8f9b5c4a1c38@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <efedaa0e-33ce-24c6-bb9d-8f9b5c4a1c38@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 08:41:52PM +0800, Zhang Changzhong wrote:
> 
> 
> On 2022/11/17 19:36, Leon Romanovsky wrote:
> > On Thu, Nov 17, 2022 at 03:50:09PM +0800, Zhang Changzhong wrote:
> >> The __ef100_hard_start_xmit() returns NETDEV_TX_OK without freeing skb
> >> in error handling case, add dev_kfree_skb_any() to fix it.
> >>
> >> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
> >> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> >> ---
> >>  drivers/net/ethernet/sfc/ef100_netdev.c | 1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> >> index 88fa295..ddcc325 100644
> >> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> >> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> >> @@ -218,6 +218,7 @@ netdev_tx_t __ef100_hard_start_xmit(struct sk_buff *skb,
> >>  		   skb->len, skb->data_len, channel->channel);
> >>  	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
> >>  		netif_stop_queue(net_dev);
> >> +		dev_kfree_skb_any(skb);
> >>  		goto err;
> >>  	}
> > 
> > ef100 doesn't release in __ef100_enqueue_skb() either. SKB shouldn't be
> > NULL or ERR at this stage.
> 
> SKB shouldn't be NULL or ERR, so it can be freed. But this code looks weird.

Please take a look __ef100_enqueue_skb() and see if it frees SKB on
error or not. If not, please fix it.

Thanks

> 
> > 
> > diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
> > index 29ffaf35559d..426706b91d02 100644
> > --- a/drivers/net/ethernet/sfc/ef100_tx.c
> > +++ b/drivers/net/ethernet/sfc/ef100_tx.c
> > @@ -497,7 +497,7 @@ int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
> > 
> >  err:
> >         efx_enqueue_unwind(tx_queue, old_insert_count);
> > -       if (!IS_ERR_OR_NULL(skb))
> > +       if (rc)
> >                 dev_kfree_skb_any(skb);
> > 
> >         /* If we're not expecting another transmit and we had something to push
> > 
> > 
> >>  
> >> -- 
> >> 2.9.5
> >>
> > .
> > 
