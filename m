Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC130527D21
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 07:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236196AbiEPFpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 01:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239877AbiEPFpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 01:45:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 020D6E0E7
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 22:45:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7178660F13
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 05:45:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03B45C385B8;
        Mon, 16 May 2022 05:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652679912;
        bh=WExA2xvzjGg/gmYBGvhmJzb/aELmIcIhMb1Kq+R5T8I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qjktuBwEBpqeCE75Fak+/dWkXpNl79dOSixG6pOmpXONOTNrwPSeGIz/kM9kVI9m3
         uswgZ6IqYYM229KUcaDyNQ+z4Wsrbrtksh5+Qoncig3AUyFHcXYHA42lpH5PuGRkwk
         X7pOZzV8BgN95ymxA1WTq7cG7/CldVS0HYeTbWdjbh2Pfg5DTA8hAgq4MYR55ZHH/Y
         AsteJEFHMdZIentng0M+bKainyyoIA6WRPHWtY8YQiseXaZxfZVdffM1IAO17JZvex
         7eYJryTgBDdKiNUC5deAFXpANl7vdBafzw2eAZTVFMppw+Zy+Ji757yoRXsEvHBT4o
         gNgPSkdHr97Sg==
Date:   Mon, 16 May 2022 08:44:58 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 4/6] xfrm: add TX datapath support for IPsec
 full offload mode
Message-ID: <YoHk2jiostIWIHn5@unreal>
References: <cover.1652176932.git.leonro@nvidia.com>
 <905b8e8032d5cdb48ef63cb153fd86552c8a6a7d.1652176932.git.leonro@nvidia.com>
 <20220513145658.GL680067@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513145658.GL680067@gauss3.secunet.de>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 04:56:58PM +0200, Steffen Klassert wrote:
> On Tue, May 10, 2022 at 01:36:55PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > In IPsec full mode, the device is going to encrypt and encapsulate
> > packets that are associated with offloaded policy. After successful
> > policy lookup to indicate if packets should be offloaded or not,
> > the stack forwards packets to the device to do the magic.
> > 
> > Signed-off-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  net/xfrm/xfrm_output.c | 19 +++++++++++++++++++
> >  1 file changed, 19 insertions(+)
> > 
> > diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
> > index d4935b3b9983..2599f3dbac08 100644
> > --- a/net/xfrm/xfrm_output.c
> > +++ b/net/xfrm/xfrm_output.c
> > @@ -718,6 +718,25 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
> >  		break;
> >  	}
> >  
> > +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
> > +		struct dst_entry *dst = skb_dst_pop(skb);
> > +
> > +		if (!dst) {
> > +			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
> > +			return -EHOSTUNREACH;
> > +		}
> > +
> > +		skb_dst_set(skb, dst);
> > +		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
> > +		if (unlikely(err != 1))
> > +			return err;
> > +
> > +		if (!skb_dst(skb)->xfrm)
> > +			return dst_output(net, skb->sk, skb);
> > +
> > +		return 0;
> > +	}
> > +
> 
> How do we know that we send the packet really to a device that
> supports this type of offload? For crypto offload, we check that
> in xfrm_dev_offload_ok() and I think something similar is required
> here too.

I think that function is needed to make sure that we will have SW
fallback. It is not needed in full offload, anything that is not
supported/wrong should be dropped by HW.

> 
> Also, the offload type still requires software policies and states.
> What if a device comes up that can do a real full offload, i.e.
> in a way that the kernel acts just as a stub layer between IKE
> and the device. Are we going to create XFRM_DEV_OFFLOAD_FULL_2
> then? We need to make sure that this case cann be supported with
> the new API too.

Yes, I think that it is supported by this API.

From user perspective, all flavours of full offload are the same, the
difference is in-kernel API, where we will be able differentiate with
some sort of features flag.

Thanks
