Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE35059BB0B
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 10:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbiHVIHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 04:07:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233629AbiHVIHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 04:07:16 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A572B1B4
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 01:06:46 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6E6C020504;
        Mon, 22 Aug 2022 10:06:44 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id CP7EN5Cd7ott; Mon, 22 Aug 2022 10:06:43 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DE072204D9;
        Mon, 22 Aug 2022 10:06:43 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id CC67B80004A;
        Mon, 22 Aug 2022 10:06:43 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 22 Aug 2022 10:06:43 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 22 Aug
 2022 10:06:43 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0B0DC3182A10; Mon, 22 Aug 2022 10:06:43 +0200 (CEST)
Date:   Mon, 22 Aug 2022 10:06:42 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        <netdev@vger.kernel.org>, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: Re: [PATCH xfrm-next v2 5/6] xfrm: add RX datapath protection for
 IPsec full offload mode
Message-ID: <20220822080642.GG2602992@gauss3.secunet.de>
References: <cover.1660639789.git.leonro@nvidia.com>
 <8264ad13665f510b081764131b1f23ade32c7578.1660639789.git.leonro@nvidia.com>
 <20220818102708.GF566407@gauss3.secunet.de>
 <Yv5AbrT+xHc/xtNY@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Yv5AbrT+xHc/xtNY@unreal>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 04:36:46PM +0300, Leon Romanovsky wrote:
> On Thu, Aug 18, 2022 at 12:27:08PM +0200, Steffen Klassert wrote:
> > On Tue, Aug 16, 2022 at 11:59:26AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Traffic received by device with enabled IPsec full offload should be
> > > forwarded to the stack only after decryption, packet headers and
> > > trailers removed.
> > > 
> > > Such packets are expected to be seen as normal (non-XFRM) ones, while
> > > not-supported packets should be dropped by the HW.
> > > 
> > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > > @@ -1125,6 +1148,15 @@ static inline int __xfrm_policy_check2(struct sock *sk, int dir,
> > >  {
> > >  	struct net *net = dev_net(skb->dev);
> > >  	int ndir = dir | (reverse ? XFRM_POLICY_MASK + 1 : 0);
> > > +	struct xfrm_offload *xo = xfrm_offload(skb);
> > > +	struct xfrm_state *x;
> > > +
> > > +	if (xo) {
> > > +		x = xfrm_input_state(skb);
> > > +		if (x->xso.type == XFRM_DEV_OFFLOAD_FULL)
> > > +			return (xo->flags & CRYPTO_DONE) &&
> > > +			       (xo->status & CRYPTO_SUCCESS);
> > > +	}
> > >  
> > >  	if (sk && sk->sk_policy[XFRM_POLICY_IN])
> > >  		return __xfrm_policy_check(sk, ndir, skb, family);
> > 
> > What happens here if there is a socket policy configured?
> 
> No change, we don't support offload of socket policies.

But the user can confugure it, so it should be enforced
regardless if we had an offload before.
