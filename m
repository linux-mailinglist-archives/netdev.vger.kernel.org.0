Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED087682DDD
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 14:28:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbjAaN17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 08:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231911AbjAaN16 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 08:27:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB5C883EE
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 05:27:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78BF861514
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 13:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB37C433D2;
        Tue, 31 Jan 2023 13:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675171675;
        bh=2+Xxzrzfn8imaPoXS+6oux1nN+VvoW1s2v8bL3wc8wg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y8naEP12QRK+AtiAzC526AAPYuFCl+fU6xxf8GnHx5X3LRDcCbrWk+uB5biesj5nG
         JqKduyqwedlienL6WIEUojQrIp/0VvYZbWapkpqzvIv05du3voEeCJsYk7lPvwLz10
         KaIvz8SS4XKQdYf3Nz7SxOMosFZEymK81XCn4oRjCPMXjyGw6uAufsIgp+dku8fwb7
         odgCiLVuMtCLedvfXHAP+W0c9ys8W3eCvh18QmpnCa9+HyCqUROqjmcSZY6tJ7QGYz
         7XzUCZkZfaseAJ5VUVbFlSVmJ0R6IcMnPnnZPHxetirAa/I7TDEozbZfcm32xCnYU/
         KjK0N9+M1faCA==
Date:   Tue, 31 Jan 2023 15:27:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yanguo Li <yanguo.li@corigine.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net] nfp: flower: avoid taking mutex in atomic context
Message-ID: <Y9kXV1LvDfXjzA9R@unreal>
References: <20230131080313.2076060-1-simon.horman@corigine.com>
 <Y9j/Rvi9CSYX2qSk@unreal>
 <Y9kGcnKUUO5HURZX@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9kGcnKUUO5HURZX@corigine.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:15:46PM +0100, Simon Horman wrote:
> On Tue, Jan 31, 2023 at 01:45:10PM +0200, Leon Romanovsky wrote:
> > On Tue, Jan 31, 2023 at 09:03:13AM +0100, Simon Horman wrote:
> > > From: Yanguo Li <yanguo.li@corigine.com>
> > > 
> > > A mutex may sleep, which is not permitted in atomic context.
> > > Avoid a case where this may arise by moving the to
> > > nfp_flower_lag_get_info_from_netdev() in nfp_tun_write_neigh() spinlock.
> > > 
> > > Fixes: abc210952af7 ("nfp: flower: tunnel neigh support bond offload")
> > > Reported-by: Dan Carpenter <error27@gmail.com>
> > > Signed-off-by: Yanguo Li <yanguo.li@corigine.com>
> > > Signed-off-by: Simon Horman <simon.horman@corigine.com>
> > > ---
> > >  drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > > index a8678d5612ee..060a77f2265d 100644
> > > --- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > > +++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
> > > @@ -460,6 +460,7 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
> > >  			    sizeof(struct nfp_tun_neigh_v4);
> > >  	unsigned long cookie = (unsigned long)neigh;
> > >  	struct nfp_flower_priv *priv = app->priv;
> > > +	struct nfp_tun_neigh_lag lag_info;
> > >  	struct nfp_neigh_entry *nn_entry;
> > >  	u32 port_id;
> > >  	u8 mtype;
> > > @@ -468,6 +469,11 @@ nfp_tun_write_neigh(struct net_device *netdev, struct nfp_app *app,
> > >  	if (!port_id)
> > >  		return;
> > >  
> > > +	if ((port_id & NFP_FL_LAG_OUT) == NFP_FL_LAG_OUT) {
> > > +		memset(&lag_info, 0, sizeof(struct nfp_tun_neigh_lag));
> > 
> > This memset can be removed if you initialize lag_info to zero.
> > struct nfp_tun_neigh_lag lag_info = {};
> 
> Happy to change if that is preferred.
> Is it preferred?

I don't see why it can't be preferred.

Thanks
