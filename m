Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C57359BCEC
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 11:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbiHVJfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 05:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233126AbiHVJfm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 05:35:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2238A2B25B
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 02:35:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D07A5B80E88
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 09:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8C1C433D6;
        Mon, 22 Aug 2022 09:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661160938;
        bh=SKTpxRpOz/KWjtnC45CoUEzEvcMEw3gs4kCXAQxFgXY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZdBzOFAqPTG7HtLWTW8m+QGoBszDQsKuv0SnVRALthZLw8Qy7OPyI2XSIDE1x6tRU
         cNazQZHmu3oenPyHWfGFdryL7XYhSIOqeX9jq6ywlEzr8m7UDb13/+ZW/WfxhPD5Ja
         0OvcrMcQS5HuLmSKsXYOvimwMavXaLSPQCHmrXMKsxWalLIkUSFqnXH0om6gGhy/+w
         co6iG9UlbhJOI0iXJ8L6tGpTz53E/UJrGo6Qk3slTEVjdXh5V5wUdHDn7KnmjHaO4B
         1eoP7KIaQBj6+cQ5veircPOd17wIUERs/hJb3FGBZI/JlM41nBH/Bv8/e7XIlTLV8J
         O3MPfgFtN2+Vg==
Date:   Mon, 22 Aug 2022 12:35:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 5/6] xfrm: add RX datapath protection for
 IPsec full offload mode
Message-ID: <YwNN5hPMD474r03i@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <8264ad13665f510b081764131b1f23ade32c7578.1660639789.git.leonro@nvidia.com>
 <20220818102708.GF566407@gauss3.secunet.de>
 <Yv5AbrT+xHc/xtNY@unreal>
 <20220822080642.GG2602992@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822080642.GG2602992@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 22, 2022 at 10:06:42AM +0200, Steffen Klassert wrote:
> On Thu, Aug 18, 2022 at 04:36:46PM +0300, Leon Romanovsky wrote:
> > On Thu, Aug 18, 2022 at 12:27:08PM +0200, Steffen Klassert wrote:
> > > On Tue, Aug 16, 2022 at 11:59:26AM +0300, Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > 
> > > > Traffic received by device with enabled IPsec full offload should be
> > > > forwarded to the stack only after decryption, packet headers and
> > > > trailers removed.
> > > > 
> > > > Such packets are expected to be seen as normal (non-XFRM) ones, while
> > > > not-supported packets should be dropped by the HW.
> > > > 
> > > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > > @@ -1125,6 +1148,15 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
> > > >  {
> > > >  	struct net *net = dev_net(skb->dev);
> > > >  	int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
> > > > +	struct xfrm_offload *xo = xfrm_offload(skb);
> > > > +	struct xfrm_state *x;
> > > > +
> > > > +	if (xo) {
> > > > +		x = xfrm_input_state(skb);
> > > > +		if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> > > > +			return (xo->flags & CRYPTO_DONE) &&
> > > > +			       (xo->status & CRYPTO_SUCCESS);
> > > > +	}
> > > >  
> > > >  	if (sk && sk->sk_policy[XFRM_POLICY_IN])
> > > >  		return __xfrm_policy_check(sk, ndir, skb, family);
> > > 
> > > What happens here if there is a socket policy configured?
> > 
> > No change, we don't support offload of socket policies.
> 
> But the user can confugure it, so it should be enforced
> regardless if we had an offload before.

Thanks, I'll see how it can be resolved.
