Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E249559BBFE
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbiHVIuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231331AbiHVIuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108B395AA
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A070860DFC
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 08:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DE4C433D6;
        Mon, 22 Aug 2022 08:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661158212;
        bh=Q33Tlz/79OuCFGnbRsGytybOqGopOsSfwfpIG97mJlE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PpDvdnee39iDo2AGfMX/Cy8wt4UOFoJoNSSug4tYz3eQAek3EeZv4Y3OpEOPZlQ7P
         NHoI8/9s0PM76cYZrHQVzo408/DdcSw9edma/HaNWmrn2xZgJUu6eZLDUmVKUstQeO
         P2MHe93aUEDSIJh9uqLLLxnxgnymjzpgNMO02MOXYN5fGeAXZaEg/R6Oss0JxQnHQe
         OafQHxpQ+I78LjL5qXcXr1d/kU82wBWe5b1S09mRqKe+L8GlK39oYENPfcXweOv+VF
         Wooj+FPv4sIsUyEzUUB1hb84buO00C00kxJJKaXXa+k7khWXVi7HLCklH/Nkps3W/v
         FGHt0MX8faatA==
Date:   Mon, 22 Aug 2022 11:50:07 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 4/6] xfrm: add TX datapath support for IPsec
 full offload mode
Message-ID: <YwNDP6pQ16y/e2fp@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <aa0b418e5bccb0b32625f8615124c8d0e58d9980.1660639789.git.leonro@nvidia.com>
 <20220818102451.GE566407@gauss3.secunet.de>
 <Yv4//oQssmUDaRwn@unreal>
 <20220822080454.GF2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822080454.GF2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 10:04:54AM +0200, Steffen Klassert wrote:
> On Thu, Aug 18, 2022 at 04:34:54PM +0300, Leon Romanovsky wrote:
> > On Thu, Aug 18, 2022 at 12:24:51PM +0200, Steffen Klassert wrote:
> > > On Tue, Aug 16, 2022 at 11:59:25AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > In IPsec full mode, the device is going to encrypt and encapsulate
> > > > packets that are associated with offloaded policy. After successful
> > > > policy lookup to indicate if packets should be offloaded or not,
> > > > the stack forwards packets to the device to do the magic.
> > > > 
> > > > Signed-off-by: Raed Salem <raeds@nvidia.com>
> > > > Signed-off-by: Huy Nguyen <huyn@nvidia.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > > ---
> > > >  net/xfrm/xfrm_device.c | 13 +++++++++++++
> > > >  net/xfrm/xfrm_output.c | 20 ++++++++++++++++++++
> > > >  2 files changed, 33 insertions(+)
> > > > 
> > > > diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> > > > index 1cc482e9c87d..db5ebd36f68c 100644
> > > > --- a/net/xfrm/xfrm_device.c
> > > > +++ b/net/xfrm/xfrm_device.c
> > > 
> > > > @@ -366,6 +376,9 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x)
> > > >  	struct xfrm_dst *xdst = (struct xfrm_dst *)dst;
> > > >  	struct net_device *dev = x->xso.dev;
> > > >  
> > > > +	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> > > > +		goto ok;
> > > 
> > > You skip the PMTU checks here. I've seen that you check
> > > the packet length against the device MTU in one of your
> > > mlx5 patches, but that does not help if the PMTU is below.
> > 
> > If device supports transformation of the packet, this packet
> > won't be counted as XFRM anymore. I'm not sure that we need
> > to perform XFRM specific checks.
> 
> This is not xfrm specific, it makes sure that the packet you
> want to send fits into the PMTU.

I will add.

Thanks
