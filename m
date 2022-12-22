Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC7F4653A56
	for <lists+netdev@lfdr.de>; Thu, 22 Dec 2022 02:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbiLVBiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 20:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiLVBiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 20:38:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46525165B6;
        Wed, 21 Dec 2022 17:38:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6564B81CCA;
        Thu, 22 Dec 2022 01:38:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39626C433EF;
        Thu, 22 Dec 2022 01:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671673126;
        bh=QBWS72HcGu41EkBnnBrQNriIY7lz8m5hemIXlVMkIl4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hPAkXrpIQm85VDAdAH1ShLX0Ki7Yi1smUNpggq6l4GfgfuEqt6ngkhpjYUj5qxV5g
         VdPAcx1CEEso1uxMwyq0rzY6BzaMCMVA4Ezo3if/GK6TRjbmZ6F4euN2I6tFyoBbmk
         /is2vhBhajG9op59NYLmme3yhdGdeLJxQDw0Elnt4M+6x96g62C2uinKa0A+0iUote
         j5zO8ra8SjIdjta/ZhWl4olHYpghDBuwZDFAbHKDXi9lJj5lFiI+fKobjAK32eUUqC
         KGtz7tUTgtPXeuUxSSSOXb9tInVPXmtF7w+auEli8/Wll0jrhGw21Q0sSgJbRS9owr
         +lACl/QhHF/nA==
Date:   Wed, 21 Dec 2022 17:38:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Krzysztof Halasa <khalasa@piap.pl>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof =?UTF-8?B?SGHFgmFzYQ==?= <khc@pm.waw.pl>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ixp4xx_eth: Fix an error handling path in
 ixp4xx_eth_probe()
Message-ID: <20221221173845.38e15410@kernel.org>
In-Reply-To: <Y6NVb8igxFCwwdw5@localhost.localdomain>
References: <3ab37c3934c99066a124f99e73c0fc077fcb69b4.1671607040.git.christophe.jaillet@wanadoo.fr>
        <Y6NVb8igxFCwwdw5@localhost.localdomain>
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

On Wed, 21 Dec 2022 19:50:23 +0100 Michal Swiatkowski wrote:
> On Wed, Dec 21, 2022 at 08:17:52AM +0100, Christophe JAILLET wrote:
> > If an error occurs after a successful ixp4xx_mdio_register() call, it
> > should be undone by a corresponding ixp4xx_mdio_remove().  
> 
> What about error when mdio_bus is 0? It means that mdio_register can
> return no error, but sth happen and there is no need to call mdio_remove
> in this case?
> 
> I mean:
>  /* If the instance with the MDIO bus has not yet appeared,
>   * defer probing until it gets probed.
>   */
>   if (!mdio_bus)
> 	return -EPROBE_DEFER;

Indeed, I think a closer look is warranted, this code operates on
global variables, it's also not clear to me whether it's safe to always
call remove, even if has_mdio is false?

> > Add the missing call in the error handling path, as already done in the
> > remove function.
> > 
> > Fixes: 2098c18d6cf6 ("IXP4xx: Add PHYLIB support to Ethernet driver.")
> > Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> > ---
> >  drivers/net/ethernet/xscale/ixp4xx_eth.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> > index 3b0c5f177447..007d68b385a5 100644
> > --- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
> > +++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
> > @@ -1490,8 +1490,10 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
> >  
> >  	netif_napi_add_weight(ndev, &port->napi, eth_poll, NAPI_WEIGHT);  
> netif_napi_add_weight() doesn't need to be unrolled in case of error
> (call netif_napi_del() or something)?

free_netdev() cleans it up automatically
