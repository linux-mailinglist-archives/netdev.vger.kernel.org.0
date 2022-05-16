Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E64527D0B
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 07:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236916AbiEPF3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 01:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbiEPF3R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 01:29:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52077DF27
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 22:29:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EDDF2B80AB6
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 05:29:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9CC0C385AA;
        Mon, 16 May 2022 05:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652678953;
        bh=m1aOLhW3YzGYIjCbjj4hJXp67xsT5EV54cKxTxk3XBY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pLubknG3FoeloQCpJNff5rztfi7XpruoFZLdVFsCGgN8kazRTdZQWDKL2W7PibZaV
         A+PIdoSFyYoFiHMGp3ORwiwsIePAeHd2F3hjPGD0tLjwWNqLopacHOKFDXx61GmEJ4
         yOZuDgdBJ3xwAc181/PHu6AzYNb6pLrbx7NEYoPCoJEtyclJo9bkGobUTUS4BiqbRP
         8KgztUF4R9XXTkJ5kaA5004ppzqnUvHcafuAnK6+v7r/5LlYC6uLVbNwSUVksbw1Vc
         oy4JL/y2iZgIR4Q+hfGNcFLIH/1u1OdWP+fUs7mZzzMZZe4RgFvwOhSPk6gtPc98Zq
         xgH8SCQVyU/lg==
Date:   Mon, 16 May 2022 08:29:03 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH ipsec-next 5/6] xfrm: add RX datapath protection for
 IPsec full offload mode
Message-ID: <YoHhH++2sBvyy+8d@unreal>
References: <cover.1652176932.git.leonro@nvidia.com>
 <ff459f4de434def4a1d7ab989a17577f19a67f45.1652176932.git.leonro@nvidia.com>
 <20220513150254.GM680067@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513150254.GM680067@gauss3.secunet.de>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 05:02:54PM +0200, Steffen Klassert wrote:
> On Tue, May 10, 2022 at 01:36:56PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Traffic received by device with enabled IPsec full offload should be
> > forwarded to the stack only after decryption, packet headers and
> > trailers removed.
> > 
> > Such packets are expected to be seen as normal (non-XFRM) ones, while
> > not-supported packets should be dropped by the HW.
> > 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  include/net/xfrm.h | 55 +++++++++++++++++++++++++++-------------------
> >  1 file changed, 32 insertions(+), 23 deletions(-)
> > 
> > diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> > index 21be19ece4f7..9f9250fe1c4d 100644
> > --- a/include/net/xfrm.h
> > +++ b/include/net/xfrm.h
> > @@ -1094,6 +1094,29 @@ xfrm_state_addr_cmp(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x, un
> >  	return !0;
> >  }
> >  
> > +#ifdef CONFIG_XFRM
> > +static inline struct xfrm_state *xfrm_input_state(struct sk_buff *skb)
> > +{
> > +	struct sec_path *sp = skb_sec_path(skb);
> > +
> > +	return sp->xvec[sp->len - 1];
> > +}
> > +#endif
> > +
> > +static inline struct xfrm_offload *xfrm_offload(struct sk_buff *skb)
> > +{
> > +#ifdef CONFIG_XFRM
> > +	struct sec_path *sp = skb_sec_path(skb);
> > +
> > +	if (!sp || !sp->olen || sp->len != sp->olen)
> > +		return NULL;
> > +
> > +	return &sp->ovec[sp->olen - 1];
> > +#else
> > +	return NULL;
> > +#endif
> > +}
> > +
> >  #ifdef CONFIG_XFRM
> >  int __xfrm_policy_check(struct sock *, int dir, struct sk_buff *skb,
> >  			unsigned short family);
> > @@ -1113,6 +1136,15 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
> >  {
> >  	struct net *net = dev_net(skb->dev);
> >  	int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
> > +	struct xfrm_offload *xo = xfrm_offload(skb);
> > +	struct xfrm_state *x;
> > +
> > +	if (xo) {
> > +		x = xfrm_input_state(skb);
> > +		if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> > +			return (xo->flags & CRYPTO_DONE) &&
> > +			       (xo->status & CRYPTO_SUCCESS);
> > +	}
> 
> We can not exit without doing the policy check here. The inner
> packet could still match a block policy in software. Maybe
> we can reset the secpath and do the policy check.

We checked that both policy and state were offloaded. In such case,
driver returned that everything ok and the packet is handled.

SW policy will be in lower priority, so we won't catch it.

Thanks

