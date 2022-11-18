Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF162FB45
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 18:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbiKRRLj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 12:11:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbiKRRLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 12:11:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674B38C791;
        Fri, 18 Nov 2022 09:11:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F418B6265E;
        Fri, 18 Nov 2022 17:11:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B74C433C1;
        Fri, 18 Nov 2022 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668791493;
        bh=KWwzNSV7Rl2am6gtz8aTkwn6BkiBMh1VJdUCRx5KM8o=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=ekpjulwdwM3mjoP/FGVfzRoKGn00Lpr71FAhMqFMUJbmfNIXK6+cdo+Sr5y5dV1Xa
         JLhEKb9VJcy/rgwJgyXrTfOzIz1oo5ctjPaC6HxvCOFqJHQVuuBXczre9bGwFAcipf
         eGiKfxeUyWBvWD6F10SiflHcSxutSckgKFY8sa6u9Q1HhvQptGqFyyvdCnnRvs5mT2
         VZitUA/c1BkXTA5VjDGrrn/DiZZM9qvY80m8B5VSmKdGVuOqhlXt29Z0x5jGsffsue
         AJ987t/tbic3eF8oiewCB/Entv9JHlDhPm3ErFXiBb1a83yAJfPDzfoNqJLB9vw1aZ
         l1S+AECybhcCA==
Date:   Fri, 18 Nov 2022 19:11:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] sfc: fix potential memleak in
 __ef100_hard_start_xmit()
Message-ID: <Y3e8wEZme3OpMZKV@unreal>
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
 <Y3YctdnKDDvikQcl@unreal>
 <efedaa0e-33ce-24c6-bb9d-8f9b5c4a1c38@huawei.com>
 <Y3YxlxPIiw43QiKE@unreal>
 <Y3dNP6iEj2YyEwqJ@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3dNP6iEj2YyEwqJ@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 09:15:43AM +0000, Martin Habets wrote:
> On Thu, Nov 17, 2022 at 03:05:27PM +0200, Leon Romanovsky wrote:
> > On Thu, Nov 17, 2022 at 08:41:52PM +0800, Zhang Changzhong wrote:
> > > 
> > > 
> > > On 2022/11/17 19:36, Leon Romanovsky wrote:
> > > > On Thu, Nov 17, 2022 at 03:50:09PM +0800, Zhang Changzhong wrote:
> > > >> The __ef100_hard_start_xmit() returns NETDEV_TX_OK without freeing skb
> > > >> in error handling case, add dev_kfree_skb_any() to fix it.
> > > >>
> > > >> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
> > > >> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> > > >> ---
> > > >>  drivers/net/ethernet/sfc/ef100_netdev.c | 1 +
> > > >>  1 file changed, 1 insertion(+)
> > > >>
> > > >> diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
> > > >> index 88fa295..ddcc325 100644
> > > >> --- a/drivers/net/ethernet/sfc/ef100_netdev.c
> > > >> +++ b/drivers/net/ethernet/sfc/ef100_netdev.c
> > > >> @@ -218,6 +218,7 @@ netdev_tx_t __ef100_hard_start_xmit(struct sk_buff *skb,
> > > >>  		   skb->len, skb->data_len, channel->channel);
> > > >>  	if (!efx->n_channels || !efx->n_tx_channels || !channel) {
> > > >>  		netif_stop_queue(net_dev);
> > > >> +		dev_kfree_skb_any(skb);
> > > >>  		goto err;
> > > >>  	}
> > > > 
> > > > ef100 doesn't release in __ef100_enqueue_skb() either. SKB shouldn't be
> > > > NULL or ERR at this stage.
> > > 
> > > SKB shouldn't be NULL or ERR, so it can be freed. But this code looks weird.
> > 
> > Please take a look __ef100_enqueue_skb() and see if it frees SKB on
> > error or not. If not, please fix it.
> 
> That function looks ok to me, but I appreciate the extra eyes on it.

__ef100_enqueue_skb() has the following check in error path:

  498 err:
  499         efx_enqueue_unwind(tx_queue, old_insert_count);
  500         if (!IS_ERR_OR_NULL(skb))
  501                 dev_kfree_skb_any(skb);
  502

The issue is that skb is never error or null here and this "if" is
actually always true and can be deleted.

Thanks
