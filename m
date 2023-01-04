Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 792F265D157
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 12:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbjADLYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 06:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjADLYj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 06:24:39 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484A81A839;
        Wed,  4 Jan 2023 03:24:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672831478; x=1704367478;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=e3dnwHcZnNjJi9JOEYjRBlsq3Z+daJrut682oSaz7Oo=;
  b=JAJQ/5vbLhKx6q7wP937T4miOT9SLEUJ5gVPxoDmqsOFRqUY3oQHSNBU
   7AWbbGY6KzQw2ZPKnQXcn/YgCQQBv2E4abysPysFxht94nqR/lk4zXesw
   wuO/M1X0UCAWJg6afiAXxQ5RKZ5hAQ/7EPNlMU60cagTCEkdAdLmcbbJS
   iZIo5bNbUWgIrVu303CJJI6NB+EavgmXX9HLw530YYQrxjkNy0msvZsto
   2vQYAS3O/u+nkDVidpYVh+Tv5/+8ihk3ZrBx47Bx/RKNo43T/tkjYCTGS
   hPRQWkGBE+FylpgfBwoHMhjPHfAU7aaL4hUNQKEe25ua309bG7rsnI7b+
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="305419650"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="305419650"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 03:24:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="900526406"
X-IronPort-AV: E=Sophos;i="5.96,299,1665471600"; 
   d="scan'208";a="900526406"
Received: from unknown (HELO localhost.localdomain) ([10.237.112.144])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2023 03:24:35 -0800
Date:   Wed, 4 Jan 2023 12:24:31 +0100
From:   Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] fjes: Fix an error handling path in fjes_probe()
Message-ID: <Y7Vh73c74R9xhjWZ@localhost.localdomain>
References: <fde673f106d2b264ad76759195901aae94691b5c.1671569785.git.christophe.jaillet@wanadoo.fr>
 <Y6LZEVU7tKPzjHQ8@localhost.localdomain>
 <437145bf-d925-e91e-affd-835d272c55a0@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <437145bf-d925-e91e-affd-835d272c55a0@wanadoo.fr>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 29, 2022 at 05:34:22PM +0100, Christophe JAILLET wrote:
> Le 21/12/2022 à 10:59, Michal Swiatkowski a écrit :
> > On Tue, Dec 20, 2022 at 09:57:06PM +0100, Christophe JAILLET wrote:
> > > A netif_napi_add() call is hidden in fjes_sw_init(). It should be undone
> > > by a corresponding netif_napi_del() call in the error handling path of the
> > > probe, as already done inthe remove function.
> > > 
> > > Fixes: 265859309a76 ("fjes: NAPI polling function")
> > > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > > ---
> > >   drivers/net/fjes/fjes_main.c | 4 +++-
> > >   1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
> > > index 2513be6d4e11..01b4c9c6adbd 100644
> > > --- a/drivers/net/fjes/fjes_main.c
> > > +++ b/drivers/net/fjes/fjes_main.c
> > > @@ -1370,7 +1370,7 @@ static int fjes_probe(struct platform_device *plat_dev)
> > >   	adapter->txrx_wq = alloc_workqueue(DRV_NAME "/txrx", WQ_MEM_RECLAIM, 0);
> > >   	if (unlikely(!adapter->txrx_wq)) {
> > >   		err = -ENOMEM;
> > > -		goto err_free_netdev;
> > > +		goto err_del_napi;
> > >   	}
> > >   	adapter->control_wq = alloc_workqueue(DRV_NAME "/control",
> > > @@ -1431,6 +1431,8 @@ static int fjes_probe(struct platform_device *plat_dev)
> > >   	destroy_workqueue(adapter->control_wq);
> > >   err_free_txrx_wq:
> > >   	destroy_workqueue(adapter->txrx_wq);
> > > +err_del_napi:
> > > +	netif_napi_del(&adapter->napi);
> > >   err_free_netdev:
> > >   	free_netdev(netdev);
> > >   err_out:
> > 
> > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > 
> > I wonder if it won't be better to have fjes_sw_deinit() instead or
> > change fjes_sw_init to only netif_napi_add(). You know, to avoid another
> > bug here when someone add sth to the fjes_sw_deinit(). This is only
> > suggestion, patch looks fine.
> 
> hi,
> 
> based on Jakub's comment [1], free_netdev() already cleans up NAPIs (see
> [2]).
> 
> So would it make more sense to remove netif_napi_del() from the .remove()
> function instead?
> The call looks useless to me now.
> 
> CJ
> 
> [1]: https://lore.kernel.org/all/20221221174043.1191996a@kernel.org/
> [2]: https://elixir.bootlin.com/linux/v6.2-rc1/source/net/core/dev.c#L10710
> 

Yeah, it make more sense.

Thanks, Michal
> > 
> > > -- 
> > > 2.34.1
> > > 
> > 
> 
