Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36F1598445
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 15:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245094AbiHRNgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 09:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243887AbiHRNgy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 09:36:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B516CB56C6
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 06:36:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F01C161697
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 13:36:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FBFC433C1;
        Thu, 18 Aug 2022 13:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660829810;
        bh=+gSQTW91cV9Vmn3zTDnShLFhu850dD2vkdEQANswHyg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rmPqctx2Y7tzPhnz2WFJMJ1eBENChMNLaFzgCBR4ueFDLk2F2oMau9f4RtKl78MK4
         mz+0P9b37k+NzYUuPjFLEBRnjZL7lijIgJJiAtba4wGzhJ9dSshRgOeymoT32et8gp
         F7B6oxtcTo2XnezRivyzyAp0lYeeSkFCKanFvKXjHgHqBAb4a1R1oeZ1aL+pwa8Y3g
         Qasa2NrCHbRmR3L8BdsQTRMBLczkuV9y5qbAu+lTgDt05bX/12UEyJMvbujZt1WKc+
         hQ2MNaEw6ZwULr579UPy7mkWCHQ2+kr1fc00dGlhSf88dHv3ar11fy6wm6EnDqWBpQ
         hUEc1OiNKB0tw==
Date:   Thu, 18 Aug 2022 16:36:46 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 5/6] xfrm: add RX datapath protection for
 IPsec full offload mode
Message-ID: <Yv5AbrT+xHc/xtNY@unreal>
References: <cover.1660639789.git.leonro@nvidia.com>
 <8264ad13665f510b081764131b1f23ade32c7578.1660639789.git.leonro@nvidia.com>
 <20220818102708.GF566407@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818102708.GF566407@gauss3.secunet.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 12:27:08PM +0200, Steffen Klassert wrote:
> On Tue, Aug 16, 2022 at 11:59:26AM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Traffic received by device with enabled IPsec full offload should be
> > forwarded to the stack only after decryption, packet headers and
> > trailers removed.
> > 
> > Such packets are expected to be seen as normal (non-XFRM) ones, while
> > not-supported packets should be dropped by the HW.
> > 
> > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> > @@ -1125,6 +1148,15 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
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
> >  
> >  	if (sk && sk->sk_policy[XFRM_POLICY_IN])
> >  		return __xfrm_policy_check(sk, ndir, skb, family);
> 
> What happens here if there is a socket policy configured?

No change, we don't support offload of socket policies.

Thanks
