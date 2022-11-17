Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8386B62DBFD
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234666AbiKQMwC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:52:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbiKQMvj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:51:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26B456EE0
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:51:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50FD861BDD
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 12:51:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31153C433D6;
        Thu, 17 Nov 2022 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668689497;
        bh=Klcrc4zejdPo4o4dfZ7M7w33yCEQ/VsznceciXZG960=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oL1JC1cSRip2w9NuuiLefD1CMuyVUDlz5j9L26TlZHp3R8Wl1sHIkcLNxjwGKLOY0
         w82B2/q7dpSSrvrjy2vy5ofHA2wE9jNRKbKup4s1mSwEFAg7hckDFkeYUT2e5rQ8+N
         u/oK4Oq2NI5NGFqksMUtLg0oLH2KhSVRc7XPmAc6hRu19Si3WWLi9URaLFYAw2Rn9N
         FRrnmbyCN2OmuD1RGaNPVuOSnXp4yDEAxBZOWm+ZdFOEdA2g4iufk7lUTLoVGAtUvQ
         LBKIGUxIsnvonqKb2JXq7LwQYz8AFiVJ0/e9U39gvxP7L3/5Asy7pCaW8acMRRXAAr
         tKe4ojLiaw+zg==
Date:   Thu, 17 Nov 2022 14:51:33 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH xfrm-next v7 6/8] xfrm: speed-up lookup of HW policies
Message-ID: <Y3YuVcj5uNRHS7Ek@unreal>
References: <cover.1667997522.git.leonro@nvidia.com>
 <f611857594c5c53918d782f104d6f4e028ba465d.1667997522.git.leonro@nvidia.com>
 <20221117121243.GJ704954@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117121243.GJ704954@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 01:12:43PM +0100, Steffen Klassert wrote:
> On Wed, Nov 09, 2022 at 02:54:34PM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > @@ -1166,16 +1187,24 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
> >  			spin_lock_bh(&net->xfrm.xfrm_state_lock);
> >  			x->km.state = XFRM_STATE_ACQ;
> >  			list_add(&x->km.all, &net->xfrm.state_all);
> > -			hlist_add_head_rcu(&x->bydst, net->xfrm.state_bydst + h);
> > +			XFRM_STATE_INSERT(bydst, &x->bydst,
> > +					  net->xfrm.state_bydst + h,
> > +					  x->xso.type);
> >  			h = xfrm_src_hash(net, daddr, saddr, encap_family);
> > -			hlist_add_head_rcu(&x->bysrc, net->xfrm.state_bysrc + h);
> > +			XFRM_STATE_INSERT(bysrc, &x->bysrc,
> > +					  net->xfrm.state_bysrc + h,
> > +					  x->xso.type);
> >  			if (x->id.spi) {
> >  				h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, encap_family);
> > -				hlist_add_head_rcu(&x->byspi, net->xfrm.state_byspi + h);
> > +				XFRM_STATE_INSERT(byspi, &x->byspi,
> > +						  net->xfrm.state_byspi + h,
> > +						  x->xso.type);
> >  			}
> >  			if (x->km.seq) {
> >  				h = xfrm_seq_hash(net, x->km.seq);
> > -				hlist_add_head_rcu(&x->byseq, net->xfrm.state_byseq + h);
> > +				XFRM_STATE_INSERT(byseq, &x->byseq,
> > +						  net->xfrm.state_byseq + h,
> > +						  x->xso.type);
> >  			}
> 
> This does not work. A larval state will never have a x->xso.type set.

x->xso.type always exists. Default is 0, which is XFRM_DEV_OFFLOAD_UNSPECIFIED.
It means this XFRM_STATE_INSERT() will behave exactly as hlist_add_head_rcu() before.

> So this raises the question how to handle acquires with this packet
> offload. 

We handle acquires as SW policies and don't offload them.


> You could place the type and offload device to the template,
> but we also have to make sure not to mess too much with the non
> offloaded codepath.
> 
> This is yet another corner case where the concept of doing policy and
> state lookup in software for a HW offload does not work so well. I
> fear this is not the last corner case that comes up once you put this
> into a real network.
> 

It is not different from any other kernel code, bugs will be fixed.

BTW, IPsec packet offload mode is in use for almost two years already
in real networks.
https://docs.nvidia.com/networking/display/OFEDv521040/Changes+and+New+Features

Thanks
